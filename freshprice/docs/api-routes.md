# FreshPrice API Routes Investigation

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
- `POST /`
- `POST /import-csv`
- `PUT /:id`
- `DELETE /:id`

Mutations require auth and operator role.

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
