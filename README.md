# Workspace agent instructions

Read [AGENTS.md](AGENTS.md) first, then only the documentation for the affected app.

| App | Specification | Current progress | Current work | Open risks |
| --- | --- | --- | --- | --- |
| FreshPrice | [Spec](freshprice/docs/project-spec.md) | [Progress](freshprice/memory-bank/progress.md) | [Todo](freshprice/memory-bank/todo.md) | [Bugs](freshprice/memory-bank/bugs.md) |
| Sugilanon / PhilWatch | [Spec](sugilanon/docs/project-spec.md) | [Progress](sugilanon/memory-bank/progress.md) | [Todo](sugilanon/memory-bank/todo.md) | [Bugs](sugilanon/memory-bank/bugs.md) |
| Portfolio | [Spec](portfolio/docs/project-spec.md) | [Progress](portfolio/memory-bank/progress.md) | [Todo](portfolio/memory-bank/todo.md) | [Bugs](portfolio/memory-bank/bugs.md) |

## Current release and planning

- [October 27 FP-57 seller profile improvements](freshprice/docs/fp-57-profile-improvements-2026-10-27.md): private resumable setup, profile/cover photos, preview, hours/landmark and website/Facebook/Instagram. 538 seller cases plus lint/build, 18 production-built browser/14 operational checks pass; FP-58 messaging regressions also pass. Exact source/evidence and remaining release/pilot limits are linked; production flags/exemptions remain disabled.

- [October 27 sprint closeout](freshprice/docs/sprint-338-closeout-2026-10-27.md): FP-66 marked Done; sprint 338 completed with all 3/3 items Done and no carryover. Sprint 339 Seller and Messaging is active October 27–November 10, FP-57 → FP-58.

- [October 27 FP-57 review/publication](freshprice/docs/fp-57-review-publication-2026-10-27.md): Jira In Progress; reviewed seller pilot and 500-case validation, lint/build pass. Backend #64/frontend #60 are ready for review against master, MERGEABLE/CLEAN. [Policy/API/schema](freshprice/docs/fp-57-seller-pilot-2026-10-27.md). User-accepted staging verification subsequently passed; authorized release and operator pilot readiness remain open, with production pilot/exemptions disabled.

- [October 27 local Docker startup fix](freshprice/docs/docker-startup-fix-2026-10-27.md): signed Desktop 4.97.0 update addresses the known Windows socket-startup defect; two complete stop/cold-start cycles and normal executable launch pass without manual runtime cleanup. Existing containers/volumes/images preserved. Full Windows reboot subsequently passed, with no recurrence of the socket error; the initial checker timeout is preserved alongside successful follow-up evidence.

- [October 27 search pagination release](freshprice/docs/search-pagination-deployment-2026-10-27.md): fresh review found no blocking gap; all 511 local checks, lint/build and isolated browser regressions pass. Backend #63 deployed before frontend #59, followed by PhilWatch #3; all deployment workflows and public search/browser smoke pass. Populated production/SSH-host limits remain explicit. The subsequent Docker startup correction is linked above. [Historical publication](freshprice/docs/search-pagination-review-publication-2026-10-26.md).

- [Isolated populated browser verification](freshprice/docs/populated-browser-verification-2026-10-26.md): ranking/tag/tied pages, current-price UI pages, history/search API pages and populated form/detail checks pass. Historical reproduction of missing PhilWatch page controls and page-local price search; both subsequently released in the October 27 follow-up above. That isolated checkpoint left production untouched.

- [October 26 browser verification](freshprice/docs/browser-verification-2026-10-26.md): checked public sort/search/trends/empty pagination and anonymous login gate pass, no observed console errors/warnings; populated, authenticated and device/PWA coverage limits remain explicit. Exemptions stay disabled.

- [FP-62/63 production release](freshprice/docs/fp62-fp63-deployment-2026-10-22.md): four PRs merged/four deployment workflows succeeded; approved content is published. Final FP-63 runtime/host verification and fresh post-release backup/full isolated restore pass. This supersedes historical unreleased/gate-pending status below.

- [Shared VPS maintenance](freshprice/docs/vps-maintenance-2026-10-22.md): 70 upgrades completed, graceful reboot performed and both public apps/content verified; postboot kernel, database/images, services and guard checks pass after operator SSH reconnection.

- FP-59/60/61 are released. [Final live read-only verification](freshprice/docs/fp61-deployment-2026-10-21.md) is the authoritative release record; intermediate dated audits are historical checkpoints, not instructions to repeat completed deployments.
- [PostgreSQL protection/recovery](freshprice/docs/postgres-security-2026-10-21.md) and [deployment operations](freshprice/docs/deployment.md) describe the inspected single-VPS topology.
- [FP-62 reconciliation](freshprice/docs/fp-62-reconciliation-2026-10-22.md): master conflicts resolved, fresh 13+30 acceptance and 36 gated DB checks pass; paired draft PRs #59/#57 are mergeable. Content/editorial/release gates remain open and FP-63 explicitly depends on these prerequisites.
- [FP-63 current refresh](freshprice/docs/fp-63-refresh-2026-10-22.md): reconciled FP-62 included, conflicts resolved, 12+30 fresh acceptance/36 gated DB checks pass; PRs #58/#56 are mergeable drafts with production gates open.
- [FP-63 publication review](freshprice/docs/fp-63-publication-review-2026-10-22.md): historical pre-release checkpoint; all three earlier findings were fixed and reviewed commits pushed. [Draft PR/dependency audit](freshprice/docs/fp-63-pr-release-gates-2026-10-22.md) retains historical conflict evidence. FP-62/63 were subsequently released and sprint 338 closed October 27.
- [Backend pagination release](freshprice/docs/backend-pagination-deployment-2026-10-26.md): reviewed three corrections, published/merged backend PR #62 and verified its deployment. Exact source/digest, 51 live GETs, read-only list/database comparison, four healthy services/42 migrations/preserved DB/guard/runtime pass; exemptions disabled, zero rules/audits. Accepted 62 integration/271 unit checks include 16 PostgreSQL regressions. Live inventory is sparse; populated edge cases remain synthetic coverage. [Original audit](freshprice/docs/backend-pagination-audit-2026-10-26.md).

- [FP-66 deployed release](freshprice/docs/fp-66-deployment-2026-10-26.md): ordered four-PR merge/deploy plus Docker credential parser #27, Caddy authenticated-edge mode/two real clients/direct-origin checks and final images/migration 42/DB/guard pass. Exemptions remain disabled with zero rules/audits. Protected post-release backup/full isolated restore passes. The subsequent nonempty PhilWatch search 500 is [fixed/deployed in backend PR #61](sugilanon/docs/content-search-fix-2026-10-26.md), with 46 DB/271 unit checks and live public/internal query verification; empty production content limits detail smoke. Device/off-host/atomic-backup limits retained; Jira unchanged. [Policy](freshprice/docs/fp-66-controls-2026-10-23.md).

- [FP-62/63 readiness packet](freshprice/docs/fp-62-63-release-readiness-2026-10-22.md): actual inventory, fresh protected backup/restored-data migration/recovery, candidate service checks and concrete remaining content/scope/release approvals. The inventory had zero recipes at that pre-release checkpoint.

- [FP-62/63 content approval packet](freshprice/docs/fp-62-63-content-pilot-2026-10-22.md): six English/Filipino/Cebuano wiki variants and two sourced English recipes approved by the user against `9172cbd`; subsequently published in the release above.

## What belongs here

Keep instructions, concise current memory-bank files, dated audit records, sanitized evidence, and reviewed operator utilities. Historical memory-bank snapshots live under each app's `memory-bank/archive/`; old pending statuses there do not override current records.

Tests, executable synthetic fixture seeders, build output, browser screenshots, local source exports and temporary certificates belong in the sibling local workspace, not in app repositories or this instruction repository. The October 21 test-only harnesses are retained locally at `testing/operations/release-2026-10-21/`; operational utilities retained here are indexed in [scripts/README.md](freshprice/scripts/README.md). Keep a separate local backup of testing assets.

Never commit production dumps, runtime environment files, credentials, JWTs/cookies, TLS private keys, SSH control sockets or full private server logs. Safe evidence must state its scope, failures/skips and limitations rather than treating every passing synthetic check as a production acceptance result.
