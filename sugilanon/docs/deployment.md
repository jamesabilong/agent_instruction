# Sugilanon Deployment And Local Operations

Last investigated: 2026-07-01

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

- `SUGILANON_PORT=3000`
- `SUGILANON_API_BASE_URL`
- `SUGILANON_SITE_URL`
- `CONTENT_API_BASE_URL=http://backend:4000/api`
- `NEXT_PUBLIC_API_BASE_URL`
- `NEXT_PUBLIC_SITE_URL`
- `SUGILANON_ALLOWED_DEV_ORIGINS`

## Production Notes

- Production nginx config routes `philwatch.com` to the Sugilanon service.
- Production API traffic for Sugilanon should be proxied to the backend.
- On the current VPS, Caddy owns public ports `80` and `443` and should terminate TLS for `philwatch.com`.
- Pushes to the `sugilanon` repository `main` branch dispatch `sugilanon-updated` to `jamesabilong/fpdocker`.
- The `fpdocker` repository builds `ghcr.io/jamesabilong/sugilanon:latest`, pushes it to GHCR, and updates `freshprice_sugilanon` on the VPS.

## Verification Checklist

- Run `npm run lint` from `sugilanon` after code changes.
- Run `npm run build` from `sugilanon` for production-sensitive changes.
- Backend content API changes should run relevant `platform-backend` tests.
