# FP-60 review fixes — 2026-10-19

Resolves the three findings in `fp-60-precommit-review-2026-10-19.md`. Changes remain local on frontend/backend FP-60 branches; no stage, commit, push, merge, staging migration or deployment.

## Behavior changes

- **Delete confirmation:** the prompt snapshots expense ID, revision and amount when opened. Refresh does not advance its token. A concurrent payer correction therefore makes confirmation fail with 409; the revised expense remains intact. The prompt displays the amount being confirmed. The user cancels and opens a new prompt to review/delete the latest version.
- **Former beneficiaries:** historical removed members appear as explicitly selected, inactive beneficiaries in the correction form. The author must uncheck them before saving; once removed they cannot be re-added without current membership. Confirmed shares remain visible in audit history. A missing/read-only former payer similarly requires explicit selection of a current owner/contributor. Client submit/button guards reinforce these requirements; server membership checks remain authoritative.
- **Payment replay:** write authorization runs first, then existing creator/request UUID lookup. An omitted date resolves to the existing record's date for retries, or to the current business date only for a new record. Canonical signature comparison still rejects changed amount, recipient, budget, date or note. No migration or data rewrite is needed; existing signatures remain compatible.

## Registered regression coverage

- Promoted the two review React assertions into `testing/tickets/FP-60/frontend/unit/reviewRegressions.test.tsx`, updating former-member coverage to exercise the explicit removal control and verify the confirmed snapshot is untouched. The standalone review config now points to these registered regressions.
- Added five backend unit cases in `backend/unit/settlementReplay.test.js`: omitted-date replay after Manila midnight, changed amount/date/budget conflicts and authorization before replay.
- Registered three additional real PostgreSQL/browser scenarios: open deletion → payer correction → refresh → stale 409 → explicit fresh confirmation; member removal → reload → explicit beneficiary removal → confirmed correction with original history retained; API creation without date → process-local next-day replay → changed-payload rejection → viewer replay denial. Feature suite increases from 13 to 16; separate whole-app group remains 30.
- The gated local DB helper's clock advance is confined to its child process, restored in finally, and runs only against the runner-owned disposable PostgreSQL. Successful API responses are real. Fixtures, tests, generated seeders and reports remain outside app repositories.

## Verification

Final execution results are recorded in `testing/tickets/FP-60/COVERAGE.md`. Local validation does not replace restored staging tests or production release verification. Release order and financial history/rollback guards remain unchanged: FP-59 baseline, FP-60 migration/backend, then frontend.
