# Sugilanon Todo

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
