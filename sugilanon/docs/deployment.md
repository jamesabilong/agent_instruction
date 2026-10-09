# Sugilanon Deployment And Local Operations

Last investigated: 2026-07-02

## Local Development

Direct frontend development:

```sh
cd sugilanon
npm install
npm run dev
```

The local app defaults to `http://localhost:3000`.

Docker development through `fpdocker` also runs a `sugilanon` service:

```sh
cd fpdocker
task dev
task sugilanon
```

## Environment

Important variables:

- `SUGILANON_PORT=3000` for local development; use `3001` on the VPS when Caddy routes `philwatch.com` directly to Sugilanon.
- `SUGILANON_API_BASE_URL`
- `SUGILANON_SITE_URL`
- `CONTENT_API_BASE_URL=http://backend:4000/api`
- `NEXT_PUBLIC_API_BASE_URL`
- `NEXT_PUBLIC_SITE_URL`
- `SUGILANON_ALLOWED_DEV_ORIGINS`

## Production Notes

- Caddy terminates public TLS on ports `80` and `443` on the documented VPS setup; verify the live routing before changing it.
- The `fpdocker` repository builds `ghcr.io/jamesabilong/sugilanon:latest`, pushes it to GHCR, and updates `freshprice_sugilanon`.
- Sugilanon runs on `philwatch.com` in production. It does not run on
  `sugilanon.philwatch.com`; do not configure the Sugilanon site URL, API base
  URL, nginx host, or TLS certificate path for that subdomain unless the hosting
  plan changes.
- Sugilanon source pushes on either `main` or `master` trigger the `sugilanon-updated` repository dispatch for `fpdocker`; the dispatch includes the pushed ref and SHA so the Docker build checks out the same branch that triggered it.
- The production Sugilanon Docker image uses Next.js `output: "standalone"` and runs the generated `server.js` on port `3000`.
- The Docker health check uses `GET /health`, a dependency-free route. Do not point it at
  `/`, because that page renders data from the content API and can exceed the five-second
  health-check timeout even when the Next.js server is healthy.
- Production nginx config routes `philwatch.com` to the Sugilanon service.
- Production API traffic for Sugilanon should be proxied to the backend.
- Keep the no-store legacy `/sw.js` retirement endpoint available for returning devices. PhilWatch does not register a new offline worker. Release, targeted CDN purge and affected-device checks are in `cache-recovery-2026-10-09.md`.
- Before enabling `nginx.prod.ssl.conf`, ensure this certificate exists:
  `/etc/letsencrypt/live/philwatch.com/fullchain.pem`.

## Verification Checklist

- Run `npm run lint` from `sugilanon` after code changes.
- Run `npm run build` from `sugilanon` for production-sensitive changes.
- On the VPS, verify the service probe directly with `curl -fsS http://127.0.0.1:3001/health`.
- Backend content API changes should run relevant `platform-backend` tests.
