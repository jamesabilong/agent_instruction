# FP-57 seller pilot — local implementation, October 27, 2026

Status: reviewed, committed and pushed on backend/frontend `FP-57` branches, with draft backend [#64](https://github.com/jamesabilong/fresh-price-backend/pull/64) and frontend [#60](https://github.com/jamesabilong/fresh-price-front/pull/60). [Current review/publication and fresh evidence](fp-57-review-publication-2026-10-27.md). Jira is In Progress; this is not a deployment or staging acceptance record.

## Jira selection

At the implementation-selection checkpoint, live Jira review selected [FP-57 Seller user addition](https://fresh-price.atlassian.net/browse/FP-57), then in future sprint 339, Seller and Messaging. The later user-authorized [October 27 closeout](sprint-338-closeout-2026-10-27.md) marked deployed FP-66 Done, completed sprint 338 (FP-62/63/66 all Done) and started sprint 339 for October 27–November 10. Sequence remains FP-57 → FP-58. The connector is read-only; explicitly requested administrative changes used the signed-in browser. FP-57 was subsequently marked In Progress during review/publication; delivery gates remain open.

## Pilot policy

- An existing account has one seller profile, attached to its unchanged user/admin role. It must select one existing market. The pilot supports up to 200 catalog-product/unit offers per profile.
- Public profile fields: stall name, description, stall location and market. Private contact is available only to the owner and operators; reviewer identities/reasons and reports are excluded from public responses.
- Applications begin pending. Another operator may approve or reject. Approved sellers can be suspended; an operator can restore a suspended seller or reject it. Rejected applicants must resubmit. Suspended owners cannot change their profile or offers. Public-profile edits return an approved seller to pending and hide offers until another review.
- Approval means admission to a manually supported pilot, not certification of goods or pricing. Operators must check contact and market details outside the app and document the reason for each decision.
- Offers contain product, unit, positive PHP price, quantity in that unit, availability, published/archived state, seller-confirmed time and an explicit expiry within seven days. Available stock must be positive. Saving an offer reconfirms it; editing an expired offer requires an explicit new expiry. Public responses include only fresh, available, published offers of approved sellers with an available market/product.
- A deleted market makes a seller ineligible until reapplication with another market. A deleted product removes the offer publicly while retaining private history. Suspension/archival/expiry do not delete historical rows. Restoring approval can expose previously published offers that are still fresh; operators should consider these before restoration.
- Authenticated users can submit private reports. Only one report per reporter/profile may remain open. Operators resolve/dismiss with a private note; they cannot resolve their own report or reports about their own stall.
- Seller data never updates official market prices, price history, FP-65 observations or account roles. Ordering, checkout, payments, delivery and messaging remain outside FP-57.

## Availability and release order

`FRESHPRICE_SELLER_PILOT` is false when absent or any value other than the exact string `true`. Only the disposable local test services enabled it. Public discovery, applications, reports and owner writes return unavailable while disabled; owners can still read retained private history and operators can review/suspend/resolve reports. No bypass or authentication exemption is introduced.

Release requires a reviewed additive migration/backend deployment before frontend deployment. Keep the flag disabled during that process. Enabling an actual pilot requires a separately authorized runtime configuration change and an identified operator/support process. Changing the backend process environment requires its ordinary controlled restart/recreation. Disabling the flag is the immediate reversible stop for public discovery and seller publishing.

Migration `20261027000001-seller-pilot.cjs` adds four tables after the 42-migration deployed baseline. On an empty isolated database, down/up is verified. Down locks seller tables and refuses once collected profile/report data exists; preserve the schema/data and disable the pilot instead. No destructive rollback of collected pilot data is approved.

## APIs and schema

All routes below are relative to `/api/freshprice/sellers`, use private/no-store response headers and standard cookie/Bearer authentication where required.

| Access | Method and path | Behavior |
| --- | --- | --- |
| Public | GET `/config` | Enabled state and seven-day expiry policy |
| Public | GET `/`, `/:profileId`, `/:profileId/offers` | Approved directory/profile and fresh offers; directory market filter and paginated lists |
| Owner | GET/PUT `/me` | Private profile/latest review and application/resubmission |
| Owner | GET/POST `/me/offers`, PUT `/me/offers/:offerId` | Paginated retained history and owned offer writes |
| Signed-in user | POST `/:profileId/reports` | Private report with optional eligible offer reference |
| Operator | GET `/admin/stats`, `/admin/profiles`, `/admin/profiles/:profileId` | Pilot metrics, filtered applications and private details |
| Operator | GET `/admin/profiles/:profileId/reviews`, PATCH `/admin/profiles/:profileId/review` | Paginated audit and reasoned status transition |
| Operator | GET `/admin/reports`, PATCH `/admin/reports/:reportId` | Filtered reports and revision-checked resolution |

List defaults are page 1 / 20 rows; limit is bounded to 100 and page to 1,000,000. Each order ends in a unique ID. Offset pagination is not a snapshot across concurrent writes. Input allowlists, bounded strings/decimals, UUIDs, explicit statuses, optimistic revisions and per-account mutation limits protect new endpoints. Fresh database account/operator checks supplement existing middleware. All owner writes and moderation serialize on the same seller-profile lock, preventing an older open form from bypassing a completed suspension. Profile changes and review audits commit together.

| Table | Purpose and relationships |
| --- | --- |
| `seller_profiles` | Unique user, nullable market reference after removal, public/private fields, status/revision |
| `seller_offers` | Owned profile, nullable catalog product, unique profile/product/unit, bounded price/quantity, state/freshness/revision |
| `seller_profile_reviews` | Transactional submission/review history, nullable actor after account removal |
| `seller_reports` | Private reason, optional offer, nullable reporter/resolver after account removal, resolution metadata/revision; unique open reporter/profile |

Database constraints enforce status, units, stock/price and expiry bounds. Account deletion cascades its owned seller records; other actors become null in retained history. Profile references on child tables are initially deferred so simultaneous profile cascades and actor SET NULL operations cannot fail because of trigger order. A real PostgreSQL regression reproduces the earlier failure and verifies this correction.

UI routes are `/sellers`, `/sellers/:id`, `/user/seller` and `/admin/sellers`, with public, user and operator navigation links. Auth/private state resets on account changes. Visible errors, retry/refresh, state messages, explicit price units and confirmed/expiry labels are provided. User/admin role guards remain unchanged.

## Verification and evidence

External local assets: `D:\Project\Web\FreshPrice\testing\tickets\FP-57\suite.json`, `fixtures.json`, `ACCEPTANCE.md`, backend/frontend specs, `run.mjs` and `browser.mjs`. Executable fixture seeders and raw results remain exclusively under `testing/.local`. Synthetic fixtures use loopback-only, uniquely named disposable PostgreSQL 14 containers; ownership labels/IDs are checked before removal. Authentication exemptions, recurring budgets and outbound content scanning remain disabled.

| Check | Result |
| --- | --- |
| Backend ordinary unit suite | 185 passed, including 12 new seller-rule cases |
| Frontend ordinary unit suite | 271 passed, including 8 new seller UI cases |
| Seller real HTTP/PostgreSQL suite | 30 passed, zero skipped |
| Chromium desktop/mobile seller acceptance | 7 scenarios each, 14 passed, zero skipped/page errors |
| Frontend lint, TypeScript/production/PWA build | Passed |

Database evidence: `testing/.local/fp57_1793083016998_05d61a/database/results.json`. It includes account isolation, stale token roles, self-review, pending/rejected/suspended denial, cross-owner writes, price/unit/expiry validation, full-set offer pagination, stale revisions, deleted market/product behavior, report privacy/deduplication/resolution, cascading account deletion, concurrent offer/suspension, audit rollback, official-price isolation and guarded migration down/reapply. Original cascading-deletion and soft-deletion fixture failures were corrected before the accepted run.

Final browser evidence: `testing/.local/fp57_1793083451789_c9f679/summary.json`, with separate desktop/mobile `browser.json` and directory screenshots. Both groups passed seven scenarios, zero skipped/page errors, and verified cleanup. Actual UI login creates HttpOnly sessions; anonymous protected-route redirects, ordinary-user admin denial, application/reload, operator approval, offer publishing, literal HTML-like text, public privacy, stale-form suspension, report resolution, re-review, directory pagination/filter/recovery and disabled-pilot retained history run against real APIs/PostgreSQL. Mobile directory layout was visually inspected. Existing unrelated frontend tests emit React act warnings; the build reports an old browsers-data warning. These were not treated as seller failures.

The historical `test:e2e:chromium` alias routes to the FP-59-only harness and refuses other feature branches. Its guard was preserved; the registered FP-57 runner above supplies the real Chromium checks for this feature. It is not a claim that the whole historical FP-59 acceptance suite was rerun.

## Remaining delivery gates

- Reviewed/published at the user's request in paired draft PRs; current exact heads and fresh validation are in the [publication record](fp-57-review-publication-2026-10-27.md). Review/merge/release gates remain open.
- Jira asks for staging verification. This project has no staging target; the isolated synthetic local checks do not satisfy an unspecified staging signoff. Obtain an explicit designated non-production target or accepted alternative before marking delivery complete.
- Preserve production backup/recovery and deployment checks; enable a limited live pilot only after operator/support readiness and authorization. No production migration, deployment, fixture, flag, exemption or service changed here.
- Other browsers, physical devices, installed-PWA upgrades, real seller verification and live pilot operations are untested. FP-58 messaging remains pending.
