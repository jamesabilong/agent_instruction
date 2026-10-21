# FP-63 shopping integration — 2026-10-20

October 21 status: preserved/pushed as explicitly WIP FP-63 commits `0a079583` (frontend) and `acfa1f8` (backend), without source changes or deployment. [Three pre-commit review findings](fp-63-precommit-review-2026-10-20.md) remain open; this supersedes older uncommitted/no-gaps interpretations below. FP-59/60/61 are now deployed; FP-62 and FP-63 remain unreleased. Current source fingerprint matches the original reviewed snapshot.

Matching frontend/backend FP-63 branches start from published reviewed FP-62 heads `2fc10cd7` and `1fcb72d8`. Jira FP-63 is In Progress in future sprint 338; the sprint was not started or rescheduled. Application changes remain uncommitted. This implements the ticket's first increment. Favorites, price alerts (including delivery deduplication), orders, checkout and payments remain explicitly separate follow-up work.

## List and ingredient policy

The existing shopping guide is product/official-price discovery, with no persistent cart/list. Reuse that discovery, canonical products/aliases, published recipe data, auth and budget services. New personal lists optionally reference an accessible current or scheduled/shared budget. Linking never shares the list with budget members. Every list/item route requires the owning account, including operator accounts; shared-budget viewers may read an authorized estimate but cannot confirm spending.

Recipe creation snapshots the published recipe title, original ingredient strings, selected serving count and parsed quantities. Only numeric or simple fraction prefixes followed by a unit/name are parsed. Exact case-insensitive canonical name/local-name/alias matches resolve to one canonical ID; ambiguous or unmatched text remains unmapped. No products or aliases are created automatically. Target servings accept at most two decimals to match stored serving precision; quantities below supported precision remain unknown rather than zero. Quantities scale from a documented serving count; unknown counts remain unscaled. Preserve original ingredient text for review, even when quantities/products are edited.

Supported comparable estimate units are kg, g (converted to kg), whole pieces and whole sacks. No volume/density, sack-to-weight, fraction-of-piece or fuzzy ingredient-name conversion is assumed. Other units and missing quantities remain editable and explicitly unresolved. Item text is rendered literally. Limits: 200 active lists per account, 200 collected items per list (removed items still count), 120-character list names and 500-character ingredient text. Archive/remove retain data and purchase history.

## Estimates and budget privacy

Price estimates use only the selected market's current official `market_product_prices` row in a compatible unit, with positive price, availability and a last-update timestamp no more than seven days old and not in the future. No observation average, seller offer or cross-market fallback is used. Each result exposes official basis, market, unit, unit price, timestamp and missing/stale reason. Unsupported monetary range stays unknown. Estimated item cost rounds to centavos; the full basket total is null while any outstanding item is unresolved. A known subtotal is labeled partial. Purchased items are excluded; checking alone does not exclude or book them.

Remaining confirmed budget comes from server expense aggregates. Current budget validates the exact linked budget ID and aggregates all personal confirmed expenses in its Philippine calendar daily/monthly period, matching the existing current-budget summary (including retained expenses from an older/reset budget); scheduled budgets use all their confirmed expenses, matching existing scheduled totals. Each read and purchase rechecks budget existence/access. Denied/deleted/disabled links return an unavailable marker with no private totals; the owner can still edit/unlink their personal list. Shared access revocation/viewer roles block expense creation and replay. The balance comparison is informational; no new hard budget cap is imposed.

## Purchase and retry policy

Only explicit actual purchase confirmation creates spending. Collect actual quantity/unit, whole-PHP amount (the existing integer expense contract), and a valid Philippine purchase date within the saved linked budget period and no later than today. Actual quantities use at most two decimals, consistent with expense storage. Estimates are never copied into the actual amount. Expense category is groceries; canonical product and saved market references are retained, while the shopping purchase audit also preserves the actual unit and original values.

Each mutation requires a client UUID operationId; edits also require expectedRevision. PostgreSQL operation locks and existing actor locks serialize retries; immutable request signatures bind account, operation, target and full payload. Replays of the same operation return its original result, conflicting reuse returns 409, and stale list revisions reject before mutation. In one transaction, purchase creates the expense through the existing expense service, updates the item purchase marker/list revision and persists the operation receipt. The expense requestId is the item's stable UUID. A different operation cannot purchase that item again, even after expense deletion. A replay after expense deletion returns 410 and never recreates it. Original purchase details remain available separately from later edits/deletion in expense history. A new purchase requires a new item.

Expense service accepts an internal outer transaction option so shopping shares its authorization, activity and durable expense-receipt behavior without a nested independent commit. Existing expense HTTP routes keep their contract. Purchase lock order is operation, actor, linked shared/current budget, list/item and expense work; membership revocation uses the same shared parent lock.

The UI freezes payload/identity after an uncertain response and offers explicit same-operation retry; it refreshes list and server totals only after confirmation. Saved market/budget settings must be applied before purchase; unsaved settings block it. Failed reads retain composing fields with writes disabled until refreshed. Private state and stale reads are cleared/ignored on account changes. Shopping forms are online-only and remain in memory while open; offline status disables writes and never auto-queues an expense. This workflow does not repurpose the FP-61 expense queue, and in-memory fields do not survive navigation/restart. The permanent item purchase marker still prevents a second purchase on later attempts.

## API and schema

Authenticated prefix `/api/freshprice/shopping-lists`:

- GET `/`: up to 200 owned active list summaries.
- POST `/`: create a list; optional published recipeId and target servings, name, marketId and budgetLink.
- GET `/:id`: owned list/items plus official estimates and permission-checked budget comparison; archived records remain readable by ID.
- PATCH `/:id`: name, marketId (or null), budgetLink (or null), archived; requires expectedRevision.
- POST `/:id/items`: add editable text/productId/quantity/unit; requires expectedRevision.
- PATCH `/:id/items/:itemId`: edit/check/remove an unpurchased item; requires expectedRevision.
- POST `/:id/items/:itemId/purchase`: explicit actual quantity/unit/amount/date with expectedRevision.

All write bodies require operationId. Budget link is `{kind:'current'|'scheduled',id:string}`. Creation/edit outputs contain list/items, not cached private budget totals. Purchase outputs also return the recorded expense and its original budget reference; UI then refetches fresh totals.

Additive migration `20261020000004-shopping-lists.cjs` creates shopping_lists, shopping_items and shopping_operations. User deletion cascades owned data; product/market/recipe deletion nulls references while retaining original text/snapshots. Expense deletion nulls its live FK but keeps purchased_at/purchase_details and operation history. UUID receipts preserve deduplication and the original result. Down takes exclusive locks and refuses any collected list or operation; do not discard used purchase history.

## Verification and release

Ticket fixtures, rules/component tests, real PostgreSQL/Chromium scenarios, evidence and reports live outside app repositories under `testing/tickets/FP-63`; see COVERAGE.md for actual completed checks. Final complete rerun results are recorded below and in the local ticket coverage, independently of prior tickets.

Release only after integrating the unmerged FP-59/60/61/62 dependency chain, with migration/schema/backend before frontend. Staging must rehearse recipe mapping, missing/stale prices, both budget scopes, denied/revoked/deleted links, mobile navigation, offline/uncertain response recovery, expense edits/deletion and protected rollback. Synthetic fixture prices/content and local browser tests do not establish production readiness. Keep Jira In Progress until review, staging and release gates are satisfied.

Final complete execution `2026-10-20T08-18-55-310Z-8cb7f672` passes 12/12 feature and 30/30 separate whole-app cases, zero JUnit failures/errors/skips. Both groups use fresh migrated disposable databases and unchanged final application source. Frontend lint/build and 284 units (52 files), backend 224 ordinary tests (23 existing opt-in DB skips across five files), and 36 runner checks pass. Additive migration empty roundtrip and nonempty-history rollback guard pass. Mobile evidence: workspace `output/playwright/fp63-shopping-mobile.png` (synthetic fixture data). Source fingerprint `38eb24ddc506b0f97debbc346769754a07e7b2c8db2516200a59333c9edcbf92`: SHA-256 over sorted workspace-relative paths, NUL, file bytes, NUL for both app src trees, package.json and root Vite/Vitest config files. Earlier partial results are historical and do not qualify as passing. No source changes after the final run began; no reduced scenarios, relaxed assertions or increased timeouts.
