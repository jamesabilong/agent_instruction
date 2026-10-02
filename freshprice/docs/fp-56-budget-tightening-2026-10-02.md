# FP-56 — Budget Feature tightening (2026-10-02)

Source: [FP-56](https://fresh-price.atlassian.net/browse/FP-56), read through Atlassian on October 2. Its current description replaces the old “Online data web scraping” scope. Implemented and verified locally in the existing frontend/backend `FP-64` checkouts. No Jira write, commit, push, or deployment was performed. Existing migrations were later applied only to an isolated disposable test database.

## Scope and implementation

| Requirement | Result |
| --- | --- |
| Enforce expense ownership and prevent body user ID impersonation | Already present on FP-64: allowlisted create payload and session actor; member filtering requires authorized scheduled-budget access. Existing regressions pass. |
| Isolate cached budgets between accounts | Already present: in-memory private data with synchronous session reset and generation guards. Added early abandonment before follow-up hydration requests after session/write changes. |
| Accurate totals beyond 200 expenses | Already present: server aggregates separate from paginated history. Existing 201+ total and browser regressions pass. |
| Explicit, reliable expense prices | Visible unit selection; lookup filters by unit and checks availability; changing product/market/unit clears price, override, quantity and amount; stale responses are discarded. Failures have retry and manual-entry options. |
| Prevent stale price-list responses | Request generations protect rows, metadata, loading and errors; retries use the latest requested filters. |
| Visible loading failures/retry | Product/market catalog, expense price, community posts/tags, price-list filters/results and moderation queues expose retry states. Existing budget status exposes stale data and refresh errors. |
| Philippine business dates | Shared helper in each app uses Asia/Manila regardless of host/device timezone. Applied to budget scopes/status, expense defaults, submissions, price snapshots and trend date windows. Date-only values stay YYYY-MM-DD; timestamps stay UTC. |
| Comparison labels | “Prices across markets” identifies current prices and counts distinct markets in the displayed rows, not unit rows. |
| Expense precision | Preserve existing integer-peso API/storage. Manual entry/edit rejects fractional amounts. UI explicitly states whole pesos and nearest-peso rounding for quantity calculations. |
| Duplicate login budget loading | Login already no longer hydrates. Concurrent dashboard/focus/refresh hydration now shares one in-flight promise; session changes and writes invalidate it. |
| Notification polling | Skip hidden/offline requests, refresh on visibility/online/focus, and prevent overlapping requests within a session. |
| Duplicate login submissions | Synchronous submission guard plus disabled pending button; failure restores retry. |
| Wiki/recipe moderation pagination | Separate 20-row admin pages with totals, Previous/Next, stale-response protection and retry. Server validates page/limit, preserves product/status filters, and orders by createdAt plus id. Paging preserves unsaved editor content; review reloads both queues from page one. |

## Verification

- Frontend: lint, production build, 37 unit files / 218 tests pass.
- Backend: 20 unit files / 126 tests pass; all 30 API/database integration tests pass with both database gates enabled.
- Chromium: 10 flows pass (9 existing flows plus recipe editing/publishing/discovery), including budget account/cache and 201+ total coverage, failed saves, membership changes, login guards and public/admin prices.
- Added focused regressions for reversed price responses, failed-query retries, unit changes and unavailable prices, catalog/community failures, whole-peso rejection, login/refresh deduplication, notification visibility/session changes, Philippine midnight/year/leap-day boundaries, and moderation beyond 100 rows.
- Follow-up: all existing migrations passed in disposable PostgreSQL 14, and all database gates ran without skips. Added real recipe lifecycle and 121-suggestion moderation persistence checks. Browser tests use API fixtures; they are separate from database verification.

## Release notes

- Suggestion-list endpoints return `{ data, meta: { page, limit, total } }` for explicit pagination; callers without pagination keep the legacy array. Deploy backend first. The frontend tolerates old arrays and marks their moderation count incomplete.
- No new schema changes in this patch. Existing FP-64 migrations passed isolated database checks; staging checks remain before release.
- FP-55 recipe editing/publishing and complete public discovery were added in the follow-up. Broader wiki publication-quality work remains separate. External ingestion is not FP-56's current scope.
