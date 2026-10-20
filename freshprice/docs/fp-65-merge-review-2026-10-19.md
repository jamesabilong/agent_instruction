# FP-65 merge review — 2026-10-19

Follow-up: all five findings below are now fixed locally and revalidated. See `fp-65-gap-fixes-2026-10-19.md` for current readiness and results. This document preserves the original review evidence.

Recommendation: hold the “ready with no gaps” sign-off. The earlier picker and archived-market bugs are fixed, but an admin filtering acceptance gap and test-confidence issues remain. Application/test implementation was not changed during this review.

## Reviewed state

- Jira FP-65, “Multiple price support”, remains In Progress. Reviewed its full description and nine acceptance criteria directly from Jira.
- Freshly fetched frontend `9ddf4dc020fcb97eb8d12c9ade67c3fb3115aece` and backend `af93cfd0fe4b5911eac36ad162b54aaf68fa81f5` match their remote FP-65 branches; application working trees were clean.
- Frontend master `f2877d52` and backend master `64b4bdc` each contain one merge commit absent from FP-65. `git merge-tree --write-tree HEAD origin/master` succeeds in both repositories without conflicts. FP-65 has two frontend commits and one backend commit beyond the common ancestors.
- GitHub lists no FP-65 pull requests in either repository, including closed/merged requests. No PR checks, approvals or branch-rule eligibility can therefore be certified.

## Findings

### P2 — Admin observation preview ignores the selected market

Jira explicitly requires market and unit filters in admin statistical previews. `fresh-price-front/src/features/admin/price/PriceHistoryPage.tsx:151` updates the history market filter, but its `TrendPreview` invocation at line 231 passes only product ID/name. `TrendPreview.tsx:24–27` accepts no market, and line 61 mounts `ObservationTrends` without a market ID. The shared observation component offers statistic, unit and interval controls, with no market selector of its own.

Consequently selecting one market in Price History still requests observation statistics for all markets. Changing the history market cannot update that observation request. This can show a pooled median/mean/mode alongside market-filtered records. Pass the selected market into the preview and API, or provide a clearly scoped market control in the preview. Verify with two markets whose statistics differ, including switching back to all markets.

Confirmed in an additional real Chromium session against the disposable whole-app API: selected Ginger, then Carbon Market (ID 1). Both initial trend requests omitted `marketId`; after selecting Carbon, the history request completed successfully but the observation request count remained unchanged (2 before, 2 after). No data was changed by this diagnostic.

### P2 — Database migration test interferes with parallel integration files

Fresh migrated, dedicated PostgreSQL 14 database, both DB gates enabled: the default parallel integration run returned 35 passes and one failure, `SequelizeDatabaseError: deadlock detected`, at `testing/tickets/FP-65/backend/integration/priceObservation.model.test.js:40`. That test drops/recreates shared observation tables while other files use the same database; the backend Vitest configuration leaves file parallelism enabled. This is a test-isolation finding, not evidence of a production forward-migration failure. Run schema rollback tests in their own database or serialize the database suite explicitly.

A second fresh database with `--no-file-parallelism` passes all 36 integration checks, including rollback/reapply. This supports parallel test interference as the cause; the suite configuration/commands were left unchanged.

### Existing test-confidence findings remain unresolved

The three October 15 findings remain in source: stale HTML/XML reports after setup failure, page-shell-only checks for some whole-app routes, and feature authentication headers built from the literal `cookie-session` response marker rather than a captured session cookie. See `testing-suite-audit-2026-10-15.md`. During this review the first sandbox-restricted Docker attempt failed before Playwright while old reports remained; it was rerun with Docker access. Do not treat old report pages as evidence for a newer failed attempt.

Tests intentionally live in the local sibling `testing/` workspace. This follows the existing workspace policy, but a clean remote app checkout cannot independently execute the suites without those assets. No remote CI success is claimed.

## Fresh verification

- Frontend lint, 255 unit tests and production build pass.
- Ordinary backend suite: 152 pass, 23 DB-gated skips.
- Runner/generator checks: 27 pass.
- Mocked Chromium regression suite: 19 pass.
- Real seeded feature group: 9/9 pass, including settled empty-picker/reselection, archived-market correction/exclusion, persisted statistical calculations and lost-response replay.
- Serialized database integration run with both DB gates enabled: 36/36 pass, including migration rollback/reapply. Default parallel execution: 35 pass, one migration-test deadlock.
- Full whole-app rerun: 30/30 pass; default combined seeded execution finishes with 39/39 passes and zero skips/failures. Both runner-owned containers were removed.
- Deployment maintenance parser checks: 3/3 pass.

## Release constraints

The backend migration must precede the frontend release, and collected observation tables must survive application rollback. Existing staging/actual-host checks remain open; local disposable-data and preview checks do not certify production/CDN behavior. Community submission ingestion is explicitly permitted as later scope by the ticket and is not a missing initial-delivery requirement.

No application changes, commits, pushes, merges, Jira writes or deployments were performed.
