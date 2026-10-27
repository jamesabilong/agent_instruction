# Recurring Windows Docker socket startup failure — October 27, 2026

## Finding and correction

Docker Desktop **4.48.0.207573** repeatedly aborted while removing its Windows `dockerInference` runtime endpoint, before the Linux engine became available. The secrets-engine endpoint had exhibited the same failure. Directory enumeration showed zero-byte reparse entries; querying the inference entry returned Windows error 1920 even though its ordinary parent directory granted the user full control. Replacing those temporary directories allowed one startup but left the old Desktop implementation in place to recreate the endpoints.

The observations match Docker's [tracked Windows socket-startup defect](https://github.com/docker/desktop-feedback/issues/625). The [issue's maintainer follow-up](https://github.com/docker/desktop-feedback/issues/625) confirms fixes shipped in 4.92; [official release notes](https://docs.docker.com/desktop/release-notes/#4900) also describe a stuck-socket startup correction. Recent Windows System events recorded orderly shutdowns (1074 followed by 6006), with no unexpected-shutdown event in the inspected three-day set. They do not establish precisely how Docker closed its sockets, so an ungraceful shutdown or user action is not asserted as the root cause. The supported corrective action was upgrading the affected Desktop implementation rather than continuing manual directory replacements.

The official updater offered **4.97.0**, and `docker desktop update --quiet` applied an in-place all-users update preserving the WSL 2 backend. The downloaded installer and installed Desktop executable both have valid Docker Inc. Authenticode signatures. The installer log recorded **Installation succeeded** at 13:03:32 Asia/Manila; installed metadata reports **4.97.0.244584**, and both client and server report **29.9.2**. The original updater CLI exited 1 as the installation handed off; that exit is not treated as success evidence. The installer result, installed version and running engine establish completion independently.

No factory reset, uninstall, WSL unregister, prune, manual socket-directory replacement, ACL relaxation, startup cleanup task or shortcut wrapper was used in this follow-up. Previous recoverable runtime backups remain preserved. Automatic-start preference remains false; WSL 2/Linux containers and the existing `overlay2` store remain selected, with `UseContainerdSnapshotter=false`.

## Restart and preservation verification

1. Updated Desktop automatically started with engine 29.9.2.
2. First `docker desktop stop --timeout 60` completed; process inventory confirmed **zero** Desktop/backend processes. `docker desktop start --timeout 60` then reached a working engine at 13:06:02, with a new session ID.
3. Second orderly stop again reached zero Desktop/backend processes. Launching the normal installed `Docker Desktop.exe` once, without CLI start assistance or any manual runtime cleanup, reached a working engine at 13:06:51 with another new session ID.
4. Existing identities match: **6 containers and 39 volumes** before/after, and all **23 original image references** are present and directly inspectable. The new CLI's default image listing omitted intermediate images; the complete `--all` inventory and direct inspection resolved that display difference. No image was missing.
5. `docker run --rm --pull=never --network none postgres:14 postgres --version` passed using the existing image (PostgreSQL 14.20). The disposable container was removed automatically; no application database was started or mounted.
6. Unchanged FreshPrice Compose configuration passed validation. Post-update backend logs contained **zero** new backend-crash/initialization/socket-access failures in the inspected interval. Docker is left running with no running application containers.

The repeated launches verify that manual socket relocation is no longer required in the tested startup paths. At this first checkpoint a full Windows reboot had not yet been tested; the subsequent reboot verification is recorded below. Abrupt-power-loss recovery and every future shutdown condition remain outside the tested scope. Keep ordinary orderly Desktop shutdown available through `docker desktop stop` or Quit Docker Desktop.

## Full Windows reboot verification — passed after follow-up

The user subsequently authorized a full Windows reboot. A one-time limited-user logon task launched the normal Desktop executable after sign-in, without manual socket repair. Windows boot time advanced from **11:42:07 AM to 1:38:34 PM, October 27, Asia/Manila** (`03:42:07.5Z` to `05:38:34.5Z`). Desktop 4.97.0.244584 and Engine 29.9.2 started successfully; all 6 containers, 39 volumes and 23 image references remained present.

The initial checker reported failure because its `docker info` query exceeded a 12-second timeout after engine readiness and inventory checks had already passed. Follow-up at 1:41 PM completed that query in 1,559 ms: `overlay2`, 6 containers, zero running application containers and 23 images. The entire post-boot log scan found zero backend-crash/initialization/socket-access failures. Fresh workload identity comparisons and disposable network-isolated PostgreSQL image execution also passed. Both completed one-time scheduled tasks were removed. The original socket issue did **not** recur in this full-reboot test; no repair, reset or socket relocation was performed after reboot.

The local report is `testing/.local/docker-reboot-verification-20261027/Docker reboot verification.md`; `result.json` records the completed verification and explicitly explains the initial timeout, whose original evidence is preserved in `initial-check-result.json`. Separate info/log/preservation follow-up files retain the corroborating checks. Automatic-start preference remains false; the single test launch was performed by the temporary logon task. Docker is running; no permanent startup task remains.

## Evidence and scope

Local evidence lives under `testing/.local/docker-startup-20261027/`: sanitized baseline, both stop/start records, preservation result and post-update error count. A private settings backup is retained only there; do not publish that backup or raw host logs. The recovery and verification did not change application source, production hosts, shared authentication settings or database fixtures. Documentation publication does not deploy application code.
