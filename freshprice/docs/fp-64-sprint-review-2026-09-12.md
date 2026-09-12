**FP-64 — UX and data update: sprint review and roadmap integration**

Reviewed 2026-09-12 through Atlassian Rovo and the local FreshPrice repository. This updates the local feature plan. Jira issues were read, not modified. Source: [FP-64 — UX and data update](https://fresh-price.atlassian.net/browse/FP-64).

FP-64 is an epic. Its three child tasks are also the three issues in the active **Data proliferation** sprint (ID 335, board 1), scheduled September 12–October 10, 2026, Manila time. The sprint goal is empty. All three tasks are To Do, Medium priority, unassigned, and have no description, acceptance criteria, subtasks, or linked dependencies in the fetched detail. No estimates were returned. These are planning gaps, not proof the features are infeasible or late.

**Mandatory and optional scope**

| Jira task | Classification | Roadmap mapping | Proposed outcome |
| --- | --- | --- | --- |
| [FP-55 — WIKI creation](https://fresh-price.atlassian.net/browse/FP-55) | Mandatory | M08–M10, Update 2 | Improve the existing wiki's publication quality and import review, inventory coverage, and publish a reviewed pilot batch. |
| [FP-43 — Create maintenance screen](https://fresh-price.atlassian.net/browse/FP-43) | Mandatory for planned maintenance/release readiness | M12; deliver alongside Update 2, earlier if a maintenance window is needed | Users receive an honest, recoverable maintenance experience when the application or its API is temporarily unavailable. |
| [FP-56 — Online data web scraping](https://fresh-price.atlassian.net/browse/FP-56) | Optional automation; mandatory safeguards if selected | O10 after M08/M10 | Collect one bounded batch from one approved source into a review queue. Treat collection as draft input, with explicit publishing by an editor. |

Mandatory means needed for the selected release's quality or operability. Scraping is optional because reviewed manual/CSV imports can achieve the initial coverage goal. It should not hold up the first useful wiki release. Seller accounts and chat retain their existing optional classification.

**Issues to resolve before implementation**

1. **FP-55 overlaps functionality already built.** Public product/recipe wiki pages, admin editing, publication state, sources, revisions, suggestions, and CSV import exist. Implement the missing quality and coverage workflow rather than estimating this as an entirely new wiki. Suggested scope label: “Wiki quality, coverage and editorial workflow.” Existing production adoption/coverage still needs measurement.
2. **FP-56 does not specify its data domain or source.** Wiki text, recipes, and market prices require different mappings and checks. The current draft assumes wiki source material first; confirm before building the collector. If prices are intended, create a separate workflow with canonical product, market, unit, currency, observation date, collection date, and source identity. Collected prices must enter review and must not silently replace approved market prices.
3. **Scraping before review controls would multiply the current quality problem.** Source and substantive content are optional today, and new admin authoring defaults to published. Complete server publication checks and draft import staging before an automated collector can write candidate content. Preserve existing published content unless a reviewed change is approved.
4. **A maintenance page alone cannot protect writes or work during an API outage.** Define planned maintenance versus unexpected failure, which routes remain readable, and how protected writes receive a retryable response. Serve the fallback from the frontend/edge without depending on the unavailable database. Test recovery in installed PWAs so a cached maintenance page does not linger. Static fallback cannot help if the edge/host itself is unreachable; a separate hosted status page is optional.
5. **The sprint has no measurable commitment or dependency order.** Assign an owner/reviewer and estimate the bounded outcomes before treating October 10 as a delivery commitment. Avoid combining “build a crawler,” “populate all content,” and “rebuild a wiki” into three broad tasks. No team-capacity or velocity evidence was supplied, so schedule feasibility is unassessed.
6. **Updates 0 and 1 need their own release verification.** The new epic does not include budget/security tickets. Preserve those release gates, particularly migrated PostgreSQL concurrency and staging access checks, while wiki content preparation runs independently. Do not mark the budget work deployed based on local code or mocked browser tests.

Evidence for existing wiki behavior: `fresh-price-front/src/features/admin/wiki/ProductWikiManagementPage.tsx`, `fresh-price-front/src/features/public/wiki/`, `platform-backend/src/apps/freshprice/services/productWikiService.js`, and the original audit's A08/M08–M10. Maintenance/crawler features were not found in the reviewed FreshPrice paths; this is not a production inventory.

**Proposed acceptance criteria**

FP-55 / mandatory:

- Produce a coverage inventory with canonical product ID, missing/draft/published/needs-review status, completeness, source, reviewer, and review date. Count eligible active products before announcing a coverage percentage.
- New authoring and imports start in draft. The server rejects publication without useful category-appropriate content and traceable source provenance. Existing sparse pages are flagged for review, not automatically unpublished.
- Imports preview new/update/unchanged/error rows and meaningful changes; preserve product/alias matching and revision history. Errors identify the row and corrective action.
- Publish an initial 25 reviewed product pages, or all eligible products if fewer. Include a summary, buying and storage guidance where applicable, with claims checked against sources. Record reviewer/date and verify wiki-to-price navigation on mobile and desktop.
- Re-running the same import creates no duplicate canonical product pages. Review draft→publish, correction, and permission-denial flows in staging.

FP-43 / mandatory baseline:

- Provide a lightweight, accessible static page explaining temporary unavailability, what remains usable, and how to retry. Show a return time only when it is known.
- Choose an operations-controlled enable/disable mechanism and document exactly which frontend/API routes it affects. Reject affected writes consistently; do not present failed writes as saved. Health checks and the operator recovery path remain usable.
- Verify deep links, active forms, offline/online transitions, and the installed PWA through enable→maintenance→disable. Recovered users can retry safely without duplicate writes or being trapped by stale cached content.
- Record a tested recovery procedure. Automated maintenance scheduling, rich status dashboards, and a public incident subscription service are optional extensions.

FP-56 / optional one-source pilot, required if launched:

- Name the first source, intended fields, allowed reuse/access, source-specific collection limits, and responsible reviewer before implementation. Prefer a supported feed/export/API when available. No access-control bypass is in scope.
- Store source URL/title/publisher, retrieval time, source revision/hash where available, canonical product match, import-run ID, and review status. Keep collected input separate from public content; use safe text/HTML handling.
- Bound pages/rows, request timeouts, retry attempts, and request rate. Provide a stop control and a run summary. Restrict destinations and redirects to the intended public sources so a collector cannot become an internal-network fetch endpoint.
- Stage a small fixture-backed batch, show field changes, report ambiguous matches, and prove that rerunning it neither duplicates entries nor overwrites reviewed edits silently. Handle source format changes and partial failures visibly.
- Measure usable reviewed records and reviewer effort, not simply fetched row count. Expand only after the pilot demonstrates benefit. There is no automatic publishing in this scope.

**Suggested delivery sequence**

1. Finalize Updates 0/1 release checks; independently define FP-64's goal, owners, data domain, and first source.
2. FP-55 quality gates and coverage inventory (M08), plus the FP-43 maintenance baseline (M12).
3. FP-55 draft import/diff workflow (M10), then reviewed content batch (M09), followed by relevant M11 staging checks.
4. FP-56 one-source ingestion pilot (O10) as a stretch item after the staging/review contract works. Broader crawling, price collection, scheduling, and automatic enrichment are separate follow-ups.

Suggested sprint goal: **“Publish a useful, sourced wiki pilot with a reliable review/import workflow and tested maintenance recovery.”** The original sprint dates are retained as planning context, not a new estimate. No Jira status, sprint, assignment, or issue description was changed.
