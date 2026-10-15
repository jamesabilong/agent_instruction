# FP-65 — Multiple price observations and trends

Implemented locally: 2026-10-15. No commit, push, production migration or deployment.

## Branches and delivered behavior

- `fresh-price-front`: `FP-65`, created from current `FP-64` at `60d65371`, carrying the earlier local note-import work.
- `platform-backend`: `FP-65`, created from current `FP-64` at `56d4142`.
- Docker configuration is unaffected; no Docker source branch was needed.

Separate observation storage now retains every operator quote for the same product/market/date/unit, including repeated equal prices. Original note, quoted amount/quantity, seller/quality context and creator/batch identity are retained. Exact decimal normalization occurs on the server. Batch IDs return immutable outcomes on concurrent/lost-response retries; identical content submitted as a different batch requires explicit confirmation. Preview/import requests contain at most 500 quotes.

The paste/review UI expands each detected numeric quote into a separate row. Product selection can be applied to every quote from a source line; unit selection can be explicitly applied across the batch. Ambiguous weights/fractions remain visible for human interpretation. A server-derived statistical preview is required before save. The original official-history CSV remains available separately.

Price History adds paginated observation management, corrections and exclusion. Corrections use row locks and revision checks, retain prior values with actor/reason, and never alter the original note. Excluded/unavailable quotes stop contributing to public statistics.

Public/signed-in trend views and admin previews default to observation medians and offer mean/mode, unit and day/week controls. Official published-price views remain available. Server responses calculate daily, weekly and range statistics from raw eligible observations, fill date gaps, expose tied modes without arbitrary selection, show counts and ranges, and compare distinct periods consistently. Mode chart values are null for absent/tied modes. Missing observation history is not manufactured from older official averages.

Official current prices, daily history/publication and budget estimates keep their existing contracts. Public observation responses omit creator identities, source notes and seller labels. The additive migration is transactional; original official-price rows survive migration rollback/reapply. Account deletion nulls creator links; product/market hard deletion follows existing price ownership via cascade. New tables should be retained during application rollback after collection begins.

## Verification

- Frontend lint and production build pass; 255 unit tests pass.
- All 19 Chromium flows pass, including multi-quote review/import and statistical choices plus mobile pagination/correction/exclusion; adjacent price creation/editing, public pricing, auth, budgets, recovery and wiki flows pass.
- Backend ordinary suite: 150 tests pass, with the 23 database-gated checks skipped in that invocation.
- With both `RUN_DB_TESTS=true` and `RUN_BUDGET_DB_TESTS=true`, all 36 integration checks pass (23 real database checks plus 13 API regression checks) against disposable PostgreSQL 14.
- All migrations applied in the disposable database. Final FP-65 targeted suite: six database-backed checks pass, including transactional migration down/up over populated official prices, concurrency/replay, duplicate-content confirmation, authorization/validation, partial row outcomes, decimal correction, stale revisions, exclusion/unit filtering, public privacy and legacy official-trend compatibility.
- Initial fixture/test-selector failures were corrected (required market tags, multiple mode labels, admin versus user route navigation); the final runs above pass.

The normal app database and production data were untouched. Test container removed after verification.

## Remaining release/follow-up work

- Deploy backend migration/API before the frontend, then smoke-test real aliases, actual note batches and returning-browser caches in staging before production rollout.
- Community submission ingestion is deliberately not enabled: it needs the planned source adapter, edit/rejection synchronization and source deduplication before inclusion.
- Operator observation CSV, seller registries, standardized quality grading, seller-weighted indices and automatic official-price publication remain outside this initial operator-note release.
- Trend requests over 50,000 eligible quotes return an explicit narrowing error; future higher-volume aggregation can move to database-side statistical queries without changing quote semantics.
