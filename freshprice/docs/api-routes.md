# FreshPrice API Routes Investigation

Last investigated: 2026-07-01

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
