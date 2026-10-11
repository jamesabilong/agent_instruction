# FP-43 recovery screens and maintenance operation

Implemented locally on 2026-10-02. No deployment or Jira update was performed.

## Application behavior

- Unknown public paths show Page not found; unknown admin/user paths still pass through the existing role guard. Wiki, recipe and community resource 404 responses use the same screen. Unexpected route-rendering errors offer a reload.
- The Axios client has a 15-second default timeout. A network/timeout or 500–504 failure triggers one shared, 5-second readiness request to `/api/platform/db/health`. A healthy readiness response leaves the original failure local to the page. Notification polling and explicitly optional background market lookup failures never trigger the global screen.
- If readiness also fails, the current page stays mounted but hidden/inert behind the recovery screen. Session state and in-memory form inputs remain intact. Open portal dialogs become hidden and suspend focus management until recovery, preserving their editor inputs. Offline browsers get connection-specific wording; loaded pages show an offline notice.
- Try again checks readiness and then retries pending GET/HEAD requests only. Original callers receive the retried data, so the screen clears after reads recover. Failed writes are never replayed: the original save failure remains visible when the screen closes, and the user decides whether to submit again. If a write response was lost, check whether it saved before retrying.
- Navigation or session changes cancel queued reads; old-session responses are discarded. Reset also detaches old readiness/retry promises, with identity-safe cleanup so stale completion cannot clear current work. Retry checks are deduplicated. There is no automatic outage polling or redirect loop.
- HTTP 400/401/403/404/422/429 keep their normal handling. Maintenance does not log a user out. API/maintenance responses are not service-worker navigation fallbacks. Readiness responses are no-store.

## Deployment components

`fpdocker/Dockerfile.prod` installs standalone fallback HTML and the startup maintenance switch into the nginx image. No API, database, remote images, fonts or JavaScript are needed for that HTML.

Normal nginx document routes serve the SPA. Hashed `/assets/` files retain one-year immutable caching. Missing assets return 404; API paths proxy to the API and return JSON 503 on a connection failure. `/healthz` reports nginx readiness independently of planned maintenance; the frontend Compose healthcheck now uses it. Existing backend healthchecks are unchanged.

The active production path is Caddy → frontend nginx → API. If the entire frontend container is unavailable, nginx cannot serve its fallback. `fpdocker/maintenance/Caddyfile.snippet` supplies an independent edge fallback for that case. Install it in the **FreshPrice site only**, preserving unrelated sites and existing TLS/reverse-proxy settings:

1. Copy `fpdocker/maintenance/index.html` to `/srv/freshprice-maintenance/index.html` on the Caddy host. Ensure the Caddy service user can read it and traverse its directories.
2. Copy the snippet to a stable host path and import that file inside the existing `freshprice.philwatch.com` site block. Back up the active configuration first; merge with any existing error handler rather than adding competing handlers.
3. Validate the actual active Caddy configuration with `caddy validate --config <active-config-path>`, then reload the existing Caddy service through its normal deployment process.
4. On staging, stop only the staging frontend and verify HTML 503 with `Retry-After: 60` on document URLs and JSON 503 on `/api/*`. Restore it and verify normal traffic.

The snippet uses Caddy's [error handlers](https://caddyserver.com/docs/caddyfile/directives/handle_errors) and [file-server status override](https://caddyserver.com/docs/caddyfile/directives/file_server). It handles connection errors; ordinary upstream HTTP errors remain the upstream's responsibility. DNS/TLS/host outages still require independently hosted infrastructure. The live Caddy configuration was not read or changed in this task.

## Planned maintenance and rollback

After deploying the new frontend image and `/healthz` healthcheck, set `FRESHPRICE_MAINTENANCE=true` on the frontend service. In Swarm, a targeted update is:

```sh
docker service update --env-add FRESHPRICE_MAINTENANCE=true freshprice_frontend
```

This replaces the service task. The startup script enables the standalone maintenance page and API JSON 503 responses. Document responses carry 503, no-store and Retry-After. `/healthz` remains 200 so Swarm does not restart the service repeatedly. The independent Caddy fallback covers the task replacement gap once installed.

Restore service with:

```sh
docker service update --env-add FRESHPRICE_MAINTENANCE=false freshprice_frontend
```

Persist the same `FRESHPRICE_MAINTENANCE=true` or `false` value in the VPS `fpdocker/.env` when changing the service setting. The deployment workflow exports that key before stack rendering, so subsequent frontend/Sugilanon dispatches retain the intended state. An absent flag defaults to false. Verify `/healthz`, a public deep link and API readiness after restoration. Existing installed PWAs may retain the app shell during maintenance; API requests still return 503 and the in-app recovery UI handles them.

For release, push the fpdocker configuration before the normal app dispatch, as required by its deployment workflow. Deploy the additive backend readiness header and updated frontend image through the normal process. Do not enable the maintenance flag on an old image/healthcheck. Roll back a broken frontend deployment through the existing Swarm rollback procedure; remove the Caddy import and reload its backed-up configuration if the edge customization causes problems.

## Repeatable verification

Build the production frontend image from the workspace parent using the existing `frontend-prod` Dockerfile target and `VITE_API_BASE_URL=/api`. Run disposable instances on ports 5183 (normal) and 5184 (`FRESHPRICE_MAINTENANCE=true`), isolated from the application database/API. Run Caddy with the supplied snippet and static file, proxying to an intentionally unreachable upstream, on port 5185.

```sh
python3 fpdocker/tests/maintenance.py
cd fresh-price-front
npm run test:e2e:chromium -- --config=playwright.production.config.ts
```

The Python script accepts `--normal-url`, `--maintenance-url` and `--edge-url`; the production browser config accepts `PLAYWRIGHT_PRODUCTION_URL`. Use disposable local/staging instances for these checks. The normal proxy must have an unavailable API to exercise the JSON fallback.

Local verification: frontend lint/build, 240 unit tests; backend 128 unit tests; all 17 development Chromium flows (including budget/auth/wiki regressions); one production-build/service-worker Chromium flow; nginx/Caddy HTTP fallback checks. Production browser checks cover offline deep-link navigation, missing assets, JSON API failures and absence of cached API responses. No schema changes or database migration needed.

Remaining release gate: install/validate the snippet against the actual VPS Caddy site, run staging recovery checks, and deploy. Static SPA unknown document URLs intentionally return HTTP 200 with a not-found UI; route-aware document-level 404 status is outside this implementation.
