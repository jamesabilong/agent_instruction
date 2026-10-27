# FP-58 private messaging — local implementation, October 27, 2026

[FP-58](https://fresh-price.atlassian.net/browse/FP-58) remains In Progress. The user requested continued implementation and screenshots, explicitly extending the seller inquiry flow to messages between ordinary users. Both flows are implemented and verified locally. This supersedes the [historical foundation checkpoint](fp-58-messaging-foundation-2026-10-27.md).

Published backend/frontend `FP-58` candidates are `46c31dbd76ddd4e94876d2dd2145f606ab5ea7dc` / `cc78dac391970a171b34b9176f3a15c4ba26f7d9`, in [backend #65](https://github.com/jamesabilong/fresh-price-backend/pull/65) / [frontend #61](https://github.com/jamesabilong/fresh-price-front/pull/61) against master. They build on FP-57 candidates `b5fc98a1` / `db7e0e8c`. Documentation is on `FP-58-docs` above `5fd0d6d`. [Final review, deployment rehearsal and publication](fp-58-review-publication-2026-10-27.md) supersede the initial uncommitted checkpoint. FP-57 remains a prerequisite for release. No production data, flags or services changed.

## User flows

- Shopper to seller: open an approved seller's profile and select **Message seller**, or **Ask about this offer** on an available offer. The server resolves the seller account. The seller opens **Messages**, chooses the inquiry and replies.
- User to user: open **Messages → New message**, enter the exact FreshPrice username, then **Start conversation**. Both participants write in the composer and select **Send**. Email addresses are not exposed.
- The inbox includes unread counts, paging, archive/restore, refresh and private previews. Conversations include sending/sent/failed states, same-receipt retry, earlier history, block/unblock and private reporting. Narrow screens show either inbox or conversation, with an **All messages** return link.
- `/messages` and `/messages/:id` require the current authenticated account; user/admin sidebars link to Messages. `/admin/message-reports` is the report queue, with bounded context and access/resolution audit.

## Privacy, delivery and operational controls

- `FRESHPRICE_MESSAGING_PILOT` must be exactly `true` for new conversations/messages. Its absent/default value disables writes. Peer messaging is independent of the seller flag. Seller inquiries additionally require `FRESHPRICE_SELLER_PILOT=true`, an approved profile and an existing market; offer entry validates a fresh published available offer.
- One canonical peer conversation per account pair, and one seller conversation per buyer/profile. Only the two current participants can read/send/update read state/block/archive/report. A third account, including an operator outside reported-case access, receives 404. Actor identity always comes from authentication; roles are rechecked against the database.
- Account-wide directional blocks prevent contact across both seller and peer conversations. Either participant's block stops new messages; unblocking cannot remove the other participant's block. A suspended seller account cannot bypass suspension through peer messaging. Pair/profile/conversation locks serialize starts/sends/blocks with seller suspension.
- Messages have increasing server sequences and unique receipts scoped to conversation/sender/client UUID. Same-body retries acknowledge the persisted message; changed-body receipt reuse returns 409. Receipt acknowledgement remains available when new writes become disabled. Plain text is canonicalized and limited to 2,000 Unicode code points; malformed Unicode and NUL are rejected. React renders text literally.
- Read cursors update atomically and monotonically, never beyond the server sequence. Stable before/after keyset history returns at most 50 messages per request. The client merges and deduplicates incremental pages, reconciles lost-response receipts, preserves earlier-history scroll and acknowledges fetched messages when at the bottom.
- Polling normally runs every 15 seconds, backs off to at most 60 seconds after errors, pauses while hidden and stops on unmount. Private state and late responses are isolated by account/session. No transport presence or read receipts are exposed.
- Notifications are generic and emitted after the message transaction commits. No private body appears in notification previews. Notification failure does not turn a saved message into a failed send; retries do not duplicate notifications. New incoming messages restore archived conversations to the inbox.
- Disabling messaging, blocking or suspension preserves participant history. Account/profile removal anonymizes nullable references and preserves the remaining participant's conversation. There is no message edit/hard-delete endpoint in this pilot.
- Reports expose at most twenty messages bounded by the report-time sequence, with an optional reported-message window. Each operator context view and resolution is audited transactionally. Operators cannot inspect or resolve their own participant conversations. Resolution requires the current revision; the queue is not a general private-inbox browser.
- Contact creation is limited to 10 requests/15 minutes per account, sends to 60/minute, and block/archive/report/moderation writes to 30/15 minutes. Existing authentication rate limits remain active; test exemptions were disabled throughout acceptance.

## APIs and additive schema

All endpoints below use `/api/freshprice/messages`, authentication and private/no-store responses. Inputs are allowlisted and validated. Expected errors are structured; database details are not exposed.

| Method/path | Request / behavior |
| --- | --- |
| `GET /config`, `GET /unread` | Availability/text limit/poll interval; own unarchived unread total |
| `GET /conversations` | Own inbox; `page`, `limit` (max 100), `archived=true/false` |
| `POST /conversations/peer` | `{ username }`; canonical account pair |
| `POST /conversations/seller` | `{ sellerProfileId, offerId? }`; canonical buyer/profile |
| `GET /conversations/:id` | Own conversation capabilities and participant-safe metadata |
| `GET /conversations/:id/messages` | `before` or `after` sequence; `limit` default 30/max 50 |
| `POST /conversations/:id/messages` | `{ body, clientMessageId }`; persisted message and `replayed` |
| `PATCH /conversations/:id/read` | `{ throughSequence }`; monotonic own cursor |
| `PUT /conversations/:id/block` | `{ blocked }`; own account-wide contact block |
| `PUT /conversations/:id/archive` | `{ archived }`; own inbox state |
| `POST /conversations/:id/reports` | `{ reason, messageId? }`; one open report per reporter/conversation |
| `GET /admin/reports` | Operator-only paginated queue; optional `status` |
| `GET /admin/reports/:id` | Audited reported case and bounded context |
| `PATCH /admin/reports/:id` | `{ status, resolutionNote, revision }`; audited resolved/dismissed state |

Migration `20261027000002-private-messaging.cjs` is local migration 44, following FP-57's seller migration 43 and the deployed baseline 42. It adds `message_conversations`, `message_participants`, `message_contact_blocks`, `private_messages`, `message_reports` and `message_moderation_audits`, with their matching models. Unique pairs/receipts/sequences, read/value checks, lookup indexes, data-preserving nullable account/profile references and report audit constraints are enforced in PostgreSQL. The migration uses a transaction. Empty down/reapply passes; down locks all six tables and refuses collected conversations or blocks. Disable messaging rather than rolling back collected private data.

## Verification and screenshots

External fixtures, tests and runners live in `testing/tickets/FP-58`; executable seeders and raw reports/screenshots remain local under `testing/.local`, outside application and instructions Git repositories. [Final publication evidence](../evidence/fp-58-review-publication-2026-10-27.json) binds the committed source and final tests/rehearsal. The [initial uncommitted manifest](../evidence/fp-58-local-acceptance-2026-10-27.json) is historical.

| Verification | Actual result |
| --- | --- |
| Backend ordinary units, including 12 messaging rule cases | 197 passed, zero skips |
| Frontend ordinary units, including 10 messaging cases | 281 passed, zero skips |
| Real PostgreSQL / HTTP acceptance | 51 passed, zero skips |
| Real Chromium desktop and mobile-viewport flows | 10 + 10 passed, zero skips; zero page errors |
| Frontend lint / TypeScript and production build | Passed |
| Exact production-image desktop/mobile scenarios | 10 + 10 passed, zero skips/page errors |
| Isolated production-image operational/recovery checks | 15 passed, cleanup verified |

Final database evidence: `testing/.local/fp58_1793098172142_07434c/summary.json`. Review browser readback: `testing/.local/fp58_1793098104033_80e57f/{desktop,mobile}`. Exact committed production-image rehearsal: `testing/.local/fp58_deploy_1793098436018_4abfaa/summary.json`, including populated migration 43→44, full database/backend/nginx restart and full synthetic restore with actual private-history reads. Resource cleanup is verified. Unit/build logs are at `testing/.local/fp58-review-{backend,frontend}-checks.log`. Original screenshots delivered to the user remain at `testing/.local/fp58_1793094851000_3f8974/{desktop,mobile}`.

The 51 database cases cover third-account and stale-role denial, safe private projection, canonical and simultaneous starts, uppercase seller identifiers, current eligibility, malformed/oversized input, concurrent and changed-body receipts, tied pagination, read tabs/reload, account-wide and concurrent cross-mode blocking, suspension, disabled-write/history behavior, account/profile deletion, archive, post-commit notification failure/deduplication, report-time privacy, audit rollback/revision/self-review denial, and empty/collected-data migration rollback. Official prices remain unchanged.

The twenty browser scenarios exercise actual seller entry/replies and peer replies in separate signed-in sessions, a third unauthorized account, failed and lost responses, an open form during blocking/suspension, audited report resolution, populated history/unread reload, composer/scroll layout, and disabled-write retained history. Mobile means Chromium viewport emulation; a physical on-screen keyboard/device, other browsers and installed-PWA upgrades were not tested. Expected denied/network requests produce console errors in failure scenarios; zero page errors does not mean zero console errors. Existing React test warnings and the Browserslist age notice are retained in logs.

The legacy `npm run test:e2e:chromium` command refuses `FP-58` branches because its runner is intentionally bound to FP-59. Its guard was preserved. The dedicated `node testing/tickets/FP-58/run.mjs` acceptance above supplies real database/browser verification for this ticket; the legacy command is not claimed passed.

Screenshot index (same names under both final viewport folders): `browser-01-seller-entry.png`, `browser-02-seller-inbox.png`, `browser-03-seller-reply.png`, `browser-04-buyer-seller-chat.png`, `browser-05-new-user-message.png`, `browser-06-user-reply.png`, `browser-07-user-to-user-chat.png`. All show synthetic accounts and content from the implemented app.

## Remaining delivery gates

Review/commit/push/PR publication and isolated production-built deployment/migration/backup-restore verification are complete. Preserve the verified FP-57 prerequisite and backend-before-frontend schema release order. Normal review, authorized production deployment/verification and pilot operator/support readiness remain before declaring delivery complete. The isolated rehearsal is not a staging server, production backup restore or live pilot. Keep both pilot flags and authentication exemptions disabled in production until explicitly authorized. Jira remains In Progress.
