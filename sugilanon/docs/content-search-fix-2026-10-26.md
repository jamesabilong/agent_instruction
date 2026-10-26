# PhilWatch nonempty search fix — October 26, 2026

The nonempty search 500 is fixed, merged and deployed through [backend PR #61](https://github.com/jamesabilong/fresh-price-backend/pull/61). The user explicitly authorized publishing/merging/deploying the verified fix after the initial local checks. Both public API paths and the internal content reader now return 200 for nonempty queries. Exemptions remain disabled with zero rules and audit events; protected identity configuration is unchanged.

[Sanitized evidence](../evidence/content-search-fix-2026-10-26.json), [production finding](../../freshprice/docs/fp-66-deployment-2026-10-26.md).

## Cause and change

Sequelize's `findAndCountAll` selects a page of articles in a subquery before hydrating multi-valued tags/sources. The original top-level OR referenced `$category.name$` and `$tags.name$`; those aliases are not present in that pagination subquery. Real PostgreSQL reproduces `missing FROM-clause entry for table "category"`, including nonmatching nonempty searches.

`platform-backend/src/apps/sugilanon/services/contentService.js` now uses correlated EXISTS predicates for category/tag name matching. Table and column identifiers are static; the user-derived ILIKE pattern passes through Sequelize's PostgreSQL escaping before inclusion. Existing text-field matching, case-insensitive substring/wildcard behavior, published-only visibility, ordering, distinct counts, page limits and full public association serialization are retained. Pagination is still applied to articles before joins, so articles with multiple tags/sources do not consume several page positions or lose unmatched tags. No migration or frontend change is needed.

The per-request association options are also cloned before applying category restrictions. The original shallow array copy allowed `where`/`required` to persist on the shared category include and affect later global searches. The new database regression covers filtered followed by unfiltered requests.

## Database-backed regression and validation

Added local-only `testing/legacy/backend/integration/contentSearch.api.test.js`, automatically discovered by the existing backend integration command. It exercises the actual content router, validation/controller, service and Sequelize against a freshly migrated PostgreSQL 14 database; successful service/database responses are not mocked. The shared router harness supplies the request/response transport, so this is database-backed route coverage rather than a deployed HTTP/CDN claim.

Ten regressions cover nonmatching queries; case-insensitive title, summary, body, category and tag matches; draft exclusion/public author privacy; multi-tag/source article pagination/counts/order/full associations; category intersection and subsequent global search; apostrophes/injection-shaped input; and the `/articles?q=` consumer of the same function.

Before the fix: all 10 new regressions failed with the SQL error; the existing 36 database checks passed. After the fix: all **46 database checks and 271 backend unit tests pass**, zero skips. JavaScript syntax and diff whitespace pass. Each database execution used a fresh runner-owned local database with synthetic fixtures and migrations through 42; cleanup removed its container/volumes. No production dump or fixture was used, and no production mutation was run.

```sh
npm --prefix platform-backend run test:integration:db
npm --prefix platform-backend run test:unit
node --check platform-backend/src/apps/sugilanon/services/contentService.js
git -C platform-backend diff --check
```

Tests/fixtures/logs remain in local `testing/` and `/private/tmp/philwatch-search-20261026/`, outside app and instruction Git publication. Run the complete database command with Docker available; the regression retains the existing RUN_DB_TESTS guard and refuses a non-local database or a database name not ending in `_test`. No exemption was enabled or created. The authorized publication and actual runtime checks are recorded below.

## Authorized production release and final verification

Candidate `dc1cd236ff15d3be6c8aa0ed16f51d893a8ff098` merged as `72861ee0c309ef2c4ef2608803f70d360a633648`; the merged tree equals the tested candidate. Backend source-trigger run `40272515955` and [Docker deployment 40272525191](https://github.com/jamesabilong/fpdocker/actions/runs/40272525191) succeeded using Docker `6b5ce18c`. The workflow checked out the intended merged source. The published digest matches the actual running backend image:

`sha256:d9c01eccf97abe448a5027bdcfe41ae7d5de65384c7409405b2baa854b458f36`

Shipped search-service SHA-256 equals tested source `72cde73b78b280dd0bad9e0f5ae68c7ee3f911e437c1d30e2b267546404c8250`. Fifteen live public GET checks pass: `q=fp66` and `q=PhilWatch` search plus article-list queries through both FreshPrice and PhilWatch, app/DB/auth readiness, anonymous testing-exemption access denied with 401, and PhilWatch search SSR. The server-only content reader's same nonempty searches return 200; auth remains denied with 403. Correct API responses have empty data/zero totals because production published content is still empty. Successful populated matches/pagination/privacy are established by the isolated synthetic PostgreSQL regressions, not invented production data.

Four services are healthy. PostgreSQL/frontend/PhilWatch service specs and actual images are unchanged; backend spec changed only image/force-update. Protected app/Caddy runtime files, Caddyfile and systemd drop-in hashes are unchanged. Caddy's active config equals the environment-adapted file; authenticated-edge mode remains active. Database identity/volume, 42-migration inventory and fresh private connectivity pass; PostgreSQL remains unpublished and its guard active/enabled. Final exemption rule and audit counts are both zero, with AUTH_TEST_EXEMPTIONS_ENABLED=false.

Protected pre-update service/configuration metadata is under `/var/backups/freshprice/philwatch-search-20261026T050800Z`. The earlier same-day migration-42 full isolated restore checkpoint remains `/var/backups/freshprice/fp-restore-20261026T041156Z-2388254`; this code-only fix required no migration/config changes. Existing off-host/global-role/config-reconstruction, atomic uploads/DB and waived physical-device/PWA limits remain; this update does not recertify them. No production mutation fixture or login exemption was created. No Jira transition was performed.

Publication/release commands included:

```sh
git -C platform-backend push --set-upstream origin HEAD:refs/heads/fix/philwatch-content-search
gh pr create --repo jamesabilong/fresh-price-backend --base master --head fix/philwatch-content-search --title 'fix(sugilanon): correct nonempty content search' --body-file /private/tmp/philwatch-search-20261026/pr-body.md
gh pr merge 61 --repo jamesabilong/fresh-price-backend --merge --match-head-commit dc1cd236ff15d3be6c8aa0ed16f51d893a8ff098
gh run watch 40272525191 --repo jamesabilong/fpdocker --exit-status --interval 20
```

Raw workflow logs and runtime scripts remain in owner-protected local operation storage; only allowlisted sanitized evidence is published. Updated agent instructions record the released fix and keep the disabled-exemption contract.
