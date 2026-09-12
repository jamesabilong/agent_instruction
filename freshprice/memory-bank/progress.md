# FreshPrice Progress

## 2026-07-01

- Split FreshPrice documentation into `instructions/freshprice`.
- FreshPrice docs now cover frontend, backend, Docker deployment, API routes, and schema inventory separately from Sugilanon and portfolio docs.
- Previous investigation confirmed FreshPrice frontend and backend have active unit/E2E test structures.
- Backend API ownership relevant to FreshPrice is namespaced under `/api/platform` and `/api/freshprice`.
- Docker local development expects `platform-backend` as the canonical backend folder.
- Confirmed production trigger flow: frontend/backend `master` pushes dispatch the `fpdocker` workflow, which builds/pushes the relevant image and updates the VPS service.
- Added README deployment trigger notes to `fresh-price-front` and `platform-backend`.
- Updated production frontend container setup for Caddy TLS termination: container serves HTTP only on the configured host port.

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

- FreshPrice frontend: `fresh-price-front`.
- FreshPrice backend/API: `platform-backend`, especially `src/apps/freshprice` and shared platform routes.
- FreshPrice orchestration: `fpdocker`.
- Root workspace is not itself a git repository, so check git state inside the relevant subproject when needed.
