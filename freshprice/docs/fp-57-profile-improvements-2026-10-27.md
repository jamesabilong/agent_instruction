# FP-57 seller profile improvements — October 27, 2026

The user selected seller-profile improvements after the FP-58 WebSocket work. This extends the reviewed seller pilot with resumable setup, owned profile/cover photos, buyer preview, a short introduction, a landmark, opening hours and optional website/Facebook/Instagram links. The [research proposal](seller-profile-design-research-2026-10-27.md) supplies design context; this record describes the implemented subset. Orders, payment, ratings and delivery remain outside scope.

| Candidate | Exact source | PR |
| --- | --- | --- |
| FP-57 backend | `62547612f2383f1b82b28c9794ee9a73d1d9fa13` | [#64](https://github.com/jamesabilong/fresh-price-backend/pull/64), master |
| FP-57 frontend | `20104ded2054e87284f29d7c84371828ba89edeb` | [#60](https://github.com/jamesabilong/fresh-price-front/pull/60), master |
| Integrated FP-58 backend | `2bd4fb48253f95e4816b253053a10e7520690b5d` | [#65](https://github.com/jamesabilong/fresh-price-backend/pull/65), master |
| Integrated FP-58 frontend | `f97e2f8141305202555821e4777003d71142c1fa` | [#61](https://github.com/jamesabilong/fresh-price-front/pull/61), master |

Documentation is updated in [FP-57 notes #2](https://github.com/jamesabilong/agent_instruction/pull/2) and propagated to dependent FP-58 notes. The [sanitized evidence](../evidence/fp-57-profile-improvements-2026-10-27.json) binds source blobs and external test/report hashes. Existing [initial verification](fp-57-final-verification-2026-10-27.md) and [initial publication](fp-57-review-publication-2026-10-27.md) remain historical checkpoints. Jira stays In Progress; no merge/deploy/production configuration or pilot enablement occurred.

## Setup and publication

The dashboard guides Stall details → Photos → Hours & links → Buyer preview. Save draft accepts incomplete required details and resumes from the signed-in account after reload. Private contact remains explicitly separated and never appears in buyer preview/public responses. Failures retain local input; server and draft revisions prevent another tab or moderation change from silently overwriting newer work. A stale draft can be discarded and restarted from the current submitted profile.

Saving a draft does not change the current approved public profile. Submission validates required fields and submits the saved revision atomically with the review audit, then removes the draft. Existing publication policy is preserved: submitting an approved profile changes it to pending and hides offers until approved again. A separate pending revision that leaves the old public version live is future scope. Suspended sellers cannot save/upload/submit; disabling the pilot preserves private draft/profile/media history while stopping new writes/discovery.

## Photos, details and links

Profile and cover photos are optional. The owner uploads one actual decoded JPEG/PNG/WebP at a time (5 MiB input, 20 million pixels); shared image processing strips metadata, produces WebP and bounds output to 512 pixels for avatars / 1280 for covers and 500000 bytes. Display uses a square profile image and wide cover crop; there is no interactive crop editor. Draft upload atomically saves the photo reference/revision. Replacing/discarding draft photos removes only unreferenced owner binaries and preserves the current submitted/approved images.

Processed photos live in a dedicated PostgreSQL BYTEA table so a normal database dump/restore includes them. They are never placed in the shared public upload directory. Owner-only image reads protect drafts; operator reads require a reference from an actually submitted profile, and public reads recheck pilot availability, current approval, market availability and the current image reference. All reads are private/no-store. Approval publishes text, links and photos together; suspension hides the public image URL too. Draft/public images cannot be attached across accounts or photo slots.

Hours are either absent or a complete seven-day same-day schedule in Asia/Manila, including closed days. Unknown hours show an explicit fallback; no inferred Open now/response-time badge. External links require public HTTPS without credentials or custom ports. Facebook/Instagram use exact supported hosts and direct Page/profile formats, rejecting lookalikes/redirectors/post links. No external URL is fetched for previews. Public links display their hostname and open with noopener/noreferrer/nofollow/ugc. The directory and public page show cover/avatar, introduction, About, visit details and supplied links; absent images/details have useful fallbacks. FP-58 places Message seller beside the profile identity and retains offer inquiry buttons.

## Compatible APIs and schema

All routes are under `/api/freshprice/sellers`:

| Route | Contract |
| --- | --- |
| `GET /me` | Own profile/latest review plus private draft |
| `PUT /me/draft` | Partial public/private values, optional current draft revision and current profileRevision; owner-bound optimistic write |
| `DELETE /me/draft` | Current draft revision; discard and prune only unreferenced photos |
| `POST /me/draft/submit` | Current draft revision; validate complete application and submit transactionally |
| `POST /me/draft/media/:slot?revision=N` | Owner-only multipart image, slot avatar/cover; current draft revision |
| `GET /me/media/:id` | Owner-only private processed image |
| `GET /admin/media/:id` | Current operator; submitted-profile referenced image |
| `GET /media/:id` | Current approved/public referenced image only |

Legacy `PUT /me` remains compatible and preserves existing optional details when omitted by an older client. Public/own/operator profile output adds tagline, landmark, hours, website, facebook, instagram, avatarId and coverId through a strict public projection. No private contact/report/reviewer output is added to public profiles.

Additive migration `20261027000003-seller-profile-details.cjs` adds profile details JSONB, private drafts and bounded processed media with account-deletion cascades, shape/size/revision constraints and ownership checks in services. Its down migration locks the affected tables and refuses collected details/drafts/photos. FP-57 has 44 migrations; the integrated FP-58 tree has 45 because its existing private-messaging migration also applies. Preserve schema/backend-before-frontend release and the FP-58 nginx proxy dependency. Never roll back collected details/photos destructively to recover availability.

## Verification and limits

FP-57: 194 backend / 281 frontend unit cases, 45 real PostgreSQL/HTTP checks and 18 desktop/mobile browser scenarios pass (538 total), zero skips; lint and production build pass. New cases cover partial resume, cross-account ownership, media slots/visibility/processing/limits, stale writes/uploads, moderation changes, duplicate/concurrent draft writes, old-client preservation, audit rollback, replacement/discard, suspension, disabled history and migration rollback safety. Browser flows exercise actual save/reload, uploads, hours/links, private preview, approval/public images, literal text, offer controls, reporting and directory paging.

Production rehearsal `testing/.local/fp57_deploy_1793113530798_8a639b/summary.json` builds canonical committed archives with production nginx/Dockerfiles. All 18 browser scenarios and 14 operational checks pass, zero page errors/skips; cleanup is verified. Populated migration 42→44 preserves accounts/catalog/official prices. Full database/backend/nginx restart retains data; synthetic dump/restore includes drafts and image bytes, matches all retained row fingerprints/all 44 migrations and serves the restored private draft and processed photo through the actual backend with the pilot disabled. Exemptions remain disabled with zero rules/audits. This is the user's accepted local staging alternative, not an actual production backup.

FP-58 integration preserves live seller-state notifications and seller/offer message entry. 206 backend / 305 frontend units, lint/build, 69 messaging database/WebSocket cases and 26 messaging desktop/mobile scenarios pass. Together with seller acceptance above, 669 ordinary cases are covered without double counting the separate FP-57 unit suites. The new integrated FP-58 source is verified by database/development browser regression; the production-image rehearsal in this record certifies the FP-57 candidate.

Development seller screenshots: `testing/.local/fp57_1793113202435_a27a27/{desktop,mobile}/{profile-setup-preview,seller-profile-details}.png`. Solid-color photos are synthetic validation fixtures, not seller/product photographs. The legacy FP-59-only E2E guard correctly refuses these branches (`testing/.local/fp57-profile-legacy-guard.log`). Earlier synthetic audit-trigger quoting failure was corrected in the test helper before the final 45-case pass; no app defect or failed run is claimed accepted. Expected denied/offline requests cause console errors; zero page errors does not mean zero console errors. Existing React/Browserslist warnings remain.

Gallery/offer photos, public phone, assisted image cropping and pending-public-revision editing remain future scope. Physical device/keyboard, other browsers, installed-PWA upgrade, actual production deployment/backup restore and pilot/support readiness are not certified. Keep production seller/messaging flags and exemptions disabled until separately authorized.
