# Backend search and pagination audit — October 26, 2026

Historical local audit checkpoint: three classes of bugs were fixed on `fix/backend-pagination-audit`, based on backend `72861ee0`. **These corrections were subsequently reviewed, merged and deployed through [backend PR #62](backend-pagination-deployment-2026-10-26.md).** The user requested the backend audit/fixes, database-backed regressions and instruction publication. The existing PhilWatch nonempty-search fix remains deployed through backend PR #61. Exemptions remain disabled; no authentication, identity, exemption configuration or production resource was changed by this audit.

[Sanitized evidence and source/test hashes](../evidence/backend-pagination-audit-2026-10-26.json), [deployed search fix](../../sugilanon/docs/content-search-fix-2026-10-26.md).

## Confirmed findings and local corrections

1. Community `hot`/`top` selected a page of newest posts, then sorted that page in JavaScript. An older high-ranking post could appear on a later page even when it should lead page one. Rank is now calculated/selected by PostgreSQL and ordered **before LIMIT/OFFSET**. The selected rank alias works through Sequelize's inner article page and outer association hydration query. Vote subtraction uses bigint; future timestamps have zero minimum age to avoid invalid hot-score powers. `newest`, score/date ties and hidden/admin visibility retain explicit deterministic rules; the internal score is not exposed in public output.
2. A community tag filter was applied directly to the included tags. Matching posts were returned with only the selected tag, hiding their other tags. A correlated EXISTS now selects posts independently of the full tag hydration. The requested numeric tag is escaped; distinct totals, author privacy and the viewer's vote annotation remain intact. Later unfiltered calls do not inherit a tag restriction.
3. Public articles, source drafts and current/history prices had nonunique ORDER BY keys. Equal timestamps or multiple units for the same market/product allowed page boundaries to repeat/reorder/omit records. Unique IDs now follow the existing primary sort fields. Community and admin-content lists receive the same deterministic tie-breaker; the original admin-content fixture happened to return the desired order, so its additional ID is hardening rather than a separately demonstrated failure.

Content uses ID descending after its existing dates; community uses date descending/ID descending after the chosen rank. Current prices and price history retain their existing product/market/date ascending keys, followed by ID ascending. No migration or new dependency is required. No numeric proxy trust, limiter, role or exemption behavior was changed.

## Reviewed query shapes

Reviewed all **15 Sequelize findAndCountAll call sites**, including dynamic model consumers, plus the raw seasonal list/count query and backend ILIKE/shared-include/post-fetch-sort patterns.

| Area | Audit result |
| --- | --- |
| Community posts | Correct full-set ranking, preserve all tags after filtering, add unique tie-breaker |
| Public/admin articles and source drafts | Retain prior escaped search EXISTS/per-call include isolation; add final ID order |
| Current prices/history | Belongs-to joins preserve cardinality; add ID across tied unit rows |
| Own/admin price submissions | Existing distinct counts, belongs-to includes and price-date/ID order; unchanged |
| Expenses | Existing scoped filter, belongs-to user and date/creation/ID order; unchanged |
| Wiki/recipe suggestions | Existing base-row filters and creation/ID order; unchanged |
| Recipes | Root-column escaped ILIKE and title/ID order; new real PostgreSQL literal/privacy checks pass unchanged |
| Enrichment/seasonal browse | Existing stable ID order and common raw SQL list/count predicates; unchanged |
| Budget activity/accounting | Existing base-budget filters, belongs-to users or no joins, creation/ID order; unchanged |
| Price observations | Existing root-row predicates, belongs-to product/market and date/ID order; unchanged |

No further joined-alias pagination 500 was found in these reviewed search shapes. This is a scoped source review with regression coverage for the findings, not an exhaustive functional, boundary-input, concurrent-edit or performance certification of every endpoint. Offset pagination still allows datasets/ranks to move between independent requests when posts/votes/content change; no snapshot/cursor contract was added.

## Real PostgreSQL regression evidence

Two new local-only suites are automatically discovered by the existing database command:

- `testing/legacy/backend/integration/communityPagination.api.test.js`: eight cases for global hot/top pages, hidden/admin visibility, full tag hydration/distinct totals, filter isolation, deterministic tied pages, viewer vote annotation/rank privacy, and a future-timestamp hot query. Uses the actual router/controller/service and PostgreSQL, with the existing request/response transport harness.
- `testing/legacy/backend/integration/paginationOrder.model.test.js`: eight cases for tied public/admin article/source-draft pages, current/history multi-unit price pages after ordinary row updates, and unchanged literal `%`, `_` and SQL-shaped recipe searches with draft exclusion.

The corrected red baseline has **10 failures and 51 passes (61 cases, zero skips)** before the fixes. Six community and four content/price ordering assertions fail. A later guard for future timestamps adds the 62nd case. After the fixes, the complete database-enabled suite passes **62/62**, including all **16 new actual PostgreSQL regressions**, and shared backend units pass **271/271**, zero skips. The full database-enabled suite retains existing mock-backed transport cases; the 16 new tests use real database queries/results rather than mocked successes. Syntax and whitespace checks pass for all changed backend files.

Initial fixture setup omitted the required market tags array and was corrected before the valid red baseline. The first fixed-source run passed the new database cases but found one old mocked-query expectation that omitted the new price ID order; it was updated along with its unit equivalent, and the complete suite was rerun. No assertion/scenario was dropped to obtain the passing result.

```sh
npm --prefix platform-backend run test:integration:db
npm --prefix platform-backend run test:unit
node --check platform-backend/src/services/communityService.js
node --check platform-backend/src/apps/sugilanon/services/contentService.js
node --check platform-backend/src/apps/freshprice/services/marketPriceService.js
git -C platform-backend diff --check
```

Each database run creates its own localhost PostgreSQL 14 container/database, applies actual migrations through 42, seeds only synthetic fixtures and cleans up its owned container/volumes. Tests refuse non-local/non-test database targets. Fixture/test source and raw logs remain outside app and instruction Git publication in `testing/` and owner-protected `/private/tmp/backend-pagination-audit-20261026/`.

## Handoff and current production state

The three changed backend source files are `src/services/communityService.js`, `src/apps/sugilanon/services/contentService.js`, and `src/apps/freshprice/services/marketPriceService.js`. They were local/uncommitted at this audit checkpoint and are now published/deployed in the linked subsequent release. At the original audit checkpoint, the verified production baseline was the search-fix release. The subsequent [pagination release](backend-pagination-deployment-2026-10-26.md) is now the current verified backend and resolves these ranking/tag/tie findings in production. There was no live probe, migration, backup export, service update, credential change or exemption operation in this audit. Keep AUTH_TEST_EXEMPTIONS_ENABLED=false during any later release and verify the exact image, public lists, private data boundaries and preserved DB/guard/runtime.
