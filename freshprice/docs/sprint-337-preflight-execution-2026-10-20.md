# Sprint 337 preflight execution — 2026-10-20

Status: **verification in progress; do not tag ready yet**. The user will handle merging and deployment. No PR merge, production migration, application deployment, service restart or firewall change is authorized by this check.

## Confirmed environment and current production inventory

The user confirmed one VPS at `root@107.174.250.249`, with the production app and PostgreSQL together, serving `https://freshprice.philwatch.com`. No separate staging environment exists. Operator access is password-based; passwords are entered directly in the terminal, never copied into reports. See `../../AGENTS.md` and `deployment.md` for the updated instructions.

The operator executed the reviewed read-only inventory at **2026-10-20 15:46:00–15:46:03 UTC / 23:46 Asia/Manila**. Evidence: `../../../staging-preflight/production/inventory-user-session.log`.

- fpdocker is clean at `4ea0c5385298967a6e9cb0f263b40e7f04b25a25`.
- Backend, frontend and PostgreSQL are healthy, each with one desired/running replica. Backend/frontend updates are completed; current tasks have run about 34 hours.
- Backend/frontend service references are mutable `latest`; actual running image IDs/registry digests still need the supplemental inventory for recovery identity.
- PostgreSQL is version 14. The database metadata read explicitly used a read-only transaction. All 33 pre-sprint migration names match the expected baseline; none of the five sprint migrations is applied, as expected before release.
- Frontend maintenance is false; backend `NODE_ENV=production`. Optional image-tag/recurrence overrides were not present in the allowlisted `.env` output. Defaults still require review against the deployment render.
- Approximately 11.5 GiB disk space is available. Service identities/spec versions were unchanged before and after inventory.
- The checked backup directory contains a 44,857-byte July 1 custom dump. This is not a current release checkpoint or evidence of a successful restore. Other backup locations were not established.
- The PowerShell stream appended a final carriage return after the inventory completed, producing a trailing Bash error. All inventory sections finished and reported zero failed checks; future pipelines strip carriage returns before Bash. The shell transport exit must not be misreported as clean.

## Checks completed in this session

| Check | Actual evidence | Scope/limit |
| --- | --- | --- |
| Public API and nginx health | Pass at 15:34 UTC | Current deployed public path only; not candidate feature acceptance |
| Worker/manifest headers | Pass: expected MIME/cache/CDN behavior | Does not identify deployed app commit |
| Production configuration regression | 3/3 pass, zero skips | Synthetic config rendering only |
| Exact FP-61 frontend production build | Pass | Exported `0d100ab525fb3bcbfde2e42b97e56b127c10d30b`; installed dependency lock matches primary checkout |
| New focused PWA/storage checks | 11/11 desktop + 11/11 mobile emulation pass | Eleven overlapping scenarios; no actual phone, authenticated feature UI, live API replay or old-to-new app-version acceptance |
| New pure accounting checks | Six on each FP-60/61 candidate pass | 12 overlapping executions; not DB/service acceptance |
| Original full ticket acceptance suites | Not rerun | Current local workspace contains restored FP-59 coverage only; original FP-60/61 local-only suites are absent |
| Local synthetic migration/restore rehearsal | Blocked before DB provisioning | Docker Desktop startup/engine access failed; no native PostgreSQL fallback; zero DB assertions executed locally |

The PWA checks exercise real IndexedDB and browser restart, worker lifecycle retention, expiry versus logout, account switching, no API caching and injected storage failure. See `../../../staging-preflight/pwa/README.md` and its JSON/log evidence. Their explicit limitations remain part of the readiness assessment.

## Confirmed issue requiring disposition

PostgreSQL is published as `*:5432->5432/tcp`; an external single TCP connection to `107.174.250.249:5432` succeeds. This confirms external reachability, not unauthorized database access. The Compose loopback address is ignored by Swarm. Actual firewall rules and legitimate external consumers must be considered before a reviewed mitigation; no firewall change has been made. See `../memory-bank/bugs.md` and `../../../staging-preflight/production/postgres-public-port.json`.

## Remaining execution

- [ ] Capture actual running image IDs/digests and supplemental runtime/firewall/resource evidence.
- [ ] Create a protected current database/config/uploads recovery checkpoint and validate the custom dump.
- [ ] Restore into a bounded disposable PostgreSQL container with no network access/public ports; never restore into production.
- [ ] Apply the exact FP-59/60/61 migrations only on restored copies, verifying all old data/sequence preservation and rollback guards.
- [ ] Execute the prepared FP-60/61 service checks on separate isolated restored copies and verify fixture cleanup.
- [ ] Dump and re-restore the post-migration copy to verify recovery of schema, financial history and durable receipts.
- [ ] Record actual results and disposition of remaining installed-device/proxy/upgrade and external database-port concerns before any ready label.

The protected copy rehearsal is being prepared because local Docker is unavailable and there is no staging host. It will use cached images, no application startup, no outbound integration access, strict container ownership/cleanup and resource guards. Prepared scripts are not passing execution evidence.
