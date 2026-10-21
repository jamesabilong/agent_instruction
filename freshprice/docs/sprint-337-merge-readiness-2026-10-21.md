# Sprint 337 merge readiness — 2026-10-21

FP-59/60/61 and Docker security changes are released. Final live read-only verification passes; device/installed-upgrade testing was explicitly waived, not passed. See [the authoritative final release record](fp61-deployment-2026-10-21.md) and [current open work](../memory-bank/todo.md). The shared client-IP/rate-limit issue is separately tracked by FP-66 and is not resolved by the release.

This dated record is retained for audit/recovery context. Older “pending”, “unmerged”, “not ready” and superseding interim statements below describe their original checkpoints. Do not repeat completed merges or deployments from this history.

<details>
<summary>Historical pre-merge readiness checkpoints</summary>

Final release status: FP-59/60/61 and Docker security changes are merged/released; [final FP-61 read-only deployment verification passes](fp61-deployment-2026-10-21.md). Expected running images, healthy services, 38 migrations/receipt schema, preserved DB identity/volume, private connectivity, PostgreSQL protection and public health/cache headers verified. This supersedes older pending merge/deploy status below. Device/installed-upgrade testing remains waived, not passed; authenticated live feature mutations were not rerun. No Jira status update performed.

Deployment update: the user merged Docker #25 and both FP-59 PRs. [FP-59 read-only deployment verification passes](fp59-deployment-2026-10-21.md): expected actual runtime digests, healthy services, 36 migrations, preserved DB identity/volume, private connectivity, removed PostgreSQL publication, external denial and public health/cache headers. Older unmerged/unpublished Docker/FP-59 notes below are superseded. Continue FP-60 after retarget/final-diff review; no live authenticated feature mutation or device test was performed.

Decision: **eligible for the ordered release with the user's device-testing waiver**, subject to final candidate-head/diff/review checks and verification after each automatic deployment. Scope is FP-59/60/61; FP-62/63 are excluded. This is not authorization to merge or deploy.

Docker security publication: reviewed/committed `5b42640` and pushed branch `fix/postgres-private-networking`; [Docker PR #25](https://github.com/jamesabilong/fpdocker/pull/25) is OPEN/CLEAN/MERGEABLE. GitHub requires a PR, so direct master push was rejected and master is unchanged. **Merge Docker #25 first**, then perform the six app releases below. Three production-render checks (including no DB published port) and Bash/whitespace checks pass. All six app PR heads/bases rechecked unchanged and CLEAN/MERGEABLE. No PR merge/deploy/dispatch performed. This supersedes older uncommitted/unpublished Docker notes.

Latest user decision (October 21): “no need for device testing,” reiterated as “no need to check device.” Physical-device/installed-PWA upgrade acceptance is waived, **not passed**; no connected Android device was detected and no phone acceptance ran. Installed-version upgrade/draft retention and device storage behavior remain untested risks. This supersedes older device-testing blockers below. Backup/restore, isolated acceptance and PostgreSQL mitigation pass within their documented limits. Local Docker security sources/Compose correction remain uncommitted and unpublished; preserve the live firewall guard and use the ordered release/runbook checks.

Latest security result: [public PostgreSQL exposure mitigated and verified](postgres-security-2026-10-21.md). Persistent eth0 TCP 5432 guard blocks external probes while fresh private DB access and both apps' health pass; all production tasks/images/specs unchanged. This supersedes older exposure-pending statements below. Actual-device/installed-version upgrade acceptance remains open. Local Compose port removal/guard sources are uncommitted and unpublished.

Follow-up execution: [backup/isolated restore and candidate migration recovery now pass](backup-restore-check-2026-10-21.md). Remaining items below are narrowed accordingly; the initial readiness audit itself was read-only.

Service follow-up: [50 direct-service acceptance cases pass](service-acceptance-2026-10-21.md) on independent restored copies for all three exact candidates. Production service identities/health unchanged; fixtures and temporary resources cleaned. HTTP/auth/proxy/browser/PWA device checks and PostgreSQL exposure disposition still block full readiness.

HTTP/browser follow-up: [34 HTTP/auth, 21 Chromium assertion groups and three backend-down nginx checks pass](http-browser-acceptance-2026-10-21.md), with exact candidate builds and independent restored copies. This supersedes the isolated HTTP/browser-pending notes above. Remaining: actual-device/installed-version upgrades and PostgreSQL exposure disposition; live edge/deployed image checks remain in the ordered release runbook.

## Verified this audit

- Live GitHub queries confirm frontend #51/#52/#53 and backend #53/#54/#55 are OPEN, CLEAN and MERGEABLE against their existing stacked bases. All six heads still match the October 20 final validation record. No hosted checks or approval decision are reported; follow any applicable independent review policy.
- Live masters remain frontend `d7c0e554c47c451320547458ce42911a201e051f`, backend `72ce922253ceec28347f0e2176be01a328d56829`, and fpdocker `4ea0c5385298967a6e9cb0f263b40e7f04b25a25`. Read-only merge-tree checks using matching local refs pass for all six candidates against master, each yielding its candidate tree.
- Re-parsed saved final browser XML: FP-59 15 feature + 30 whole-app; FP-60 16 + 30; FP-61 15 + 30. Every group has zero failures/errors/skips. Full app, database and browser suites were not rerun today; earlier lint/unit/build/database evidence remains in the [final review](sprint-337-final-review-2026-10-20.md).
- Fresh `node --test testing/legacy/docker/deploy-maintenance.test.mjs`: 3 passed, zero skipped. Swarm rendering again warns that the PostgreSQL loopback publishing address is ignored; this does not retest external reachability.
- Latest reported fpdocker Actions remain successful October 19 runs `39205448196` and `39205441581`. No newer automated sprint release is reported.
- Reviewed app dispatch workflows and the Docker deploy workflow: backend migrations precede backend service update; frontend dispatch renders the stack. App builds use default-branch sources and mutable latest tags, requiring serialized merges and verification of actual built/deployed digests.

## Remaining before master merge

1. Running image identities and current protected database/config/uploads checkpoint are captured; base restore and uploads archive integrity pass. Off-host/global-role/config redeployment recovery and live-upload snapshot consistency retain their stated limits.
2. Exact candidate migrations, data/sequence preservation, rollback guards, post-migration recovery, 50 declared direct-service cases, 34 HTTP/auth groups, 21 Chromium groups and three nginx fallback checks pass on isolated restored copies. No separate staging environment exists; do not use production as the rehearsal target.
3. Physical-device/installed-PWA upgrade testing waived by the user on October 21; do not report it as passed. Retain the documented untested installed-upgrade/storage risk. Real browser offline reload, same-account retry, worker API-cache isolation and isolated nginx checks pass; verify the public deployed edge during rollout.
4. PostgreSQL exposure gate cleared for current eth0 topology by the enabled/verified firewall guard. Preserve this protection; publish the reviewed local Compose port-removal correction through the normal Docker release process when authorized. No reboot test was performed.
5. Recheck candidate diffs/heads when retargeting dependents and satisfy applicable review policy. Author-account COMMENT reviews do not establish independent approval.

Use the [release runbook](sprint-337-release-audit-and-runbook-2026-10-20.md) with the newer [preflight execution record](sprint-337-preflight-execution-2026-10-20.md), which supersedes its older uninspected-inventory statements. After gates pass: FP-59 backend → frontend, FP-60 backend → frontend, FP-61 backend → frontend. Wait for and verify each deployment before the next merge; retarget dependent pairs to master after prerequisites land.

The initial audit made no production change. Subsequent user-authorized backups, inventory, isolated rehearsals and the October 21 production firewall guard are documented in their execution records. No merge, retarget, PR mutation, stage/commit/push, app deployment, production migration/restart or app-source edit occurred; primary dirty FP-63 work remains untouched.

</details>
