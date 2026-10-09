# FP-64 pre-merge review — 2026-10-09

Reviewed the complete branch diffs against freshly fetched `origin/master`:

| Repository | FP-64 head | Master base |
| --- | --- | --- |
| fresh-price-front | `5a5d58ee` | `a44c812f` |
| platform-backend | `56d4142` | `4805345` |
| fpdocker | `a459648` | `85d6e44` |

Each local head matched `origin/FP-64`. Application working trees were clean at the start and end. No open FP-64 pull request was returned by the repository queries. No application fix, merge, commit, push, deployment, or Jira write was performed during this review.

## Findings to resolve before release

1. **P2 — Budget writes can complete in a later account session.** `fresh-price-front/src/store/budgetStore.ts:109` awaits post-save hydration after its final generation check. If account A's write is confirmed, hydration is delayed, and the user switches to account B, hydration discards A's data correctly but the old write promise still resolves successfully. Existing form success callbacks can then change shared preferences or navigate in B's session; the expense form also has a subsequent price-submission side effect. Add a generation check after the awaited hydration and a regression covering this timing window. Do not undo the already committed server write.

   Reproduction: mock a successful expense create and a delayed `fetchBudget`; start `addExpense`, wait for hydration to start, switch the auth token/user, then release hydration. An assertion that the write rejects with the existing session-change error fails with `promise resolved undefined instead of rejecting`. Temporary test source is preserved at `/private/tmp/fp64-review-evidence/post-save-session.test.ts`; it was removed from the normal suite after reproducing the issue.

2. **P2 — Deployments ignore the persisted maintenance flag.** `fpdocker/docker-compose.prod.yml:91` reads `FRESHPRICE_MAINTENANCE` from the deployment process environment, but `.github/workflows/deploy.yml:125-129` does not export that key from the VPS `.env`. Frontend and Sugilanon dispatches run `docker stack deploy`, which can reset an enabled maintenance service to false even when `.env` says true. Add the flag to the explicit deployment-key parser and verify both states through the actual stack-config path. Keep the documented `.env`/service state consistent.

   Reproduction: copied the production Compose file into a temporary directory with a synthetic `.env` containing `FRESHPRICE_MAINTENANCE=true`; ran the workflow's exact parser/export block and `docker stack config`. The **frontend** service rendered `FRESHPRICE_MAINTENANCE: "false"`. This reproduction requires no real credentials or production connection.

## Verification

- Frontend lint and production build pass; 240 unit tests pass.
- All 17 existing Chromium flows pass, covering budgets, wiki/recipes, recovery, public prices and admin routes. These fixtures do not cover the newly reproduced account-switch window.
- Backend: 128 unit tests pass. All migrations apply to disposable PostgreSQL 14; 30 integration checks pass with both database gates enabled, including allocation concurrency, keyed retries, 201-expense totals, removed-member access and recipe/moderation persistence.
- Wiki population: created 130 pages from all catalogue identities in the disposable database; no page lacked a linked first revision; a second population run created zero additional pages.
- Restored nginx worker/manifest cache rules were already verified earlier on October 9 with HTTP/TLS and maintenance regressions and are unchanged at the reviewed Docker head.

## Release requirements

- Publish/merge Docker configuration before app dispatches. Release the backend and complete its additive migrations before releasing the new frontend contracts.
- Backend migration `20260912000002-populate-product-wiki-catalogue.cjs` publishes starter content for matching products that have no wiki page. Existing pages, including drafts, are preserved. This is a content-publication consequence of the backend merge/deploy, not merely a schema migration.
- Install and validate the independent Caddy fallback on the actual VPS; merging Docker files does not install the host snippet.
- PhilWatch's legacy-worker retirement is a separate Sugilanon change (`b15da39`), and worker/manifest URLs need the targeted Cloudflare purge described in the cache recovery runbook.
- Production/staging deployment and the affected user's browser registration remain unverified. Passing local checks do not close those operational gates.
