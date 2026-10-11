# FreshPrice Deployment And Local Operations

Last investigated: 2026-07-02

## Local Docker Development

Local orchestration is in `fpdocker`.

Expected services from `fpdocker/docker-compose.yml`:

- `frontend`: FreshPrice Vite app, default port `5173`.
- `backend`: platform backend, default port `4000`.
- `migrate`: one-shot Sequelize migration runner.
- `postgres`: PostgreSQL 14.
- `n8n`: workflow automation, default port `5678`.
- `sugilanon`: also present in the same Compose stack, but Sugilanon-specific docs live under `instructions/sugilanon`.

Typical flow:

```sh
cd fpdocker
task dev
```

Useful commands from `fpdocker`:

```sh
task dev:restart
task dev:logs
task ps
task backend
task frontend
task n8n
task migrate
task backend:cmd -- npm run test:unit
task frontend:cmd -- npm run test:unit
```

## Environment

Important local variables:

- `API_BASE_URL=/api`
- `VITE_API_BASE_URL=/api`
- `API_PROXY_TARGET=http://backend:4000`
- `BACKEND_PORT=4000`
- `FRONTEND_PORT=5173`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `DATABASE_URL`
- `JWT_SECRET`
- `ALLOWED_ORIGINS`
- `N8N_*`

Keep `N8N_ENCRYPTION_KEY` stable after creating credentials.

## Direct App Development

FreshPrice frontend:

```sh
cd fresh-price-front
npm install
npm run dev
```

Platform backend:

```sh
cd platform-backend
npm install
npx sequelize-cli db:migrate
npm run dev
```

## Production Notes

- Production Docker files and nginx configs live under `fpdocker`.
- `fresh-price-front` pushes to `master` dispatch `frontend-updated` to `jamesabilong/fpdocker`.
- `platform-backend` pushes to `master` dispatch `backend-updated` to `jamesabilong/fpdocker`.
- The `fpdocker` repository handles the image build, GHCR push, VPS SSH deploy, and targeted service update for the dispatched app.
- Backend production images include `sequelize-cli` and `.sequelizerc` so VPS migrations run from bundled image files instead of downloading tooling with `npx`.
- Backend-only dispatches bootstrap the stack only when the Swarm network or `freshprice_backend` service is missing; otherwise they run migrations and update `freshprice_backend` directly.
- On the current VPS, Caddy owns public ports `80` and `443`; the FreshPrice frontend container should serve HTTP on a non-public host port such as `8081`.
- Route `freshprice.philwatch.com` through Caddy to the frontend HTTP port. For `philwatch.com`, either use the frontend nginx host routing or the documented direct Sugilanon port `3001`; verify the active Caddy configuration before choosing a path.
- The production frontend nginx config also routes `philwatch.com` to the Sugilanon service in the shared Swarm stack. Sugilanon is not intended to run on `sugilanon.philwatch.com`.
- Production deploys use Docker Swarm:

```sh
cd fpdocker
docker stack deploy -c docker-compose.prod.yml freshprice
```

- Direct `fpdocker` pushes do not trigger the production deploy workflow unless a separate `repository_dispatch` event is sent.

- For backend releases, run Sequelize migrations with the newly pulled backend
  image before forcing `freshprice_backend` onto that image. If the Swarm network
  does not exist yet, create the stack first, then run migrations, then force the
  backend service update.
- Keep production PostgreSQL pinned to `postgres:14` unless a planned database upgrade is being performed.
- Do not use `task restart` for the VPS production stack while the production network driver is `overlay`.
- Keep `/assets/` content-hashed files immutable, but serve `/sw.js` with
  `Cache-Control: no-store` and matching CDN cache-control headers. A cached
  service worker can continue serving an obsolete application shell on devices
  that visited FreshPrice before a release.
- When `fpdocker` nginx files change, push `fpdocker` `master` before triggering
  the frontend deployment so the frontend image is built with the new config.
- After deploying a service-worker cache fix, purge the exact Cloudflare URLs
  `https://freshprice.philwatch.com/sw.js` and
  `https://freshprice.philwatch.com/manifest.webmanifest`. Verify `/sw.js` no
  longer returns a positive `max-age` before testing on a previously affected
  device.
- The October 9 production check still found four-hour FreshPrice worker caching. Both nginx variants now have locally verified exact worker/manifest locations. Coordinate the frontend image rebuild with PhilWatch's separate legacy-worker retirement release; see `instructions/sugilanon/docs/cache-recovery-2026-10-09.md` for evidence, targeted URL purges and affected-device verification.

## Verification Checklist

- Frontend normal change: `npm run lint`, `npm run test:unit`, `npm run build`.
- Frontend E2E/protected route change: also `npm run test:e2e:chromium`.
- Backend normal change: `npm run test`, or scoped `npm run test:unit` / `npm run test:integration`.
- Schema change: run migrations against a local database and add/update migration tests when practical.


## FP-43 maintenance and recovery (2026-10-02)

The frontend now uses `/healthz` for container readiness and supports `FRESHPRICE_MAINTENANCE=true`. See `fp-43-recovery-runbook.md` for the independent Caddy fallback, targeted enable/disable commands, validation and rollback. These changes have been verified locally and are not deployed.

The deployment workflow now exports `FRESHPRICE_MAINTENANCE` from the VPS `.env` before rendering the Swarm stack (2026-10-11 fix). Persist `true` or `false` there when changing the frontend service setting so later frontend/Sugilanon dispatches retain the intended state. An absent flag defaults to false. Verify the parser without a daemon or production access with `node --test fpdocker/tests/deploy-maintenance.test.mjs`; on Windows set `DEPLOY_TEST_SHELL` to the Git Bash executable. The regression executes the workflow's actual parser and renders synthetic enabled, disabled and default settings through `docker stack config`.
