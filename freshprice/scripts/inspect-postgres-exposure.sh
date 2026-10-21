#!/usr/bin/env bash
# Read-only production inventory; full snapshots stay root-only on the VPS.
set -Eeuo pipefail
umask 077
[[ $EUID == 0 ]]
audit="/var/backups/freshprice/pg-security-$(date -u +%Y%m%dT%H%M%SZ)-$$"
mkdir -m 700 -p "$audit"
docker service inspect freshprice_postgres freshprice_backend freshprice_frontend >"$audit/services.json"
docker ps -q | xargs -r docker inspect >"$audit/containers.json"
ip -j address >"$audit/addresses.json"
ip route show >"$audit/routes.txt"
for family in iptables ip6tables; do
  if command -v "${family}-save" >/dev/null; then
    "${family}-save" >"$audit/$family.txt"
  fi
done
if command -v nft >/dev/null; then nft list ruleset >"$audit/nft.txt"; fi
printf 'Protected inventory: %s\n' "$audit"
docker stack services freshprice
python3 - "$audit" <<'PY'
import json,sys,urllib.parse,pathlib
p=pathlib.Path(sys.argv[1])
for s in json.loads((p/'services.json').read_text()):
 print('SERVICE',s['Spec']['Name'],'ports=',json.dumps(s.get('Endpoint',{}).get('Ports',[])),
       'networks=',json.dumps(s['Spec']['TaskTemplate'].get('Networks',[])))
for c in json.loads((p/'containers.json').read_text()):
 print('CONTAINER',c['Name'],'id=',c['Id'][:12],'health=',c['State'].get('Health',{}).get('Status'),
       'networks=',json.dumps({k:v.get('IPAddress') for k,v in c['NetworkSettings']['Networks'].items()}))
 env=dict(x.split('=',1) for x in c['Config'].get('Env',[]) if '=' in x)
 for key in ['POSTGRES_HOST','POSTGRES_PORT','DB_HOST','DB_PORT']:
  if key in env: print('DB_TARGET',c['Name'],key,env[key])
 for key in ['DATABASE_URL','DB_POSTGRESDB_HOST','DB_POSTGRESDB_PORT']:
  if key not in env or not env[key]: continue
  if key=='DATABASE_URL':
   try:
    u=urllib.parse.urlsplit(env[key]); print('DB_URL_TARGET',c['Name'],u.hostname,u.port)
   except ValueError: print('DB_URL_TARGET',c['Name'],'unparseable')
  else: print('DB_TARGET',c['Name'],key,env[key])
for name in ['routes.txt','iptables.txt','ip6tables.txt']:
 if not (p/name).exists(): continue
 print('FIREWALL_OR_ROUTE',name)
 print((p/name).read_text())
PY
pg_container="$(docker ps -q --filter label=com.docker.swarm.service.name=freshprice_postgres)"
[[ -n "$pg_container" && "$pg_container" != *$'\n'* ]]
docker exec -e PGOPTIONS='-c default_transaction_read_only=on -c statement_timeout=10000' "$pg_container" \
 sh -eu -c 'exec psql -X -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT coalesce(client_addr::text, '\''local-socket'\'') AS client, backend_type, state, count(*) FROM pg_stat_activity GROUP BY 1,2,3 ORDER BY 1,2,3"'
if command -v ufw >/dev/null; then ufw status verbose; fi
systemctl is-enabled ufw netfilter-persistent nftables firewalld 2>/dev/null || true
ss -lnt '( sport = :5432 )'
