# FP-59 database and browser verification — October 19, 2026

Continued [FP-59 — Budget feature update](https://fresh-price.atlassian.net/browse/FP-59) on the existing frontend/backend FP-59 branches, preserving the earlier month-end fix and unrelated local documentation edits.

## Result

The repaired normal frontend command `npm.cmd run test:e2e:chromium` completed successfully, execution `20261019135335916_d768b0`.

| Registered group | Passed | Failed/skipped/retried |
| --- | ---: | ---: |
| Restored PostgreSQL model checks | 17 | 0 |
| FP-59 PostgreSQL acceptance | 20 | 0 |
| Chromium desktop, real API/database | 8 | 0 |
| Chromium mobile, real API/database | 8 | 0 |
| Total | **53** | **0** |

Source result: `testing/reports/20261019135335916_d768b0/summary.json`, with raw `legacy.json`, `fp59.json` and per-profile `browser.json` / browser HTML reports. Each database/profile used a fresh migrated PostgreSQL 14 container; browser users logged in through real HttpOnly cookie sessions. No production or application database was used.

Additional fresh validation: frontend 255 unit checks, backend 173 unit checks, 13 restored mocked API checks, 17 recovered mocked Chromium regressions, and 23 test-runner/setup safety checks pass. Frontend lint and production build pass. Mocked auxiliary results are separate from the 53 real registered checks.

## Test setup repaired

- Restored 84 historical files from exact Git snapshots; `testing/historical-restoration.json` records paths, source commits and hashes. Preserved assertions while rewriting relocated imports.
- Fixed Windows test globs, backend dependency identity, validated dependency junction creation and per-run writable temporary directories. Ordinary unit commands now work without shell-specific environment setup.
- Rebuilt `testing/run.mjs` and generated local fixture scripts; both app branches must match FP-59. The cross-platform backend `test:integration:db` and both app E2E commands use this isolated runner. `testing/README.md` documents commands and scope.
- Registered all 37 database and 16 browser cases. Tests cover viewer/owner/contributor access; concurrent permission revocation and ownership acceptance; stale requests/membership; transaction rollback; 205-expense aggregates; independent monthly instances, original month-end anchors, concurrent deduplication, pause/resume/cancel, scheduler recovery across 52 templates, and migration up/down safeguards.
- Browser coverage exercises current budget save/reload/disable, monthly copies, invitations, stale editors, transfer acceptance/former-owner demotion, template privacy and same-tab logout/account isolation on desktop and mobile.
- The first diagnostic run exposed first-visit-guide and selector assumptions in the new harness; these were corrected through actual UI interactions. A subsequent shared-stack run hit the normal API request limit. Each complete browser profile now gets a fresh API/database, keeping rate counters and fixture state independent; application limits were retained.
- Reports have execution identities and cannot reuse stale green results after setup failure. Completion inspects every testcase and rejects expected failures, missing/duplicate/project-imbalanced cases, skips or retries. Cleanup tracks every child, awaits Docker creation, verifies container ownership/ID and reports termination failure.

No additional business-code defect was reproduced beyond the earlier month-end copy bug. That fix is now verified through real persisted desktop/mobile form submissions. No backend business source change was needed.

## Local backup and remaining gates

The local test-source backup contains 118 files, excluding dependencies, generated credentials/caches and reports:

`testing/.local/backups/fp59-test-assets-2026-10-19-d768b0.zip`

SHA-256: `DB525CADE7F331B49B4AF759C3BA5529DC1168B4539D83487CAEBD28F1E67952`.

Later FP-65 unit/integration/whole-app additions were local-only and could not be recovered from reachable or unreachable Git history. The restored suite and new full FP-59 registered scope are explicit; earlier larger historical counts are not presented as current coverage. See `testing/RESTORATION.md`.

Staging smoke and schema/backend-before-frontend release verification remain before delivery sign-off. Jira still reports In Progress. The verification phase performed no Jira write, commit, push, deployment or application database migration. API/schema notes describe the verified FP-59 branch contracts.

## Requested publication — October 19, 2026

Committed and pushed frontend `101a834` and backend `e4fe0bc` to their existing FP-59 branches at the user's request. FP-59 documentation is prepared separately on the instruction repository's FP-59 branch, excluding earlier FP-65 review edits. Local test sources, generated seeders/reports and the source backup remain outside app repositories. These feature-branch pushes do not deploy the apps.
