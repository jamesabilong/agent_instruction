# Sprint 337 preflight execution — 2026-10-20

FP-59/60/61 and Docker security changes are released. Final live read-only verification passes; device/installed-upgrade testing was explicitly waived, not passed. See [the authoritative final release record](fp61-deployment-2026-10-21.md) and [current open work](../memory-bank/todo.md). The shared client-IP/rate-limit issue is separately tracked by FP-66 and is not resolved by the release.

This dated record is retained for audit/recovery context. Older “pending”, “unmerged”, “not ready” and superseding interim statements below describe their original checkpoints. Do not repeat completed merges or deployments from this history.

<details>
<summary>Historical preflight execution record</summary>

Status: **verification in progress; do not tag ready yet**. The user will handle merging and deployment. No PR merge, production migration, application deployment, service restart or firewall change is authorized by this check.

October 21 follow-up: the user authorized protected backup and isolated restore execution. [Backup/migration recovery evidence](backup-restore-check-2026-10-21.md) now confirms a current protected checkpoint, full base restore comparison, uploads archive integrity, exact five-migration row/sequence preservation, five rollback guards and post-migration recovery. This supersedes the backup/migration-pending items below; broader service/device/firewall gates remain open. No production migration or deployment occurred.

October 21 service follow-up: [50/50 declared direct-service cases pass](service-acceptance-2026-10-21.md) across exact FP-59/60/61 candidates on independent fresh restored copies. Fixture cleanup/baseline hashes, runtime dependency identity, production health/identity and temporary cleanup verified. The snapshot has no scheduled budgets; shared-budget scenarios explicitly use synthetic actors/history. HTTP/auth middleware, proxy/browser/installed-device acceptance and PostgreSQL exposure disposition remain open.

October 21 HTTP/browser follow-up: [34 HTTP/auth groups, 21 browser assertion groups and three backend-down nginx checks pass](http-browser-acceptance-2026-10-21.md) on the exact three candidate pairs. Offline reload/recovery/reauthentication/retry, secure cookies, scope/validation/CORS and viewer/mobile controls verified. Baseline preservation, production health/identity and complete cleanup pass. This clears the declared isolated HTTP/browser scope; actual-device/installed-version upgrades, live edge checks and PostgreSQL exposure disposition remain separate.

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
- [x] Create a protected current database/config/uploads recovery checkpoint and validate the custom dump (October 21; live uploads are not atomic with the DB snapshot).
- [x] Restore into a bounded disposable PostgreSQL container with no network access/public ports; never restore into production.
- [x] Apply the exact FP-59/60/61 migrations only on restored copies, verifying all old data/sequence preservation and rollback guards.
- [x] Execute FP-59/60/61 direct-service acceptance on separate isolated restored copies and verify fixture cleanup (October 21; 9/18/23 cases, zero failures; HTTP/browser/device scope remains separate).
- [x] Dump and re-restore the post-migration copy to verify recovery of schema and explicitly synthetic financial history/durable receipts (October 21).
- [ ] Record actual results and disposition of remaining installed-device/proxy/upgrade and external database-port concerns before any ready label.

The protected copy rehearsal is being prepared because local Docker is unavailable and there is no staging host. It will use cached images, no application startup, no outbound integration access, strict container ownership/cleanup and resource guards. Prepared scripts are not passing execution evidence.

</details>
