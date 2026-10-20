# FP-60 — Expense splits and manual settlements

Local implementation, 2026-10-19. Frontend and backend branches `FP-60` start from the reviewed FP-59 commits (`5dc479f9` / `aa866602`). FP-59 PRs remain open; FP-60 is not committed, released or verified in staging. Jira remains In Progress until review and delivery checks finish.

## Accounting rules

- PHP only. Existing expense totals retain the positive whole-peso integer contract. Beneficiary shares and manual payment amounts accept exact centavos. Maximum per-record value is PHP 2,147,483,647; accumulated balances reject unsafe integer serialization rather than round. No exchange rates, percentage splits, multiple payers or money-transfer integration.
- Author, payer and beneficiaries are separate. Unsplit historical expenses use the author as payer and sole beneficiary and create no household debt. Equal shares sort numeric member IDs and distribute remainder centavos to the first IDs; explicit shares must sum exactly, including allowed zero shares.
- Only the author may propose/correct an expense split. Current contributors/owners may be payers, current accepted members including viewers may be beneficiaries. A different payer must confirm; author-as-payer confirms atomically. Pending/disputed proposals have no financial effect. The last confirmed revision remains effective and the expense amount remains unchanged until a new payer confirms.
- Corrections append revisions and require a reason after a confirmed split. Split proposals require `expectedRevision`; confirmed proposals recheck expense revision, current author/payer write permission and beneficiary membership. Ordinary tracked expense update/delete also require revision. Use split correction controls for tracked amount changes; moving tracked expenses between budgets is blocked. Ordinary non-financial edits supersede pending proposals.
- Net balance = paid − beneficiary shares + confirmed payments sent − confirmed payments received. Positive means the member is owed; negative means the member owes. Sum is zero. Settlements never add to spending totals.
- Sender records an external payment; recipient confirms/disputes receipt. Both must currently have write access. Payment cannot exceed the current sender debt or recipient credit, checked at creation and confirmation under the scheduled budget lock. Pending proposals can coexist; only payments fitting current balances can confirm.
- Proposer may cancel a pending/disputed record. A confirmed payment is immutable. Either participant may request a full reversal with a reason; the other participant confirms/disputes. Reversals are distinct linked records, with only one pending/confirmed reversal per original payment and at most one confirmed reversal enforced by a partial unique index. No partial reversal UI.
- Removing a member preserves confirmed numeric identities and username snapshots, paid/share/payment breakdown and liabilities; it denies access and new writes. Reconfirming pending participant changes requires active permissions. Resolving historical balances with an inactive member requires explicit re-invitation/write access; no owner override of another person's confirmation.
- Deleting a tracked expense appends a confirmed void revision and retains its historical key and snapshots after the expense FK becomes NULL. Confirmed payments remain, potentially producing a refund balance; they are reconciled with explicit records rather than silently erased. Scheduled budget soft deletion retains accounting history.

## API and UI

All routes use authenticated `/api/freshprice/user`; authenticated identity overrides request-body identity. Read access follows FP-59 membership; viewers cannot mutate. Split controls appear on scheduled expense history rows; balance/payment controls appear under each scheduled budget's “Balances and settlements”. History shows statuses, revision/reasons, actor usernames, timestamps and IDs. Actions come from server permissions. Read errors have explicit retry controls; drafts retain fetched revisions and stable retry UUIDs. Private data ignores late responses after account switches. Split expansion survives expense-list refresh.

Split proposals and settlement creation use UUID request IDs unique per creator/table; same-content retries return the existing record and changed-content reuse returns 409 after reauthorization. Stable history order is createdAt/id descending, 25 rows/page. Balances aggregate all persisted records independently of history pages. New monthly recurring instances do not copy finance records or memberships; ownership transfer preserves author identities and balances.

## Rollout and rollback

Release FP-59 migrations/backend and frontend first. Rehearse FP-60 on a restored staging database. Back up, then apply `20261019000004-budget-accounting.cjs`, deploy FP-60 backend, verify legacy neutral breakdown, exact 100/3 split, competing edits/payment confirmations and removed-member denials. Deploy frontend after backend readiness and verify desktop/mobile split, pending payment, receipt confirmation and reversal, plus ordinary expense CRUD. Frontend rollback can retain schema/data. Migration down refuses any split/settlement rows; never delete collected financial history to permit rollback. Rolling backend back to FP-59 while accounting records exist would bypass expense revision/void protections: retain FP-60 accounting guards or stop expense writes pending a forward fix.

## Local verification

See `testing/tickets/FP-60/COVERAGE.md` for actual final execution and counts. Local fixtures, DB helpers, executable seeders and reports stay outside application repositories. Local PostgreSQL/browser checks do not establish staging or production readiness.

Review fixes (2026-10-19): delete prompts retain the reviewed revision/amount across refresh; inactive beneficiaries require explicit removal from new correction drafts while confirmed history remains intact; optional-date payment retries reuse their persisted date across midnight after authorization. See `fp-60-review-fixes-2026-10-19.md` for regressions and final validation.
