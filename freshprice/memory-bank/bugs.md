# FreshPrice Bugs And Risks

Current as of 2026-10-26. Historical findings and their original status are preserved in [the archive](archive/bugs-through-2026-10-21.md). Do not treat old “unfixed” or “not deployed” entries there as current without checking the later resolution.

- Confirmed October 26 in isolated populated Chromium: PhilWatch search has no page controls (25 matches, only first 12 reachable in its UI); FreshPrice price search filters only the loaded page (same query returns 0 rows on page 1, 3 on page 2). Backend pages/order/search pass; frontend follow-ups remain open. Next development mode also emitted a nonblocking synthetic-cover image-priority warning. [Reproduction and evidence](../docs/populated-browser-verification-2026-10-26.md).

- Resolved in production (October 26): community page-local hot/top ranking, truncated tag hydration and nonunique content/source/price page order fixed by backend PR #62. Exact image/source, 51 public GET checks, read-only production list/SQL comparisons and shared DB/runtime/guard pass; populated edge cases covered by 16 isolated PostgreSQL regressions. Exemptions disabled with zero rules/audits. [Release](../docs/backend-pagination-deployment-2026-10-26.md).

## Resolved: shared gateway authentication limiter identity (FP-66)

October 26 authorized release is deployed. Caddy 2.11.7 authenticates exact visitor identity on both app proxy paths; two real independent public clients resolve correctly despite forged forwarding/custom headers. Direct Caddy origin uses its socket peer; nginx/Next/backend auth rejects absent/invalid credentials. Migration 42 and scoped service credentials are verified. Exemptions remain disabled with zero rules/audits. [Release/evidence](../docs/fp-66-deployment-2026-10-26.md).

## Resolved: PhilWatch nonempty content-search query

Confirmed invalid joined category/tag aliases inside Sequelize's article pagination subquery. Backend PR #61 uses escaped correlated EXISTS plus per-request include cloning; 10 regressions failed before and all 46 DB/271 unit checks pass after. Authorized merge/deployment `72861ee0` is verified by exact running digest/source, 15 public GET checks, internal reader searches and unchanged protected identity/disabled exemptions. Production search 500 is resolved. [Fix/release/evidence](../../sugilanon/docs/content-search-fix-2026-10-26.md). Empty production content still limits existing article-detail smoke; populated matches were tested only on isolated synthetic PostgreSQL.

## FP-62/63 deployed and verified

All four reviewed PRs merged and deployment workflows succeeded in authorized backend-before-frontend order. FP-62 runtime/40 migrations and FP-63 backend/41 migrations pass host verification; approved multilingual pilot/two recipes are published and exact public checks pass. Both merged master trees equal the tested FP-63 candidates. Prior FP-63 confirmation/history/centavo findings are resolved and released. [Release record](../docs/fp62-fp63-deployment-2026-10-22.md).

Final frontend/backend runtime/host verification and post-release full isolated restore passed after operator SSH reconnection. Earlier SSH interruptions no longer block release verification. Host maintenance is recorded separately; public health alone was not used to close these gates.

## Operational limits

- October 26 FP-66 rollout/identity gates passed with exemptions disabled. Post-release migration-42 backup/full isolated restore and protected runtime checkpoint pass. Existing article-detail inventory limits remain; nonempty-query search is resolved by the subsequent verified backend fix above. [Release](../docs/fp-66-deployment-2026-10-26.md).
- Actual app digests were verified against running image IDs; service definitions still use mutable latest tags. Serialize releases and verify the real image after each deployment.
- Device/installed-version upgrades remain user-waived, not passed; live final verification did not mutate authenticated expense/payment/replay flows.
- Backups are retained on the single VPS; off-host recovery/global-role/config redeployment and atomic uploads/DB capture are not certified by current evidence.
- Keep test fixtures outside app repos and never run mutation rehearsals against production. Do not source a production .env in a shell or publish dumps, runtime environment, secrets, cookies or private logs.
- Historical wiki/editorial and older device-specific reports need explicit revalidation when revisited; source fixes, synthetic acceptance and live release verification are distinct evidence.

## Resolved or superseded

- October 23 FP-66 local checks found/fixed populated-textarea labeling and a stale offline-regression ticket mapping. The Next production rewrite now defaults to the Swarm backend; deployment parsing preserves the four new settings and isolates credentials by service. Local tests pass and reviewed changes are deployed; four parser checks also verify the separate protected FP-66 runtime override.

- October 22 postboot SSH verification gap closed after operator reconnection. Kernel `6.8.0-147-generic`, services, exact images, 41 migrations, DB preservation/connectivity and active/enabled PostgreSQL guard pass; no failed units or remaining reboot requirement. [Maintenance record](../docs/vps-maintenance-2026-10-22.md).

- Public PostgreSQL publishing removed; independent firewall guard active/enabled, external access blocked and private DB access verified.
- FP-59/60/61 integration/PR-target/deployment blockers resolved. Final live inventory: 38 migrations and four healthy services. [Release verification](../docs/fp61-deployment-2026-10-21.md).
- FreshPrice worker/manifest cache headers now verified correct at the public edge. Older four-hour caching reports are historical; PhilWatch device-specific retirement remains separate.
