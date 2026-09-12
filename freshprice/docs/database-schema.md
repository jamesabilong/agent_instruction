# FreshPrice Database Schema Investigation

Last investigated: 2026-09-12 (budget reliability migration; other inventory retained)

FreshPrice uses Sequelize models under `platform-backend/src/models` and migrations under `platform-backend/src/migrations`. PostgreSQL is the target database.

## FreshPrice And Shared Tables

| Model | Table | Domain |
| --- | --- | --- |
| `User` | `users` | Auth, account ownership, admin/operator roles |
| `Product` | `products` | Product catalog |
| `Market` | `markets` | Market catalog |
| `MarketProductPrice` | `market_product_prices` | Current market/product/unit price |
| `MarketProductPriceHistory` | `market_product_price_history` | Historical price snapshots |
| `PriceSubmission` | `price_submissions` | User-submitted daily prices pending moderation |
| `PriceModerationAudit` | `price_moderation_audits` | Audit trail for accepted/rejected/published prices |
| `Budget` | `budgets` | User daily/monthly budget |
| `BudgetSubBudget` | `budget_sub_budgets` | User budget buckets |
| `Expense` | `expenses` | User expense records |
| `ScheduledBudget` | `scheduled_budgets` | Shared or scheduled budget envelopes |
| `ScheduledSubBudget` | `scheduled_sub_budgets` | Scheduled budget buckets |
| `ScheduledBudgetMember` | `scheduled_budget_members` | Scheduled budget collaborators/invitations |
| `BudgetActivity` | `budget_activities` | Actor/action history for shared budget and membership changes |
| `Notification` | `notifications` | Account notifications, including links to budget activity |

## Budget Reliability Migration — 20260912000001

`platform-backend/src/migrations/20260912000001-budget-reliability.cjs` is additive and wraps its changes in a transaction. It has not been applied to production by this task.

- `scheduled_budget_members.expires_at`: nullable timestamp; existing pending invitations receive seven days from migration time. Accepted memberships do not expire. New invitations explicitly set a seven-day deadline.
- `expenses.request_id`: nullable UUID, with unique `(user_id, request_id)` index `expenses_user_request_unique`. Existing rows remain null; new keyed retries are deduplicated per actor.
- `notifications.href`: nullable string(500) for application links. Budget UI accepts budget-path links and rechecks access through the destination API.
- `budget_activities`: auto-increment BIGINT `id`, required `scheduled_budget_id` string(80) FK with CASCADE on hard parent deletion, nullable `actor_id` and `target_user_id` user FKs with SET NULL, required `action` string(60), nullable UUID `expense_id`, required `created_at`. No `updated_at`. The expense reference deliberately has no FK so deletion events retain their ID. Index `budget_activities_budget_date` covers budget/date/id ordering.

Allocation mutation services lock the current/scheduled parent before reading allocation sums and writing. Parent-amount changes use the same parent lock. Expense retries serialize on the actor row; shared writes and membership removal lock the scheduled parent. User locks use PostgreSQL NO KEY UPDATE to avoid blocking notification FK key-share checks. These rules need the opt-in migrated PostgreSQL regression suite before release; mocked unit checks alone cannot prove concurrency behavior.

The down migration drops activity history and the added columns/index; use application rollback with the additive schema retained where possible. Do not execute a destructive down migration as a routine production rollback without reviewing data loss.

## Community Tables

| Model | Table | Purpose |
| --- | --- | --- |
| `CommunityPost` | `community_posts` | Discussion posts |
| `CommunityComment` | `community_comments` | Threaded comments |
| `CommunityTag` | `community_tags` | Post tags |
| `CommunityPostVote` | `community_post_votes` | Post votes |
| `CommunityCommentVote` | `community_comment_votes` | Comment votes |

## Notable Relationships

- Products and markets are joined by `market_product_prices`.
- Historical prices are stored in `market_product_price_history`.
- Price submissions connect users, products, markets, unit type, date, status, and moderation decisions.
- Budgets, sub-budgets, expenses, and scheduled budgets are user-owned, with collaborator support through scheduled budget members.
- Community posts belong to users and can have tags, comments, and votes.

## Schema Change Checklist

- Add or update a Sequelize migration in `platform-backend/src/migrations`.
- Update the matching Sequelize model in `platform-backend/src/models`.
- Update services/controllers that shape request and response data.
- Add or update tests for model constraints, API behavior, and frontend consumers when applicable.
- Update this document and `instructions/freshprice/docs/api-routes.md` if the change affects API contracts.
