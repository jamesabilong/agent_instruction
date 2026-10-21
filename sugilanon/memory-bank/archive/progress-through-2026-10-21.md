# Historical snapshot through 2026-10-21

Superseded by the current memory-bank file. Older pending/ready claims below describe their original checkpoints, not current state. Paths retain the original app context.

# Sugilanon Progress

## Shared auth follow-up scheduled as FP-66 — 2026-10-21

- User deferred exemption work to future sprint 338. FP-66 covers FreshPrice admin-managed dynamic IP/account exemptions and the shared proxy-identity fix, explicitly requiring validation of PhilWatch's auth path. Story/To Do; no Sugilanon source/config change or live exemption applied. See `../../freshprice/docs/auth-testing-exemption-2026-10-21.md`.

## Shared auth exemption investigation — 2026-10-21

- FreshPrice public-path probe confirms shared backend client identity can collapse to Docker gateway, causing shared limiter buckets. No PhilWatch-specific probe, source change or production exemption applied. Any shared-auth correction must validate PhilWatch separately. See `../../freshprice/docs/auth-testing-exemption-2026-10-21.md`.

## FP-61 shared-stack verification — 2026-10-21

- Following the user's FP-61 release, read-only checks confirm unchanged healthy Sugilanon task and passing public PhilWatch health. Shared DB identity/volume and fresh private connection pass; no published DB port, active/enabled guard and external denial retained. No Sugilanon source/production changes by verification. See `../../freshprice/docs/fp61-deployment-2026-10-21.md`.

## FP-60 shared-stack verification — 2026-10-21

- Read-only post-FP-60 checks confirm one healthy unchanged Sugilanon task and passing public PhilWatch health. Shared DB retains checkpoint identity/data volume, private backend connectivity, no host port publication and active/enabled guard. No Sugilanon source/production change by verification. See `../../freshprice/docs/fp60-deployment-2026-10-21.md`.

## Shared database publication removed; deployment health verified — 2026-10-21

- User's Docker/FP-59 rollout applied PostgreSQL port removal. Read-only checks confirm original DB volume/system identity preserved, private DB connection succeeds, no DB published ports, guard active/enabled, and external 5432 blocked. Sugilanon remains one healthy task with unchanged task identity; public PhilWatch `/health` returns 200 `ok`. No Sugilanon source change or production mutation by verification. See `../../freshprice/docs/fp59-deployment-2026-10-21.md`.

## Shared Docker security sources published — 2026-10-21

- Reviewed/committed shared PostgreSQL security sources as `5b42640`, pushed `fix/postgres-private-networking`, and opened `jamesabilong/fpdocker#25` under master's PR requirement. Three rendered maintenance cases pass, including no PostgreSQL host ports. No Sugilanon source change, PR merge, dispatch or deployment. Keep the enabled live guard; check Sugilanon alongside FreshPrice when the first frontend stack reconciliation removes DB publication.

## Shared PostgreSQL public access secured — 2026-10-21

- User-authorized FreshPrice/shared-DB remediation installed a persistent independent nftables guard for public eth0 TCP 5432. Sugilanon uses private `postgres:5432`; overlay access preserved, public/origin PhilWatch `/health` returns 200 `ok`, and all service/task/image identities remain unchanged/healthy. No Sugilanon source change, service restart, migration or deployment.
- Local shared production Compose removes DB publishing; source correction/guard files uncommitted and unpublished. Live publication remains protected by the enabled guard. See `../../freshprice/docs/postgres-security-2026-10-21.md`; maintain guard coverage if public networking changes.

## Shared backend test relocation — 2026-10-15

- Moved all existing shared backend test/support files, including content/Sugilanon checks, to local `testing/legacy/backend/`; dedicated FP-65 checks are separate. Updated backend test configuration; Sugilanon application source is unchanged. Ordinary backend run: 150 pass, 23 database-gated skips; gated model/concurrency suites were not rerun in this relocation.

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
