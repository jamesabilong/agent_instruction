# FP-58 private messaging — local implementation, October 27, 2026

Later [seller-profile improvements](fp-57-profile-improvements-2026-10-27.md) are integrated into FP-58 and supersede the candidate heads/migration totals/test counts below. Transport contracts and the original production-image checkpoint remain valid historical evidence; current integrated source and regressions are in that follow-up.

[FP-58](https://fresh-price.atlassian.net/browse/FP-58) remains In Progress. The user requested continued implementation and screenshots, explicitly extending the seller inquiry flow to messages between ordinary users. Both flows are implemented and verified locally. This supersedes the [historical foundation checkpoint](fp-58-messaging-foundation-2026-10-27.md).

Current WebSocket candidates are backend `33243a06ad59fe37d13f9168192780f4bd0f09fd` / frontend `7c562364c37187a13d29db1189d29a3e307a95e1`, in [backend #65](https://github.com/jamesabilong/fresh-price-backend/pull/65) / [frontend #61](https://github.com/jamesabilong/fresh-price-front/pull/61) against master. [WebSocket upgrade, recovery and current verification](fp-58-websocket-upgrade-2026-10-27.md) supersede the polling-only [initial publication](fp-58-review-publication-2026-10-27.md). Docker proxy changes must ship before frontend; FP-57 remains a prerequisite for release. No production data, flags or services changed.

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
- Authenticated WebSocket events refresh incoming messages immediately. Reconnect uses bounded backoff and persisted sequence history to recover missed messages across offline periods and service restarts. A sixty-second visible-tab consistency refresh remains; hidden tabs pause and recover on return. Private state and late responses are isolated by account/session. No presence or peer read receipts are exposed.
- Notifications are generic and emitted after the message transaction commits. No private body appears in notification previews. Notification failure does not turn a saved message into a failed send; retries do not duplicate notifications. New incoming messages restore archived conversations to the inbox.
- Disabling messaging, blocking or suspension preserves participant history. Account/profile removal anonymizes nullable references and preserves the remaining participant's conversation. There is no message edit/hard-delete endpoint in this pilot.
- Reports expose at most twenty messages bounded by the report-time sequence, with an optional reported-message window. Each operator context view and resolution is audited transactionally. Operators cannot inspect or resolve their own participant conversations. Resolution requires the current revision; the queue is not a general private-inbox browser.
- Contact creation is limited to 10 requests/15 minutes per account, sends to 60/minute, and block/archive/report/moderation writes to 30/15 minutes. Existing authentication rate limits remain active; test exemptions were disabled throughout acceptance.

## APIs and additive schema

All endpoints below use `/api/freshprice/messages`, authentication and private/no-store responses. Inputs are allowlisted and validated. Expected errors are structured; database details are not exposed.

| Method/path | Request / behavior |
| --- | --- |
| `GET /config`, `GET /unread` | Availability/text limit/poll interval; own unarchived unread total |
| `GET /events` (WebSocket upgrade) | Authenticated Origin/cookie; account-bound ready/changed/inbox/sync invalidations; see current transport record |
| `GET /conversations` | Own inbox plus `unreadCount` and `enabled`; `page`, `limit` (max 100), `archived=true/false` |
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

Migration `20261027000002-private-messaging.cjs` is the original messaging-table migration following the baseline seller schema; the integrated seller-profile follow-up has 45 migrations, while FP-57 alone has 44. It adds `message_conversations`, `message_participants`, `message_contact_blocks`, `private_messages`, `message_reports` and `message_moderation_audits`, with their matching models. Unique pairs/receipts/sequences, read/value checks, lookup indexes, data-preserving nullable account/profile references and report audit constraints are enforced in PostgreSQL. The migration uses a transaction. Empty down/reapply passes; down locks all six tables and refuses collected conversations or blocks. Disable messaging rather than rolling back collected private data.

## Verification and screenshots

Current [WebSocket verification and limits](fp-58-websocket-upgrade-2026-10-27.md) and [exact-source manifest](../evidence/fp-58-websocket-upgrade-2026-10-27.json) supersede the historical polling-only [initial review](fp-58-review-publication-2026-10-27.md). External cases/fixtures/runners remain in `testing/tickets/FP-58`; executable seeders, raw reports and screenshots remain local in `testing/.local`.

Current ordinary acceptance: 197 backend + 295 frontend units, 69 real database/WebSocket cases and 26 desktop/mobile browser scenarios (587 total), zero skips. Frontend lint/build pass. Production-built proxy/restart/restore evidence is recorded in the upgrade record. Browser delivery checks use actual received WebSocket frames and replies within a three-second deadline without Refresh; offline multi-page recovery and backend restart are covered. Retained privacy, receipt retry, literal text, block/suspension, report/audit, pagination/unread and disabled-write history checks pass.

The legacy FP-59-only E2E branch guard remains intact; dedicated FP-58 verification is used. Physical devices/keyboards, other browsers, installed-PWA upgrade and live production/pilot are not certified. Expected denied/offline requests cause console errors; zero page errors is not zero console errors.

Screenshot index (same names under both final viewport folders): `browser-01-seller-entry.png`, `browser-02-seller-inbox.png`, `browser-03-seller-reply.png`, `browser-04-buyer-seller-chat.png`, `browser-05-new-user-message.png`, `browser-06-user-reply.png`, `browser-07-user-to-user-chat.png`. All show synthetic accounts and content from the implemented app.

## Remaining delivery gates

Review/commit/push/PR publication and isolated production-built deployment/migration/backup-restore verification are complete. Preserve the verified FP-57 prerequisite and backend-before-frontend schema release order. Normal review, authorized production deployment/verification and pilot operator/support readiness remain before declaring delivery complete. The isolated rehearsal is not a staging server, production backup restore or live pilot. Keep both pilot flags and authentication exemptions disabled in production until explicitly authorized. Jira remains In Progress.
