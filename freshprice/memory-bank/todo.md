# FreshPrice Todo

## Worker cache release — 2026-10-09

- [x] Restore and verify worker/manifest browser/CDN headers in both production nginx variants; expand proxy regressions while preserving immutable asset caching. Reapplied the missing Docker edits and reran nginx/HTTP/TLS/maintenance checks on October 9; Sugilanon's recovery changes remained present.
- [x] Commit the Docker cache fixes (`a459648` on `FP-64`, October 9).
- [ ] Publish Docker configuration and rebuild/release the frontend image, then purge the exact FreshPrice worker/manifest URLs and require `/sw.js` no-store. Coordinate the PhilWatch legacy-worker release and affected-device checks in `instructions/sugilanon/docs/cache-recovery-2026-10-09.md`. Live FreshPrice worker headers were still four-hour max-age on October 9.

- [x] FP-43 audit fixes verified locally: suspend dialog portals/focus traps during recovery, scope recovery/probe promises to the current view/session, exempt optional layout calls from global outage handling, and restore immutable caching for hashed assets. Added passing regressions for the confirmed cases in `docs/fp-43-audit-2026-10-02.md`.

- [x] FP-43: implement and locally verify recovery screens and deployment fallback; see `docs/fp-43-recovery-runbook.md`.
- [ ] FP-43 release: integrate/validate the Caddy snippet on the actual host, run staging outage/recovery checks, deploy through the normal process, and update Jira when write access is available.

## FP-56 follow-up — 2026-10-02

- [x] Implement and verify the current **Budget Feature tightening** scope on `FP-64`; see `docs/fp-56-budget-tightening-2026-10-02.md`.
- [x] Apply existing FP-64 migrations and run database-gated budget/moderation checks in isolated PostgreSQL (30 integration tests passed, October 2).
- [ ] Run staging account-switch, multi-unit expense, Philippine-midnight, and paginated approval/rejection checks; release the backward-compatible backend before the frontend.

## Ongoing

- Keep `instructions/freshprice/docs/api-routes.md` updated whenever FreshPrice or shared platform routes used by FreshPrice change.
- Keep `instructions/freshprice/docs/database-schema.md` updated whenever FreshPrice-related Sequelize models or migrations change.
- Keep `instructions/freshprice/docs/project-spec.md` updated when FreshPrice workflows or app boundaries change.
- Keep `instructions/freshprice/docs/deployment.md` updated when Docker, nginx, environment, or deploy flows change.

## Audit Follow-Up 2026-09-12

- Use `docs/feature-audit-and-roadmap-2026-09-12.md` as the detailed mandatory/optional backlog.
- Updates 0/1 (M01–M07) are present in the current `FP-64` checkout (confirmed October 2); isolated migration and budget integration checks passed October 2; before release, perform staging access/retry/PWA checks and the normal release process. See `docs/budget-updates-0-1-2026-09-12.md`.
- Wiki update: inventory live coverage, enforce publication quality, improve draft imports, and publish an initial reviewed content batch (M08-M10).
- Add release regressions for cross-account access, 201+ expenses, failed saves, shared membership changes, and wiki publication (M11).
- Optional later: seller profiles/offers and private text chat pilots, followed by advanced budget, offline, and wiki features.
- FP-64 / sprint 335: define sprint goal, owner/reviewer, estimates and acceptance criteria. Map FP-55 to existing wiki quality/coverage work (M08–M10); deliver FP-43 maintenance readiness (M12); FP-56 now covers budget tightening (implemented locally October 2). Treat O10 external ingestion as a separate optional future item. See `docs/fp-64-sprint-review-2026-09-12.md`.

## Next Wiki Work — Tighten Existing Gaps (2026-10-02)

- [ ] **High — Verify the complete wiki workflow against a local database.** Migrations, recipe draft lifecycle, public reads, permissions and moderation persistence passed October 2. Remaining broader verification: user suggestion submission and CSV import against the database. Confirm drafts stay private, rejected suggestions leave published content unchanged, and approved changes persist after reload. Include recipe detail navigation and valid/invalid CSV imports; record actual results separately from mocked test results.
- [x] **High — Complete existing recipe editing and publishing.** Add operator-only API and admin UI support for editing saved recipes and publishing/unpublishing drafts. Preserve product association, validate fields, show save failures, and prevent duplicate saves. Verify public visibility changes and deny writes from regular users.
- [x] **Medium — Make all published recipes discoverable.** Add a view-all or paginated recipe list from the public wiki instead of stopping at six entries. Show an accurate published count, preserve back navigation, and exclude drafts. Cover products with zero, six, and more than six recipes.
- [x] **Medium — Paginate wiki and recipe moderation queues (FP-56, 2026-10-02).** Replace the fixed newest-100 limit with pagination and total counts. Preserve product/status filters, allow access to older pending suggestions, and refresh the queue correctly after approval/rejection. Cover more than 100 suggestions.
- [x] **Completion checks — Add regression coverage for these gaps.** Include database/API coverage for persistence, permissions, and moderation plus browser coverage for recipe draft → edit → publish → public view. Run frontend lint, unit tests, build, relevant Chromium E2E tests, and affected backend tests. Update API documentation and memory-bank status; do not mark runtime verification complete based only on mocked tests.

## Suggested Follow-Up

- Reconcile the September implementation claims with the 2026-10-01 audit before duplicating work; current checkout still needs fixes for expense read/create ownership enforcement and account-specific budget cache isolation first, with cross-account regression coverage.
- Correct budget summaries beyond 200 expenses, explicit expense-price unit selection, and stale-response handling.
- Standardize business dates, expose retryable loading failures, correct the current-price/history label, and deduplicate budget hydration; see `docs/existing-feature-audit-2026-10-01.md`.

- Push the `fpdocker` production nginx changes to `master` before merging or dispatching the FreshPrice frontend release, so the frontend image is built with the new service-worker cache headers.
- After the frontend deploy, purge the exact Cloudflare URLs `https://freshprice.philwatch.com/sw.js` and `https://freshprice.philwatch.com/manifest.webmanifest`; verify `/sw.js` returns `Cache-Control: no-store`, then reopen FreshPrice on a previously affected device and confirm the current product image appears.
- Commit and push the FP-54 backend `package.json` and `package-lock.json` minimatch security fix before merging the branch into `master`.
- Run `npx sequelize-cli db:migrate` during the next backend deploy to apply `20260907000001-repair-price-history-unit-constraint.cjs` and remove any lingering date-only price-history uniqueness.
- After deploying the upload replacement cleanup, replace one product image in staging/production and confirm the old managed UUID WebP is removed from `UPLOAD_DIR`.
- Add richer wiki moderation later if needed: visual field-by-field diffs, revision restore UI, trusted-domain/source-quality scoring, and recipe revision history.
- Before production deployment, run `20260817000001-create-product-wiki-tables.cjs` on a disposable PostgreSQL copy and verify both `up` and `down`; the new backend product-list query expects the wiki table to exist.
- Consider replacing the budget expense product picker with the shared searchable product selector in a later consistency pass.
- Confirm the active production nginx config and TLS certificate path use `philwatch.com` for Sugilanon, not `sugilanon.philwatch.com`.
- Confirm the active VPS TLS terminator and nginx config are aligned before switching between HTTP-only and SSL nginx images.
- Confirm the next VPS stack deploy preserves the frontend healthcheck probe against `127.0.0.1`.
- Confirm the next VPS stack deploy preserves the backend healthcheck probe against `127.0.0.1:4000`.
- After deploying the backend healthcheck fix, verify `https://freshprice.philwatch.com/api/platform/db/health` returns `{"status":"ok","database":"ready"}` and the budget setup page no longer surfaces Cloudflare 502.
- On the VPS, confirm there is no stale `CONTENT_API_BASE_URL=http://backend:4000/api` override; production defaults now use `http://freshprice_backend:4000/api`.
- Confirm manual deployment dispatch instructions match any future workflow trigger changes.
- Confirm the next `backend-updated` dispatch no longer reconciles `freshprice_sugilanon` when the backend service already exists.
- Confirm the next production stack deploy publishes Sugilanon on `SUGILANON_PORT=3001` for Caddy routing.
- Expand `database-schema.md` with per-column field details if a database-focused task is requested.
- Run a full backend production Docker image build once Docker Desktop/Linux engine is available.
- Confirm the next GitHub Actions run and VPS service health after the frontend/backend README trigger commits are pushed.

- Add troubleshooting notes after the next full local Docker run.

## Completed 2026-08-14

- Unified and modernized product detail dialogs for guest, desktop user, search, and mobile product entry points.
- Replaced the full generated product image catalog with 113 consistent flat-style assets and removed superseded Whole Chicken variants.
- Added missing Chicken Intestine and Pork Face/Maskara supplemental import coverage and verified Pork Chop mapping.

## Conflict Audit Follow-Up — 2026-10-02

- Verify live deployment state before closing historical production incidents; this documentation merge does not establish production recovery.
