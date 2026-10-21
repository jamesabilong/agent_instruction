# PostgreSQL public exposure remediation — 2026-10-21

Current status: Docker #25 is merged/deployed; PostgreSQL no longer publishes a host port. The independent guard remains enabled/active and private connectivity/external denial are verified in [the final release record](fp61-deployment-2026-10-21.md). Publication-pending/device-gate notes below are retained from the original execution; device testing was later waived.

Status: **current public-interface exposure mitigated and verified**. The user explicitly requested checking and securing port 5432. Production firewall configuration changed; no database/application service restart, migration, deployment or repository publication occurred.

Publication follow-up: the user subsequently authorized review/commit/push. Security commit `5b42640` is published on `fix/postgres-private-networking`; [fpdocker PR #25](https://github.com/jamesabilong/fpdocker/pull/25) is OPEN/CLEAN/MERGEABLE. Direct master push was rejected by GitHub's PR requirement; merge #25 before app releases. Three render cases now also assert no production PostgreSQL published port. No app deployment or PR merge occurred. This supersedes the initial uncommitted/unpublished statements below.

## Findings and action

- Before the change, an external TCP connection to `107.174.250.249:5432` succeeded. Swarm publishes `freshprice_postgres` through ingress on all addresses. UFW was inactive; Docker's forwarding/NAT rules accepted 5432. A loopback address in Compose does not constrain Swarm publishing.
- FreshPrice and Sugilanon use `postgres:5432` on the private Swarm network. The connection snapshot showed only private-overlay database clients, not external clients. This snapshot does not establish whether dormant external clients exist. Direct remote PostgreSQL access is now intentionally blocked; use operator SSH access for administration.
- Installed a dedicated `inet freshprice_pg_guard` nftables table: drop TCP destination port 5432 arriving on public interface `eth0`, at prerouting priority `-310`, before Docker destination NAT. Internal overlay and loopback traffic do not match. Both IP families are covered by the rule; the host currently has only link-local IPv6 on eth0, and no external IPv6 probe was performed. No Docker-owned rule/table was changed or global ruleset flushed.
- Installed `/etc/freshprice/postgres-public-guard.nft` and enabled `/etc/systemd/system/freshprice-postgres-guard.service`. Startup ordering precedes `docker.service`; reload atomically replaces only the guard's own table. Unit syntax, nft syntax, enablement, active state and reload idempotence pass. No VPS reboot or Docker restart was performed to test boot recovery. If the public interface changes, update and verify the guard before exposing that interface.
- Removed the PostgreSQL `ports` declaration from the local `fpdocker/docker-compose.prod.yml`. This source change is **not committed, pushed or deployed**. The running Swarm service still advertises 5432, behind the verified firewall guard. Keep the guard active while publishing/releasing the Compose correction through the normal reviewed Docker process; do not restart the production database just to apply this local change.

## Verification

- Before: external SSH 22, HTTPS 443 and PostgreSQL 5432 reachable. After: SSH/HTTPS reachable; two separate PostgreSQL connection attempts time out after five seconds each. Guard counter recorded 11 dropped packets following the probes.
- A **new** backend Sequelize connection over the private network successfully runs `SELECT 1` after the restriction; this is not just an existing pooled session.
- All four production Swarm service definitions, running container IDs and image identities remain unchanged. All five running containers (including the portfolio) remain healthy.
- Origin FreshPrice database/frontend and Sugilanon health checks pass. Public HTTPS FreshPrice DB health returns `{"status":"ok","database":"ready"}`, `/healthz` returns `{"status":"ok"}`, and PhilWatch `/health` returns `ok`, all HTTP 200. Initial Python urllib probes returned 403; subsequent curl checks from the operator environment and VPS succeed. The initial results are retained rather than represented as successful checks.
- Existing three maintenance/production-stack render checks pass; Bash installer/inspection syntax and repository whitespace checks pass. No app source, FP-63, credentials or database contents changed.

Safe evidence: `../evidence/postgres-security-2026-10-21.json`. Root-only VPS snapshots: `/var/backups/freshprice/pg-security-20261021T035749Z-1945614` and `/var/backups/freshprice/pg-guard-install-20261021T035931Z-1946354`. Snapshots may contain runtime secrets and must stay protected.

## Operations and recovery

Versioned files: `fpdocker/firewall/postgres-public-guard.nft`, `fpdocker/firewall/freshprice-postgres-guard.service`, `fpdocker/scripts/install-postgres-guard.sh`. The installer is for a fresh install and refuses existing guard files/table. It does not deploy the app.

Inspect with `sudo nft list table inet freshprice_pg_guard` and `sudo systemctl status freshprice-postgres-guard.service`. After a deliberate, reviewed rule edit, run `sudo nft --check --file /etc/freshprice/postgres-public-guard.nft`, then `sudo systemctl reload freshprice-postgres-guard.service` and repeat external/internal verification. Do not flush the entire nftables ruleset or enable a blanket firewall policy as part of this change.

Stopping the unit deliberately leaves the guard installed. Emergency removal requires an explicit operator decision: disable the unit, then delete **only** `inet freshprice_pg_guard`. This reopens the published database port and is not routine rollback. Prefer correcting the specific rule while retaining protection. Preserve the protected pre-change rules and deployment snapshots.

The PostgreSQL release gate is cleared for the inspected topology. Actual-device/installed-version upgrade acceptance is still required before full sprint merge readiness.

References: [Docker firewall integration](https://docs.docker.com/engine/network/packet-filtering-firewalls/) explains why UFW alone may not constrain published Docker ports; [nftables hook priorities](https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks) documents prerouting ordering ahead of destination NAT.
