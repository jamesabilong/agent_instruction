# FreshPrice Progress

Last consolidated: 2026-10-21. This file describes current state. Older chronological notes are retained in [the history archive](archive/progress-through-2026-10-21.md).

## Production release

- FP-59, FP-60 and FP-61 are merged and deployed. Final read-only checks confirm the expected actual running image digests, four healthy services, 38 migrations including mutation receipts, preserved database identity/data volume, fresh private DB connectivity, and passing FreshPrice/PhilWatch health and worker/manifest cache headers. See [final release verification](../docs/fp61-deployment-2026-10-21.md) and its linked evidence.
- Docker security PR #25 is merged/deployed. PostgreSQL has no published host port; the independent public-interface guard is active/enabled and external 5432 probes time out. Recovery/operation details: [PostgreSQL security](../docs/postgres-security-2026-10-21.md).
- Protected checkpoint and isolated recovery/migration checks pass; 50 direct-service cases, 34 HTTP groups, 21 overlapping browser groups and 3 proxy-failure checks pass on exact candidates. Live verification was read-only and did not rerun authenticated production feature mutations. Physical-device/installed-upgrade testing was explicitly waived, not passed. Off-host/global-role/config recovery and atomic live-upload snapshots retain their documented limits.
- Jira FP-59/60/61 completion and sprint closure were not changed by release verification. Sprint 337 remains administratively separate from deployment status.

## Current development

- FP-62 is published on feature branches at frontend `2fc10cd7` / backend `1fcb72d8`, but is not released. Editorial pilot approval, target inventory, integration/release review and database/browser release gates remain open.
- FP-63 shopping work is now preserved as explicitly WIP remote commits: frontend `0a079583` / backend `acfa1f8`. No PR or production deployment was created by cleanup. Source/config fingerprint remains `38eb24ddc506b0f97debbc346769754a07e7b2c8db2516200a59333c9edcbf92`, matching the reviewed snapshot. Three findings remain open: purchase-confirmation context drift, shared-history navigation, and exact estimate rounding. See [FP-63 review](../docs/fp-63-precommit-review-2026-10-20.md). WIP publication does not establish merge readiness.
- Fresh cleanup checks: frontend lint/build and 291 units pass; backend 224 tests pass with 23 database-gated skips. Earlier complete acceptance evidence belongs to the unchanged source snapshot; no DB/browser suite rerun is claimed by cleanup.
- FP-66 is a To Do Story in future sprint 338, Wiki and Shopping Integration: [admin-managed dynamic IP exemptions](https://fresh-price.atlassian.net/browse/FP-66). It includes the confirmed shared-gateway client-IP bug as a prerequisite. No live bypass has been enabled. [Investigation](../docs/auth-testing-exemption-2026-10-21.md).
- FP-57/58 remain future seller/messaging work. FP-62/63/66 were not deployed or moved into the active sprint by cleanup.

## Repository cleanup

- Removed local Docker security duplicates only after byte comparison with published master; primary fpdocker is clean on deployed master `5f364def`.
- Consolidated current progress/todo/bugs and retained prior records under memory-bank/archive. Safe release evidence and operator utilities are retained; test-only rehearsal fixtures/helpers moved to local workspace `testing/operations/release-2026-10-21/`, outside app repositories. Local testing, generated output and private server snapshots are not published with instructions.
- Before cleanup, saved a protected local recovery snapshot at `/private/tmp/freshprice-repo-cleanup-20261021T172949/`. No app master/main push, deployment dispatch, production restart/migration or live configuration change occurred.
