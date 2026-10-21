#!/usr/bin/env python3
"""Run over authenticated SSH: read-only production release verification.

Arguments: FP-60|FP-61 backend_digest frontend_digest expected_docker_commit.
Output contains safe metadata only; no service environment or database rows.
"""
import json
import pathlib
import subprocess
import sys


def call(*args):
    return subprocess.check_output(args, text=True, timeout=30).strip()


def inspect(*args):
    return json.loads(call("docker", *args))


ticket, backend_digest, frontend_digest, docker_commit = sys.argv[1:]
assert ticket in {"FP-60", "FP-61"}
assert all(d.startswith("sha256:") and len(d) == 71 for d in [backend_digest, frontend_digest])
expected = {"freshprice_backend": backend_digest, "freshprice_frontend": frontend_digest}
result = {"ticket": ticket, "services": [], "containers": []}
names = ["freshprice_postgres", "freshprice_backend", "freshprice_frontend", "freshprice_sugilanon"]
for service in inspect("service", "inspect", *names):
    name = service["Spec"]["Name"]
    image = service["Spec"]["TaskTemplate"]["ContainerSpec"]["Image"]
    update = service.get("UpdateStatus", {}).get("State")
    assert update in {None, "completed"}, "Incomplete/failed update: " + name
    ports = service.get("Endpoint", {}).get("Ports", [])
    if name == "freshprice_postgres":
        assert not ports and not service["Spec"].get("EndpointSpec", {}).get("Ports")
    ids = call("docker", "ps", "-q", "--filter", "label=com.docker.swarm.service.name=" + name).splitlines()
    assert len(ids) == 1, "Unexpected running task count: " + name
    container = inspect("inspect", ids[0])[0]
    assert container["State"]["Running"] and container["State"].get("Health", {}).get("Status") == "healthy"
    runtime = inspect("image", "inspect", container["Image"])[0]
    if name in expected:
        assert any(d.endswith("@" + expected[name]) for d in runtime.get("RepoDigests", [])), "Wrong runtime image: " + name
    result["services"].append({"name": name, "image": image, "update": update, "ports": ports})
    result["containers"].append({"service": name, "id": container["Id"], "image_id": container["Image"],
                                 "repo_digests": runtime.get("RepoDigests", []), "health": "healthy"})
    if name == "freshprice_backend":
        backend = ids[0]
    if name == "freshprice_postgres":
        pg, pg_mounts = ids[0], container["Mounts"]

result["docker_checkout"] = call("git", "-C", "/var/projects/freshprice/fpdocker", "rev-parse", "HEAD")
assert result["docker_checkout"] == docker_commit
for property_name, operation, expected_value in [("guard_active", "is-active", "active"), ("guard_enabled", "is-enabled", "enabled")]:
    result[property_name] = call("systemctl", operation, "freshprice-postgres-guard.service")
    assert result[property_name] == expected_value
result["guard_rules"] = call("nft", "list", "table", "inet", "freshprice_pg_guard")
assert 'iifname "eth0" tcp dport 5432' in result["guard_rules"] and "drop" in result["guard_rules"]


def query(sql):
    return call("docker", "exec", "-e", "PGOPTIONS=-c default_transaction_read_only=on -c statement_timeout=10000",
                pg, "sh", "-eu", "-c", 'exec psql -X -v ON_ERROR_STOP=1 -At -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "$1"', "sh", sql)


migrations = query('SELECT name FROM "SequelizeMeta" ORDER BY name').splitlines()
assert len(migrations) == (37 if ticket == "FP-60" else 38)
assert "20261019000004-budget-accounting.cjs" in migrations
receipt_migration = "20261020000001-expense-mutation-receipts.cjs"
assert (receipt_migration in migrations) == (ticket == "FP-61")
result["migrations"] = {"count": len(migrations), "accounting_applied": True,
                        "receipt_migration_applied": receipt_migration in migrations}
checkpoint = pathlib.Path("/var/backups/freshprice/fp-restore-20261021T011813Z-1873577")
identity = query("SELECT md5(current_database() || ':' || system_identifier::text) FROM pg_control_system()")
assert identity == (checkpoint / "postgres-target.txt").read_text().strip()
old = json.loads((checkpoint / "containers-before.json").read_text())
old_pg = next(c for c in old if any(m.get("Destination") == "/var/lib/postgresql/data" for m in c["Mounts"]))


def data_volume(mounts):
    return next((m.get("Name"), m.get("Source")) for m in mounts if m["Destination"] == "/var/lib/postgresql/data")


assert data_volume(pg_mounts) == data_volume(old_pg["Mounts"])
result["database_identity_matches_checkpoint"] = result["database_volume_preserved"] = True
result["fresh_backend_connection"] = call("docker", "exec", "-w", "/app", backend, "node", "--input-type=commonjs", "-e",
    "const {Sequelize}=require('sequelize');const c=require('./src/config/config.cjs').production;"
    "const d=new Sequelize(c.database,c.username,c.password,{...c,logging:false,pool:{max:1,min:0,acquire:10000}});"
    "(async()=>{try{const [r]=await d.query('SELECT 1 AS ok');if(r[0].ok!==1)throw Error();console.log('PASS')}"
    "finally{await d.close()}})().catch(()=>{console.error('FAIL');process.exitCode=1});")
assert result["fresh_backend_connection"] == "PASS"
print(json.dumps(result, indent=2))
