# FreshPrice Bugs And Risks

## Known Risks

- The root workspace is not a git repository. Worktree checks must be run inside the relevant subproject repository when needed.
- `/api/vegetables` is removed and returns 410. New callers should use `/api/freshprice/products`.

## Open Bugs

- 2026-07-01 deploy logs showed `freshprice_sugilanon` rejected with `No such image: ghcr.io/jamesabilong/sugilanon:latest`; frontend/backend deploys can still surface this because the stack includes the Sugilanon service.
- 2026-07-01 deploy logs showed `freshprice_backend` repeatedly failing health checks with exit 137 after startup; live VPS memory/healthcheck state still needs confirmation.
- 2026-07-01 frontend nginx logs showed the config was still pointing Sugilanon at `sugilanon.philwatch.com`; production should serve Sugilanon from `philwatch.com`.

## Audit Findings 2026-09-12

- P0, reproduced with local mocks: `expenseService.listExpenses` allows an unscoped `memberId` to replace the authenticated user's query scope (A01).
- P0, reproduced with local mocks: `expenseController.createExpense` spreads `req.body` after the authenticated `userId`, allowing actor override (A02).
- P1, source-confirmed risks: budget storage is shared across accounts without logout reset (A03); first-200 expense hydration can understate totals (A04); failed saves can resolve as success or retain unqueued optimistic state (A05).
- P1, concurrency risk requiring database validation: sub-budget allocation checks and writes are not protected by a transaction/parent lock (A06).
- Follow-up 2026-09-12: A01–A05 repaired in local code with regression coverage; A06 now uses transactional parent locks, but real PostgreSQL concurrency/migration checks are still required because Docker's Linux engine was unavailable. Production remains unverified. See `docs/budget-updates-0-1-2026-09-12.md`; the bullets above preserve the original audit findings.
- A08 wiki publication-quality gap remains open and is part of FP-55/M08. FP-56 must not auto-publish collected material before the review contract is implemented.

## Resolved Bugs

- 2026-09-12 local: expense impersonation/unscoped member reads, cross-session budget cache retention, first-page-only summary calculations, swallowed save errors, and initial-load form/target defaults were repaired. Shared expense mutations now recheck membership, and a removed/unavailable expense target cannot silently become a personal expense. Release verification remains open as documented above.

- 2026-08-13 FP-53 backend market-price POST/PUT tests failed with `toJSON is not a function`; fixed by reloading hydrated price rows and serializing Sequelize/plain records defensively.
- 2026-08-13 FP-53 backend deploy image could not reliably run VPS migrations because `sequelize-cli` and `.sequelizerc` were not included in the production image; fixed by making the CLI a production dependency and copying `.sequelizerc`.
- 2026-08-13 Admins could stay in persisted `previewAsUser` mode and be redirected away from `/admin`; fixed by clearing preview mode when a session token is stored or cleared.
- 2026-08-13 Production frontend updates could require a hard refresh because the app cache refresher used a static `APP_CACHE_VERSION` and the generated service worker registration did not reload clients on update; fixed by using `virtual:pwa-register` with the existing `autoUpdate` service worker setup and removing the broad localStorage cache clear.
