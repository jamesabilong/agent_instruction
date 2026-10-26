# Sugilanon Todo

Current as of 2026-10-26. [Historical checklist](archive/todo-through-2026-10-21.md).

- [x] October 26 Windows continuation: restore missing search source, reverify helper/page/browser/lint/build and shared backend/PostgreSQL behavior, recover Docker startup and correct setup guidance. [Current evidence and limits](../../freshprice/docs/windows-continuation-2026-10-26.md).

- [x] October 26: read-only production Chromium verification completed; checked flows/API statuses and zero console errors/warnings recorded with explicit limits. Keep exemptions disabled. [Results](../../freshprice/docs/browser-verification-2026-10-26.md).
- [x] October 26: complete isolated populated community ranking/tag/tie pages, current-price UI pages, browser-fetched history/search pages and populated search/detail checks. [Results and limits](../../freshprice/docs/populated-browser-verification-2026-10-26.md).
- [x] October 26: fix PhilWatch search-page navigation and global price search locally; add real PostgreSQL and isolated UI regressions. [Results](../../freshprice/docs/search-pagination-fix-2026-10-26.md).
- [x] October 26: review/fix search gaps, commit/push and create backend #63, frontend #59 and PhilWatch #3 with current exact-head verification. [Review and evidence](../../freshprice/docs/search-pagination-review-publication-2026-10-26.md).
- [ ] Obtain release authorization, then deploy backend #63 before frontend #59 and verify PhilWatch #3 with exemptions disabled. PR creation did not merge or deploy anything.
- [ ] Preserve production inventory limits and separate authenticated/admin, cross-browser/device/PWA recovery follow-ups; do not seed production or enable exemptions for coverage.

- [x] October 26: audit backend search/pagination, reproduce/fix ranking/tag/tie findings locally and add 16 database regressions; final 62 database-suite and 271 unit checks pass. [Record](../../freshprice/docs/backend-pagination-audit-2026-10-26.md).
- [x] October 26: user-authorized review/commit/push/PR #62 merge/deployment and actual production verification complete; source/digest, read-only query comparison, 51 GET checks and preserved runtime/DB/guard pass. Exemptions false, zero rules/audits. [Release](../../freshprice/docs/backend-pagination-deployment-2026-10-26.md).

- [x] October 26: ordered FP-66 merge/deploy, scoped credential parser follow-up, Caddy strict identity/two independent real clients/direct-origin checks and final image/migration 42/DB/guard verification complete; exemptions false, zero rules/audits. Fresh protected post-release full restore passes. [Release](../../freshprice/docs/fp-66-deployment-2026-10-26.md).
- [x] October 26: fix nonempty PhilWatch search locally and add 10 database-backed regressions; all 46 DB/271 unit checks pass. [Record](../docs/content-search-fix-2026-10-26.md).
- [x] October 26: user-authorized backend PR #61 merged/deployed; exact new source/digest, both public nonempty search paths/internal reader and preserved exemptions-disabled/DB/guard/runtime pass. [Release](../docs/content-search-fix-2026-10-26.md). Existing article-detail smoke still requires real published content.

- [x] October 23: FP-66 local proxy/Next/SSR integration, restricted service reader and shared exemption controls/admin UI implemented; complete local acceptance and PhilWatch lint/build pass. [Record](../../freshprice/docs/fp-66-controls-2026-10-23.md).
- [x] October 26: review exact cross-app FP-66 candidate, verify unchanged acceptance hashes, rerun shared units/parser checks and both apps' lint/build; no blocking code finding. [Review](../../freshprice/docs/fp-66-review-2026-10-26.md).
- [x] October 26: authorized FP-66 commit/push and four coordinated draft PRs complete; PhilWatch [#2](https://github.com/jamesabilong/sugilanon/pull/2) targets main and is MERGEABLE/CLEAN. [Publication](../../freshprice/docs/fp-66-publication-2026-10-26.md). Historical publication checkpoint; the release is recorded above.
- [x] October 26 readiness: public app/DB health and local Caddy validation with all 22 current official CDN ranges/both proxy header policies pass. [Scope](../../freshprice/docs/fp-66-readiness-2026-10-26.md).
- [x] October 26: user-authenticated shared host/DB/guard/backup inventory and explicitly approved October 22 restored-copy FP-66 migration/recovery pass; final production metadata unchanged and local raw dumps/resources removed. [Scope](../../freshprice/docs/fp-66-host-readiness-2026-10-26.md).
- [x] October 26: authorized fresh backup/full restore, exact fresh-snapshot FP-66 migration/recovery and official Caddy 2.11.7 upgrade complete; existing PhilWatch/www and shared sites preserved, installed non-active candidate and shared baseline pass. [Maintenance](../../freshprice/docs/fp-66-caddy-maintenance-2026-10-26.md).
- [ ] Verify remaining legacy-worker retirement delivery/purge and affected-device recovery evidence before closing the earlier first-load report. Public health alone does not certify it.
- [ ] Preserve local shared-backend testing backups; app-only checkouts do not include relocated suites.
- [ ] Verify live state rather than closing historical incidents from documentation alone. Recheck routing/manual dispatch instructions when those workflows change; keep API/schema documentation current when editing those areas.
- [x] FP-61 shared-stack verification: healthy unchanged Sugilanon task, public health, preserved database and private connectivity, no database publishing, enabled guard and external denial.
- [x] Consolidate instructions and preserve historical progress/todo/bugs during authorized cleanup; no Sugilanon app source change.

- [x] October 22 VPS maintenance complete: operator SSH restored; kernel, database/images, public health/content and guard verification pass after reboot. [Record](../../freshprice/docs/vps-maintenance-2026-10-22.md).
