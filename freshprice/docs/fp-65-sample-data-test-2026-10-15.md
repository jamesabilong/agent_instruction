# FP-65 sample data verification — 2026-10-15

Tested the supplied notes through the production frontend build in Chromium, the real local API and a disposable PostgreSQL 14 database. No API responses were mocked. All migrations applied successfully. No application or production database was modified.

## Input and review assumptions

- The 29 product lines expanded into **38 quote rows**, preserving multiple prices for the same product and date. Weight/fraction tokens were retained for review rather than treated as extra prices.
- Used October 13 and 14 as test-only date headings for the two blocks. All saved rows used per-kilo units as an explicit test assumption, not an inferred fact about the original notes.
- Loaded 113 products from the repository wet-market CSV. Fixture aliases came from the aliases column or pipe-delimited notes where that CSV row lacked a final aliases cell. This establishes behavior with the fixture catalogue, not matching coverage in the live database.
- Reviewed clear mismatches manually: Kamates → Tomato, Whitebonion → White Onion, Abocado → Avocado and Ahos → Garlic. Catalogue matches included Bombay → Yellow Onion, Muscovado → Brown Sugar and Batong → Winged Bean; catalogue semantics still require operator review.
- Left **seven quotes** unsaved: Maharlika 50; Mambajao 60/50; generic Onion 90/100; Mongos 46; Butong 70. Their product identity needs confirmation.
- For conversion testing only, interpreted Muscovado 36 1/2 as ₱36 for 0.5 kg, yielding ₱72/kg. Confirm the intended interpretation before a real import.

## Actual persisted results

The UI saved **31 observations**. Replaying the identical import request returned the original result with `replayed: true`; the database still contained 31 sample observations. Official current-price and history counts remained zero in this isolated fixture.

Statistics below combine the two test dates and use the selected sample market only:

| Product | Quotes | Mean | Median | Mode |
| --- | ---: | ---: | ---: | --- |
| Ginger / Luya | 4 | ₱131.25 | ₱127.50 | None |
| Carrot | 3 | ₱71.67 | ₱80.00 | ₱80.00 |
| Cabbage | 4 | ₱87.75 | ₱95.00 | None |
| Avocado | 2 | ₱240.00 | ₱240.00 | None |
| Brown Sugar / Muscovado | 1 | ₱72.00 | ₱72.00 | None |

Additional checks passed:

- Luya 90/120/180 on October 13 remains three separate observations: mean ₱130, median ₱120, no mode.
- Luya weekly aggregation uses all four raw observations: mean ₱131.25 and median ₱127.50. Daily median change to ₱135 is 12.5%; daily mean change is 3.85%.
- Excluding the ₱180 Luya quote reduced the count from four to three; restoring it returned the count to four. Both edits remained in the audit history.
- Separate synthetic-market controls verified a repeated mode (90/90/120 → mode 90) and a tie (90/90/120/120 → modes 90 and 120, no single chart value). Retrying the control import also created no duplicates.
- The real browser displayed the selected sample market's median ₱127.50, mean ₱131.25 and no-mode state. The synthetic market displayed both tied modes in daily details.

## Evidence and limits

- Screenshots: `output/playwright/fp65-sample-saved.png`, `fp65-ginger-median.png`, `fp65-mode-controls.png`.
- Machine-readable API assertions: `output/playwright/fp65-sample-results.json`.
- Frontend production build passed. Earlier full-suite results remain in the review report; this run exercised real sample persistence and browser rendering rather than rerunning unchanged suites.
- The two previously reproduced P2 issues remain unresolved: clearing a correction product can trigger a render loop, and soft-deleted markets can crash observation management. See [review](fp-65-review-2026-10-15.md). Successful sample testing does not establish release readiness.
- Temporary seed script, browser session, API/frontend processes and disposable database were removed after testing. No source fixes, commit, push or deployment were performed in this data-test step.
