# FreshPrice existing-feature audit — 2026-10-01

Scope: local frontend and FreshPrice backend code, including shared auth and notifications. Reviewed budgets/expenses, prices/history/trends, submissions, community, and wiki moderation. No application code changed. This is not a production, browser, accessibility, or exhaustive security audit.

Validation: frontend unit tests 31 files/199 tests passed; backend unit tests 18 files/103 tests passed. Two expense authorization defects reproduced using in-memory mocks against source functions (no database writes). Other findings are code-path analysis, not live reproductions. Existing passing tests do not cover all findings below.

## Fix first

### 1. High: expense listing can override the authenticated owner

`platform-backend/src/apps/freshprice/services/expenseService.js:25` initializes the owner filter from the session, then replaces it with `memberId`, even without a scheduled budget. The route accepts this query and the controller forwards it. Mock check: authenticated user 101 with memberId 202 produces database filter `{ userId: 202 }` without any scheduled-budget access check.

Fix: permit member filtering only inside an authorized shared budget; otherwise enforce the authenticated owner. Add cross-user route/service regression tests.

### 2. High: creating an expense trusts a body-supplied user ID

`platform-backend/src/apps/freshprice/controllers/expenseController.js:52` spreads the request body after the authenticated user ID. Route validators validate fields but do not strip extra fields. Mock check: session user 101 and body userId 202 forwards userId 202 to the creation service.

Fix: allowlist expense fields and derive ownership exclusively from the session. Test attempts to create expenses under another account.

### 3. High: budget cache is shared between accounts

`fresh-price-front/src/store/budgetStore.ts:638` persists under one `budget-storage` key without an owner. `src/store/authStore.ts:24` clears auth but not budgets. Login starts hydration asynchronously, and hydration failures retain cached data. Account B can therefore see account A's cached expenses on a shared browser while loading, or indefinitely if loading fails. In-flight responses also lack an account-generation guard.

Fix: clear private state on logout/account change, scope cache by user, and discard responses belonging to a previous session. Test A → logout → B with delayed and failed hydration.

### 4. High: budget totals are calculated from incomplete expense pages

`fresh-price-front/src/store/budgetStore.ts:582` fetches only 200 expenses and ignores pagination metadata. Shared-budget requests also stop at 200. `src/features/user/budget/BudgetPage.tsx:331` and `budgetTypes.ts` calculate spending from those loaded rows. With more rows, totals can undercount spending and overstate the remaining budget; older scheduled-budget history can disappear from summaries.

Fix: obtain authoritative totals for the relevant period/scope from the backend and paginate the history separately, or fetch every page as an interim fix. Test more than 200 expenses and mixed current/scheduled budgets.

## Correctness and usability

### 5. Medium: expense price selection is ambiguous and can become stale

`fresh-price-front/src/features/user/budget/ExpenseInputScreen.tsx:237` requests one price for a market/product without a unit filter and accepts unavailable entries. It has no cancellation or request-generation guard. A slow previous selection can overwrite a newer selection's price. `src/hooks/useMarketPrices.ts:104` has the same response-order issue for price lists.

Fix: select the intended unit explicitly, check availability, clear outdated price state during loading, and guard responses. Test reversed response order and multiple units.

### 6. Medium: failures silently resemble empty or valid cached data

Budget hydration clears its loading state without reporting failure (`budgetStore.ts:632`), community loading swallows errors (`CommunityPage.tsx:75`), and expense product/market loading also swallows errors (`ExpenseInputScreen.tsx:222`). Users cannot reliably distinguish an outage from no records or current data.

Fix: visible error/retry states; mark retained data as cached and potentially outdated. Preserve useful cached content rather than replacing it with a misleading empty result.

### 7. Medium: price submission defaults to yesterday before 08:00 Philippine time

`fresh-price-front/src/features/user/prices/UserPriceSubmissionPage.tsx:18` derives today from UTC using `toISOString()`. At 00:30 Asia/Manila on October 1, that produces September 30. Daily price snapshots also use UTC (`marketPriceService.js:69`), while expense entry and budget periods use local dates.

Fix: choose a single business-date convention and use it consistently for submissions, snapshots, and date defaults. Test around Philippine midnight.

### 8. Medium: the Price History screen displays current prices

`fresh-price-front/src/features/user/products/ProductPriceHistory.tsx:26` uses the current-price list hook, but labels its heading "Price History". Its footer counts price rows as markets, although one market can have several unit rows.

Fix: rename this existing view to "Prices across markets" and count distinct market IDs. Link actual history/trends separately if desired.

### 9. Product decision: expense amounts silently round away centavos

`ExpenseInputScreen.tsx:384` rounds the entered amount; quantity calculations and expense editing also round to whole pesos. Backend expense validation explicitly requires integers. This is a system-wide whole-peso convention, not merely a display issue: ₱12.50 is saved as ₱13.

Fix: either make whole-peso entry explicit in the UI or support centavos consistently in validation, storage, calculations, and formatting. Do not change only the frontend rounding.

## Smaller optimizations

- **Duplicate budget hydration:** Login.tsx:50 and UserDashboard.tsx:21 both hydrate during login/navigation. Each hydration makes at least four requests, plus one per shared budget. Give hydration one owner, deduplicate in-flight work, and guard against older results overwriting newer state.
- **Notification polling:** useNotifications.ts polls every 30 seconds even in hidden tabs, with additional focus fetches and no in-flight deduplication. Pause hidden-tab polling, refresh on visibility, and prevent overlapping requests.
- **Wiki moderation queue:** productWikiService.js caps wiki/recipe suggestions at 100 newest rows without paging. Large queues can hide older work. Add pagination and a visible total when needed.
- **Login submission:** Login.tsx has no pending/disabled state, allowing repeated requests. Add a loading state and prevent duplicate submissions.

## Recommended sequence

1. Close both backend ownership gaps and isolate account caches.
2. Fix expense totals, unit selection, and stale request handling.
3. Standardize dates and expose load failures with retries.
4. Correct labels, clarify whole-peso behavior, and remove redundant requests.

Existing strengths to preserve: wiki moderation uses transactions and row locks; trend loading already guards cancelled responses; price submissions have separate product, market, and submission-list error states. Reuse those patterns in older screens.
