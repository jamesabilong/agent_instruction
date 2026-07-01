# FreshPrice Project Spec

Last investigated: 2026-07-01

## Summary

FreshPrice is a produce and market price tracking platform with public price browsing, admin price management, user budget tools, price submissions, and community discussion.

## Code Areas

| Path | Purpose | Stack |
| --- | --- | --- |
| `fresh-price-front` | FreshPrice public, user, auth, and admin SPA | React 19, TypeScript, Vite, Tailwind, Zustand, React Router, Vitest, Playwright |
| `platform-backend` | Shared API plus FreshPrice API modules | Node.js ESM, Express, Sequelize, PostgreSQL, JWT |
| `fpdocker` | Local and production orchestration for FreshPrice stack | Docker Compose, Dockerfiles, nginx, Task |

## Frontend Structure

- Entry points: `fresh-price-front/src/main.tsx`, `fresh-price-front/src/App.tsx`, and `src/router`.
- API services: `fresh-price-front/src/api`.
- Global state: `fresh-price-front/src/store`.
- Feature modules: `fresh-price-front/src/features`.
- Admin features: product, market, price, user, community moderation, and dashboards.
- User/public features: product listings, price history, public price trends, budgets, expenses, price submission, contact, auth, and community.
- Unit tests: `fresh-price-front/tests/unit`.
- E2E tests: `fresh-price-front/tests/e2e`.

## Backend Structure

- Server entry point: `platform-backend/src/server.js`.
- API router entry point: `platform-backend/src/api.js`.
- FreshPrice routes: `platform-backend/src/apps/freshprice/routes`.
- FreshPrice controllers: `platform-backend/src/apps/freshprice/controllers`.
- FreshPrice services: `platform-backend/src/apps/freshprice/services`.
- Shared platform routes used by FreshPrice: `platform-backend/src/routes`.
- Models: `platform-backend/src/models`.
- Migrations: `platform-backend/src/migrations`.

## Auth And Roles

- Backend auth uses JWT through `authenticateMarketPrice`.
- Operator/admin access is enforced by `requireOperatorRole`.
- Frontend treats `role === 1` as admin/operator and `role === 0` as regular user.
- Auth endpoints are under `/api/platform/auth`.

## Important Conventions

- Use `VITE_API_BASE_URL` in the frontend instead of hardcoded backend URLs.
- Keep frontend API behavior centralized through `fresh-price-front/src/api/client.ts`.
- FreshPrice API routes should stay under `/api/freshprice/*`.
- Shared auth/user/community APIs should stay under `/api/platform/*`.
- Use Sequelize migrations for schema changes.
- Removed legacy API aliases should not be reintroduced without a migration plan.
