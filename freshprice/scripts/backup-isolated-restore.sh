#!/usr/bin/env bash
# Run on the production VPS via an operator-authenticated SSH connection.
# Creates backups; never restores/migrates/restarts a production service.
set -Eeuo pipefail
umask 077
export LC_ALL=C
task_id="fp-restore-$(date -u +%Y%m%dT%H%M%SZ)-$$"
checkpoint="/var/backups/freshprice/$task_id"
test_container="$task_id"
test_volume="$task_id"
mkdir -m 700 -p "$checkpoint"
exec 3>&1
exec >"$checkpoint/private-execution.log" 2>&1
say() { printf '%s\n' "$*" >&3; }
cleanup() {
  local result=$?
  trap - EXIT
  set +e
  if [[ "$(docker inspect -f '{{index .Config.Labels "freshprice.restore-check"}}' "$test_container" 2>/dev/null)" == "$task_id" ]]; then
    docker rm -f "$test_container" || result=1
  fi
  if [[ "$(docker volume inspect -f '{{index .Labels "freshprice.restore-check"}}' "$test_volume" 2>/dev/null)" == "$task_id" ]]; then
    docker volume rm "$test_volume" || result=1
  fi
  if [[ $result == 0 ]]; then
    say "PASS: backup and isolated database restore comparison; temporary resources removed."
  else
    say "FAIL: check stopped; restricted diagnostics retained in $checkpoint/private-execution.log"
  fi
  say "Protected checkpoint: $checkpoint"
  exit "$result"
}
trap cleanup EXIT
say "Starting protected backup and isolated restore check: $task_id"
[[ $EUID == 0 ]]
for command in docker timeout sha256sum diff sed tar; do command -v "$command"; done
cd /var/projects/freshprice/fpdocker
[[ -f .env ]]
one_container() {
  local value
  value="$(docker ps -q --filter "label=com.docker.swarm.service.name=$1")"
  [[ -n "$value" && "$value" != *$'\n'* ]]
  printf '%s' "$value"
}
pg_container="$(one_container freshprice_postgres)"
backend_container="$(one_container freshprice_backend)"
frontend_container="$(one_container freshprice_frontend)"
for container in "$pg_container" "$backend_container" "$frontend_container"; do
  [[ "$(docker inspect -f '{{.State.Health.Status}}' "$container")" == healthy ]]
done
pg_image="$(docker inspect -f '{{.Image}}' "$pg_container")"
# Use exactly the cached PostgreSQL image already running; no pulls.
docker image inspect "$pg_image" >"$checkpoint/postgres-image.json"
docker service inspect freshprice_postgres freshprice_backend freshprice_frontend >"$checkpoint/services-before.json"
docker inspect "$pg_container" "$backend_container" "$frontend_container" >"$checkpoint/containers-before.json"
for container in "$pg_container" "$backend_container" "$frontend_container"; do
  docker inspect -f '{{.Id}} {{.Image}}' "$container" >>"$checkpoint/image-identities.txt"
done
pg_sql() {
  timeout 60 docker exec -e PGOPTIONS='-c default_transaction_read_only=on -c statement_timeout=30000 -c lock_timeout=5000' \
    "$pg_container" sh -eu -c 'exec psql -X -v ON_ERROR_STOP=1 -At -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "$1"' sh "$1"
}
pg_version="$(pg_sql 'SHOW server_version_num')"
[[ "$pg_version" =~ ^[0-9]+$ && "$pg_version" -ge 140000 && "$pg_version" -lt 150000 ]]
# Confirm this is the database the running backend actually uses. Import only
# connection configuration, never models, server startup or recurring workers.
pg_sql "SELECT md5(current_database() || ':' || system_identifier::text) FROM pg_control_system()" \
  >"$checkpoint/postgres-target.txt"
timeout 60 docker exec -i -w /app "$backend_container" node --input-type=commonjs \
  >"$checkpoint/backend-target.txt" <<'NODE'
const { Sequelize } = require('sequelize');
const config = require('./src/config/config.cjs').production;
const connection = new Sequelize(config.database, config.username, config.password, {
  ...config, logging: false, pool: { max: 1, min: 0, acquire: 15000 },
});
(async () => {
  try {
    const [rows] = await connection.transaction({ readOnly: true }, async transaction =>
      connection.query("SELECT md5(current_database() || ':' || system_identifier::text) AS identity FROM pg_control_system()", { transaction }));
    process.stdout.write(rows[0].identity + '\n');
  } finally { await connection.close(); }
})().catch(() => { process.exitCode = 1; });
NODE
diff -q "$checkpoint/postgres-target.txt" "$checkpoint/backend-target.txt"
database_bytes="$(pg_sql 'SELECT pg_database_size(current_database())')"
[[ "$database_bytes" =~ ^[0-9]+$ && "$database_bytes" -le 1073741824 ]]
available_kb="$(df -Pk "$checkpoint" | awk 'END {print $4}')"
memory_kb="$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)"
[[ "$available_kb" -ge 4194304 && "$memory_kb" -ge 786432 ]]
upload_kb="$(docker exec "$backend_container" du -sk /app/uploads | awk '{print $1}')"
[[ "$upload_kb" =~ ^[0-9]+$ ]]
# Allow for dump, two plain SQL comparisons, restore volume, uploads and 2 GiB spare.
[[ $((available_kb * 1024)) -gt $((database_bytes * 6 + upload_kb * 2048 + 2147483648)) ]]
say "Resource guards passed; PostgreSQL 14; database size ${database_bytes} bytes."
cp -p .env "$checkpoint/runtime.env"
cp -p docker-compose.prod.yml "$checkpoint/docker-compose.prod.yml"
git rev-parse HEAD >"$checkpoint/fpdocker-head.txt"
if [[ -d /etc/caddy ]]; then
  tar -C /etc -czf "$checkpoint/caddy-config.tar.gz" caddy
fi
timeout 300 docker exec -e PGOPTIONS='-c lock_timeout=5000' "$pg_container" sh -eu -c \
  'exec pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc' >"$checkpoint/database.dump.partial"
test -s "$checkpoint/database.dump.partial"
mv "$checkpoint/database.dump.partial" "$checkpoint/database.dump"
timeout 300 docker cp "$backend_container:/app/uploads" "$checkpoint/uploads"
tar -C "$checkpoint" -czf "$checkpoint/uploads.tar.gz" uploads
tar -tzf "$checkpoint/uploads.tar.gz" >"$checkpoint/uploads-files.txt"
# Retain extracted uploads too, so their integrity can be checked without production access.
find "$checkpoint/uploads" -type f -exec sha256sum {} + >"$checkpoint/uploads-sha256.txt"
say 'Database dump, runtime configuration and live uploads copied; validating isolated restore.'
docker volume create --label "freshprice.restore-check=$task_id" "$test_volume"
docker run -d --name "$test_container" --label "freshprice.restore-check=$task_id" \
  --network none --cpus 0.5 --memory 384m --memory-swap 384m --pids-limit 128 \
  --mount "type=volume,source=$test_volume,target=/var/lib/postgresql/data" \
  -e POSTGRES_HOST_AUTH_METHOD=trust -e POSTGRES_USER=restorecheck -e POSTGRES_DB=restorecheck \
  "$pg_image" postgres -c listen_addresses= -c shared_buffers=32MB -c max_connections=10
[[ "$(docker inspect -f '{{.HostConfig.NetworkMode}}' "$test_container")" == none ]]
[[ "$(docker inspect -f '{{len .HostConfig.PortBindings}}' "$test_container")" == 0 ]]
for attempt in $(seq 1 45); do
  if docker logs "$test_container" 2>&1 | grep -q 'PostgreSQL init process complete' && \
    docker exec "$test_container" pg_isready -U restorecheck -d restorecheck; then break; fi
  sleep 1
done
docker exec "$test_container" pg_isready -U restorecheck -d restorecheck
docker cp "$checkpoint/database.dump" "$test_container:/tmp/database.dump"
docker exec "$test_container" pg_restore --list /tmp/database.dump >"$checkpoint/archive-inventory.txt"
timeout 300 docker exec "$test_container" pg_restore --exit-on-error --no-owner --no-privileges \
  -U restorecheck -d restorecheck /tmp/database.dump
docker exec "$test_container" psql -X -v ON_ERROR_STOP=1 -U restorecheck -d restorecheck -At \
  -c 'SELECT count(*) FROM "SequelizeMeta"' >"$checkpoint/restored-migration-count.txt"
timeout 300 docker exec "$test_container" pg_dump -U restorecheck -d restorecheck -Fc \
  >"$checkpoint/restored-roundtrip.dump"
# Compare the complete archive SQL, including rows, constraints and sequence values.
# pg_dump versions may emit timestamps and randomized psql restriction tokens.
normalize_sql() {
  sed -E '/^\\(un)?restrict /d; /^-- (Started on|Completed on|Dumped from database version|Dumped by pg_dump version):?/d; /^-- .*Owner: /s/Owner: .*/Owner: <normalized>/'
}
docker exec "$test_container" pg_restore --no-owner --no-privileges -f - /tmp/database.dump \
  | normalize_sql >"$checkpoint/original-normalized.sql"
docker cp "$checkpoint/restored-roundtrip.dump" "$test_container:/tmp/roundtrip.dump"
docker exec "$test_container" pg_restore --no-owner --no-privileges -f - /tmp/roundtrip.dump \
  | normalize_sql >"$checkpoint/restored-normalized.sql"
python3 - "$checkpoint" <<'PY'
import json, pathlib, re, sys
p=pathlib.Path(sys.argv[1])
literal=r"'(?:[^']|'')*'::character varying"
pattern=re.compile(r"\(\(ARRAY\[("+literal+r"(?:, "+literal+r")*)\]\)::text\[\]\)")
def canonicalize(text):
    lines=text.splitlines();output=[];i=0;rows_total=0;blocks=0;rewrites=0
    while i<len(lines):
        line=lines[i]
        if line.startswith('COPY ') and line.endswith(' FROM stdin;'):
            output.append(line);rows=[];i+=1
            while i<len(lines) and lines[i]!='\\.':rows.append(lines[i]);i+=1
            if i==len(lines):raise ValueError('Unterminated COPY block')
            output.extend(sorted(rows));output.append('\\.');blocks+=1;rows_total+=len(rows)
        else:
            if (line.lstrip().startswith('CONSTRAINT ') and ' CHECK ' in line) or (line.startswith(('CREATE INDEX ', 'CREATE UNIQUE INDEX ')) and ' WHERE ' in line):
                line,n=pattern.subn(lambda m:'(ARRAY['+', '.join('('+x+')::text' for x in re.findall(literal,m[1]))+'])',line)
                rewrites+=n
            output.append(line)
        i+=1
    return output,{'copyBlocks':blocks,'rows':rows_total,'castRewrites':rewrites}
a,aa=canonicalize((p/'original-normalized.sql').read_text())
b,bb=canonicalize((p/'restored-normalized.sql').read_text())
report={'equal':a==b,'original':aa,'restored':bb}
(p/'comparison-result.json').write_text(json.dumps(report,indent=2)+'\n')
if a!=b:raise SystemExit('Restored schema/data/sequence comparison failed')
PY
sha256sum "$checkpoint/database.dump" "$checkpoint/restored-roundtrip.dump" \
  "$checkpoint/uploads.tar.gz" "$checkpoint/runtime.env" >"$checkpoint/SHA256SUMS"
sha256sum -c "$checkpoint/SHA256SUMS"
for service in freshprice_postgres freshprice_backend freshprice_frontend; do
  docker service inspect -f '{{.ID}} {{.Version.Index}} {{.Spec.TaskTemplate.ContainerSpec.Image}}' "$service"
done >"$checkpoint/service-identities-after.txt"
# Compare service identity/spec version with captured JSON without displaying secrets.
docker service inspect freshprice_postgres freshprice_backend freshprice_frontend >"$checkpoint/services-after.json"
diff -q "$checkpoint/services-before.json" "$checkpoint/services-after.json"
[[ "$(one_container freshprice_postgres)" == "$pg_container" ]]
[[ "$(one_container freshprice_backend)" == "$backend_container" ]]
[[ "$(one_container freshprice_frontend)" == "$frontend_container" ]]
for container in "$pg_container" "$backend_container" "$frontend_container"; do
  [[ "$(docker inspect -f '{{.State.Health.Status}}' "$container")" == healthy ]]
done
chmod -R go-rwx "$checkpoint"
say "Restored migration count: $(cat "$checkpoint/restored-migration-count.txt")"
say 'Full normalized database roundtrip matches; backup checksums pass; production service identities and health unchanged.'
say 'Scope: live database snapshot; uploads copied while app remained online (not an atomic database/filesystem snapshot).'
say 'Backup remains on this VPS; off-host disaster recovery and candidate migrations are separate checks.'
