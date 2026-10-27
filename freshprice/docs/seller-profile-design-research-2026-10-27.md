# Seller profile design research — October 27, 2026

Status: historical research proposal requested after the seller demo. The user selected implementation of the first delivery phase; see [implemented scope, verification and remaining limits](fp-57-profile-improvements-2026-10-27.md). Gallery/offer photos, public phone and pending-public-revision editing remain future scope. The competitor observations below record the original research date.

## Current FreshPrice gap

The current seller application asks for a public stall name, description, existing market, stall location and private operator contact. Public pages show approved profile text, market/location, available offers and Message seller. The profile model/API has no avatar, cover, seller gallery, operating hours, website or social-link fields. The application is a single submit-for-review form, with no resumable draft or public-preview step. Approved profile edits currently return the entire profile to pending and hide offers until review.

Existing shared image processing supports bounded JPEG/PNG/WebP uploads, actual decoding, resize and WebP output. It is a useful processing foundation, but seller media needs its own ownership, quota, draft/public visibility, replacement and moderation contract. A product upload route is not already a seller gallery. Seller images must not overwrite canonical catalogue images or official prices.

## Comparable profiles and documented capabilities

Public pages and official help were checked on October 27. Rendered extracts can be cached; examples describe observed design patterns, not guarantees of current statistics or endorsement of a seller.

| Reference | Observed pattern | FreshPrice application |
| --- | --- | --- |
| [VintageAndLoverly on Etsy](https://www.etsy.com/shop/VintageAndLoverly) | Shop identity/location, product sections, About, owner photo, policies, Facebook/Instagram/website-labelled links and review history | A recognizable storefront, story, real photos and structured optional links |
| [Etsy About setup](https://help.etsy.com/hc/en-us/articles/115015628487-How-to-Edit-Your-Shop-s-About-Section?segment=selling) | Name/tagline/logo/story, up to five featured photos, team and external links | A short setup flow and gallery; use our own image limits |
| [eBay Store setup](https://www.ebay.com/help/selling/ebay-stores/managing-ebay-shop?id=4090) | Logo, banner, About and shop policies, with preview/publish | Branded header and a buyer preview before submitting |
| [Explore Things on Carousell Philippines](https://m.carousell.ph/u/buyn_sell/) | Profile image, professional-seller label, membership age, listings and reviews | Clear identity and listings; derive factual age/activity only from actual records |
| [Google Business Profile social links](https://support.google.com/business/answer/13580646?hl=en) | Separate platform fields with one link per platform; availability varies by region | Distinct optional Website, Facebook and Instagram inputs rather than URLs buried in a description |
| [Google business information guidance](https://support.google.com/business/answer/3038177?hl=en) | Separate business name, category, address/service area and hours | Structured market/stall details and customer-facing operating hours |

The existing FP-57 pilot approval is not a product-quality certification. FreshPrice has no completed-order or verified-purchase system. Competitor ratings, sales counts and badges must not be copied into a design as if we have equivalent evidence.

## Proposed seller setup

1. **Stall details:** name, short introduction/tagline, description/story, one existing market, stall/aisle number and landmark. Pick the product categories sold using the existing catalogue categories. Keep the current private operator contact clearly separated from public fields.
2. **Photos:** one square logo or recognizable stall image, an optional wide cover and an optional gallery of three to five real stall/product photos with captions. A personal face photo should be optional. Show crop/preview, upload progress, retry, replacement and removal; use a sensible placeholder until an image is supplied.
3. **Visiting and contact:** weekly opening hours with closed days, optional pickup/delivery arrangements and service area, optional business Website, Facebook Page and Instagram profile. Optional public business phone is a separate explicit opt-in; never repurpose the existing private contact as public.
4. **Preview and review:** buyer preview, clear public/private labels, save draft/continue later, missing-required-field prompts and submit-for-review confirmation. Show the review state and required corrections without losing the draft.

Keep required setup small: existing name/description/market/private contact, with a useful stall location. Encourage at least one genuine stall photo before launch. Logo, cover, social profiles, website and delivery details are optional; a seller should not need a brand designer or social account to join. A future assisted photo-upload path can support vendors with limited connectivity.

## Public page layout

Display a wide stall cover followed by an overlapping avatar/logo, stall name, short introduction, actual market/stall location and clearly worded pilot-review status. Place **Message seller** prominently beside the identity. Below that show **Available offers**, **About the stall**, **Photos**, and **Visit/contact**, with a shareable FreshPrice page link.

Offer cards should retain unit/quantity, actual seller-confirmed time and expiry. Seller-specific offer photos are useful after the basic profile-media flow; keep them separate from the shared product image. Hours can show Open now only when a complete applicable schedule is provided; otherwise say Hours not provided. Do not infer response time, stock freshness or seller activity from a profile edit timestamp.

Use optional Website, Facebook and Instagram buttons as secondary actions. Hide missing links. Label destinations and open them separately while retaining the FreshPrice conversation. The FreshPrice seller page should be useful without any external link. Do not embed social feeds, auto-import followers or imply that adding a social link verifies ownership.

## Link, media and editing behavior to specify before implementation

- Store one structured business website and one URL per supported social platform. Use HTTPS and exact supported social hosts, reject malformed URLs, credentials and script/data links, and show the final hostname. Support legitimate Facebook Page formats rather than assuming every Page has a username. Do not auto-fetch arbitrary external URLs to generate previews.
- Accept actual decoded JPEG/PNG/WebP, with a proposed 5 MB input limit per image, bounded pixels/count, compressed output, metadata stripping and responsive thumbnails. Final dimensions/quota must be chosen for the existing server/storage budget; competitor limits are not our requirements.
- Only the profile owner can attach or replace owned media. Draft/unapproved files must not become public through a copied static URL. Submission, replacement, moderation and deletion need consistent retained references and orphan cleanup.
- Keep the current permission/review guarantees. A preferable future editing model is a pending draft revision while the last approved public revision remains live. That is a deliberate change from today's hide-until-reviewed behavior and requires an additive schema/publication contract. Suspension must still hide all public versions and stop new messaging immediately.
- Published profile, contact links and images are reviewed together. Owner/private operator details and report reasons stay private. Daily offer price/stock updates remain separate from profile identity review, under the existing offer rules.
- Reviews/ratings, followers, verified sales, response-time badges, checkout and payments are separate future capabilities. Without a defensible interaction/purchase and moderation model, omit those elements. A minimal accurate badge is Approved for seller pilot, with an explanation of what was reviewed.

## Recommended delivery order

First build draft/preview setup, avatar/cover, stall details, hours and optional website/Facebook/Instagram fields, with matching public profile/directory cards. Then add the small gallery and seller-offer photos using the same owned-media flow. Add reviews/following only under a separate defined contract.

Before accepting implementation: exercise owner/other-account isolation, public versus private draft media, image validation/crop/failure/replacement, invalid and lookalike social URLs, missing-image/link/hours fallbacks, resumable forms, stale edits/moderation/suspension and message entry on narrow screens. Use additive migrations and external local fixtures; preserve official prices and the verified messaging privacy/retry behavior. This proposal has no implementation or new test-pass claim.
