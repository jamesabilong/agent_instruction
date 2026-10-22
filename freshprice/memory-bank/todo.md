# FreshPrice Todo

Current as of 2026-10-22. Historical checklists are preserved in [the archive](archive/todo-through-2026-10-21.md); superseded pending release steps there are not current tasks.

## Active work

- [ ] FP-66: correct trusted end-user IP handling and forwarding-header spoof resistance, then implement admin-managed exact account/IP exemptions with expiry, revocation and audit. Validate FreshPrice and PhilWatch. No gateway/subnet wildcard exemption or password/session/role bypass. [Ticket](https://fresh-price.atlassian.net/browse/FP-66).
- [ ] Reconcile FP-62/63 against deployed master before release; preserve tested source, review actual PR targets/diffs, and deploy schema/backend before frontend. Do not merge stacked PRs into an old feature branch when a production release is intended.
- [ ] FP-62: run target-environment content inventory, select a sourced pilot, obtain editorial/translation approval and verify moderation/import/privacy/rollback before publication.
- [ ] FP-63: complete dependency/release review and ordered backend-before-frontend rollout acceptance; local isolated migration/purchase/history/revocation/offline/retry checks now pass. Favorites/price alerts remain separate increments; checkout/orders/payments remain deferred.
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
