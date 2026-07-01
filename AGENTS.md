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

Use this section for:

- `fresh-price-front`
- `platform-backend` FreshPrice APIs, shared auth/user/community APIs used by FreshPrice, Sequelize models, migrations, tests
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
