# Populated browser verification — October 26, 2026

Completed the remaining populated ranking, tag, pagination and search checks using synthetic data in a disposable local PostgreSQL 14 database, actual backend/React/Next.js servers and Chromium. Core query behavior passed. Two existing UI limits were confirmed: PhilWatch exposes no search-page navigation, and FreshPrice price search filters only the currently loaded page. Neither was changed by this verification task.

[Sanitized evidence](../evidence/populated-browser-verification-2026-10-26.json), [prior production browser pass](browser-verification-2026-10-26.md), [deployed backend release and database regressions](backend-pagination-deployment-2026-10-26.md).

## Isolation and source

No production connection, seed, configuration change, deployment or exemption was used. A newly created `populated_browser_test` database was migrated through all **42 migrations** and seeded with synthetic accounts/content only. Its owned PostgreSQL port and all three app listeners were bound to `127.0.0.1`. Test processes used explicit local endpoints and a loopback-only socket/fetch guard; source scanning, recurring jobs and Next telemetry were disabled. Local article covers used the bundled `/globe.svg`; source links used `example.test` and were not followed. No production backup or credentials were needed.

All three Git source trees match their released branch trees: backend candidate `5b6c4de3` (same tree as deployed PR #62 merge), FreshPrice `7d7cfb97`, PhilWatch `8dc1a930`. Exact trees/hashes are in the evidence. Clean tracked sources were archived to local snapshots with installed dependency links; app source was not edited. Fixtures, browser assertions, logs and generated assets remain in local `testing/.local/populated-browser-20261026/`, outside app/instruction Git. Fresh disposable database checks confirmed **zero exemption rules and zero audit rows**; `AUTH_TEST_EXEMPTIONS_ENABLED=false` throughout.

## Browser results

| Checked behavior | Result |
| --- | --- |
| Full-set community ranking | Hot and Top put the older high-score winner first despite 44 newer posts; New starts with the newest post. The hidden higher-score post never appears publicly. |
| Community pagination | Traversed four real UI pages in each of Hot/Top/New: all 70 visible IDs in expected order, no duplicates or omissions, correct disabled boundary controls. Sort changes from the last page reset to page 1. |
| Community tag hydration | Selected-tag filter traversed 45 posts across three UI pages. Each card kept both its selected and companion tag. Changing/clearing filters reset the page and restored the expected set. |
| Tied community rows | Traversed 25 equal-timestamp/score posts across two pages in each sort; unique descending-ID order remained complete. |
| Current market prices | Real Next/Previous UI navigation showed 50 then 10 rows, matching API ordering across all 60 unique rows. Reverse-order price updates preserved the expected unique-ID tie-breaker. Returning to page 1 was stable. |
| Price history | Browser same-origin fetches traversed three real API pages (20 rows each), with 60 unique tied history IDs in expected order. This is API coverage through the browser, not an admin history-screen pagination claim. |
| Populated PhilWatch form search | Eight submissions verified case-insensitive title, summary, body, category-only and tag-only matches, an apostrophe, an unmatched term and SQL-like text. Rendered cards matched API results; drafts were excluded and no query returned 500. |
| Populated search pagination/associations | Browser same-origin API fetches traversed three pages (12/12/1) containing all 25 matching tied articles, each once, each with all three tags and two sources. Public author fields stayed id/username. Category+query returned 24; subsequent global query returned 25, with no filter leakage. |
| Article detail | Followed the first tag-search result to its real detail page; correct heading/body and both source links rendered. |

Community's scripted run observed 28 application responses, all 200, with no console/page errors, warnings or failed requests. Price checks reported no errors/warnings or failed requests. Final PhilWatch checks reported no JavaScript errors, unexpected failed requests or HTTP error responses; expected navigation cancellations were excluded from failed-request assertions. A **nonblocking Next.js development LCP/image-priority warning** appeared for the synthetic `/globe.svg` cover. Preserve this warning as observed; this pass makes no production image-performance claim.

The initial search assertion treated that warning as an error after its functional assertions completed. The harness was corrected to report warnings separately and the complete search sequence passed again. Earlier local setup/CLI mistakes were corrected and failed owned database attempts were removed; these were test-harness failures, not production changes or application fixes. No backend/unit suite was rerun for this browser-only task; its accepted 62 integration/271 unit checks remain separately recorded.

## Confirmed limits and remaining work

- **PhilWatch search has no page navigation.** A tag query matching 25 articles renders only the first 12; the search page reads `q` only and has no Next/Previous controls. API pages 2/3 work and were exercised from the browser, but users cannot navigate them through the search UI. Frontend pagination remains open; do not mark it passed as UI pagination.
- **Price search is page-local.** On page 1, searching `Browser Product 19` rendered “No price records found.”; clicking Next with that same query displayed its three rows on page 2. This confirms filtering of fetched rows rather than search across the complete price set. Global price search remains a frontend/API integration follow-up, not fixed here.
- These are synthetic isolated checks, not populated production acceptance or a restored-production-data rehearsal. Production's sparse-content limits remain. Local socket identity mode/dev servers do not re-certify production Caddy/CDN/SSR trust, exact runtime images, caching or installed PWA behavior.
- Authenticated/admin mutations, administrator/source-list browser pagination, other browsers, physical devices and offline/PWA recovery remain outside this pass. Normal offset pagination still has no cross-request snapshot under concurrent writes. Previously accepted backup/recovery limits remain unchanged.
- Keep exemptions disabled. Do not create production fixtures, publish synthetic content, widen proxy trust or enable exemptions to close coverage gaps.

The isolated browser was closed after checking; owned database/network/apps were stopped and removed after verification. Only sanitized results are published. No app PR, app push, merge, deploy or Jira transition was performed.

## Subsequent local fixes

The [search pagination follow-up](search-pagination-fix-2026-10-26.md) fixes both UI gaps locally and records database/browser regressions. Its app publication/release is pending; this audit remains the historical reproduction, and production inventory/device limits still apply.
