# Backend pagination fixes — production release, October 26, 2026

Reviewed, committed/pushed, merged and deployed the three pagination corrections through [backend PR #62](https://github.com/jamesabilong/fresh-price-backend/pull/62), in the order explicitly authorized by the user. **AUTH_TEST_EXEMPTIONS_ENABLED remains false**, with zero rule and audit rows. Production verification passes; the sparse live inventory limits below remain explicit. No schema, dependency, credential, Caddy or exemption change was needed.

[Sanitized release evidence](../evidence/backend-pagination-deployment-2026-10-26.json), [original audit/regression coverage](backend-pagination-audit-2026-10-26.md), [previous search release](../../sugilanon/docs/content-search-fix-2026-10-26.md).

## Review and delivery

No blocking review findings. Confirmed escaped/static SQL construction, full-set ranking before LIMIT/OFFSET, selected rank alias compatibility with Sequelize's inner/outer query, preserved public/private visibility and vote/author/rank privacy, complete tag hydration/distinct counts, future-timestamp safety and unique tie-breakers. No authentication/identity/exemption source was modified.

All three source files and four external test-file hashes match the accepted audit evidence: **62 integration-suite checks and 271 units pass**, zero skips, including **16 new actual PostgreSQL regressions**. Syntax/diff checks pass. These passing checks were retained on byte-identical reviewed source rather than rerun solely because Git publication changed. Tests remain in the required external local `testing/` workspace; no fixture/test executable was published in app/instruction Git.

- Candidate: `5b6c4de376be459167f741170d4a32b4f03f7323`, branch `fix/backend-pagination-audit`.
- Merged to master: `51784fa1e9dc51c54828f60e3341e4592c610b86`; merged tree equals reviewed candidate.
- Source dispatch workflow `40274749807` succeeded.
- [Docker deployment 40274759279](https://github.com/jamesabilong/fpdocker/actions/runs/40274759279) succeeded using Docker `6b5ce18c9c6df7db60b01233f180c23046a522e4`; checkout of the intended backend merge was verified in protected logs.
- Published digest matches the actual running backend image: `sha256:e3449516c4b9763c6c8b733b7b91c72d65b4aeda0dad87a73e8aaca03cab9d82`.

Backend changed files are `src/services/communityService.js`, `src/apps/sugilanon/services/contentService.js`, and `src/apps/freshprice/services/marketPriceService.js`; all three shipped SHA-256 values match the reviewed audit evidence. Community hot/top now ranks the eligible set before pagination, tag filters preserve other public tags, and community/content/source/current/history lists have a unique final ID order. Envelopes, primary sort fields and permission checks remain intact.

## Production verification

Prechecks passed before merge: four healthy services, migration 42, preserved database identity/volume and fresh private connectivity, enabled/active PostgreSQL guard, matching Caddy active/file configuration, authenticated-edge mode and disabled exemptions in both the service and protected file. Rule/audit counts were zero.

Final checks confirm:

- Four healthy services and exact published/running backend digest. PostgreSQL/frontend/PhilWatch actual images and service specifications are unchanged; backend specification changed only image/force-update.
- Protected application/Caddy runtime files, Caddyfile and systemd drop-in hashes are unchanged. Caddy active JSON equals its environment-adapted file; authenticated-edge mode remains active. No service credential was printed, exported or included in Git.
- Database identity/volume, all 42 migrations and fresh private DB connection are preserved. PostgreSQL is unpublished and its independent public-interface guard is active/enabled. Final exemption rules/audits remain **0/0**.
- **51 public GET checks** through FreshPrice and PhilWatch pass: first/second page prefixes versus a wider page, duplicate-row/count checks for all community sorts and current/history prices/public articles, public author/hidden/rank-field checks, search/SSR/app/DB/auth readiness, plus anonymous 401 denial for exemption management and content/source admin routes.
- An actual backend-image process confirmed `current_setting('default_transaction_read_only') = 'on'` before comparing service results to read-only database queries. Community ranking/page order and public visibility match; public/admin content, source-draft and price-list page prefixes match their exact SQL sort. The restricted server reader's nonempty searches pass, while auth with that credential remains 403.

The comparison harness initially assumed Sequelize SHOW results had normal SELECT nesting and stopped at its read-only check before list evaluation. Replacing that check with SELECT current_setting confirmed read-only mode and allowed all comparisons to finish. This was a verification-only repair; application source/digest did not change. Raw diagnostics remain private.

## Inventory limits and rollback material

Both public domains report **one visible community post**, no visible tagged posts, no public articles, no current prices and no price-history rows. The live checks establish SQL/API execution, ordering of available rows, empty-page metadata/privacy and protected runtime preservation. They cannot establish populated multi-post ranking, tag hydration or tied multi-page behavior on this live inventory. Those cases pass the 16 isolated PostgreSQL regressions on the exact shipped source. No production fixture, post, vote, price, article or login exemption was created to fill coverage gaps. Private admin/source lists were compared inside the read-only host process; their content/IDs were not exported or published.

The release retains ordinary offset pagination; concurrent data/vote changes can reorder independent requests and no snapshot/cursor contract was added. Existing accepted physical-device/PWA, same-VPS/off-host/global-role/config recovery and non-atomic uploads/database snapshot limits remain unchanged.

Protected pre-update service/configuration metadata is at `/var/backups/freshprice/pagination-release-20261026T053046Z`. The prior same-day migration-42 full isolated restore checkpoint `/var/backups/freshprice/fp-restore-20261026T041156Z-2388254` remains available; no new schema/configuration backup was required for this backend image change. Previous backend digest is retained in the protected service checkpoint and [search release record](../../sugilanon/docs/content-search-fix-2026-10-26.md). Any later authorized rollback must preserve current runtime/exemptions=false and audit history. No migration down, trust widening or exemption enablement is a recovery shortcut.

## Commands and publication

```sh
git -C platform-backend commit -m 'fix: rank community posts before pagination and stabilize list order'
git -C platform-backend push --set-upstream origin HEAD:refs/heads/fix/backend-pagination-audit
gh pr create --repo jamesabilong/fresh-price-backend --base master --head fix/backend-pagination-audit --title 'fix: correct ranking and stabilize paginated backend lists' --body-file /private/tmp/pagination-release-20261026/pr-body.md
gh pr merge 62 --repo jamesabilong/fresh-price-backend --merge --match-head-commit 5b6c4de376be459167f741170d4a32b4f03f7323
gh run watch 40274759279 --repo jamesabilong/fpdocker --exit-status --interval 20
```

The PR is attached to the task. Exact intended checkout/digest/source, protected service/config comparisons, read-only SQL/API checks and final health gates are recorded in the linked sanitized JSON. Raw workflow logs, private verifier scripts and protected runtime inspections stay outside Git. Current FreshPrice/Sugilanon progress/todo/bugs and agent instructions are updated for this deployed state. No Jira transition was performed.
