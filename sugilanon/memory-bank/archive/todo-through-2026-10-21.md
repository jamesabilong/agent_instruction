# Historical snapshot through 2026-10-21

Superseded by the current memory-bank file. Older pending/ready claims below describe their original checkpoints, not current state. Paths retain the original app context.

# Sugilanon Todo

- [ ] Validate shared auth/client-IP behavior for PhilWatch when implementing FP-66 in future sprint 338; no live bypass enabled during planning.

## Shared auth client identity — 2026-10-21

- [ ] Include PhilWatch's route in validation if fixing shared auth proxy identity/testing exemption. FreshPrice route currently groups traffic under gateway; no PhilWatch-specific repro or production change performed. See `../../freshprice/docs/auth-testing-exemption-2026-10-21.md`.

## FP-61 shared-stack health — 2026-10-21

- [x] Verify unchanged healthy Sugilanon task, public health and preserved shared DB identity/volume/private access/security after FP-61 stack reconciliation. See `../../freshprice/docs/fp61-deployment-2026-10-21.md`.

## FP-60 shared-stack health — 2026-10-21

- [x] Verify healthy Sugilanon task/public health and preserved private DB/security settings following FP-60's frontend stack reconciliation. See `../../freshprice/docs/fp60-deployment-2026-10-21.md`.

## Shared database rollout verified — 2026-10-21

- [x] Verify shared PostgreSQL port removal after Docker/FP-59 rollout, preserved DB identity/volume, healthy Sugilanon task and public health. Firewall guard remains active/enabled; earlier pending publication/reconciliation notes are superseded. See `../../freshprice/docs/fp59-deployment-2026-10-21.md`.

## Shared Docker security publication — 2026-10-21

- [x] Review/commit/push shared security sources as `5b42640` and open `jamesabilong/fpdocker#25`; this supersedes earlier unpublished-source notes. No app deployment.
- [ ] Preserve live guard when Docker #25 lands and verify PhilWatch health during FreshPrice's first frontend stack reconciliation/removal of PostgreSQL publication.

## Shared PostgreSQL security — 2026-10-21

- [x] Verify Sugilanon private DB target, unchanged healthy service identities and public/origin health during shared PostgreSQL public-port restriction. See `../../freshprice/docs/postgres-security-2026-10-21.md`.
- [ ] Preserve the enabled public-interface guard when publishing the shared Compose port-removal correction; no app deployment or repository publication performed during mitigation.

## Shared backend test relocation — 2026-10-15

- [x] Relocate existing shared backend suites/support to local `testing/legacy/backend/` and verify ordinary backend checks.
- [ ] Keep local testing-folder backups; app-only remote checkouts no longer contain these suites.

## Cache recovery — 2026-10-09

- [x] Implement and locally verify the legacy `/sw.js` retirement route and layout update check without clearing user storage or registering a worker for new visitors.
- [x] Commit the PhilWatch legacy-worker recovery (`b15da39` on `main`, October 9).
- [ ] Release the Sugilanon fix, purge `https://philwatch.com/sw.js`, and confirm normal revisits recover on an affected device. Coordinate the FreshPrice nginx release and worker/manifest purge; see `docs/cache-recovery-2026-10-09.md`.

## Ongoing

- Keep `instructions/sugilanon/docs/project-spec.md` updated when frontend or content API architecture changes.
- Keep `instructions/sugilanon/docs/api-routes.md` updated when content routes change.
- Keep `instructions/sugilanon/docs/deployment.md` updated when environment, Docker, nginx, or deploy flows change.
- After deploying the 2026-09-15 health-check fix, confirm `freshprice_sugilanon` remains healthy and `https://philwatch.com/` returns 200.

## Suggested Follow-Up

- Confirm the VPS has `/etc/letsencrypt/live/philwatch.com/fullchain.pem` before enabling `nginx.prod.ssl.conf` for Sugilanon.
- Confirm manual deployment dispatch instructions match any future workflow trigger changes.
- Confirm the documented manual Sugilanon dispatch flow after the `GH_PAT` secret/token is refreshed.
- Confirm `philwatch.com` routes through Caddy to `127.0.0.1:3001` after the Sugilanon service publishes `SUGILANON_PORT`.
- Add per-model field details for content tables if a content schema task is requested.
- Add known admin workflow notes after the next admin feature change.
- Confirm the first Sugilanon dispatch builds and pushes `ghcr.io/jamesabilong/sugilanon:latest`.

## Conflict Audit Follow-Up — 2026-10-02

- Verify live deployment state before closing historical production incidents; this documentation merge does not establish production recovery.
