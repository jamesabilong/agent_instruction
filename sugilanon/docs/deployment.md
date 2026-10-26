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


## FP-66 deployed shared identity — 2026-10-26

[Release/commands/evidence](../../freshprice/docs/fp-66-deployment-2026-10-26.md): PhilWatch #2 is deployed after the compatible backend/migration 42 and before FreshPrice frontend. Caddy 2.11.7 authenticates visitor assertions on the existing port-3001 route; Next browser rewrites preserve those assertions to `freshprice_backend:4000`. Server-only public-content reads use a distinct CONTENT_INTERNAL_API_KEY and cannot access auth/admin GETs; no edge or DB/auth credentials are provided to PhilWatch. Real keys are absent from browser chunks/SSR HTML. Exemptions stay false with zero rules/audits.

Root-protected `/etc/freshprice/fp66-runtime.env` supplies the allowlisted runtime parser; keep new keys out of the shared Compose `.env` inherited by PostgreSQL. Only the content-reader credential enters PhilWatch's explicit environment. Maintain targeted service/file consistency and preserve Caddy's separate protected service environment/drop-in, TLS/maintenance and www redirect. Both real public-client paths and direct-origin spoof resistance pass; final shared DB identity/volume/connectivity/guard and protected migration-42 backup/full isolated restore pass.

The separate nonempty search 500 is [fixed and deployed in backend PR #61](content-search-fix-2026-10-26.md), with 46 DB/271 unit checks and actual public/internal nonempty query checks passing. Empty-query search/article/category reads pass; production has no published articles/categories, so existing detail smoke is unavailable. The confirmed Sequelize pagination alias cause and escaped correlated EXISTS/include-cloning repair are documented in that release. Live mutation-denial POST was omitted after automatic approval rejection; prior isolated coverage is retained. See the release record for all accepted historical recovery/device limits and the historical search finding now resolved by the subsequent verified release.

## Backend pagination release — 2026-10-26

Backend PR #62 is reviewed/merged/deployed as `51784fa1`; actual running digest/source match, 51 public GET checks and read-only list/SQL comparisons pass. Other images/service specs, protected Caddy/app runtime, 42 migrations, DB identity/volume/connectivity and PostgreSQL guard are preserved. Exemptions stay disabled with zero rules/audits. Sparse live inventory limits populated edge checks; 16 actual PostgreSQL regressions and 62 integration/271 unit checks cover those cases. [Release/digest/evidence](../../freshprice/docs/backend-pagination-deployment-2026-10-26.md).
