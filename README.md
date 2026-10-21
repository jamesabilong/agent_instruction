# Workspace agent instructions

Read [AGENTS.md](AGENTS.md) first, then only the documentation for the affected app.

| App | Specification | Current progress | Current work | Open risks |
| --- | --- | --- | --- | --- |
| FreshPrice | [Spec](freshprice/docs/project-spec.md) | [Progress](freshprice/memory-bank/progress.md) | [Todo](freshprice/memory-bank/todo.md) | [Bugs](freshprice/memory-bank/bugs.md) |
| Sugilanon / PhilWatch | [Spec](sugilanon/docs/project-spec.md) | [Progress](sugilanon/memory-bank/progress.md) | [Todo](sugilanon/memory-bank/todo.md) | [Bugs](sugilanon/memory-bank/bugs.md) |
| Portfolio | [Spec](portfolio/docs/project-spec.md) | [Progress](portfolio/memory-bank/progress.md) | [Todo](portfolio/memory-bank/todo.md) | [Bugs](portfolio/memory-bank/bugs.md) |

## Current release and planning

- FP-59/60/61 are released. [Final live read-only verification](freshprice/docs/fp61-deployment-2026-10-21.md) is the authoritative release record; intermediate dated audits are historical checkpoints, not instructions to repeat completed deployments.
- [PostgreSQL protection/recovery](freshprice/docs/postgres-security-2026-10-21.md) and [deployment operations](freshprice/docs/deployment.md) describe the inspected single-VPS topology.
- [FP-63 WIP review](freshprice/docs/fp-63-precommit-review-2026-10-20.md) retains three unresolved findings. Its feature branches are backed up, not released.
- [FP-66 planned auth exemptions](freshprice/docs/auth-testing-exemption-2026-10-21.md) include the confirmed proxy-client identity issue. No live exemption has been enabled.

## What belongs here

Keep instructions, concise current memory-bank files, dated audit records, sanitized evidence, and reviewed operator utilities. Historical memory-bank snapshots live under each app's `memory-bank/archive/`; old pending statuses there do not override current records.

Tests, executable synthetic fixture seeders, build output, browser screenshots, local source exports and temporary certificates belong in the sibling local workspace, not in app repositories or this instruction repository. The October 21 test-only harnesses are retained locally at `testing/operations/release-2026-10-21/`; operational utilities retained here are indexed in [scripts/README.md](freshprice/scripts/README.md). Keep a separate local backup of testing assets.

Never commit production dumps, runtime environment files, credentials, JWTs/cookies, TLS private keys, SSH control sockets or full private server logs. Safe evidence must state its scope, failures/skips and limitations rather than treating every passing synthetic check as a production acceptance result.
