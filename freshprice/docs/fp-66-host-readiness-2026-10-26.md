# FP-66 authenticated host and restored-backup readiness — October 26, 2026

## Result

**Release blocker: installed Caddy 2.6.2 cannot parse the candidate proxy configuration.** The installed parser rejects both the global `trusted_proxies` option and, in a separate minimal probe, `trusted_proxies_strict`. [Strict right-to-left parsing is documented since Caddy v2.8](https://caddyserver.com/docs/caddyfile/options#trusted-proxies-strict). A separately authorized Caddy upgrade/maintenance plan and installed-version validation are required before FP-66 strict-mode rollout. Do not remove strict parsing or broaden trusted peers to work around this gate.

The production baseline and the approved isolated restored-backup migration/recovery checks pass. No app merge, deployment, production migration/configuration change, upgrade/restart, new production backup or live exemption was performed. Four app drafts remain the published candidates in the [publication record](fp-66-publication-2026-10-26.md).

## Authenticated read-only production baseline

Used the user's explicitly shared password-authenticated SSH multiplex session; the agent did not handle the password. Inventory emits allowlisted metadata only, never environment values, database rows, raw active configuration or logs.

- All four Swarm services have exactly one running healthy task. Backend actual digest `sha256:b4202249c438c0c74e773dbcf03bf3bd29e1af3077946a6495f37ae2aafe9f44` and frontend `sha256:9104acc80d49bbfe5777b7c52a46e60437f59eef44339f67e709bb491ceae1e8` match the recorded FP-63 release. Actual image IDs/digests for all services are retained in [sanitized evidence](../evidence/fp-66-readiness-2026-10-26.json). The Docker checkout remains `5f364defe7202c16e839c58bfc3f35b8ee8221ef`.
- Live migration inventory remains **41**, including shopping; FP-66 migration and both FP-66 tables are absent. Database identity and data volume match the protected historical checkpoint. A new independent backend connection completes a read-only `SELECT 1`.
- PostgreSQL has no published service port; the guard is enabled/active and its public-interface TCP 5432 drop rule remains present.
- FP-66 service settings/keys are unset and exemptions are not enabled. The old PhilWatch environment still inherits database/auth credential names; no values were exposed. The candidate's explicit service environment must replace that inheritance in a separately authorized rollout. Unset FP-66 variables do not mean the old backend implements the new socket-identity code.
- Caddy is active, package `2.6.2-6ubuntu0.24.04.3`, running as `caddy`. Active JSON equals the adapted `/etc/caddy/Caddyfile`; the admin listener is actually bound only to `127.0.0.1:2019`. File is root-owned mode 0644, directory 0755; no FP-66 key is installed. Future credential files/environment need their separately reviewed protection before activation.
- Exact active routes: FreshPrice → `127.0.0.1:8081`; PhilWatch → `127.0.0.1:3001`. Neither route currently installs FP-66 identity assertions/internal-key stripping, and the active server has no trusted-proxy/strict/client-IP-header policy. Existing TLS/maintenance configuration was read, not rewritten; preservation under a future upgrade/configuration change remains a rollout check.

After the local rehearsal, repeated the same remote inventory. Services/images/ports/health, database inventory/identity/volume, guard, Caddy file hash/active configuration, settings and protected backup metadata are unchanged. Live production still has 41 migrations, no FP-66 tables and no enabled exemption.

## Approved existing-backup rehearsal

Latest existing protected checkpoint is `/var/backups/freshprice/fp-restore-20261022T074534Z-2658688`; its directory is mode 0700 and dump mode 0600. Dump is 226,036 bytes, modified October 22 at 07:45:38 UTC (15:45 Manila), SHA-256 `148b80951c00a087655057a5a55e2529c770beb966db9020b2fbd633e6e848fc`. It is an October 22 snapshot, **not a fresh October 26 production backup**.

Automatic approval review initially rejected local export because the general readiness request did not explicitly authorize sensitive-data egress. The user then explicitly approved that exact backup's protected local copy and isolated rehearsal. Only that dump was copied into an owner-only local directory, mode 0600, and its checksum matched the remote inventory. No environment, service credential, upload payload or new production dump was exported.

Execution uses disposable local PostgreSQL 14 and a cached Node runtime. Both run with network none, no published ports and bounded resources. The Node process receives only the exact committed migration, standalone harness, read-only candidate dependencies and scratch database Unix socket; no production `.env`, app startup, scheduler or external integration is used. Exact backend is `68945dd319bbd583cd6ada52a027ae35970437e7`; migration hash `43d40c7f48527ed60020c6f0b0724163973a4bad71a9c7a7487908d07e057384`. Runtime dependency versions are Sequelize 6.37.8 and pg 8.23.0.

Passing results:

- Initial backup restore and normalized full schema/COPY row-multiset/sequence comparison: **46 COPY blocks, 581 rows**. Owners/ACLs and known PostgreSQL dump/deparser formatting are normalized, not certified as global-role recovery.
- Exact additive migration **41→42** preserves every original row and original sequence. Empty down/up restores the original column/migration inventory and rows/sequences, then reapplies cleanly.
- One-rule-per-user and user-FK constraints pass. Three populated rollback checks refuse destructive down, including audit-only history. A synthetic user deletion cascades the current rule and retains its audit identifier/history. Synthetic rows exist only on the local restored copy; no actual account, password, rule or history is edited in production.
- A new post-migration dump and independent database restore match full normalized schema/data/sequences: **48 COPY blocks, 583 rows**, including explicit synthetic audit history and the migration metadata row. All original restored rows/sequences remain unchanged.
- Label-checked temporary containers and volumes are removed. Local raw dump copies are removed after verification; only sanitized reports and test harnesses remain outside Git. The protected source backup on the VPS is unchanged.

This closes the FP-66 exact migration/recovery rehearsal **for the existing October 22 snapshot**. It does not certify a fresh release-time backup, off-host full-server/global-role/config recovery, atomic live upload/database snapshots, restored-data browser/mobile/PWA acceptance, physical devices or two actual public clients. Earlier synthetic API/browser/proxy evidence retains its stated scope.

## Remaining release gates

1. Explicit authorization and a reviewed maintenance/recovery plan for upgrading installed Caddy to a supported version with strict proxy parsing; validate the exact candidate against that installed version while preserving both sites' TLS/maintenance behavior. No upgrade/restart is authorized by this readiness work.
2. Fresh protected release-time backup/recovery checkpoint, or explicit release-owner acceptance of the existing snapshot's age and retained recovery limits. No new production backup was authorized or created here.
3. Separate app merge/deployment authorization, protected distinct edge/content credentials, coordinated targeted Swarm/on-host settings and serialized Docker/backend/schema/PhilWatch/admin-UI rollout. Keep exemptions disabled.
4. With FP-66 actually deployed under separate authorization, verify two independent real public clients and direct-origin/forged assertions through both actual sites before exemption activation, then exact intended runtime images/migration 42/database/health/guard. No live exemption is a deployment test.

Keep Jira In Progress and all four PRs draft/unmerged. Full safe metadata is in the [readiness evidence](../evidence/fp-66-readiness-2026-10-26.json); private data, SSH sockets and executable rehearsal payloads are not published.
