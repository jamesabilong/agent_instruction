# Search and pagination — review and publication, October 26, 2026

> Historical publication checkpoint. The app PRs were reviewed, merged and deployed on October 27; see the [current release record](search-pagination-deployment-2026-10-27.md).

The user requested a fresh gap review followed by commits, pushes and PRs for global current-price search and PhilWatch search pagination. The [Windows continuation](windows-continuation-2026-10-26.md) records the restored baseline and Docker recovery. This review tests the actual API contracts and concurrent UI behavior beyond that first acceptance pass.

[Sanitized final evidence and ten verified source hashes](../evidence/search-pagination-review-2026-10-26.json).

## Findings fixed before publication

- **Blank PhilWatch searches returned a false outage.** The new helper sent explicit `q=` while the content route accepts an omitted query and rejects an explicitly empty trimmed value. Omit blank/whitespace-only query values, retain pagination metadata and verify initial/cleared searches against a stub enforcing the actual validator contract.
- **Overlong PhilWatch searches returned a false outage.** Bound the form to the API's 120-character contract and validate direct URLs locally with a specific length message instead of making a failing API request. Retain server-only restricted reader requests and generic messages for real dependency failures.
- **Price page numbers could race a new search.** Disable numbered page controls while loading, matching Previous/Next. This prevents an old page selection from being applied to a new, smaller result set.
- **A shrinking price result set could strand the current page.** Recover once to page one with all filters/query retained, under the same request sequence. A newer search wins over a late recovery response, a failed recovery remains retryable, and a new list request clears the prior global list error.
- **Unsafe price offsets could reach PostgreSQL and return 500.** Bound page integers and reject unsafe computed offsets with 400 before querying. Preserve ordinary pagination, limit capping, search/filter combinations and the adjacent price-history path using the same helper.
- **Overflowing product/market IDs could return 500.** Bound current-price identifiers to the existing PostgreSQL INTEGER model range; the exact maximum remains accepted while overflowing values return 400.
- **NUL in a price query violated literal search semantics.** Sequelize rewrote this unsupported PostgreSQL text input; reject it explicitly with 400 instead of silently changing the search.

External regressions reproduced the boundary/race failures before the fixes. Tests remain in the sibling local `testing/` workspace according to repository instructions; application PRs do not contain executable fixtures, private logs or generated test output.

## Final verification

No unresolved blocking finding remains in the changed paths. Final checks on the committed source pass:

| Gate | Result |
| --- | --- |
| FreshPrice ordinary units | 263 passed, zero skips |
| Backend ordinary units | 173 passed |
| Backend real loopback HTTP/mocked-persistence and adjacent APIs | 34 passed |
| Real PostgreSQL 14 + HTTP search boundaries | 14 passed, zero skips; 42 migrations |
| PhilWatch focused helper/page tests | 27 passed |
| FreshPrice lint and production build | Passed |
| PhilWatch lint and complete production webpack build | Passed |
| FreshPrice Chromium with mocked APIs | Nine scenarios each on desktop/mobile; 17 requests per view; zero page errors/unexpected network |
| Built Next + synthetic HTTP API Chromium | 25 articles across 12/12/1 pages; blank/length/Unicode/input/page/outage cases pass; zero console errors/warnings or external requests |

Every owned browser/app listener and disposable database container was removed and cleanup verified. The PostgreSQL suite used an owned fresh local database, never an existing Compose database. Final accepted DB evidence remains local at `testing/.local/search-pagination-20261026/reports/search_1793018533517_7001bc/results.json`; PhilWatch browser evidence is `testing/.local/philwatch-search-browser-1793018549753/result.json`; price browser evidence is `testing/operations/search-continuation-2026-10-26/output/results.json`.

FreshPrice's existing unrelated React act/Browserslist warnings remain. The restricted Windows token cannot perform all local socket/process operations; accepted browser/DB checks used normal host execution. Default restricted-token Turbopack failed starting its CSS worker; the complete normal-host webpack build passed. One expanded PhilWatch browser assertion initially counted Next's route announcer as an app alert; it was scoped to main content and rerun successfully without source changes. Historical unavailable ticket suites and the branch-gated full FP-59 runner were not claimed as passing.

## PRs and release order

| Change | PR | Exact head | Base |
| --- | --- | --- | --- |
| Backend search and validation | [Backend #63](https://github.com/jamesabilong/fresh-price-backend/pull/63) | `d63bc4aa512fdd4164c54ce2ba3bbc68cb727e75` | `master` |
| FreshPrice global search and recovery | [Frontend #59](https://github.com/jamesabilong/fresh-price-front/pull/59) | `a1d3321f966e53147d4d71f165af335ffbde0cbd` | `master` |
| PhilWatch pagination and input handling | [PhilWatch #3](https://github.com/jamesabilong/sugilanon/pull/3) | `723d5cb4d9d3be86cbae7b9b1356626a5f7bb6fc` | `main` |

All three are OPEN, non-draft, MERGEABLE/CLEAN; live PR reads confirm the exact heads, bases and ten reviewed source files. GitHub reports no checks for these PRs (`statusCheckRollup: []`); that is not a CI pass. The local checks above are the validation evidence. The companion instruction branch `docs/search-pagination-publication` targets `main`.

Remote defaults and release workflow triggers were checked; app feature branch pushes did not dispatch production deployments. No app main/master push, release merge, deployment or production mutation was performed.

Deploy the backend before the new FreshPrice UI: an older backend ignores `q` and cannot supply globally filtered rows/totals. PhilWatch uses its already deployed paginated content API and adds no migration. Creating these PRs does not authorize release merges or production deployment. Keep authentication test exemptions disabled.

## Scope and retained limits

The Docker setup README change from the prior task remains outside these app search PRs. The application PRs contain only their reviewed search/pagination source changes. The instruction PR contains sanitized progress, API-contract and verification records.

Local synthetic PostgreSQL tests, mocked price browser checks and actual Next/HTTP-stub browser checks are separate evidence. They do not establish production runtime state, populated production inventory, authenticated admin mutation acceptance, other-browser/device/PWA recovery or substring-search performance at scale. Existing offset pages do not provide a cross-request snapshot during concurrent changes. Several historical ticket suites are absent from the restored Windows testing workspace; historical larger counts are not claimed here.
