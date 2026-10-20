# FP-61 pre-commit review — 2026-10-20

Historical review: these three reproduced P2 defects were subsequently fixed and verified locally; see `fp-61-review-fixes-2026-10-20.md`. At review time, commit readiness was on hold. Application source was reviewed without fixes, staging, commits or pushes.

## Findings

1. **Conflict confirmation can overwrite an unseen revision.** `fresh-price-front/src/features/user/budget/offline/expenseQueue.ts:174–178` resolves using the latest IndexedDB `row.current.revision`, while the sync center passes only a draft ID after confirmation. With revision 2 displayed in an open confirmation, another tab retried the same conflict and persisted revision 3. Accepting the original confirmation submitted expectedRevision 3 and succeeded, although the user had only reviewed revision 2. Freeze the reviewed revision/snapshot in the action, compare it transactionally, and reject/re-display if the conflict changed; submit exactly the reviewed revision.
2. **Successful queue replay can leave confirmed spending stale.** `fresh-price-front/src/store/budgetStore.ts:178–183` joins an existing hydrate without advancing the read sequence as the ordinary write path does. A background summary read captured total 0, then a queued expense successfully saved 123; releasing the old read left total 0 and an empty expense list after addExpense resolved, with the draft marked synced. The sync-center success listener also joins that same read. Invalidate reads on successful mutation and require a fresh confirmed read; cover background and other-tab replay as well as direct saves.
3. **Interrupted logout disposal replays discarded work on next login.** `fresh-price-front/src/features/user/budget/offline/expenseQueue.ts:79–83` starts purge without awaiting its commit or persisting a disposal marker, while auth immediately removes the account identity. A second tab held an IndexedDB write transaction; explicit logout queued cleanup, then the logout tab closed. One pending draft remained and replayed on the next same-account login. Persist a durable logout generation/tombstone before clearing auth, reject older drafts during replay, and make interrupted cleanup safely resumable. Awaiting cleanup alone does not protect against a tab closing before completion.

## Evidence and coverage gaps

`testing/tickets/FP-61/review/probes.mjs` runs actual Chromium, IndexedDB, React sync-center and application stores through `review/browser-entry.tsx`. Network responses are controlled through an Axios adapter; these review probes do not exercise the real API/PostgreSQL. `review/evidence.json` records:

- Stale read: serverAmount 123, displayedTotal 0, displayedExpenses 0, summaryCalls 2, syncState synced.
- Conflict: reviewedRevision 2, serverChangedTo 3, submittedRevision 3, state synced.
- Logout: queuedBeforeLogout 1, persistedAfterLogoutAndTabClose 1, automaticallyReplayedOnNextLogin 1.

All three probes reproduced in one completed run. The first two also reproduced in the preceding successful run. Assertions intentionally verify the defective behavior and must be converted into expected-correct regressions when fixing it. They are separate from registered acceptance/unit groups.

Earlier 269 frontend units, 186 ordinary backend checks, 36 runner checks, 12 feature cases and 30 whole-app cases passed before this review. Those passing results do not cover these races. Add registered coverage for a read crossing a successful mutation, a conflict changing in another tab during confirmation, and logout interrupted by tab closure with IndexedDB contention; rerun affected checks and complete real API/browser regressions before committing. No additional concrete backend defect was established in this review; staging/release verification remains separate.
