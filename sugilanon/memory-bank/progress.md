# Sugilanon Progress

## 2026-10-09

- Investigated PhilWatch's reported FreshPrice first-load display. Live homepage is already no-store/Cloudflare DYNAMIC; apex `/sw.js` returns 404. Reproduced the same symptom with an old navigation-caching worker, which remains active when its script is removed. The affected device's actual registration remains uninspected.
- Added a no-store retirement worker at the legacy URL and an existing-registration update check in the layout. Chromium verifies automatic recovery, subsequent normal reloads, selective precache removal, storage preservation, clean visitors, separate-origin isolation, and recovery after a hard refresh. Lint/build pass.
- Committed as `b15da39` on Sugilanon `main`; the companion Docker cache fix is `a459648` on `FP-64`. Neither commit has been pushed or deployed. Release and targeted Cloudflare purge steps are in `docs/cache-recovery-2026-10-09.md`.

## 2026-09-15

- Fixed the production Sugilanon health-check design: `/` renders content API data and intermittently exceeded Docker Swarm's five-second probe timeout, causing Swarm to terminate otherwise healthy Next.js tasks. Added a dependency-free `/health` route, pointed the production probe at it, and documented diagnosis, temporary recovery, deployment order, and verification in both deployment READMEs.

## 2026-07-01

- Split Sugilanon documentation into `instructions/sugilanon`.
- Documented Next.js frontend shape, content API routes, content models, and deployment notes separately from FreshPrice and portfolio docs.
- Added Sugilanon GitHub Actions deploy trigger for `main` pushes to dispatch `sugilanon-updated` to `fpdocker`.
- Corrected production routing expectation from `sugilanon.philwatch.com` to `philwatch.com`.
- Documented that Caddy terminates TLS for `philwatch.com` on the VPS.

## 2026-07-02

- Fixed Sugilanon deploy dispatch to run for pushes to either `main` or `master` and pass the pushed ref/SHA into the `fpdocker` build.
- Switched the production Sugilanon image to Next.js standalone output and the generated `server.js` runtime.
- Documented and aligned nginx config so Sugilanon is intended to run on `philwatch.com`, not `sugilanon.philwatch.com`, including env, nginx, smoke test, and TLS certificate references.
- Verified the Sugilanon production build and production Compose render locally.
- Documented the manual `sugilanon-updated` production dispatch command in the Sugilanon and Docker READMEs.
- Added Sugilanon production dispatch details to shared, Sugilanon, and Docker agent instructions.
- Clarified in the Sugilanon README that README-only pushes to `main` or `master` still trigger the `sugilanon-updated` deployment chain.
- Added a Sugilanon README note to check the downstream `fpdocker` `sugilanon-updated` action after triggering deployment.
- Added a Sugilanon README note that `Bad credentials` in the trigger workflow means the `GH_PAT` Actions secret needs permission to dispatch to `jamesabilong/fpdocker`.
- Updated shared Docker deployment config so Sugilanon probes `127.0.0.1:3000` and the `sugilanon-updated` workflow does not wait indefinitely for Swarm progress output.
- Added `SUGILANON_PORT` production mapping defaults and documentation so Caddy can route `philwatch.com` to Sugilanon on `127.0.0.1:3001`.
- Expanded the Sugilanon README manual trigger instructions with `GH_PAT` setup, expected empty success response, and `Bad credentials` guidance.

## Current State

- Sugilanon frontend lives in `sugilanon`.
- Sugilanon backend content APIs live under `platform-backend/src/apps/sugilanon`.
- Public routes are mounted under `/api/sugilanon`; `/api/content` is deprecated.
- Root workspace is not itself a git repository, so check git state inside the relevant subproject when needed.

## Conflict Resolution Audit — 2026-10-02

- Reconciled upstream/stashed documentation conflicts, preserving deployment history and pending checks. Checked deployment claims against local workflow/Compose sources; no application code or production state changed.
