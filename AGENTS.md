# Agent Instructions

These instructions route automated and AI-assisted work to the right app-specific context. The goal is to avoid loading FreshPrice, Sugilanon, and portfolio details together unless a task actually crosses those boundaries.

## Required Start/Finish Ritual

Before making changes:

1. Read this file.
2. Identify the affected app or apps.
3. Read only the matching app docs and progress file listed below.
4. Also read any app-local instruction file in the target code folder.

After finishing:

1. Update the matching app's `memory-bank/progress.md`.
2. Update the matching app's `memory-bank/todo.md`.
3. Update the matching app's `memory-bank/bugs.md` if you confirm a reproducible bug or unresolved risk.

If the work affects multiple apps, repeat the read/update steps for each affected app.

## App Routing

### FreshPrice

Production topology confirmed by the user on 2026-10-20:

- Public application: `https://freshprice.philwatch.com`.
- Operator SSH target: `root@107.174.250.249`. Use existing SSH authentication; never store passwords, private keys or database credentials in these instructions.
- The current operator uses password login; the available local key was rejected. Have the user enter the password directly in the terminal. A user-authenticated terminal is readable by the agent but is not an authenticated session for separate command-tool SSH processes.
- One VPS runs both the production app and its PostgreSQL database. There is no separate staging environment.
- Do not treat the public production URL as a staging target. Perform migration/restore rehearsals only in an isolated disposable local database or another explicitly designated non-production target. Disable outbound integrations in a restored copy and keep dumps/credentials out of source control and reports.
- Label synthetic-fixture checks separately from checks on a restored production backup. Public health responses do not verify app revisions, migration inventory, backups or restore readiness.
- A readiness check does not authorize merging, deploying, production migration, service restart or configuration changes. Production inventory stays read-only unless the user explicitly requests an operation; never restore into the production database as a rehearsal.

Use this section for:

- `fresh-price-front`
- `platform-backend` FreshPrice APIs, shared auth/user/community/upload/notification APIs used by FreshPrice, Sequelize models, migrations, tests
- `fpdocker` when the change affects FreshPrice local or production deployment

Read before changes:

- `instructions/freshprice/docs/project-spec.md`
- `instructions/freshprice/memory-bank/progress.md`
- Relevant local instructions such as `fresh-price-front/AGENTS.md` or `fpdocker/AGENTS.md`

Update after changes:

- `instructions/freshprice/memory-bank/progress.md`
- `instructions/freshprice/memory-bank/todo.md`

Keep current when relevant:

- `instructions/freshprice/docs/api-routes.md`
- `instructions/freshprice/docs/database-schema.md`
- `instructions/freshprice/docs/deployment.md`
- `instructions/freshprice/memory-bank/bugs.md`

### Sugilanon

Use this section for:

- `sugilanon`
- `platform-backend/src/apps/sugilanon`
- Sugilanon content routes, content models, source scanning, and Sugilanon deploy settings

Read before changes:

- `instructions/sugilanon/docs/project-spec.md`
- `instructions/sugilanon/memory-bank/progress.md`
- `sugilanon/AGENTS.md`

Update after changes:

- `instructions/sugilanon/memory-bank/progress.md`
- `instructions/sugilanon/memory-bank/todo.md`

Keep current when relevant:

- `instructions/sugilanon/docs/api-routes.md`
- `instructions/sugilanon/docs/deployment.md`
- `instructions/sugilanon/memory-bank/bugs.md`

### Portfolio

Use this section for:

- `jamesabilong`
- Portfolio content, routing, styles, deployment, and resume/assets

Read before changes:

- `instructions/portfolio/docs/project-spec.md`
- `instructions/portfolio/memory-bank/progress.md`

Update after changes:

- `instructions/portfolio/memory-bank/progress.md`
- `instructions/portfolio/memory-bank/todo.md`

Keep current when relevant:

- `instructions/portfolio/docs/deployment.md`
- `instructions/portfolio/memory-bank/bugs.md`

## Shared Rules

- The workspace root is not a git repository. Check git state inside the relevant subproject when needed.
- Preserve app boundaries. Do not change another app just because it is nearby unless the task requires it.
- Do not stage, commit, or push unless the user explicitly asks.
- Keep memory-bank entries brief and dated.

## Documentation Maintenance

- Treat each app's current `memory-bank/progress.md`, `todo.md` and `bugs.md` as the current-state summary. Consolidate superseded checklist entries instead of appending contradictory pending/complete claims indefinitely.
- Preserve old evidence and decisions in dated docs or `memory-bank/archive/`; mark archived status as historical. Read [README.md](README.md) for the current release index and local-only asset boundaries.
- Keep tests, executable synthetic fixture seeders, generated output, certificates and private runtime snapshots in their designated local/protected locations. Only sanitized release evidence and reviewed operator utilities belong in this repository.
- Verify the actual PR base before handing off a release. Merging a prerequisite feature branch does not retarget dependent PRs; production app PRs must target master when that is the intended release. Preserve backend-before-frontend ordering and verify each deployment.

## Production Deployment Triggers

- `fresh-price-front` pushes to `master` dispatch `frontend-updated` to `jamesabilong/fpdocker`.
- `platform-backend` pushes to `master` dispatch `backend-updated` to `jamesabilong/fpdocker`.
- `sugilanon` pushes to `main` or `master` dispatch `sugilanon-updated` to `jamesabilong/fpdocker` with the pushed ref.
- `fpdocker` itself deploys from `repository_dispatch` events, not direct push. When Docker, Compose, nginx, or deploy workflow files change, push `fpdocker` `master` first so the VPS deploy step can `git pull --ff-only origin master` before the next app dispatch.
- Manual dispatches use GitHub's repository dispatch API against `https://api.github.com/repos/jamesabilong/fpdocker/dispatches` with one of the event types above. Use a token with permission to dispatch workflows in `jamesabilong/fpdocker`.

## FP-66 production identity contract (2026-10-26)

- [Current release and verified limits](freshprice/docs/fp-66-deployment-2026-10-26.md) is the deployed baseline. Historical publication/readiness records do not describe current PR/runtime state.
- Keep AUTH_TEST_EXEMPTIONS_ENABLED=false under the current user instruction; deployment verification must never create a live exemption. Any later enablement requires separate explicit authorization.
- Keep the four allowlisted FP-66 settings in root-protected `/etc/freshprice/fp66-runtime.env`, using the deploy workflow parser. Never put the two new credentials in shared Compose `.env`, which PostgreSQL inherits. Backend receives both; PhilWatch receives only its distinct restricted content-reader key; frontend/PostgreSQL receive neither. Do not source production env files in a shell.
- Caddy's matching assertion key and reviewed official public CIDRs are separately protected in `/etc/caddy/fp66-runtime.env` via its systemd drop-in. Validate complete config with its protected process environment, compare/preserve unrelated TLS/maintenance routes, and restart only when authorized to ingest changed environment. Never print/export the adapted config or runtime/service env.
- Image-only backend deployment does not reconcile new environment; keep targeted service updates and the protected runtime file consistent. Future manual stack deployment must use the same allowlisted parser. Preserve disabled exemptions during socket-mode recovery; never widen CIDR/header trust as a shortcut.
- Verify exact running images, migration inventory, database identity/volume/connectivity, guard, both actual proxy/SSR paths and two independent real clients after identity changes. Page 200 is insufficient search evidence: the earlier PhilWatch SSR helper swallowed the search query error as empty results. The [search fix](sugilanon/docs/content-search-fix-2026-10-26.md) is merged/deployed in backend PR #61, with 46 DB/271 unit checks and actual public/internal nonempty query verification passing. Keep tests outside app repositories; the existing full local database command discovers the new search regression. Preserve article-level pagination/full associations and clone per-call includes when adding filters; search predicates must not reference outer join aliases inside a paginated subquery.

## Backend query review (2026-10-26)

- [Pagination release](freshprice/docs/backend-pagination-deployment-2026-10-26.md) is merged/deployed in backend PR #62 with verified source/image, 51 public GET checks and read-only database/service comparisons. The [original audit](freshprice/docs/backend-pagination-audit-2026-10-26.md) is a historical local checkpoint. Keep exemptions disabled and preserve the documented sparse-inventory/offset-pagination limits.
- Rank/filter the eligible base rows before LIMIT/OFFSET. Avoid sorting only an already fetched page. Select computed ranking aliases when Sequelize must order both its inner page and outer association hydration.
- Use an existence predicate to select base rows by a many-to-many tag without truncating the association returned to clients. Preserve distinct base-row counts, all public tags and role/owner visibility. Never disable subqueries blindly to avoid an alias error.
- End paginated orders with a unique key. Regression fixtures should tie timestamps/primary sort values and include multiple children/units; ordinary updates can expose otherwise incidental heap/index order. A unique order does not create a cross-request snapshot under concurrent writes.
- Keep real PostgreSQL regressions in external `testing/`; the full existing backend database command discovers the new community/order suites. Review source/tests and update sanitized evidence before publication; do not publish synthetic fixture executables or private runtime material in instructions.

## Browser verification scope (2026-10-26)

- [Production browser results and limits](freshprice/docs/browser-verification-2026-10-26.md): public community sorts, prices empty-state pagination/search, both Rice trend views, nonempty PhilWatch form/API search and anonymous admin redirect passed in Chromium with zero observed console errors/warnings. Sparse inventory prevents populated multi-page/ranking/tag/article/price browser claims; isolated database regressions cover those query cases. Authenticated mutations, cross-browser/device/PWA recovery and fresh host/exemption counts were not tested by this pass. Keep exemptions disabled; never fill coverage gaps with live fixtures or exemptions without explicit authorization.

- [Isolated populated follow-up](freshprice/docs/populated-browser-verification-2026-10-26.md) closes synthetic browser ranking/tag/tied-page and populated search/detail gaps on released source trees, with exemptions disabled/local rules and audits 0/0. Preserve two confirmed open UI limits: PhilWatch search lacks pagination controls; price search filters the current page only. Browser fetches verify later search/history API pages, not nonexistent UI navigation. Retain the observed Next development image-priority warning and production/authenticated/device coverage limits. No production fixture or setting changed.
