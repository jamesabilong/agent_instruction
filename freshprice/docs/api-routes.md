# FreshPrice API Routes Investigation

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

### FP-66 local authentication testing controls (2026-10-23)

`GET/PUT /api/platform/auth/testing-exemption` and `POST /api/platform/auth/testing-exemption/revoke` require authenticated current administrator authorization. Changes require a fresh current password, enabled feature, verified public caller identity and expected revision; rules are restricted to that same account. GET is no-store and includes current IP, rule lifecycle and latest 100 audit events. See [FP-66 policy and API](fp-66-controls-2026-10-23.md). Local implementation; not deployed.

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

Search follow-up (release pending): `GET /?q=...` filters product names case-insensitively before pagination/counting; trimmed scalar string ≤200 characters, literal `%`/`_`/backslash, combinable market/product/unit filters. Blank/absent query preserves the existing contract. NUL queries, unsafe page/offset values and product/market IDs outside their positive PostgreSQL INTEGER range return 400 before querying. [Current review, verification and PRs](search-pagination-review-publication-2026-10-26.md).

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
- `PATCH /scheduled-budgets/:id/collaborators/:userId/role` — FP-59 owner-only role change; body `{ role: "contributor" | "viewer" }`. Supports pending/accepted memberships, rejects invalid roles with 400, non-owner members with 403 and unavailable members/budgets with 404. Role updates and expense writes serialize on the scheduled parent; changes record `member_role_changed` activity and notifications transactionally.
- `POST /scheduled-budgets/:id/leave`
- `GET /scheduled-budgets/:id/activity`
- `GET /scheduled-budgets/:id/ownership-transfer` — pending transfer or null; visible only to current owner/recipient with current budget access. Includes `expired`.
- `POST /scheduled-budgets/:id/ownership-transfer` — owner proposes `{ toUserId }` (accepted member); same live recipient/membership retry returns the existing transfer. Supersedes earlier pending requests.
- `POST /scheduled-budgets/:id/ownership-transfer/:transferId` — `{ action: "accept" | "decline" | "cancel" }`; recipient accepts/declines, current owner cancels. Seven-day expiry (410); stale/superseded/revoked membership conflicts (409). Same successful outcome retry is harmless. Parent-row locking keeps exactly one owner; acceptance removes the recipient membership and retains the previous owner as an accepted contributor. Historical expense authorship is unchanged. Events/notifications commit atomically.
- `GET /budget-recurring-templates` — authenticated creator's templates, including cancelled history.
- `POST /scheduled-budgets/:id/recurring-template` — owner creates monthly snapshot with client UUID `{ id }`; same UUID replays even after cancellation, existing active/paused owner/source template deduplicates a new UUID. A new UUID after cancellation can create a fresh snapshot. Generated instances cannot be used as template sources.
- `PATCH /budget-recurring-templates/:templateId` — creator-only `{ status: "active" | "paused" | "cancelled" }`. Resume advances past missed start dates. Cancelled templates cannot restart (409).
- `POST /budget-recurring-templates/:templateId/generate` — creator-only; active templates generate due instances using server Philippine business date, returning `{ generated: string[], template }`. Paused/cancelled return 409. Concurrent workers/retries serialize on the template; existing and soft-deleted periods are not duplicated or resurrected.

Lifecycle responses use `{ success: true, data }` (200); failures use `{ success: false, message }`. Template responses contain `id`, `sourceBudgetId`, `name`, numeric `amount`, `note`, original `anchorStartDate`/`anchorEndDate`, `nextStartDate`, `status`, `frequency=monthly`, `memberPolicy=private`. Scheduled budget responses add nullable `recurringTemplateId`. Templates retain their creator after source deletion/ownership transfer. New generated instances use random UUIDs rather than predictable future IDs; existing generated IDs remain valid. Deleting a historical inviter preserves accepted/pending memberships with a null inviter reference. Instances copy only snapshot budget/allocation values; each has new allocation IDs, no expenses and no members. Each original date anchor shifts independently by calendar months, clamping to the last valid day. Creation starts at the first occurrence at least one month after the source and no earlier than today. Active downtime catches up (24 periods per transaction); pause/resume skips past starts. Generation also runs on backend startup/hourly, all due templates in stable ID-ordered pages of 50, attempting each ID once per sweep and reporting failures after processing later pages. See `fp-59-lifecycle-2026-10-19.md`.

### Budget contract additions — 2026-09-12

FP-59 viewer increment (local, 2026-10-19): invitation creation accepts optional `role` (default `contributor`). Member/invitation responses expose `role`; scheduled-budget `shareRole` adds `viewer` while retaining legacy `collaborator` for contributors. Owners alone manage invitations, roles and allocations. Viewers can read authorized shared expenses, summaries and activity and may leave; all expense creates/updates/deletes are rejected with 403, including replay of a prior request and moving an existing expense into/out of a viewer budget. A contributor can still change only their own expenses. Deploy the role migration and new backend before exposing viewer controls. Do not roll back to a role-unaware backend while viewer memberships exist; it would grant them contributor rights.

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

## FP-60 accounting (local 2026-10-19)

Authenticated prefix `/api/freshprice/user`; shared read/write permissions follow FP-59. Currency PHP. See `fp-60-accounting-2026-10-19.md` for confirmation and correction policy.

| Method | Path | Input / response |
| --- | --- | --- |
| GET | `/expenses/:expenseId/split` | Expense revision, confirmed/latest split and current participants/capabilities |
| PUT | `/expenses/:expenseId/split` | UUID requestId, expectedRevision, payerUserId, whole-peso amount, method equal/explicit, shares[{userId,amount?}], reason; author only |
| POST | `/scheduled-budgets/:id/splits/:splitId/respond` | action confirm/dispute/cancel, expectedRevision; payer responds, author cancels |
| GET | `/scheduled-budgets/:id/accounting` | PHP balances in integer cents, current/historical participants, legacy policy |
| GET | `/scheduled-budgets/:id/accounting/history` | kind splits/settlements, page; 25 rows/page with server-authorized actions |
| POST | `/scheduled-budgets/:id/settlements` | UUID requestId, toUserId, amount with at most 2 decimal places, date, note; sender is actor |
| POST | `/scheduled-budgets/:id/settlements/:settlementId/respond` | action, expectedRevision, optional response note; counterparty responds, proposer cancels |
| POST | `/scheduled-budgets/:id/settlements/:settlementId/reversals` | UUID requestId, 3–200 character note; creates separately confirmed full reversal |

Existing expense responses add `revision`; PUT accepts body `expectedRevision` and DELETE accepts query `expectedRevision`. Required after any split history; optional for untracked legacy clients. Tracked amounts change through split correction controls; tracked moves are rejected. Mutations are transactional/idempotent where keyed; stale/conflicting or revoked participants return 409, permission denials 403/404, invalid centavos/sums 400. Pending/disputed records do not affect balances or expense totals.

FP-60 review fix: settlement POST replay resolves an omitted date from the existing creator/request UUID record, preserving identical retries across Asia/Manila midnight. New records alone default to today's business date. Explicitly changed dates and other changed values still return 409; current write/member authorization applies before replay.

## FP-61 durable expense replay — local 2026-10-20

POST `/api/freshprice/user/expenses` and PUT `/api/freshprice/user/expenses/:id` optionally accept `mutationId` UUID and `draftAccountId` matching the authenticated actor. Current-budget drafts also send the original `expectedBudgetId`; mutation PUT requires `expectedRevision >= 1`. The mutation receipt and expense write commit atomically. Replays reauthorize original/destination/current shared access and return the original saved response; conflicting key reuse returns 409. Structured outcomes include `DRAFT_ACCOUNT_CHANGED` (403), `MUTATION_KEY_REUSED`, `BUDGET_CHANGED`, `REVISION_CONFLICT` plus current expense (409), and deleted committed expense (410 `EXPENSE_DELETED`). Legacy writes remain compatible. See `fp-61-offline-editing-2026-10-20.md` for policy and release gates.

## FP-62 wiki enrichment (local, 2026-10-20)

Product prefix `/api/freshprice/products`: public `GET /wiki/seasonal` (locale/region/month/page/limit) and `GET /:id/wiki/enrichments`; operator `GET /wiki/inventory`; authenticated `POST /:id/wiki/enrichments`, `GET /:id/wiki/enrichments/mine` and author-only `POST /:id/wiki/enrichments/:entryId/withdraw-recognition`; operator `GET /:id/wiki/enrichments/moderation` and `POST /:id/wiki/enrichments/:entryId/review` (approve/reject/retract, reviewed sourceRevisionId; retract requires the exact approved entry revision). Contribution/history lists use page/limit; public enrichment output omits identities and moderation state. Canonical publication/revision changes invalidate public variants until newly reviewed proposals are approved. Existing recipes GET adds literal q, difficulty and maxCookMinutes before pagination, retaining its legacy array contract. See `fp-62-wiki-enrichment-2026-10-20.md`.

FP-62 review fix: proposal POST accepts an optional client UUID `submissionId`; matching author/product/normalized-payload retries return the original operation and current status (including after source changes), while conflicting identity reuse returns 409. Updated editor retains this identity through uncertain responses. Retraction is operator-only, idempotent for the same retracted entry, records separate actor/time and preserves approval history; private lists expose retractedAt, while public lists omit private identity/signature/status fields. See `fp-62-review-fixes-2026-10-20.md`.

## FP-63 shopping lists (local, 2026-10-20)

Authenticated `/api/freshprice/shopping-lists`: GET owned active summaries; POST personal list or published recipe snapshot; GET `/:id` list/items, official market estimates and freshly authorized budget comparison; PATCH `/:id` settings/archive; POST `/:id/items`; PATCH `/:id/items/:itemId` edit/check/remove; POST `/:id/items/:itemId/purchase` explicit actual spending. All writes require UUID operationId, edits/purchases also expectedRevision. Conflicting keys or stale revisions return 409; an already recorded but deleted expense replay returns 410. Ownership is mandatory even for shared-budget members/operators. Readable shared-budget viewers can estimate but cannot purchase. Checking alone never creates an expense. Actual amount uses existing whole-PHP expense storage, quantity at most two decimals, and purchase date must fit the saved linked budget's period. Missing/stale/noncomparable quotes keep full total unknown. See `fp-63-shopping-integration-2026-10-20.md` for full contracts, online/in-memory retry limitations and staging requirements.

October 22 FP-63 contract update: GET shopping list items includes `purchaseHistory:{available,budgetLink}` for purchased items. Targets come from immutable purchase snapshots/legacy operation receipts, with fresh expense ownership and shared-budget access checks. Deleted/moved expenses or revoked/deleted shared budgets return unavailable history. Estimates round exact decimal products half up per item and aggregate integer centavos. See [review fixes](fp-63-review-fixes-2026-10-22.md).

## FP-66 production status — 2026-10-26

Additive migration 42 and `/api/platform/auth/testing-exemption` own-account admin controls are deployed. Caddy authenticated-edge identity is verified on both apps; normal authentication/roles/fresh-password rules remain. Exemptions are disabled, with zero rule/audit rows. Schema constraints, audit retention and guarded rollback follow the [policy](fp-66-controls-2026-10-23.md); do not discard collected audit history. [Release/evidence](fp-66-deployment-2026-10-26.md).

## Deployed pagination corrections — 2026-10-26

Community hot/top ranking, full tag hydration under tag filters and deterministic tie orders for community/content/current-price/history lists are deployed through backend PR #62, with unchanged envelopes/auth/privacy contracts. Exact image/source, public GETs and read-only SQL comparisons pass. [Release/coverage](backend-pagination-deployment-2026-10-26.md). Exemptions stay disabled.
