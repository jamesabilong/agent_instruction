# FreshPrice Deployment And Local Operations

Last deployment verification: 2026-10-21. [Final FP-61 release record](fp61-deployment-2026-10-21.md).

VPS deployment verification added: 2026-10-12

## Confirmed production topology — 2026-10-20

October 21 security update: Docker PR #25 is merged and deployed; production PostgreSQL has no published host port. The independent `freshprice-postgres-guard.service` nftables guard remains enabled/active on eth0 TCP 5432; private DB access and both apps' health pass. The initial firewall installation did not restart Docker/DB; subsequent app stack reconciliation changed the PostgreSQL task while preserving the original data volume/DB identity. Keep the guard enabled and recheck coverage if networking changes. See [security execution and recovery](postgres-security-2026-10-21.md).

The user confirmed a single VPS at `root@107.174.250.249`, serving `https://freshprice.philwatch.com`, with the production application and PostgreSQL on the same host. There is no separate staging environment. Use existing SSH keys or an authenticated operator session; do not copy credentials into documentation or evidence.

Current operator access uses username/password. The local default key is not authorized. The operator can stream a reviewed local script over SSH from PowerShell and enter the password directly in the terminal; strip carriage returns before Bash when streaming from Windows PowerShell, for example `ssh ... "tr -d '\r' | bash -s -- /var/projects/freshprice/fpdocker"`. Do not assume that a manually authenticated SSH terminal grants access to another process.

Pre-merge verification must distinguish read-only inspection of this production host from an isolated migration/restore rehearsal. Restore an approved backup only into a disposable non-production target with outbound integrations disabled. Synthetic fixtures can exercise migration and contract behavior, but do not prove that the actual production backup restores. Preserve production data, deployed services and installed clients throughout preflight. The sprint-337 request authorizes checks and instruction updates; the user will handle merging/deployment.

## Local Docker Development

Local orchestration is in `fpdocker`.

Expected services from `fpdocker/docker-compose.yml`:

- `frontend`: FreshPrice Vite app, default port `5173`.
- `backend`: platform backend, default port `4000`.
- `migrate`: one-shot Sequelize migration runner.
- `postgres`: PostgreSQL 14.
- `n8n`: workflow automation, default port `5678`.
- `sugilanon`: also present in the same Compose stack, but Sugilanon-specific docs live under `instructions/sugilanon`.

Typical flow:

```sh
cd fpdocker
task dev
```

Useful commands from `fpdocker`:

```sh
task dev:restart
task dev:logs
task ps
task backend
task frontend
task n8n
task migrate
task backend:cmd -- npm run test:unit
task frontend:cmd -- npm run test:unit
```

## Environment

FP-59 lifecycle rollout (2026-10-19, local implementation): apply all three October 19 migrations (roles, lifecycle, inviter preservation) before the new backend, then release the frontend. Automatic monthly generation runs on backend startup and hourly; `FRESHPRICE_RECURRING_BUDGETS=false` disables the timer (manual creator-authorized generation remains available). `NODE_ENV=test` always disables the timer. Template row locks and unique period keys support multiple backend instances. Sweeps page through all due IDs, so a failed page cannot block later work. The inviter-preservation migration prevents former-owner deletion from revoking other members; retain its nullable SET NULL FK on rollback. Preserve the additive schema on application rollback; lifecycle down refuses nonempty lifecycle tables, and role-unaware backends must not serve viewer memberships. Verify recipient acceptance, stale owner controls, private generated budgets and pause/cancel on staging before release. See `fp-59-lifecycle-2026-10-19.md`.

Important local variables:

- `API_BASE_URL=/api`
- `VITE_API_BASE_URL=/api`
- `API_PROXY_TARGET=http://backend:4000`
- `BACKEND_PORT=4000`
- `FRONTEND_PORT=5173`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_DB`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `DATABASE_URL`
- `JWT_SECRET`
- `ALLOWED_ORIGINS`
- `N8N_*`

Keep `N8N_ENCRYPTION_KEY` stable after creating credentials.

## Direct App Development

FreshPrice frontend:

```sh
cd fresh-price-front
npm install
npm run dev
```

Platform backend:

```sh
cd platform-backend
npm install
npx sequelize-cli db:migrate
npm run dev
```

## Production Notes

- Production Docker files and nginx configs live under `fpdocker`.
- `fresh-price-front` pushes to `master` dispatch `frontend-updated` to `jamesabilong/fpdocker`.
- `platform-backend` pushes to `master` dispatch `backend-updated` to `jamesabilong/fpdocker`.
- The `fpdocker` repository handles the image build, GHCR push, VPS SSH deploy, and targeted service update for the dispatched app.
- Backend production images include `sequelize-cli` and `.sequelizerc` so VPS migrations run from bundled image files instead of downloading tooling with `npx`.
- Backend-only dispatches bootstrap the stack only when the Swarm network or `freshprice_backend` service is missing; otherwise they run migrations and update `freshprice_backend` directly.
- On the current VPS, Caddy owns public ports `80` and `443`; the FreshPrice frontend container should serve HTTP on a non-public host port such as `8081`.
- Route `freshprice.philwatch.com` through Caddy to the frontend HTTP port. For `philwatch.com`, either use the frontend nginx host routing or the documented direct Sugilanon port `3001`; verify the active Caddy configuration before choosing a path.
- The production frontend nginx config also routes `philwatch.com` to the Sugilanon service in the shared Swarm stack. Sugilanon is not intended to run on `sugilanon.philwatch.com`.
- Production deploys use Docker Swarm:

```sh
cd fpdocker
docker stack deploy -c docker-compose.prod.yml freshprice
```

- Direct `fpdocker` pushes do not trigger the production deploy workflow unless a separate `repository_dispatch` event is sent.

- For backend releases, run Sequelize migrations with the newly pulled backend
  image before forcing `freshprice_backend` onto that image. If the Swarm network
  does not exist yet, create the stack first, then run migrations, then force the
  backend service update.
- Keep production PostgreSQL pinned to `postgres:14` unless a planned database upgrade is being performed.
- Do not use `task restart` for the VPS production stack while the production network driver is `overlay`.
- Keep `/assets/` content-hashed files immutable, but serve `/sw.js` with
  `Cache-Control: no-store` and matching CDN cache-control headers. A cached
  service worker can continue serving an obsolete application shell on devices
  that visited FreshPrice before a release.
- When `fpdocker` nginx files change, push `fpdocker` `master` before triggering
  the frontend deployment so the frontend image is built with the new config.
- After deploying a service-worker cache fix, purge the exact Cloudflare URLs
  `https://freshprice.philwatch.com/sw.js` and
  `https://freshprice.philwatch.com/manifest.webmanifest`. Verify `/sw.js` no
  longer returns a positive `max-age` before testing on a previously affected
  device.
- The October 9 production check still found four-hour FreshPrice worker caching. Both nginx variants now have locally verified exact worker/manifest locations. Coordinate the frontend image rebuild with PhilWatch's separate legacy-worker retirement release; see `instructions/sugilanon/docs/cache-recovery-2026-10-09.md` for evidence, targeted URL purges and affected-device verification.

## Verify deployment on the VPS

Wait for **fpdocker → Build and Deploy** to finish, then SSH into the Swarm manager on the single-node VPS and paste this read-only command. It requires Bash, Docker access and curl. It does not restart services, apply migrations or read/source the VPS `.env`.

Use `DEPLOY_CHECK_PHASE=backend` after the backend deploy, before merging the frontend. Use `DEPLOY_CHECK_PHASE=full` after the frontend deploy and targeted Cloudflare purge. The full check expects normal traffic with maintenance disabled.

```bash
DEPLOY_CHECK_PHASE=full bash <<'CHECK'
set -euo pipefail
cd /var/projects/freshprice/fpdocker

case "${DEPLOY_CHECK_PHASE:-full}" in
  backend) deployment_services=(freshprice_backend) ;;
  full) deployment_services=(freshprice_backend freshprice_frontend) ;;
  *) printf 'Use DEPLOY_CHECK_PHASE=backend or full\n' >&2; exit 1 ;;
esac

docker stack services freshprice
for deployment_service in "${deployment_services[@]}"; do
  docker service inspect "$deployment_service" --format \
    '{{.Spec.Name}} image={{.Spec.TaskTemplate.ContainerSpec.Image}} update={{if .UpdateStatus}}{{.UpdateStatus.State}}{{else}}none{{end}}'
  docker service ps "$deployment_service" --no-trunc
done
docker ps --filter label=com.docker.stack.namespace=freshprice \
  --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'

# Inspect migration status in the running release; db:migrate:status is read-only.
deployment_backend="$(docker ps -q --filter label=com.docker.swarm.service.name=freshprice_backend)"
if [[ -z "$deployment_backend" || "$deployment_backend" == *$'\n'* ]]; then
  printf 'Expected one active backend container; wait for rollout convergence and retry.\n' >&2
  exit 1
fi
docker exec "$deployment_backend" ./node_modules/.bin/sequelize-cli db:migrate:status

curl --fail --silent --show-error --connect-timeout 5 --max-time 20 \
  -H 'Cache-Control: no-cache' \
  "https://freshprice.philwatch.com/api/platform/db/health?_deploy_check=$(date +%s)"
printf '\n'

if [[ "${DEPLOY_CHECK_PHASE:-full}" == full ]]; then
  curl --fail --silent --show-error --connect-timeout 5 --max-time 20 \
    https://freshprice.philwatch.com/healthz
  printf '\n'
  curl --fail --silent --show-error --connect-timeout 5 --max-time 20 \
    --output /dev/null --write-out 'Frontend HTTP: %{http_code}\n' \
    https://freshprice.philwatch.com/
  for deployment_path in sw.js manifest.webmanifest; do
    curl --fail --silent --show-error --head --connect-timeout 5 --max-time 20 \
      "https://freshprice.philwatch.com/$deployment_path"
  done
fi
CHECK
```

Confirm these results before proceeding:

- Selected services have their desired replicas (`1/1` in the current configuration), current tasks are Running, and their local containers report `(healthy)`. Old Shutdown/Failed entries in task history alone do not indicate a failed current release.
- The selected service's update is `completed`, or `none` on an initial deployment. `updating` means wait and rerun; `paused`, `rollback_started`, `rollback_paused` or `rollback_completed` means the intended rollout has not succeeded. Compare the displayed image digest with the image published by the intended Actions run: a healthy old/rolled-back release is insufficient.
- All migrations shipped in the running backend image show `up`; FP-64 includes `20260912000001-budget-reliability.cjs` and `20260912000002-populate-product-wiki-catalogue.cjs`. Public API readiness returns `{"status":"ok","database":"ready"}`.
- For the full check, `/healthz` returns `{"status":"ok"}`, the frontend reports HTTP 200, `/sw.js` has `Cache-Control: no-store`, and the manifest has `Cache-Control: no-cache` with `Content-Type: application/manifest+json`. Both worker/manifest responses should have `CDN-Cache-Control: no-store`. The origin also sets `Cloudflare-CDN-Cache-Control: no-store`; its absence from public responses is expected because [Cloudflare consumes that header without forwarding it downstream](https://developers.cloudflare.com/cache/concepts/cdn-cache-control/).

The block prints evidence for inspection; exit code zero alone does not confirm migration, rollout or header correctness. A failed curl stops the block. Once these checks pass, smoke-test login, budget saves, wiki/recipe pages and a previously affected returning browser. This HTTP check does not exercise the host's frontend-down Caddy fallback; verify that through the [recovery runbook](fp-43-recovery-runbook.md).

For a failure, inspect the current task errors and recent logs on the VPS:

```bash
docker service ps freshprice_backend --no-trunc
docker service ps freshprice_frontend --no-trunc
docker service logs --tail 100 freshprice_backend
docker service logs --tail 100 freshprice_frontend
```

## Verification Checklist

- Frontend normal change: `npm run lint`, `npm run test:unit`, `npm run build`.
- Frontend E2E/protected route change: also `npm run test:e2e:chromium`.
- Backend normal change: `npm run test`, or scoped `npm run test:unit` / `npm run test:integration`.
- Schema change: run migrations against a local database and add/update migration tests when practical.


## FP-43 maintenance and recovery (2026-10-02)

The frontend now uses `/healthz` for container readiness and supports `FRESHPRICE_MAINTENANCE=true`. See `fp-43-recovery-runbook.md` for the independent Caddy fallback, targeted enable/disable commands, validation and rollback. These changes have been verified locally and are not deployed.

The deployment workflow now exports `FRESHPRICE_MAINTENANCE` from the VPS `.env` before rendering the Swarm stack (2026-10-11 fix). Persist `true` or `false` there when changing the frontend service setting so later frontend/Sugilanon dispatches retain the intended state. An absent flag defaults to false. Verify the parser without a daemon or production access with `node --test fpdocker/tests/deploy-maintenance.test.mjs`; on Windows set `DEPLOY_TEST_SHELL` to the Git Bash executable. The regression executes the workflow's actual parser and renders synthetic enabled, disabled and default settings through `docker stack config`.

## FP-60 release gate — local 2026-10-19

FP-60 depends on FP-59's three migrations and permission/lifecycle release. Apply `20261019000004-budget-accounting.cjs` and FP-60 backend before frontend. Rehearse on restored staging data and confirm neutral legacy balances, centavo shares, concurrent confirmations, ordinary expense CRUD, and viewer/removed-member denials; then release the UI and verify desktop/mobile pending/confirmed/reversal flows. Financial rows block destructive schema rollback. Once accounting is collected, retain FP-60 expense revision/void guards during backend rollback or suspend expense writes; reverting to FP-59's write paths could invalidate financial history. Prefer a forward fix. No staging or production action was performed by local implementation. See `fp-60-accounting-2026-10-19.md`.

## FP-61 offline queue rollout — 2026-10-20

Apply `20261020000001-expense-mutation-receipts.cjs` and deploy the supporting backend before releasing the FP-61 frontend. Retain durable receipts and backward-compatible APIs during rollback; the migration refuses down after receipt creation. PWA cache replacement must retain the separate `freshprice-expense-drafts` IndexedDB database. Queue version 1 creates `drafts` additively; future migrations must preserve pending payloads/keys and reject unsupported versions without resetting data. Foreground operation is sufficient; background sync is optional. Rehearse offline browser restart, upgrade with queued work, expiry/same-account reauthentication, account changes, revoked/deleted targets and uncertain-response retries against staging before release. Local fixture/server verification does not certify production cache/proxy/storage behavior.

## FP-62 wiki enrichment release gate — 2026-10-20

Integrate the unmerged FP-59/60/61 dependency chain, then rehearse both `20261020000002-wiki-enrichments.cjs` and `20261020000003-wiki-enrichment-retry-and-retraction.cjs`, then backend before frontend. Never roll back a used enrichment table by deleting collected proposals/history; down rejects nonempty data. Confirm current-source publication, obsolete-translation hiding, import draft preservation, author-only name withdrawal, scoped seasonal/recipe pagination and private review output in staging. Use the operator inventory against the actual target before selecting a small factual content pilot; review source authority, regional applicability, date and translation quality before publishing it. Local synthetic fixtures and passing browsers are not production content evidence.

FP-62 review fixes also require staging checks for draft collapse/in-flight retention, committed-response loss retry/concurrent deduplication and exact operator retraction from public/seasonal results while preserving canonical/other variants. Migration 00003 refuses rollback once retry identities or retraction history exist; preserve columns/history and use a forward repair. Older clients omitting submissionId remain compatible but do not gain retry deduplication. See `fp-62-review-fixes-2026-10-20.md`.

## FP-63 shopping integration release gate — 2026-10-20

Integrate FP-59/60/61/62 dependencies, then apply `20261020000004-shopping-lists.cjs` and backend before frontend. Used list/purchase/operation history blocks destructive rollback. Rehearse current/shared budget privacy and revocation, exact recipe mapping/serving precision, official unit/market/freshness estimates, missing-price unknown totals, explicit actual purchase, concurrent/lost-response retries, expense deletion preventing recreation, mobile list navigation and account/offline recovery in staging. Lists are personal; shopping forms have in-memory online retries, not durable background expense replay. Favorites/alerts remain separately scoped follow-ups. See `fp-63-shopping-integration-2026-10-20.md` and local ticket coverage for actual verification.

## Sprint 337 release audit/runbook — 2026-10-20

October 21 execution: backup/migration recovery, 50 direct-service cases and the declared [HTTP/auth/browser/nginx acceptance](http-browser-acceptance-2026-10-21.md) now pass on isolated restored copies of the production backup. Actual-device/installed-version upgrades and PostgreSQL exposure disposition remain before full readiness; public Caddy/CDN/certificate and intended image-digest checks remain part of the serialized deployment. No sprint candidate has been merged or deployed by these checks.

See [the audited sprint 337 deployment runbook](sprint-337-release-audit-and-runbook-2026-10-20.md) for the current PR state, resolved FP-60/61 integration, exact five-migration/six-deployment order, remaining review/staging/backup/digest gates and data-preserving repair. Read-only public checks now confirm healthy API/nginx, `/sw.js` no-store/CDN no-store with Cloudflare BYPASS, and manifest no-cache/CDN no-store; this supersedes the historical four-hour-cache observation above for the checked responses. VPS images/migration state and actual-device staging still require verification before releasing the sprint. No production action was performed by the audit.
