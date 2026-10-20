# FP-61 review fixes — 2026-10-20

The three pre-commit findings have local fixes. No stage, commit, push, Jira change, merge or deployment was performed. Tests and evidence remain in the standalone local testing workspace.

## Changes

- Conflict actions pass the revision shown in the confirmation. The IndexedDB transaction compares that revision with the stored conflict before creating a new mutation key. A changed conflict requires renewed review; a subsequent server-side change still receives the existing revision conflict response. The sync center surfaces the failed action and retains the draft.
- Every successful foreground replay invalidates older budget reads and requests fresh confirmed totals/history through the budget store, including replay without a mounted sync center. Account-scoped confirmation broadcasts perform the same invalidation in other tabs. Direct create/edit actions await current hydration after successful sync. Pending amounts remain separate from confirmed values.
- Explicit logout writes a synchronous durable per-account draft-generation marker before clearing authentication; account switches mark the previous account too. Draft creation captures its generation, and persistence, claiming, sending and completion reject obsolete generations. Physical purge deletes only obsolete records, preserving new work from a later login. Refresh resumes interrupted cleanup. Legacy records without a generation remain valid until account disposal. Expiry retains the same generation and drafts. Failure to persist disposal intent stops the action before clearing identity.

No server API or database schema change was needed for these fixes. Existing mutation receipts and authorization checks remain in force. Storage generations contain no auth credentials.

## Regression coverage

`testing/tickets/FP-61/offline.spec.ts` now registers 15 complete real API/PostgreSQL/browser cases. The three additions cover:

1. Hold a real pre-save summary response, confirm a save through the real queue, verify fresh totals/history before releasing the old read, then verify the old response cannot overwrite them. Also verify confirmed totals after another tab replays a draft.
2. Hold native confirmation of revision 2, persist revision 3 through the real API, refresh the stored conflict through another tab, and verify the old confirmation leaves revision 3 intact. A new review successfully applies the draft as revision 4.
3. Hold an IndexedDB write transaction in a plain second tab, explicitly log out and close the application tab before cleanup commits, then verify same-account login cannot submit the discarded draft. A fresh same-account draft still syncs.

Three new ordinary units cover durable disposal before clearing identity, expiry/same-account reauthentication versus account switch, and marker-storage failure. Existing expiry, account isolation, receipt, quota/schema, lease, production PWA restart and lost-response tests remain registered. The corrected isolated review probes additionally pass with actual Chromium/IndexedDB/React/stores and controlled Axios responses; see `testing/tickets/FP-61/review/fixed-evidence.json`. Those isolated probes are separate from the real API acceptance group.

## Verification

- Frontend lint and production builds pass. Complete standalone unit rerun: 272/272 tests, 49 files, two workers.
- Backend: 186 ordinary checks pass; 23 existing opt-in DB checks are skipped. The feature browser group independently exercises migrated disposable PostgreSQL and rollback guards.
- Runner/generator/report checks: 36/36 pass.
- Whole-app: 30/30 pass, zero failures/errors/skips in JUnit, execution `2026-10-20T02-18-32-119Z-10045bfc`. That invocation's feature group failed two test setups, described below; this is a separately completed whole-app group.
- Feature rerun: 15/15 pass, zero failures/errors/skips in JUnit, execution `2026-10-20T02-27-39-587Z-42c59029`. This final invocation is feature-only; the separate whole-app result above applies to unchanged application source.
- Source fingerprint (sorted relative paths plus NUL-delimited file bytes for both app src trees, package.json and Vite/Vitest configs): `c0b3884db6c7b34d66fd5705cbcc57d0e4debe80cc7cc043b088dd1b6f202ffa`.

The first combined check attempt ran units alongside backend checks and E2E setup; two existing wiki units exceeded their unchanged five-second timeout. The complete standalone rerun passes unchanged. The first feature run passed 13/15: cross-tab logout went offline before the second tab finished lazy route loading, leaving its auth handling unmounted; the new conflict test incorrectly resent nullable server `requestId` in a PUT. Corrected the harness to finish online route loading/warm Login before the offline logout scenario, and omit requestId on those PUTs as the existing conflict test already does. No successful API responses were fabricated and no assertions, timeout limits or final feature scope were reduced.

Staging, actual-device eviction, production proxy/CDN behavior and the established migration/backend-before-frontend release order remain separate release gates.
