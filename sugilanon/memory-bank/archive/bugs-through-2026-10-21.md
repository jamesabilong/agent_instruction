# Historical snapshot through 2026-10-21

Superseded by the current memory-bank file. Older pending/ready claims below describe their original checkpoints, not current state. Paths retain the original app context.

# Sugilanon Bugs And Risks

## Shared auth proxy identity risk — 2026-10-21

- FreshPrice public-path probe confirms shared backend auth/global rate-limit key collapses to Docker gateway `172.19.0.1`, potentially grouping visitors. PhilWatch's public path was not independently probed; validate it before shared-auth changes. No source/config change or exemption applied. See `../../freshprice/docs/auth-testing-exemption-2026-10-21.md`.

## Known Risks

- `sugilanon/AGENTS.md` warns that Next.js 16 has breaking changes. Read relevant local Next docs before framework-sensitive edits.
- `/api/content` is deprecated. New callers should use `/api/sugilanon`.

## Open Bugs

- 2026-10-09: Reported FreshPrice display on initial PhilWatch visits, corrected by hard refresh. Live apex HTML is no-store, but `/sw.js` is 404; an isolated Chromium reproduction confirms an obsolete worker can keep serving FreshPrice under these conditions. Retirement route and client update check pass locally; deployment/purge and verification of the affected device's actual registration remain pending. See `docs/cache-recovery-2026-10-09.md`.

- 2026-07-01 FreshPrice deploy logs showed `freshprice_sugilanon` rejected because `ghcr.io/jamesabilong/sugilanon:latest` was missing or inaccessible.
- 2026-07-01 frontend nginx logs showed the config was still pointing at `sugilanon.philwatch.com`; production should serve Sugilanon from `philwatch.com`.

## Resolved

- 2026-07-02: Sugilanon deployment config had inconsistent branch assumptions: dispatch only listened to `main`, the Docker build did not receive the pushed ref, while production deploys were described around `master`. The workflow refs were aligned.

## Documentation Corrections

- 2026-07-02: Corrected deployment docs to state that Sugilanon production runs on `philwatch.com`, not `sugilanon.philwatch.com`.
