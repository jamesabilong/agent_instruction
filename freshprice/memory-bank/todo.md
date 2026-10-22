# FreshPrice Todo

Current as of 2026-10-22. Historical checklists are preserved in [the archive](archive/todo-through-2026-10-21.md); superseded pending release steps there are not current tasks.

## Active work

- [ ] FP-66: correct trusted end-user IP handling and forwarding-header spoof resistance, then implement admin-managed exact account/IP exemptions with expiry, revocation and audit. Validate FreshPrice and PhilWatch. No gateway/subnet wildcard exemption or password/session/role bypass. [Ticket](https://fresh-price.atlassian.net/browse/FP-66).
- [ ] Land/release approved FP-62 prerequisites [backend #59](https://github.com/jamesabilong/fresh-price-backend/pull/59) then [frontend #57](https://github.com/jamesabilong/fresh-price-front/pull/57) in authorized order, after real inventory/editorial/target-representative recovery gates. Conflicts and fresh local synthetic acceptance are resolved; PRs remain drafts. [Reconciliation](../docs/fp-62-reconciliation-2026-10-22.md).
- [ ] FP-63: obtain prerequisite FP-62 approval/release and complete actual target inventory/editorial/backup/migration/ordered rollout readiness. Recheck master/diff after prerequisites land; rerun affected validation if source/config changes. Conflicts, branch dependency integration and fresh local integrated acceptance are complete. [Current gates](../docs/fp-63-refresh-2026-10-22.md). Favorites/price alerts remain separate increments; checkout/orders/payments remain deferred.
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
- [x] FP-66 created/verified in sprint 338; exemption implementation remains To Do.
- [x] Review cleanup changes, preserve needed FP-63 work as WIP feature commits, discard already-published Docker duplicates, consolidate instructions and preserve historical evidence.
- [x] 2026-10-22: implemented the three FP-63 review fixes locally; lint/build, 298 frontend units, 232 backend tests (23 existing DB skips) and controlled Chromium regression pass. Reviewed fixes were subsequently committed/pushed; release gates remain open.
- [x] 2026-10-22: started sprint 338; restored local Docker by launching its nested desktop app; full acceptance passes 12 feature + 30 whole-app, 36 database integrations and dedicated service/database regressions. Disposable local databases only; no production changes.

- [x] 2026-10-22: reviewed full FP-63 scope and exact accepted source; no new blocking findings. Committed/pushed frontend `7d8e4be4` and backend `9e78c65` on existing FP-63 branches, without app master changes or deployment. [Review](../docs/fp-63-publication-review-2026-10-22.md).

- [x] 2026-10-22: created/attached paired FP-63 draft PRs against master, verified conflicts/dependencies/checks and documented remaining release gates; checked FP-66 requirements/source and the trusted-IP-first sequence. No merge, release or exemption enabled.

- [x] 2026-10-22: checked FP-62 remote source, critical feature paths, original review fixes and retained acceptance JUnit (13 + 30, zero failures/skips); confirmed master conflicts, absent dedicated PRs and open inventory/editorial/release gates. No app changes or new test execution claimed.

- [x] 2026-10-22: reconciled FP-62 with master, committed/pushed backend `cf33ab2`/frontend `2ab9afce`, passed fresh complete 13+30 acceptance plus 36 gated DB checks and normal lint/unit/build/runner checks, created attached draft PRs #59/#57 and updated FP-63 dependency/release gates. No production merge/deployment.

- [x] 2026-10-22: refreshed FP-63 with reconciled FP-62, resolved configs preserving master test tooling, passed full 12+30 acceptance/36 gated DB/298 frontend/232 ordinary backend/41 runner checks and lint/build; pushed `dffc65f`/`befd3c87` and updated existing PRs #58/#56 to MERGEABLE/CLEAN with current remaining release gates.
