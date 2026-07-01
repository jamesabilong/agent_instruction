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
