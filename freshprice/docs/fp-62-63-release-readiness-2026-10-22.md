# FP-62/FP-63 release readiness — 2026-10-22

Current release gates for FP-62 backend #59/frontend #57 and FP-63 backend #58/frontend #56. This record supersedes their earlier pending inventory/backup/migration gates. No production feature write, migration, merge, restart or deployment was performed. All four PRs still target master, are drafts and report MERGEABLE/CLEAN; no review approvals or hosted checks are attached.

## Actual production content inventory

Read-only SQL against the database used by the running application confirms 38 deployed migrations, 113 canonical products, 115 aliases, 113 wiki pages (all published), 113 approved revision records and **zero recipes, including zero published recipes**. Every published page has a last-approved revision and primary source URL. Source timestamps are October 13, 2026; a timestamp is not a factual/editorial approval. Primary source domains: FDA 75 pages, FoodSafety.gov 18, USDA FSIS 20. No FP-62 variants or FP-63 lists exist yet because their schema is unreleased.

Coverage is present for canonical starter pages, not for reviewed English/Filipino/Cebuano variants or regional seasonal calendars. Source links alone do not establish translation accuracy, local growing months or completeness. Unknown seasonal months must stay unknown. Recipe-to-shopping currently has no real published recipe to offer; synthetic recipes are mechanics evidence only. The user has now approved two real recipe drafts; publish them during the authorized rollout before treating recipe-to-shopping as populated. Approval alone does not change the live zero-recipe inventory.

### Content approval completed

The [content approval packet](fp-62-63-content-pilot-2026-10-22.md) contains six exact English/Filipino/Cebuano proposals for actual Pechay (product/source revision 1) and Lettuce (9), plus two sourced recipe drafts: Cabbage Comfort (parent product 7, four servings) and Tomato and Cucumber Salad (parent product 22, twelve servings). Sources were checked October 22; attribution, quantities, instructions, unknown timing, canonical-name/alias checks, unsupported measures and explicit reviewer decisions are documented there. Recipe text is English because the current recipe schema has no locale field. No automatic translation records, regional months, price assumptions or source images are proposed.

On October 22 the user explicitly approved all six language proposals and both recipes exactly as documented in commit `9172cbd38e25d305540b661633f33790a1f17a8c`. The pilot/recipe editorial gate is complete. This is user approval, not a claim of independent translation certification or kitchen testing. The approved content remains unpublished; production publication will be part of a separately authorized rollout. Source revisions and exact aliases must be rechecked before submitting. Months remain empty; this general-handling pilot does not establish seasonal-calendar coverage. The live zero-recipe inventory is unchanged by preparing the drafts.

## Fresh protected backup and recovery

Protected VPS checkpoint: `/var/backups/freshprice/fp-restore-20261022T060313Z-2598048`, root-only permissions. Captured a fresh consistent PostgreSQL custom dump, live uploads, runtime configuration and service/image identities. Database size: 12,488,027 bytes. Restored into a disposable cached PostgreSQL 14 container with network none, no ports, bounded resources and no production mounts. Full normalized schema, COPY row multisets and sequences match after dump/restore; checksums pass; restored migration count 38. Production container identities, service specifications and health remain unchanged. Scratch container and volume were removed.

Scope remains on-VPS recovery; owner/ACL normalization is intentional. Backups/configuration/logs stay protected and are never committed. Live uploads were copied while the app remained online, so this is not an atomic DB/filesystem snapshot. Off-host disaster recovery, global roles and rebuilding a lost VPS/configuration are not certified. Release owner must accept these limits or require a separately designated protected off-host recovery target before release.

## Exact candidate migration and post-migration recovery

FP-62 backend `cf33ab22e737788e8d187c2ac1b7135e80d19c9a`; FP-63 backend `dffc65f0e13e49472394585073258716bf87d630`. Exported exact Git migration bytes and verified SHA-256 manifests; FP-62's shared two migrations are byte-identical in both candidates.

On a separate restored copy, applied enrichment `20261020000002`/`00003` (38→40), then shopping `00004` (40→41). All 42 original tables/570 rows and baseline sequence values were preserved after every migration. Empty reverse down/up returns the exact original column inventory, rows, migration metadata and sequences, then reapplies cleanly. Synthetic private actors/history prove all three used-data down guards reject destructive rollback. A new post-migration dump, including synthetic proposal/retraction/list/item/operation history, restores to an identical schema/data/sequence state: 46 COPY blocks/578 rows. Cleanup passes; production remains unchanged and healthy.

This is restored-production-data migration/recovery evidence. Synthetic history is explicitly additional test data. A populated production rollback must use compatible code/data-preserving repair or a separately approved recovery procedure, not dropping used feature tables.

## Acceptance evidence and limits

Full local PostgreSQL/API/Chromium acceptance remains passing on the exact published candidates: FP-62 feature 13 + whole-app 30; FP-63 feature 12 + whole-app 30, all zero failures/errors/skips. Both have 36 gated DB checks passing without skips; lint/build/normal units/runner checks are recorded in their reconciliation/refresh records. Those browser fixtures are synthetic, not production backup content.

Additional exact-source service verification uses a fresh restored snapshot for each candidate, cached Linux runtime dependencies checked against each full production lock tree, network none, Unix socket only, no production .env/uploads/network, no server/scheduler startup. Synthetic accounts exercise moderation/public privacy, source invalidation, retry, name withdrawal, retraction and unknown calendars; shopping checks exercise ownership, stale revisions, check-off without expense, unknown estimates, purchase idempotency/history and scaled recipe snapshots. Each run verifies every original restored row is unchanged. Final fresh run `fp-services-20261022T061357Z-2606949` passes FP-62 **10/10** and FP-63 **15/15**, with 263 installed production dependencies matching each exact candidate lock. [Sanitized evidence](../evidence/fp62-fp63-release-readiness-2026-10-22.json).

The first service setup run stopped before cases because Sequelize specially converts table-list SQL results; the test harness now avoids that conversion. A second run passed FP-62 but misread a Sequelize virtual purchase-history field in the FP-63 assertion; the harness now uses the model getter. No application source/assertion/timeout was weakened. Full candidate service runs were repeated on new restored copies. Protected log export was rejected by automatic approval review; diagnosis used in-place predefined classifications and numeric harness stack positions only, with no log excerpts exported.

Restored-copy direct services complement the complete local browser suite. They do not certify restored-data browser/mobile/PWA flows or physical installed-upgrade behavior. Device waiver for the prior FP-59/60/61 release does not automatically waive these tickets. Approve the combined evidence as sufficient for this release, or designate the additional acceptance/device scope before merging.

## Approvals still required and release order

**Completed:** user approved the exact six multilingual variants and two sourced recipes from documentation commit `9172cbd`. Seasonal claims are excluded; empty months are retained. No repeated editorial approval is needed for this unchanged pilot.

1. **Acceptance/recovery scope:** accept the documented on-VPS/non-atomic-upload/global-role/off-host recovery limits and combined restored-service + synthetic browser evidence, or specify additional protected recovery/acceptance/device checks. None of those unperformed checks is marked passed.
2. **Code review and release authorization:** approve the four draft PRs and authorize serialized production merges. Master merges dispatch deployment. Order: FP-62 backend #59/schema (expect 40 migrations), verify intended actual image/health/API → FP-62 frontend #57 and verify → recheck current source revisions/aliases, publish the approved six variants/two recipes under rollout authorization and verify public content → recheck FP-63 master ancestry/shopping-only diff and changed-source validation → FP-63 backend #58/schema (expect 41), verify → FP-63 frontend #56 and verify. Preserve history and compatible APIs throughout; stop on mismatched revisions, unhealthy services or unexpected migration inventory.

Content approval is recorded from the explicit user message, not inferred from readiness checks. Code review, acceptance/recovery scope and merge/deployment authorization remain open; content publication has not run. Jira remains In Progress. Test harnesses and full private/generated output remain outside app/instructions repositories under local `testing/operations/release-2026-10-22` and the protected checkpoint.
