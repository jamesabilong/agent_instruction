# FreshPrice API Routes Investigation

## FP-59 local contract — 2026-10-19

The following routes exist on the current frontend/backend FP-59 branches. Real PostgreSQL and cookie-authenticated browser verification are recorded in the FP-59 verification notes; production rollout is not established. All paths below are under `/api/freshprice/user` and require authentication.

| Method and path | Contract |
| --- | --- |
| `PATCH /scheduled-budgets/:id/collaborators/:userId/role` | Owner sets `role` to `contributor` or `viewer`; existing members default to contributor. |
| `GET /scheduled-budgets/:id/ownership-transfer` | Owner/intended recipient can inspect the pending transfer; returns null when no response is needed. |
| `POST /scheduled-budgets/:id/ownership-transfer` | Owner requests an accepted member using `toUserId`; seven-day expiry. |
| `POST /scheduled-budgets/:id/ownership-transfer/:transferId` | Intended recipient accepts/declines; current owner can cancel. Successful retries are harmless, stale membership/request IDs cannot execute another transfer. |
| `GET /budget-recurring-templates` | Lists only the authenticated creator's private monthly templates. |
| `POST /scheduled-budgets/:id/recurring-template` | Owner snapshots budget/allocations using a client UUID `id`; no expenses or memberships copied. |
| `PATCH /budget-recurring-templates/:templateId` | Creator sets `status` to active, paused or cancelled; cancellation is permanent. Resume skips missed starts. |
| `POST /budget-recurring-templates/:templateId/generate` | Creator requests due instances now; future dates are not generated early. |

Lifecycle responses use `{ success: true, data }`. Ownership acceptance changes the single `scheduled_budgets.user_id` owner and makes the former owner an accepted contributor. Viewers can read shared data but expense mutations recheck current role under the parent budget lock. Contributors can mutate only their own expenses while membership remains active. Current daily/monthly budgets remain personal.

Templates remain with their creator if the source is deleted or changes owner. Each monthly instance is private, contains independent allocations and no copied actual expenses, and clamps dates from the original calendar anchors. The hourly due worker can be disabled with `FRESHPRICE_RECURRING_BUDGETS=false`; tests invoke its work against disposable databases with automatic scheduling disabled.

> Checkout caveat (2026-10-02): September budget reliability additions below describe imported implementation notes; the current frontend/backend master checkout still has the older expense ownership/cache/pagination paths. Verify the corresponding implementation commits before relying on those additions as available APIs or schema.

Last investigated: 2026-09-12 (budget reliability additions; other inventory retained)

FreshPrice uses `/api/freshprice/*` for app-owned APIs and `/api/platform/*` for shared auth, user, upload, community, and health APIs.

## Top-Level Relevant Namespaces

| Prefix | Owner | Notes |
| --- | --- | --- |
| `/api/platform` | Shared platform services | Auth, users, uploads, community, DB health |
| `/api/freshprice` | FreshPrice app | Product, market, price, budget, expense APIs |
| `/api/vegetables` | Removed legacy route | Returns 410; use `/api/freshprice/products` |

## Platform Routes Used By FreshPrice

### `/api/platform/auth`

- `GET /`
- `POST /login`
- `GET /me`
- `POST /register`
- `POST /change-password`
- `POST /logout`
- `POST /reset-password`
- `POST /reset-password/confirm`

### `/api/platform/users`

All routes require auth. List/create/delete require operator role. Read/update require self or operator.

- `GET /`
- `GET /:id`
- `POST /`
- `PUT /:id`
- `DELETE /:id`

### `/api/platform/db`

- `GET /`
- `GET /health`

### `/api/platform/uploads`

- `GET /:filename`
- `HEAD /:filename`
- `POST /vegetable`
- `POST /product`

Image reads are public. Upload mutations require auth and operator role, accept
one `image` multipart file only, and allow JPEG, PNG, or WebP inputs up to 5 MB.
Uploaded images are decoded, verified as JPEG/PNG/WebP content, auto-oriented,
resized within the configured max dimension, and stored as WebP.

### `/api/platform/community`

- `GET /tags`
- `POST /tags`
- `GET /posts`
- `POST /posts`
- `GET /posts/:id`
- `PATCH /posts/:id/status`
- `POST /posts/:id/vote`
- `DELETE /posts/:id/vote`
- `POST /posts/:id/comments`
- `POST /comments/:id/vote`
- `DELETE /comments/:id/vote`
- `GET /users/:username/activity`

## FreshPrice Routes

### `/api/freshprice/products`

- `GET /`
- `GET /:id`
- `GET /:id/wiki`
- `GET /:id/wiki/admin`
- `PUT /:id/wiki`
- `POST /:id/wiki/suggestions`
- `GET /:id/wiki/suggestions`
- `POST /:id/wiki/suggestions/:suggestionId/approve`
- `POST /:id/wiki/suggestions/:suggestionId/reject`
- `GET /:id/wiki/revisions`
- `GET /:id/wiki/recipes`
- `POST /:id/wiki/recipes`
- `PUT /:id/wiki/recipes/:recipeId` (operator-only edit/publish/unpublish)
- `POST /:id/wiki/recipes/suggestions`
- `GET /:id/wiki/recipes/suggestions`
- `POST /:id/wiki/recipes/suggestions/:suggestionId/approve`
- `POST /:id/wiki/recipes/suggestions/:suggestionId/reject`
- `GET /:id/wiki/recipes/:recipeId`
- `POST /`
- `POST /import-csv`
- `POST /wiki/import-csv`
- `PUT /:id`
- `DELETE /:id`

Mutations require auth and operator role.
Public wiki reads only return published wiki and recipe content. `GET /:id/wiki/admin`, wiki/recipe creation, wiki import, suggestion review, and revision listing require operator role. Logged-in users can suggest wiki edits and recipes.
Wiki suggestion endpoints are limited to 20 requests per authenticated user per hour. Wiki imports accept at most 500 rows, reject duplicate or ambiguous product matches, return row-level errors, and return HTTP 422 when every row fails. Wiki and recipe source URLs must use HTTP(S).

### `/api/freshprice/markets`

- `GET /`
- `GET /:id`
- `POST /`
- `POST /import-csv`
- `PUT /:id`
- `DELETE /:id`

Mutations require auth and operator role.

### `/api/freshprice/market-prices`

- `GET /`
- `POST /`
- `PUT /:marketId/:productId/:unitType`
- `PUT /:marketId/:productId`
- `GET /history`
- `POST /history`
- `POST /history/bulk`
- `GET /trends/:productId`
- `PUT /submissions/mine`
- `GET /submissions/mine`
- `GET /submissions`
- `POST /submissions/:id/reject`
- `POST /daily-prices/publish`

Operator role is required for current price mutations, history writes, listing all submissions, rejecting submissions, and publishing daily prices. Regular authenticated users can upsert and list their own submissions.

### `/api/freshprice/user`

Budget and expense routes require auth.

- `GET /budget`
- `PUT /budget`
- `DELETE /budget`
- `PUT /budget/sub-budgets/:subBudgetId?`
- `DELETE /budget/sub-budgets/:subBudgetId`
- `GET /expenses`
- `GET /expenses/summary`
- `POST /expenses`
- `PUT /expenses/:id`
- `DELETE /expenses/:id`
- `GET /scheduled-budgets`
- `PUT /scheduled-budgets/:id`
- `DELETE /scheduled-budgets/:id`
- `PUT /scheduled-budgets/:id/sub-budgets/:subBudgetId?`
- `DELETE /scheduled-budgets/:id/sub-budgets/:subBudgetId`
- `GET /scheduled-budget-invitations`
- `POST /scheduled-budget-invitations/:id/accept`
- `POST /scheduled-budget-invitations/:id/decline`
- `POST /scheduled-budgets/:id/invitations`
- `DELETE /scheduled-budgets/:id/collaborators/:userId`
- `POST /scheduled-budgets/:id/leave`
- `GET /scheduled-budgets/:id/activity`

### Budget contract additions — 2026-09-12

- Expense actor/ownership comes from authentication only. The create controller allowlists fields; supplied body/query `userId` cannot select another actor. Editing/deleting requires the original expense owner and continued access to its shared budget, even when moving the expense elsewhere.
- `GET /expenses` returns `{ success, data, meta: { total, page, limit } }`; limit is capped at 200. Ordering is date, creation time, then ID. `GET /expenses/summary` returns `{ success, data: { total, count, groups } }`; each group contains category, current/scheduled sub-budget IDs, spent and count. Summary includes every matching row, independent of page/limit.
- Both reads use the same scope/filter rules. `scope=current` includes only the actor's non-scheduled expenses. Default/`scope=all` returns the actor's own expenses in current and still-accessible scheduled budgets. `scheduledBudgetId` requires owner or accepted-member access and returns all members' expenses. `memberId` requires that authorized scheduled scope; an unscoped member filter returns 400. `scheduledSubBudgetId` requires its parent. Mixing scheduled scope with current-budget allocation filters is rejected.
- Date filters accept inclusive `startDate`/`endDate`. If omitted, `period=daily&date=YYYY-MM-DD` or `period=monthly&year=YYYY&month=1..12` selects a period. Without date/period filters, all matching dates are included. Page and member filters never change the stored budget allocation.
- `POST /expenses` accepts optional UUID `requestId`. Same actor/key/payload returns the existing expense; a changed payload for a used key returns 409. New clients preserve this key through failed retries. Older clients without a key remain supported but do not gain retry deduplication.
- Scheduled budget responses include server `spent`, `remaining`, and `categoryTotals`, plus sub-budget totals and sharing metadata. Member responses include `expiresAt` and `expired`; new pending invitations expire after seven days. Expired response attempts return 410; removed/cancelled or unavailable invitations return 404.
- Owners can invite, cancel pending invitations, and remove accepted members. Accepted contributors can `POST /scheduled-budgets/:id/leave`; owners must use the explicit budget-delete flow. Leaving/removal preserves expenses while removing access.
- Activity requires current owner/accepted-member access, uses `page` (default 1), fixed limit 25, and returns `{ success, data: { rows, total, page, limit } }`. Rows identify actor/target usernames, action, and creation time; no expense notes or amounts are copied into event text. There is no historical event backfill.
- Existing `/api/platform/notifications` responses may contain `type=budget_activity` and optional `href` for the relevant budget screen. Budget mutations record activity and notifications in the same database transaction. Notifications do not grant budget access.

## FP-56 moderation pagination — 2026-10-02

`GET /api/freshprice/products/:id/wiki/suggestions` and `GET /api/freshprice/products/:id/wiki/recipes/suggestions` accept `status`, `page` (positive integer, default 1) and `limit` (1–100, default 20). Both return `{ data: Suggestion[], meta: { page, limit, total } }`. Invalid pagination returns 400. Product/status filters and operator authorization are preserved; rows sort by `createdAt DESC, id DESC`. The envelope applies when either pagination parameter is supplied. Calls without page/limit retain the legacy array response (up to 100 rows). Deploy the backend first; the frontend also tolerates legacy arrays and labels moderation totals as incomplete.


## Recipe lifecycle and discovery — 2026-10-02

`PUT /api/freshprice/products/:id/wiki/recipes/:recipeId` accepts recipe content and `isPublished`; it requires an authenticated operator. Product association and creator cannot be changed. Editing the title preserves the existing slug. Optional numeric preparation/cooking/serving values can be cleared with null. Invalid fields return 400; a missing recipe or wrong product returns 404. Updates persist transactionally.

Public wiki responses include `recipeCount` for all published recipes while retaining the six-recipe preview. Public `GET /:id/wiki/recipes?page=1&limit=6` returns `{ data, meta: { page, limit, total } }`, ordered by title then ID. Limit is 1–100; invalid pagination returns 400. Without pagination parameters, the original complete published array is returned. Public list/detail endpoints never expose drafts.


FP-43: public database readiness at `/api/platform/db/health` returns `Cache-Control: no-store` on both ready (200) and unavailable (503) responses. Response bodies and authorization behavior are unchanged.

## FP-65 price observations (local, 2026-10-15)

Under `/api/freshprice/market-prices`:

| Method/path | Access | Behavior |
| --- | --- | --- |
| `POST /observations/preview` | Operator | Validate up to 500 reviewed quotes and return normalized per-product/market/date/unit count, min/max, mean, median, modes and mode frequency; no writes. |
| `POST /observations/import` | Operator | Transactionally store independent quotes with a UUID batch ID; return stable per-input-row outcomes. |
| `GET /observations` | Operator | Paginated admin records including original quote/note, seller/quality context, revision and audit data. Filters: productId, marketId, unitType, fromDate, toDate, page, limit (max 200). |
| `PATCH /observations/:id` | Operator | Correct or exclude a quote with required current revision, reviewed=true and reason. Stale revisions return 409. Original source note remains immutable; audit retains previous values and actor/reason. |
| `GET /trends/:productId?basis=observations` | Public | Observation-based statistics; official prices remain the default API basis when omitted. |

Import request: `{ batchId: UUID, records: [...], allowDuplicateBatch?: boolean }`. Each quote uses `{ quoteKey, productId, marketId, price, quantity, priceDate, unitType, originalNote?, sellerLabel?, qualityNote?, reviewed: true, isAvailable?: boolean }`. `price` is the original quoted amount; the server computes the normalized price using exact arithmetic. Price accepts up to two decimals and quantity up to six decimals. Dates are valid Philippine calendar dates no later than today. No uniqueness is imposed on the product/date/unit/market/price combination; identical prices with different quote identities are retained.

Response: `{ success: true, results: { success: [{row,id}], errors: [{row,error}], replayed } }`, with one-based input row numbers. Replaying the same actor/batch/payload returns the original result without adding quotes; changing a used batch payload returns 409 (`batch_conflict`). Reusing identical content as a new batch requires explicit confirmation (`duplicate_batch` otherwise). Partial validation errors are stored with the batch outcome; correct failed rows using a fresh batch after removing confirmed successes. A transaction failure saves no part of a batch. Maximum 500 quotes per batch.

Observation trends accept `statistic=median|mean|mode` (default median), `interval=daily|weekly` (default daily), `unitType=per_kilo|per_piece|per_sack`, marketId and days (7–365). Range contains exactly the requested number of Philippine business dates through today. Weekly buckets start Sunday and mark partial edge weeks. Buckets include missing periods with null values. Summary and market comparisons calculate statistics from raw eligible quotes, with first/latest period values and direction using the selected method/granularity. Repeated tied modes are returned as a list, but chart/direction scalar values are null unless there is a unique mode. Units never mix; unavailable/excluded quotes never count. Queries over 50,000 eligible quotes return 422 with guidance to narrow the filters rather than silently truncate. Public responses omit original notes, seller labels and creator/audit identities.

Existing official current-price/history/import/publication endpoints and legacy trend fields retain their contracts. Community submissions are not automatically copied into observations in this initial operator-import release.

### Local regression corrections — 2026-10-15

Product creation and updates return 400 for Sequelize model-validation failures. Observation history/trends retain soft-deleted market identity; an existing observation can retain its original archived market during correction/exclusion, but new quotes and market reassignment require an active market. Image uploads still accept one image with no extra multipart fields; valid single images now pass the multipart parser. Community tag associations match the existing timestamp-free junction table.
