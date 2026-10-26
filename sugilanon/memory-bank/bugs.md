# Sugilanon Bugs And Risks

Current as of 2026-10-26. [Historical reports](archive/bugs-through-2026-10-21.md).

- Open in production, locally fixed (October 26 audit): community hot/top ranks were page-local; tag filters trimmed other tags; tied content/source/current/history price keys were not uniquely ordered. Database-backed fixes and admin-content tie hardening pass 62 database-suite/271 unit checks; source remains uncommitted/unreleased. Prior PhilWatch nonempty-search 500 stays resolved in deployed PR #61. [Audit](../../freshprice/docs/backend-pagination-audit-2026-10-26.md).

- Resolved FP-66 shared identity: deployed backend/schema, Caddy/nginx/Next and restricted SSR reader; two independent public clients and spoof/direct-origin checks pass. Scoped keys absent from browser assets and SSR HTML. Exemptions false, zero rules/audits. [Release](../../freshprice/docs/fp-66-deployment-2026-10-26.md).
- Resolved nonempty search 500: confirmed Sequelize pagination alias error; backend PR #61 escaped correlated EXISTS/include cloning passes 46 DB/271 unit checks (10 new regressions fail before/pass after), and authorized deployment `72861ee0` passes exact digest/source, both public query paths/internal reader and preserved runtime/DB/guard checks. Exemptions remain false with zero rules/audits. [Fix/release/evidence](../docs/content-search-fix-2026-10-26.md).

- Earlier first-load/obsolete-worker report: retirement source was implemented and tested locally, but the affected device's registration and recovery are not established by current public health checks. See [cache recovery](../docs/cache-recovery-2026-10-09.md).
- Current Sugilanon task/public health pass. Old missing-image, wrong-host and health-loop reports are historical observations, not current demonstrated outages.
- Next.js 16 has breaking changes; read the app-local agent/Next instructions before framework-sensitive edits. `/api/content` is deprecated; use `/api/sugilanon`.

- Resolved October 26: the earlier local Next rewrite correction is deployed in PhilWatch #2 with production `freshprice_backend` default verified; server-only content identity remains separate from visitor identity and public ingress strips its credential. [Release](../../freshprice/docs/fp-66-deployment-2026-10-26.md).
