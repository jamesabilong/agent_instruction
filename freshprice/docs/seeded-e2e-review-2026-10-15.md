# Seeded E2E review — 2026-10-15

Reviewed frontend commit `7fcd2906` and backend seeder commit `888ff3dc` against the current FP-65 working tree. Application feature changes are still uncommitted. Review did not modify application or committed test source.

## P2 — Picker regression escapes the render loop before observing it

Location: `fresh-price-front/tests/e2e/seeded/observations.spec.ts:177–180`.

The test waits only two animation frames after clearing the corrected product, then immediately chooses another valid product. This ends the invalid `"0"` selection state before the effect loop reliably emits its depth warning. Consequently, the regression passes while the actual bug remains present.

Reproduction against the real seeded browser/API/database: copied the spec temporarily, replaced only the two-frame wait with a 1.5-second diagnostic pause, and ran the corrected-product scenario. React emitted `Maximum update depth exceeded`; the existing console handler closed the page, failing during the pause. The unchanged original passes in the complete run. Removed the diagnostic copy afterward.

Required improvement: cover leaving the cleared picker empty before searching/reselecting, observe the depth warning during that state, and assert the form remains usable. Prefer a deterministic React regression that proves the effect settles, plus the browser correction path. Fix the underlying empty-ID handling before treating this scenario as verified. A fixed arbitrary delay alone should not be the final regression strategy.

## Execution results

- Complete seeded suite: **9 executed, 8 passed, 1 failed, zero skipped/retries**.
- The failing archived-market regression correctly reports null historical market association, blank public market identity and HTTP 400 when excluding a retained quote. These are the previously documented application defects, not a new runner failure.
- Focused delayed-picker diagnostic: **1 failed**, with the depth warning verified in the Playwright trace.
- Existing Chromium suite: **19 passed** (two workers).
- Runner and seeder syntax checks and both repositories' diff whitespace checks passed.
- Both seeded runs applied migrations to separate runner-owned PostgreSQL containers. Normal failure cleanup removed both containers and volumes. Application and production data were untouched.

The suite adds useful real persistence, permission, statistics, concurrent replay and lost-response coverage. It is not green and the picker regression currently gives a false negative for the known bug. No commit, push or deployment was performed.
