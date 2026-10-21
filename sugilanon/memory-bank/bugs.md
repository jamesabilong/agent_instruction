# Sugilanon Bugs And Risks

Current as of 2026-10-21. [Historical reports](archive/bugs-through-2026-10-21.md).

- FP-66 shared-auth risk: FreshPrice's public path identifies callers as the Docker gateway, grouping rate-limit buckets. PhilWatch's exact route is not independently reproduced; verify it when correcting proxy trust. No live exemption is enabled.
- Earlier first-load/obsolete-worker report: retirement source was implemented and tested locally, but the affected device's registration and recovery are not established by current public health checks. See [cache recovery](../docs/cache-recovery-2026-10-09.md).
- Current Sugilanon task/public health pass. Old missing-image, wrong-host and health-loop reports are historical observations, not current demonstrated outages.
- Next.js 16 has breaking changes; read the app-local agent/Next instructions before framework-sensitive edits. `/api/content` is deprecated; use `/api/sugilanon`.
