# FreshPrice Project Spec

> FP-59 checkout update (2026-10-19): the current frontend/backend FP-59 branches include viewer/contributor roles, explicitly accepted ownership transfer and private monthly recurring budget templates. Full registered local verification passes 37 PostgreSQL and 16 desktop/mobile browser checks, with isolated runner-owned stacks. The monthly-copy month-end fix is verified through persisted form submissions. See `fp-59-verification-2026-10-19.md` for repaired test commands, restored historical coverage and remaining staging/release gates; older checkout caveats below are historical context.

> Checkout update (2026-10-02): current frontend/backend `FP-64` checkouts contain the September budget reliability implementation. FP-56 now covers budget tightening, with remaining fixes implemented locally; see `fp-56-budget-tightening-2026-10-02.md`. Database/staging/production verification remains pending. Earlier master audit notes describe a different checkout.

Last investigated: 2026-09-12 (budget workflow update)

## Summary

FreshPrice is a produce and market price tracking platform with public price browsing, admin price management, user budget tools, price submissions, and community discussion.

## Code Areas

| Path | Purpose | Stack |
| --- | --- | --- |
| `fresh-price-front` | FreshPrice public, user, auth, and admin SPA | React 19, TypeScript, Vite, Tailwind, Zustand, React Router, Vitest, Playwright |
| `platform-backend` | Shared API plus FreshPrice API modules | Node.js ESM, Express, Sequelize, PostgreSQL, JWT |
| `fpdocker` | Local and production orchestration for FreshPrice stack | Docker Compose, Dockerfiles, nginx, Task |

## Frontend Structure

- Entry points: `fresh-price-front/src/main.tsx`, `fresh-price-front/src/App.tsx`, and `src/router`.
- API services: `fresh-price-front/src/api`.
- Global state: `fresh-price-front/src/store`.
- Feature modules: `fresh-price-front/src/features`.
- Admin features: product, market, price, user, community moderation, and dashboards.
- User/public features: product listings, price history, public price trends, budgets, expenses, price submission, contact, auth, and community.
- Older suites: local workspace `testing/legacy/{frontend,backend,docker}` outside app repositories; app configs/commands point to relocated files.
- Dedicated ticket tests: `testing/tickets/<TICKET>`, including ticket unit/API checks and real-data E2E. FP-65 temporarily owns a 30-case whole-app group plus its nine observation feature cases.
- Fixture requirements generate local-only per-group seeders under `testing/.local`; separate fresh databases and reports prevent cross-group state contamination. See `testing/README.md` and `testing/tickets/FP-65/whole-app/COVERAGE.md`.

## Backend Structure

- Server entry point: `platform-backend/src/server.js`.
- API router entry point: `platform-backend/src/api.js`.
- FreshPrice routes: `platform-backend/src/apps/freshprice/routes`.
- FreshPrice controllers: `platform-backend/src/apps/freshprice/controllers`.
- FreshPrice services: `platform-backend/src/apps/freshprice/services`.
- Shared platform routes used by FreshPrice: `platform-backend/src/routes`.
- Models: `platform-backend/src/models`.
- Migrations: `platform-backend/src/migrations`.
- Backend tests now live in `testing/legacy/backend` and dedicated ticket folders; shared Sugilanon/content checks retain their behavior and database gates.

## Auth And Roles

- Backend auth uses JWT through `authenticateMarketPrice`.
- Operator/admin access is enforced by `requireOperatorRole`.
- Frontend treats `role === 1` as admin/operator and `role === 0` as regular user.
- Auth endpoints are under `/api/platform/auth`.

## Important Conventions

Budget workflow additions (local Update 0/1 implementation): current budgets remain personal; scheduled budgets support owner-managed invitations, seven-day expiry, accepted contributors, self-service leave, and owner removal. Contributors can edit/delete only their own expenses while membership is active. Removal preserves historical expenses. Totals come from server aggregates and history is paginated. Private budget state is cleared across sessions; saves require a confirmed online response, with keyed retries and visible stale/offline status. Budget activity and notifications are recorded transactionally. Database migration and staging gates remain open in `docs/budget-updates-0-1-2026-09-12.md`.

FP-64 wiki coverage, maintenance readiness and optional external ingestion are future scope in `docs/fp-64-sprint-review-2026-09-12.md`; they are not implemented by the budget update.

- Use `VITE_API_BASE_URL` in the frontend instead of hardcoded backend URLs.
- Keep frontend API behavior centralized through `fresh-price-front/src/api/client.ts`.
- FreshPrice API routes should stay under `/api/freshprice/*`.
- Shared auth/user/community APIs should stay under `/api/platform/*`.
- Use Sequelize migrations for schema changes.
- Removed legacy API aliases should not be reintroduced without a migration plan.

## Multiple Price Observations (FP-65, local 2026-10-15)

Operator note imports retain every quoted price as a separate observation, including repeated prices for the same product/market/date/unit. Review supports ISO date headings, name/local-name/alias matching, typo suggestions, optional seller/quality context, explicit units/quantities and a server-normalized statistical preview. Import batches have stable replay identities and same-content warnings. Price History includes paginated observation inspection, corrections and exclusion with revision checks and audit history.

Public/signed-in trends and admin previews offer observation-based Median (default), Mean and Mode, explicit units, daily/weekly grouping, quote counts, market comparisons and tied/no-mode explanations. Published official prices remain separately accessible; existing API clients default to their original official-price basis. Importing/correcting observations does not change official prices or budget estimates. Current operator-only scope deliberately excludes automatic community-submission ingestion; that requires its planned deduplication/review adapter.
