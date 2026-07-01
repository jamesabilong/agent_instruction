# FreshPrice Progress

## 2026-07-01

- Split FreshPrice documentation into `instructions/freshprice`.
- FreshPrice docs now cover frontend, backend, Docker deployment, API routes, and schema inventory separately from Sugilanon and portfolio docs.
- Previous investigation confirmed FreshPrice frontend and backend have active unit/E2E test structures.
- Backend API ownership relevant to FreshPrice is namespaced under `/api/platform` and `/api/freshprice`.
- Docker local development expects `platform-backend` as the canonical backend folder.

## Current State

- FreshPrice frontend: `fresh-price-front`.
- FreshPrice backend/API: `platform-backend`, especially `src/apps/freshprice` and shared platform routes.
- FreshPrice orchestration: `fpdocker`.
- Root workspace is not itself a git repository, so check git state inside the relevant subproject when needed.
