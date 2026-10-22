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

## Open: FP-63 integration/release gates

Draft backend #58 and frontend #56 target master but both are CONFLICTING/DIRTY: backend package.json and frontend vite.config.ts. Both include unreleased FP-62, and older feature configurations omit master’s reconciled testing commands/module aliases. Preserve those master fixes during integration and rerun tests on the actual result. No CI checks are attached; existing acceptance certifies feature heads, not a resolved merge. Target content/editorial and migration/release gates remain open. [Audit](../docs/fp-63-pr-release-gates-2026-10-22.md).

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
