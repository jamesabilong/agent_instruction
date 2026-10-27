# FP-58 messaging foundation — October 27, 2026

> Historical initial checkpoint. Superseded by the [implemented seller and user messaging flows, actual verification and remaining delivery gates](fp-58-messaging-2026-10-27.md). Statements below about missing routes/schema/UI and requiring both flags describe that earlier checkpoint, not current FP-58 source.

[FP-58 Private text messaging](https://fresh-price.atlassian.net/browse/FP-58) is now In Progress in active sprint 339, after FP-57's final verification. The user asked to start this next ticket; this is an initial implementation checkpoint, not messaging delivery.

Backend/frontend `FP-58` branches start from the verified FP-57 candidates `b5fc98a1` / `db7e0e8c`; working documentation is on `FP-58-docs` above FP-57 verification commit `5fd0d6d`. These branches are intentionally stacked on the seller prerequisite, which still requires its own authorized merge/deployment before FP-58 release. FP-58 work is local/uncommitted; the FP-57 PR branches are unchanged.

## Implemented foundation

- Backend `messagingRules.js`: disabled-by-default messaging requires both seller and messaging flags explicitly true. Strict UUID v4 and field allowlists reject client overrides of sender/participant/conversation identity.
- Message input canonicalizes line endings/outer whitespace, bounds well-formed Unicode text to 2,000 code points and rejects NUL/lone surrogates. Literal HTML-like text remains plain text for the eventual React view; it is not interpreted as HTML.
- Keyset message inputs support one `before` or `after` direction, default 30/max 50 rows, bounded sequence IDs and no repeated/ambiguous cursor values.
- Read-state inputs are bounded and their helper prevents a cursor decrease or acknowledging a future sequence. Block/report payloads are allowlisted/bounded; a reused message receipt with changed normalized body conflicts.
- Twelve external unit cases are registered in `testing/tickets/FP-58/suite.json`, with synthetic fixture requirements and an acceptance map. The complete backend ordinary unit suite passes 197 cases, including all 12 new foundation tests.

No public messaging route, migration, conversation/message persistence, inbox, polling, notification or moderation API is implemented yet. Passing these rules tests does not establish participant authorization, concurrency, persistence or UI correctness. Existing application routes behave as before.

## Implementation policy selected for the next phases

- One canonical buyer/account + seller-profile conversation. Only a signed-in other account may initiate against an approved eligible seller; a seller can reply to an existing participant conversation. The server resolves the seller owner from the profile, never a supplied recipient account ID. Roles remain unchanged.
- Exactly two participant roles. Every history/read/send/block/report request must resolve the current authenticated participant; nonparticipants receive a non-enumerating 404. Admin role alone gives no conversation access.
- Serialize new sends and blocks on the conversation; serialize sends with FP-57 suspension on the seller profile in a consistent lock order. Persist a unique per-conversation increasing sequence and a unique `(conversation, sender participant, client message ID)` receipt. Same-body retry acknowledges the existing message without another notification; changed-body reuse returns 409. Existing-message acknowledgement is not a new send.
- New contact/messages require both flags, an eligible approved seller/market, two current accounts and neither participant blocking. Suspension/block/feature disable stops new messages immediately; participants retain private history. Participants may archive an inbox entry; no hard-delete or message-edit UI in the pilot. Account removal should anonymize that participant/reference and retain the remaining participant's history rather than cascade-delete the conversation.
- Store a monotonic read sequence using an atomic database update, bounded by that conversation's server sequence. Derive unread counts from other-participant messages above the cursor. Use keyset history/incremental reads with stable sequence order; changing inbox activity requires refresh/deduplication rather than a cross-request snapshot claim.
- Commit messages before reusing the existing notification mechanism. Notification failure must not make a committed send appear failed; recipient polling recovers missed notifications. Never put private message bodies into general notification previews.
- Report a conversation/optional accessible message with a private reason. Operators may inspect only reported cases, with bounded context and an audit of every access/resolution. No general admin private-inbox browser. Operators cannot resolve their own reports or reports about their own participant conversation.
- Start with visibility-aware bounded polling (15 seconds normally, backoff capped at 60 seconds), stop hidden/unmounted/changed-account requests and reject stale responses. Show sending/sent/failed and retry states. Attachments, group chats, presence, typing indicators, read receipts and budget-sharing membership are outside scope.
- Additive migration 44 is the next schema phase: conversations, participants/read cursors, immutable messages, reports and moderation access audits. Data-preserving account references, uniqueness/check constraints and collected-data rollback refusal need real PostgreSQL regressions before APIs/UI are accepted.

## Next work and verification

Implement schema/models, then participant-authorized endpoints, transactional idempotency/read-state/notification behavior, and finally inbox/conversation/report UI. Register real integration/browser scenario counts as those phases are implemented. The external acceptance map already lists third-party denial, two real sessions, lost/concurrent retries, pagination completeness, unread reload/tabs, open-form block/suspension, notification-failure persistence, report-only audited access and mobile keyboard/scroll requirements.

FreshPrice API/schema docs are to be updated when actual routes/tables exist; the policies above are not deployed contracts. Frontend lint/build/browser checks and FP-58 PostgreSQL/staging acceptance remain pending until their implementations exist. No pilot flag, production service, real account or data changed.
