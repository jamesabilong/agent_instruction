# FP-60 pre-commit review — 2026-10-19

Follow-up: all three findings have local fixes and registered regressions; see `fp-60-review-fixes-2026-10-19.md` for current verification. The findings and evidence below describe the pre-fix source.

Recommendation: fix the following three P2 issues before committing. Reviewed the uncommitted frontend/backend FP-60 diff including new accounting models, migration, service/controller/routes, UI/store/API integration, local acceptance cases and relevant existing mutation/auth paths. Application source was not changed, staged, committed or pushed. This review adds independent local probes and records their results; it does not rerun the broad implementation suite.

## P2 — Delete confirmation silently adopts a newer expense revision

Location: `fresh-price-front/src/features/user/budget/ExpenseListScreen.tsx:219–221`, with the dialog opened at line 505.

`deleting` stores only the expense ID. Confirming deletion reads the revision from the latest refreshed rows, rather than the revision shown when the user opened the dialog. If a pending payer correction confirms in another session and budget hydration refreshes the expense, the same open confirmation now sends the newer revision and can delete the revised amount without requiring the author to review the changed expense.

React probe: opened deletion at revision 3, refreshed rows to revision 4/PHP 200, confirmed and observed `removeExpense('expense', 4)` instead of 3. Real PostgreSQL probe: opened at revision 2, confirmed another payer's PHP 200 proposal to revision 3, observed old-revision deletion correctly rejected with 409 but adoption of the refreshed revision successfully deleted the corrected expense. The backend protection works; the UI defeats its purpose by silently updating the confirmation's token.

Fix: snapshot `{id, revision}` (and relevant display details) when opening the delete prompt. Preserve that token through refresh, or invalidate/close the dialog and require a new confirmation when the record changes. Add a regression that changes the expense while confirmation is open.

## P2 — Removed beneficiaries remain in an invisible, uncorrectable draft

Location: `fresh-price-front/src/features/user/budget/BudgetAccountingPanels.tsx:22–23` and controls at line 47.

The editor initializes `shares` from every historical confirmed share, while rendering editable checkboxes only for current participants. After a beneficiary leaves/is removed, that ID remains in the draft with no way to deselect it. Even explicitly unchecking/rechecking all visible beneficiaries submits the hidden ID, and the API correctly rejects it as an inactive participant. Reloading recreates the same blocked draft; the active author cannot make a normal split correction through the UI.

React probe: only participant 1 is editable, but selecting participant 1 as sole beneficiary submits IDs 1 and 2. Real PostgreSQL probe: participant list `[1]`, historical shares `[1,2]`, resulting correction returns 409. Historical accounting itself is retained correctly.

Fix: render historical/removed beneficiaries in the correction form with an explicit removal control and clear inactive labels, or require an explicit reset/reselection of beneficiaries without carrying invisible IDs. Do not silently rewrite the confirmed financial history. Add removal → reload editor → correct split coverage.

## P2 — Optional-date settlement retries fail across midnight

Location: `platform-backend/src/apps/freshprice/services/budgetAccountingService.js:152–156`.

The route accepts omitted `date`; creation supplies the current Asia/Manila date and includes it in the request signature. On retry after midnight, the same request UUID and unchanged body calculate a different default date before looking up the existing record. The committed request returns 409 “different settlement values” instead of its existing record. This breaks the advertised retry contract for supported API callers that omit the optional date. The current frontend supplies a date, so its ordinary same-payload retry is unaffected.

Real migrated PostgreSQL probe created a pending PHP 10 payment with omitted date, advanced process-local time by 24 hours and replayed the identical argument object. Result: 409, while one original row remained. No duplicate debit was created, but the client cannot safely resolve the uncertain original save by retrying.

Fix: resolve the existing request before applying changing defaults, comparing an omitted date against the persisted original date (or recording omission in a stable canonical request signature). Apply the business-date default only to a new record. Preserve changed-payload conflict detection and active membership authorization. Test a successful retry across the business-date boundary and a genuinely changed payload returning 409.

## Evidence and limits

- `testing/tickets/FP-60/frontend/review/panel-probes.test.tsx`: two focused assertions of correct behavior fail on current source; standalone config `testing/tickets/FP-60/review.vitest.config.ts` keeps these review repros outside normal registered unit/E2E groups. Saved log: `testing/reports/fp60-panel-review-2026-10-19.log`.
- `testing/tickets/FP-60/review-probes.mjs`: uses real services/models and a newly migrated runner-owned PostgreSQL container at 127.0.0.1:55467, database `freshprice_fp60_review_test`. Date advance is process-local, restored in finally. Container and volumes are removed in finally. Evidence: `testing/reports/fp60-review-probes-2026-10-19.json`.
- Prior implementation validation (13 feature, 30 whole-app, 264 frontend, 179 ordinary backend with 23 opt-in DB skips) predates these review probes and did not cover these edge cases. No broad suite rerun was necessary for this read-only application review. Staging/deployment checks remain outstanding separately.
