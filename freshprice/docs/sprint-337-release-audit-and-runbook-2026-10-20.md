# Sprint 337 release audit and deployment runbook — 2026-10-20

**Current decision: merge conflicts are resolved; production release gates remain open.** Both FP-60 and FP-61 reconciliations are published and their exact committed trees match the passing local test evidence. All six PRs are OPEN/CLEAN/MERGEABLE. Fresh FP-59 exact-head validation and final source/integration review are complete; all six PR Validation sections and exact-head COMMENT reviews are published. No actionable code findings were identified. Restored-data staging and verified production preflight/ordered rollout remain open. Agent comments from the author account do not represent independent approval. See the [final review record](sprint-337-final-review-2026-10-20.md).

This is the current plan after FP-61 publication and the final review, replacing earlier instructions to reconcile/push FP-61 or refresh the six PRs. The original audit used read-only Jira/GitHub/public-health queries. The subsequent final review updated six PR bodies, posted six exact-head COMMENT reviews, ran fresh FP-59 checks and updated local documentation. No PR merge/retarget, Jira/sprint edit, source change or deployment. FP-63 remains unchanged/on hold; FP-62/63 are outside this release.

## 1. Re-audit findings and remaining blockers

Purpose-built board/sprint lookup confirms sprint **337 — Budget and Expense Management** is active on board 1, October 19–November 2 (Asia/Manila). The complete JQL result contains exactly [FP-59](https://fresh-price.atlassian.net/browse/FP-59), [FP-60](https://fresh-price.atlassian.net/browse/FP-60) and [FP-61](https://fresh-price.atlassian.net/browse/FP-61), all In Progress, assigned to james abilong. Sprint 338 remains future. Each ticket requires staging and data-preserving schema/backend-before-frontend delivery. All three Jira comment collections are empty.

| Ticket | Frontend PR / published head | Backend PR / published head | Live base / state |
| --- | --- | --- | --- |
| FP-59 | [#51](https://github.com/jamesabilong/fresh-price-front/pull/51) / `101a8342057eba50478d894bee9e77734c1927a2` | [#53](https://github.com/jamesabilong/fresh-price-backend/pull/53) / `e4fe0bc2f0f6c2a5cede18b4bc13ab9691a2ec46` | master / OPEN, CLEAN, MERGEABLE |
| FP-60 | [#52](https://github.com/jamesabilong/fresh-price-front/pull/52) / `3372481b6797b95064e3482ed37b2c95a04e4bf9` | [#54](https://github.com/jamesabilong/fresh-price-backend/pull/54) / `e8b7f78595303546a6f846f8074f9ffcfcfef990` | FP-59 / OPEN, CLEAN, MERGEABLE |
| FP-61 | [#53](https://github.com/jamesabilong/fresh-price-front/pull/53) / `0d100ab525fb3bcbfde2e42b97e56b127c10d30b` | [#55](https://github.com/jamesabilong/fresh-price-backend/pull/55) / `1d1fa16985330b923cca20631d4e7c2a86a37af2` | FP-60 / OPEN, CLEAN, MERGEABLE |

In both repositories FP-59 is now an ancestor of FP-60 and FP-60 an ancestor of FP-61. Read-only merge-tree checks of all six heads against current master are clean, and each prospective merged tree equals its branch tree exactly. Current masters remain frontend `d7c0e554c47c451320547458ce42911a201e051f` and backend `72ce922253ceec28347f0e2176be01a328d56829` (October 19 FP-65 merges). There is no current master-content conflict; recheck after any ref change and after each prerequisite landing. Do not redo completed FP-61 integration.

| Remaining gate | Confirmed evidence / action required |
| --- | --- |
| Current-head release evidence and review — completed locally | Fresh FP-59 exact-head checks pass, including seven calendar/server-spending cases and complete 15+30 browser groups. All six Validation sections now cite current paired heads/results; each has an exact-head COMMENT review with no actionable findings. These agent author-account reviews are not independent approval; obtain independent review if required by repository/team policy. Recheck final heads/diffs after retargeting or source changes. |
| Restored-data staging | No verification of these exact heads was found in current PRs, Jira comments or checked local release records. Identify the actual staging target and record roles/transfer/recurrence, accounting/concurrency/history, and PWA upgrade/offline/privacy/reauthentication/device results before production. A previously configured environment alone is not current-release evidence. |
| Production preflight and recovery | VPS running image digests, migration inventory, restorable backup, uploads/config recovery and image-tag settings were not inspected in this audit. Complete section 4 on the actual Swarm manager and retain protected evidence. Public health is insufficient to establish these. |
| Ordered release and acceptance | None of the six sprint PRs has landed. Perform the six serialized releases in sections 5–7 and verify each before continuing. Mark Jira Done/complete sprint only after actual delivery checks pass. |

All six `statusCheckRollup` collections are empty: **no hosted check result is reported**. This is an evidence limitation, not a newly invented requirement to build CI before release; use the recorded local tests plus required review/staging gates. Jira development panels are marked stale and aggregate inherited PRs; use live GitHub heads and deployment digests for release identity.

### Verified local evidence

FP-59 was freshly rerun during final review; FP-60/61 saved final JUnit was re-parsed and current published fingerprints reverified. Every listed browser group has zero failures/errors/skips:

| Ticket | Feature / whole-app | Execution and applicability |
| --- | --- | --- |
| FP-59 | 15 / 30 | `2026-10-20T09-48-40-201Z-4bf7489a`; fresh exact-head complete execution. Lint/build, 260 frontend plus 7 targeted calendar/server-spending, 166 ordinary backend, 36 enabled integration and 41 runner checks pass. |
| FP-60 | 16 / 30 | `2026-10-20T08-51-44-309Z-89ef42c2`; current published trees verified against tested fingerprints. Lint/build, 273 frontend, 184 ordinary backend, 36 enabled integration and 41 runner checks pass. |
| FP-61 | 15 / 30 | `2026-10-20T09-23-26-688Z-5def1a3c`; one complete final run on current published trees, verified against tested fingerprints. Lint/build, 279 frontend, 186 ordinary backend, 173 explicit unit-command checks, 36 enabled integration and 41 runner checks pass. |

All three ordinary backend commands each retain 23 existing opt-in DB skips; their separate enabled integration runs execute all 36 integration checks with zero skips. The 173 explicit FP-61 unit checks are a subset, not additional unique tests. Full evidence/fingerprints: [FP-60 reconciliation](fp-60-reconciliation-2026-10-20.md), [FP-61 reconciliation](fp-61-reconciliation-2026-10-20.md). FP-60/61 checks were not unnecessarily rerun for PR documentation updates. Fresh FP-59 logs, all fingerprints, six published reviews and readback are recorded in the [final review](sprint-337-final-review-2026-10-20.md).

### Live environment observations and limits

Read-only public checks around 09:33 UTC / 17:33 Asia/Manila on October 20 pass: API readiness `{"status":"ok","database":"ready"}`, nginx `/healthz` `{"status":"ok"}`, worker HTTP 200 with `Cache-Control: no-store`, CDN `no-store`, Cloudflare BYPASS; manifest HTTP 200 with `no-cache`, CDN `no-store`, Cloudflare DYNAMIC. The site is healthy and the checked worker/manifest headers are correct. These responses do not identify app commits, verify database migrations or exercise sprint features.

Latest fpdocker Actions remain successful October 19 dispatches [39205448196](https://github.com/jamesabilong/fpdocker/actions/runs/39205448196) and [39205441581](https://github.com/jamesabilong/fpdocker/actions/runs/39205441581), using fpdocker head `4ea0c538`. This is the orchestration SHA, not the app revision. No verified deployment of the new sprint heads was established; an unrecorded manual deploy cannot be excluded without VPS inspection.

Audit snapshots of the six PRs, public checks and prospective master trees are saved under `reconciliation/sprint337-release-reaudit-2026-10-20/`. Primary FP-63 branches, heads, full status and dirty/untracked file hashes were verified unchanged against the saved preservation record.

## 2. Release sequence and candidate gates

1. **Preserve scope.** Keep FP-63 primary checkouts untouched and sprint 338 unchanged. Use the existing isolated FP-60/61 worktrees and sibling local testing assets; keep their backups. Do not include FP-62/63 migrations or features.
2. **Confirm candidate identity.** Fresh FP-59 follow-up verification, all six current Validation sections and final agent COMMENT reviews are complete. FP-60/61 reconciliation, local checks and publication are complete. Author-account comments are not independent approval; follow applicable review policy. Recheck final diffs/heads when retargeting; rerun affected checks only if source changes or a specific unresolved concern requires them.
3. **Rehearse staging.** Use an isolated restored-data staging target and exact candidate revisions; disable outbound integrations and rehearse backup/restore and data-preserving repair. Use a staging deployment process or controlled staging build; merging master invokes production. Record the ticket-specific scenarios in sections 5–7, including old/new client compatibility, previously installed PWA update with pending work, actual device/storage behavior and proxy/cache headers.
4. **Production preflight.** Complete section 4, record backup/restore checkpoint and immutable image digests, verify image tags and maintenance/scheduler choices, then freeze other master merges for the release window.
5. **Execute one row at a time.** A master merge triggers deployment. Wait for its app dispatch and fpdocker build/deploy, verify the intended image/migrations/health and ticket smoke tests, then proceed. Preserve prerequisite branches until dependents are retargeted. Use merge commits for the stack.

| Order | Production action | Required checkpoint before next row |
| --- | --- | --- |
| 1 | Merge backend FP-59 [#53](https://github.com/jamesabilong/fresh-price-backend/pull/53) to master | Three role/lifecycle/inviter migrations up; intended backend healthy, old tasks drained; role/transfer/recurrence API smoke passes. |
| 2 | Merge frontend FP-59 [#51](https://github.com/jamesabilong/fresh-price-front/pull/51) to master | Full frontend/API and two-account desktop/mobile budget/lifecycle smoke passes. |
| 3 | Retarget FP-60 pair to master, review diffs; merge backend [#54](https://github.com/jamesabilong/fresh-price-backend/pull/54) | Accounting migration up; intended backend healthy; exact balances, authorization, concurrency and spending totals correct. |
| 4 | Merge frontend FP-60 [#52](https://github.com/jamesabilong/fresh-price-front/pull/52) to master | Splits, payment/receipt confirmation, corrections/reversals/history and ordinary CRUD pass. |
| 5 | Retarget FP-61 pair to master, review diffs; merge backend [#55](https://github.com/jamesabilong/fresh-price-backend/pull/55) | Receipt migration up; intended backend healthy; deduplication, revision/identity/authorization/deletion contracts pass. |
| 6 | Merge frontend FP-61 [#53](https://github.com/jamesabilong/fresh-price-front/pull/53) to master | Installed-PWA upgrade, offline restart/replay, privacy/conflicts and production/device checks pass. |
| 7 | Record evidence and close out | Exact SHAs/digests, migrations, Actions links, staging/device results and recovery evidence recorded; then Jira Done and sprint completion. |

Normal local verification commands, when needed on isolated matching ticket checkouts:

```sh
# Frontend
npm run lint
npm run test:unit -- --maxWorkers=2
npm run build
# Backend
npm test
npm run test:integration:db
# Sibling testing directory
npm run test:scope
# Frontend: complete feature AND whole-app groups
npm run test:e2e:chromium
```

Expected browser groups remain FP-59 15+30, FP-60 16+30 and FP-61 15+30. Use runner-owned disposable PostgreSQL only. Keep every registered scenario and record actual skips; no success can be inferred from a list-only run. The standalone E2E dev-server config freezes filesystem watching/HMR; normal app development and the actual production PWA build retain their own configuration.

## 3. Understand the deployment trigger

Both app repositories dispatch to [fpdocker Build and Deploy](https://github.com/jamesabilong/fpdocker/actions/workflows/deploy.yml) on a push/merge to `master`. **Merging a PR into master is a production deployment action.** There is no need for a second manual migration command in the normal path.

The verified live fpdocker workflow checks out each app's default branch at execution time and publishes mutable `latest` tags; it does not pin frontend/backend checkouts to the triggering app SHA. Deployment concurrency serializes runs but does not prevent later master merges from changing the source that an earlier queued run builds. Therefore perform one master merge, wait for its matching dispatch/build/deploy and verify its result before the next master merge. Record app SHA plus built image digest; workflow success or fpdocker SHA alone is insufficient.

Backend dispatch pulls its image, runs `sequelize-cli db:migrate` from that new image with the VPS environment, then updates `freshprice_backend`. Frontend dispatch renders the stack and updates `freshprice_frontend`. Confirm VPS `BACKEND_IMAGE_TAG`/`FRONTEND_IMAGE_TAG` settings will not reintroduce an older pinned image when the stack is rendered. Frontend full-stack rendering must preserve unrelated services and the intended backend image.

Re-audit confirms fpdocker origin/master is 4ea0c538; the local checkout is 42fd3fb, differing only by removed test files. The deployment workflow used above matches origin/master. No new Docker configuration is needed for this sprint based on this audit. If a configuration fix becomes necessary, publish fpdocker master first, then trigger the relevant app release. Keep PostgreSQL 14 and production Swarm; do not use local `task restart`.

## 4. Preflight and backup on the VPS

After candidate/staging/review gates pass, on the Swarm manager:

```bash
cd /var/projects/freshprice/fpdocker
git status --short
git pull --ff-only origin master
docker stack services freshprice
docker service inspect freshprice_backend --format '{{.Spec.TaskTemplate.ContainerSpec.Image}}'
docker service inspect freshprice_frontend --format '{{.Spec.TaskTemplate.ContainerSpec.Image}}'
docker service ps freshprice_backend --no-trunc
docker service ps freshprice_frontend --no-trunc
```

Save current image digests/service specifications, active migration inventory and a restorable database backup in a protected release record. Confirm all pre-sprint migrations are already up. One PostgreSQL backup example (VPS Bash, existing single-node local database container):

```bash
set -euo pipefail
umask 077
release_backup_dir="/var/backups/freshprice/sprint-337-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$release_backup_dir"
release_pg_container="$(docker ps -q --filter label=com.docker.swarm.service.name=freshprice_postgres)"
[[ -n "$release_pg_container" && "$release_pg_container" != *$'\n'* ]]
docker exec "$release_pg_container" sh -c \
  'exec pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" -Fc' \
  > "$release_backup_dir/database.dump"
test -s "$release_backup_dir/database.dump"
```

This assumes that the actual database is the local `freshprice_postgres` service; verify the active database target first. A backup-file existence check is not restore validation: verify the dump and restore it into a separate isolated target before release. Back up uploads and protected runtime configuration as well; never paste credentials or dump contents into PRs/Jira. Take another recovery checkpoint before later stages if production data has changed.

If a maintenance window is required, use the existing [maintenance runbook](fp-43-recovery-runbook.md), persist the same flag in VPS `.env` and verify the installed image supports it. Frontend maintenance does not by itself pause the recurrence worker; recurring generation starts on backend startup/hourly unless disabled with `FRESHPRICE_RECURRING_BUDGETS=false`. Verify the intended scheduler setting reaches the runtime backend; manual generation remains enabled. Staging must cover startup and repeated generation. Do not clear users' IndexedDB as part of maintenance.

## 5. Release FP-59 first

1. After the gates above, merge **backend PR #53 into master** using a merge commit. Keep the FP-59 branch for the dependent PR. Wait for backend app dispatch and its matching fpdocker build/deploy to complete.
2. The backend workflow automatically applies, in order:
   - `20261019000001-scheduled-budget-member-roles.cjs`
   - `20261019000002-budget-transfer-and-templates.cjs`
   - `20261019000003-preserve-budget-inviter-history.cjs`
3. Run the backend verification block in section 8. Confirm all three migrations up, intended image digest and old backend tasks drained, then test viewer write denials, contributor access, recipient-accepted transfer/stale-owner denial, member survival after former-owner deletion and monthly recurrence/clamping/private empty instances. Verify pause/resume/cancel and retry/startup behavior.
4. Only after the backend gate passes, merge **frontend PR #51 into master**. Wait for its matching fpdocker run. Run full verification and desktop/mobile two-account budget, transfer and template smoke tests. Verify stale tabs and account-switch privacy.
5. Stop on failure. Do not proceed to FP-60 until this paired release is verified.

## 6. Release FP-60 second

1. Retarget **backend #54 and frontend #52 to master** after FP-59 lands. Fetch/reconcile master if necessary; inspect final diffs and mergeability. If source changes, rerun the applicable checks and staging verification. Preserve FP-59 until retargeting is confirmed.
2. Merge **backend #54**. Wait for the backend dispatch/deploy; it automatically applies `20261019000004-budget-accounting.cjs` before backend update.
3. Verify intended image/migration, neutral legacy balances, exact PHP 100/3 remainder allocation, balances summing to zero, concurrent corrections/confirmations, viewer/removed-member denial, and ordinary expense CRUD. Pending settlements must have no confirmed effect; confirmed settlements must not increase spending totals.
4. Merge **frontend #52 only after backend verification**. Wait for deployment, run full verification and desktop/mobile split, pending payment, receipt confirmation, correction, reversal and paginated history smoke tests.
5. Retain accounting history/revision/void protections. Stop before FP-61 if this stage fails.

## 7. Release FP-61 last

1. FP-60 → FP-61 reconciliation, fresh local checks and publication are complete. After FP-60 lands, retarget **backend #55 and frontend #53 to master**, review the actual final diffs and verify exact candidate heads. Recheck source trees against the tested fingerprints; rerun affected checks if integration content changes.
2. Merge **backend #55**, wait for its matching deployment; it automatically applies `20261020000001-expense-mutation-receipts.cjs` before backend update.
3. Verify durable receipts, authorization on every replay, exact duplicate/lost-response behavior, revision conflict responses, account/budget identity binding, deleted-target responses and unchanged financial totals. Confirm old clients remain compatible. Use a controlled test account and retain its records/evidence.
4. Only then merge **frontend #53**. Wait for deployment. Purge only `/sw.js` and `/manifest.webmanifest` in Cloudflare if stale delivery is observed or as part of the established targeted PWA release procedure. Check headers again; retain immutable hashed assets and the `freshprice-expense-drafts` IndexedDB database.
5. Test a previously installed PWA and a clean browser: offline create/edit → restart → reconnect, exactly-one server result, pending totals separate from confirmed totals, lost response, concurrent tabs, conflicts with renewed review, expired-session same-account reauthentication, explicit logout/account switching, permission revocation/deleted budget, storage failure and update with queued work. Check actual mobile/device behavior and the production proxy/CDN path.
6. Do not ask users to clear site data to fix a deployment: it can delete unsynced drafts. Preserve receipts and queue payloads during repair.

## 8. Verify after every backend/frontend deployment

Run the fuller read-only block in [deployment.md — Verify deployment on the VPS](deployment.md) with `DEPLOY_CHECK_PHASE=backend` after each backend and `DEPLOY_CHECK_PHASE=full` after each frontend. A compact per-stage check is:

```bash
set -euo pipefail
cd /var/projects/freshprice/fpdocker
docker stack services freshprice
docker service inspect freshprice_backend --format '{{.Spec.TaskTemplate.ContainerSpec.Image}} {{if .UpdateStatus}}{{.UpdateStatus.State}}{{end}}'
docker service ps freshprice_backend --no-trunc
release_backend_container="$(docker ps -q --filter label=com.docker.swarm.service.name=freshprice_backend)"
[[ -n "$release_backend_container" && "$release_backend_container" != *$'\n'* ]]
docker exec "$release_backend_container" ./node_modules/.bin/sequelize-cli db:migrate:status
curl --fail --silent --show-error --connect-timeout 5 --max-time 20 \
  -H 'Cache-Control: no-cache' https://freshprice.philwatch.com/api/platform/db/health
# Add after frontend deployment / maintenance removal:
docker service inspect freshprice_frontend --format '{{.Spec.TaskTemplate.ContainerSpec.Image}} {{if .UpdateStatus}}{{.UpdateStatus.State}}{{end}}'
docker service ps freshprice_frontend --no-trunc
curl --fail --silent --show-error --connect-timeout 5 --max-time 20 https://freshprice.philwatch.com/healthz
curl --fail --silent --show-error --head --connect-timeout 5 --max-time 20 https://freshprice.philwatch.com/sw.js
curl --fail --silent --show-error --head --connect-timeout 5 --max-time 20 https://freshprice.philwatch.com/manifest.webmanifest
```

Proceed only when the intended image digest is running, desired replicas are healthy/current, update is completed (or none for initial deployment), required migrations are up, API readiness is correct and the ticket smoke tests pass. A healthy old/automatically rolled-back service is not a successful new release. Commands print evidence for inspection; exit code zero alone does not establish these conditions.

Monitor current task errors and recent `docker service logs --tail 100 freshprice_backend` / frontend logs in the protected operator session. Check shared platform auth and an unrelated existing API path as backend regression smoke coverage.

## 9. Stop/repair rules and closeout

If migration or backend verification fails, do not merge its frontend or any later ticket. If a frontend update fails, stop the sequence and repair/restore a verified compatible frontend image. The workflow uses mutable tags and prunes images, so record and retain recoverable immutable digests before relying on rollback. Restore the last verified service configuration/image with an explicit compatibility check rather than blindly reverting all services.

Retain additive schemas and collected data. Never delete financial/receipt/lifecycle rows to force `db:migrate:undo`:

- FP-59: a role-unaware backend must not serve viewer memberships; retain inviter/member history.
- FP-60: once financial history exists, retain revision/void guards or suspend expense writes pending a forward fix. Reverting to FP-59 expense writers bypasses those protections.
- FP-61: retain receipt-aware APIs and durable receipts while any installed client has queued work. Do not replay queued mutations against a backend lacking idempotency support or clear IndexedDB to recover the shell.

Forward repair is preferred. Database restore is a coordinated incident recovery with writes stopped and reconciliation of writes after the checkpoint, not the routine application rollback path.

After all three paired releases and smoke tests pass, record exact app SHAs, image digests, migrations, Actions URLs, backup/restore checkpoint, staging and device results in the release record and Jira. Mark FP-59/60/61 Done and complete sprint 337 only when the actual delivery checks are satisfied. FP-62/63 remain outside this deployment; FP-63 stays on hold until sprint-337 closeout is complete.
