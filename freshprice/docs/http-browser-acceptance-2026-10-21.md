# HTTP/auth and browser/proxy acceptance — 2026-10-21

Release follow-up: FP-59/60/61 are now deployed and [final live read-only checks pass](fp61-deployment-2026-10-21.md). Device/installed-version testing was user-waived. This report retains the original isolated-run scope and limits; earlier pending release requirements below are historical. Test-only harness/fixture sources are retained locally in `testing/operations/release-2026-10-21/`, outside instruction/app Git repositories.

Status: **34/34 HTTP/auth groups, 21/21 browser assertion groups and 3/3 backend-down proxy checks pass**. Independent fresh restored copies were used for each exact candidate. All fixture/baseline preservation and production identity/health/temporary cleanup checks pass. Previous 50 direct-service cases remain separate evidence.

## Verified candidates and results

| Candidate | Frontend / backend | HTTP groups | Browser groups | Proxy failure |
| --- | --- | --- | --- | --- |
| FP-59 | `101a8342` / `e4fe0bc2` | 10/10 | 5/5 | Pass |
| FP-60 | `3372481b` / `e8b7f785` | 11/11 | 7/7 | Pass |
| FP-61 | `0d100ab5` / `1d1fa169` | 13/13 | 9/9 | Pass |

Sources were exported from published Git objects, with full source/dist/nginx/harness hashes verified before remote execution. All three frontend production builds pass with `VITE_API_BASE_URL=/api` and matching installed dependency lockfiles. Each cached backend runtime matches 263 installed production dependency versions against its candidate lockfile; actual candidate CLI migrations ran before fixtures. App source and primary dirty FP-63 work were not edited.

HTTP checks cover real routing/validation, secure opaque-cookie login/logout, malformed/expired auth, bearer compatibility/cookie precedence, operator/self restrictions, account isolation, viewer/transfer contracts, credentialed CORS, response codes and FP-61 `draftAccountId`/receipt conflicts/deleted replay. Cache/MIME checks cover worker, manifest, HTML and hashed assets; missing assets do not fall through to the SPA.

Browser assertions cover real Secure/HttpOnly cookie login, actual UI expense save and reload with exact server totals, viewer history and write-control restrictions, 390×844 viewport layout, rendered confirmed financial shares, post-install worker control/no cached API requests and ordinary 401 redirects/private-history removal. FP-60/61 additionally verify UI logout. FP-61 verifies offline UI draft persistence over a real offline reload, zero database booking while offline, same-account sign-in retaining the failed draft, explicit retry producing exactly one expense plus one receipt and the expected ₱433 total, and explicit logout purging IndexedDB drafts before a different account signs in. Shared-budget scenarios use synthetic history because the original backup contains zero scheduled budgets.

After every browser phase, stopping only the scratch backend produced nginx JSON 503 with no-store and Retry-After 60 while `/healthz` stayed healthy. Each candidate's synthetic fixture cleanup matched every baseline table hash and restored the scratch sequences consumed by fixtures. Final independent readback confirms production definitions/task/image identities unchanged and PostgreSQL/backend/frontend healthy, with no run-labeled containers, volumes or networks remaining. No merge, deployment, production migration/restart/firewall change or stage/commit/push occurred.

## Isolation design

A fresh restore of the verified protected checkpoint was used for each candidate. PostgreSQL had no network and shared only a disposable Unix socket with the backend. App/proxy containers shared an **internal** Docker bridge with outgoing access blocked. The initial standalone loopback publish request did not accept connections on this internal network; health was verified at the isolated nginx private address and the task's localhost SSH forward was retargeted directly there. No public endpoint or database port was opened. The corrected rerunnable script omits port publishing entirely and emits the verified private proxy address. No production environment/database volume was provided; recurrence/source scanning were explicitly disabled.

The exact published production nginx config served the compiled candidates and proxied real API calls. A localhost-only SSH forward and temporary local HTTPS terminator exercised Secure cookies without changing the deployed config. Browser requests were limited to this local origin. The disposable self-signed certificate was trusted only in isolated Chromium, not the system trust store. Public certificate trust, Cloudflare and the host's real Caddy path were not exercised. Physical phones, storage eviction and old-to-new installed-version upgrades with pending work remain separate gates.

The runner paused at `BROWSER_READY` with a 15-minute bound per phase; each candidate advanced only after live browser inspection/assertions. Ownership-labeled cleanup ran at completion. The SSH forward, local TLS helper and all acceptance browser sessions were closed; the disposable TLS key/certificate were removed. Private server logs, signing secrets and full source fingerprints remain in the protected checkpoint.

Fixture namespace is checked empty before seed and uses explicitly synthetic accounts (`http-acceptance-*`), never production credentials. Private logs/JWT secret/cookies remain local or in the protected remote checkpoint; do not print them into reports. The backup has no scheduled budgets; shared scenarios are synthetic on restored schema/data.

## Recovery details and evidence

Initial browser-harness issues were corrected without application source changes: local test-certificate trust for service workers; normal post-install reload before asserting worker control; visible-element selection for the recovery overlay's responsive sync-center copies; waiting for logout's server response rather than the preceding route change; refreshed semantic summary targeting during recurring UI hydration.

In the combined offline/session-invalid scenario, the recovery center displayed “Sign in again to sync this draft.” Its visible **Try again** action led to login, which showed the same-account retained-draft notice. Same-account sign-in and **Retry draft** then synced once. Automatic navigation from that unavailable overlay was not established and is not claimed as passing. Ordinary invalid-session navigation from the available app did redirect and clear private history on all three candidates.

Safe [HTTP/proxy evidence](../evidence/http-acceptance-2026-10-21.json) and [browser evidence](../evidence/browser-acceptance-2026-10-21.json) list actual case results and exact identities. Screenshots are in workspace `output/playwright/http-acceptance-2026-10-21/`. Protected run: `/var/backups/freshprice/fp-restore-20261021T011813Z-1873577/http-acceptance-20261021/runs/fp-http-20261021T024251Z-1911130/`, including checksums and a retained safe browser summary. These are assertion groups with overlapping coverage, not a count of unique end-to-end user journeys.

This clears the declared isolated HTTP/auth/browser/nginx acceptance scope. Full merge readiness still requires actual-device/installed-upgrade evidence and disposition of the recorded PostgreSQL exposure; final deployed image/digest/live edge checks belong to the ordered release runbook.
