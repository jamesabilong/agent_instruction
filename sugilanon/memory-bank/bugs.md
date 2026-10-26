# Sugilanon Bugs And Risks

Current as of 2026-10-26. [Historical reports](archive/bugs-through-2026-10-21.md).

- Resolved FP-66 shared identity: deployed backend/schema, Caddy/nginx/Next and restricted SSR reader; two independent public clients and spoof/direct-origin checks pass. Scoped keys absent from browser assets and SSR HTML. Exemptions false, zero rules/audits. [Release](../../freshprice/docs/fp-66-deployment-2026-10-26.md).
- Open nonempty-query search defect: `/api/sugilanon/search?q=fp66` returns 500; empty-query search is 200. SSR catches it and renders empty results. Source matches previous running backend; exact cause/repair unconfirmed. Add real database regression coverage and repair separately. Production has zero published articles/categories, so no existing live article-detail smoke was possible. [Diagnostics/limits](../../freshprice/docs/fp-66-deployment-2026-10-26.md).

- Earlier first-load/obsolete-worker report: retirement source was implemented and tested locally, but the affected device's registration and recovery are not established by current public health checks. See [cache recovery](../docs/cache-recovery-2026-10-09.md).
- Current Sugilanon task/public health pass. Old missing-image, wrong-host and health-loop reports are historical observations, not current demonstrated outages.
- Next.js 16 has breaking changes; read the app-local agent/Next instructions before framework-sensitive edits. `/api/content` is deprecated; use `/api/sugilanon`.

- October 23 local fix: Next browser rewrite default used the local backend alias in production; changed to `freshprice_backend` and verified both normal production build and real synthetic rewrite traffic. Server-only content identity is separate from visitor identity; public ingress strips its credential. Not deployed.
