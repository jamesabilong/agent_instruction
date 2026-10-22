# FP-63 PR dependency and release gates — 2026-10-22

Reconciliation update (2026-10-22): FP-62 conflicts are resolved and full fresh tests pass; paired draft backend #59/frontend #57 are mergeable. FP-63 now explicitly depends on them and still needs its own refresh/retest. [Current reconciliation and gates](fp-62-reconciliation-2026-10-22.md) supersedes earlier FP-62 conflict/no-PR status below. No production release performed.

Status: **draft PRs created; do not merge**. No app source changes, integration commit, merge, production migration or deployment occurred during this check.

## Verified PRs and branch state

| Component | Draft PR | Head | Base | GitHub state |
| --- | --- | --- | --- | --- |
| Backend | [#58](https://github.com/jamesabilong/fresh-price-backend/pull/58) | FP-63 `9e78c65` | master `871acac` | CONFLICTING / DIRTY |
| Frontend | [#56](https://github.com/jamesabilong/fresh-price-front/pull/56) | FP-63 `7d8e4be4` | master `699c11ba` | CONFLICTING / DIRTY |

Both new PRs are linked to each other and attached to this chat. GitHub reports an empty statusCheckRollup on each PR; no automated CI pass is claimed. The repositories currently contain production-dispatch workflows triggered by master pushes, not the retained local acceptance suites.

Fetched remote refs before inspection. Non-mutating prospective merge-tree checks reproduce conflicts: frontend vite.config.ts and backend package.json. The feature branches predate the master-side test-runner reconciliation; do not replace master's sibling-testing commands/module aliases with the older feature versions when resolving conflicts. Keep FP-62/63 test discovery. No branch/worktree/index was changed by the merge-tree check.

## Dependency disposition

- FP-59/60/61: merged/released on master, per actual master history and existing release evidence. Reconcile the newer master-side test/config changes before release.
- FP-62: not on master. Its frontend `2fc10cd7` and backend `1fcb72d8` commits are ancestors of FP-63 and are included in both draft diffs. No open FP-62 PR was found. Jira still has FP-62 In Progress; its cached development summary reporting a merged PR does not establish code inclusion in master.
- FP-63: requires the FP-62 published-recipe/wiki prerequisites, existing budget/expense/offline contracts, and shopping migration 20261020000004. Current PR scope includes FP-62 enrichment code/UI and migrations 20261020000002/00003.

Choose a deliberate integration scope before merging: release the FP-62 prerequisite first and update FP-63 against master, or explicitly approve and review the combined FP-62 + FP-63 scope. Both PRs target master now; do not merge into an obsolete feature base to avoid the release conflicts.

## Gate matrix

| Gate | Result |
| --- | --- |
| Exact feature-head review and synthetic local acceptance | Pass: 298 frontend units, lint/build; 232 ordinary backend tests (23 existing opt-in DB skips); separately gated integration 36/36; real API/PostgreSQL/Chromium feature 12/12 + whole-app 30/30, zero failures/skips; dedicated shopping DB and controlled browser probes; 41 runner checks. |
| Prospective merge with current master | Blocked by conflicts above; no integrated candidate exists or is certified. |
| FP-62 dependency/publication decision | Open; included prerequisite scope and target-environment inventory/editorial/translation pilot approval remain pending. |
| PR CI and reproducible remote testing | No checks attached. Suites/fixtures remain in local sibling testing per policy; app-only clones need those retained assets. |
| Target-representative migration/recovery rehearsal | Open for the new candidate. Earlier sprint 337 restored-backup evidence and this synthetic acceptance do not certify FP-62/63 on current production data. Refresh protected backup/recovery evidence before release. |
| Ordered deployment | Pending: enrichment 00002/00003, then shopping 00004 and backend/API verification before frontend. Master merges trigger deployment dispatch; serialize releases and verify image digests, migration inventory and service health at every step. |
| Post-integration behavior/rollback | Pending on the actual integrated candidate: preserve collected proposals/lists/purchases/receipts; down migrations reject used history; verify publication/privacy, exact prices, personal/shared history and revocation, retry/idempotency, account/offline/mobile/PWA compatibility. |

There is no separately designated staging environment; the public URL is production. Use an isolated restored/disposable target for mutation rehearsals. No new production health/inventory check is claimed by this PR audit.

## Next ticket checked: FP-66

[Jira FP-66](https://fresh-price.atlassian.net/browse/FP-66), Admin-managed dynamic IP exemptions for authentication testing, is To Do/unassigned in active sprint 338. Source inspection confirms production Express trusts one hop (platform-backend/src/server.js), nginx appends forwarding headers (fpdocker/nginx.prod.conf), and login/register/reset share one authRateLimit middleware (platform-backend/src/routes/authRoutes.js). Existing auth has password comparison helpers but no exemption model/admin UI or dedicated recent-reauthentication capability. The historical live shared-gateway observation remains the prerequisite evidence; no new live probe was run.

Implementation sequence:

1. Establish trusted end-user identity through Cloudflare → Caddy → nginx → Express. Validate both FreshPrice and PhilWatch, independent client buckets, IPv4/IPv6 normalization, forged forwarding headers and alternate/direct-origin paths before exemptions.
2. Add persistent exact account+IP rules and redacted audit, admin authorization plus recent password reauthentication, default one-hour expiry/bounded maximum, explicit IP replacement/revocation and fail-closed enforcement after restart/replicas. Define test-account eligibility/ownership, maximum lifetime, reauth lifetime and audit retention before exposing controls.
3. Add the admin controls and isolated unit/API/database/browser acceptance. Exempt only matching login throttling: registration/reset/global limits, normal passwords, roles and sessions remain enforced. Current limiter is shared across login/register/reset, so a broad middleware skip would violate the ticket. Document cooldown/password-reset/operator recovery and shared-NAT limits.

Check completed only: no FP-66 code, Jira transition or live exemption was created. It is the next implementation ticket; FP-62/63 release prerequisites remain open independently.
