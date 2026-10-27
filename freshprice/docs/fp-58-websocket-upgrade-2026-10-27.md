# FP-58 WebSocket delivery and recovery — October 27, 2026

The user requested instant messaging, reconnect handling, missed-message recovery and updates to the existing FP-58 PRs. This supersedes the polling-only transport described in the [initial publication](fp-58-review-publication-2026-10-27.md). Existing private REST APIs, saved-message receipts, participant permissions and schema remain compatible; no new migration is needed.

Candidates: backend `33243a06ad59fe37d13f9168192780f4bd0f09fd`, frontend `7c562364c37187a13d29db1189d29a3e307a95e1`, Docker proxy `fa5c15699c99657ee554d227aa03321d320b8a8d`. Application branches remain `FP-58`; Docker uses `FP-58-websocket-proxy`. Documentation is on `FP-58-docs`. No production deployment, service restart, flag change or pilot enablement is authorized by this verification/publication request.

## Transport and privacy

`/api/freshprice/messages/events` now accepts an authenticated WebSocket upgrade on the existing HTTP server. The browser derives ws/wss from the central API base and uses the existing HttpOnly session cookie. The server checks the actual browser Origin against configured origins (plus the same bounded development-origin policy as HTTP), JWT signature/expiry and current database account/role. Query-token/account/room parameters are rejected. There is no client-selected subscription or arbitrary private-conversation room.

The read-only event protocol is deliberately small:

| Frame | Meaning |
| --- | --- |
| `{ type: "ready", userId }` | Authenticated identity; client must match its active account and synchronize history/inbox |
| `{ type: "changed" }` | This account has message/block/seller-state changes; fetch its authorized current data |
| `{ type: "inbox" }` | Own read/archive state changed; refresh inbox without rereading conversation history |
| `{ type: "sync" }` | Database listener reconnected; recover from persisted history even if transient notifications were missed |

No message body, report reason, peer read cursor or conversation ID is transmitted in the socket event. Authoritative content is fetched immediately through participant-authorized keyset REST reads. Sending remains the idempotent REST transaction, retaining its length/rate/eligibility checks and stable client receipt. This produces instant incoming UI updates without creating a second message-write permission path or acknowledging unsaved messages.

The existing PostgreSQL database distributes tiny routing notifications across backend processes using LISTEN/NOTIFY. Events are queued inside the same transaction as message/control changes and are released only on commit; rollback and receipt replay do not publish another send. Each API instance maintains one dedicated reconnecting listener and routes events to its own authenticated sockets. Notification payloads contain account-routing metadata only. No Redis service or sticky-session requirement is added.

This follows [PostgreSQL's transaction-bound notification behavior](https://www.postgresql.org/docs/14/sql-notify.html) and the [ws authenticated-upgrade/heartbeat pattern](https://github.com/websockets/ws#client-authentication). PostgreSQL notifications and WebSockets are transient signals; the database sequence history is the recovery source.

## Reconnect and missed messages

- A ready frame triggers inbox and active-history synchronization. Reconnect starts near one second, adds jitter and backs off to at most thirty seconds. A stalled handshake times out; online/visibility changes resume immediately. Hidden/offline tabs close their stream and recover on return.
- Incremental history starts after the last contiguous fetched server sequence. The client merges by saved message ID, preserves sequence order, reconciles pending receipts and drains additional pages. A bounded batch continues immediately if more history remains; an event arriving during an in-flight fetch queues another pass rather than being lost.
- Incoming bursts are coalesced without indefinitely postponing refresh. Read advances publish an inbox-only event only after an atomic cursor advance; duplicate acknowledgements do not publish. Inbox responses include own unread total and messaging availability, avoiding extra count/config requests. Own read/archive changes do not refetch active message history. A sixty-second visible-tab consistency refresh remains as a fallback for lost signals or a proxy that cannot upgrade. It is not the normal delivery mechanism.
- Connection status is visible: connecting, live, reconnecting, offline or paused. Disconnecting never marks an outgoing message as saved. Failed unsaved sends still require explicit same-receipt retry; reconnect does not silently resend drafts.
- Account/session changes dispose the prior stream, timers and handlers. Ready-frame identity mismatch or close code 4401 clears private session state through the existing auth store and requests reauthentication. No credentials are put in URLs, persisted socket buffers or logs.

Server heartbeat is twenty-five seconds, with dead peers terminated and current account validity checked. Streams close on JWT expiry/account removal. Each account is limited to six active sockets and thirty upgrade attempts/minute; a separate 600/minute raw-peer pre-authentication ceiling bounds handshake abuse without trusting forwarding headers. Frames are capped at 256 bytes; application writes/subscription frames are refused, compression is disabled and slow-consumer buffers are bounded. Existing HTTP send/contact/control limits and disabled authentication exemptions are preserved.

Blocks and seller review/suspension changes push a refresh to existing contacts immediately. Eligibility is still rechecked on every new send. Messaging disablement preserves authenticated history and its stream while denying new contact/messages. Other catalogue/account changes retain server enforcement and the consistency refresh; there is no presence/typing/read-receipt feature in this change.

## Proxy and release order

Production nginx has a dedicated upgrade location for the event path, preserving Origin/cookie and existing trusted identity-header handling, HTTP/1.1 Upgrade/Connection headers, no buffering and a 75-second idle timeout. Heartbeats keep healthy streams active. The standard local nginx and Vite API proxy also support WebSocket upgrades. The current production Dockerfiles/nginx topology is the verified target; alternate legacy TLS/LAN proxy variants are not certified by this pass.

Release must include the Docker proxy configuration before the frontend image is built. Preserve prerequisite FP-57 backend #64/frontend #60 and backend/schema-before-frontend order. Keep seller/messaging pilot flags and authentication exemptions disabled in production until explicitly authorized. This update does not merge or deploy anything.

## Verification and remaining limits

External registration is `testing/tickets/FP-58/suite.json`. The final WebSocket database run is `testing/.local/fp58_1793111888072_1d93e6/summary.json`: 69 passed, zero skips, including 51 retained REST/database cases and 18 real WebSocket cases. These cover origin/auth denial, participant-only/private-content-free frames, rollback/replay, two backend instances, listener recovery, JWT expiry, account removal, socket/frame limits, disabled-history access and dead-peer detection.

Frontend coverage is 295 ordinary unit cases, including 24 messaging/transport cases. Inbox-only events and unchanged read acknowledgements have explicit regression coverage. It exercises reconnect/backoff, hidden/offline lifecycle, expired/mismatched/changed account handling, disposal, immediate invalidation, a racing in-flight fetch and recovery beyond a bounded page batch. Backend ordinary units remain 197. Lint and production build pass. The final unit/build logs are `testing/.local/fp58-ws-final-back2.log` and `testing/.local/fp58-ws-final-front2.log`.

Development Chromium evidence is `testing/.local/fp58_1793111900141_e9b141/summary.json`: 13 desktop + 13 mobile scenarios pass with zero skips/page errors. Real received WebSocket frames are recorded. Seller and peer replies arrive without Refresh within a three-second test deadline. Offline clients recover two messages and a 75-message/multiple-page backlog without reload. Existing sessions reconnect after a backend restart and receive another live reply. Blocks/suspension disable an already-open composer promptly, while a stale direct authenticated request still receives 403. Retained retry, reporting, pagination, literal-text, unread and disabled-pilot checks pass.

Production rehearsal `testing/.local/fp58_deploy_1793111979377_57a669/summary.json` passes all 26 production-built desktop/mobile browser scenarios and 15 operational checks, with zero skips/page errors and owned-resource cleanup verified. Canonical committed archives produce backend image `sha256:5d3a1a7958c79c0a0037ef6f85bbd73d3c9d554b780f459a716154b228f831ad` and frontend/proxy image `sha256:1dfbee4ca50e50b8dd22df43579f9f07dbcdf3be059251c18fcbe598bf33dda7`. Populated migration 43→44 preserves accounts/catalog/official prices/seller data; cold restart preserves collected messages/blocks/reports/audits. All-table synthetic dump/restore matches the original records and all 44 migrations, then real login/private history and disabled-write denial pass against the restored database. Exemptions remain false with zero rules/audits.

The first production WebSocket rehearsal exposed excessive refresh traffic under the unchanged 300-request/15-minute HTTP ceiling. Read/archive events now refresh only the inbox; no-op read acknowledgements do not publish, and inbox summaries avoid separate count/config requests. The complete production pass succeeds without increasing limits, creating exemptions or replacing actual authenticated browser sessions. The optimization's SQL placeholder-boundary regression was caught in the real database suite and corrected before the final 69-case pass. Failed-run reports remain local and are not accepted evidence.

Published updates: [backend #65](https://github.com/jamesabilong/fresh-price-backend/pull/65), [frontend #61](https://github.com/jamesabilong/fresh-price-front/pull/61), [Docker proxy #28](https://github.com/jamesabilong/fpdocker/pull/28), and [documentation #3](https://github.com/jamesabilong/agent_instruction/pull/3). Application and Docker PRs target master; documentation targets main. The [sanitized exact-source/test/rehearsal manifest](../evidence/fp-58-websocket-upgrade-2026-10-27.json) binds the committed candidates. Ordinary acceptance totals 587 cases (197 + 295 + 69 + 26), with the production-built browser pass counted separately. The legacy `test:e2e:chromium` FP-59 branch guard remains intact; its refusal is recorded at `testing/.local/fp58-ws-legacy-guard.log`, with dedicated FP-58 acceptance used instead.

Synthetic isolated verification does not establish live deployment, an actual production-backup restore, physical-device/on-screen-keyboard behavior, other browsers, installed-PWA upgrade or pilot/operator readiness. Expected offline/denied requests cause console errors; zero page errors is not a zero-console-error claim. Existing legacy React and browsers-data warnings are retained. Seller profile enrichment research and the pre-existing Docker README change are separate uncommitted work.
