# Sugilanon Bugs And Risks

Current as of 2026-10-26. [Historical reports](archive/bugs-through-2026-10-21.md).

- October 26 FP-66 readiness is awaiting user-authenticated SSH: installed-Caddy/shared host/database/backup inventory and restored-copy migration/recovery remain unverified despite passing public health and local Caddy/public-CDN checks. [Readiness](../../freshprice/docs/fp-66-readiness-2026-10-26.md).

- FP-66 shared-auth risk: FreshPrice's public path identifies callers as the Docker gateway, grouping rate-limit buckets. PhilWatch's exact route is not independently reproduced; verify it when correcting proxy trust. Local FP-66 now passes 37 actual proxy/SSR assertions and complete shared feature acceptance, but no deployed/public-client validation is claimed and no live exemption is enabled. [Record](../../freshprice/docs/fp-66-controls-2026-10-23.md).
- Earlier first-load/obsolete-worker report: retirement source was implemented and tested locally, but the affected device's registration and recovery are not established by current public health checks. See [cache recovery](../docs/cache-recovery-2026-10-09.md).
- Current Sugilanon task/public health pass. Old missing-image, wrong-host and health-loop reports are historical observations, not current demonstrated outages.
- Next.js 16 has breaking changes; read the app-local agent/Next instructions before framework-sensitive edits. `/api/content` is deprecated; use `/api/sugilanon`.

- October 23 local fix: Next browser rewrite default used the local backend alias in production; changed to `freshprice_backend` and verified both normal production build and real synthetic rewrite traffic. Server-only content identity is separate from visitor identity; public ingress strips its credential. Not deployed.
