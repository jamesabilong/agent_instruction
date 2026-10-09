# FreshPrice Bugs

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
