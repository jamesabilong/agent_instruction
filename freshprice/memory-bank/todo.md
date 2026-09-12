# FreshPrice Todo

## Ongoing

- Keep `instructions/freshprice/docs/api-routes.md` updated whenever FreshPrice or shared platform routes used by FreshPrice change.
- Keep `instructions/freshprice/docs/database-schema.md` updated whenever FreshPrice-related Sequelize models or migrations change.
- Keep `instructions/freshprice/docs/project-spec.md` updated when FreshPrice workflows or app boundaries change.
- Keep `instructions/freshprice/docs/deployment.md` updated when Docker, nginx, environment, or deploy flows change.

## Audit Follow-Up 2026-09-12

- Use `docs/feature-audit-and-roadmap-2026-09-12.md` as the detailed mandatory/optional backlog.
- Updates 0/1 (M01–M07) are implemented locally. Next: apply the additive migration in an isolated PostgreSQL test database, run budget concurrency integration tests, then perform staging access/retry/PWA checks and the normal release process. See `docs/budget-updates-0-1-2026-09-12.md`.
- Wiki update: inventory live coverage, enforce publication quality, improve draft imports, and publish an initial reviewed content batch (M08-M10).
- Add release regressions for cross-account access, 201+ expenses, failed saves, shared membership changes, and wiki publication (M11).
- Optional later: seller profiles/offers and private text chat pilots, followed by advanced budget, offline, and wiki features.
- FP-64 / sprint 335: define sprint goal, owner/reviewer, estimates and acceptance criteria. Map FP-55 to existing wiki quality/coverage work (M08–M10); deliver FP-43 maintenance readiness (M12); keep FP-56 one-source ingestion (O10) optional after draft review. Confirm wiki content versus market-price collection before implementing the collector. See `docs/fp-64-sprint-review-2026-09-12.md`.

## Suggested Follow-Up

- Expand `database-schema.md` with per-column field details if a database-focused task is requested.
- Run a full backend production Docker image build once Docker Desktop/Linux engine is available.
- Confirm the next GitHub Actions run and VPS service health after the frontend/backend README trigger commits are pushed.

## Completed 2026-08-14

- Unified and modernized product detail dialogs for guest, desktop user, search, and mobile product entry points.
- Replaced the full generated product image catalog with 113 consistent flat-style assets and removed superseded Whole Chicken variants.
- Added missing Chicken Intestine and Pork Face/Maskara supplemental import coverage and verified Pork Chop mapping.
