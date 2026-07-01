# FreshPrice Database Schema Investigation

Last investigated: 2026-07-01

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
