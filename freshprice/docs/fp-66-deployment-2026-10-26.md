# FP-66 production release — October 26, 2026

FP-66 is merged, deployed and running in authenticated-edge mode. The user explicitly authorized ordered deployment, accepted the previously documented limits, and required exemptions to stay disabled. `AUTH_TEST_EXEMPTIONS_ENABLED=false`; final database counts are **zero rules and zero audit events**. No live exemption or authenticated feature mutation was created. One separate content-search defect discovered during verification remains open below; this release does not certify every PhilWatch feature.

[Sanitized release evidence](../evidence/fp-66-deployment-2026-10-26.json), [prior backup/Caddy maintenance](fp-66-caddy-maintenance-2026-10-26.md), [policy/recovery](fp-66-controls-2026-10-23.md). Prior publication/readiness records are historical checkpoints, superseded here for current deployment state.

## Ordered delivery

| Stage | PR / merged commit | Deployment / result |
| --- | --- | --- |
| Docker prerequisite | [#26](https://github.com/jamesabilong/fpdocker/pull/26), `16a160bc` | Published first; Docker push alone does not dispatch deployment |
| Backend | [#60](https://github.com/jamesabilong/fresh-price-backend/pull/60), `fc770b40` | [40266112449](https://github.com/jamesabilong/fpdocker/actions/runs/40266112449), success; verified source, image and additive migration 42 before proceeding |
| PhilWatch | [#2](https://github.com/jamesabilong/sugilanon/pull/2), `ec1051d6` | [40266501721](https://github.com/jamesabilong/fpdocker/actions/runs/40266501721), success; exact image/rewrite, home/empty feed/missing article checks |
| FreshPrice frontend | [#58](https://github.com/jamesabilong/fresh-price-front/pull/58), `0e80f5c5` | [40267161444](https://github.com/jamesabilong/fpdocker/actions/runs/40267161444), success; exact image/nginx, admin chunk and anonymous browser redirect to login |
| Credential parser follow-up | [Docker #27](https://github.com/jamesabilong/fpdocker/pull/27), `6b5ce18c` | Four external parser checks pass; merged after the app stages and pulled onto VPS; no image dispatch |

Each original merged app tree matched its reviewed candidate; deployment logs confirmed intended source checkout. Published digests match actual running image IDs:

- Backend: `sha256:33eb7f87ed8db5e73bc6b13db9b2b54d9f6ecad5139942e3e2941de0d503a813`
- PhilWatch: `sha256:2eb786e0d7a38b9a98353447c4f817f539c10b6896101fa33ca6cfb78294e3f9`
- Frontend: `sha256:5befc1dc3584699618194741084290bff0630ec090ce3b4adc2846c76d06d64b`

## Protected runtime and verification

The shared Compose `.env` also feeds PostgreSQL. The supplemental parser fix keeps the four FP-66 values in root-owned mode-0600 `/etc/freshprice/fp66-runtime.env`. Only backend receives both credentials; PhilWatch receives only its distinct content-reader credential. PostgreSQL and frontend receive neither new key. Their service specs were preserved through the targeted runtime rollout. Caddy's matching key and public CIDRs are separately held in `/etc/caddy/fp66-runtime.env` (root:root 0600), loaded by `/etc/systemd/system/caddy.service.d/fp66-client-identity.conf`. No real credential was exported or published.

Compatible socket mode was retained while service credentials and Caddy were configured. Caddy 2.11.7 validated the complete candidate using all 15 IPv4 and seven IPv6 official ranges reviewed that day. The server's attempted range download returned 403 before mutation; the activation used the hash-verified official lists already fetched locally that day. Normalization showed only the expected global trust settings and two proxy header policies changed. Existing TLS, maintenance/fallback and portfolio route configuration were preserved. Caddy was restarted to ingest its protected environment; active JSON equals the adapted file. Backend was then updated to authenticated-edge and the protected file kept consistent, with exemptions false throughout.

Two real independent public clients (operator machine and VPS outbound network) passed eight auth-root assertions across both public sites, including forged X-Forwarded-For and custom identity/service headers. Backend logs resolved each request to that client's independent Cloudflare trace identity; client addresses/logs remain private. Direct Caddy origin HTTPS ignores forged forwarding/custom headers and resolves the actual socket peer. Direct nginx/Next auth paths return 403 with absent or invalid assertions; uncredentialed private backend auth is also 403. Full forged CDN-header probes returned 403 HTML at the public edge; the permitted forged-header probes and direct-origin checks establish backend spoof resistance without relying on those edge blocks.

The restricted reader returns 200 for article/category/empty-query search GETs and 403 for auth/admin GETs. Real keys are absent from FreshPrice/PhilWatch browser assets and PhilWatch SSR HTML. A live mutation-denial POST was rejected by automatic approval review because an authorization defect could create content; it was omitted. The original verification stopped at search before reaching that POST. Mutation-denial coverage remains the prior isolated tests/source review, not a production mutation claim.

Final inventory: four healthy services, all three exact intended digests, 42 migrations and both new tables, preserved database identity/data volume, fresh private DB connection, unpublished PostgreSQL and active/enabled public-interface guard. Seventeen final public app/DB/page/worker/manifest/redirect/portfolio checks pass. FreshPrice admin URL redirects an anonymous real browser to login. Public health and an SSR page's 200 status alone are not functional search evidence.

## Recovery checkpoint and limits

Protected post-release backup `/var/backups/freshprice/fp-restore-20261026T041156Z-2388254` has 42 migrations, 48 COPY blocks and 582 rows. Full isolated network-none restore/schema/data/sequence comparison and checksums pass; scratch container/volume removed. Dump SHA-256: `8da50acebfa378529377b3ab3a0d43f24b6301f4e3367a0f3e210475a5cdcc99` (231075 bytes). The separate app/Caddy runtime files and systemd drop-in are retained with protected checksums in that checkpoint. Pre-release checkpoint, Caddy package rollback material and exact image digests remain available. No dump, environment, client IP, cookie or raw log is in Git.

Recovery for an identity incident is an authorized targeted backend change to socket mode, keeping exemptions false and updating the protected runtime file consistently. Preserve scoped keys for repair; do not broaden trusted CIDRs, enable exemptions or run a destructive schema down as an availability shortcut. Caddy's prior config and pre-runtime service inspections are protected under `/var/backups/freshprice/fp66-release-20261026T035000Z`. Use the same allowlisted parser for future manual stack deploys; never source the production `.env` in a shell. This backup includes runtime material but does not establish an executed full config/global-role/off-host disaster-recovery procedure. Live uploads were copied while the app stayed online and are not an atomic DB/filesystem snapshot. Physical-device/installed-PWA checks remain waived and untested.

## Open follow-up: PhilWatch query search

GET `/api/sugilanon/search?q=fp66` returns 500; `/api/sugilanon/search` returns 200. The server helper catches the error and the search page renders empty results with 200. The search service SHA-256 `60b4295ce96eba9a88365d6aff25452751ceb3e69829ad983d88f55d9400fb0b` matches the previous running backend image; no FP-66 search source change occurred. This indicates an existing separate search-path defect, but a previous-image database execution was not performed, and the exact SQL cause remains unconfirmed. It has not been repaired or accepted as a newly waived test. Keep it visible in both app bug/todo records.

Production has zero published content articles/categories, independently confirmed by read-only database counts and public inventory. Existing article-detail behavior therefore cannot be certified on live data; missing article 404 and prior synthetic detail coverage are retained. No fixture article was inserted. Jira was not changed during this release.

## Commands and operations executed

The operator-facing command sequence used the existing authenticated SSH control socket; real values were generated and used only inside protected server processes. Repeated read-only diagnostics and failed pre-mutation validation attempts are summarized above.

```sh
gh pr ready 26 --repo jamesabilong/fpdocker
gh pr merge 26 --repo jamesabilong/fpdocker --merge --match-head-commit c4b33711b20074a03526306cd0b1e0457e3f74d6
gh pr ready 60 --repo jamesabilong/fresh-price-backend
gh pr merge 60 --repo jamesabilong/fresh-price-backend --merge --match-head-commit 68945dd319bbd583cd6ada52a027ae35970437e7
gh run watch 40266112449 --repo jamesabilong/fpdocker --exit-status --interval 20
gh pr ready 2 --repo jamesabilong/sugilanon
gh pr merge 2 --repo jamesabilong/sugilanon --merge --match-head-commit 8dc1a93015b72cd9ae4a7259e4ff52112cecf2ee
gh pr ready 58 --repo jamesabilong/fresh-price-front
gh pr merge 58 --repo jamesabilong/fresh-price-front --merge --match-head-commit 7d7cfb97683a462a3d617d004bbe5ecd43773a7d
gh run watch 40267161444 --repo jamesabilong/fpdocker --exit-status --interval 20
gh pr merge 27 --repo jamesabilong/fpdocker --merge --match-head-commit 16e8b1908c5b9c254d98b8961e19148df31297da
ssh -S /private/tmp/fp66-readiness-20261026/ssh-control -o BatchMode=yes root@107.174.250.249 'git -C /var/projects/freshprice/fpdocker pull --ff-only origin master'
ssh -S /private/tmp/fp66-readiness-20261026/ssh-control -o BatchMode=yes root@107.174.250.249 'python3 - prepare' < /private/tmp/fp66-release-20261026/rollout.py
ssh -S /private/tmp/fp66-readiness-20261026/ssh-control -o BatchMode=yes root@107.174.250.249 'python3 - caddy' < /private/tmp/fp66-release-20261026/rollout.py
ssh -S /private/tmp/fp66-readiness-20261026/ssh-control -o BatchMode=yes root@107.174.250.249 'python3 - strict' < /private/tmp/fp66-release-20261026/rollout.py
ssh -S /private/tmp/fp66-readiness-20261026/ssh-control -o BatchMode=yes root@107.174.250.249 'bash -s' < instructions/freshprice/scripts/backup-isolated-restore.sh
```

The private rollout script used argument-array `docker service update --detach=false --env-add` for the scoped backend/PhilWatch values, installed protected files, ran `caddy validate`/`adapt`, compared the complete normalized config, then `systemctl daemon-reload` and `systemctl restart caddy`. It checked one settled healthy task and preserved PostgreSQL/frontend specs. Secret values were never placed in command-tool text or printed. Verification ran read-only metadata/SQL/count/source checks, browser navigation, network-none old-image source hashing and public GETs. These private operation scripts/evidence are not a general deployment utility and are not published.
