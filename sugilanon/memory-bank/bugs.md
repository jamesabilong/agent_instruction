# Sugilanon Bugs And Risks

## Known Risks

- `sugilanon/AGENTS.md` warns that Next.js 16 has breaking changes. Read relevant local Next docs before framework-sensitive edits.
- `/api/content` is deprecated. New callers should use `/api/sugilanon`.

## Open Bugs

- 2026-07-01 FreshPrice deploy logs showed `freshprice_sugilanon` rejected because `ghcr.io/jamesabilong/sugilanon:latest` was missing or inaccessible.
- 2026-07-01 frontend nginx logs showed the config was still pointing at `sugilanon.philwatch.com`; production should serve Sugilanon from `philwatch.com`.

## Resolved

- 2026-07-02: Sugilanon deployment config had inconsistent branch assumptions: dispatch only listened to `main`, the Docker build did not receive the pushed ref, while production deploys were described around `master`. The workflow refs were aligned.

## Documentation Corrections

- 2026-07-02: Corrected deployment docs to state that Sugilanon production runs on `philwatch.com`, not `sugilanon.philwatch.com`.
