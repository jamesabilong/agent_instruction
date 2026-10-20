# FreshPrice Todo

## Current priority: finish sprint 337 before FP-63 — 2026-10-20

- [x] Audit live Jira, six PRs, dependency heads/reviews/checks and recorded test/release evidence for FP-59/60/61. See `docs/sprint-337-pending-audit-2026-10-20.md`.
- [x] Preserve FP-63 work/findings through FP-60/61 reconciliation, publication and the renewed sprint audit; sprint 338 remains future/unchanged. FP-63 remains on hold.
- [x] Prepare and verify FP-60 working-file resolutions against FP-59 101a8342/e4fe0bc in isolated worktrees, preserving calendar/test-command fixes and accounting. Lint/build, 273 frontend / 184 ordinary backend / 36 enabled DB / 41 runner / 16 feature + 30 whole-app pass. See `docs/fp-60-reconciliation-2026-10-20.md`.
- [x] Commit/push proper two-parent FP-59 → FP-60 merges: frontend `3372481b`, backend `e8b7f78`. Verified exact tested trees, live refs/upstream 0/0 and both FP-60 PRs OPEN/CLEAN/MERGEABLE. FP-63 unchanged/on hold.
- [x] Prepare FP-61 frontend/backend conflict resolutions against current FP-60 in isolated worktrees and rerun all checks: lint/build, 279 frontend / 186 ordinary backend / 173 explicit unit command / 36 enabled integration / 41 runner / 15 feature + 30 whole-app pass. FP-63 unchanged/on hold. See `docs/fp-61-reconciliation-2026-10-20.md`.
- [x] Commit/push proper two-parent FP-60 → FP-61 merges: frontend `0d100ab5`, backend `1d1fa16`. Verified exact tested trees, both parents, live refs/upstream 0/0 and both PRs OPEN/CLEAN/MERGEABLE. FP-63 unchanged/on hold.
- [x] Complete fresh FP-59 exact-head follow-up validation and final source/integration review; update/read back all six current PR Validation sections and exact-head COMMENT reviews. No actionable findings; author-account comments are not independent approval. FP-60/61 published trees match complete passing evidence. See `docs/sprint-337-final-review-2026-10-20.md`.
- [ ] Recheck candidate heads/diffs when retargeting FP-60/61 to master as prerequisites land; follow applicable independent review policy. No hosted checks are currently reported.
- [ ] Verify all three tickets on restored-data staging, including roles/transfer/recurrence, accounting/concurrency/history, PWA queued-work upgrade/replay/privacy, rollback constraints and real proxy/device checks; attach actual results.
- [x] Re-audit after FP-61 publication: six PRs clean/mergeable, dependency ancestry correct, prospective current-master merge trees unchanged. Rewrite the runbook to remove obsolete integration steps and specify remaining evidence/staging/preflight gates and six serialized deployment stages. No production actions performed.
- [ ] Complete actual VPS image/migration inventory, restore-tested DB/backup and uploads/config recovery checkpoints, image-tag and maintenance/scheduler checks before the release window.
- [ ] Land/release FP-59 → FP-60 → FP-61 with each migration/schema/backend before its frontend; record actual verification, then mark the tickets Done and complete sprint 337. Master merges trigger deployment; do not treat unresolved staging/integration work as delivery complete.

## FP-63 pre-commit findings — 2026-10-20

- [ ] P2: freeze the purchase confirmation's reviewed item/list/budget/market context or invalidate it on refresh changes; require explicit renewed review before recording against another target/revision.
- [ ] P2: route recorded purchases to their original personal/shared expense history, retaining purchase-time budget context even after the list is retargeted.
- [ ] P3: use exact decimal/scaled arithmetic for centavo estimates and integer-cent basket aggregation; cover half-cent and unit-conversion boundaries.
- [ ] Add expected-correct registered regressions and rerun affected/full checks before committing. Evidence: `docs/fp-63-precommit-review-2026-10-20.md`; isolated review probes are separate from acceptance groups.

## FP-63 shopping integration — 2026-10-20

- [x] Read current Jira scope, branch frontend/backend from reviewed FP-62, and mark FP-63 In Progress without starting/rescheduling its future sprint.
- [x] Implement personal list/item persistence, published recipe mapping/scaling, fresh official market estimates and unknown totals, accessible-budget comparison and explicit atomic/idempotent actual purchase-to-expense conversion. No spending from checking alone.
- [x] Verify 12 feature + 30 whole-app, 284 frontend units, 224 ordinary backend checks (23 existing opt-in DB skips), 36 runner checks and lint/build. Additive migration roundtrip/history guard, privacy/revocation, source/expense deletion, mobile/offline and committed-response-loss paths pass. See `docs/fp-63-shopping-integration-2026-10-20.md`.
- [ ] Review changes before commit; commit/push/PR only when requested. Preserve the separate local testing workspace and unmerged FP-59/60/61/62 dependency chain.
- [ ] Rehearse migration/schema/backend-before-frontend rollout and both budget scopes, recipe/price provenance, privacy/revocation, mobile/offline/retry and rollback in staging before marking delivery complete.
- [ ] Implement favorites and define/verify threshold, market/unit/freshness, cooldown, consent/unsubscribe and deduplicated newly eligible alert delivery as separately planned follow-up increments. Orders/checkout/payments remain deferred.

## FP-62 publication — 2026-10-20

- [x] Commit/push reviewed frontend `2fc10cd7` and backend `1fcb72d8` to origin/FP-62; exact live refs, upstream tracking and clean app working trees verified.
- [ ] Create linked PRs when requested; preserve the local testing workspace, unmerged FP-59/60/61 dependencies and editorial/staging/ordered release gates.

## FP-62 pre-commit review findings — 2026-10-20

- [x] P2: preserve account/product-scoped composing form state across panel collapse/reopen and during submission, while retaining session clearing.
- [x] P2: add an explicit operator retraction/unpublish transition for approved variants, preserving history and unrelated canonical/variant content; cover public and seasonal exclusion. Author cancellation remains a separate future workflow consideration.
- [x] P3: retain a stable submission identity across uncertain retries and atomically deduplicate matching actor/payload operations.
- [x] Add expected-correct registered regressions for these paths and rerun affected checks before committing. Review probes/evidence are separate from prior passing acceptance groups; see `docs/fp-62-precommit-review-2026-10-20.md`.

- [x] Verify 13/13 feature + 30/30 whole-app, 278 frontend units, 206 ordinary backend checks (23 existing opt-in skips), 36 runner checks and lint/build. See `docs/fp-62-review-fixes-2026-10-20.md`.

## FP-62 wiki enrichment — 2026-10-20

- [x] Read current Jira scope, create matching FP-62 branches from reviewed FP-61 and move ticket to In Progress; retain the future sprint schedule.
- [x] Implement source-revision-linked language/regional proposals, moderation/private draft retention, environment coverage audit, sourced seasonal/recipe filters and explicit contributor recognition/withdrawal.
- [x] Verify additive migration roundtrip/nonempty rollback guard, privacy/authorization, source/import invalidation, concurrent review, mobile text safety and discovery. Complete feature 10/10 + separate whole-app 30/30, 275 frontend units, 203 ordinary backend checks, 36 runner checks and lint/build pass. See `docs/fp-62-wiki-enrichment-2026-10-20.md`.
- [x] Perform pre-commit review and fix all three findings; passing review-fix verification is documented.
- [x] Commit/push at the explicit request on 2026-10-20; frontend `2fc10cd7`, backend `1fcb72d8`. PR creation remains pending; preserve the local testing workspace and unmerged FP-59/60/61 dependency chain.
- [ ] Run inventory against the actual target environment, select a small sourced pilot and obtain factual/translation editorial approval before publishing it. Synthetic test notes do not qualify.
- [ ] Rehearse schema/backend-before-frontend rollout and publication/privacy/import/rollback checks in staging before marking delivery complete.

## FP-61 publication — 2026-10-20

- [x] Commit/push reviewed frontend `5e58884f` and backend `a394105d` to origin/FP-61; clean working trees and exact live refs verified.
- [x] Create and verify reciprocally linked FP-61 PRs: backend #55 and frontend #53, both targeting FP-60 while prerequisite PRs remain open. Documented FP-59/FP-60 dependencies, local testing assets, passing checks and ordered release gates; both OPEN/unmerged with auto-merge disabled.
- [ ] Complete staging and migration/backend-before-frontend release only when requested; preserve the standalone local testing workspace.

## FP-61 pre-commit review blockers — 2026-10-20

- [x] Freeze the reviewed conflict revision and reject concurrent conflict changes instead of adopting unseen versions.
- [x] Invalidate pending reads after queue replay and refresh confirmed totals/history from a fresh read, including background/other-tab replay.
- [x] Persist logout disposal intent so interrupted IndexedDB cleanup cannot replay discarded drafts on same-account login.
- [x] Convert the three review probes into expected-correct registered regressions and rerun affected/full acceptance checks before committing. See `docs/fp-61-precommit-review-2026-10-20.md`; review evidence uses controlled Axios responses with actual browser/storage/stores.

- [x] Verify complete feature 15/15, separate whole-app 30/30, 272 frontend units, 186 ordinary backend checks, 36 runner checks and lint/build. See `docs/fp-61-review-fixes-2026-10-20.md`.
- [x] Commit/push at the explicit request on 2026-10-20; retain staging and ordered dependency/migration/backend/frontend release gates.

## FP-59 publication — 2026-10-19

- [x] Commit/push reviewed frontend `5dc479f9` and backend `aa866602` to origin/FP-59; live refs and clean working trees verified.
- [x] Create and verify reciprocally linked FP-59 PRs: backend #53 and frontend #51, with test results, local testing dependencies and backend-first release order. Both remain OPEN/unmerged with auto-merge disabled.
- [ ] Complete the ordered staging/migration/backend/frontend release when requested. Preserve the standalone local testing workspace and staging gates.

## FP-59 pre-commit review blockers — 2026-10-19

- [x] Preserve other members when the former owner's account is deleted after an ownership transfer; use a nullable SET NULL inviter FK without rewriting historical attribution.
- [x] Prevent future recurring ID preclaims, including cross-account attempts by accepted shared members; random instance UUIDs retain unique-period deduplication.
- [x] Make due-template processing fair across batches and repeated failures; healthy later work proceeds despite 50 persistent failures.
- [x] Register all three real-data acceptance regressions and rerun affected/full checks: all 45 seeded cases, 260 frontend units, 166 ordinary backend checks, 36 runner checks, lint/build pass. See `docs/fp-59-review-fixes-2026-10-19.md`. Changes remain uncommitted.

## Active budget sprint / FP-59 — 2026-10-19

- [x] Start sprint 337, Budget and Expense Management, October 19–November 2 (Asia/Manila), two weeks with automatic completion disabled. Move FP-59 to In Progress through Jira browser UI.
- [x] Create matching local FP-59 frontend/backend branches from published FP-65 heads and implement the viewer-role increment with owner invitation/role controls, shared expense write enforcement, migration and local regression assets.
- [x] Verify first increment: lint/build, 257 frontend unit checks, 145 backend unit checks, 36 runner checks, five real feature/migration scenarios and 30 whole-app regressions pass (35/35 seeded, zero skips/failures/errors). Preserve In Progress status for remaining FP-59 increments.
- [x] Implement transactional recipient-accepted ownership transfer with concurrency/stale-request checks.
- [x] Define and implement durable recurring templates with Philippine calendar dates, independent expenses, idempotent generation and pause/cancel behavior. See `docs/fp-59-lifecycle-2026-10-19.md` for independent creator ownership, private membership policy and monthly cadence.
- [x] Finish lifecycle/browser regression verification: all 42 seeded cases, 260 frontend unit checks (two workers), 166 ordinary backend checks and 36 runner checks pass; lint/build and cleanup verified. Report `2026-10-19T07-10-05-532Z-17bc48de`. Unrestricted parallel frontend execution hit two existing five-second test timeouts; bounded-worker full rerun passes unchanged.
- [ ] Release only after reviewed migration/backend-before-frontend rollout and staging checks. Never run a role-unaware backend while viewer memberships exist.

## Category-based sprints — 2026-10-19

- [x] Inspect existing sprints and prepare three category-based sprint goals/mappings in `docs/backlog-ticket-plans-2026-10-19.md`.
- [x] Create category sprints and assign/verify all seven tickets via authenticated Jira browser UI: 337 budget (FP-59/60/61), 338 wiki/shopping (FP-62/63), 339 seller/messaging (FP-57/58). Goals saved, future state verified, no dates/start. Preserved empty sprint 336 because its intended purpose was not established. Connector itself still reports read-only.
- [ ] Estimate increments and set capacity/dates before starting; budget scope includes XL offline work and may require follow-up sprints.

## Jira backlog planning — 2026-10-19

- [x] Review the actual backlog and prepare individual plans for all seven open tickets FP-57–FP-63; see `docs/backlog-ticket-plans-2026-10-19.md`.
- [x] Publish implementation plans and acceptance criteria to FP-57–FP-63 via Jira browser UI and verify every saved description after reopening (2026-10-19).
- [ ] Settle explicitly proposed policy details, owners and estimates before implementation/sprint commitment.
- [ ] Verify the existing budget/wiki release baseline before implementation. Follow the proposed dependencies: FP-59 → FP-60 → FP-61; FP-57 → FP-58; FP-62 and core FP-63 can proceed independently once their baselines are verified.
- [ ] Register ticket-specific local fixtures and acceptance suites when implementing each increment; no new feature implementation or verification is claimed by this planning review.

## FP-65 merge review — 2026-10-19

- [x] Pass the chosen history market into the admin observation preview; real multi-market median/mean/mode and reset-to-All regression passes (2026-10-19).
- [x] Serialize database-backed test files through the backend config; documented DB command passes 36/36, including rollback/reapply, without a CLI override (2026-10-19).
- [x] Resolve the reviewed report provenance, role-cookie helper and page-shell assertion gaps; 35 runner checks and all 39 seeded cases pass (2026-10-19).
- [x] Commit/push October 19 fixes and create paired PRs: frontend #50 (`c853c2ff`), backend #52 (`1f83d41`). GitHub reports both CLEAN/MERGEABLE, no required branch checks/reviews; working trees clean. Optional CI diagnostics are unavailable without a separate connector login.
- [ ] Merge/release backend #52 and observation migration before frontend #50 when requested; complete staging/actual-host checks. See `docs/fp-65-gap-fixes-2026-10-19.md`.

## Suite audit follow-up — 2026-10-15

- [x] Give test artifacts an execution identity and prevent report commands from showing stale successes after setup/validation failure; eight report regressions and actual rejected-argument CLI check pass (2026-10-19).
- [x] Strengthen whole-app shopping/contact/activity/admin-community checks with real loaded products, persisted post/profile/tag data, contact links and final protected URLs; all 30 whole-app cases pass (2026-10-19).
- [x] Replace the FP-65 marker bearer header with captured real session cookies; independent identity and cross-login role regressions pass (2026-10-19).
- [ ] Add interruption cleanup if guaranteed Ctrl-C/SIGTERM cleanup is required; current cleanup covers normal pass/failure.

## Requested publication — 2026-10-15

- [x] Commit and push FP-65 frontend/backend changes and current-branch Docker test relocation; preserve local-only testing and generated seeders.
- [ ] Keep a local backup of the standalone testing folder; remote app checkouts require that sibling workspace to run the relocated suites.

## Seeded regression fixes — 2026-10-15

- [x] Fix idle correction picker, archived observation market identity/correction, image multipart acceptance, tagged-post junction configuration and product validation status handling.
- [x] Verify adjacent authorization/input limits and persistence through the registered real-data scenarios.
- [ ] Verify on staging before release; local disposable-data checks do not establish production behavior.

## All-suite local relocation and whole-app coverage — 2026-10-15

- [x] Move all existing suites/support into isolated local testing folders, preserve legacy details and verify rewritten paths/configuration.
- [x] Create whole-app real-data coverage under FP-65, fixture requirements and local seed generation; strengthen the idle picker regression and invalid-input assertions.
- [x] Fix the five application regressions and rerun all 39 seeded cases: all pass with zero skips (2026-10-15).
- [ ] Register future tickets explicitly; whole-app ownership is temporarily FP-65. Back up local `testing/`, which is outside app repositories.

## Local testing isolation — 2026-10-15

- [x] Move ticket E2E infrastructure to workspace `testing/`; retain frontend convenience commands and ticket branch validation.
- [x] Generate local-only seed scripts from each ticket’s JSON fixture requirements and data-details note; verify recreation/validation (24 checks) and real isolated execution (all nine scenarios; eight pass, archived-market failure remains).
- [x] Remove the approved unpushed backend seeder-only commit without changing earlier backend work; remove app-repository seeded CI that depends on local assets.
- [ ] For each future ticket, add local specs, fixture requirements, acceptance mapping and an expected scenario count. Back up the standalone local testing folder as needed.
- [x] Resolve archived-market behavior and the idle picker regression (fixed October 15; feature regressions pass again October 19).

## Ticket E2E selection — 2026-10-15

- [x] Make default E2E commands branch-selected, with matching backend ticket validation, explicit ticket spec/seeder registration and no broad fallback.
- [x] Reject filtered, skipped, missing and incomplete ticket runs; add a Docker-free scope preview and separate full-regression commands/workflow.
- [x] Verify FP-65 selects only its nine seeded scenarios and preserves the existing archived-market failure; scope/completion guard tests pass.
- [ ] Register each future ticket’s specs, seeder, scenario count and acceptance matrix before running its branch. Unit suites remain independently configured.
- [x] Fix the archived-market bug (October 15); feature suite passes again October 19. Branch scoping does not establish exhaustive acceptance/code coverage.

## Seeded E2E review follow-up — 2026-10-15

- [x] Strengthen the real-browser corrected-product regression with a settled empty selection and depth-warning capture; it now exposes the confirmed loop. A separate deterministic component regression remains useful when fixing the app.
- [x] Fix archived-market identity/exclusion and picker empty-ID handling; prior 8/1 diagnostic is superseded by nine passing feature cases (October 15 and October 19).

## Seeded feature verification — 2026-10-15

- [x] Add a repeatable migrated PostgreSQL seeder and real browser/API feature suite: `npm run test:e2e:seeded` from `fresh-price-front`.
- [x] Execute all 9 scenarios without skips: import review/normalization, typo/row review, duplicate confirmation, replay/lost response, corrections/audit, statistics/units/markets/pagination, permissions and public/member/admin trend views. Result: 8 pass and 1 archived-market regression fails.
- [x] Keep the existing mocked Chromium suite isolated and passing (19 tests); add a manual CI workflow accepting a matching backend ref.
- [x] Fix archived-market identity, rendering and correction/exclusion and the correction picker; feature regressions pass October 19.
- [x] Publish the original matching feature changes (October 15). Remote test workflows were subsequently retired for the intentionally local testing workspace; no remote CI/staging success or exhaustive coverage is claimed. October 19 fixes still need publication.

## FP-65 sample data verification — 2026-10-15

- [x] Import the supplied notes through the real browser/API into disposable PostgreSQL and verify persistence, replay, normalization, corrections and statistical displays; see `docs/fp-65-sample-data-test-2026-10-15.md`.
- [ ] Confirm actual dates, quote units/quantities and unclear product names before importing into a real market; complete staging checks before release. Both original review bugs are fixed.

## FP-65 review fixes — 2026-10-15

- [x] Preserve an empty correction product selection and regress clear → choose replacement → save without a render loop (October 15 fix; October 19 recheck passes).
- [x] Handle soft-deleted markets while retaining historical identity and correction/exclusion (October 15 fix; October 19 recheck passes).
- [x] Rerun affected checks after the original review fixes; latest verification is in `docs/fp-65-gap-fixes-2026-10-19.md`. Deployment/staging remains a separate release step.

## Multiple prices and statistical trends — FP-65, 2026-10-15

- [x] Inspect existing price storage/trend calculations and write `docs/multiple-price-observations-plan-2026-10-15.md`.
- [x] Add separate observations and idempotent import/read/correction APIs while preserving official prices/history.
- [x] Expand note imports to retain every reviewed quote, including repeated prices and optional seller/quality context.
- [x] Implement daily/weekly/range mean, median and mode statistics, counts, tie/no-mode rules and consistent trend comparisons.
- [x] Update public/signed-in/admin trend views and verify existing CSV, publication, history and budget workflows.
- [x] Apply migrations and verify batch retries/statistics against disposable PostgreSQL; complete frontend/backend/browser checks before release.

- [ ] Release migration/backend before frontend; smoke-test real notes/aliases and cache refresh in staging.
- [ ] Implement the community-submission adapter and source deduplication before including community quotes in observation trends.

## Friendly price-note imports — 2026-10-15

- [x] Add paste/review imports for dated notes with name/alias matching, typo suggestions, explicit price/unit/quantity choices and duplicate protection.
- [x] Fix shared bulk result-envelope compatibility and preserve existing CSV entry point.
- [x] Pass frontend lint/build, 252 unit tests and all 18 Chromium flows.
- [ ] Smoke-test with real product aliases and a dated note batch in staging; confirm individual quote counts and normalized prices. Browser tests use mocked API responses; persistence was separately verified against PostgreSQL.
- [x] Retain multiple same-day quotes separately from official history (FP-65 initial operator implementation, 2026-10-15).

## VPS deployment verification — 2026-10-12

- [x] Document backend-only and full-release VPS check commands, expected successful results and failure diagnostics in `docs/deployment.md`.
- [ ] Run the documented checks on the VPS after each deployment phase and complete browser smoke checks; local syntax validation does not establish a live successful deployment.

## FP-64 merge readiness — 2026-10-12

- [x] Confirm both P2 fixes are committed/pushed and all three FP-64 branches merge cleanly with freshly fetched master; rerun frontend/backend/browser checks.
- [x] Repeat all migrations, 30 database integration checks, 130-page wiki population/revision/idempotency/draft preservation, maintenance parser, nginx/Caddy runtime and production PWA checks in disposable local environments.
- [ ] Complete the ordered Docker → backend/migrations → frontend release; confirm actual-host Caddy and staging recovery before the frontend production release, then purge exact CDN URLs and verify live services/returning browsers. See `docs/fp-64-merge-readiness-2026-10-12.md`.

## FP-64 recheck — 2026-10-11

- [x] Reproduce both October 9 findings on the current unchanged heads and rerun available unit/browser/build checks; see `docs/fp-64-recheck-2026-10-11.md`.
- [x] Resolve both P2 findings with passing regressions (2026-10-11); see `docs/fp-64-gap-fixes-2026-10-11.md`.
- [x] Repeat database/proxy runtime checks after Docker becomes available (2026-10-12).
- [ ] Complete staging/production release verification.

## FP-64 pre-merge gaps — 2026-10-09

- [x] Recheck the budget write generation after post-save hydration; regress an account switch after write confirmation while hydration is pending (fixed and verified 2026-10-11).
- [x] Export `FRESHPRICE_MAINTENANCE` from the VPS `.env` in the deployment workflow; verify enabled/disabled stack configuration so dispatches preserve the intended state (fixed and verified 2026-10-11).
- [ ] Complete the release requirements in `docs/fp-64-premerge-review-2026-10-09.md`, including backend-first rollout, starter-content publication awareness, host Caddy installation and targeted CDN purge.

## Worker cache release — 2026-10-09

- [x] Restore and verify worker/manifest browser/CDN headers in both production nginx variants; expand proxy regressions while preserving immutable asset caching. Reapplied the missing Docker edits and reran nginx/HTTP/TLS/maintenance checks on October 9; Sugilanon's recovery changes remained present.
- [x] Commit the Docker cache fixes (`a459648` on `FP-64`, October 9).
- [ ] Publish Docker configuration and rebuild/release the frontend image, then purge the exact FreshPrice worker/manifest URLs and require `/sw.js` no-store. Coordinate the PhilWatch legacy-worker release and affected-device checks in `instructions/sugilanon/docs/cache-recovery-2026-10-09.md`. Live FreshPrice worker headers were still four-hour max-age on October 9.

- [x] FP-43 audit fixes verified locally: suspend dialog portals/focus traps during recovery, scope recovery/probe promises to the current view/session, exempt optional layout calls from global outage handling, and restore immutable caching for hashed assets. Added passing regressions for the confirmed cases in `docs/fp-43-audit-2026-10-02.md`.

- [x] FP-43: implement and locally verify recovery screens and deployment fallback; see `docs/fp-43-recovery-runbook.md`.
- [ ] FP-43 release: integrate/validate the Caddy snippet on the actual host, run staging outage/recovery checks, deploy through the normal process, and update Jira when write access is available.

## FP-56 follow-up — 2026-10-02

- [x] Implement and verify the current **Budget Feature tightening** scope on `FP-64`; see `docs/fp-56-budget-tightening-2026-10-02.md`.
- [x] Apply existing FP-64 migrations and run database-gated budget/moderation checks in isolated PostgreSQL (30 integration tests passed, October 2).
- [ ] Run staging account-switch, multi-unit expense, Philippine-midnight, and paginated approval/rejection checks; release the backward-compatible backend before the frontend.

## Ongoing

- Keep `instructions/freshprice/docs/api-routes.md` updated whenever FreshPrice or shared platform routes used by FreshPrice change.
- Keep `instructions/freshprice/docs/database-schema.md` updated whenever FreshPrice-related Sequelize models or migrations change.
- Keep `instructions/freshprice/docs/project-spec.md` updated when FreshPrice workflows or app boundaries change.
- Keep `instructions/freshprice/docs/deployment.md` updated when Docker, nginx, environment, or deploy flows change.

## Audit Follow-Up 2026-09-12

- Use `docs/feature-audit-and-roadmap-2026-09-12.md` as the detailed mandatory/optional backlog.
- Updates 0/1 (M01–M07) are present in the current `FP-64` checkout (confirmed October 2); isolated migration and budget integration checks passed October 2; before release, perform staging access/retry/PWA checks and the normal release process. See `docs/budget-updates-0-1-2026-09-12.md`.
- Wiki update: inventory live coverage, enforce publication quality, improve draft imports, and publish an initial reviewed content batch (M08-M10).
- Add release regressions for cross-account access, 201+ expenses, failed saves, shared membership changes, and wiki publication (M11).
- Optional later: seller profiles/offers and private text chat pilots, followed by advanced budget, offline, and wiki features.
- FP-64 / sprint 335: define sprint goal, owner/reviewer, estimates and acceptance criteria. Map FP-55 to existing wiki quality/coverage work (M08–M10); deliver FP-43 maintenance readiness (M12); FP-56 now covers budget tightening (implemented locally October 2). Treat O10 external ingestion as a separate optional future item. See `docs/fp-64-sprint-review-2026-09-12.md`.

## Next Wiki Work — Tighten Existing Gaps (2026-10-02)

- [ ] **High — Verify the complete wiki workflow against a local database.** Migrations, recipe draft lifecycle, public reads, permissions and moderation persistence passed October 2. Remaining broader verification: user suggestion submission and CSV import against the database. Confirm drafts stay private, rejected suggestions leave published content unchanged, and approved changes persist after reload. Include recipe detail navigation and valid/invalid CSV imports; record actual results separately from mocked test results.
- [x] **High — Complete existing recipe editing and publishing.** Add operator-only API and admin UI support for editing saved recipes and publishing/unpublishing drafts. Preserve product association, validate fields, show save failures, and prevent duplicate saves. Verify public visibility changes and deny writes from regular users.
- [x] **Medium — Make all published recipes discoverable.** Add a view-all or paginated recipe list from the public wiki instead of stopping at six entries. Show an accurate published count, preserve back navigation, and exclude drafts. Cover products with zero, six, and more than six recipes.
- [x] **Medium — Paginate wiki and recipe moderation queues (FP-56, 2026-10-02).** Replace the fixed newest-100 limit with pagination and total counts. Preserve product/status filters, allow access to older pending suggestions, and refresh the queue correctly after approval/rejection. Cover more than 100 suggestions.
- [x] **Completion checks — Add regression coverage for these gaps.** Include database/API coverage for persistence, permissions, and moderation plus browser coverage for recipe draft → edit → publish → public view. Run frontend lint, unit tests, build, relevant Chromium E2E tests, and affected backend tests. Update API documentation and memory-bank status; do not mark runtime verification complete based only on mocked tests.

## Suggested Follow-Up

- Reconcile the September implementation claims with the 2026-10-01 audit before duplicating work; current checkout still needs fixes for expense read/create ownership enforcement and account-specific budget cache isolation first, with cross-account regression coverage.
- Correct budget summaries beyond 200 expenses, explicit expense-price unit selection, and stale-response handling.
- Standardize business dates, expose retryable loading failures, correct the current-price/history label, and deduplicate budget hydration; see `docs/existing-feature-audit-2026-10-01.md`.

- Push the `fpdocker` production nginx changes to `master` before merging or dispatching the FreshPrice frontend release, so the frontend image is built with the new service-worker cache headers.
- After the frontend deploy, purge the exact Cloudflare URLs `https://freshprice.philwatch.com/sw.js` and `https://freshprice.philwatch.com/manifest.webmanifest`; verify `/sw.js` returns `Cache-Control: no-store`, then reopen FreshPrice on a previously affected device and confirm the current product image appears.
- Commit and push the FP-54 backend `package.json` and `package-lock.json` minimatch security fix before merging the branch into `master`.
- Run `npx sequelize-cli db:migrate` during the next backend deploy to apply `20260907000001-repair-price-history-unit-constraint.cjs` and remove any lingering date-only price-history uniqueness.
- After deploying the upload replacement cleanup, replace one product image in staging/production and confirm the old managed UUID WebP is removed from `UPLOAD_DIR`.
- Add richer wiki moderation later if needed: visual field-by-field diffs, revision restore UI, trusted-domain/source-quality scoring, and recipe revision history.
- Before production deployment, run `20260817000001-create-product-wiki-tables.cjs` on a disposable PostgreSQL copy and verify both `up` and `down`; the new backend product-list query expects the wiki table to exist.
- Consider replacing the budget expense product picker with the shared searchable product selector in a later consistency pass.
- Confirm the active production nginx config and TLS certificate path use `philwatch.com` for Sugilanon, not `sugilanon.philwatch.com`.
- Confirm the active VPS TLS terminator and nginx config are aligned before switching between HTTP-only and SSL nginx images.
- Confirm the next VPS stack deploy preserves the frontend healthcheck probe against `127.0.0.1`.
- Confirm the next VPS stack deploy preserves the backend healthcheck probe against `127.0.0.1:4000`.
- After deploying the backend healthcheck fix, verify `https://freshprice.philwatch.com/api/platform/db/health` returns `{"status":"ok","database":"ready"}` and the budget setup page no longer surfaces Cloudflare 502.
- On the VPS, confirm there is no stale `CONTENT_API_BASE_URL=http://backend:4000/api` override; production defaults now use `http://freshprice_backend:4000/api`.
- Confirm manual deployment dispatch instructions match any future workflow trigger changes.
- Confirm the next `backend-updated` dispatch no longer reconciles `freshprice_sugilanon` when the backend service already exists.
- Confirm the next production stack deploy publishes Sugilanon on `SUGILANON_PORT=3001` for Caddy routing.
- Expand `database-schema.md` with per-column field details if a database-focused task is requested.
- Run a full backend production Docker image build once Docker Desktop/Linux engine is available.
- Confirm the next GitHub Actions run and VPS service health after the frontend/backend README trigger commits are pushed.

- Add troubleshooting notes after the next full local Docker run.

## Completed 2026-08-14

- Unified and modernized product detail dialogs for guest, desktop user, search, and mobile product entry points.
- Replaced the full generated product image catalog with 113 consistent flat-style assets and removed superseded Whole Chicken variants.
- Added missing Chicken Intestine and Pork Face/Maskara supplemental import coverage and verified Pork Chop mapping.

## Conflict Audit Follow-Up — 2026-10-02

- Verify live deployment state before closing historical production incidents; this documentation merge does not establish production recovery.

## FP-60 follow-up — 2026-10-19

- [x] Historical FP-60 implementation review and all three fixes completed before commit; final recorded validation is 16 feature / 30 whole-app / 266 frontend / 184 backend (23 existing opt-in skips) / 36 runner, lint/build. Current integration/staging work remains open above.
- [x] Commit/push both FP-60 branches: backend `f5834acf`, frontend `e0343e56`.
- [x] Open linked FP-60 PRs: backend #54 and frontend #52, currently based on FP-59.
- [ ] After FP-59 lands, retarget/reconcile both FP-60 PRs to master and verify the resulting diffs before merge/release.
- [ ] Rehearse FP-60 migration, concurrency and negative-permission flows on restored staging data; deploy migration/backend before frontend, preserving financial history and revision/void guards during rollback.
- [ ] Complete release verification before marking FP-60 Done; FP-61 is next in category after FP-60 review.

## FP-60 review fixes — verified locally 2026-10-19

- [x] Fix deletion confirmation to retain its original revision/amount across refresh.
- [x] Let split authors explicitly remove former beneficiaries from new correction drafts; preserve confirmed history.
- [x] Make optional-date settlement replay stable across Asia/Manila midnight, retaining authorization and changed-payload checks.
- [x] Add registered regression coverage for all three and rerun checks: 16 feature, 30 whole-app, 266 frontend, 184 backend (23 opt-in DB skips), 36 runner, lint/build. See FP-60 review fixes.

## Branch/Jira follow-up — 2026-10-20

- [x] Refresh FreshPrice origin refs and safely advance behind local FP-59 branches; verify active checkouts are clean/current with upstream.
- [x] Confirm ongoing Jira work: FP-59 and FP-60 are In Progress, both unassigned.
- [ ] Reconcile FP-60 with latest FP-59 follow-ups (`101a8342` frontend / `e4fe0bc` backend), then verify paired PR diffs and affected tests before merge/release.

## FP-61 durable offline editing — 2026-10-20

- [x] Create matching local FP-61 branches, implement account-scoped expense drafts/replay, server receipts and reviewed revision conflicts, and document release policy.
- [x] Move Jira FP-61 to In Progress after explicit user approval.
- [x] Pass all 12 feature + 30 whole-app scenarios on unchanged final app source; frontend 269, backend 186 (23 opt-in DB skips), runner 36, lint/build pass. Final feature run `2026-10-20T01-47-42-406Z-0d70bd76`; separate whole-app evidence in FP-61 coverage.
- [ ] Review local FP-61 changes before any commit/push. Retain FP-59 → FP-60 → FP-61 dependency/release order.
- [ ] Rehearse staging auth/revocation/deletion/concurrency, production shell upgrades with pending drafts and real-device storage behavior; deploy migration/backend before frontend. Keep receipts during rollback.
