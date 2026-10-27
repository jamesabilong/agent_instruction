# FP-58 initial review, verification and publication — October 27, 2026

Historical polling-only publication checkpoint. The later [WebSocket upgrade and current source/verification](fp-58-websocket-upgrade-2026-10-27.md) supersede the heads, transport and counts below; original evidence is retained.

The user authorized final gap review, remaining verification, commits/pushes and PR creation. Seller inquiries and user-to-user messaging are reviewed and published for review. No blocking code finding remains after the corrections below. Jira stays In Progress; no merge, production deployment, data/configuration change or live pilot enablement occurred.

| Repository | Published branch / exact commit | PR / base |
| --- | --- | --- |
| Backend | `FP-58` / `46c31dbd76ddd4e94876d2dd2145f606ab5ea7dc` | [#65](https://github.com/jamesabilong/fresh-price-backend/pull/65), `master` |
| Frontend | `FP-58` / `cc78dac391970a171b34b9176f3a15c4ba26f7d9` | [#61](https://github.com/jamesabilong/fresh-price-front/pull/61), `master` |

Both app PRs are OPEN, ready for review, MERGEABLE/CLEAN, with exact accepted heads. GitHub lists no checks/reviews; absent checks are not a CI-pass claim. They include the still-open FP-57 prerequisites, backend [#64](https://github.com/jamesabilong/fresh-price-backend/pull/64) and frontend [#60](https://github.com/jamesabilong/fresh-price-front/pull/60). Merge FP-57 first, then deploy migration/backend support before FP-58 frontend. Documentation likewise builds on [FP-57 notes #2](https://github.com/jamesabilong/agent_instruction/pull/2). Feature-branch pushes do not trigger the production master deployment.

[Current API/schema/privacy policy and screenshots](fp-58-messaging-2026-10-27.md), [sanitized exact-source/test/rehearsal manifest](../evidence/fp-58-review-publication-2026-10-27.json). Initial [uncommitted acceptance evidence](../evidence/fp-58-local-acceptance-2026-10-27.json) is historical and does not describe the published heads.

## Review and corrections

Reviewed all 23 FP-58 app files across migration/models/constraints, current actor and participant authorization, canonical identity and concurrent locks, send receipts/sequences, notifications, history/read state, account-wide blocking/suspension, reporting/audit privacy, route/auth/state boundaries, polling, stale responses and deployment controls.

Three focused corrections were made before committing:

- Seller/offer navigation now invalidates a pending contact response as well as account/session changes. A delayed response cannot navigate to the previous seller's conversation. The regression asserts the actual router location.
- Conversation refresh checks its lifetime after metadata and during incremental paging; closing the page does not initiate a follow-on private history request. The regression resolves metadata after unmount and verifies no history call.
- Seller profile UUIDs are canonicalized before matching locked profiles, accepting valid uppercase identifiers consistently with PostgreSQL and route validation. A real HTTP/PostgreSQL regression verifies canonical conversation reuse.

Added simultaneous opposite-direction conversation starts to the database suite, verifying one conversation and exactly two participants. Browser checks now send HTML-like text between actual sessions and assert literal text with no injected elements or script execution. Existing protections for lost/concurrent retries, post-commit notification failure, stale roles, cross-mode blocks, suspension, monotonic read cursors, anonymized history and report-time bounded/audited access remain verified.

## Final verification

| Check | Result |
| --- | --- |
| Backend ordinary units, including 12 messaging rules | 197 passed; zero skips |
| Frontend ordinary units, including ten messaging cases | 281 passed; zero skips |
| Real PostgreSQL/HTTP messaging suite | 51 passed; zero skips |
| Development Chromium desktop/mobile scenarios | 10 each / 20 passed; zero skips/page errors |
| Frontend lint, TypeScript and production/PWA build | Passed |
| Committed production-image browser scenarios | 10 each / 20 passed; zero skips/page errors |
| Production-image operational/source/recovery checks | 15 passed; cleanup verified |

Ordinary acceptance total is 549 (197 + 281 + 51 + 20), with the production-image pass recorded separately. The final focused UI run also passed ten cases after strengthening the navigation assertion. Database evidence: `testing/.local/fp58_1793098172142_07434c/summary.json`. Development browser evidence: `testing/.local/fp58_1793098104033_80e57f/summary.json`; its earlier database phase has 49 cases, superseded by the final 51-case run. Unit/lint/build logs: `testing/.local/fp58-review-{backend,frontend}-checks.log`.

Production-built isolated rehearsal: `testing/.local/fp58_deploy_1793098436018_4abfaa/summary.json`, using clean canonical Git archives of the exact app commits above and production Dockerfiles/nginx from Docker `6b5ce18c9c6df7db60b01233f180c23046a522e4`. No tests, local environment files or runtime credentials were copied into build contexts. Backend/database used an internal Docker network; only nginx was bound to loopback.

- Populated synthetic migration 43 → 44 preserved exact accounts, markets, products, official prices, seller profiles and offers; all 44 migrations were present.
- Real Secure/HttpOnly browser sessions verified seller and peer conversations, privacy, retry, block/suspension, literal text, report resolution/audit, history/unread and disabled-write retained history through production nginx on desktop/mobile viewports. Production worker/manifest cache policies passed.
- Full PostgreSQL/backend/nginx restart preserved exact collected synthetic records, including messages, blocks, reports, audits and notifications. Fresh actual login and private history read passed; disabled messaging still rejected new sends.
- Full collected-data dump/restore into a second owned database matched every public table and all 44 migrations. The actual backend then served that restored database, with real login/history and disabled-write denial verified. This is synthetic recovery coverage, not a restored production backup or atomic upload snapshot.
- Authentication exemptions stayed disabled with zero rules/audits in both browser databases. All owned temporary containers, networks and rehearsal-tagged images were checked and removed. No production service was touched.

One initial rehearsal stopped on a test-harness cookie issue: Playwright's separate request helper omitted Secure cookies on HTTP loopback although the actual browser/app requests succeeded. History/unread checks now use signed-in browser fetch. Secure/HttpOnly session settings were preserved; the complete rehearsal passed afterward. Earlier owned resources were cleaned up. This correction changed external tests only, not the accepted app commits.

Tests, requirements, executable seeders, raw reports and screenshots remain in external workspace `testing/`; executable seeders are generated only under `.local`. Only sanitized manifests and operator documentation are published. The legacy `npm run test:e2e:chromium` alias still refuses FP-58 because it is bound to FP-59; its guard was preserved and dedicated FP-58 runners supply the verification above. Existing React test and Browserslist age warnings remain visible. Expected denied/network scenarios produce console errors; zero page errors is not zero console errors.

## Release and pilot handoff

The isolated production-build/migration/restart/restore verification is complete. No separate staging server exists. Physical devices/on-screen keyboard behavior, other browsers and installed-PWA upgrades are unverified; this pass used Chromium desktop/mobile viewport emulation.

Before an authorized release, merge prerequisite FP-57 and preserve migration/backend-before-frontend order. Keep `FRESHPRICE_MESSAGING_PILOT` and `FRESHPRICE_SELLER_PILOT` disabled until explicit pilot enablement. Peer messaging requires the messaging flag; seller inquiries require both flags and current approved/live-market eligibility. Preserve `AUTH_TEST_EXEMPTIONS_ENABLED=false`.

Before live enablement, name a responsible operator/support contact and limited approved seller cohort. Operators must review only reported cases, respect the twenty-message report-time window and use resolution notes for private follow-up. Either party can block contact across both conversation modes; suspension/disable stops new messages while retaining history. A successful send is persisted before notification; polling can recover a missed alert.

Recovery: disable messaging and retain all six messaging tables plus seller history. Collected-data schema rollback is deliberately refused. Recheck authenticated history and denial of fresh sends after a controlled restart; use the reviewed backup/restore process on a separate recovery target. Actual production deployment, live participant/operator readiness and pilot operations remain open. FP-58 is review-ready, not marked Done.
