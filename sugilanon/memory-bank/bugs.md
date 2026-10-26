# Sugilanon Bugs And Risks

Current as of 2026-10-26. [Historical reports](archive/bugs-through-2026-10-21.md).

- October 26 Windows reconciliation: reconstructed missing local search fixes and added fresh helper/page/browser/lint/build checks. Docker Desktop's preexisting inaccessible runtime sockets were recovered without reset or project-data changes; Engine 28.5.1 responds and isolated PostgreSQL search tests pass. [Current evidence and limits](../../freshprice/docs/windows-continuation-2026-10-26.md).

- Published source, release pending (October 26): missing PhilWatch page navigation/global price search plus blank/overlong-query and shared price boundary/race findings are fixed in backend #63/frontend #59/PhilWatch #3. Fresh local gates pass; deployment is required before calling these resolved in production. [Review and verification](../../freshprice/docs/search-pagination-review-publication-2026-10-26.md). The earlier development image-priority warning remains separate.

- Resolved in production (October 26): community page-local hot/top ranking, truncated tag hydration and nonunique content/source/price page order fixed by backend PR #62. Exact image/source, 51 public GET checks, read-only production list/SQL comparisons and shared DB/runtime/guard pass; populated edge cases covered by 16 isolated PostgreSQL regressions. Exemptions disabled with zero rules/audits. [Release](../../freshprice/docs/backend-pagination-deployment-2026-10-26.md).

- Resolved FP-66 shared identity: deployed backend/schema, Caddy/nginx/Next and restricted SSR reader; two independent public clients and spoof/direct-origin checks pass. Scoped keys absent from browser assets and SSR HTML. Exemptions false, zero rules/audits. [Release](../../freshprice/docs/fp-66-deployment-2026-10-26.md).
- Resolved nonempty search 500: confirmed Sequelize pagination alias error; backend PR #61 escaped correlated EXISTS/include cloning passes 46 DB/271 unit checks (10 new regressions fail before/pass after), and authorized deployment `72861ee0` passes exact digest/source, both public query paths/internal reader and preserved runtime/DB/guard checks. Exemptions remain false with zero rules/audits. [Fix/release/evidence](../docs/content-search-fix-2026-10-26.md).

- Earlier first-load/obsolete-worker report: retirement source was implemented and tested locally, but the affected device's registration and recovery are not established by current public health checks. See [cache recovery](../docs/cache-recovery-2026-10-09.md).
- Current Sugilanon task/public health pass. Old missing-image, wrong-host and health-loop reports are historical observations, not current demonstrated outages.
- Next.js 16 has breaking changes; read the app-local agent/Next instructions before framework-sensitive edits. `/api/content` is deprecated; use `/api/sugilanon`.

- Resolved October 26: the earlier local Next rewrite correction is deployed in PhilWatch #2 with production `freshprice_backend` default verified; server-only content identity remains separate from visitor identity and public ingress strips its credential. [Release](../../freshprice/docs/fp-66-deployment-2026-10-26.md).
