# Portfolio Progress

## 2026-10-26

- Shared VPS Caddy upgraded from 2.6.2 to official signed 2.11.7 under explicit user maintenance authorization. Existing route/config preserved; direct origin HTTPS and public `jamesabilong.philwatch.com` title/status pass before and after. No portfolio source/image/deployment change. Protected rollback package/config/certificate storage and shared-stack backup/restore checks pass. [Maintenance](../../freshprice/docs/fp-66-caddy-maintenance-2026-10-26.md).

## 2026-09-06

- Renamed the portfolio project card from `Sugilanon / PhilWatch` to `PhilWatch` and linked it to `https://philwatch.com`.

## 2026-07-01

- Split portfolio documentation into `instructions/portfolio`.
- Documented React/Vite app structure, scripts, assets, and deployment locations separately from FreshPrice and Sugilanon docs.

## Current State

- Portfolio frontend lives in `jamesabilong`.
- Node engine requires `>=20.19.0`.
- Root workspace is not itself a git repository, so check git state inside the relevant subproject when needed.
