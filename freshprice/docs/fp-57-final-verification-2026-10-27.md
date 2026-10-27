# FP-57 final verification — October 27, 2026

Historical baseline checkpoint. The later [seller-profile improvements](fp-57-profile-improvements-2026-10-27.md) supersede setup/media capabilities, candidate heads, migration totals and acceptance counts below. Original evidence and pilot policy remain available.

The user explicitly accepted an isolated local deployment rehearsal as FP-57's staging check. That check passed on the exact published backend `b5fc98a1a2800524363e9ce843012be294029c47` and frontend `db7e0e8cd04b893ae2daafaaf5085c5f2aeb5322`, using production Dockerfiles/nginx from Docker `6b5ce18c9c6df7db60b01233f180c23046a522e4`. This closes the agreed staging-verification requirement; it does not certify a separate staging server, production deployment, real sellers, physical devices or live pilot operations.

[Sanitized rehearsal evidence](../evidence/fp-57-final-verification-2026-10-27.json), [prior 500-case acceptance/source inventory](fp-57-review-publication-2026-10-27.md), [pilot policy/API/schema](fp-57-seller-pilot-2026-10-27.md).

## Results

- Both actual production images built from clean archives of the reviewed commits, excluding local environment files, tests and runtime material. All 22 app blobs still match the accepted publication manifest.
- Populated synthetic PostgreSQL 14 migration 42 → 43 preserved exact account, market, product and official-price fingerprints. All 43 migrations are present afterward.
- Production-built Chromium desktop/mobile acceptance passed 7 scenarios each: 14 passed, zero skipped/page errors. Includes real Secure/HttpOnly browser sessions through the production nginx configuration, protected-route denial, application/reload, approval/publishing, safe literal text/public privacy, stale-form suspension, report resolution, profile re-review, pagination and disabling the pilot.
- Built deployment starts disabled and rejects public discovery/publishing; owners retain private history and operators can moderate. Production worker/manifest cache policies pass.
- Full backend/nginx cold restart preserves exact collected synthetic seller/history/report data and disabled state. Actual login and private offer-history read pass after restart.
- Full collected-data dump/restore into a second owned database preserves row fingerprints and migration inventory. This is synthetic recovery coverage, not a restored production backup or upload consistency claim.
- Authentication exemptions stay disabled, with zero exemption rules/audits. Backend/database use an internal network; only the frontend has a loopback host binding. All temporary containers, networks and rehearsal-tagged images were verified and removed.

Accepted report: `testing/.local/fp57_deploy_1793091079337_9f387d/summary.json`; separate desktop/mobile reports and screenshots are alongside it. Thirteen named operational/source checks and fourteen browser scenarios passed. Earlier failed harness attempts remain local: Windows `git archive` newline conversion was corrected to canonical Git bytes; the rehearsal retains its authentication key across configuration changes; the disabled-write assertion uses actual Chromium cookie handling; the test frontend port remains fixed across restart. No application source change resulted from those harness corrections.

## Final PR review

Reviewed current backend [#64](https://github.com/jamesabilong/fresh-price-backend/pull/64), frontend [#60](https://github.com/jamesabilong/fresh-price-front/pull/60), and documentation [#2](https://github.com/jamesabilong/agent_instruction/pull/2). Application heads remain the exact accepted commits, bases remain master, and no review comments, requested changes, CI checks or merge conflicts were listed. No blocking application gap remains. The prior removed-market report correction is included. GitHub's absent checks are not a CI-pass claim.

PRs can proceed through normal review. Merge, backend/schema-before-frontend deployment, production verification and any live-pilot enablement still require their own authorization. FP-57 stays In Progress while unreleased; its API/code availability control remains disabled by default. Starting FP-58 does not imply FP-57 is deployed.

## Pilot operator checklist

Before an explicitly authorized live pilot, identify the responsible operator/support contact and a small seller cohort. Confirm each applicant's contact, selected market and stall details manually; approval admits them to the pilot and does not certify goods or pricing. Review reasons are visible to the applicant: keep reporter identities and private report details in operator-only report-resolution notes.

Approve/reject with a reason; suspension immediately hides offers and denies fresh owner writes. Restoration can expose still-fresh prior offers, so review those before restoring. Public-profile edits require another review. Offers require explicit quantity/unit/price and expiry within seven days; no automatic renewal. New owner writes and public discovery stop when the seller flag is disabled, while retained private history/operator review remain accessible. Keep the runtime flag persistent through normal controlled deployments/restarts; do not rotate authentication credentials merely to change availability.

Recovery: disable the seller flag, preserve all four seller tables and retained history, and use the reviewed application rollback/backup procedure. Migration down deliberately refuses collected pilot data. Never use a destructive schema rollback or enable authentication exemptions as an availability shortcut.
