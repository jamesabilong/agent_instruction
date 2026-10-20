# FP-61 reconciliation with updated FP-60 — 2026-10-20

## Published merge commits — 2026-10-20

At the user's explicit request, created proper two-parent FP-60 → FP-61 merge commits and pushed both origin/FP-61 branches:

- Frontend [`0d100ab525fb3bcbfde2e42b97e56b127c10d30b`](https://github.com/jamesabilong/fresh-price-front/commit/0d100ab525fb3bcbfde2e42b97e56b127c10d30b), parents 5e58884f / 3372481b. [PR #53](https://github.com/jamesabilong/fresh-price-front/pull/53) is OPEN/CLEAN/MERGEABLE against FP-60.
- Backend [`1d1fa16985330b923cca20631d4e7c2a86a37af2`](https://github.com/jamesabilong/fresh-price-backend/commit/1d1fa16985330b923cca20631d4e7c2a86a37af2), parents a394105d / e8b7f78. [PR #55](https://github.com/jamesabilong/fresh-price-backend/pull/55) is OPEN/CLEAN/MERGEABLE against FP-60.

Refreshed refs before committing; both FP-61 published heads and prerequisite FP-60 refs were unchanged. Restored the prepared resolutions into actual merges, staged only the two expected files per app, verified the staged and committed trees against the exact tested fingerprints below, and checked both parent lists. Published refs/PR heads match the commits; local/upstream counts are 0/0 and tracked working trees/indexes are clean. No source changed during publication, so the recorded passing checks apply without another test rerun. Local dependency links/testing assets/reports remain outside app commits.

FP-63 primary branch names, heads, full status and hashes of every dirty/untracked file remain identical to the saved preservation record. FP-63 stays on hold. No master merge, PR retargeting, Jira/sprint change or deployment. `reconciliation/fp61/publication.json` and a copy in the final run's reconciliation evidence record publication. The original local preparation/handoff below is historical and superseded by this section. Final review/current-head release evidence, staging and ordered deployment remain pending.

Prepared conflict resolutions in isolated FP-61 worktrees. The primary frontend/backend checkouts remain on their original unfinished FP-63 branches; FP-63 stays on hold. No staging, commit, push, PR update, Jira/sprint change or deployment is included in this task.

## Baselines and resolution

| Repository | FP-61 HEAD retained | Updated FP-60 incorporated into working files |
| --- | --- | --- |
| Frontend | 5e58884fad6d202609992777ff1ed4f0d1f2ea0d | 3372481b6797b95064e3482ed37b2c95a04e4bf9 |
| Backend | a394105d3594f6d47586e48ac27b0db5998ebf68 | e8b7f78595303546a6f846f8074f9ffcfcfef990 |

Fetched origin before reconciliation and verified local FP-61 matches its published head. Existing worktrees were FP-60 only; created `reconciliation/fp61/fresh-price-front` and `reconciliation/fp61/platform-backend`, with a separate sibling `testing/` copy. Dependency links reuse installed app libraries. The isolated tests import the FP-61 worktrees, not primary FP-63 application source.

Used `git merge-tree --write-tree HEAD origin/FP-60` to compute both merges without modifying the indexes. Saved original diagnostics and applied the working-file result, then resolved:

- Frontend `vite.config.ts`: retain FP-61, FP-60, FP-59, legacy and FP-65 unit discovery using the relative external globs from reconciled FP-60. The incoming `package.json` change adopts portable Node unit/watch/UI/coverage wrappers. FP-61's existing monthly clamp already equals updated FP-60 and is preserved.
- Backend `package.json`: use the portable unit/integration/database/browser wrappers while explicitly retaining FP-61 and FP-60 unit paths alongside all prerequisite suites. Automatic `vitest.config.js` merge retains FP-61 discovery, serial gated database execution, and incoming Vitest/dotenv aliases.

Only `package.json` and `vite.config.ts` differ from frontend HEAD; only `package.json` and `vitest.config.js` differ from backend HEAD. Neither app's `src/` differs from its original FP-61 HEAD. Durable receipts, queue/auth/privacy/disposal/conflict guards, financial/revision protections and all five sprint migrations are preserved. There are no FP-62/63 additions in these worktrees.

The existing registered regression suites cover this integration: all FP-61 replay/disposal/conflict tests, prior FP-60 money/accounting/review tests, seven calendar/server-total regressions added during FP-60 reconciliation, and shared command/isolation/cleanup regressions remain active. No application behavior change required new implementation-mirroring tests; complete discovery counts and actual command execution verify that neither side's suites were dropped. Canonical and isolated testing assets match.

## Test-harness findings and corrections

Initial full execution `2026-10-20T09-15-10-945Z-f99a243a` ran 9/15 feature scenarios successfully and all 30 whole-app scenarios. Failures exposed harness assumptions and dev-server interference: a status query also matched the hidden recovery sync-center copy; traces show HMR invalidating React contexts and store modules during offline transitions; direct offline imports requested URLs not explicitly loaded beforehand; a lease test inspected an intermediate syncing state while another foreground pass finished.

Kept application source unchanged. Added standalone `testing/vite.e2e.config.ts` inheriting the app config with watcher/HMR disabled for fixed-snapshot acceptance, used by the local Playwright harness only. Warm auth/budget-store module URLs online, scope restart confirmation to the actual draft's visible status, and poll completion of lease recovery with an additional persisted amount/revision assertion. All registered scenarios, real API/DB responses and existing timeout limits remain. Normal development retains its original watcher/HMR configuration; production PWA tests still use the actual build and persistent browser restart. Initial failure traces/reports remain available. The next complete invocation `2026-10-20T09-18-56-170Z-25427bb5` passes 14/15 feature cases: the remaining mobile assertion is blocked by the first-use budget tutorial, confirmed in its screenshot. Its setup now completes the tutorial through the visible Skip action before going offline; the production restart, pending-state and exact-one-expense assertions remain. Final full rerun results below supersede these attempts.

## Verification

All required checks pass against unchanged final app source:

| Check | Result |
| --- | --- |
| Frontend `npm run lint` | Passed |
| Frontend `npm run test:unit -- --maxWorkers=2` | 279 passed / 50 files |
| Frontend `npm run build` | TypeScript, Vite and PWA passed |
| Backend `npm test` | 186 ordinary passed; 23 existing opt-in DB checks skipped |
| Backend `npm run test:unit` | 173 passed, explicitly exercises the merged FP-61/FP-60 unit command |
| Backend `npm run test:integration:db` | 36 integration checks passed, both gates enabled, zero skips; fresh migrated owned PostgreSQL |
| Sibling testing `npm run test:scope` | 41 passed |
| Frontend `npm run test:e2e:chromium` | All 15 feature + 30 whole-app passed in one final execution, zero failures/errors/skips |
| Both app `git diff --check` | Passed |

Final complete browser execution: `2026-10-20T09-23-26-688Z-5def1a3c`. Parsed JUnit independently confirms 15+30 and no failures/errors/skips. Reports/HTML/JUnit and preserved command logs/`reconciliation/verification.json` are under `reconciliation/fp61/testing/reports/runs/2026-10-20T09-23-26-688Z-5def1a3c/`. Summary also saved in `reconciliation/fp61/verification.json`. The unchanged application source applies to the unit/build/database and browser results; the harness corrections affect only standalone browser setup. Earlier attempts remain historical and do not substitute for this complete passing run.

Tracked working-tree SHA-256 (sorted tracked path + NUL + file bytes + NUL): frontend `c360afb8db376183187ea081ac57994e6408b71fa83daec7b6a50157e286c565`; backend `47e3c642bb697f503eb98cb124a174814a354cffd163c8d7cd874e38ff3675f8`. Final source/index/FP-63 preservation checks pass. Transient duplicate package/config files matching original FP-61 bytes were retained outside app trees in `transient-filesystem-copies/`; no test or original application work was deleted. Local results do not replace staging, real-device or production verification.

## Original preservation and commit handoff (completed; historical)

All four app changes remain **unstaged/uncommitted** in `reconciliation/fp61/`. Original merge-tree diagnostics, exact resolution patches, baseline/fingerprint state and primary FP-63 preservation evidence are saved immediately under that folder. Both original dirty FP-63 branches, heads, status and hashes of every modified/untracked file must continue matching `fp63-preservation.json`.

No active `MERGE_HEAD` was created by the no-index preparation. When the user requests committing, snapshot these verified files/patches; restore only these prepared working-file changes to the original FP-61 HEADs; start proper `origin/FP-60` merges; restore the verified resolutions; explicitly stage the two expected files per app; check the exact staged trees; then create two-parent merge commits. Confirm remotes have not moved. Do not replace this with a single-parent source snapshot that omits prerequisite ancestry. Preserve standalone tests/tooling/reports outside both app commits.

Frontend [PR #53](https://github.com/jamesabilong/fresh-price-front/pull/53) and backend [PR #55](https://github.com/jamesabilong/fresh-price-backend/pull/55) keep their published heads and conflict status until proper commits are pushed. Source resolution and local verification do not change GitHub's view by themselves.

Sprint 337 still requires publication, final review/current-head evidence, restored-data staging and the ordered FP-59 → FP-60 → FP-61 migration/backend/frontend release in the [release runbook](sprint-337-release-audit-and-runbook-2026-10-20.md). FP-63 stays on hold; no production readiness is claimed from local fixtures.
