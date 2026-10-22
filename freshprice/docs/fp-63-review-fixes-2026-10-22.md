# FP-63 review fixes — 2026-10-22

Publication update (2026-10-22): reviewed fixes are committed/pushed on FP-63 as frontend `7d8e4be4` and backend `9e78c65`. [Publication review](fp-63-publication-review-2026-10-22.md) supersedes earlier uncommitted/WIP status below; no release is claimed.

Sprint 338, Wiki and Shopping Integration, was started at the user’s request on October 22 at 09:17 Asia/Manila. Jira confirms active state and its default two-week end date, November 5 at 09:17. FP-62 and FP-63 remain In Progress; FP-66 remains To Do. [Sprint confirmation](../evidence/sprint-338-started-2026-10-22.json).

## Changes

- Capture the list revision when a purchase form opens. A changed revision removes that form, explains the change, and requires reopening/review with cleared actual values. API submission retains the reviewed revision; uncertain operation retries remain frozen.
- Store the purchase-time budget link in purchase_details. GET list resolves each saved expense for its author and exposes purchaseHistory `{available,budgetLink}`; older purchases recover the original target from the immutable operation receipt. Shared history requires current budget access. Deleted or moved expenses and revoked/deleted shared budgets show unavailable history. Personal history remains accessible after the current budget is removed. List retargeting never changes purchase history navigation. Shared URLs encode scheduledBudgetId.
- Multiply stored two-decimal quotes and six-decimal quantities with BigInt, including exact gram conversion. Round each positive item cost half up once to integer centavos, then aggregate cents before returning currency values. Missing/stale/unit/range checks retain unknown totals.

No schema migration is required; the budget snapshot extends existing JSON. Deploy backend before frontend so purchaseHistory is present; the frontend safely shows unavailable history when omitted.

## Verification

- Runner/fixture/report checks: 41 pass.
- Frontend lint and production build pass; 298 units across 53 files pass.
- Backend: 232 pass, 23 existing database-gated skips.
- Controlled actual Chromium/React/API-client regression passes: retarget refresh removes the composing confirmation; renewed review submits the new revision; shared history uses the original shared target. This uses Axios fixture responses, not real API/database acceptance.
- Expanded the existing 12 registered feature scenarios with real concurrent market/item refresh invalidation, exact half-cent and g/kg basket sums, purchase history before/after retarget, legacy receipt recovery, revocation and deleted expense checks. Existing whole-app regression count stays 30.
- Full default acceptance execution `2026-10-22T01-14-23-757Z-08e0bb2d` failed during setup for both groups: Docker daemon unavailable. Docker info also failed outside the sandbox; the outer Docker.app launcher failed. A subsequent authorized start through the existing nested Docker Desktop.app succeeds; Docker Engine 28.3.3 is available. This supersedes the runtime blocker; see follow-up acceptance below.

Local tests/probes/reports remain under testing/ outside app repositories. Earlier October 20 DB/browser evidence applies to the older source snapshot. Changes are uncommitted and unreleased; FP-62 editorial/inventory and dependency/release gates remain open.

## Follow-up full acceptance

The user authorized starting the sprint and restoring Docker. The existing nested launcher `/Applications/Docker.app/Contents/MacOS/Docker Desktop.app` starts successfully; Docker Engine 28.3.3 responds. No reinstall, factory reset, volume deletion or production changes were required.

Dedicated migrated PostgreSQL service probes pass stale-revision rejection, one shared expense versus zero personal expenses, and exact 1.005 kg × PHP 1.00 = PHP 1.01. The full database integration runner passes all 36 checks with both database gates enabled and no skips.

First complete attempt `2026-10-22T01-19-02-189Z-d38faf14`: feature 10/12, whole-app 30/30. Both feature failures were harness defects: the new rounding setup attempted POST for an existing market-product-unit price (correctly rejected 409), and an older recipe browser assertion assumed UUID-dependent ingredient order. Corrected setup to PUT the exact unit’s price and scoped the ingredient assertion to its named article. No cases removed, correctness assertions weakened or timeouts increased; no application source changes during these runs.

Final complete execution `2026-10-22T01-22-57-267Z-8b453ff2`: feature 12/12 and separate whole-app 30/30, zero JUnit failures/errors/skips, confirmed from both report XML files and the latest execution summary. Both groups migrate/seed their own disposable local PostgreSQL and exercise real APIs/Chromium; whole-app also builds the production PWA preview. This supersedes earlier Docker-blocked and partial execution status.

[Sanitized acceptance evidence](../evidence/fp63-acceptance-2026-10-22.json). Source/config fingerprint: `a4c53171b0ce757b9b762066156d320cf64afee53255caddbfdc638a30500ab3`. Local HTML reports: testing/reports/runs/2026-10-22T01-22-57-267Z-8b453ff2/{feature,whole-app}/html/index.html. Synthetic fixture acceptance does not establish production content approval or deployment readiness. Changes remain uncommitted and unreleased.
