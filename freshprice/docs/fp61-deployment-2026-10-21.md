# FP-61 final deployment verification — 2026-10-21

Result: **read-only deployment/health/security checks pass**. FP-59, FP-60 and FP-61 are now released; no deployment blocker was identified within these checks. User-waived physical-device/installed-upgrade testing remains untested. No production mutation, migration, restart, deployment or PR change was performed by this verification.

## Release identity

- Backend PR #57 merge: `871acac86b459a40c4bf9fa842bf9557bc77b838`. [Backend run](https://github.com/jamesabilong/fpdocker/actions/runs/39570359848) succeeds; logs confirm receipt migration and service convergence.
- Frontend PR #55 merge: `699c11bab4f949d8096f03ec7fb29c34c3b940f2`. [Frontend run](https://github.com/jamesabilong/fpdocker/actions/runs/39570390880) succeeds and frontend converges.
- Actual running backend digest matches `sha256:039828f23f9a048154224d4a9e0aab36c79300f4fc4000ab8af7d73737f03151`; frontend matches `sha256:6c8694fe0993158cbff8f8f2a7fe5bb558b6d60d53f23f252452d818be8a59e1`. Runtime immutable image IDs/RepoDigests verified, since service specs retain mutable latest tags. VPS Docker checkout remains `5f364defe7202c16e839c58bfc3f35b8ee8221ef`.

## Host and public checks

- All four Swarm services have exactly one healthy running container. Update states are completed or absent; none is paused or rolling back. PostgreSQL and Sugilanon retain their FP-60 container identities.
- Database inventory is **38 migrations**, including accounting and `20261020000001-expense-mutation-receipts.cjs`. Database/system identity and original data volume match the protected checkpoint; a fresh backend private-network connection successfully runs `SELECT 1`.
- PostgreSQL has no published port in endpoint or service spec. The independent eth0 TCP 5432 guard is active/enabled; its counter records drops, and an external connection times out.
- Public FreshPrice database health: HTTP 200 `{"status":"ok","database":"ready"}`. Frontend `/healthz`: HTTP 200 `{"status":"ok"}`. PhilWatch `/health`: HTTP 200 `ok`.
- `/sw.js`: HTTP 200, JavaScript, browser/CDN no-store, CF BYPASS. Manifest: HTTP 200, application/manifest+json, browser no-cache/CDN no-store, CF DYNAMIC.

These are live read-only checks, not new authenticated production expense/replay/payment/role mutations. Prior exact-candidate isolated restored-copy acceptance remains the functional evidence. Physical-device/installed-version testing was explicitly waived; do not describe it as passed. No CDN purge was performed by verification; observed public cache headers are correct.

Safe evidence: `../evidence/fp61-deployment-2026-10-21.json`. Earlier stages: [FP-59](fp59-deployment-2026-10-21.md), [FP-60](fp60-deployment-2026-10-21.md). Keep the PostgreSQL guard enabled and retain additive financial/receipt schema and history for recovery. FP-62/63 remain excluded from this release. Jira completion was not changed by this verification.
