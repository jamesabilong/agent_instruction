# FP-62 wiki enrichment — 2026-10-20

Reconciliation update (2026-10-22): FP-62 conflicts are resolved and full fresh tests pass; paired draft backend #59/frontend #57 are mergeable. FP-63 now explicitly depends on them and still needs its own refresh/retest. [Current reconciliation and gates](fp-62-reconciliation-2026-10-22.md) supersedes earlier FP-62 conflict/no-PR status below. No production release performed.

October 22 current-state update: FP-59/60/61 are released and sprint 338 is active. FP-62 feature source/retained acceptance still match, but master integration conflicts, actual inventory/editorial and delivery gates remain open. [Current check](fp-62-current-check-2026-10-22.md) supersedes historical dependency/sprint status below.

Matching local FP-62 frontend/backend branches start from the published reviewed FP-61 heads (`5e58884f` / `a394105d`). That dependency chain remains unmerged. No commit, push, PR, deployment or production content publication is included in this implementation task. Jira FP-62 is In Progress; its future Wiki and Shopping Integration sprint has not been started or rescheduled.

## Baseline audit and editorial scope

Existing code supports canonical product aliases, published wiki pages, snapshots/revisions, suggestions/import, and paginated published recipes. It had no separate revision-linked editorial language variants or structured seasonal calendar. Aliases remain names attached to canonical product IDs; editorial variants never create products or modify name matching.

An operator-only inventory endpoint and admin coverage table audit the connected environment's product/alias counts, wiki publication/source revision/source links/update timestamp, published recipe counts and current approved variants. Missing sources and dates remain unknown. The real acceptance fixture audit is explicitly a disposable local database, not evidence of production coverage. Run the audit again in staging/production before selecting actual content.

The initial workflow supports English (`en`), Filipino (`fil`), and Cebuano (`ceb`). Notes can contain summaries, buying/storage/cooking tips and regional seasonality. Nutrition content and automatic ingestion remain outside this increment. No real factual/translated seasonal pilot is auto-populated. A small pilot should be chosen from the environment audit and published by an editor only after checking source authority, exact geography, review date, translation quality and navigation. Synthetic example.test fixtures demonstrate mechanics only.

## Publication and privacy rules

- Immutable proposals live separately from canonical wikis and public variants. Authenticated contributors and operators can submit a private pending proposal; operator review explicitly approves or rejects it. Revision creates a new private proposal, preserving the old approved text until its replacement is reviewed. Rejection never changes public content.
- Each proposal references the source wiki's exact last-approved revision. Canonical editing, approved canonical suggestions and imports advance that revision. Old approved notes immediately fall out of public queries; pending/approved history remains visible to its author/operators with a needs-review flag. A stale proposal cannot be approved. A new submission must reference the current published source. Unpublishing the source removes variants from public results too.
- The composing UI captures the source revision and retains it through refresh. Adopting a newer source requires a separate review confirmation. Moderation approves immutable content and compares the reviewed source again under the same canonical-row lock used by source writes. Concurrent reviewers serialize, and only one approved variant exists per product/language/exact geography.
- Every proposal requires a validated http(s) source URL without embedded credentials and a valid source review date no later than the Philippine calendar date. Seasonal notes/months require geography; calendar months require an explanatory seasonal note. Months are distinct integers 1–12. Empty calendars represent unknown months and are omitted from month browsing, rather than implying year-round supply.
- Recognition is off by default. Only a contributor-chosen display name with explicit consent is public. Public responses whitelist content/provenance/name fields and never return author/reviewer IDs, emails or private review state. Authors can withdraw a name from their own proposal at any status, including after approval. Administrative access does not grant withdrawal for another author.
- Text is rendered as text, not HTML. Drafts and account-scoped contribution lists reset when identity/product changes. This feature is online; it does not use the expense draft queue.

## Discovery

The product wiki offers a reviewed-variant selector with language tags, source/review date and geographic scope, a contribution form/history and a sourced seasonal browser linking canonical wiki routes. The admin editor adds coverage audit and a paginated enrichment review queue. Seasonal browsing filters exact geography (case-insensitive), language and optional month, with SQL-side publication/revision filtering before count/pagination; ordering is stable. Missing calendar data has an explicit unknown message. It is not an availability forecast.

Recipe discovery adds literal title/summary search, case-insensitive difficulty, and a maximum cooking-duration filter. Unknown cooking time does not satisfy a maximum. Publication and filtering happen before stable title/id pagination; legacy array clients remain compatible, and older-server array responses are filtered before local pagination.

## API and schema

FreshPrice product prefix: `/api/freshprice/products`.

- `GET /wiki/inventory` — operator only, connected-environment inventory.
- `GET /wiki/seasonal?locale=en&region=&month=&page=1&limit=10` — public, current approved scoped calendars.
- `GET /:id/wiki/enrichments` — public, current approved variants.
- `POST /:id/wiki/enrichments` — authenticated, rate-limited pending proposal. Accepts optional UUID submissionId for retry deduplication, sourceRevisionId, locale, region, content, months, sourceUrl, reviewedOn, creditConsent and publicName; ignores publication/identity overrides.
- `GET /:id/wiki/enrichments/mine` — authenticated author's proposals, paginated.
- `GET /:id/wiki/enrichments/moderation` — operator review history, paginated.
- `POST /:id/wiki/enrichments/:entryId/review` — operator, action approve/reject/retract; approval and retraction compare sourceRevisionId.
- `POST /:id/wiki/enrichments/:entryId/withdraw-recognition` — author only, clears chosen public name.
- Existing `GET /:id/wiki/recipes` adds q, difficulty and maxCookMinutes while preserving array/paged response contracts.

Migration `20261020000002-wiki-enrichments.cjs` adds `product_wiki_enrichments` (UUID key, canonical product FK, source revision FK, locale/region/content/months/provenance, optional chosen name, review state and private author/reviewer references). Product/source removal cascades; user deletion preserves notes and nulls private references. Partial uniqueness permits one approved product/locale/region variant. Down migration locks and rejects any collected proposal/history. Preserve data; do not drop a used table.

## Local verification and release

Ticket-specific fixtures, units, E2E, inventory artifacts and coverage are under `testing/tickets/FP-62`. The registered feature group contains ten complete real API/PostgreSQL/Chromium scenarios; the separate 30-case whole-app group stays authored under FP-65 with FP-62 fixture identity. Exact results are recorded in that ticket's COVERAGE.md and the memory bank after completion.

Deploy the additive schema/backend before frontend, after integrating the FP-59/60/61 dependency chain. Rehearse publication/source invalidation/import/rollback behavior, run the actual environment audit, and review factual pilot content before publishing it. Keep Jira In Progress until staging, editorial review and release gates are satisfied.

Final local checks pass on unchanged source: frontend lint/build, 275 frontend units (51 files), 203 backend ordinary checks (23 existing opt-in DB skips), 36 runner checks, and all 40 real-data browser scenarios in `2026-10-20T04-07-38-382Z-3f34d7fb` (10 feature plus separate 30 whole-app; zero failures/errors/skips). Source fingerprint: `f47f08c2fe0d52a64cccde9168a346045dbee8a10de9cf8f33c45f5c169e0a2c` (both app src trees and package/Vite/Vitest configs). The initial seasonal replacement bug and whitespace-only difficulty failure were fixed; select-label/login test setup and the inherited offline expectation were corrected before complete rerun. No assertion/timeout reduction or successful API response mocking.

## Review-fix verification

All three pre-commit findings are now resolved; see `fp-62-review-fixes-2026-10-20.md` for definitive behavior, new migration 20261020000003 and final evidence. Drafts survive collapse/in-flight saves; operator retraction preserves history and removes only its variant; identity-bearing submissions safely retry uncertain responses. Current verification supersedes the initial snapshot above: lint/build, 278 frontend units, 206 ordinary backend checks (23 existing opt-in DB skips), 36 runner checks and complete 13 feature + 30 whole-app cases pass in `2026-10-20T07-44-39-173Z-1ee9ee93`. Source fingerprint `77731ccf52fd57486183cc8a199465a671fd77a4bb7032bd4452ba54ec45008b`. Both migrations/schema/backend precede frontend; used identities/retraction history cannot be discarded on rollback.
