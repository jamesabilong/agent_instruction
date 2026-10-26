# FreshPrice Bugs And Risks

Current as of 2026-10-26. Historical findings and their original status are preserved in [the archive](archive/bugs-through-2026-10-21.md). Do not treat old “unfixed” or “not deployed” entries there as current without checking the later resolution.

## Open: shared gateway authentication limiter identity (FP-66)

A harmless public auth-root GET is logged by Express as Docker gateway `172.19.0.1`, while Cloudflare observes a public client IP. Express trusts one proxy hop; nginx appends its peer and Caddy has no configured trusted client-IP handling. Requests through this route can share authentication/global API rate-limit buckets. PhilWatch's exact public auth path is not independently reproduced yet. No bypass is active. FP-66 now has a complete local forwarding/SSR and disabled-by-default exemption candidate: 9+30 acceptance and 37 real local proxy assertions pass. Actual installed production proxy/CDN/public-client validation and release remain, so the live issue is still open. [Local continuation](../docs/fp-66-controls-2026-10-23.md). Fix trustworthy client identity/spoof resistance before admin-managed account/IP exemptions. [FP-66](https://fresh-price.atlassian.net/browse/FP-66), [investigation](../docs/auth-testing-exemption-2026-10-21.md).

## FP-62/63 deployed and verified

All four reviewed PRs merged and deployment workflows succeeded in authorized backend-before-frontend order. FP-62 runtime/40 migrations and FP-63 backend/41 migrations pass host verification; approved multilingual pilot/two recipes are published and exact public checks pass. Both merged master trees equal the tested FP-63 candidates. Prior FP-63 confirmation/history/centavo findings are resolved and released. [Release record](../docs/fp62-fp63-deployment-2026-10-22.md).

Final frontend/backend runtime/host verification and post-release full isolated restore passed after operator SSH reconnection. Earlier SSH interruptions no longer block release verification. Host maintenance is recorded separately; public health alone was not used to close these gates.

## Operational limits

- October 26 FP-66 readiness: existing noninteractive SSH authentication rejected; installed Caddy/current host/backup and restored-copy migration gates await user-authenticated access. Both sites' public health and local public-CDN/Caddy validation pass, but do not close these gates. [Readiness](../docs/fp-66-readiness-2026-10-26.md).
- Actual app digests were verified against running image IDs; service definitions still use mutable latest tags. Serialize releases and verify the real image after each deployment.
- Device/installed-version upgrades remain user-waived, not passed; live final verification did not mutate authenticated expense/payment/replay flows.
- Backups are retained on the single VPS; off-host recovery/global-role/config redeployment and atomic uploads/DB capture are not certified by current evidence.
- Keep test fixtures outside app repos and never run mutation rehearsals against production. Do not source a production .env in a shell or publish dumps, runtime environment, secrets, cookies or private logs.
- Historical wiki/editorial and older device-specific reports need explicit revalidation when revisited; source fixes, synthetic acceptance and live release verification are distinct evidence.

## Resolved or superseded

- October 23 FP-66 local checks found/fixed populated-textarea labeling and a stale offline-regression ticket mapping. The Next production rewrite now defaults to the Swarm backend; deployment parsing preserves the four new settings and isolates credentials by service. Local tests pass; these changes are not deployed.

- October 22 postboot SSH verification gap closed after operator reconnection. Kernel `6.8.0-147-generic`, services, exact images, 41 migrations, DB preservation/connectivity and active/enabled PostgreSQL guard pass; no failed units or remaining reboot requirement. [Maintenance record](../docs/vps-maintenance-2026-10-22.md).

- Public PostgreSQL publishing removed; independent firewall guard active/enabled, external access blocked and private DB access verified.
- FP-59/60/61 integration/PR-target/deployment blockers resolved. Final live inventory: 38 migrations and four healthy services. [Release verification](../docs/fp61-deployment-2026-10-21.md).
- FreshPrice worker/manifest cache headers now verified correct at the public edge. Older four-hour caching reports are historical; PhilWatch device-specific retirement remains separate.
