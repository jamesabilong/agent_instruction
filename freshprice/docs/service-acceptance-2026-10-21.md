# Isolated restored-copy service acceptance — 2026-10-21

Release follow-up: FP-59/60/61 are now deployed and [final live read-only checks pass](fp61-deployment-2026-10-21.md). Device/installed-version testing was user-waived. This report retains the original isolated-run scope and limits; earlier pending release requirements below are historical. Test-only harness/fixture sources are retained locally in `testing/operations/release-2026-10-21/`, outside instruction/app Git repositories.

Status: **50/50 declared direct-service cases pass, zero failures**. This records direct backend service acceptance, separate from HTTP/auth middleware, browser/proxy and real-device PWA acceptance.

Follow-up: the declared [isolated HTTP/auth/browser/nginx scope now passes](http-browser-acceptance-2026-10-21.md): 34 HTTP, 21 Chromium assertion groups and three proxy-failure checks. Actual-device/installed-version upgrades and live edge acceptance remain separate; older HTTP-pending notes below describe this earlier direct-service run.

## Candidate identity and isolation

| Ticket | Exact backend candidate | Passed cases |
| --- | --- | --- |
| FP-59 | `e4fe0bc2f0f6c2a5cede18b4bc13ab9691a2ec46` | 9 |
| FP-60 | `e8b7f78595303546a6f846f8074f9ffcfcfef990` | 18 |
| FP-61 | `1d1fa16985330b923cca20631d4e7c2a86a37af2` | 23 |

Exported each candidate's complete `src`, package and lock directly from Git objects, with per-file SHA-256 and Git tree identity. No dirty FP-62/63 source is used. Each candidate runs its own actual Sequelize CLI migrations against a fresh restore of the verified checkpoint `fp-restore-20261021T011813Z-1873577/database.dump`. The cached backend runtime's installed production dependency versions are checked against each candidate lock before execution; no dependency installation or image build occurs.

Both PostgreSQL and service containers use `--network none`, no public ports, bounded memory/CPU/PIDs and a shared disposable Unix socket volume. The app mounts exact candidate source read-only and receives only scratch database configuration. It starts the service harness, not the HTTP server or scheduler; production `.env`, uploads and database volumes are never mounted. Full production service definitions and running task/image identities plus health are compared before/after. Cleanup is restricted to matching per-run ownership labels, including failure paths.

Run: `fp-services-20261021T020324Z-1894192` beneath `/var/backups/freshprice/fp-restore-20261021T011813Z-1873577/service-acceptance-20261021/runs/`. Private logs remain there and are not copied into reports.

All three fresh-copy runs completed with zero failed cases. Each matched **263 installed production dependency versions** against its candidate lockfile using cached Node `v20.20.2`. Actual CLI migrations resulted in the expected 36/37/38 migration inventory for FP-59/60/61. Fixture cleanup restored baseline table hashes on every candidate; scratch sequence counters consumed by synthetic activities were reset and verified. Final independent readback confirmed unchanged production service definitions, original running task/image identities, healthy PostgreSQL/backend/frontend, and no run-labeled temporary containers or volumes. No application defect or failed service case was found; none of the case expectations or source code needed adjustment during the remote run.

Safe local [acceptance evidence](../evidence/service-acceptance-2026-10-21.json) includes every case result, exact source Git trees/heads, harness hash, runtime version checks and cleanup verification. Full per-file source hashes, private logs and SHA256SUMS remain in the protected checkpoint. Source-only local preparation first encountered an older Python tar API and was corrected before upload; this was not a remote test failure. The harness selected unused, high positive fixture user IDs so valid-member service validation and baseline sequences are both preserved.

This clears the declared **restored-copy backend service-flow gate**. The release remains not ready pending HTTP/proxy/auth/browser/PWA device acceptance and PostgreSQL exposure disposition. No merge, deployment, production migration, restart, firewall change, app-source edit or stage/commit/push occurred; primary dirty FP-63 work was untouched.

## Acceptance coverage

- FP-59 surfaces on all three candidates: restored-record read preservation; pending/expired/renewed invitations; viewer totals/history/activity and write denials; contributor CRUD and author/scope enforcement; recipient-only transfer, retry, expiry, former-owner permissions and inviter deletion; monthly date anchors, concurrent deduplication, private empty generated instances and snapshot allocations; template creator ownership after source transfer/deletion, pause/resume/cancel.
- FP-60 surfaces on FP-60/61: neutral unsplit balances, exact PHP 100/3 centavos and zero-sum balances; invalid shares and viewer payer/write denials; counterparty-confirmed corrections; competing split revisions, replay identity and stale edits; payments, reversal, spending independence and overpayment concurrency; removed-member liabilities/denials; tracked deletion/void history; paginated financial history and pending neutrality.
- FP-61 surfaces: concurrent durable create/edit retries; key reuse and revision conflicts; original receipt replay; deletion retaining receipts and preventing recreation; replaced/disabled current-budget identity; role downgrade, membership revocation and deleted target reauthorization; independent mutation progress; actor-scoped mutation-key isolation.
- Every candidate deletes only its tracked synthetic fixtures, hashes all baseline table rows to confirm preservation and restores/checks scratch sequence counters consumed by synthetic activities before the database copy is destroyed.

## Evidence limits

The restored snapshot contains **zero scheduled budgets**. Therefore shared-budget legacy neutrality and lifecycle/accounting flows use explicitly synthetic actors/budgets on the restored production schema, alongside the original data; they do not establish preservation of pre-existing real shared-budget histories. Every original row remains covered by the baseline hashes.

These checks call services directly. They do not certify routing, request validation, JWT/cookie/expired-auth handling, controller-level `draftAccountId`, HTTP status/response serialization, reverse proxy/cache behavior, browser UI, installed-PWA upgrades or physical storage/device behaviour. No production release or migration is authorized by this acceptance run. PostgreSQL exposure disposition remains separate.
