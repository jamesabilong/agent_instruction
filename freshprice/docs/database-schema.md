# FreshPrice Database Schema Investigation

> Checkout caveat (2026-10-02): September budget reliability additions below describe imported implementation notes; the current frontend/backend master checkout still has the older expense ownership/cache/pagination paths. Verify the corresponding implementation commits before relying on those additions as available APIs or schema.

Last investigated: 2026-09-12 (budget reliability migration; other inventory retained)

FreshPrice uses Sequelize models under `platform-backend/src/models` and migrations under `platform-backend/src/migrations`. PostgreSQL is the target database.

## FreshPrice And Shared Tables

| Model | Table | Domain |
| --- | --- | --- |
| `AuthTestExemption` | `auth_test_exemptions` | FP-66 local: one exact-IP/expiry/revision rule per own admin account |
| `AuthTestExemptionAudit` | `auth_test_exemption_audits` | FP-66 local: redacted transactional lifecycle/use audit |
| `User` | `users` | Auth, account ownership, admin/operator roles |
| `Product` | `products` | Product catalog |
| `Market` | `markets` | Market catalog |
| `MarketProductPrice` | `market_product_prices` | Current market/product/unit price |
| `MarketProductPriceHistory` | `market_product_price_history` | Historical price snapshots |
| `PriceObservation` | `price_observations` | Individual reviewed operator quotes, corrections and exclusion audit |
| `PriceObservationBatch` | `price_observation_batches` | Immutable import identities, content hashes and replayable per-row outcomes |
| `PriceSubmission` | `price_submissions` | User-submitted daily prices pending moderation |
| `PriceModerationAudit` | `price_moderation_audits` | Audit trail for accepted/rejected/published prices |
| `ProductWikiPage` | `product_wiki_pages` | Current approved product wiki content and source links |
| `ProductWikiEditSuggestion` | `product_wiki_edit_suggestions` | User-submitted wiki edits pending admin review |
| `ProductWikiRevision` | `product_wiki_revisions` | Append-only approved wiki version history |
| `ProductRecipe` | `product_recipes` | Published or draft recipe subwiki entries linked to products |
| `ProductRecipeSuggestion` | `product_recipe_suggestions` | User-submitted recipe suggestions pending admin review |
| `Budget` | `budgets` | User daily/monthly budget |
| `BudgetSubBudget` | `budget_sub_budgets` | User budget buckets |
| `Expense` | `expenses` | User expense records |
| `ScheduledBudget` | `scheduled_budgets` | Shared or scheduled budget envelopes |
| `ScheduledSubBudget` | `scheduled_sub_budgets` | Scheduled budget buckets |
| `ScheduledBudgetMember` | `scheduled_budget_members` | Scheduled budget collaborators/invitations |
| `BudgetOwnershipTransfer` | `budget_ownership_transfers` | Recipient-accepted ownership proposals and outcomes |
| `BudgetRecurringTemplate` | `budget_recurring_templates` | Creator-owned monthly snapshots and durable generation cursors |
| `BudgetActivity` | `budget_activities` | Actor/action history for shared budget and membership changes |
| `Notification` | `notifications` | Account notifications, including links to budget activity |

## FP-59 lifecycle migration — 20261019000002

`20261019000002-budget-transfer-and-templates.cjs` creates transfer records (UUID, budget/from/to user references, exact membership UUID, checked status, expiry and timestamps) with a partial unique index for one pending transfer per budget. Membership UUID deliberately has no FK so accepted/removed membership history remains meaningful. Scheduled parent row locking serializes acceptance with member removal and other management operations.

Recurring templates store creator user FK, source budget ID (no FK, so source deletion never removes the schedule), immutable name/amount/note/date-anchor/allocation JSONB snapshot, checked active/paused/cancelled status and next occurrence/date cursor. A partial unique owner/source index prevents multiple active/paused templates; cancelled snapshots remain historical records. A due-date index supports startup/hourly generation. `scheduled_budgets.recurring_template_id` is nullable UUID FK with ON DELETE SET NULL, and `recurring_occurrence` is nullable integer; their unique pair deduplicates periods. New instance IDs are random UUIDs; unique template/occurrence pairs and row locking deduplicate retries without exposing a preclaimable future ID. Existing deterministic instance IDs remain supported and editable. Allocations receive fresh IDs; expenses/members are not copied. Creator hard deletion removes templates but preserves any instances transferred to another owner by nulling their template FK.

Up is transactional. Down exclusively locks lifecycle tables and refuses while either contains records, avoiding discarded transfer history or active schedules. Keep additive schema on application rollback, disable automatic generation when needed, and review retained data before any destructive rollback. See `fp-59-lifecycle-2026-10-19.md`.

## FP-59 inviter preservation migration — 20261019000003

`20261019000003-preserve-budget-inviter-history.cjs` makes `scheduled_budget_members.invited_by_user_id` nullable and replaces its user FK with ON DELETE SET NULL / ON UPDATE CASCADE. A deleted historical inviter no longer cascades unrelated accepted/pending memberships after ownership transfer. Existing inviter values are retained until that account is deleted; audit actor references already use SET NULL. Model nullability and association behavior match the migration. No member status/role/expense is rewritten.

Up and down are transactional. Empty-schema rollback/reapply is supported; down refuses if any inviter is null or any ownership-transfer history exists, since restoring the old relationship would lose history or restore cascading revocation. Keep the additive migration on application rollback.

## Budget Reliability Migration — 20260912000001

FP-59 adds `20261019000001-scheduled-budget-member-roles.cjs`: required `scheduled_budget_members.role` VARCHAR(16), default `contributor`, with named CHECK constraint permitting only `contributor`/`viewer`. All existing memberships receive the contributor default without changing owner identity, status or expenses. Role lives on the invitation/membership; account user/admin roles are unchanged. Up runs transactionally. Down acquires an exclusive table lock and refuses to drop role information while any viewer membership exists, since legacy behavior would widen that user's permissions. Retain the additive schema on application rollback, and remove viewer access before running any older role-unaware backend.

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
- Products can have one current wiki page, many wiki revisions, many wiki edit suggestions, many recipes, and many recipe suggestions.
- Wiki edit suggestions store `changed_fields` so approving a partial proposal does not erase untouched page sections; only one pending wiki suggestion per product/user is allowed.
- Wiki revisions snapshot slug, publication state, content, and source links and enforce unique positive revision numbers per wiki page.
- Wiki/recipe suggestion statuses are constrained to pending, approved, or rejected; recipe time and serving values have non-negative/positive constraints.
- Historical prices are stored in `market_product_price_history`; one daily snapshot is allowed per market/product/unit via `unique_market_product_unit_date`.
- Price submissions connect users, products, markets, unit type, date, status, and moderation decisions.
- Budgets, sub-budgets, expenses, and scheduled budgets are user-owned, with collaborator support through scheduled budget members.
- Community posts belong to users and can have tags, comments, and votes.

## Schema Change Checklist

- Add or update a Sequelize migration in `platform-backend/src/migrations`.
- Update the matching Sequelize model in `platform-backend/src/models`.
- Update services/controllers that shape request and response data.
- Add or update tests for model constraints, API behavior, and frontend consumers when applicable.
- Update this document and `instructions/freshprice/docs/api-routes.md` if the change affects API contracts.

## FP-65 observation migration — 20261015000001

The additive, transactional migration creates `price_observation_batches` and `price_observations` without altering official history/current-price rows. Tested locally against disposable PostgreSQL 14; not applied to an app or production database.

- Batches: UUID primary key, nullable creator FK (SET NULL on user deletion), SHA-256 request hash, JSONB per-row result, timestamps. Creator/hash lookup index supports duplicate-content warnings.
- Quotes: UUID primary key, required batch FK, quote key, product/market FKs, DATEONLY price date, supported unit, normalized/original price DECIMAL(10,2), quantity DECIMAL(14,6), original note, optional seller (120)/quality (300) text, available/excluded flags, nullable creator FK, revision and JSONB correction audit, timestamps.
- Unique batch/quote identity prevents ingest duplicates. Market/product/date/unit/price combinations are deliberately non-unique. Trend index covers product/unit/date/market. Database checks enforce nonnegative prices, positive quantity and supported units.
- Product/market hard deletion cascades quotes consistently with existing historical-price ownership. User deletion nulls creator FKs without blocking account deletion or discarding observations. Batch identity/outcomes remain retained.
- Import transactions use PostgreSQL advisory locks for actor/content and batch identity, ensuring concurrent retries return one immutable result. Correction transactions lock the observation and require a matching revision. No published daily summary or community submission is counted as an additional observation.
- The down migration removes collected quotes and batch/audit history. Use application rollback with the additive schema retained after real data collection; export first if schema removal is intentional.

## FP-60 financial accounting (local, 2026-10-19)

Migration `20261019000004-budget-accounting.cjs` adds `expenses.revision` (integer, default 1), `budget_expense_splits` and `budget_settlements`. Split rows retain UUID expense_key, nullable expense FK with SET NULL, scheduled budget, expense revision, creator/payer identities, request UUID, kind/status, response metadata and JSONB snapshots (expense, PHP total, named centavo shares, correction reason). Unique expense_key/revision and creator/request enforce concurrency and replay identity. Settlement rows retain sender/recipient/creator numeric identities without User foreign keys, BIGINT amount_cents, payment date, payment/reversal kind, linked reversal_of, revision/status/response metadata, request UUID and participant/note snapshots. Amounts are positive and sender differs from recipient. Unique creator/request and partial unique confirmed reversal_of prevent duplicate financial effects. Both histories index budget/created_at/id. Participant IDs deliberately survive user removal/deletion; budget FKs cascade only on hard purge, while normal deletion is soft. Down migration locks both accounting tables and refuses any financial records. See FP-60 design for forward-fix/rollback restrictions.

## FP-61 expense mutation receipts — local 2026-10-20

Migration `20261020000001-expense-mutation-receipts.cjs` adds `expense_mutations` (model `ExpenseMutation`): UUID primary key `id`, indexed required actor `user_id` (users FK, CASCADE on account deletion), required SHA-256 `signature`, required `expense_id` UUID without an expense FK, required original `result` JSONB, and `created_at`. Actor locking and one transaction cover expense/activity/receipt. Retain receipts after expense deletion so uncertain retries cannot recreate deleted records. Down migration requires an empty locked receipt table; preserve all receipts when rolling back application code. No changes to spending, split or settlement amounts.

## FP-62 wiki enrichment (local, 2026-10-20)

Additive migration `20261020000002-wiki-enrichments.cjs` creates `product_wiki_enrichments`: UUID PK; canonical product/source-revision FKs; locale, exact geographic scope, JSONB editorial content/calendar months; source URL/review date; opt-in public name; pending/approved/rejected/superseded status; nullable private author/reviewer IDs; timestamps. Product/source deletion cascades; user deletion sets private references NULL. A partial unique index permits one approved variant per product/locale/region. Approval serializes with source edits via the canonical wiki lock. Queries exclude unpublished or obsolete-revision variants. Rollback locks the table and rejects any collected proposal/history. No product or alias duplication and no new factual seed content. See `fp-62-wiki-enrichment-2026-10-20.md`.

FP-62 review fix migration `20261020000003-wiki-enrichment-retry-and-retraction.cjs` adds nullable submission_signature TEXT, retracted_by_user_id INTEGER (users FK SET NULL) and retracted_at timestamp. State adds `retracted`; original reviewer_id remains the approval reviewer. UUID advisory locks serialize identity-bearing submissions and hashes bind the original normalized payload/product, separately from mutable recognition/status. Rollback refuses any stored signature or retraction audit; empty down/up applies 00003 down, 00002 down, then both up in order. Public approved-only queries exclude retracted rows. See `fp-62-review-fixes-2026-10-20.md`.

## FP-63 shopping lists (local, 2026-10-20)

Additive `20261020000004-shopping-lists.cjs` creates owned shopping_lists (UUID, optional logical budget_link JSON, market/recipe FK snapshots, revision/archive), shopping_items (UUID, canonical product or unmatched text, quantity/unit, check/remove state, permanent purchase timestamp/details and live expense FK), and shopping_operations (UUID, owner, immutable request hash and original result). Account deletion cascades; deleted market/product/recipe/expense references SET NULL while snapshots/purchase markers remain. Actor/operation locks serialize idempotent writes; purchase shares one outer expense transaction with item/list/receipt updates. A different operation cannot repurchase a marked item after expense deletion. Down locks and refuses collected lists/operations; preserve data and forward-repair used schemas. See `fp-63-shopping-integration-2026-10-20.md`.

October 22 FP-63: existing shopping_items.purchase_details JSON now also snapshots the purchase-time budgetLink; no migration required. Legacy targets are recovered from immutable shopping_operations result.purchaseBudget. Live expense access is checked before offering history navigation.

FP-66 migration `20261023000001-auth-test-exemptions.cjs` is additive; rollback refuses collected rule/audit history. [Policy and migration gates](fp-66-controls-2026-10-23.md). Not deployed.

## FP-66 production status — 2026-10-26

Additive migration 42 and `/api/platform/auth/testing-exemption` own-account admin controls are deployed. Caddy authenticated-edge identity is verified on both apps; normal authentication/roles/fresh-password rules remain. Exemptions are disabled, with zero rule/audit rows. Schema constraints, audit retention and guarded rollback follow the [policy](fp-66-controls-2026-10-23.md); do not discard collected audit history. [Release/evidence](fp-66-deployment-2026-10-26.md).
