**FreshPrice audit and future update plan**

Date: 2026-09-12. Recommendation: repair budget access and data reliability first, improve shared-budget usability next, then expand sourced wiki coverage. Treat seller accounts and private messaging as optional product expansions.

Implementation follow-up: Updates 0 and 1 have local code changes, with release verification in progress. Original audit findings and baseline results below describe the pre-change revisions. See [Update 0/1 implementation and release notes](budget-updates-0-1-2026-09-12.md) for current status. The new [FP-64 sprint review](fp-64-sprint-review-2026-09-12.md) maps the Jira plan into Update 2 and adds maintenance readiness (M12) and an optional ingestion pilot (O10).

“Mandatory” means required for the next core update or to resolve an existing material defect. “Optional” means a later investment that can be deferred. An optional feature still has minimum requirements before it can launch.

**Scope and confidence**

Reviewed the local FreshPrice frontend, FreshPrice backend modules, shared account/community/notification code, models, migrations, and relevant tests. Frontend revision: `a44c812`; backend revision: `4805345`.

This is a repository audit with local verification. Production data, deployed behavior, user analytics, database concurrency, browser accessibility, and usability with real users were not measured. Findings distinguish reproduced logic defects, source-confirmed behavior, and risks requiring further validation. Existing deployment notes were not treated as current production incidents.

“Data proliferation for wiki” is interpreted as increasing useful, sourced product and recipe coverage, improving import and editorial operations, and making that content easier to discover.

**Current capability inventory**

| Area | Present in the code | Main opportunity |
| --- | --- | --- |
| Shopping and prices | Public price lists, trends, product details, market selection, user price submissions, admin review/publishing | Preserve these flows while adding budget and seller capabilities; distinguish seller offers from approved market prices. |
| Budgets | Current daily/monthly budgets, dated scheduled budgets, sub-budgets, expenses, product-linked expense entry | Accurate totals at larger volumes, reliable saves, account isolation, clearer budget context. |
| Shared budgets | Scheduled-budget invitations by username/email, accept/decline, owner removal, accepted collaborators, expense attribution/member filters | Sharing is implemented for scheduled budgets. Improve discovery, membership lifecycle, refresh, and permissions. |
| Wiki | Public product wiki and recipes, admin editing, draft/published state, edit suggestions, moderation, revision records, sources, CSV import | Grow and measure content coverage; strengthen publication quality and review workflows. |
| Wiki import | Maximum 500 rows per request, product/alias matching, duplicate/ambiguous-name handling, per-row results, first-eight-row UI preview | Add change previews, completeness checks, and editorial staging to the existing importer. |
| Community | Public posts, comments, voting, activity pages, admin moderation | Useful discussion foundation; separate from private chat. |
| Notifications | Persisted notifications, read/unread support, 30-second polling hook | Add relevant budget events and actionable links; reuse infrastructure where suitable. |
| Seller accounts | User/admin role convention; no seller model or seller workflow found in reviewed application code | New domain requiring profiles, approval, listing ownership, and offer provenance. |
| Private chat | No conversation/message domain, private inbox routes, or real-time transport found in reviewed application code | New domain requiring authorization, delivery state, abuse controls, and operations. |

Inventory evidence: [frontend routes](D:/Project/Web/FreshPrice/fresh-price-front/src/router/index.tsx), [budget routes](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/routes/budgetRoutes.js), [wiki service](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/productWikiService.js), [wiki admin UI](D:/Project/Web/FreshPrice/fresh-price-front/src/features/admin/wiki/ProductWikiManagementPage.tsx), [community routes](D:/Project/Web/FreshPrice/platform-backend/src/routes/communityRoutes.js), [user model](D:/Project/Web/FreshPrice/platform-backend/src/models/user.js), and [notification hook](D:/Project/Web/FreshPrice/fresh-price-front/src/hooks/useNotifications.ts).

**Audit findings, in priority order**

P0 = address immediately, before feature expansion. P1 = required in the next relevant core update. P2 = planned improvement.

| ID | Priority / evidence | Finding and impact | Required response |
| --- | --- | --- | --- |
| A01 | P0 — reproduced with local mocks | `listExpenses` initially scopes to the authenticated user, but `memberId` replaces that scope even when no scheduled budget is supplied. An authenticated caller can cause a query for another user's expenses. | Permit member filtering only inside an authorized shared-budget scope; reject unscoped member filters and test cross-account reads. |
| A02 | P0 — reproduced with local mocks | Expense creation builds `{ userId: req.user.id, ...req.body }`. A body-supplied `userId` wins, so the service receives another user's identity and uses it for ownership and budget access. | Allowlist writable fields and derive the actor exclusively from authentication. Add create-route impersonation regressions. |
| A03 | P1 — source-confirmed privacy risk; browser scenario untested | Budget data persists under one `budget-storage` key. Logout clears auth but does not reset budget state. Login hydrates asynchronously, and failed hydration preserves existing data. Another account on the same browser can inherit stale budget state. | Clear private state on logout/account changes, scope caches by account, and discard requests from an earlier session. Test account A → logout → account B with slow/failed requests. |
| A04 | P1 — source-confirmed correctness gap | Hydration requests only the first 200 personal expenses and first 200 per shared budget. The UI calculates spending from loaded rows and ignores pagination totals. Larger histories can understate spending and overstate remaining funds. | Use server aggregates for totals and paginated expense lists. Preserve the backend's existing scheduled summary fields in the client contract. Test more than 200 rows and multiple date periods. |
| A05 | P1 — source-confirmed reliability gap | `addExpense` catches a failed save without rejecting; its caller then resets the form and navigates away. Some edits and scheduled-budget mutations retain optimistic local changes after failure, with no durable retry queue found. Hydration can replace them. | Make save outcomes explicit. Keep failed forms recoverable, roll back rejected changes, show retry state, and stop implying a pending sync unless a persistent queue actually exists. |
| A06 | P1 — concurrency risk from source; not DB-reproduced | Current and scheduled sub-budget allocation checks read a sum and then write without a surrounding transaction/parent lock. Concurrent requests can both pass against the same remaining allocation. | Serialize allocation and parent-amount changes in transactions with consistent parent locking. Add a database concurrency test. |
| A07 | P1 — product gap | Membership supports pending/accepted/declined and owner removal. No self-service leave route, invitation expiry field, budget activity history, or budget notification calls were found in the reviewed flow. Budget refresh is primarily hydration/action driven. | Add leave/cancel/expiry behavior, visible permissions, membership/activity feedback, and freshness handling. |
| A08 | P1 — source-confirmed editorial gap | Wiki source fields and substantive content are optional. The admin form defaults new content to published, while the backend model defaults to draft. Publication can therefore produce sparse or unsourced pages. Current live coverage is unknown. | Default new authoring/imports to draft; validate publication readiness on the server; inventory and prioritize coverage before a content expansion. |
| A09 | P2 — implementation absent in reviewed scope | Seller accounts and private messaging require new data, permission, UI, and moderation flows. Community comments and notification rows do not provide those capabilities. | Deliver bounded pilots after core reliability work; avoid treating either feature as a small UI addition. |

Evidence locations:

- A01: [expense query](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/expenseService.js:25), [controller forwarding](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/controllers/expenseController.js:20), and the `memberId` validator in [budget routes](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/routes/budgetRoutes.js).
- A02: [expense create controller](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/controllers/expenseController.js:59). Existing validators do not remove unknown body fields.
- A03: [logout](D:/Project/Web/FreshPrice/fresh-price-front/src/store/authStore.ts:24), [persisted budgets](D:/Project/Web/FreshPrice/fresh-price-front/src/store/budgetStore.ts:638), and [login hydration](D:/Project/Web/FreshPrice/fresh-price-front/src/features/auth/Login.tsx:49).
- A04: [hydration](D:/Project/Web/FreshPrice/fresh-price-front/src/store/budgetStore.ts:583), [scheduled totals](D:/Project/Web/FreshPrice/fresh-price-front/src/features/user/budget/budgetTypes.ts:203), and [current totals](D:/Project/Web/FreshPrice/fresh-price-front/src/features/user/budget/BudgetPage.tsx:331).
- A05: [expense mutations](D:/Project/Web/FreshPrice/fresh-price-front/src/store/budgetStore.ts:221) and [submit flow](D:/Project/Web/FreshPrice/fresh-price-front/src/features/user/budget/ExpenseInputScreen.tsx:382).
- A06: [current sub-budget write](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/budgetService.js:130) and [scheduled sub-budget write](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/budgetService.js:506).
- A07: [membership model](D:/Project/Web/FreshPrice/platform-backend/src/models/scheduledBudgetMember.js), [owner removal](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/budgetService.js:704), and [scheduled-budget UI](D:/Project/Web/FreshPrice/fresh-price-front/src/features/user/budget/ScheduledBudgetScreen.tsx).
- A08: [wiki validation](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/productWikiService.js:163), [wiki writes](D:/Project/Web/FreshPrice/platform-backend/src/apps/freshprice/services/productWikiService.js:335), and [admin published default](D:/Project/Web/FreshPrice/fresh-price-front/src/features/admin/wiki/ProductWikiManagementPage.tsx:71).

**Mandatory backlog**

Sizes are relative scope, not delivery promises: S = focused change; M = coordinated UI/API work; L = several flows or a data migration. Assign owners and estimates during implementation planning.

| ID | Deliverable | Size | Depends on | Acceptance criteria |
| --- | --- | --- | --- | --- |
| M01 | Expense authorization repair: A01/A02 | S | None | Actor comes only from auth; unscoped member filters cannot query others; own and authorized shared-budget paths still work; denial returns an intentional 4xx. |
| M02 | Account-scoped budget state: A03 | M | None | Logout clears private in-memory/persisted state; switching accounts never displays the prior account's data, even when hydration fails or returns late. |
| M03 | Accurate totals and complete expense navigation: A04 | M | M01 | Totals match the database for 201+ expenses; date/member/sub-budget filters have defined scope; users can page through the full history without changing totals. |
| M04 | Reliable saves and recoverable errors: A05 | M | M02 | Failed creates preserve user input; failed edits/deletes show the server-consistent state or explicit retry state; navigation only follows confirmed success; retries do not create duplicates. |
| M05 | Budget allocation integrity: A06 | M | M01 | Two simultaneous allocations cannot exceed the parent limit; shrinking a parent cannot race an allocation write; failed transactions leave consistent data. |
| M06 | Shared-budget UX and membership lifecycle: A07 | L | M01–M05 | A user can discover sharing, invite, accept/decline, see who can do what, log an attributed expense, and leave. Owner can cancel invitations/remove members. Expired/removed access is rejected server-side. |
| M07 | Budget activity and freshness | M | M06 | Show actor, action, and timestamp for membership/expense changes. Refresh on focus/reconnect plus bounded polling while relevant. Display loading/stale/retry status. Budget notifications link to the relevant screen. |
| M08 | Wiki inventory and publication quality: A08 | M | None | Inventory distinguishes missing/draft/published/needs-review entries. Publishing requires useful content and source provenance; drafts may be incomplete. Existing pages needing review are flagged without an automatic bulk unpublish. |
| M09 | Sourced wiki content expansion | M + editorial work | M08 | Publish an initial batch of 25 priority product pages, or all eligible products if fewer. Every page passes editorial review and source checks; report actual coverage after import. |
| M10 | Wiki import and discovery improvements | M | M08 | Existing row preview gains new/update/unchanged/error classifications and meaningful change previews. Imports stage drafts, preserve revisions, and report per-row results. Product/wiki navigation preserves the user's return context. |
| M11 | Release regression and measurement | M | Relevant deliverables | Unit/build/lint checks pass; staging checks cover cross-account denial, shared invite→expense→remove, large histories, failed saves, and wiki draft→review→publish. Record baseline product metrics without storing private content in analytics. |
| M12 | Maintenance readiness — FP-43 | M | Release/deployment scope agreed | A static maintenance page is served by the frontend edge even when the API is unavailable; affected writes fail clearly; health checks remain usable; enable/disable and recovery are tested with PWA cache behavior. See the FP-64 review for the bounded first release. |

For M04, the first release can use confirmed online saves with honest offline status. A durable offline mutation queue is an optional later investment; temporary optimistic state must not be presented as reliable offline persistence.

**Shared-budget UX proposal**

Use one clear path: **Budgets → choose budget → overview → add expense → saved expense and updated remaining amount**. Keep the budget name, period, and “Personal” or “Shared” label visible during entry. Sharing currently belongs to scheduled budgets; keep that boundary explicit in the next release. Extending sharing to the current daily/monthly budget is optional.

The overview should show allocated, spent, remaining, date range, member count, and data freshness. Keep “Add expense” primary; place members and activity in dedicated views. Label summaries “All members” or the selected member so filtered rows are not confused with the entire budget total. Preserve the existing per-person attribution and filtering.

Use the existing owner/contributor model for the first improvement:

| Action | Owner | Accepted contributor | Pending/removed user |
| --- | --- | --- | --- |
| Read shared budget and its expense history | Yes | Yes | No |
| Add expense | Yes | Yes | No |
| Edit/delete expense | Own entries only | Own entries only | No shared-budget mutation access |
| Change amount, dates, categories, or members | Yes | No | No |
| Leave budget | Archive/delete through an explicit owner flow | Yes | Decline pending invite |

This is the proposed permission contract. Recheck membership on every shared-budget read/write, including mutation of an existing expense after removal. Keep prior member expenses in the owner's history so totals remain explainable; define corrections through recorded actions. Owners should see deletion consequences before confirming. Viewer roles and ownership transfer can follow later.

Test the revised screens on a narrow mobile viewport and desktop, with keyboard navigation, labeled inputs, focus restoration, readable error states, and screen-reader save feedback. UX recommendations here are hypotheses pending browser and user testing.

**Wiki data expansion proposal**

Start with an export of actual products and wiki coverage. Prefer active products with recent price data; use search/view analytics if available, then editorial prioritization. Repository assets and catalogue CSVs are not proof of production wiki coverage.

1. Build a coverage queue with product ID, canonical/local names, category, wiki state, completeness, sources, reviewer, and review date.
2. Prepare the first 25 pages with a useful summary, buying guidance, and storage guidance where applicable. Add cooking, nutrition, seasonality, and recipes only when appropriate and supported.
3. Record source title, URL, publisher, access/review date, reuse permission or license where needed, and which claims the source supports. Prefer relevant primary agricultural, food, and research sources; verify their suitability during content production.
4. Normalize aliases against the existing product catalogue. Use canonical product IDs in import files; retain current duplicate and ambiguous-name safeguards.
5. Import as drafts through the existing CSV flow, review changes and citations, then explicitly publish. AI-assisted drafts, if used, receive the same human checks.
6. Expand toward the next 75 priority pages after the pilot review. Add coverage, stale-review, and broken-link reports. Review factual corrections through existing suggestions and revision history.

Proposed acceptance targets: 100% of newly published pages have traceable sources and reviewer/date metadata; zero duplicate canonical product pages; every rejected import row has an actionable reason. Decide a later coverage percentage only after counting eligible active products. Do not claim every field needs filling for every product category.

**Optional backlog**

| ID | Feature | Benefit | Scope / dependency | Launch condition |
| --- | --- | --- | --- | --- |
| O01 | Seller account pilot | Connect shoppers with identifiable local sellers and current offers | L; M01/M02/M11, seller permissions, review process, and separate offers | Approved sellers can manage only their profiles/offers; public pages show market, unit, price timestamp, and account status. |
| O02 | Private text messaging | Allow focused buyer/seller questions | L; O01 for a seller-chat pilot, conversation access controls and moderation | Authorized participants only; message retries are deduplicated; block/report/rate limits work; unread and failed-send states are clear. |
| O03 | Budget-scoped discussion | Discuss household purchases beside their budget | M after M06; reuse conversation core if O02 exists | Only authorized budget members can access it, including after membership changes. |
| O04 | Advanced shared budgets | Viewer role, ownership transfer, share current budgets, recurring household templates | M–L after M06 | Permission and recurrence rules are explicit; existing private budgets retain their intended access. |
| O05 | Expense splits and settlement tracking | Show who paid and how costs are divided | L after M03/M05 | Payer, beneficiary, split, and settlement are distinct; totals reconcile and changes are auditable. |
| O06 | Durable offline editing | Support unreliable connectivity | L after M02/M04 | Account-scoped queue, idempotency, conflict handling, and visible pending state survive restart; revoked permissions are honored. |
| O07 | Rich messaging | Attachments, typing/read receipts, presence, push notifications | M–L after O02 | Text chat is useful and support capacity is proven; media access and lifecycle are enforced. |
| O08 | Wiki enrichment | Local-language variants, richer recipe search, seasonal browsing, contribution recognition | M after M08–M10 | Core content quality is maintained; translations remain linked to reviewed source revisions. |
| O09 | Shopping integrations | Recipe-to-shopping-list, budget-aware basket planning, favorites and price alerts | M–L after reliable budget totals | Suggestions retain market/unit/date context and distinguish estimates from actual expenses. |
| O10 | Controlled external ingestion pilot — FP-56 | Reduce repetitive collection of wiki source material | M–L after M08/M10; one approved source and one bounded batch first | Source identity, retrieval date, product matching, deduplication, review staging, error reporting, and rerun behavior are verified. No automatic publication. Price ingestion, if intended, needs a separate unit/market/date/provenance contract. |

Optional prioritization: seller profiles/offers first if marketplace participation is the product direction; private seller chat next if users need an in-app contact channel. Budget-scoped discussion can be prioritized independently if household coordination is the stronger need. Orders, payments, delivery, and a full commerce platform require separate scope.

**Seller account MVP, if selected**

Keep the existing `role === 0` user and `role === 1` admin behavior compatible. Model seller participation through a profile/capability attached to a user, with `pending`, `approved`, `rejected`, and `suspended` states. Seller approval must not grant operator/admin powers.

Provide application, admin review, public stall/profile, market association, operating information, and seller-owned catalogue offers with unit, availability, and update time. Offer management must allow only the owning approved seller. Include reporting and suspension handling. Collect only profile information needed for this pilot, and make verification meaning explicit.

Store seller offers separately from approved market prices. The current submission model recognizes `user` and `admin` sources; add explicit seller provenance through a compatible migration if seller submissions enter moderation. Seller changes must never directly replace official prices. Start with a small manually supported pilot, for example 5–10 sellers, and measure active sellers and fresh offers before expanding.

**Chat MVP, if selected**

Start with text-only buyer/seller conversations opened from a seller profile or offer. Show context, inbox/unread counts, pagination, timestamps, and sending/sent/failed state. Reuse account and notification foundations; build dedicated conversations, participants, and messages. Recheck membership and suspension status when reading or sending.

Require message IDs or idempotency keys, bounded message sizes and send rates, blocking, reporting, a scoped moderation workflow, and a documented retention/deletion policy. Moderation access should be limited to the cases and staff who need it. Persist delivery before notifying recipients; do not equate successful notification with successful delivery.

Choose polling or a real-time transport after setting latency and concurrent-user requirements. WebSockets are an implementation option. File uploads, voice/video, typing indicators, and read receipts can wait until the basic conversation is useful and operable.

**Delivery order and measures**

| Update | Scope | Exit gate |
| --- | --- | --- |
| 0 — immediate repair | M01, M02 | Cross-account access and state isolation regressions pass. Verify deployment through the normal release process. |
| 1 — dependable budgets | M03–M07 plus M11 | Large-history totals reconcile; save failures recover; two users complete invite→expense→remove without stale access. |
| 2 — useful wiki coverage / FP-64 | FP-55 → M08–M10; FP-43 → M12; M11; FP-56 → optional O10 | Initial reviewed batch is published; quality/coverage and maintenance recovery work. One-source ingestion is a stretch item after draft review is reliable. Content preparation may begin during budget work. |
| 3 — optional seller pilot | O01 | Seller ownership, approval, suspension, offer freshness, and official-price separation pass staging checks. |
| 4 — optional messaging pilot | O02, or O03 if household coordination takes priority | Private access, retry, unread, blocking/reporting, and removal behavior pass. |

Collect a baseline before setting commercial targets. Useful measures: invitation acceptance and time to first shared expense; save failure/retry rate; discrepancies between displayed and database totals; reviewed wiki coverage and wiki-to-price navigation; active approved sellers and fresh offers; inquiry response rate and report rate. Suggested usability goal: at least 4 of 5 pilot participants complete invite acceptance and expense entry without assistance. These are proposed measures, not observed results.

Use additive Sequelize migrations and preserve current API contracts. Stage permission, cache, and data changes with realistic fixtures. Make seller/chat availability controllable for a limited pilot and rollback. Avoid destructive schema cleanup in the initial rollout.

**Verification performed**

| Check | Result |
| --- | --- |
| Frontend `npm run test:unit` | 31 files / 199 tests passed |
| Backend `npm run test:unit` | 18 files / 103 tests passed; shared backend suite includes adjacent app tests |
| Frontend `npm run lint` | Passed |
| Frontend `npm run build` | Passed, including PWA generation; non-blocking warning about outdated Browserslist data |
| A01 local mock reproduction | Authenticated user 7 plus unscoped member 42 produced a query for user 42 and zero shared-budget access checks |
| A02 local mock reproduction | Authenticated user 7 plus body user 42 passed actor 42 to the create service |
| Production/API penetration test, DB integration/concurrency, browser E2E, accessibility, live data inventory | Not run |

The reproductions evaluated the existing service/controller code with in-memory mocks; they did not read or modify user data. The test suites passed but lack coverage for the two reproduced cases. Tests/build initially hit the sandbox's process-spawn restriction and passed after approved execution outside that restriction.

The original audit was documentation only. Later Update 0/1 implementation and FP-64 planning are tracked in the linked follow-up documents; no production deployment or Jira mutation is implied by those local changes.
