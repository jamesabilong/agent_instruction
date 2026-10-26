# Workspace agent instructions

Read [AGENTS.md](AGENTS.md) first, then only the documentation for the affected app.

| App | Specification | Current progress | Current work | Open risks |
| --- | --- | --- | --- | --- |
| FreshPrice | [Spec](freshprice/docs/project-spec.md) | [Progress](freshprice/memory-bank/progress.md) | [Todo](freshprice/memory-bank/todo.md) | [Bugs](freshprice/memory-bank/bugs.md) |
| Sugilanon / PhilWatch | [Spec](sugilanon/docs/project-spec.md) | [Progress](sugilanon/memory-bank/progress.md) | [Todo](sugilanon/memory-bank/todo.md) | [Bugs](sugilanon/memory-bank/bugs.md) |
| Portfolio | [Spec](portfolio/docs/project-spec.md) | [Progress](portfolio/memory-bank/progress.md) | [Todo](portfolio/memory-bank/todo.md) | [Bugs](portfolio/memory-bank/bugs.md) |

## Current release and planning

- [FP-62/63 production release](freshprice/docs/fp62-fp63-deployment-2026-10-22.md): four PRs merged/four deployment workflows succeeded; approved content is published. Final FP-63 runtime/host verification and fresh post-release backup/full isolated restore pass. This supersedes historical unreleased/gate-pending status below.

- [Shared VPS maintenance](freshprice/docs/vps-maintenance-2026-10-22.md): 70 upgrades completed, graceful reboot performed and both public apps/content verified; postboot kernel, database/images, services and guard checks pass after operator SSH reconnection.

- FP-59/60/61 are released. [Final live read-only verification](freshprice/docs/fp61-deployment-2026-10-21.md) is the authoritative release record; intermediate dated audits are historical checkpoints, not instructions to repeat completed deployments.
- [PostgreSQL protection/recovery](freshprice/docs/postgres-security-2026-10-21.md) and [deployment operations](freshprice/docs/deployment.md) describe the inspected single-VPS topology.
- [FP-62 reconciliation](freshprice/docs/fp-62-reconciliation-2026-10-22.md): master conflicts resolved, fresh 13+30 acceptance and 36 gated DB checks pass; paired draft PRs #59/#57 are mergeable. Content/editorial/release gates remain open and FP-63 explicitly depends on these prerequisites.
- [FP-63 current refresh](freshprice/docs/fp-63-refresh-2026-10-22.md): reconciled FP-62 included, conflicts resolved, 12+30 fresh acceptance/36 gated DB checks pass; PRs #58/#56 are mergeable drafts with production gates open.
- [FP-63 publication review](freshprice/docs/fp-63-publication-review-2026-10-22.md): all three earlier findings are fixed and local database/API/browser acceptance passes. Reviewed commits are pushed to FP-63 feature branches; [draft PR/dependency audit](freshprice/docs/fp-63-pr-release-gates-2026-10-22.md) retains historical conflict evidence and points to current refresh/prerequisite/release gates. Sprint 338 is active October 22–November 5.
- [FP-66 deployed release](freshprice/docs/fp-66-deployment-2026-10-26.md): ordered four-PR merge/deploy plus Docker credential parser #27, Caddy authenticated-edge mode/two real clients/direct-origin checks and final images/migration 42/DB/guard pass. Exemptions remain disabled with zero rules/audits. Protected post-release backup/full isolated restore passes. The subsequent nonempty PhilWatch search 500 is [fixed/deployed in backend PR #61](sugilanon/docs/content-search-fix-2026-10-26.md), with 46 DB/271 unit checks and live public/internal query verification; empty production content limits detail smoke. Device/off-host/atomic-backup limits retained; Jira unchanged. [Policy](freshprice/docs/fp-66-controls-2026-10-23.md).

- [FP-62/63 readiness packet](freshprice/docs/fp-62-63-release-readiness-2026-10-22.md): actual inventory, fresh protected backup/restored-data migration/recovery, candidate service checks and concrete remaining content/scope/release approvals. The inventory had zero recipes at that pre-release checkpoint.

- [FP-62/63 content approval packet](freshprice/docs/fp-62-63-content-pilot-2026-10-22.md): six English/Filipino/Cebuano wiki variants and two sourced English recipes approved by the user against `9172cbd`; subsequently published in the release above.

## What belongs here

Keep instructions, concise current memory-bank files, dated audit records, sanitized evidence, and reviewed operator utilities. Historical memory-bank snapshots live under each app's `memory-bank/archive/`; old pending statuses there do not override current records.

Tests, executable synthetic fixture seeders, build output, browser screenshots, local source exports and temporary certificates belong in the sibling local workspace, not in app repositories or this instruction repository. The October 21 test-only harnesses are retained locally at `testing/operations/release-2026-10-21/`; operational utilities retained here are indexed in [scripts/README.md](freshprice/scripts/README.md). Keep a separate local backup of testing assets.

Never commit production dumps, runtime environment files, credentials, JWTs/cookies, TLS private keys, SSH control sockets or full private server logs. Safe evidence must state its scope, failures/skips and limitations rather than treating every passing synthetic check as a production acceptance result.
