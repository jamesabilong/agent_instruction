# Historical snapshot through 2026-10-21

Superseded by the current memory-bank file. Older pending/ready claims below describe their original checkpoints, not current state. Paths retain the original app context.

# FreshPrice Bugs

## Auth/global rate limits identify public traffic as gateway — 2026-10-21

- Tracking: FP-66, Story/To Do in future sprint 338, created at user's request for admin-managed dynamic test exemptions. Trusted client-IP correction is a prerequisite; issue remains unresolved and no live bypass was enabled.

- Confirmed with harmless public auth-root GET and request-log comparison: Cloudflare sees a public client, but Express sees Docker gateway `172.19.0.1`. Production trusts one proxy hop; nginx appends its peer; Caddy has no trusted-proxy/client-IP configuration. Public requests through this route can share rate-limit buckets. Earlier per-public-IP explanation was incomplete.
- No bypass applied. Resolve trustworthy client forwarding/spoof resistance before a short-lived tester-IP exemption; never exempt the gateway/private subnet. See `docs/auth-testing-exemption-2026-10-21.md`.

## PostgreSQL public exposure mitigated — 2026-10-21

- Supersedes the historical unresolved exposure notes below: user-authorized independent nftables guard blocks public eth0 TCP 5432 before Docker NAT, persists via an enabled systemd unit, and passes syntax/reload checks. External probes now time out while fresh internal DB access, SSH/HTTPS and FreshPrice/PhilWatch health pass. All production tasks/images/specs unchanged; no service restart or database mutation.
- Live Swarm publication remains behind the guard; local Compose removes it but is not committed/published/deployed. Maintain guard coverage if the public interface changes. Boot ordering verified, no reboot or external IPv6 test performed. Evidence and recovery: `docs/postgres-security-2026-10-21.md`. Real-device/installed-upgrade gate remains open.

## HTTP/browser acceptance follow-up — 2026-10-21

- Declared isolated HTTP/auth/browser/nginx scope passes: 34 HTTP groups, 21 Chromium assertion groups, three backend-down fallback checks and all baseline/production/cleanup checks. No actionable app defect established by these runs. FP-61 retained failed draft recovery uses visible Try again → same-account sign-in → explicit Retry draft; automatic redirect from the unavailable overlay was not established. Physical-device/installed-version upgrade, live edge and recorded PostgreSQL exposure limits remain. See `docs/http-browser-acceptance-2026-10-21.md`.

## Service acceptance follow-up: no direct-service failures — 2026-10-21

- Fresh restored-copy acceptance passes all 50 declared cases on exact FP-59/60/61 backend candidates, with no actionable application finding. The backup contains zero scheduled budgets; tested shared histories are explicitly synthetic, while every baseline row is preserved. HTTP/auth middleware, proxy/browser/installed-PWA/device evidence and the recorded public PostgreSQL exposure remain unresolved readiness limits. See `docs/service-acceptance-2026-10-21.md`; no production change or merge occurred.

## Production PostgreSQL is externally reachable — 2026-10-20

- Password-authenticated read-only VPS inventory shows `freshprice_postgres` published as `*:5432->5432/tcp`; a separate external TCP connection to `107.174.250.249:5432` succeeds. The production Compose file's `127.0.0.1` publishing address does not constrain Swarm publishing, as the renderer warning also reports. This confirms external reachability, not unauthorized database access; no database login was attempted by the external probe.
- Inspect actual firewall and legitimate database consumers before selecting a mitigation. Do not change firewall rules, database credentials or production services as part of a readiness check without a concrete reviewed change. Evidence: `../../../staging-preflight/production/inventory-user-session.log`, `../../../staging-preflight/production/postgres-public-port.json` and production config regression log. No production configuration change has been made.

## Sprint 337 re-audit: integration clear, release gates pending — 2026-10-20

- All six published PRs are CLEAN/MERGEABLE; both dependency ancestries are correct and prospective merges into current master introduce no content changes. FP-60/61 source fingerprints and passing JUnit evidence verified. No new application defect or remaining merge-conflict blocker established by this release audit; historical FP-60/61 conflict notes below are resolved.
- Final review update: fresh FP-59 exact-head checks pass; all six Validation sections and exact-head COMMENT reviews are published/read back. No actionable source/integration findings identified. Author-account comments are not independent approval; no hosted checks are reported. Remaining gaps: no verified current-head restored-data staging/device/proxy/PWA upgrade evidence, and unverified actual VPS image/migration/backup/restore/tag configuration. Production public health/cache headers pass but do not certify sprint features. Review: `docs/sprint-337-final-review-2026-10-20.md`. Current plan: `docs/sprint-337-release-audit-and-runbook-2026-10-20.md`. FP-63 unchanged/on hold.

## FP-61 remote merge-conflict blocker resolved — 2026-10-20

- Published verified two-parent FP-60 → FP-61 merges frontend `0d100ab5` / backend `1d1fa16`. Live FP-61 PRs #53/#55 are OPEN/CLEAN/MERGEABLE against FP-60. This supersedes the remote-conflict/publication-pending notes below. Committed trees match the complete passing reconciliation checks. Final release review/staging/ordered deployment remain pending; FP-63 preserved/on hold. Evidence: `docs/fp-61-reconciliation-2026-10-20.md`.

## FP-61 local reconciliation verified; publication pending — 2026-10-20

- Both app working-file conflicts are resolved against current FP-60 without changing FP-61 src or primary dirty FP-63 work. All 15+30 browser cases, 279 frontend / 186 ordinary backend / 36 enabled integration / 41 runner and lint/build pass. Standalone browser harness fixes address confirmed hot-reload module/context resets, hidden status matching, offline module loading, async lease completion and initial tutorial setup; no new application runtime defect is established by these failures.
- Remote integration blocker below persists until authorized two-parent commits/push. Final review/staging/ordered release remain required; FP-63 stays on hold. Exact evidence: `docs/fp-61-reconciliation-2026-10-20.md`.

## FP-61 baseline integration blocker confirmed — 2026-10-20

- Updated FP-60 leaves frontend FP-61 #53 and backend #55 DIRTY/CONFLICTING. Read-only merge-tree confirms vite.config.ts/package.json conflicts; resolve while preserving offline registrations and portable test commands, then rerun final-source checks. Historical FP-61 15+30 success does not cover this unresolved integration. No new feature runtime bug claimed by the release audit.
- Sprint 337 remains blocked for full rollout pending integration, current-head review and restored-data staging; FP-63 remains untouched/on hold. Exact readiness and ordered deployment/rollback guidance: `docs/sprint-337-release-audit-and-runbook-2026-10-20.md`. Public SW/manifest cache headers were verified correct in this audit; prior four-hour-cache observations are historical.

## FP-60 remote merge-conflict blocker resolved — 2026-10-20

- Published verified two-parent reconciliations frontend `3372481b` / backend `e8b7f78`; live FP-60 PRs #52/#54 are CLEAN and MERGEABLE against latest FP-59. This supersedes the local/publication-pending and remote-conflict notes below. Exact committed source matches all passing reconciliation checks. FP-61 propagation and staging/release remain pending; FP-63 preserved/on hold. See `docs/fp-60-reconciliation-2026-10-20.md`.

## FP-60 local reconciliation verified; publication pending — 2026-10-20

- Resolved the frontend config and backend command conflicts in isolated unstaged FP-60 worktrees, retaining FP-59 clamp/command fixes and FP-60 accounting. Restored missing shared `unit.mjs`/disposable database support referenced by published FP-59 commands; removed the shared pagination test dependency on FP-62-only call arguments. Seven new calendar/accounting cases and five runner cases pass alongside the full checks.
- All 16 feature + 30 whole-app, 273 frontend units, 184 ordinary backend, 36 enabled database and 41 runner checks pass, plus lint/build. No new app defect reproduced. The remote integration blocker below remains until proper merge commits are authorized/pushed; FP-61 propagation and staging remain open. FP-63 unchanged/on hold. See `docs/fp-60-reconciliation-2026-10-20.md`.

## Sprint 337 integration blocker confirmed — 2026-10-20

- Both FP-60 PRs (frontend #52/backend #54) currently report DIRTY against latest FP-59. They omit follow-up commits 101a8342/e4fe0bc and overlap calendar/test command/configuration changes. Resolve and verify the dependency stack before release; FP-61's clean state against old FP-60 is not final integration verification.
- This is an integration/release blocker, not a newly reproduced FP-59/60/61 runtime defect. Staging/ordered release evidence remains pending in checked records. FP-63 work is on hold per user direction. See `docs/sprint-337-pending-audit-2026-10-20.md`.

## FP-63 confirmed pre-commit findings — 2026-10-20

- P2: an already-composing actual purchase retains its values but sends a newer revision after a refresh changes saved budget/market, permitting the expense to be booked to the replacement target without a new confirmation review.
- P2: shared-purchase View expense history uses the personal scope URL; the exact recorded shared expense is excluded from that ledger. Navigation must retain the original purchase target when list settings later change.
- P3: floating-point half-cent estimates misround valid stored price/quantity (1.00 × 1.005 → 1.00 instead of 1.01), affecting estimates rather than actual whole-PHP spending.
- Reproduced in actual Chromium/React controlled fixtures and real migrated disposable PostgreSQL/services. Prior no-known-blocker implementation note below is superseded. App source remains unchanged; fix/register regressions before committing. See `docs/fp-63-precommit-review-2026-10-20.md`.

## FP-63 implementation edge cases resolved locally — 2026-10-20

- Guarded recipe serving storage precision and sub-resolution quantities (unknown instead of zero); align current-budget comparison with the existing personal-period expense summary, including retained spending after resets. Unsaved market/budget settings block purchase, failed refreshes retain composing fields, and identity changes ignore stale private reads.
- Final 12 feature + 30 whole-app regressions, 284 frontend / 224 ordinary backend (23 existing opt-in skips) / 36 runner, lint/build pass. No known blocker found in implementation verification; formal review/staging remain open. Evidence: `docs/fp-63-shopping-integration-2026-10-20.md`. Shopping drafts/retry keys are in-memory while the page remains open; durable restart/navigation recovery is outside this online-first increment and the permanent item purchase marker prevents repurchase.

## FP-62 review findings resolved locally — 2026-10-20

- All three findings below are historical and now fixed: collapse retains drafts/in-flight saves, operators can retract a single approved variant with audit history, and stable submission identities deduplicate uncertain retries.
- Registered real browser/API/PostgreSQL regressions pass with 13/13 feature and 30/30 whole-app, 278 frontend / 206 ordinary backend (23 existing skips) / 36 runner and lint/build. No known blocker remains from this review. Evidence: `docs/fp-62-review-fixes-2026-10-20.md`. Changes remain uncommitted; editorial/staging gates remain open.

## FP-62 confirmed pre-commit findings — 2026-10-20

- P2: `open && ...` unmounts the composing editor on disclosure close; reopening loses translated summary, source URL and geography without warning. Reproduced in actual Chromium/React with controlled read responses.
- P2 moderation gap: approved enrichments cannot be independently retracted; rejecting an approved row returns 409 and it remains public. Real migrated PostgreSQL/services confirm; only pending decisions and name-only withdrawal exist.
- P3 retry gap: identical repeated proposal data creates separate pending UUID rows, so a retry after an uncertain commit can duplicate moderation work. Real service/DB repetition reproduced; HTTP loss itself was not injected in this probe.
- All remain unresolved. Prior 10 feature/30 whole-app passes miss these cases. Application source unchanged; details and evidence: `docs/fp-62-precommit-review-2026-10-20.md` and local `testing/tickets/FP-62/review`.

## FP-62 implementation findings resolved locally — 2026-10-20

- Fixed a seasonal SQL replacement boundary that left an unbound region placeholder and returned 500. Complete real seasonal-filter/pagination/source-invalidation and browser scenarios now pass.
- Fixed whitespace-only optional recipe difficulty causing a null string operation; added a passing unit. Legacy array responses now filter before local pagination, and composing proposals preserve their reviewed revision through refresh until explicit renewed review.
- Initial harness issues included exact select-label lookups, reviewer login in an already authenticated shared context, an old pagination call expectation and whole-app queued-save behavior recognized only under FP-61. Corrected setup/expectations while retaining assertions, scope and timeouts. Final complete feature 10/10 and whole-app 30/30 pass with ordinary unit/lint/build checks; no known implementation blocker remains from these findings. Actual factual content review and staging remain release gates.

## FP-61 pre-commit findings resolved locally — 2026-10-20

- Fixed unseen-revision overwrite with a frozen displayed revision and transactional conflict comparison; changed conflicts require renewed review.
- Fixed stale confirmed totals/history with replay-driven read invalidation and account-scoped cross-tab refreshes.
- Fixed interrupted logout disposal with durable generation markers checked before replay/completion and resumable physical cleanup; expiry and fresh same-account drafts remain supported.
- All three registered real API/PostgreSQL/browser regressions pass in the complete 15/15 feature group; separate whole-app 30/30, 272 frontend units, backend/runner/lint/build checks pass. Earlier findings below are historical. Details: `docs/fp-61-review-fixes-2026-10-20.md`. No known blocker remains from this review; changes are uncommitted.

## FP-61 confirmed pre-commit defects — 2026-10-20

- P2: conflict confirmation showing revision 2 submits expectedRevision 3 after another tab updates the stored conflict, allowing an unseen correction to be overwritten.
- P2: successful queued save can join an older hydration and leave confirmed total/history stale; reproduced server amount 123 with displayed total 0 and no displayed expense.
- P2: closing the logout tab before blocked IndexedDB purge commits leaves a discarded draft that automatically replays on the next same-account login.
- Actual Chromium/IndexedDB/React/store reproductions use controlled Axios responses, recorded in `testing/tickets/FP-61/review/evidence.json`. Application source unchanged; all three remain unresolved. Details and fixes: `docs/fp-61-precommit-review-2026-10-20.md`.

## FP-61 implementation findings — 2026-10-20

- Fixed expiry-driven global logout deleting pending local drafts: authentication expiry now retains a hidden account marker and failed drafts for same-account sign-in; explicit logout/account change still purges. Added passing unit and real-browser coverage; final feature 12/12 and whole-app 30/30 pass on unchanged app source.
- Fixed outage-state suppression of foreground queue replay after reconnection while retaining ordinary recovery behavior, and kept sync confirmations expanded until dismissal. Cross-tab localStorage removal explicitly clears auth instead of relying on rehydration of a missing value.
- Early browser run failures also included test-only production-preview CORS, canonical module imports attempted after offline transition, and text selectors matching hidden recovery content. Harness corrections preserve real API/DB responses and full group execution.

## FP-59 pre-commit defects resolved locally — 2026-10-19

- Fixed former-owner deletion revoking unrelated members with an additive nullable SET NULL inviter FK and matching model; accepted/pending memberships and existing audit records survive without false inviter reassignment.
- Fixed recurring ID preclaims with random UUID instance IDs and existing unique period/cursor deduplication; another account's ordinary budget cannot block future generation or be overwritten.
- Fixed scheduler starvation with stable ID keyset paging across all due batches, one attempt per ID per sweep and deferred error reporting. A real 51-template test verifies failure rollback, healthy progress, retry and recovery.
- All three registered regressions and all 45 seeded cases pass, alongside unit/runner/lint/build checks. Earlier findings below are historical reproductions; no known blocker remains from this review. Evidence: `docs/fp-59-review-fixes-2026-10-19.md`. No commit/push/deployment.

## FP-59 confirmed pre-commit defects — 2026-10-19

- P2: ownership acceptance leaves other members tied to the former owner's `invited_by_user_id` CASCADE FK. Deleting that account preserves the transferred budget but removes unrelated members; real collaborator access becomes 404.
- P2: ordinary scheduled-budget creation permits predictable future `recurring:<template>:<occurrence>` IDs. An accepted shared member can preclaim a future ID in their own account and block another creator's generation with a unique-constraint failure.
- P2: the fixed first-50 due-template query permanently starves later healthy work when those 50 fail repeatedly. Two sweeps reproduced 50 failures each and zero instances for the healthy 51st template.
- Confirmed using real services against disposable PostgreSQL, including a process-local next-month simulation; app source unchanged. Evidence and reproduction: `docs/fp-59-precommit-review-2026-10-19.md`. These supersede a no-gaps interpretation of the previous 42-case pass and should be fixed before committing.

## FP-59 transfer recipient reset resolved locally — 2026-10-19

- Real Chromium exposed the new transfer form clearing its selected recipient during background budget hydration, leaving submission disabled. Recipient reset now follows budget/account identity changes rather than every revision; a deterministic component regression preserves selection during refresh. Final browser acceptance passes, including viewer-to-owner transfer and owner-control revocation; all 42 seeded scenarios pass. See `docs/fp-59-lifecycle-2026-10-19.md`.
- Local test timing: unrestricted parallel frontend execution hit two existing 5000ms timeouts in price submission/wiki editing. The entire unchanged suite passes 260/260 with `--maxWorkers=2`; no timeout/assertion was changed. Prefer bounded workers on resource-constrained local runs; no product regression was established by these timing failures.

## FP-65 reviewed gaps resolved locally — 2026-10-19

- Admin preview now propagates its selected market; the real multi-market regression passes for median/mean/mode and All. DB-gated files serialize through config; the documented integration command passes 36/36, including rollback/reapply, without a CLI override.
- The October 15 report/auth/assertion findings are resolved: execution-specific artifacts and guarded report lookup, captured independently verified session cookies, and persisted feature-specific navigation assertions. Eight report regressions, 35 total runner checks and all 39 seeded cases pass. Current HTML/JUnit identity and database cleanup verified.
- No known code blockers remain from this review. Earlier entries below preserve historical reproductions. Current evidence: `docs/fp-65-gap-fixes-2026-10-19.md`; changes remain local/uncommitted, with PR/release steps separate.

## FP-65 merge review findings — 2026-10-19

- P2: Price History's selected market is not passed to `TrendPreview`/`ObservationTrends`. Real Chromium confirmed Carbon selection changes history but leaves pooled observation requests unchanged without `marketId`. This misses the ticket's admin-market-filter requirement.
- P2 test isolation: the observation migration rollback test drops shared tables while other integration files run; the default parallel database run hit a deadlock (35 pass / 1 fail). A fresh serialized run passes 36/36. Forward migrations passed in all disposable databases; no production migration failure established.
- Existing October 15 report/auth/assertion confidence findings remain. Full evidence: `docs/fp-65-merge-review-2026-10-19.md`. Application/test source unchanged.

## Test-suite confidence gaps — 2026-10-15

- Review found stale report artifacts on pre-Playwright setup failure, weak page-shell assertions in part of whole-app navigation, and FP-65 auth headers that send the literal `cookie-session` marker while real authentication comes from the request context’s cookie jar. No current app regression is established by these findings; they are test/report reliability issues. Evidence and corrective scope: `docs/testing-suite-audit-2026-10-15.md`.

## Seeded regression fixes implemented locally — 2026-10-15

- Fixed all five failures documented below: correction picker uses nullable empty ID; archived observation markets load with `paranoid:false` and may be retained on correction; upload multipart part-count permits the first valid image while preserving file/field limits; community junction associations disable absent timestamps; invalid product create/update data returns 400. No schema changes.
- Existing failing E2E assertions remain enabled. Added adjacent checks for malformed/excess multipart data, invalid update persistence, archived-market import rejection and tagged-post reload. Final real-data run results are recorded in progress. Earlier bug entries are historical reproductions.

## Whole-app real-data regressions — 2026-10-15

- Invalid catalogue categories return HTTP 500 from the real product controller instead of a client validation error (400/422); no product is persisted. The old `status != 201` assertion hid this. A separate strict validation case now remains active.

- Valid authenticated single-image upload returns 400 “Upload requests may only include the image file.” Reproduced with a real 192×192 PNG confirmed by Sharp metadata and the normal `image` multipart field. `uploadController.js` has `parts: 1`; old unit/controller checks do not exercise the real parser. The new whole-app upload case remains failing; no business-logic fix made.
- Valid tagged community posts return 500 on freshly migrated PostgreSQL: `community_post_tags` association queries request `createdAt`/`updatedAt` columns absent from the join table. Untagged posts/comments/votes/moderation work; a separate positive tagged-post regression remains failing. Backend log and fresh real HTTP runs confirm this is not invalid fixture input.
- The FP-65 picker regression now deliberately pauses with an empty selection and captures the maximum-depth warning. The former two-frame/immediate-reselection check was a false negative; the strengthened case remains failing alongside archived-market handling.
- All suites are local under `testing`; coverage mapping is `testing/tickets/FP-65/whole-app/COVERAGE.md`. No application bug fixes or production actions were included.

## Seeded picker regression false negative — 2026-10-15

- P2 test gap: `tests/e2e/seeded/observations.spec.ts:177–180` reselects after only two frames and passes with the correction render loop still present. Replacing that wait in a temporary diagnostic with a 1.5-second empty-state pause reproduces the depth warning in Chromium. Preserve empty-state coverage and deterministic effect-settling assertions; see `docs/seeded-e2e-review-2026-10-15.md`. Test source was left unchanged.

## FP-65 confirmed review findings — 2026-10-15

- P2: `ObservationManager.tsx:62` converts cleared product IDs to numeric zero, passes the truthy string `"0"` to the shared picker, and triggers an unbounded reset/state-update loop. Reproduced with the real React picker.
- P2: normal market soft deletion retains quotes but list reads return `market: null`; `ObservationManager.tsx:54` dereferences the market name and crashes. Confirmed in disposable PostgreSQL plus a UI reproduction; public market comparisons also lose the market label.
- Neither is fixed in application source. The new seeded suite actively checks both paths: quick browser clear/reselect/save passes, while archived market identity and exclusion fail against real PostgreSQL. The earlier React loop reproduction remains open. Evidence and fix requirements: `docs/fp-65-review-2026-10-15.md`; seeded coverage: `docs/seeded-e2e-2026-10-15.md`.

## Bulk import response compatibility — 2026-10-15

- Resolved locally: historical bulk controller returns `{ success, result }`, while frontend CSV expected `{ success, message, results }`. Shared service now normalizes both envelopes with regression coverage. CSV saved counts no longer rely on a `created` flag absent from this backend.
- Original note-import limitation: official history permits one market/product/date/unit value. Superseded locally by FP-65 separate observation storage on 2026-10-15; official-history uniqueness remains intentional, while the note importer now retains every quote independently.

## FP-64 fix verification — 2026-10-12

- Both prior P2 fixes are present in pushed FP-64 heads and their regressions pass. Fresh migrated PostgreSQL and production nginx/Caddy/PWA checks pass; no new merge-blocking code findings. Host fallback installation and live cache/recovery verification remain operational release risks. Historical findings below describe earlier revisions; see `docs/fp-64-merge-readiness-2026-10-12.md`.

## FP-64 resolved locally — 2026-10-11

- Both P2 findings recorded below are fixed: post-save hydration now rejects a stale session before success callbacks, and the deploy parser exports the persisted maintenance flag. Three session regressions and three actual parser/stack-rendering regressions pass. Historical findings below preserve pre-fix evidence; deployment remains pending. See `docs/fp-64-gap-fixes-2026-10-11.md`.

## FP-64 reconfirmed — 2026-10-11

- Both October 9 P2 findings still reproduce on the current heads. The budget save promise resolves after an account switch during hydration; the deployment key list renders persisted maintenance=true as frontend maintenance=false. No application fix applied. Evidence: `docs/fp-64-recheck-2026-10-11.md`.

## FP-64 pre-merge findings — 2026-10-09

- P2, reproduced: budget write promises can resolve in a new account when the session changes during post-save hydration; old form success callbacks can still run. Add the missing final generation guard.
- P2, reproduced: `.env` maintenance=true renders frontend maintenance=false through the current deploy parser/stack-config path because the flag is not exported. Dispatches can reverse maintenance.
- Both remain unfixed; see `docs/fp-64-premerge-review-2026-10-09.md`. Existing suites pass but do not cover these timing/configuration combinations.

## FP-43 post-commit audit findings — 2026-10-02

- P1: Open Headless UI portal dialogs remain visible and make recovery controls inaccessible.
- P2: Old recovery promises survive reset and block retries for a new page/session.
- P2: Optional market loading overrides the user-route not-found screen during downtime.
- P3: nginx extension matcher overrides hashed-asset immutable caching.
- All four resolved locally on 2026-10-02, with unit/browser regressions and proxy cache-header checks passing. The bullets above preserve the original findings. See `docs/fp-43-audit-2026-10-02.md` for reproduction and resolution evidence; deployment remains pending.

## FP-43 recovery — 2026-10-02

- Resolved missing wildcard routes and absent shared API-outage recovery. Missing community content is now distinguished from request failure. Proxy tests caught and fixed inherited error-page handling for maintenance deep links.
- Remaining deployment dependency: independent frontend-down fallback requires installing the supplied Caddy snippet on the host. DNS/TLS/host outages and true document-level SPA 404 status remain outside this scope. See the recovery runbook. And Risks

## Current Checkout Audit — 2026-10-02

The imported September 12 notes describe implementation work that is not present in the currently checked-out frontend/backend `master` trees. Source inspection still finds the expense owner overrides, global `budget-storage` cache, and first-200 expense hydration. Treat September implementation/test counts as historical claims for a different code state, not proof these fixes are present or released here. Locate the corresponding commits/branch before reimplementing; then reconcile and rerun regression and database checks. Production status is unverified.

## Review findings resolved locally — 2026-10-02

Saved recipe editing/publishing and public discovery beyond six recipes are implemented on FP-64. Migrated PostgreSQL tests verify draft privacy, permission enforcement, persistence, budget reliability and paginated moderation. Legacy API responses remain compatible. Earlier discovery/draft limitations below are historical findings; production rollout remains pending.

## FP-56 reconciliation — 2026-10-02

Current `FP-64` source contains the prior expense ownership, account isolation and aggregate fixes. Remaining October 1 price races, load failures, date inconsistencies and moderation pagination are now addressed locally with regression coverage. The older “unfixed/current checkout” statements below describe the earlier master audit, not this branch. Local migrated PostgreSQL verification now passes (30 integration checks). Production verification remains open. Legacy suggestion arrays are preserved; deploy the backend before the frontend. FP-56 is now budget tightening, not external ingestion.

## Known Risks

- The root workspace is not a git repository. Worktree checks must be run inside the relevant subproject repository when needed.
- `/api/vegetables` is removed and returns 410. New callers should use `/api/freshprice/products`.
- Backend deployments must run migrations before forcing `freshprice_backend` onto a new backend image. The deploy workflow and VPS guide were updated on 2026-07-01 to enforce that order for existing Swarm stacks.
- Do not run `source .env` on the production `fpdocker/.env`; secrets and `DATABASE_URL` values can contain shell syntax. Parse needed keys as text or let Docker consume `.env` via `--env-file`.

## Open Bugs

- 2026-10-09: Reconfirmed `https://freshprice.philwatch.com/sw.js` returns `Cache-Control: max-age=14400`. Both nginx variants now have locally verified browser/CDN no-store rules; frontend image rebuild, targeted Cloudflare purge and live verification remain pending. PhilWatch's separate apex-worker recovery is documented in `instructions/sugilanon/docs/cache-recovery-2026-10-09.md`.

- 2026-07-01 deploy logs showed `freshprice_sugilanon` rejected with `No such image: ghcr.io/jamesabilong/sugilanon:latest`; frontend/backend deploys can still surface this because the stack includes the Sugilanon service.
- 2026-07-01 deploy logs showed `freshprice_backend` repeatedly failing health checks with exit 137 after startup; live VPS memory/healthcheck state still needs confirmation.
- 2026-07-01 frontend nginx logs showed the config was still pointing Sugilanon at `sugilanon.philwatch.com`; production should serve Sugilanon from `philwatch.com`.

- 2026-10-02: Wiki code review: public wiki returns only six recipes and the page has no view-all path; additional published recipes are not discoverable there. Admin can create recipe drafts but existing recipes have no update/publish route or UI. Targeted mocked tests pass; database-backed verification is pending because the local stack was unavailable.

- 2026-10-01: Local mock reproduction confirms expense listing accepts `memberId` without a shared-budget scope and replaces the authenticated owner filter; expense creation also permits body `userId` to override the session owner. Unfixed; prioritize authorization regression tests and fixes.
- 2026-10-01: Code review found a global budget cache surviving logout, expense-summary undercount beyond 200 fetched rows, unguarded price request races, silent load failures, and UTC/local business-date inconsistencies. See `docs/existing-feature-audit-2026-10-01.md` for evidence and validation limits. Unfixed; no production reproduction attempted.

- 2026-09-08: Production `/sw.js` returned `Cache-Control: max-age=14400`, so previously visited devices could remain on an obsolete application shell and show an old broken product image. Browser/CDN `no-store` headers and proactive update checks are prepared; keep this open until deployment, Cloudflare URL purge, and verification on an affected device are complete.
- 2026-07-06: Production `https://freshprice.philwatch.com/api/platform/db/health` returned Cloudflare 502, confirming an origin-wide API outage that also affects budget setup. A deployment config fix was prepared to align backend healthchecks with `127.0.0.1`; verify after deploy.
- 2026-07-06: `freshprice_sugilanon` could not resolve `backend:4000` in production Swarm (`bad address` / `ENOTFOUND backend`). Production config now targets `freshprice_backend:4000`; verify after deploy and ensure VPS `.env` does not override `CONTENT_API_BASE_URL` back to `backend`.

## Documentation Corrections

- 2026-07-02: Corrected shared deployment docs to state that Sugilanon production runs on `philwatch.com`, not `sugilanon.philwatch.com`.

## Audit Findings 2026-09-12

- P0, reproduced with local mocks: `expenseService.listExpenses` allows an unscoped `memberId` to replace the authenticated user's query scope (A01).
- P0, reproduced with local mocks: `expenseController.createExpense` spreads `req.body` after the authenticated `userId`, allowing actor override (A02).
- P1, source-confirmed risks: budget storage is shared across accounts without logout reset (A03); first-200 expense hydration can understate totals (A04); failed saves can resolve as success or retain unqueued optimistic state (A05).
- P1, concurrency risk requiring database validation: sub-budget allocation checks and writes are not protected by a transaction/parent lock (A06).
- Historical follow-up 2026-09-12 (not present in current checkout): A01–A05 reported repaired in local code with regression coverage; A06 now uses transactional parent locks, but real PostgreSQL concurrency/migration checks are still required because Docker's Linux engine was unavailable. Production remains unverified. See `docs/budget-updates-0-1-2026-09-12.md`; the bullets above preserve the original audit findings.
- A08 wiki publication-quality gap remains open and is part of FP-55/M08. FP-56 must not auto-publish collected material before the review contract is implemented.

## Historically Reported Fixes — Not Verified in Current Checkout

- 2026-09-12 local: expense impersonation/unscoped member reads, cross-session budget cache retention, first-page-only summary calculations, swallowed save errors, and initial-load form/target defaults were repaired. Shared expense mutations now recheck membership, and a removed/unavailable expense target cannot silently become a personal expense. Release verification remains open as documented above.

- 2026-08-13 FP-53 backend market-price POST/PUT tests failed with `toJSON is not a function`; fixed by reloading hydrated price rows and serializing Sequelize/plain records defensively.
- 2026-08-13 FP-53 backend deploy image could not reliably run VPS migrations because `sequelize-cli` and `.sequelizerc` were not included in the production image; fixed by making the CLI a production dependency and copying `.sequelizerc`.
- 2026-08-13 Admins could stay in persisted `previewAsUser` mode and be redirected away from `/admin`; fixed by clearing preview mode when a session token is stored or cleared.
- 2026-08-13 Production frontend updates could require a hard refresh because the app cache refresher used a static `APP_CACHE_VERSION` and the generated service worker registration did not reload clients on update; fixed by using `virtual:pwa-register` with the existing `autoUpdate` service worker setup and removing the broad localStorage cache clear.

## FP-60 local regression fixed — 2026-10-19

- Initial seeded browser run reproduced split-editor closure after a successful save because expense-list refresh unmounted the row. Retained expansion in the parent keyed to expense/auth session, while the remounted editor refetches the current revision. The draft never silently adopts a newer revision; component regressions explicitly block stale saves. Final verification is recorded in FP-60 coverage/progress.

## FP-60 review defects — fixed locally 2026-10-19

- P2: open delete confirmation uses the latest refreshed expense revision instead of the reviewed snapshot, allowing a concurrent payer correction to be deleted without a new confirmation.
- P2: removed beneficiary IDs remain in split drafts but lack editable controls, so normal corrections repeatedly fail 409.
- P2: omitted-date settlement replay after midnight recalculates the default date, falsely treating unchanged request content as a conflict. Current frontend explicit-date requests are unaffected.
- Confirmed with focused React assertions and real migrated disposable PostgreSQL services. The three issues are now fixed with registered regressions; see `docs/fp-60-review-fixes-2026-10-19.md`. Original reproduction evidence is retained in the pre-commit review.
