# FreshPrice Deployment And Local Operations

Last investigated: 2026-07-01

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
- Production deploys use:

```sh
cd fpdocker
docker stack deploy -c docker-compose.prod.yml freshprice
```

- Keep production PostgreSQL pinned to `postgres:14` unless a planned database upgrade is being performed.
- Do not use `task restart` for the VPS production stack while the production network driver is `overlay`.

## Verification Checklist

- Frontend normal change: `npm run lint`, `npm run test:unit`, `npm run build`.
- Frontend E2E/protected route change: also `npm run test:e2e:chromium`.
- Backend normal change: `npm run test`, or scoped `npm run test:unit` / `npm run test:integration`.
- Schema change: run migrations against a local database and add/update migration tests when practical.
