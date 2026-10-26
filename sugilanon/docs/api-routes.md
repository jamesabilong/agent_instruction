# Sugilanon API Routes Investigation

Last investigated: 2026-07-01

Sugilanon routes are mounted at `/api/sugilanon`. `/api/content` is a deprecated compatibility alias that sets `Deprecation: true`.

## Public Routes

- `GET /status`
- `GET /articles`
- `GET /articles/:slug`
- `GET /categories`
- `GET /earthquakes/latest`
- `GET /categories/:slug/articles`
- `GET /search`

## Admin Routes

Admin routes require platform auth and operator role.

- `GET /admin/dashboard`
- `GET /admin/government-sources`
- `GET /admin/source-drafts`
- `POST /admin/source-scan`
- `PATCH /admin/source-drafts/:id/ignore`
- `POST /admin/source-drafts/:id/convert`
- `POST /admin/categories`
- `GET /admin/articles`
- `GET /admin/articles/:id`
- `POST /admin/articles`
- `PUT /admin/articles/:id`
- `DELETE /admin/articles/:id`
- `PATCH /admin/articles/:id/publish`
- `PATCH /admin/articles/:id/unpublish`

## Content Tables

- `content_articles`
- `content_categories`
- `content_tags`
- `content_article_tags`
- `content_media`
- `content_sources`
- `content_source_drafts`

## Search correction (deployed, 2026-10-26)

Nonempty `/api/sugilanon/search?q=...`, `/articles?q=...` and category article queries retain their public paginated contracts. The deployed backend correction removes invalid joined-alias references from article pagination and prevents category filters leaking between requests. All 46 DB/271 unit checks pass; backend PR #61 is merged/deployed and both public query paths/internal reader pass. [Fix/evidence](content-search-fix-2026-10-26.md). Exemptions remain disabled.

## Deployed pagination tie correction — 2026-10-26

Public/admin article and source-draft pages have a final-ID ordering tie-breaker deployed through backend PR #62. Database-backed tied-page tests, exact shipped source/digest and read-only production comparisons pass. The earlier nonempty-query search fix remains intact. [Shared release](../../freshprice/docs/backend-pagination-deployment-2026-10-26.md).
