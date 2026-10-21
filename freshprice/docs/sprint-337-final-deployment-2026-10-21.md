# Final deployment checklist — 2026-10-21

FP-59/60/61 and Docker security changes are released. Final live read-only verification passes; device/installed-upgrade testing was explicitly waived, not passed. See [the authoritative final release record](fp61-deployment-2026-10-21.md) and [current open work](../memory-bank/todo.md). The shared client-IP/rate-limit issue is separately tracked by FP-66 and is not resolved by the release.

This dated record is retained for audit/recovery context. Older “pending”, “unmerged”, “not ready” and superseding interim statements below describe their original checkpoints. Do not repeat completed merges or deployments from this history.

<details>
<summary>Completed release checklist and intermediate checkpoints</summary>

Final execution update: FP-59/60/61 and Docker security changes have been released. [FP-61 final verification passes](fp61-deployment-2026-10-21.md): expected running digests, four healthy services, 38 migrations including receipts, preserved DB identity/volume/private access, no public PostgreSQL publication and active guard, public health and worker/manifest cache headers. This supersedes pending release steps below; they remain historical procedure, not instructions to redeploy. Physical-device testing remains waived and no new authenticated production feature writes were performed. Jira completion unchanged.

FP-60 verification complete: [live read-only deployment checks pass](fp60-deployment-2026-10-21.md), including actual runtime image digests, four healthy services, 37 migrations/accounting applied, preserved DB identity/volume and fresh private connectivity, no public PostgreSQL port, enabled guard and public health/cache checks. This supersedes earlier FP-60-verification-pending notes below. Next is FP-61 backend #57, then frontend #55 only after backend deployment verification. Both replacements target master; no merge performed by verification.

FP-61 correction update: old backend #55/frontend #53 are closed. Correct replacements are [backend #57](https://github.com/jamesabilong/fresh-price-backend/pull/57) and [frontend #55](https://github.com/jamesabilong/fresh-price-front/pull/55), explicitly targeting master with unchanged tested heads and clean prospective merge trees identical to their tested candidates. FP-60 replacement PRs are now merged to master, but their production deployments must be verified before starting FP-61. Release FP-61 backend #57 and verify before frontend #55. No new merge/deployment performed while correcting the PRs.

FP-60 recovery update: original backend #54/frontend #52 merged into FP-59 and did not change master or trigger deployment. Replacement PRs are [backend #56](https://github.com/jamesabilong/fresh-price-backend/pull/56) and [frontend #54](https://github.com/jamesabilong/fresh-price-front/pull/54), both OPEN/CLEAN/MERGEABLE and targeting **master**. Fresh prospective merge trees exactly match unchanged tested FP-60 candidates. Use these replacements, backend first with verification before frontend; older PR numbers in historical execution notes are superseded. Neither replacement has been merged by the agent.

Execution update: Docker #25 and both FP-59 PRs are merged; deployments #70/#71 and read-only runtime/database/security verification pass. See [FP-59 deployment evidence](fp59-deployment-2026-10-21.md). This supersedes the pending Docker/FP-59 steps below. FP-60 is next: retarget/review both PRs, release backend #54 and verify before frontend #52. No authenticated production feature write smoke test was performed by this verification.

Backup/restore, candidate migrations, isolated service/HTTP/browser/proxy checks and current public-interface PostgreSQL mitigation pass within recorded limits. The user waived physical-device/installed-version upgrade testing; it is untested, not passed. Recheck final refs/review requirements immediately before each merge. FP-62/63 are excluded.

## Preflight

1. Merge [Docker #25](https://github.com/jamesabilong/fpdocker/pull/25), security commit `5b42640`, to master. GitHub requires a PR; the dedicated branch is published, master is not updated yet. This repository push/merge alone does not dispatch deployment. Do not rerun the fresh-install guard helper on the current VPS: the guard is already installed/enabled.
2. Refresh the protected production checkpoint if writes since the tested backup require a newer recovery point. Retain recoverable current image digests, service specs, environment and upload/config backup. Never print credentials into logs or Git.
3. Keep the live `freshprice-postgres-guard.service` enabled; confirm it is active. Verify intended maintenance/scheduler settings and `BACKEND_IMAGE_TAG`/`FRONTEND_IMAGE_TAG` overrides so full-stack reconciliation does not reintroduce an older backend. The deploy workflow pulls fpdocker master automatically; no separate manual stack deployment is required.

## Serialized app releases

Each app master merge automatically triggers the app workflow and downstream Docker build/deploy. Use merge commits; do not batch merges. Builds consume default-branch source at execution time and mutable latest tags. Wait for the intended source/image and completed healthy deployment before the next merge.

| Order | Merge to master | Expected backend migration checkpoint |
| --- | --- | --- |
| 1 | [FP-59 backend #53](https://github.com/jamesabilong/fresh-price-backend/pull/53) | October 19 migrations 000001, 000002, 000003 |
| 2 | [FP-59 frontend #51](https://github.com/jamesabilong/fresh-price-front/pull/51) | Verify roles, viewer restrictions, transfer/recurrence |
| 3 | [FP-60 backend #56](https://github.com/jamesabilong/fresh-price-backend/pull/56) | `20261019000004-budget-accounting.cjs` |
| 4 | [FP-60 frontend #54](https://github.com/jamesabilong/fresh-price-front/pull/54) | Verify splits, balances, confirmed payments/reversals/history |
| 5 | [FP-61 backend #57](https://github.com/jamesabilong/fresh-price-backend/pull/57) | `20261020000001-expense-mutation-receipts.cjs` |
| 6 | [FP-61 frontend #55](https://github.com/jamesabilong/fresh-price-front/pull/55) | Verify offline drafts, same-account recovery, replay deduplication/logout privacy |

After FP-59 backend/frontend land, retarget both FP-60 PRs from FP-59 to master and review final diffs/heads. After FP-60 backend/frontend land, retarget both FP-61 PRs from FP-60 to master and review again. Preserve prerequisite branches until dependent PRs are retargeted. Follow applicable independent-review rules; author-account comments are not independent approval.

Backend deployment automatically runs migrations before updating the backend. Do not add a second manual migration step to the normal workflow. Record migration status from the actual running backend container after each backend release.

## Verify every release

- Both triggering app and downstream fpdocker workflows succeeded for the intended release. Compare the actual running image digest with the intended published image, and record the app SHA plus Docker workflow SHA. A healthy rolled-back old image is not success.
- Swarm services/tasks and container health are healthy; updates are complete, not paused or rolling back. Run on the VPS:

```sh
cd /var/projects/freshprice/fpdocker
docker stack services freshprice
docker service inspect freshprice_backend freshprice_frontend --format '{{.Spec.Name}} {{.Spec.TaskTemplate.ContainerSpec.Image}} {{if .UpdateStatus}}{{.UpdateStatus.State}}{{end}}'
docker service ps freshprice_backend --no-trunc
docker service ps freshprice_frontend --no-trunc
curl --fail --silent --show-error --max-time 20 -H 'Cache-Control: no-cache' https://freshprice.philwatch.com/api/platform/db/health
```

- After the **first frontend deployment**, full-stack reconciliation applies Docker #25's removal of PostgreSQL publishing. Monitor PostgreSQL tasks and DB readiness; confirm the data volume is preserved, both FreshPrice and PhilWatch are healthy, and `docker service inspect freshprice_postgres --format '{{json .Endpoint.Ports}}'` no longer lists port 5432. Preserve the firewall guard. Do not use `task restart` or remove volumes.
- After frontend releases, purge only `https://freshprice.philwatch.com/sw.js` and `https://freshprice.philwatch.com/manifest.webmanifest` from Cloudflare. Verify worker `Cache-Control: no-store`, manifest MIME/cache headers, origin/public HTTPS health and the relevant feature smoke checks. Physical-device upgrade testing remains waived.
- Stop the release sequence on failed migrations, paused updates, wrong image versions or failed feature/health checks. Inspect diagnostics before continuing. Preserve financial history and mutation receipts; prefer a compatible forward fix over destructive migration undo. Database restore is a coordinated recovery operation with writes stopped and post-backup writes reconciled, not routine rollback.

Record final SHAs/digests, migration inventory, workflow links, checks and the device waiver before closing tickets. Full recovery/context: [release runbook](sprint-337-release-audit-and-runbook-2026-10-20.md), [PostgreSQL security execution](postgres-security-2026-10-21.md).

</details>
