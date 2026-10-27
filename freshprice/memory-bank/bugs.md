# FreshPrice Bugs And Risks

Current as of 2026-10-27. Historical findings and their original status are preserved in [the archive](archive/bugs-through-2026-10-21.md). Do not treat old “unfixed” or “not deployed” entries there as current without checking the later resolution.

- FP-58 final review: fixed stale seller/offer navigation, a history request after unmount and valid uppercase seller UUID rejection. Account-wide blocks/sorted locks and report-time privacy remain verified; 51 PostgreSQL/20 browser and full unit checks pass. Exact committed production images pass migration, restart, all-table synthetic restore and 20 browser scenarios. Backend #65/frontend #61 are review-ready; no blocking code gap remains. Physical-device/keyboard, other browsers/PWA upgrade and live release/pilot remain unverified; FP-57 prerequisite PRs are still open. [Evidence and limits](../docs/fp-58-review-publication-2026-10-27.md).

- FP-57 unreleased candidate: cascading-account-deletion and removed-market report findings are corrected. Public market/product eligibility, private history and owner controls pass real PostgreSQL/browser regressions. User-accepted isolated staging/deployment checks now pass production images, cold restart and full synthetic restore; no blocking final PR finding. Merge/deployment/live-pilot readiness remain separate, with production pilot/exemptions disabled. [Final review/evidence](../docs/fp-57-final-verification-2026-10-27.md), [policy](../docs/fp-57-seller-pilot-2026-10-27.md).

- October 27 local Docker startup correction: observed socket failures match the vendor's Windows lifecycle defect in old Desktop 4.48. Applied the official signed in-place update to 4.97.0/Engine 29.9.2. Two complete stop/cold-start cycles, including normal executable launch, pass without manual socket cleanup; no new startup errors. All 6 containers/39 volumes/23 images preserved, isolated image execution and Compose validation pass. Full Windows reboot at 1:38 PM also verified: original socket issue did not recur; initial info-query timeout cleared on follow-up, and both one-time tasks were removed. Abrupt-power-loss recovery remains untested. [Fix and evidence](../docs/docker-startup-fix-2026-10-27.md).

- October 26 Windows reconciliation: the earlier uncommitted search fixes/test assets were missing here and have been reconstructed with fresh available-suite/DB/browser checks. Docker Desktop's preexisting inaccessible inference/secrets runtime sockets prevented engine startup; preserving both runtime-only directories and restarting restored Engine 28.5.1. Compose validation passes; no project database or Docker data reset. [Current evidence, backups and limits](../docs/windows-continuation-2026-10-26.md).

- Released October 27: global price search, PhilWatch page navigation and the input/race/recovery fixes are merged through backend #63/frontend #59/PhilWatch #3. All deployment workflows, fresh 511 local checks and public API/browser smoke pass; populated production and SSH-host limits remain explicit. [Release and verification](../docs/search-pagination-deployment-2026-10-27.md).

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
