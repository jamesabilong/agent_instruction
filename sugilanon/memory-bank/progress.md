# Sugilanon Progress

## 2026-07-01

- Split Sugilanon documentation into `instructions/sugilanon`.
- Documented Next.js frontend shape, content API routes, content models, and deployment notes separately from FreshPrice and portfolio docs.

## Current State

- Sugilanon frontend lives in `sugilanon`.
- Sugilanon backend content APIs live under `platform-backend/src/apps/sugilanon`.
- Public routes are mounted under `/api/sugilanon`; `/api/content` is deprecated.
- Root workspace is not itself a git repository, so check git state inside the relevant subproject when needed.
