# FreshPrice Progress

## FP-64 gap fixes — 2026-10-11

- Fixed post-hydration session generation checking so old budget saves cannot run form success callbacks in a later session. Added regressions for account switch, logout and token renewal, all failing before the fix and passing afterward.
- Exported the persisted maintenance flag in the VPS workflow. Actual Bash-parser/stack-rendering regressions pass for true, false and omitted settings; enabled maintenance failed before the fix.
- Frontend lint/build and all 243 unit tests pass. All 17 Chromium flows pass on a complete two-worker rerun after one initial loading timeout. No commit, push or deployment. Details: `docs/fp-64-gap-fixes-2026-10-11.md`.

## FP-64 recheck — 2026-10-11

- Rechecked the unchanged frontend/backend/Docker FP-64 heads against current Jira scope. Freshly reproduced both unresolved P2 findings: old-session budget save success after delayed hydration, and maintenance=true becoming false through the deployment key list and stack config.
- Frontend lint/build, 240 unit tests, 17 Chromium flows, and 128 backend unit tests pass. Docker engine unavailable; database/proxy runtime and production checks were not rerun. Application code unchanged; temporary reproduction removed. See `docs/fp-64-recheck-2026-10-11.md`.

## FP-64 pre-merge review — 2026-10-09

- Refreshed remote refs and reviewed frontend `5a5d58ee`, backend `56d4142`, Docker `a459648` against master. Confirmed two P2 gaps: post-save hydration can resolve an old session's write in a new account, and the VPS deploy parser omits the maintenance flag, rendering frontend maintenance false despite `.env=true`.
- Frontend lint/build, 240 unit tests and 17 Chromium flows pass; backend 128 unit and 30 real PostgreSQL integration checks pass. All migrations applied in a disposable database; 130-page wiki population/revision integrity and idempotency checks pass. Findings and release requirements: `docs/fp-64-premerge-review-2026-10-09.md`.
- Application code remains unchanged; temporary reproduction removed. Audit documentation is local and uncommitted. Earlier unpushed statements are historical: reviewed heads now match fetched `origin/FP-64`; live deployment was not inspected.

## Worker cache headers — 2026-10-09

- Reapplied the missing nginx worker/manifest rules and proxy regressions at the user's request. Confirmed Sugilanon's recovery route/layout helper remained intact. HTTP/TLS cache checks, nginx syntax and the maintenance suite pass again; no commit, push or deployment.
- Live FreshPrice `/sw.js` still returns a four-hour max-age. Restored exact worker/manifest locations in both production nginx variants: worker browser/CDN no-store, manifest MIME type/revalidation, and CDN no-store. Hashed assets remain immutable.
- Both nginx variants pass syntax and HTTP/TLS cache-header checks. Expanded maintenance regression suite passes, including deep links, immutable/missing assets, planned maintenance, Caddy fallback and API failures. Sugilanon independently retires any old apex worker; see the [recovery runbook](../../sugilanon/docs/cache-recovery-2026-10-09.md).
- Committed as `a459648` on `fpdocker` branch `FP-64`; the companion Sugilanon recovery is `b15da39` on `main`. Neither commit has been pushed or deployed. Rebuild the frontend image after publishing Docker configuration, then purge exact worker/manifest URLs and verify production headers.

## FP-43 audit fixes — 2026-10-02

- Resolved all four audit findings: suspended portal dialogs preserve form inputs during recovery; route/session resets detach stale readiness/retry promises with identity-safe cleanup; optional market loading preserves missing-page UI; hashed assets retain immutable nginx caching.
- Frontend lint/build, 240 unit tests, 17 development Chromium flows, one production/service-worker Chromium flow, and nginx/Caddy HTTP regression checks pass. Changes remain uncommitted and undeployed. See `docs/fp-43-audit-2026-10-02.md`; staging/VPS validation remains pending.

## FP-43 post-commit audit — 2026-10-02

- Audited frontend/backend/deployment FP-43 commits. Confirmed three functional issues through targeted reproductions: portal dialogs block recovery, old recovery promises block new-page retries, and optional market requests override user-route 404 screens. Confirmed versioned assets receive no-cache because of nginx matcher order. Backend 128 unit tests pass.
- Findings and fix requirements: `docs/fp-43-audit-2026-10-02.md`. No application changes, commit, push or deployment during this audit.

## FP-43 implementation — 2026-10-02

- Implemented shared API-unavailable/offline, not-found and route-error screens; preserved mounted forms, session state and URLs during recovery. Only failed reads can be retried; writes are never automatically replayed. Added protected catch-all routes and resource 404 handling.
- Added bounded readiness checks, no-store API health responses, PWA exclusions, standalone nginx maintenance mode, a maintenance-safe frontend healthcheck, and an independent Caddy edge fallback snippet.
- Verification and release operation are in `docs/fp-43-recovery-runbook.md`. All changes remain local; live proxy configuration, deployment and Jira are untouched. Documentation repository's pre-existing merge remains unresolved.

## FP-43 planning — 2026-10-02

- Read FP-43 and drafted `docs/fp-43-maintenance-screen-plan.md` covering API downtime, offline recovery, broken links, accessible fallback UI, and deployment-level maintenance handling. No application code changed. Jira edit tool was unavailable, so the description remains a local draft.

## FP-55 / FP-56 review fixes on FP-64 — 2026-10-02

- Added operator recipe editing and publishing/unpublishing with validation, stable product/creator/slug, retained edits on failure, and duplicate-save protection.
- Added accurate published recipe counts and paginated public discovery beyond the six-card preview, including retries and draft exclusion.
- Preserved legacy moderation array responses when pagination is omitted and added frontend legacy-response handling. Backend-first rollout is supported.
- Applied existing migrations to an isolated PostgreSQL 14 container. All 30 integration checks passed with database gates enabled, covering budget reliability plus recipe persistence, permissions, draft privacy, and moderation of 121 suggestions. The app database was untouched.
- Frontend: 218 unit tests, lint and build passed. Backend: 126 unit tests passed. All 10 Chromium flows passed (9 existing flows plus the new recipe editing/publishing/discovery flow). No commit, push, deployment or Jira write.

## FP-56 implementation — 2026-10-02

- Read current Jira FP-56: **Budget Feature tightening**, superseding the historical scraping scope. Current repositories are clean-at-start `FP-64` checkouts with the prior ownership, session-isolation and aggregate-total fixes present; the master audit below is historical.
- Implemented remaining price request/unit safeguards, retry states, Philippine dates, whole-peso validation/copy, login/refresh deduplication, visibility-aware notification polling, and wiki/recipe moderation pagination. See `docs/fp-56-budget-tightening-2026-10-02.md` for requirement mapping and API rollout notes.
- Verification: frontend lint/build and 215 unit tests; backend 126 unit tests and 13 API integration tests; 9 Chromium flows pass. Database verification was subsequently completed in the follow-up below. No commit, push, deployment or Jira update.

## Current Checkout Audit — 2026-10-02

The imported September 12 notes describe implementation work that is not present in the currently checked-out frontend/backend `master` trees. Source inspection still finds the expense owner overrides, global `budget-storage` cache, and first-200 expense hydration. Treat September implementation/test counts as historical claims for a different code state, not proof these fixes are present or released here. Locate the corresponding commits/branch before reimplementing; then reconcile and rerun regression and database checks. Production status is unverified.

## 2026-10-02

- Expanded `todo.md` with a prioritized next-work checklist for wiki runtime verification, recipe editing/publishing, complete public recipe discovery, moderation pagination, and regression checks. These remain pending implementation.
- Checked wiki public/admin routes, suggestions, moderation, and recipe workflows. Targeted frontend tests passed (18 across 3 files); backend tests passed (16 across 2 files). Tests use mocks/validation helpers and do not establish database-backed end-to-end correctness.
- Found public recipe discovery capped at six with no view-all UI and no existing admin recipe update/publish route or UI for saved drafts. Local Docker daemon and API were unavailable, so runtime/database verification remains pending. No application code changed.

## 2026-10-01

- Audited existing FreshPrice features; findings and recommended order are in `docs/existing-feature-audit-2026-10-01.md`. No application code changed.
- Reproduced expense owner-filter override and expense-create user ID override using local in-memory mocks; identified account-cache isolation, incomplete expense totals, request races, silent failures, and business-date inconsistencies by code inspection.
- Baseline frontend unit tests (199) and backend unit tests (103) pass; these do not establish coverage of the newly identified gaps. Production and browser behavior were not tested.

## 2026-07-01

- Split FreshPrice documentation into `instructions/freshprice`.
- FreshPrice docs now cover frontend, backend, Docker deployment, API routes, and schema inventory separately from Sugilanon and portfolio docs.
- Previous investigation confirmed FreshPrice frontend and backend have active unit/E2E test structures.
- Backend API ownership relevant to FreshPrice is namespaced under `/api/platform` and `/api/freshprice`.
- Docker local development expects `platform-backend` as the canonical backend folder.
- Confirmed production trigger flow: frontend/backend `master` pushes dispatch the `fpdocker` workflow, which builds/pushes the relevant image and updates the VPS service.
- Added README deployment trigger notes to `fresh-price-front` and `platform-backend`.
- Updated production frontend container setup for Caddy TLS termination: container serves HTTP only on the configured host port.

- Simulated `FP-50` merges into `master` for `fresh-price-front`, `platform-backend`, and `fpdocker`; no merge conflicts were reported by `git merge-tree`.
- Updated deployment workflow and guide so backend migrations run before the backend service is forced onto a newly built backend image.
- Verified frontend lint, frontend unit tests, frontend production build, backend tests, and production Compose config render.
- Resolved `fpdocker` merge conflicts in `Dockerfile.prod`, `VPS_DEPLOYMENT_GUIDE.md`, `docker-compose.prod.yml`, and `docker-compose.yml` by preserving `platform-backend`, Swarm-safe production deployment, Sugilanon service support, and PostgreSQL 14.
- Reapplied the backend migration-before-service-update deployment ordering to `.github/workflows/deploy.yml` and `VPS_DEPLOYMENT_GUIDE.md` after conflict resolution.
- Replaced unsafe production `.env` shell sourcing in the VPS deployment guide and deploy workflow with explicit key parsing so secrets containing shell characters do not break backup/deploy commands.
- Fixed the backend deploy checkout target from `jamesabilong/platform-backend` to the actual GitHub repository `jamesabilong/fresh-price-backend`, while keeping the CI checkout path as `platform-backend`.

## 2026-07-02

- Updated shared production deployment documentation and nginx config to state that Sugilanon runs on `philwatch.com`, not `sugilanon.philwatch.com`.
- Verified production Compose still renders after the Sugilanon deployment fixes.
- Fixed the production frontend Swarm healthcheck to use `127.0.0.1` instead of `localhost`, matching the VPS recovery where the `localhost` probe failed and caused healthy nginx tasks to be stopped.
- Documented manual production dispatch commands in FreshPrice frontend, shared backend, and Docker READMEs.
- Added production dispatch details to shared, frontend, and Docker agent instructions.
- Adjusted backend dispatch deployment so existing stacks update `freshprice_backend` directly after migrations instead of redeploying the full stack and failing on unrelated missing Sugilanon images.
- Clarified the backend README deployment section title and manual command for the `backend-updated` dispatch.
- Updated Sugilanon production Swarm handling in shared Docker config to use a `127.0.0.1:3000` healthcheck and detached service update.
- Added a production Sugilanon host port mapping using `SUGILANON_PORT` defaulting to `3001`, including env samples and deployment docs for Caddy routing.
- Added a Carbon Market product-only CSV import file for FreshPrice live product seeding.
- Expanded the Carbon Market product-only CSV with common Cebu/Philippine wet-market produce items while keeping prices out.
- Enriched the Carbon Market product CSV with FreshPrice product metadata fields for classification, storage type, seasonality, nutrition, flavor profile, and shelf life.
- Added seasonal local fruits and imported wet-market fruits such as rambutan, sinaguelas, santol, lanzones, durian, kiwi, berries, and stone fruits to the Carbon Market product CSV.
- Corrected `Sinaguelas` to `Siniguelas` and added high-confidence scientific names for common fruits and vegetables in the Carbon Market product CSV.

## 2026-07-06

- Confirmed `https://freshprice.philwatch.com/api/platform/db/health` returns a Cloudflare 502, so the setup-page API failure is production origin-wide rather than budget setup-only.
- Updated production backend Swarm healthchecking to probe `127.0.0.1:4000` instead of `localhost:4000`, matching the existing frontend and Sugilanon VPS healthcheck recovery pattern.
- Updated backend production service updates to use `start-first` order to avoid dropping the only API task during backend deployments.
- Confirmed `freshprice_sugilanon` cannot resolve `backend:4000` in production Swarm and updated production nginx/Sugilanon backend targets to use `freshprice_backend:4000`.

## 2026-07-23

### Optimization pass — backend, frontend, Docker/nginx

**Backend**
- Added performance indexes across 7 models and a new migration `20260723000001-add-performance-indexes.cjs`. Tables covered: `expenses` (user_id, user_id+date, scheduled_budget_id, budget_sub_budget_id, scheduled_sub_budget_id), `budget_sub_budgets` (budget_id), `scheduled_budgets` (user_id), `scheduled_budget_members` (user_id+status, scheduled_budget_id), `scheduled_sub_budgets` (scheduled_budget_id), `price_submissions` (lookup composite, status), `price_moderation_audits` (lookup composite, performed_by_user_id). Migration uses `pg_indexes` idempotent checks.
- Fixed N+1 queries in `budgetService.js`: `toBudgetResponse` replaced N `Expense.sum` calls with one grouped `Expense.findAll`; `toScheduledBudgetResponse` replaced N+2 queries with 2 parallel grouped queries.
- Fixed redundant `findByPk` after writes in `marketPriceService.js`: `createPrice` and `createPriceHistory` inject already-fetched `product`/`market` into `created.dataValues`; `updatePrice` loads associations in the initial `findOne` so no second query is needed.
- Removed debug `JSON.stringify` log from `marketController.getAllMarkets`.
- Converted `importMarketsFromCSV` and `importProductsFromCSV` from per-row `Model.create()` to a single `Model.bulkCreate()`.

**Frontend**
- Removed 3 debug `console.log` calls from `UserProductList.tsx`.
- Fixed blank-screen flash on route load: `<Suspense fallback={null}>` in `router/index.tsx` replaced with a green spinner.
- Removed dead `AdminContextProvider` wrapper from the admin route (useAdminContext is unused codebase-wide).
- Replaced `date-fns` `format()` in `Footer.tsx` with `Intl.DateTimeFormat` (eliminates a 13 KB gzipped dependency).
- Split monolithic `vendor` chunk in `vite.config.ts` into `ui`, `http`, `state`, `utils` — a change to any one library no longer busts the whole vendor cache.

**Docker/nginx**
- `nginx.prod.conf` and `nginx.prod.ssl.conf`: added `worker_processes auto`, `sendfile`/`tcp_nopush`/`tcp_nodelay`/`keepalive_timeout` tuning; upgraded gzip (`gzip_vary`, `gzip_comp_level 6`, `gzip_proxied any`, added `text/javascript` and `font/woff2`); added `/assets/` location with `Cache-Control: public, max-age=31536000, immutable`; added proxy timeouts; removed deprecated `X-XSS-Protection` header.
- `nginx.prod.ssl.conf`: replaced weak `ssl_ciphers HIGH:!aNULL:!MD5` with explicit ECDHE+AESGCM/CHACHA20 list; added `ssl_session_cache`, `ssl_session_timeout`, OCSP stapling.
- `docker-compose.yml`: removed dead `postgres-logs` volume mount and orphaned `node_modules` top-level volume.
- `docker-compose.prod.yml`: added `resources.limits.memory: 512m` to backend and frontend; added `start_period: 30s` to postgres healthcheck; removed dead `postgres-logs` volume.
- `Dockerfile.backend.prod`: converted from single-stage (installed all deps) to two-stage multi-stage build with `npm ci --omit=dev` in the final stage.
- `Dockerfile.prod`: backend-prod stage now re-installs only production deps and copies only `src/` from the build stage.

**Deployment note**: run `npx sequelize-cli db:migrate` to apply the 14 new indexes via migration `20260723000001-add-performance-indexes.cjs`.

## 2026-08-12

- Updated FreshPrice agent guidance to cover shared platform upload/notification routes, auth UI use of `useAuthStore`, and production Swarm backend targets using `freshprice_backend:4000`.
- Added `instructions/freshprice/FP-53-summary.md` with FP-53 scope, merge-readiness notes, risks, and verification summary.

## 2026-08-17

- Added a reusable searchable product selector for FreshPrice price-entry forms, including product name, local name, and alias matching.
- Replaced the large product dropdown in user price submission and admin price creation with the searchable selector and added targeted unit coverage.
- Added FreshPrice product wiki/recipe backend schema, public wiki and recipe routes, user suggestion endpoints, admin review/import endpoints, and product-card wiki links.
- Added an admin Product Wiki screen for choosing products, saving published/draft wiki content, CSV wiki imports, creating recipe subpages, and reviewing pending wiki/recipe suggestions.
- Tightened product wiki and recipe page layouts, added route-state-aware back navigation from product/admin links, and reduced empty admin wiki editor space before product selection.
- Hardened FP-53 wiki and price-entry error handling: partial wiki suggestions now apply only explicit fields, HTTP(S) source URLs and recipe values are validated, moderation uses row locks, repeated wiki upserts avoid duplicate revisions, imports reject malformed/ambiguous/duplicate rows, and moderation/import actions emit structured logs.
- Added retryable frontend load errors, stale-request protection for admin product switching, separate mutation-success/refresh-failure states, CSV parse/header limits, duplicate-submit prevention, selector load-error/disabled states, and a route-level rendering recovery screen.
- Expanded negative-path regression coverage; frontend lint, 181 unit tests, production build, and 6 Chromium E2E tests pass, while all 84 backend unit tests include wiki patch/URL/recipe validation and API conflict/import-failure handling.

## 2026-08-13

- Fixed FP-53 market-price create/update serialization so backend tests pass after merging to `master`.
- Updated backend production deploy packaging so the VPS image includes `sequelize-cli` and `.sequelizerc` for bundled Sequelize migrations.
- Adjusted backend-only VPS dispatches to bootstrap the Swarm stack only when the network or `freshprice_backend` service is missing, then run migrations and update the backend service directly.
- Fixed frontend admin preview persistence so admins are no longer redirected away from `/admin` after a fresh login or logout.
- Fixed frontend production PWA cache refresh by registering the service worker through `virtual:pwa-register` with immediate update checks, replacing the stale hardcoded app cache version refresher.
- Added frontend generators for flat-style catalog PNG assets and saved generated outputs under `public/assets/generative/{vegetables,fruits,poultry,pork,goods}` with consolidated import mappings.
- Added a supplemental FreshPrice wet-market import CSV for existing orphan assets plus common supported-category wet-market gaps, keeping combined CSV rows and catalog image mappings in sync.
- Repaired FreshPrice import CSV data shape so alias lists populate the `aliases` column, image URLs populate `image_url`, and public `/assets/...` image paths render without API-base prefixing.

## 2026-08-14

- Redesigned guest and signed-in product detail dialogs with a shared clean marketplace layout, responsive scrolling, improved empty-image treatment, and readable product metadata.
- Added accessible modal-owned close controls and visually hidden dialog titles, removing duplicated headings and nested decorative cards across homepage, search, desktop, and mobile product flows.
- Regenerated all 113 catalog assets under `public/assets/generative` in the approved simple flat FreshPrice style while preserving canonical filenames and import paths.
- Promoted the approved flat Whole Chicken illustration to `poultry/whole-chicken.png` and removed its obsolete catalog-v2, catalog-v3, and flat-v4 variants.
- Corrected the supplemental catalog coverage for Pork Chop, Pork Face/Maskara, and Chicken Intestine, including explicit image paths and aliases.
- Generated the missing flat `poultry/chicken-intestine.png` asset and registered its slug in the frontend product-image catalog.

## 2026-09-12

- Created `docs/feature-audit-and-roadmap-2026-09-12.md` with a repository audit, mandatory budget/security/wiki work, optional seller/chat phases, dependencies, and acceptance criteria.
- Reproduced two expense authorization defects with local mocks: unscoped `memberId` overrides the authenticated expense read scope, and create-expense body `userId` overrides the authenticated actor. Recorded these as immediate follow-up; application code was not changed.
- Audit baseline passed: frontend 199 unit tests, backend 103 unit tests, frontend lint and production build. Production data, browser E2E, and database concurrency were not tested.

## Current State

- 2026-09-12 follow-up: implemented audit Updates 0/1 (M01–M07) locally: actor/scoped reads, session-isolated budgets, aggregate totals/pagination, confirmed retryable saves, allocation transactions, invitation expiry/leave, shared-budget UX, activity and notifications. See `docs/budget-updates-0-1-2026-09-12.md` for final checks and release gates; no commit, production migration or deployment.
- 2026-09-12 planning follow-up: reviewed FP-64 and its three tasks through Atlassian Rovo; added `docs/fp-64-sprint-review-2026-09-12.md` and mapped FP-55 to M08–M10, FP-43 to new M12, and FP-56 to optional O10. Jira sprint 335 “Data proliferation” runs September 12–October 10 with an empty goal and three unassigned To Do items lacking descriptions. Jira was not modified.
- 2026-09-12 final local verification: frontend 195 unit tests, backend 117 unit tests, 9 Chromium E2E tests (two workers), frontend lint/build and diff whitespace checks passed. Narrow mobile and desktop screenshots reviewed. PostgreSQL migration/concurrency, staging, deployment and metrics baselines remain open; Docker's Linux engine was unavailable.

- FreshPrice frontend: `fresh-price-front`.
- FreshPrice backend/API: `platform-backend`, especially `src/apps/freshprice` and shared platform routes.
- FreshPrice orchestration: `fpdocker`.
- Root workspace is not itself a git repository, so check git state inside the relevant subproject when needed.

## 2026-08-20

- Added an opt-in Docker `share` profile that provides LAN-only HTTPS through an mkcert certificate and an nginx frontend/API gateway on port `8443`.
- Added certificate generation plus `task share`, `task share:logs`, and `task share:stop`; private keys stay in the Git-ignored `.certs` directory and normal local/production startup remains unchanged.
- Bound direct local development ports to `127.0.0.1`, leaving only the HTTPS sharing gateway reachable from other LAN devices.
- Added device-friendly `.crt` exports for the public LAN certificate and root CA; only `freshprice-rootCA.crt` should be distributed to testers.
- Updated the LAN HTTPS gateway to resolve frontend/backend targets dynamically through Docker DNS, preventing 502 responses after development container restarts.
- Prevented the development HTTPS gateway from persisting backend HSTS for `localhost`, which otherwise forced the HTTP Vite port 5173 to use HTTPS.

## 2026-09-07

- Reviewed latest FreshPrice repos: `fresh-price-front`, `platform-backend`, and `fpdocker` were clean before the upload hardening pass.
- Hardened the FP-54 backend upload upgrade by validating decoded image format before Sharp transformation and limiting multipart uploads to the single expected `image` file part.
- Added best-effort cleanup for replaced product images: when `image_url` changes, the previous managed UUID upload is removed only if no supported image field still references it.
- Updated upload route errors for oversized or extra multipart fields and documented `/api/platform/uploads` route behavior.
- Repaired lingering `market_product_price_history` uniqueness with migration `20260907000001-repair-price-history-unit-constraint.cjs`, preserving one daily snapshot per market/product/unit.
- Aligned backend API E2E coverage with cookie-session auth and operator-only product/price write routes.
- Stabilized frontend admin price-management E2E auth setup so notification polling cannot clear the seeded admin session.
- Installed the newly declared backend `sharp` dependency locally and verified the full local check suite: backend unit 18 files/102 tests, backend integration API 13 tests, backend DB integration 10 tests, backend API E2E 11 tests, frontend lint, frontend unit 31 files/199 tests, frontend build, and frontend E2E 18 tests all passing.
- Cleared npm audit findings in both FreshPrice dependency trees: backend upgraded production/dev packages, added narrow overrides for unresolved transitive advisories, and now reports 0 vulnerabilities; frontend `npm audit fix` updated the lockfile and now reports 0 vulnerabilities.
- Re-ran the post-upgrade checks successfully: backend unit 18 files/102 tests, backend integration API 13 tests, backend DB integration 10 tests, backend API E2E 11 tests, frontend lint, frontend unit 31 files/199 tests, frontend build, and frontend E2E 18 tests.
- Removed generated Playwright/JUnit reports and an unintegrated duplicate Python E2E harness from the FP-54 merge surface; added ignore rules to keep test output out of Git.
- Reduced backend dependency overrides to the two transitive security fixes still required by npm audit (`qs` and `uuid`).
- Updated backend CI to Node 20 to match the FP-54 dependency engine requirements.
- Made orphan-upload checks return an empty result when `UPLOAD_DIR` does not exist yet and scoped the price-history repair migration's constraint lookup to its target table.
- Removed stale LAN share-gateway and old FP-50/FP-53 merge instructions after confirming the gateway is no longer part of `fpdocker`.

## 2026-09-08

- Completed the final FP-54 release audit after clean npm installs in both app repositories.
- Restored only the required `minimatch@9.0.9` backend override after a clean install exposed two high-severity transitive advisories; backend and frontend npm audits both report zero vulnerabilities.
- Verified backend unit tests (18 files/103 tests), API integration tests (13 tests), database integration tests (10 tests), and API E2E tests (11 tests) with no failures or skips.
- Verified frontend lint, unit tests (31 files/199 tests), production build, and Chromium E2E tests (6 tests) with no failures or skips.
- Restarted the Docker development stack successfully; migrations exited with code 0 and the retired `fpdocker-share-gateway-1` orphan was removed.
- Refreshed remote refs and confirmed both FP-54 branches are direct fast-forwards from current `origin/master` with no merge conflicts.
- Traced stale broken product images on previously visited production devices to `https://freshprice.philwatch.com/sw.js` being cached by Cloudflare for four hours, allowing an obsolete application shell to remain active.
- Added exact nginx locations that serve `/sw.js` with browser/CDN `no-store` headers and the web manifest with the correct MIME type and revalidation headers in both production nginx variants.
- Added frontend service-worker update checks when the page becomes visible and once per hour so returning tabs discover a new release promptly.
- Revalidated the cache fix with nginx syntax and response-header checks, Docker Compose config validation, frontend lint, 31 unit files/199 tests, production build, and all 6 Chromium E2E tests passing.
- Removed a timing race from the admin price-management E2E assertion that was exposed by the full cache-fix regression run.

## Conflict Resolution Audit — 2026-10-02

- Reconciled upstream/stashed documentation conflicts, preserving deployment history and pending checks. Checked deployment claims against local workflow/Compose sources; no application code or production state changed.
