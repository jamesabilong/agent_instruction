# Sugilanon Bugs And Risks

## Known Risks

- `sugilanon/AGENTS.md` warns that Next.js 16 has breaking changes. Read relevant local Next docs before framework-sensitive edits.
- `/api/content` is deprecated. New callers should use `/api/sugilanon`.

## Open Bugs

- 2026-07-01 FreshPrice deploy logs showed `freshprice_sugilanon` rejected because `ghcr.io/jamesabilong/sugilanon:latest` was missing or inaccessible.
- 2026-07-01 frontend nginx logs showed the config was still pointing at `sugilanon.philwatch.com`; production should serve Sugilanon from `philwatch.com`.
