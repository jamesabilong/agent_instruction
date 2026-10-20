# FP-59 pre-commit fixes — 2026-10-19

All three confirmed findings from `fp-59-precommit-review-2026-10-19.md` are fixed and covered by registered real PostgreSQL regressions. Changes remain local/uncommitted on the matching FP-59 branches. No stage, commit, push, Jira change or deployment.

## Membership survival after transfer

New migration `20261019000003-preserve-budget-inviter-history.cjs` changes the historical inviter reference to nullable ON DELETE SET NULL / ON UPDATE CASCADE. Model nullability and association deletion behavior match it. Existing inviter attribution is retained until that account is deleted; other accepted/pending memberships then survive with no inviter rather than cascading away. No historical invitation is reassigned to a different person.

The regression creates independent accounts, transfers ownership, deletes the former owner through the operator API, and verifies the remaining viewer's access, preserved pending invitation and later acceptance, and continued owner-only management. It checks null inviter values and rejects unsafe rollback. Empty migration down/up is exercised before lifecycle scenarios. Down refuses after null inviter values or ownership-transfer history exist; keep the migration on application rollback.

## Future instance ID protection

Generated budgets now receive crypto.randomUUID IDs. The locked template cursor and unique template/occurrence pair provide idempotence; IDs no longer need to encode a guessable future occurrence. Existing deterministic IDs and metadata remain valid, including edits and detection of soft-deleted periods. An ordinary budget preclaiming an old-style future ID cannot block generation or be overwritten.

The two-account regression shares a generated instance with a viewer, lets them create a personal budget using the predicted next legacy ID, and generates the now-due next period concurrently. Exactly one different UUID instance is created for the template owner. The preclaimed budget remains the viewer's private budget, the actual generated instance remains private to its creator, owner edits work, unauthorized edits fail and retries create nothing extra.

## Fair due processing and recovery

Sweeps use stable UUID keyset pagination in pages of 50, with one business-date cutoff and one attempt per ID per sweep. Successful templates leaving the due set cannot shift an offset and skip later work. Errors are collected until all later pages have been processed; failed records remain available for the following sweep. A failure cannot monopolize the front page. Existing per-template row locks, transactional cursor/instance creation and the 24-period transaction cap remain in effect.

The regression creates 51 real templates and installs a runner-only PostgreSQL trigger that rejects generated inserts for the first 50. The healthy later template generates in the same sweep; a second sweep reports the same 50 failures without duplicating successful instances. Removing the trigger allows the failed templates to recover with independent empty instances and advanced cursors. The trigger is removed in finally; the runner removes the whole disposable database at completion. This test uses an operational database failure rather than relying on the now-fixed ID collision to create poison work.

## Final validation

- `npm run test:e2e:chromium`: 15 feature + 30 whole-app cases, all 45 pass, zero failures/errors/skips. Report `2026-10-19T08-41-22-990Z-cdcf0310`; exact JUnit counts and disposable PostgreSQL cleanup verified.
- Frontend lint and production build pass; all 260 frontend unit checks pass with `npm run test:unit -- --maxWorkers=2`.
- Backend default checks: 166 pass; 23 opt-in database checks remain skipped in that command. The 15 registered feature cases use real migrated PostgreSQL, including the new migration and all three defect regressions.
- All 36 runner/scope/fixture/report checks pass. Application diff whitespace checks pass.

The acceptance suite is registered as 15 feature cases in the local standalone testing workspace; historical review probes and their JSON output remain reproduction evidence for the old defects, not current acceptance tests. No known code blocker remains from the three-finding review. Apply all three October 19 migrations before the backend, release frontend afterward, and complete the documented staging/production checks separately.
