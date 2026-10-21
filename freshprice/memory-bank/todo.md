# FreshPrice Todo

Current as of 2026-10-21. Historical checklists are preserved in [the archive](archive/todo-through-2026-10-21.md); superseded pending release steps there are not current tasks.

## Active work

- [ ] FP-66: correct trusted end-user IP handling and forwarding-header spoof resistance, then implement admin-managed exact account/IP exemptions with expiry, revocation and audit. Validate FreshPrice and PhilWatch. No gateway/subnet wildcard exemption or password/session/role bypass. [Ticket](https://fresh-price.atlassian.net/browse/FP-66).
- [ ] FP-63: freeze or invalidate reviewed purchase confirmation on list/item/budget/market changes; require renewed review.
- [ ] FP-63: link purchases to immutable purchase-time personal/shared history, including later list retargeting and unavailable/deleted budget access.
- [ ] FP-63: replace binary floating-point estimate multiplication with exact scaled arithmetic and integer-cent aggregation. Convert review probes to expected-correct regressions and rerun the affected/full checks. WIP commits are not merge-ready.
- [ ] Reconcile FP-62/63 against deployed master before release; preserve tested source, review actual PR targets/diffs, and deploy schema/backend before frontend. Do not merge stacked PRs into an old feature branch when a production release is intended.
- [ ] FP-62: run target-environment content inventory, select a sourced pilot, obtain editorial/translation approval and verify moderation/import/privacy/rollback before publication.
- [ ] FP-63: complete isolated migration, purchase/history/revocation/offline/retry and ordered-release acceptance after review fixes. Favorites/price alerts remain separate increments; checkout/orders/payments remain deferred.
- [ ] Set policy details, owners, estimates/capacity and dates before future sprint commitment. FP-57 → FP-58 remains the seller/messaging sequence; sprint 338 includes FP-62, FP-63 and FP-66.

## Operations and retained follow-ups

- [ ] Retain protected production backup, recoverable image digests and enabled PostgreSQL guard; recheck public-interface coverage if networking changes. Off-host/global-role/config redeployment recovery and upload/DB snapshot consistency are not certified by the isolated rehearsal.
- [ ] Retain local `testing/` backups and register fixture/acceptance/scenario requirements for future tickets. App-only checkouts require the sibling testing workspace. Add guaranteed interrupt cleanup if that runner requirement is adopted.
- [ ] Reassess historical FP-43/56/wiki/import operational follow-ups in the archived checklist when those areas are touched. Current health/cache checks do not certify every earlier functional scenario or affected-device recovery.
- [ ] Observation trends: implement the community-submission adapter/source deduplication before including community quotes, and confirm real note dates/units/aliases before imports.

## Completed

- [x] 2026-10-21: reviewed sprint 337, marked FP-59/60/61 Done and completed the sprint on user request. Jira confirms 100% completion; sprint 338 remains unstarted with FP-62/63/66.
- [x] FP-59/60/61 released and final live read-only verification passes; PostgreSQL publication removed and guarded; worker/manifest headers pass.
- [x] Device/installed-upgrade testing explicitly waived by user, recorded as untested.
- [x] FP-66 created/verified in future sprint 338; immediate exemption work deferred.
- [x] Review cleanup changes, preserve needed FP-63 work as WIP feature commits, discard already-published Docker duplicates, consolidate instructions and preserve historical evidence.
