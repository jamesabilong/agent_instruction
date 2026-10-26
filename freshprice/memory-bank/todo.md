# FreshPrice Todo

Current as of 2026-10-26. Historical checklists are preserved in [the archive](archive/todo-through-2026-10-21.md); superseded pending release steps there are not current tasks.

## Active work

- [x] October 26: read-only production Chromium verification completed; checked flows/API statuses and zero console errors/warnings recorded with explicit limits. Keep exemptions disabled. [Results](../docs/browser-verification-2026-10-26.md).
- [x] October 26: complete isolated populated community ranking/tag/tie pages, current-price UI pages, browser-fetched history/search pages and populated search/detail checks. [Results and limits](../docs/populated-browser-verification-2026-10-26.md).
- [x] October 26: fix PhilWatch search-page navigation and global price search locally; add real PostgreSQL and isolated UI regressions. [Results](../docs/search-pagination-fix-2026-10-26.md).
- [ ] Review/publish the local backend and both frontends, then obtain release authorization; deploy backend before FreshPrice frontend and verify production with exemptions disabled. No app publication/deployment performed by this task.
- [ ] Preserve production inventory limits and separate authenticated/admin, cross-browser/device/PWA recovery follow-ups; do not seed production or enable exemptions for coverage.

- [x] October 26: audit backend search/pagination, reproduce/fix ranking/tag/tie findings locally and add 16 database regressions; final 62 database-suite and 271 unit checks pass. [Record](../docs/backend-pagination-audit-2026-10-26.md).
- [x] October 26: user-authorized review/commit/push/PR #62 merge/deployment and actual production verification complete; source/digest, read-only query comparison, 51 GET checks and preserved runtime/DB/guard pass. Exemptions false, zero rules/audits. [Release](../docs/backend-pagination-deployment-2026-10-26.md).

- [x] October 26: ordered FP-66 merge/deploy, scoped credential parser follow-up, Caddy strict identity/two independent real clients/direct-origin checks and final image/migration 42/DB/guard verification complete; exemptions false, zero rules/audits. Fresh protected post-release full restore passes. [Release](../docs/fp-66-deployment-2026-10-26.md).
- [x] October 26: fix nonempty PhilWatch search locally and add 10 database-backed regressions; all 46 DB/271 unit checks pass. [Record](../../sugilanon/docs/content-search-fix-2026-10-26.md).
- [x] October 26: user-authorized backend PR #61 merged/deployed; exact new source/digest, both public nonempty search paths/internal reader and preserved exemptions-disabled/DB/guard/runtime pass. [Release](../../sugilanon/docs/content-search-fix-2026-10-26.md). Existing article-detail smoke still requires real published content.

- [x] 2026-10-23: complete FP-66 local forwarding/SSR integration, persistent own-account exemption controls, fresh reauthentication, expiry/revocation/audit/recovery and admin UI. Final 9+30 acceptance, unit/DB/proxy and lint/build checks pass. [Record](../docs/fp-66-controls-2026-10-23.md).
- [x] 2026-10-26: review exact FP-66 candidate across all four repositories; all 34 hashes/HEADs match accepted source, no blocking finding, fresh 271+303 units/three parser checks and both app lint/build checks pass. [Review](../docs/fp-66-review-2026-10-26.md).
- [x] 2026-10-26: user-authorized FP-66 commits/pushes and four attached draft PRs complete, with correct bases and MERGEABLE/CLEAN status. [Publication](../docs/fp-66-publication-2026-10-26.md). Historical publication checkpoint; the release is recorded above.
- [x] 2026-10-26 readiness: both sites' public app/DB health pass; all 22 current official Cloudflare ranges pass local Caddy adaptation/validation with strict parsing and both proxy header policies. [Scope/evidence](../docs/fp-66-readiness-2026-10-26.md).
- [x] October 26: user-authenticated read-only host/runtime/DB/guard/backup inventory and explicitly approved existing-backup FP-66 migration/recovery pass; local raw dumps/resources removed and final production metadata unchanged. [Scope/results](../docs/fp-66-host-readiness-2026-10-26.md).
- [x] October 26: user-authorized fresh protected backup/full restore, exact FP-66 migration/recovery on that fresh snapshot and safe official Caddy 2.11.7 upgrade complete. Existing sites/config and shared app/DB/guard baseline pass; installed full non-active candidate validates. [Maintenance/evidence](../docs/fp-66-caddy-maintenance-2026-10-26.md).

- [x] Final FP-63 runtime/host verification and fresh protected post-release backup/full isolated restore pass after SSH reconnection; [release record](../docs/fp62-fp63-deployment-2026-10-22.md).
- [ ] Confirm owners and estimates/capacity for active sprint 338 (FP-62/63/66); started on user request October 22 with Jira’s default two-week window ending November 5. FP-57 → FP-58 remains the future seller/messaging sequence.

## Operations and retained follow-ups

- [ ] Retain protected production backup, recoverable image digests and enabled PostgreSQL guard; recheck public-interface coverage if networking changes. Off-host/global-role/config redeployment recovery and upload/DB snapshot consistency are not certified by the isolated rehearsal.
- [ ] Retain local `testing/` backups and register fixture/acceptance/scenario requirements for future tickets. App-only checkouts require the sibling testing workspace. Add guaranteed interrupt cleanup if that runner requirement is adopted.
- [ ] Reassess historical FP-43/56/wiki/import operational follow-ups in the archived checklist when those areas are touched. Current health/cache checks do not certify every earlier functional scenario or affected-device recovery.
- [ ] Observation trends: implement the community-submission adapter/source deduplication before including community quotes, and confirm real note dates/units/aliases before imports.

## Completed

- [x] 2026-10-21: reviewed sprint 337, marked FP-59/60/61 Done and completed the sprint on user request. Jira confirms 100% completion; sprint 338 was subsequently started on October 22 with FP-62/63/66.
- [x] FP-59/60/61 released and final live read-only verification passes; PostgreSQL publication removed and guarded; worker/manifest headers pass.
- [x] Device/installed-upgrade testing explicitly waived by user, recorded as untested.
- [x] FP-66 created/verified in sprint 338; reviewed implementation deployed October 26; exemptions disabled.
- [x] Review cleanup changes, preserve needed FP-63 work as WIP feature commits, discard already-published Docker duplicates, consolidate instructions and preserve historical evidence.
- [x] 2026-10-22: implemented the three FP-63 review fixes locally; lint/build, 298 frontend units, 232 backend tests (23 existing DB skips) and controlled Chromium regression pass. Reviewed fixes were subsequently committed/pushed; release gates remain open.
- [x] 2026-10-22: started sprint 338; restored local Docker by launching its nested desktop app; full acceptance passes 12 feature + 30 whole-app, 36 database integrations and dedicated service/database regressions. Disposable local databases only; no production changes.

- [x] 2026-10-22: reviewed full FP-63 scope and exact accepted source; no new blocking findings. Committed/pushed frontend `7d8e4be4` and backend `9e78c65` on existing FP-63 branches, without app master changes or deployment. [Review](../docs/fp-63-publication-review-2026-10-22.md).

- [x] 2026-10-22: created/attached paired FP-63 draft PRs against master, verified conflicts/dependencies/checks and documented remaining release gates; checked FP-66 requirements/source and the trusted-IP-first sequence. No merge, release or exemption enabled.

- [x] 2026-10-22: checked FP-62 remote source, critical feature paths, original review fixes and retained acceptance JUnit (13 + 30, zero failures/skips); confirmed master conflicts, absent dedicated PRs and open inventory/editorial/release gates. No app changes or new test execution claimed.

- [x] 2026-10-22: reconciled FP-62 with master, committed/pushed backend `cf33ab2`/frontend `2ab9afce`, passed fresh complete 13+30 acceptance plus 36 gated DB checks and normal lint/unit/build/runner checks, created attached draft PRs #59/#57 and updated FP-63 dependency/release gates. No production merge/deployment.

- [x] 2026-10-22: refreshed FP-63 with reconciled FP-62, resolved configs preserving master test tooling, passed full 12+30 acceptance/36 gated DB/298 frontend/232 ordinary backend/41 runner checks and lint/build; pushed `dffc65f`/`befd3c87` and updated existing PRs #58/#56 to MERGEABLE/CLEAN with current remaining release gates.

- [x] 2026-10-22: completed actual 113-product inventory (zero recipes), fresh protected backup/full isolated restore, exact 38→40→41 migrations/rollback guards/post-migration recovery and restored-copy service/import checks (10/10 FP-62, 15/15 FP-63). Draft PR release gates updated; content approval is subsequently recorded; recovery/acceptance-scope, code-review and serialized-release approvals remain open.

- [x] 2026-10-22: user approved the exact six multilingual wiki variants and both sourced recipes from documentation commit `9172cbd`; editorial gate closed, production publication and release still unexecuted.

- [x] 2026-10-22: user accepted documented recovery/testing limitations; reviewed/merged FP-62/63 in authorized backend-before-frontend order, all four deployment workflows succeeded and exact approved pilot/recipes published. Final SSH-dependent verification and post-release backup/restore subsequently passed.

- [x] October 22 VPS maintenance complete: operator SSH restored; kernel, database/images, public health/content and guard verification pass after reboot. [Record](../../freshprice/docs/vps-maintenance-2026-10-22.md).

- [x] 2026-10-22: marked FP-62 and FP-63 Done through the browser and moved FP-66 to In Progress; retained visible board proof locally.
