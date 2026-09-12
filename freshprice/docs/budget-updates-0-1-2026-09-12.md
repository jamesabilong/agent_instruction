**FreshPrice Updates 0 and 1 — implementation and release notes**

Date: 2026-09-12. Implements M01–M07 and the budget portion of M11 from the [audit and roadmap](feature-audit-and-roadmap-2026-09-12.md). Local changes are uncommitted. No production migration, deployment, content import, or Jira mutation was performed.

**Delivered behavior**

| Measure | Local implementation |
| --- | --- |
| M01 — expense authorization | Authenticated actor overwrites untrusted identity input; expense payload allowlist; shared-only member filters; recheck existing and destination budget access during edits and deletion. Removed members retain no read/write access, while their prior expenses remain in owner history. |
| M02 — session isolation | Private budget state is in memory; old global budget-storage cache is retired. Token/account changes immediately clear it and discard late responses. Initial budget screens wait for hydration so direct links and edit forms do not initialize from missing/stale data. |
| M03 — complete totals/history | Server aggregate endpoint with shared filter semantics; 25-row history pagination; summary counts/totals independent of page; scheduled server totals preserved; current allocation totals use the current period. |
| M04 — save reliability | Confirmed server writes, visible errors, retained failed form input, navigation after successful save, stable request IDs for expense retries, stable allocation/scheduled IDs, and explicit offline status. There is no durable offline write queue. |
| M05 — allocation integrity | Managed database transactions lock parents before sums/writes, including parent shrinking. Shared expense changes serialize against membership removal. Includes opt-in PostgreSQL concurrency tests. |
| M06 — shared-budget UX/lifecycle | Budget cards with name, role, dates, spent/remaining; separate allocation/member/activity sections; owner invite/cancel/remove, seven-day invitation expiry, contributor leave, explicit delete consequences, preserved expense attribution, visible budget context during entry. |
| M07 — activity/freshness | Transactional activity and budget notification links; activity pagination; visible refresh/save/stale status; refresh on focus/reconnect/visibility and every 30 seconds while budget routes are visible and online. New activity is recorded going forward. |

Relevant shared surfaces reviewed: authenticated API client and auth store, user layout and route initialization, budget store/API contracts, expense entry/setup/history, scheduled budgets, and notification consumers. Existing public prices/admin E2E flows remain part of the regression suite.

**Verification status**

- Backend unit suite: 19 files / 117 tests passed, including actor spoofing, unauthorized filters, removed-member mutations, aggregate counts, keyed retries, parent locking, expiry, leave, and transactional notifications.
- Frontend unit suite: 31 files / 195 tests passed. Tests cover late responses across account changes, failed writes, complete server summaries, pagination/filtering, shared entry/edit permissions, and preventing a revoked shared target from becoming a personal expense.
- Frontend lint and production build: passed, including PWA generation. Existing outdated Browserslist-data warning remains informational.
- Chromium: 9 tests passed with `npm run test:e2e:chromium -- --workers=2`; includes mocked two-account invite→accept→expense retry→remove, 201-expense mobile history, retired cache, initial hydration/offline status, and adjacent admin/public routes. Mobile (390×844) and desktop screenshots were visually checked. The browser fixtures do not exercise a real database.
- PostgreSQL migration/integration/concurrency: not run. Docker Desktop's Linux engine is unavailable and no isolated local PostgreSQL instance was available. Do not treat unit lock assertions as concurrency proof.
- Production/staging requests, pilot usability, complete accessibility review, actual metrics baselines and deployment: not run.

Earlier test runs exposed a broad mock URL matcher intercepting frontend API source modules, a setup-form syntax error, and load timing failures while multiple suites/build ran concurrently. The matcher and syntax error were corrected; the final browser run uses two workers. No product behavior was weakened to satisfy those checks.

**Required release steps**

1. Use a disposable local/staging PostgreSQL database and apply all migrations, including `20260912000001-budget-reliability.cjs`. The integration test rejects non-local hosts and database names not ending `_test`; do not run it against production.
2. Set `NODE_ENV=test`, explicit `POSTGRES_HOST=127.0.0.1`, `POSTGRES_PORT`, `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` (ending `_test`), and `RUN_BUDGET_DB_TESTS=true`. Run `npx sequelize-cli db:migrate --env test`, then `npx vitest run tests/integration/budgetReliability.model.test.js`. Use credentials for that disposable database only. Validate simultaneous allocations, parent shrinking, keyed retries, 201-row totals and membership removal. The test cleans up its generated accounts.
3. Apply the additive migration before the new backend, then release the frontend. Confirm schema locks/index creation duration against staging volume; budget operations now require the new activity table and columns.
4. In staging, verify two real accounts cannot cross-read/write private budgets; accept/expire/cancel/leave/remove flows; retry after a lost response; 201+ entries and period/member/allocation summaries; active form behavior after revoked access; API failure/reconnect; direct links; and PWA refresh. Test narrow mobile and keyboard interaction.
5. For rollback, roll back application versions together while retaining additive schema initially. The down migration removes activity/request/expiry data. Restart old clients safely and confirm auth/cache behavior before restoring normal traffic.
6. Record non-content metrics baselines: save failure/retry rate, summary-vs-database discrepancies, invitation acceptance, and time to first shared expense. Pilot usability and production numbers remain outstanding.

Release limitation: Update 0/1 code is implemented locally; database verification and staging/deployment gates are still open. FP-64's wiki/maintenance/ingestion work is planning only and is described separately in the [sprint review](fp-64-sprint-review-2026-09-12.md).
