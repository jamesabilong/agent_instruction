# FP-59 pre-commit review — 2026-10-19

Resolution: all three findings below are fixed and covered by registered regressions; all 45 seeded cases pass. See `fp-59-review-fixes-2026-10-19.md` for the final implementation, report identity and rollout requirements. The original review/reproduction record follows.

Recommendation: hold the commit for three confirmed P2 correctness/availability defects. Reviewed the uncommitted role, ownership, recurrence, API/store/UI and migration changes on matching FP-59 branches. Application source remains unchanged by this review; no stage, commit, push or deployment.

## 1. Former-owner account deletion removes unrelated members

Location: `platform-backend/src/apps/freshprice/services/budgetOwnershipService.js:45` (acceptance), interacting with the existing `scheduled_budget_members.invited_by_user_id` CASCADE FK.

Create owner A and accepted members B/C; transfer to B and accept; delete A through the existing user service. The budget correctly survives with owner B, but C's membership is deleted because its inviter still references A. C changes from authorized collaborator to 404 without B removing them. The former owner's new contributor membership is removed as expected, but unrelated members must survive. The probe observed zero remaining memberships while the transferred budget and its new owner remained.

Preserve accepted memberships when their historical inviter is deleted, for example through a nullable SET NULL inviter relationship with a migration, or an explicit ownership-transfer strategy that avoids the cascade. Preserve audit attribution rather than silently rewriting historical invitations without a policy. Add a transfer → former-owner deletion → remaining-member access regression.

## 2. Another member can preclaim future recurring instance IDs

Location: `platform-backend/src/apps/freshprice/services/budgetRecurringService.js:56`; normal budget creation in `budgetMutationService.js` currently accepts arbitrary IDs of up to 80 characters.

Generate instance 1 and share it with another accepted member. Their authorized budget response contains `recurringTemplateId`, and the instance ID reveals the occurrence number. That member can create their own ordinary budget named `recurring:<template UUID>:2` using the normal scheduled-budget service/API contract. In a process-local simulation of the next Philippine month, the creator's generation fails with `SequelizeUniqueConstraintError`. Its transaction rolls back, its cursor stays due, and normal retries keep failing. The blocking budget belongs to user 3 while the template belongs to user 2. No unauthorized direct database mutation was used to create the collision.

Reserve the generated-ID namespace from ordinary budget creation (while permitting legitimate owner edits of existing generated budgets), or use independently generated IDs with the unique template/occurrence constraint as the deduplication key. Add a two-account regression covering a shared member's attempt to preclaim the next instance.

## 3. Failing templates permanently starve later due work

Location: `platform-backend/src/apps/freshprice/services/budgetRecurringService.js:66`.

Each sweep selects the same first 50 due templates ordered by next date/ID. A failure neither advances that template nor moves it out of the next batch. Create 51 due templates and ordinary-budget ID collisions for the first 50. Two complete sweeps each report the same 50 failures; the healthy 51st template remains due with zero generated instances. Hourly retries repeat the same selection forever, allowing one account's broken schedules to block unrelated due work. Even healthy batches above 50 are spread across hourly runs rather than drained in one sweep.

Page through due work with a stable cursor or use a fair claim/backoff mechanism so errors cannot monopolize the front batch. Keep failed templates retryable without starving others. Add a 51-template regression where the first batch fails and the later healthy template must still generate.

## Reproduction and limits

Run `node tickets/FP-59/review-probes.mjs` from local `testing/`. The independent harness creates and migrates a disposable PostgreSQL 14 database on localhost:55467, asserts its dedicated database identity, uses real services/models, and removes the container in finally. It does not modify application source, fixtures, the registered 42-case suite, or the previous passing suite's run identity. The cross-owner probe advances Date only inside its isolated Node process; host time and the production API are unchanged.

Final evidence: `testing/reports/fp59-review-probes-2026-10-19.json`, executed 2026-10-19T08:00:47.840Z. Both independent review executions completed and removed their disposable databases. These are intentionally diagnostic probes reproducing undesired behavior, not passing acceptance regressions. The previous 42-case pass does not cover these edge cases. Full suites were not rerun because application source was unchanged; staging/release gates remain separate.
