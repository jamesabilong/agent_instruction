# FP-62/FP-63 content approval packet — 2026-10-22

**Status: content approved by the user and published on October 22, 2026 during the explicitly authorized rollout.** Approval covers the six wiki variants and two sourced English recipe records exactly as prepared in documentation commit `9172cbd38e25d305540b661633f33790a1f17a8c`. The later user release request explicitly authorized production publication; [execution record](fp62-fp63-deployment-2026-10-22.md). [Readiness and remaining release approvals](fp-62-63-release-readiness-2026-10-22.md).

## Multilingual wiki pilot

Production inventory from October 22 identifies Pechay **product 1 / approved source revision 1** and Lettuce **product 9 / approved source revision 9**. Apply each language row below separately to each product: `P1-en`, `P1-fil`, `P1-ceb`, `P9-en`, `P9-fil`, `P9-ceb`. Product names/aliases and canonical pages are unchanged.

Source for all six proposals: FDA, [Selecting and Serving Produce Safely](https://www.fda.gov/food/buy-store-serve-safe-food/selecting-and-serving-produce-safely), checked October 22, 2026, specifically Buy Right and Prepare Safely. These drafts paraphrase general handling guidance; the source does not establish Philippine growing seasons or Cebu availability.

| locale | buyingTips | cookingTips (preparation guidance) |
| --- | --- | --- |
| `en` | Choose produce without bruises or damage. Pack it separately from raw meat, poultry and seafood. | Rinse produce under running water before preparation. Do not use soap or detergent. |
| `fil` | Pumili ng gulay na walang pasa o sira. Ihiwalay ito sa hilaw na karne, manok at pagkaing-dagat kapag inilalagay sa bag. | Banlawan ang gulay sa umaagos na tubig bago ihanda. Huwag gumamit ng sabon o detergent. |
| `ceb` | Pilia ang mga utanon nga walay bun-og o kadaot. Ibulag kini sa hilaw nga karne, manok ug pagkaong-dagat sa pagputos. | Hugasi ang mga utanon sa nagaagas nga tubig sa dili pa andamon. Ayaw paggamit og sabon o detergent. |

For every proposal: `sourceRevisionId` as above, `region=""`, `months=[]`, `sourceUrl` as above, `reviewedOn="2026-10-22"`, `creditConsent=false`, no publicName. Content contains only the exact buyingTips/cookingTips cells. No summary, storage duration, nutrition claim or seasonal text is proposed. Check current publication/revision again before submitting; assign a fresh stable submission UUID per proposal and retain it for retries. Approval must refer to the exact current source revision.

The user explicitly approved the English, Filipino and Cebuano pilot text. This records user editorial acceptance; it does not assert an independently certified translation or an additional reviewer. Recognition remains off and no private identity is included. The exact content cells above are unchanged from the approved revision.

## Sourced recipe set

Both proposals are paraphrased adaptations of the linked Nutrition.gov records, which credit USDA MyPlate. Ingredient amounts and yields are retained; preparation wording is newly written. Source access/review date is October 22, 2026. The user approved the two sourced adaptations and their documented source/attribution scope; government hosting is not a blanket license for every contributor asset. No source images, nutrition panels, price claims, health claims or US seasonal tags are copied. Source notes must retain these qualifications and any later approved adaptation.

Recipes currently have no locale field in FreshPrice: create **one English recipe per approved proposal**, not three duplicated locale records. Translations above belong to wiki enrichment. Separate translated recipe publication needs a supported locale design and further editorial review.

### R1 — Cabbage Comfort

Proposed canonical parent: **Cabbage, product 7**. Source: [Nutrition.gov: Cabbage Comfort](https://www.nutrition.gov/recipes/cabbage-comfort), credited to USDA MyPlate.

Proposed fields: title `Cabbage Comfort`; slug `cabbage-comfort-pilot`; summary `A cabbage side dish with onion and caraway.`; servings **4**; prepTimeMinutes **5**; cookTimeMinutes **35**; difficulty **null** (not supplied by source); imageUrl **null**; sourceName `USDA MyPlate via Nutrition.gov`; sourceUrl as above; isPublished **false** until explicit publication approval. Times are the source's approximate values, not independently kitchen-tested.

Exact proposed ingredient strings for review:

- `1 piece Onion`
- `1 tsp Vegetable Oil`
- `4.5 cups Cabbage`
- `1/4 tsp Salt`
- `1/4 tsp Black Pepper`
- `1 tsp Caraway Seeds`

Preparation notes: slice the onion and cabbage. Warm the oil in a wide pan; soften and lightly brown the onion over medium heat for approximately 5–6 minutes. Stir in cabbage and all remaining seasonings; continue cooking and stirring for about 30 minutes. Serve hot. These sentences become the instructions array, split at sentence boundaries. The shopping unit `piece` records the source's single onion, without claiming an onion variety or weight. `4.5` preserves the source's 4½ cups.

### R2 — Tomato and Cucumber Salad

Proposed canonical parent: **Tomato, product 22**. Source: [Nutrition.gov: Tomato and Cucumber Salad](https://www.nutrition.gov/recipes/tomato-and-cucumber-salad), credited to USDA MyPlate.

Proposed fields: title `Tomato and Cucumber Salad`; slug `tomato-cucumber-salad-pilot`; summary `Vegetables with a vinegar, oil and garlic dressing.`; servings **12**; prepTimeMinutes **null**; cookTimeMinutes **null**; difficulty **null**; imageUrl **null**; sourceName/sourceUrl as above; isPublished **false** until explicit publication approval. The source gives no preparation/cooking duration. Preserve its **at least 60-minute refrigeration step** in instructions; this is not cooking time and must not be encoded as cookTimeMinutes=60 or silently included in a “ready in” estimate.

Exact proposed ingredient strings for review:

- `4 pieces Tomato`
- `1 piece Cucumber`
- `1 cup Red Onion`
- `1 cup Green Pepper`
- `1/3 cup Parsley`
- `1/3 cup Apple Cider Vinegar`
- `1 tbsp Olive Oil`
- `2 cloves Garlic`
- `1/2 tsp Salt`
- `1/2 tsp Black Pepper`
- `1/2 tsp Sugar`

Preparation notes: use large tomatoes and a large cucumber. Cube tomatoes; chop cucumber, red onion, green pepper and parsley; mince garlic. Combine the five salad vegetables/herbs. Separately blend vinegar, oil, garlic, salt, black pepper and sugar; toss this dressing through the salad. Cover and refrigerate for at least one hour before serving. These sentences become the instructions array, split at sentence boundaries. Size/preparation qualifiers remain here so ingredient matching can use exact names without implying a weight conversion. Yield remains 12 as documented; a six-serving list scales amounts by ½ without changing the stored recipe.

## Catalogue and estimate review

This mapping is based on the October 22 actual production inventory and the current FP-63 parser, not invented catalogue rows. Preserve ingredient text even when it cannot be priced. Product match and supported price unit are separate conditions; fresh compatible official prices and a selected market are also required. Do not promise a complete basket total for either recipe.

| Proposed ingredient name | Exact canonical match / decision | Estimate consequence |
| --- | --- | --- |
| Cabbage | 7 | cups are unsupported; quantity remains visible, amount unknown |
| Tomato | 22 | integer pieces may use compatible fresh per-piece quotes |
| Cucumber | 23 | integer pieces may qualify; half a piece after scaling stays unpriced |
| Red Onion | 34 | cups stay unpriced |
| Garlic | 33 | cloves stay unpriced |
| Salt | 103 | tsp stays unpriced |
| Onion | no exact canonical name in inventory; keep unmatched | do not choose red/yellow/white automatically |
| Vegetable Oil / Olive Oil | neither exact name in canonical inventory | generic Cooking Oil 104 is not an approved substitution |
| Green Pepper / Black Pepper | neither exact name in canonical inventory | do not equate either with generic Bell Pepper 21 |
| Apple Cider Vinegar | no exact canonical name | do not substitute generic Vinegar 105 |
| Sugar | no exact canonical name | do not choose White Sugar 101 or Brown Sugar 102 automatically |
| Parsley / Caraway Seeds | no exact canonical name | retain unmatched |

The retained inventory contains source metadata, not each alias string. Before submission, the operator must check exact aliases for these unresolved names; if an exact unique alias exists, FP-63 may resolve it. No new alias or product creation is included in this proposal. Unsupported cups/tsp/tbsp/cloves remain unknown even if a name resolves. No densities or piece weights were invented, no fractions were rounded to whole pieces, and no ingredient was omitted to force a known total.

## Explicit approval record

| Item | Decision requested | Status / reviewer / date |
| --- | --- | --- |
| P1-en / P9-en | approve factual scope and exact English text | Approved / user in this chat / 2026-10-22 |
| P1-fil / P9-fil | accept exact Filipino text (user approval; no independent certification claimed) | Approved / user in this chat / 2026-10-22 |
| P1-ceb / P9-ceb | accept exact Cebuano text (user approval; no independent certification claimed) | Approved / user in this chat / 2026-10-22 |
| R1 | approve source attribution/reuse, measures, approximate timing, instructions and mapping | Approved / user in this chat / 2026-10-22 |
| R2 | approve source attribution/reuse, 12-serving yield, required chilling, unknown times and mapping | Approved / user in this chat / 2026-10-22 |
| Publication | execute approved content only after supporting release and production rollout authorization; confirm current source revisions and aliases | Published / user-authorized system operation / 2026-10-22 |

Approval evidence: user message, “I approve the multilingual pilot and the two recipes.” Approved packet revision: `9172cbd38e25d305540b661633f33790a1f17a8c`; original file SHA-256: `ff69908bad006720446eec7cb2049beab689fcbb9cf4bb802e7aec17efed2cc6`. This clears the pilot/recipe content approval gate without changing any approved text, measure or instruction.

Seasonal calendars remain outside this pilot: months stay empty until geographically appropriate evidence and review exist. The separate later user request authorized production writes and merge/deployment and accepted recovery/device limitations. Source-revision/alias rechecks and publication are rollout tasks, not additional editorial approval of unchanged text. No recipe has been kitchen-tested in this task. Changed content requires renewed approval.
