# FP-60 reconciliation with current FP-59 — 2026-10-20

## Published merge commits — 2026-10-20

At the user's explicit request, created and pushed proper two-parent FP-59 → FP-60 merge commits:

- Frontend [`3372481b6797b95064e3482ed37b2c95a04e4bf9`](https://github.com/jamesabilong/fresh-price-front/commit/3372481b6797b95064e3482ed37b2c95a04e4bf9), parents e0343e56 / 101a8342. PR [52](https://github.com/jamesabilong/fresh-price-front/pull/52) is OPEN, CLEAN and MERGEABLE against FP-59.
- Backend [`e8b7f78595303546a6f846f8074f9ffcfcfef990`](https://github.com/jamesabilong/fresh-price-backend/commit/e8b7f78595303546a6f846f8074f9ffcfcfef990), parents f5834ac / e4fe0bc. PR [54](https://github.com/jamesabilong/fresh-price-backend/pull/54) is OPEN, CLEAN and MERGEABLE against FP-59.

Refreshed remote refs before merging; neither prerequisite nor FP-60 head had moved. Restored the exact verified resolutions during real merges, staged only the five expected app files and checked both committed trees byte-for-byte against the previously tested fingerprints below. No source changes or new test failures justified repeating the completed checks. Live `ls-remote` and PR heads match both commits; local/upstream counts are 0/0, tracked working trees/indexes are clean, and local testing/dependency links remain outside the commits.

The primary FP-63 branch names, heads, status and hashes of every dirty/untracked file are unchanged; FP-63 stays on hold. No Jira/sprint changes, PR landing/retargeting, FP-61 propagation or deployment. `reconciliation/fp60/publication.json` records publication. The original pre-publication state/handoff below is historical and superseded by this section.

FP-63 stays on hold. Reconciled source is prepared in isolated sibling worktrees under `reconciliation/fp60/`; the primary frontend/backend remain on their original dirty FP-63 branches. No app changes were staged, committed or pushed, and no PR, Jira status, sprint or deployment was changed. The existing FP-60 PRs are attached for navigation.

## Source and conflict resolution

| Repository | FP-60 HEAD retained | FP-59 follow-up incorporated into working files |
| --- | --- | --- |
| Frontend | e0343e5604ab952987888e4fe49833f5aca1b99d | 101a8342057eba50478d894bee9e77734c1927a2 |
| Backend | f5834acf962ae3a23b9f7bb9f1ef9a04eb8a7227 | e4fe0bc2f0f6c2a5cede18b4bc13ab9691a2ec46 |

Fetched origin before reconciliation and used `git merge-tree --write-tree` to compute the actual merge without changing either index. Applied its working-file result and resolved the two reported content conflicts:

- Frontend `vite.config.ts`: retain FP-60, FP-59, FP-65 and legacy unit discovery, using FP-59's relative external globs. The automatic source merge retains the month-end clamp in `addMonthsToIsoDate` alongside all FP-60 types/accounting behavior. Frontend `package.json` adopts the Node unit-command wrappers.
- Backend `package.json`: adopt FP-59's portable Node wrappers for unit, integration, disposable database and browser commands while retaining the FP-60 unit directory. The automatic `vitest.config.js` merge retains FP-60 discovery/serialized gated DB execution and FP-59's Vitest/dotenv aliases.

Only three frontend tracked files and two backend tracked files differ from their FP-60 HEADs. Resolution patches and the original merge-tree diagnostics are stored immediately under `reconciliation/fp60/`. Dependency symlinks are local tooling, not application changes.

## Shared test tooling and regression gaps

The shared `testing/` folder lacked `unit.mjs`, and its existing runner rejected `--database`, although both published FP-59 follow-up package files referenced those entry points. Restored portable Node argument-array unit invocation and a disposable database mode. That mode fixes database host/name/credentials and both gates, migrates a newly created localhost:55467 container, runs the complete existing integration files serially, and removes only its own container. Browser reports remain separate. Added five runner regressions covering spaced paths/argument forwarding and database isolation/cleanup on success and injected failures.

Added seven registered FP-60 frontend cases: non-leap/leap February, April, year rollover, reverse month offsets, ordinary mid-month copying, and authoritative server spending retained with accounting. An isolated original-FP-60 helper probe reproduces all five month-end failures (five failed/two passed); the reconciled helper passes all seven. The probe uses a separate test alias and never changes app source.

The first full unit run found a shared wiki pagination assertion updated for FP-62's later filter signature. It now checks stable product/page coordinates plus its existing rendered retry/navigation outcome, permitting earlier sprint branches without weakening the separate FP-62 filter tests. All executable test/tooling sources are synchronized between canonical `testing/` and the isolated sibling copy. Test assets stay outside app repositories.

## Verification

All checks pass against the unchanged final reconciled source:

| Check | Result |
| --- | --- |
| Frontend `npm run lint` | Passed |
| Frontend `npm run test:unit -- --maxWorkers=2` | 273 tests / 48 files passed |
| Frontend `npm run build` | TypeScript, Vite and PWA build passed |
| Backend `npm test` | 184 passed; 23 existing opt-in DB checks skipped |
| Backend `npm run test:integration:db` | All 36 integration checks passed; zero skips; owned migrated database cleaned up |
| Testing `npm run test:scope` | 41 passed, including five new command regressions |
| Frontend `npm run test:e2e:chromium` | All 16 feature + 30 whole-app Chromium scenarios passed, zero failures/errors/skips |
| Both app `git diff --check` | Passed |

Complete browser execution: `2026-10-20T08-51-44-309Z-89ef42c2`. JUnit counts were parsed and verified separately for both groups. HTML/JUnit/logs and `reconciliation/verification.json` are under `reconciliation/fp60/testing/reports/runs/2026-10-20T08-51-44-309Z-89ef42c2/`. Both groups ran through the actual app commands, used distinct fresh databases, and exercised the original financial, permission, concurrency, recurrence, deletion, history, public/admin/auth and production-PWA regressions. This is local evidence; staging/deployment verification remains open.

Tracked working-tree SHA-256 (sorted tracked path + NUL + file bytes + NUL): frontend `2ffe97bc70ec28e1587b03a78eb8a4d0c54a20b7deccc8a64fabce54b8e290d8`; backend `a97e134ab74434901297089238668b1eefca1c481985d0b6567417cf379e4ff3`. The primary FP-63 branch/head/status and hashes of every dirty/untracked file exactly match the pre-task snapshot; saved in `reconciliation/fp60/fp63-preservation.json`.

## Original commit/publication handoff (completed; historical)

Changes remain **unstaged and uncommitted** in:

- `reconciliation/fp60/fresh-price-front` (branch FP-60).
- `reconciliation/fp60/platform-backend` (branch FP-60).

Because the no-index reconciliation deliberately preserves the app indexes, there is no active `MERGE_HEAD` and FP-59 is not yet an ancestor of FP-60. When the user authorizes committing, preserve the prepared patches, start the real `origin/FP-59` merge from each original FP-60 HEAD, restore these exact verified resolutions, then stage and create the merge commits with both parents. Do not commit a source-only single-parent snapshot and imply the dependency ancestry is reconciled. Recheck upstream refs/source fingerprints if either remote moves. The working source is already fully resolved; remote PR conflict status can change only after proper merge commits are pushed.

Frontend PR [52](https://github.com/jamesabilong/fresh-price-front/pull/52) and backend PR [54](https://github.com/jamesabilong/fresh-price-backend/pull/54) remain unpublished at their old heads. FP-61 propagation, prerequisite landing/retargeting, staging and ordered schema/backend/frontend rollout remain separate sprint-337 work. FP-63 findings/work remain untouched and must not resume yet.
