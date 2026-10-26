# Sugilanon Project Spec

Last investigated: 2026-07-01; FP-66 release updated 2026-10-26.

FP-66 is deployed: PhilWatch #2, shared backend/schema and FreshPrice/Docker counterparts merged in verified order. Browser rewrites preserve Caddy authenticated visitor assertions; server-only public content uses a distinct restricted credential. Two independent public clients, direct-origin checks, scoped credential privacy, migration 42/shared service/DB/guard and post-release backup/full isolated restore pass. Exemptions remain false with zero rules/audits. Nonempty-query search is [fixed and deployed](content-search-fix-2026-10-26.md) through backend PR #61: 46 DB/271 unit checks and both actual public paths/internal reader pass. Production inventory is empty, so existing article-detail smoke is unavailable. [Release/evidence/limits](../../freshprice/docs/fp-66-deployment-2026-10-26.md), [policy](../../freshprice/docs/fp-66-controls-2026-10-23.md).

October 26 backend follow-up: [pagination PR #62 is deployed and verified](../../freshprice/docs/backend-pagination-deployment-2026-10-26.md), preserving the earlier search fix and disabled exemptions. Community ranking/tag hydration and deterministic content/source/price pages are corrected; live inventory limitations remain explicit.

## Summary

Sugilanon/PhilWatch is a content/news site with public article browsing and admin content management. It has a Next.js frontend in `sugilanon` and content APIs in `platform-backend/src/apps/sugilanon`.

## Code Areas

| Path | Purpose | Stack |
| --- | --- | --- |
| `sugilanon` | Sugilanon/PhilWatch frontend and admin pages | Next.js 16, React 19, TypeScript, Tailwind |
| `platform-backend/src/apps/sugilanon` | Content/news API, government source scanning, content controllers/services | Express, Sequelize |
| `platform-backend/src/models/content*` | Content schema | Sequelize, PostgreSQL |
| `fpdocker` | Local/prod service wiring for Sugilanon | Docker Compose, nginx |

## Frontend Structure

- App Router pages live under `sugilanon/src/app`.
- Shared article API helpers live under `sugilanon/src/lib`.
- Article types live under `sugilanon/src/types`.
- UI components live under `sugilanon/src/components`.
- Admin pages include login, dashboard, source inbox, new article, and edit article screens.

## Backend Structure

- Main routes: `platform-backend/src/apps/sugilanon/routes/contentRoutes.js`.
- Controllers: `platform-backend/src/apps/sugilanon/controllers/contentController.js`.
- Services: `platform-backend/src/apps/sugilanon/services`.
- Content models include articles, categories, tags, media, sources, and source drafts.

## Important Conventions

- `sugilanon/AGENTS.md` warns that this is Next.js 16 with breaking changes; read relevant local Next docs before editing framework-sensitive code.
- Public content APIs are mounted under `/api/sugilanon`.
- `/api/content` exists only as a deprecated compatibility alias.
- Admin content routes require normal platform auth and operator role.
