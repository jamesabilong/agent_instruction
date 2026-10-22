# FreshPrice Bugs And Risks

Current as of 2026-10-22. Historical findings and their original status are preserved in [the archive](archive/bugs-through-2026-10-21.md). Do not treat old “unfixed” or “not deployed” entries there as current without checking the later resolution.

## Open: shared gateway authentication limiter identity (FP-66)

A harmless public auth-root GET is logged by Express as Docker gateway `172.19.0.1`, while Cloudflare observes a public client IP. Express trusts one proxy hop; nginx appends its peer and Caddy has no configured trusted client-IP handling. Requests through this route can share authentication/global API rate-limit buckets. PhilWatch's exact public auth path is not independently reproduced yet. No bypass is active. Fix trustworthy client identity/spoof resistance before admin-managed account/IP exemptions. [FP-66](https://fresh-price.atlassian.net/browse/FP-66), [investigation](../docs/auth-testing-exemption-2026-10-21.md).

## FP-63: review fixes verified locally, unreleased

Resolved historical findings:

1. P2: an open purchase confirmation can adopt a refreshed list/market/budget/revision without renewed review.
2. P2: a shared purchase links to personal history instead of its immutable original shared budget context.
3. P3: binary floating-point multiplication can round valid half-cent estimates incorrectly.

All three findings have local October 22 fixes and expected-correct regressions. 298 frontend units, 232 backend tests (23 existing DB-gated skips), lint/build and controlled Chromium checks pass. Real PostgreSQL/API/Chromium acceptance now passes 12 feature + 30 whole-app with zero failures/skips; all 36 gated database integrations and dedicated service/database regressions pass. Docker is restored; the reviewed fixes are committed/pushed (frontend `7d8e4be4`, backend `9e78c65`) and remain unreleased. Older purchases recover their original budget from immutable operation receipts; inaccessible/deleted/moved expenses show unavailable history instead of a misleading link. See [current verification](../docs/fp-63-review-fixes-2026-10-22.md). [Full review and reproduction](../docs/fp-63-precommit-review-2026-10-20.md).

## FP-62: integration conflicts resolved; content/release readiness open

FP-62 reconciled master: backend #59/frontend #57 are MERGEABLE/CLEAN, with fresh 13 feature + 30 whole-app acceptance and 36 gated database checks passing without skips. Master portable test tooling is retained. Actual target inventory and fresh restored-backup migration/recovery now pass. Production has zero recipes; the exact six multilingual variants and two sourced recipes in the [approval packet](../docs/fp-62-63-content-pilot-2026-10-22.md) are user-approved against `9172cbd`. Publication is still unexecuted; acceptance/recovery-scope and code-review/release approvals remain open. Seasonal calendars remain outside the approved scope; PRs remain drafts. [Current readiness](../docs/fp-62-63-release-readiness-2026-10-22.md). [Record](../docs/fp-62-reconciliation-2026-10-22.md).

## FP-63: dependency/configuration integration resolved; release approval open

Refreshed FP-63 now contains reconciled FP-62/current master. Backend #58/frontend #56 are MERGEABLE/CLEAN, with fresh 12 feature + 30 whole-app acceptance, 36 gated DB checks, full lint/unit/build and runner checks passing. Initial 2/298 unit timing failures were corrected with an enabled-action wait; application source, correctness assertions and timeouts were unchanged. Actual inventory and refreshed protected-backup migration/recovery pass. FP-62 prerequisite approval, acceptance/recovery-scope and code-review/ordered rollout approvals remain open; pilot/recipe content is user-approved. [Current record](../docs/fp-63-refresh-2026-10-22.md).

## Operational limits

- Actual app digests were verified against running image IDs; service definitions still use mutable latest tags. Serialize releases and verify the real image after each deployment.
- Device/installed-version upgrades remain user-waived, not passed; live final verification did not mutate authenticated expense/payment/replay flows.
- Backups are retained on the single VPS; off-host recovery/global-role/config redeployment and atomic uploads/DB capture are not certified by current evidence.
- Keep test fixtures outside app repos and never run mutation rehearsals against production. Do not source a production .env in a shell or publish dumps, runtime environment, secrets, cookies or private logs.
- Historical wiki/editorial and older device-specific reports need explicit revalidation when revisited; source fixes, synthetic acceptance and live release verification are distinct evidence.

## Resolved or superseded

- Public PostgreSQL publishing removed; independent firewall guard active/enabled, external access blocked and private DB access verified.
- FP-59/60/61 integration/PR-target/deployment blockers resolved. Final live inventory: 38 migrations and four healthy services. [Release verification](../docs/fp61-deployment-2026-10-21.md).
- FreshPrice worker/manifest cache headers now verified correct at the public edge. Older four-hour caching reports are historical; PhilWatch device-specific retirement remains separate.
