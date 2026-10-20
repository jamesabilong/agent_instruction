# FP-59: first increment — viewer roles

Follow-up on October 19: ownership transfer and monthly templates are now implemented locally; see `fp-59-lifecycle-2026-10-19.md` and the latest progress entry. The increment-only scope and validation below are retained as the first delivery record.

Started October 19, 2026. Jira FP-59 is In Progress in active sprint 337, Budget and Expense Management, October 19–November 2 (Asia/Manila), using a two-week sprint with automatic completion disabled.

## Scope and baseline

Frontend and backend `FP-59` branches were created from the clean, published `FP-65` heads, retaining the preceding budget/wiki/observation implementation. The baseline already has scheduled invitations with seven-day expiry, contributor-owned expense changes, accurate server aggregates, membership removal/leave, actor validation and account-state isolation. Production release verification for that baseline remains distinct from local code readiness.

This increment adds invitation/member roles and owner role management. Ownership transfer and recurring templates remain subsequent FP-59 increments; the ticket must stay In Progress. Current personal daily/monthly budgets remain private. Existing monthly copy controls are not durable recurring templates.

## Permission matrix

| Action | Owner | Accepted contributor | Accepted viewer | Pending/former member or outsider |
| --- | --- | --- | --- | --- |
| Read scheduled budget, all shared expenses, totals and activity | Yes | Yes | Yes | No |
| Add own shared expense | Yes | Yes | No | No |
| Edit/delete own shared expense, including moving it elsewhere | Yes | Yes | No | No |
| Edit/delete another member's expense | No | No | No | No |
| Manage budget, allocations, invitations, roles or member removal | Yes | No | No | No |
| Voluntarily leave | Owner uses deletion instead | Yes | Yes | No |
| Respond to own unexpired pending invitation | Not applicable | Not applicable | Not applicable | Pending invitee only |

Removal revokes historical shared-budget access, preserving the records for remaining authorized members. Viewer downgrade preserves reads but immediately blocks new mutation authorization, including replay and changes to expenses the viewer originally created. Parent-row locking serializes role changes with expense mutations; a mutation that commits before a downgrade remains valid.

## Implementation

- Add a checked membership `role` column with a contributor default; existing accepted members retain their rights. `shareRole=collaborator` remains the contributor API representation for compatibility; viewer is additive.
- Allow an owner to invite viewers and change pending/accepted member roles. Validate role values, derive the actor from authentication, and audit/notify changes in the same transaction.
- Recheck write capability for the source and destination shared budget during create/update/delete, including keyed retries. Preserve read/summary/activity and voluntary-leave authorization.
- Show role-specific invitation guidance, role labels and owner role selectors. Hide viewer expense mutation links/controls and exclude viewer budgets from expense destinations; direct/stale links still hit server authorization. A role change refreshes store state using the existing write/hydration session guards.

## Local verification assets

`testing/tickets/FP-59` owns six backend unit regressions, two viewer-history component regressions and five real-data feature scenarios. Fixtures define synthetic owner/member/outsider identities, canonical products/markets and existing official price data. Seeds regenerate under `testing/.local` and use runner-owned disposable PostgreSQL only.

Feature scenarios: owner browser invitation/acceptance and viewer controls; downgrade/promotion/replay/move/revocation with preserved historical totals; budget/allocation/member authorization and leave; owner browser changes to pending invitation roles and invalid-role rejection; migration unsafe-rollback guard, legacy backfill/reapply and database role constraint.

FP-59 also explicitly runs the existing 30 whole-app regression journeys authored under FP-65 using a separate FP-59 fixture copy and fresh database. Those remain broad regression coverage, not newly authored FP-59 acceptance tests. Neither suite claims ownership-transfer or recurrence coverage.

## Release and rollback

Final local verification: frontend lint/build and 257 unit checks, 145 backend unit checks and 36 runner/fixture/report checks passed. The complete default seeded execution passed all five FP-59 feature/migration cases and all 30 reused whole-app regression cases, zero failures/errors/skips, with each group's disposable PostgreSQL removed afterward. First-run selector diagnostics and a misplaced UI role control were fixed before this final execution. No legacy opt-in database suite or staging/production host certification is claimed.

Apply the migration and role-aware backend before the frontend. Never run an older backend that ignores member roles while viewer memberships exist. Schema down refuses such a rollback; application rollback must likewise remove viewer access first. No production migration, push or deployment is part of this increment.
