# FreshPrice backlog ticket plans

Reviewed: 2026-10-19 (Asia/Manila). Planning only; implementation has not started.

Current execution update (2026-10-19): sprint 337 is now active, October 19–November 2 (Asia/Manila), and FP-59 is In Progress. Viewer roles, recipient-accepted ownership transfer and monthly templates are implemented locally; see the latest memory-bank progress entry and `fp-59-lifecycle-2026-10-19.md` for verification/release status. See also `fp-59-viewer-roles-2026-10-19.md`. Earlier planning-only/future-sprint statements below are historical context.

## Ticket descriptions published — 2026-10-19

Published the individual plans below to FP-57–FP-63 through the authenticated Jira browser UI at the user's request. Each description now contains outcome/scope, dependencies/sequencing, five numbered implementation steps, acceptance criteria and verification, and shared delivery checks. Explicitly proposed policy choices remain identified for implementation design; publication does not claim completed features.

Reopened every ticket through browser navigation and verified its complete scope, every implementation step, and every acceptance/verification clause against this document. All seven passed. Sprint memberships, workflow statuses, estimates and assignees were not edited during description publication. This supersedes historical statements below that the descriptions are empty or plans have not been posted. Screenshot: `/private/tmp/freshprice-ticket-plan-FP-63-2026-10-19.png`.

## Sprint setup completed — 2026-10-19

Created the three category sprints through the authenticated Jira browser session after reconnecting the plugin still returned read-only access. Verified persisted goals/future state through `listJiraBoardSprints` and every ticket's Sprint field through Jira search, plus the backlog UI after reload:

| Sprint ID | Sprint | Assigned tickets in recommended order |
| --- | --- | --- |
| 337 | Budget and Expense Management | FP-59 → FP-60 → FP-61 |
| 338 | Wiki and Shopping Integration | FP-62 → FP-63 |
| 339 | Seller and Messaging | FP-57 → FP-58 |

All goals include the implementation order. No dates were set and no sprint was started. All seven tickets remain To Do, Medium and unassigned. Preserved empty future sprint `Data proliferation 2` (336), whose intended purpose was not established. Backlog now contains zero unscheduled work items. Individual ticket descriptions were not edited. This completion supersedes the earlier sprint-creation blocker recorded below; connector write access itself remains unavailable. Browser evidence: `/private/tmp/freshprice-category-sprints-2026-10-19.png`.

## Jira findings and scope

Checked Fresh Price (FP), SCRUM board 1, using its actual backlog dataset and then fetched the seven open tickets in full. Pagination completed (`isLast: true`). FP-57–FP-63 are all **To Do**, **Medium**, unassigned tasks created September 12, 2026. None has a description, comments, subtasks, or issue links. Completed tickets returned by the backlog endpoint, including FP-64 and FP-65, are excluded from new delivery scope. No new October backlog tickets were found in that dataset.

The connection reports **read-only** Jira access. These plans are saved locally and have not been posted to Jira; statuses, priorities, ranks, and assignments are unchanged. Titles alone do not establish detailed requirements: the scopes below are proposals grounded in the existing September roadmap (O01/O02/O04/O05/O06/O08/O09), reconciled with October progress. They are ready to use as ticket descriptions after product scope is settled.

Jira Done does not prove production release: local progress still records outstanding staging/release gates for prior budget/wiki work and paired FP-65 PRs. Verify the baseline on the intended implementation branch and deployed environment before relying on it.

## Recommended delivery order

| Track | Sequence | Reason |
| --- | --- | --- |
| Core budget | Verify existing budget baseline → FP-59 → FP-60 → FP-61 | Establish membership and financial semantics before offline replay. FP-61 can begin queue design earlier. |
| Content and shopping | Verify existing wiki publication baseline → FP-62; reliable budget totals → FP-63 | Content enrichment and a basic shopping list can proceed independently. Recipe integration needs published recipe data. |
| Seller pilot | FP-57 → FP-58 | Messaging initially starts from an approved seller profile/offer. |

Suggested first work: baseline verification, FP-62 inventory, and FP-59 scope/permission design. Start the seller track when marketplace participation is selected as a product priority. All ordering and sizing below are recommendations, not Jira changes or committed dates. M = bounded feature; L = several coordinated increments; XL = cross-cutting behavior requiring staged delivery. Assign an implementation owner and reviewer and estimate each increment before sprint commitment.

## Category-based sprint setup — 2026-10-19

Requested follow-up: organize the seven planned tickets into category-based sprints. Checked all 13 board-1 sprints: 12 closed, no active sprint, and one future sprint, **Data proliferation 2** (ID 336), with no goal or dates returned. Jira still reports read-only access, and sprint creation is unavailable in the discovered operations. No sprint was created, renamed, started, or populated.

Prepare these three future sprint containers on board 1 when write access is available:

| Order | Proposed sprint name | Tickets and internal order | Sprint goal |
| --- | --- | --- | --- |
| 1 | Budget and Expense Management | FP-59 → FP-60 → FP-61 | Extend shared-budget permissions, reconcile expense splits and manual settlements, and support durable expense drafts with safe synchronization. |
| 2 | Wiki and Shopping Integration | FP-62 → FP-63 | Improve discovery of reviewed local-language product/recipe knowledge and turn recipes into market-aware shopping lists with explicit purchase-to-expense conversion. |
| 3 | Seller and Messaging | FP-57 → FP-58 | Enable an approved seller profile/offer pilot and private buyer-to-seller text conversations with ownership and participant access controls. |

This is the default sequential order for one implementation team. Content inventory for sprint 2 can begin alongside sprint 1; core shopping lists do not depend on settlement/offline work, but their estimates depend on verified budget totals. Seller work is an independent product track, with messaging following seller availability. Keep detailed ticket acceptance checks from the individual plans below.

No start/end dates or durations are assumed. These are category groupings, not validated sprint-capacity commitments: estimate the tickets and split oversized increments into follow-up sprints before starting. In particular FP-61 is XL and should not be promised alongside all FP-59/FP-60 increments without capacity evidence.

Before applying the setup, inspect the current contents and intended purpose of **Data proliferation 2**. If it already serves the wiki category, reuse it for that category rather than creating a duplicate; otherwise preserve it. Recheck the seven tickets' current sprint membership, then assign each to exactly one selected future sprint without changing workflow status. Verify resulting sprint goals and membership after writes. Creating future containers and assigning backlog tickets is authorized by this request; starting a sprint and choosing calendar dates remain unscheduled work.

## FP-57 — Seller user addition

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-57). Roadmap O01. Size: L. Depends on verified account isolation and operator authorization.

**Outcome and scope:** An existing user can apply as a seller, receive admin approval, and manage their own public stall profile and offers. Preserve user/admin role values; seller participation is an attached capability, never an admin role. Start with a limited manually supported pilot. Orders, payments, delivery, and automatic official-price publication are outside this proposal.

**Implementation plan:**

1. Define public/private profile fields, market association, verification meaning, approval/rejection/suspension rules, and offer freshness/expiry policy. Decide whether one seller may have multiple stalls; proposed first release is one profile with explicit market association.
2. Add additive Sequelize migrations for seller profiles and offers with ownership, review state, unit/quantity, price, availability, timestamps, and audit metadata. Keep offers separate from official prices and FP-65 observations.
3. Implement authenticated application/profile/offer APIs under `/api/freshprice/*`, operator review APIs, public approved-profile reads, pagination, and server-side ownership checks. Recheck seller state on every write; suspension removes offers from public discovery without destroying history.
4. Add application/status UI, seller dashboard, public profile/offer pages, and admin review/report handling. Display price units, market, freshness, and account state clearly.
5. Enable the pilot through a reversible availability control; record approval/suspension operations and track active sellers and fresh offers.

**Acceptance and verification:** Applicant cannot self-approve or access operator endpoints; seller A cannot modify seller B; pending/rejected/suspended sellers cannot publish offers; public responses exclude private contact/reviewer data; offer changes never modify official prices or observations. Verify state changes and reload persistence in real PostgreSQL and browser flows, including suspension while an edit form is open and migration rollback/reapply on disposable data.

## FP-58 — Private text messaging

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-58). Roadmap O02. Size: L. Depends on FP-57 for the proposed seller conversation entry point.

**Outcome and scope:** A signed-in shopper can privately contact an approved seller from a profile or offer. First release is one-to-one text with inbox, unread counts, pagination, and visible send failures. Attachments, group chat, typing indicators, presence, and read receipts are later scope. Budget discussion would need its own membership contract.

**Implementation plan:**

1. Define conversation identity, who may initiate, blocking/reporting, suspension behavior, and message retention/deletion. Proposed default: suspension blocks new messages while participants retain their own existing history; block prevents further contact. Limit moderation access to reported cases and audit it.
2. Add conversations, participant/read-cursor records, messages, and reports. Enforce unique client message IDs per sender/conversation and stable server ordering.
3. Build participant-authorized read/send/pagination/read-state endpoints. Persist messages transactionally before emitting notifications. Enforce message length and send-rate limits; make read-state updates monotonic across tabs.
4. Build seller entry point, inbox, conversation view, sending/sent/failed states, retry, and block/report UI. Begin with bounded incremental polling and reuse notifications; choose real-time transport only if pilot latency/load requirements justify it.
5. Add operational controls for disabling new messaging and handling reported content, then pilot with approved sellers.

**Acceptance and verification:** Nonparticipants cannot enumerate, read, send to, or change a conversation; concurrent/lost-response retries create one message; pagination has no omissions or duplicates; unread counts survive reload; blocking/suspension is honored immediately on the server; HTML-like message text renders safely. Test two real sessions, a third unauthorized account, failed sends, duplicate retries, notification failure after successful persistence, and mobile keyboard/scroll behavior.

## FP-59 — Budget feature update

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-59). Roadmap O04. Size: L when phased. Depends on verified existing budget reliability and sharing behavior.

**Outcome and scope:** Extend existing shared budgets with explicit roles and controlled lifecycle features. Current local work already covers scheduled-budget invitations, expiry, contributors, leave/removal, own-expense permissions, account isolation, online saves, and server totals. Revalidate and reuse it. Proposed increments: viewer role first, ownership transfer second, recurring templates third. Sharing current daily/monthly budgets stays deferred until its lifecycle is defined.

**Implementation plan:**

1. Reconcile FP-56/FP-64 code and release state; document a permission matrix for owner, contributor, viewer, former member, and outsider. Specify owner-only operations and historical access after removal.
2. Add compatible membership roles; migrate existing accepted members to contributor without widening access. Enforce viewer read-only behavior in every budget/expense mutation and update invitations and role management UI.
3. Add transactional ownership transfer requiring the recipient to be an active accepted member and explicitly accept. Ensure exactly one owner, reject stale/concurrent transfers, and audit/notify the outcome.
4. Add recurring templates only after role/transfer behavior passes: create new budget instances with explicit Philippine dates/timezone and independent expenses. Define calendar-month/end-of-month behavior, retry deduplication, membership carryover, and pause/cancel rules before implementation.
5. Refresh private state and invalidate stale responses after role/owner changes. Preserve existing personal budget behavior and account-switch clearing.

**Acceptance and verification:** Viewer mutation requests are denied server-side; contributors retain only intended permissions; old owners lose owner rights after transfer; simultaneous transfers cannot create two owners; removed members cannot regain access through stale tabs. Recurrence produces one independent instance per period, with correct month-end dates and no copied actual expenses. Verify permissions, 201+ expense totals, account switches, reloads, invitation expiry, and concurrent membership changes against real DB/API sessions.

## FP-60 — Expense and settlement tracking

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-60). Roadmap O05. Size: L. Depends on reliable totals and stable shared-budget permissions; align with FP-59 roles before building.

**Outcome and scope:** Show who paid, who benefits, and remaining household balances. Track manual settlement records; do not initiate money transfers. Initial split methods: equal and explicit amounts. Percentages, multiple payers per expense, exchange rates, and payment integrations are deferred.

**Implementation plan:**

1. Define payer, expense author, beneficiaries, split shares, settlement sender/recipient, and currency as distinct concepts. Proposed currency is PHP; agree on payer/recipient confirmation and correction rules before implementing settlement state transitions.
2. Add split and settlement records with exact centavo arithmetic, audit/revision information, actor identity, and request idempotency. Preserve legacy expense semantics; propose old expenses default to their existing author as payer/sole beneficiary unless explicitly reviewed and edited.
3. Add transactional validation that shares sum exactly to the expense; allocate equal-split remainder centavos deterministically. Compute balances from server records and confirmed settlements, separately from spending totals.
4. Add payer/split expense controls, per-member balance breakdown, settlement entry/confirmation/history, and visible disputed/pending states. Preserve removed members in historical accounting while denying new writes from them.
5. Implement revision-aware expense/split corrections and settlement reversal records; avoid silently rewriting confirmed history.

**Acceptance and verification:** ₱100 split three ways totals exactly ₱100; member net balances sum to zero; a settlement changes balances without adding to expense totals; pending settlements have no confirmed financial effect; duplicate retries create one record; invalid splits and unauthorized payer/member changes leave records untouched. Verify concurrent edits, partial/full settlement, removal, reversals, history pagination, and totals after reload against PostgreSQL.

## FP-61 — Durable offline editing

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-61). Roadmap O06. Size: XL. Depends on account isolation, server idempotency, revision/conflict contracts, and settled budget permissions.

**Outcome and scope:** A budget expense draft survives browser restart and can sync safely after reconnection. Initial offline operations are expense creation and edits. Invitations, ownership transfer, membership changes, and settlement confirmation remain online. Current confirmed-online behavior remains the fallback until queue persistence and replay are proven.

**Implementation plan:**

1. Specify queue lifecycle and conflict choices, including authentication expiry, removed membership, deleted budgets, storage exhaustion, and local-data disposal on logout. Use account-scoped IndexedDB records; never replay another account's work or store bearer tokens in queue payloads.
2. Extend supported server writes with durable idempotency keys, expected revisions, transactional outcomes, and replay responses. Reauthorize each replay using the current session; return structured conflicts instead of overwriting newer server data.
3. Implement queued/syncing/synced/failed/conflict states, ordered operations per entity, retry backoff, local temporary IDs, reload recovery, and coordination preventing two tabs from replaying the same queue unsafely.
4. Add pending indicators, a sync center, conflict resolution, and retry/discard controls. Show pending amounts separately from confirmed server totals; persist the draft before claiming it is available offline.
5. Integrate with current PWA/cache recovery and deploy a versioned queue migration strategy. Offer foreground sync first; background sync is optional and must not be required for correctness.

**Acceptance and verification:** Offline create → restart → reconnect produces one persisted expense; server-committed/lost-response retries remain single writes; switching accounts never exposes/replays old work; concurrent tabs do not double-submit; revoked permission prevents replay; revision conflicts preserve the draft for resolution. Exercise real browser offline transitions, quota failure, expired sessions, deleted entities, queue schema upgrades, and mixed pass/failure batches with real APIs/DB. Verify pending totals never masquerade as confirmed spending.

## FP-62 — Wiki enrichment

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-62). Roadmap O08. Size: M per increment. Depends on existing wiki quality, review/import, and publication behavior.

**Outcome and scope:** Make reviewed product/recipe knowledge easier to find through local-language variants, recipe filters, and sourced seasonal browsing. Existing work includes publication controls, recipe discovery/pagination, moderation pagination, and documented starter-content population. Inventory actual target-environment coverage before proposing more content; local seeded records do not establish live coverage.

**Implementation plan:**

1. Audit active product/wiki/recipe coverage, source quality, aliases, review dates, and existing search behavior. Identify a small reviewed pilot and a concrete enrichment gap for each selected page.
2. Design locale/translation records linked to canonical product IDs and source revisions. Separate name aliases from translated editorial text; mark translations for re-review when the source changes.
3. Extend draft/edit/moderation APIs and UI for language variants, source attribution, and geographic/seasonal metadata. Preserve drafts on import and require explicit review before publication.
4. Add recipe search/filtering and seasonal browsing with pagination and empty states. Represent unknown seasonality honestly; scope regional claims to their documented geography and sources.
5. Add contribution recognition using opt-in public display names, without exposing emails or private reviewer data. Publish the pilot only after sources, translation quality, and navigation are reviewed.

**Acceptance and verification:** No duplicate canonical products from aliases/translations; rejected suggestions leave public content unchanged; source edits flag affected translations; drafts remain private; filters return only matching published recipes and paginate consistently; every new factual seasonal claim has provenance/review metadata. Verify real import/suggestion/moderation persistence, malicious content handling, mobile discovery, and existing product-to-price navigation. Automated ingestion and unsupported nutrition claims are outside this ticket.

## FP-63 — Shopping integration

[Jira ticket](https://fresh-price.atlassian.net/browse/FP-63). Roadmap O09. Size: M–L by increment. Depends on reliable budget totals and published recipes for recipe-derived lists; FP-65 observation trends are optional informational context, not official expense prices.

**Outcome and scope:** Turn a published recipe into a reusable shopping list and help users estimate basket cost before recording actual spending. First increment: lists, quantities, market-aware estimates, explicit conversion to expenses. Favorites and price alerts follow separately. Orders, checkout, payments, and automatic expense creation are deferred.

**Implementation plan:**

1. Inspect existing shopping/cart behavior and reuse it where suitable. Define recipe ingredient mapping, serving scaling, editable quantities/units, unmatched ingredients, and personal/shared list permissions. Proposed first release is personal lists linked optionally to an accessible budget.
2. Add persistent list/item records and idempotent APIs. Link recognized products by canonical ID; keep unmatched ingredients as editable text and prevent invalid automatic unit conversion.
3. Add recipe-to-list, item editing/check-off, and market-aware cost estimates with price basis, market, unit, freshness, and missing-price indicators. Use the existing official-price estimate contract; never silently substitute observation statistics or seller offers.
4. Show estimate versus remaining confirmed budget. On explicit purchase confirmation collect actual quantity/amount/date and create an expense with a stable source operation ID; the same item cannot produce duplicate expenses on retry.
5. Add favorites as a small follow-up. For alerts define threshold, unit/market, source freshness, cooldown, consent and unsubscribe; send only after a newly eligible price update and deduplicate delivery.

**Acceptance and verification:** Serving scaling preserves convertible units and flags incompatible ones; missing/stale prices do not become zero-cost certainty; changing market recalculates comparable items; denied/deleted budget links expose no private data; checking an item alone does not book spending; explicit confirmation/retry produces one expense and refreshed server totals. Test recipe/list persistence, account changes, mobile list use, offline pending state if FP-61 is integrated, and notification deduplication for the later alert increment.

## Delivery and verification requirements for every ticket

1. Before application edits, read the affected app-local AGENTS.md and current relevant code; the plan is a scope/dependency assessment, not a fresh source-code audit of all seven features.
2. Keep shared account conventions compatible, centralize frontend API calls through `src/api/client.ts`, and add FreshPrice domain APIs under `/api/freshprice/*`. Use additive Sequelize migrations; document new API/schema contracts and backend-before-frontend rollout. Rollback must preserve newly collected data.
3. Register each implemented ticket explicitly in the standalone local `testing/tickets/<TICKET>` system, with fixture requirements, acceptance mapping, expected scenario counts, and generated local seeds. Do not place local test assets into app repositories or relabel FP-65 whole-app coverage as feature coverage for a new ticket.
4. Run relevant unit/API, frontend lint/build, real PostgreSQL persistence/authorization/concurrency checks, and desktop/mobile browser flows for the implemented increment. Record actual results and skips; prior FP-65 successes do not verify these unimplemented features.
5. Complete staging checks, release sequencing, owner/reviewer sign-off, and memory-bank updates before marking delivery complete. Publish the agreed plans to Jira only through a connection with write access; this review did not attempt a write.

## Planning sources

- Live [Fresh Price backlog](https://fresh-price.atlassian.net/jira/software/projects/FP/boards/1/backlog), plus linked FP-57–FP-63 issue details retrieved October 19, 2026.
- [Project spec](project-spec.md), [current progress](../memory-bank/progress.md), and [todo](../memory-bank/todo.md).
- [September audit and optional roadmap](feature-audit-and-roadmap-2026-09-12.md): the source of the proposed title-to-scope mapping. Its historical defects are not treated as newly confirmed defects.
- [FP-64 sprint context](fp-64-sprint-review-2026-09-12.md): historical planning context; current FP-56 budget-tightening scope and October progress take precedence over its older ingestion mapping.
