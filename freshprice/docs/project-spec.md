# FreshPrice Project Spec

> Current state (2026-10-23): FP-59/60/61 and FP-62/63 are released and verified; FP-62/63 are Done in Jira. All four FP-62/63 deployment workflows, approved six multilingual variants/two recipes, final host checks and protected backup/full isolated restore pass. Shared VPS update/reboot/postboot checks also pass. [Release record](fp62-fp63-deployment-2026-10-22.md), [maintenance](vps-maintenance-2026-10-22.md), [progress](../memory-bank/progress.md). Sprint 338 is active October 22–November 5; FP-66 is In Progress with complete local forwarding/SSR, own-account exemption controls and admin UI; 9+30 acceptance plus unit/database/proxy checks pass. Disabled by default; production release gates remain. [FP-66 implementation](fp-66-controls-2026-10-23.md).

Last consolidated: 2026-10-26. FP-66 is published in four coordinated draft PRs; see [publication](fp-66-publication-2026-10-26.md). [Authorized fresh backup, Caddy 2.11.7 upgrade and readiness rechecks](fp-66-caddy-maintenance-2026-10-26.md) pass; earlier version/backup-age gates are closed at this checkpoint. No app PR merge/deployment or FP-66 activation authorized. Feature descriptions below retain their implementation-date context.

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

FP-59 (local, 2026-10-19): scheduled-budget memberships support contributor/viewer roles, owner-managed invitation/member roles, and viewer access to shared totals/history/activity without expense mutations. Contributor API `shareRole=collaborator` is preserved; `viewer` is additive. Expense writes recheck both original and destination shared-budget capabilities. Ownership transfer requires an accepted member's explicit acceptance within seven days; the previous owner becomes a contributor and expense authors remain unchanged. Monthly templates snapshot budget/allocation values and generate independent private instances without copying expenses or memberships. Templates remain owned by their creator after source transfer/deletion; pause/resume skips missed starts and cancellation permanently stops generation. Calendar anchors use Asia/Manila dates and clamp short months without drifting. See `fp-59-viewer-roles-2026-10-19.md` and `fp-59-lifecycle-2026-10-19.md` for permissions, lifecycle, validation and rollout details. Local implementation does not establish deployment or staging readiness.

Operator note imports retain every quoted price as a separate observation, including repeated prices for the same product/market/date/unit. Review supports ISO date headings, name/local-name/alias matching, typo suggestions, optional seller/quality context, explicit units/quantities and a server-normalized statistical preview. Import batches have stable replay identities and same-content warnings. Price History includes paginated observation inspection, corrections and exclusion with revision checks and audit history.

Public/signed-in trends and admin previews offer observation-based Median (default), Mean and Mode, explicit units, daily/weekly grouping, quote counts, market comparisons and tied/no-mode explanations. Published official prices remain separately accessible; existing API clients default to their original official-price basis. Importing/correcting observations does not change official prices or budget estimates. Current operator-only scope deliberately excludes automatic community-submission ingestion; that requires its planned deduplication/review adapter.

FP-60 (local 2026-10-19) adds scheduled shared-expense payer/beneficiary splits, exact PHP centavo shares, revision-aware corrections, member balances and manually recorded two-party-confirmed payments/full reversals. Legacy unsplit expenses remain author-paid/sole-beneficiary and net neutral. Expense totals retain their whole-peso contract. Viewer write restrictions and removed-member historical identities are preserved. Payments remain separate from spending; no money is transferred. See `fp-60-accounting-2026-10-19.md` for policy, endpoints, review and release gates; staging/deployment remain pending.

FP-61 (local 2026-10-20) adds account-scoped IndexedDB expense create/edit drafts, foreground replay, tab leases, durable server mutation receipts, reviewed revision conflicts and a sync center. Pending amounts remain separate from confirmed totals; membership/settlement/deletion operations remain online. Explicit logout discards local work; session expiry retains hidden drafts for same-account reauthentication. Replays reauthorize current permissions and original current-budget identity. See `fp-61-offline-editing-2026-10-20.md`; migration/backend-before-frontend and staging/PWA upgrade gates remain required.

FP-62 (local, 2026-10-20) adds separately moderated English/Filipino/Cebuano editorial and regional-seasonal variants linked to canonical product/source revisions, environment inventory, sourced seasonal browsing, recipe search/difficulty/cooking-time filters and opt-in contributor names with author withdrawal. Source changes retain proposals but hide obsolete public variants until renewed review; unknown seasonal calendars stay unknown. Synthetic acceptance fixtures do not establish production content coverage or factual/translation approval. See `fp-62-wiki-enrichment-2026-10-20.md`; deploy additive schema/backend before frontend and complete actual-environment inventory/editorial/staging gates.

FP-63 (local, 2026-10-20): personal persistent shopping lists snapshot published recipe ingredients, scale documented servings and resolve exact canonical/alias names. Selected-market official estimates support only compatible units and fresh available quotes; missing/stale/unmatched items retain an unknown full basket total. Lists can reference an accessible current or shared budget without sharing list ownership. Only explicit actual purchase confirmation creates an expense, atomically with an idempotent operation receipt and permanent item purchase marker. Read/check-off never books spending. Account changes clear private UI; shopping forms remain online/in-memory. Favorites/alerts follow separately. See `docs/fp-63-shopping-integration-2026-10-20.md`; staging and migration/backend-before-frontend release gates remain open.
