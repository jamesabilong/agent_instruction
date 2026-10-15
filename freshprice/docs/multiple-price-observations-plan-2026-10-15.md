# Multiple price observations and statistical trends

Date: 2026-10-15
Status: initial operator-import implementation is local on frontend/backend `FP-65` branches (2026-10-15); community ingestion remains follow-up. See `fp-65-implementation-2026-10-15.md` for delivered scope and verification.

## Outcome

An operator can import `Luya 90 120 180` as three distinct observations for the same market, date and unit. Each observation retains its quoted price and optional seller/quality context. Trend charts can show mean, median or mode without overwriting the observations or silently choosing one quote.

Recommended default: median. Users can switch statistics; charts, comparisons, latest-period values and direction badges must use the selected statistic consistently.

## Current constraints confirmed in source

- `MarketProductPriceHistory` has a unique market/product/unit/date key. Historical bulk imports update an existing key.
- `PriceSubmission` also permits only one quote per submitting user/market/product/unit/date; it cannot directly represent an operator's multiple seller quotes.
- History already stores mean/median/min/max and submission counts for some moderated daily publications, but does not retain every contributing quote in that history row or provide mode.
- `getPriceTrend` reads published history prices, computes weekly averages, and compares first/last rows. Multiple markets on one date can therefore supply endpoints rather than two distinct daily aggregates.
- Public trends, signed-in trends, admin previews, product-history views and market comparisons share price services/types. Current market prices and budget estimates are separate consumers that must keep their existing official-price behavior.

## 1. Add observation storage without removing daily history

Create `price_observations` through a Sequelize migration. Store:

- Observation ID, market/product IDs, Philippine business date, supported unit, normalized decimal price and availability.
- Original quoted amount, priced quantity, original note/line, optional seller label and quality/size notes. Unknown seller/quality remains unknown; numbers alone do not establish why quotes differ.
- Source kind, import-batch/line/quote identity, creator, timestamps, review state, and optional linked community submission ID.
- Exclusion/correction metadata so invalid observations can be removed from calculations without losing the audit trail.

Do not impose uniqueness on market/product/date/unit or on the price itself: `90 90 120` can represent three valid quotes. Enforce stable ingestion identities instead. A batch idempotency key plus line/quote identity prevents retries from adding the same import twice, including retries after a lost response. Intentionally importing the same text as a new batch should prompt a possible-duplicate review rather than silently discard it.

Keep existing current-price and daily-history tables as official published prices. Importing observations does not automatically replace official prices or change budget estimates. Any later “publish a statistic as the official daily price” action must be explicit and audited.

Community integration: preserve the current one-submission-per-user editing contract. When a submission becomes eligible for observation trends, link it to exactly one observation; edits/rejection must update or exclude that observation. Never also count the corresponding daily publication as another quote. Implement and test this adapter before including community observations in the public dataset; initial operator imports can ship independently.

## 2. Extend paste-and-review imports

- Expand each numeric quote into an editable observation, grouped under its original source line. `90 120 180` creates three quotes, not one selected value.
- Match a product once per line, then allow per-quote overrides for date, unit, quantity, seller and quality. Batch date headings and market selection remain supported.
- Require explicit interpretation of ambiguous tokens: `70g` may describe a weight; `1/2` may describe quantity. Neither becomes an additional price automatically.
- Require review of each quote's product/date/unit/quantity. Provide bulk application of date/unit only after an explicit operator choice.
- Show normalized saved prices, counts, min/max, mean, median and mode before saving. Preserve repeated quotes; warn about likely accidental duplicates without merging them automatically.
- Submit reviewed quotes with a stable batch key. Return per-quote outcomes and retain failed drafts. Retrying failed or unconfirmed requests must not inflate sample counts.
- Offer a paginated observation list for inspection, correction and exclusion; edits recalculate affected trends.
- Keep existing historical CSV import separate and label it as replacing official daily history. Add a clearly named observation CSV path if needed; never silently reinterpret old CSV files as new observations.

## 3. Define statistical behavior

Eligible observations must be reviewed, active and available. Use normalized prices in integer centavos or exact decimal arithmetic; round results to two decimals for display. Reject invalid/overflow values. Do not silently remove outliers.

Calculate statistics over observations with matching product, unit, date range and market filter. Optional quality filters must be explicit. Mixed/unknown quality is allowed with a visible explanation that quotes may represent different grades. Different units are never combined. Per-piece observations do not imply equal item size; per-sack prices are comparable only when sack size is known/consistent, otherwise show a comparability warning or restrict that comparison.

| Statistic | Rule |
| --- | --- |
| Mean | Sum of normalized quote prices divided by observation count. |
| Median | Middle sorted quote; average the two middle quotes for an even count. |
| Mode | Exact normalized price(s) with the greatest frequency, only if that frequency exceeds one. |

Examples:

- `90, 120, 180`: mean 130; median 120; no mode.
- `90, 90, 120`: mean 100; median 90; mode 90, frequency 2.
- `90, 90, 120, 120`: mean/median 105; modes 90 and 120, frequency 2 each.
- One quote: mean/median equal that quote; label count 1, with no repeated-price mode.

For tied modes, return every tied value in ascending order. UI shows “Multiple modes” and the values; no arbitrary winner. A mode chart has a gap for no unique mode, with a tooltip explaining the missing point. Do not average tied modes or quietly substitute median. A unique mode may still be shown with its frequency/share; it does not imply a majority.

Daily buckets aggregate that day's eligible quotes. Weekly buckets aggregate all eligible quotes in the week, not the daily means/medians/modes. Preserve the existing Sunday week boundary, calculated using Philippine business dates, and label partial weeks. Whole-range summaries aggregate the raw eligible quotes in the requested range.

Across markets, the initial rule is observation-weighted: every quote has equal weight, so a market with more quotes contributes more. Label this rule and show counts per market. Do not imply it is an equally weighted market index, a random sample, or a seller-weighted statistic when seller identity is unknown.

Direction and percentage change compare the selected statistic of the first and last populated buckets at the displayed granularity. Require at least two distinct buckets, valid scalar values and a nonzero starting value. Missing/tied mode endpoints yield “insufficient data”; do not skip backward to imply a current value. Missing dates remain gaps. Keep the current ±2% stable/rising/falling thresholds unless separately changed.

## 4. Add API support and update trend views

Proposed API contracts (to finalize during implementation):

- Operator-only observation import/read/correction/exclusion endpoints under `/api/freshprice/market-prices/observations`, with transactional batch identity handling and normal auth validation.
- Extend the existing trend endpoint with explicit `basis=observations`, `statistic=median|mean|mode`, supported `unitType`, existing market/range filters and an explicit daily/weekly bucket selector. Preserve default published-history behavior for older clients.
- Return additive observation aggregates containing counts, min/max, mean, median, modes, mode frequency, eligibility/provenance metadata and per-bucket trend state. Keep old response fields semantically unchanged.
- Define public responses independently of admin observation responses; do not expose creator identity, raw notes or seller labels through public trends.

Update public and signed-in trends plus admin previews with Median / Mean / Mode controls, unit selection and clear data-basis labels. Retain low/high as range context. Tooltips explain the statistic and show quote counts; handle no data, single quotes, tied modes and mixed quality. Market comparisons and summary cards follow the same selected statistic and period. Ignore stale requests after filter changes.

Keep product-history and current-price displays explicit about official prices versus observations. Preserve direct links, filters and access guards. Use shared calculation helpers/API contracts rather than separate frontend recomputation.

## 5. Migration and rollout

1. Add the observation table/indexes and backend support first; keep old clients working.
2. Leave historical published records intact. Never reconstruct individual quotes, frequencies or mode from a stored average/median or submission count.
3. Backfill eligible, still-retained community submissions only with stable source IDs and known review/eligibility rules; verify no double counting. Treat old official-only history as a separate dataset, not raw observations, and label missing observation coverage.
4. Release the new import and observation management UI, then enable observation trends after verification. Existing imports remain clearly distinguished.
5. Roll back application behavior by disabling the new entry points while retaining collected observations. Do not drop the new table after real observations have been collected without an export/recovery plan.

## Delivery order and acceptance checks

1. Storage and idempotent import API: multiple identical-key quotes survive; retries do not duplicate; unauthorized users cannot write; decimals/dates/units validated.
2. Import review and corrections: pasted examples retain every quote, fractions/weights require interpretation, aliases and unknown names can be resolved, edits/exclusions affect only intended observations.
3. Statistical API: deterministic mean/median/mode fixtures, even counts, repeated/tied/all-unique prices, zero values, differing units, unavailable/excluded observations, mixed quality, uneven market sample sizes, business-date/week boundaries and distinct-date endpoint comparisons.
4. Trend UI: all three choices update daily/weekly charts, summaries, direction and market comparisons; show mode gaps/ties and counts; test mobile and stale requests.
5. Database integration: migration on populated existing tables; preservation of official histories and current prices; atomic batch identities, lost-response retries, edits, exclusions and community adapter deduplication if included.
6. Run frontend lint/unit/build and Chromium regressions, affected backend unit/API tests and real PostgreSQL integration tests. Include existing CSV import, price creation/editing, moderation/publication, product history, public/signed-in/admin trends, and budget pricing regressions.

This plan proposes operator-imported observations first, with community ingestion integrated through the explicit adapter. Seller registries, standardized quality grading, seller-weighted statistics and automatic official-price publication are later scope.
