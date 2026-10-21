# Authentication testing exemption investigation — 2026-10-21

Status: **deferred by user to next planned sprint; tracked as FP-66**. No bypass or production change applied.

User requested dynamic IP exemptions managed from the admin UI for their own authorized test accounts. Created [FP-66 — Admin-managed dynamic IP exemptions for authentication testing](https://fresh-price.atlassian.net/browse/FP-66), Story, To Do, assigned to future sprint **338 — Wiki and Shopping Integration**. Verified persisted description/status/sprint through Jira read-back. No duplicate found; connector is read-only, so creation/assignment used the authenticated Jira browser UI. Sprint remains future; no dates or other tickets changed.

Ticket includes the confirmed proxy-identity correction prerequisite, exact account/IP scope, explicit updates on IP changes, default one-hour expiry with bounded maximum, revocation, admin authorization/recent reauthentication, audit/redaction and lockout recovery. Normal passwords/session/role checks remain required. Scope has been scheduled for later implementation, not activated now. Proof: `output/jira/FP-66-created.png` in the workspace.

User requested a testing bypass after the authentication throttle. Current production settings permit ten login/register/password-reset requests per fifteen-minute window, with a separate global API limit of 300 per fifteen minutes. The default key is Express's client IP, not the username.

## Confirmed proxy issue

- A harmless GET to `/api/platform/auth/?probe=fp-auth-ip-check-20261021` succeeds without credentials or consuming the auth-specific POST quota. Cloudflare trace identifies a public client address, but backend Morgan logs identify the same probe as Docker gateway `172.19.0.1`.
- Express production trusts one proxy hop; nginx appends its peer to X-Forwarded-For. Caddy targets `127.0.0.1:8081`; read-only adapted configuration reports no trusted-proxy/client-IP settings or custom forwarding-header settings.
- Public requests through this route can therefore share auth/global API rate-limit buckets. The earlier explanation that only people sharing a public IP are affected was incomplete. Do not exempt this gateway/private subnet: it could exempt other visitors too.

## Proposed implementation constraints

For a live IP-scoped exemption, first establish trustworthy end-user identity across Cloudflare → Caddy → nginx → Express. Verify client separation and resistance to forged forwarding headers/alternate public origin paths. Do not blindly increase trusted hop counts or trust arbitrary headers.

Then use disabled-by-default configuration matching one verified tester IP with an absolute short expiry. Exempt only the authentication request throttle; passwords, sessions, roles and other request limits remain enforced. Test expiry, invalid/missing configuration, non-tester traffic and spoofed headers. A public-IP exemption also affects other people on the same NAT; disclose that limit. Never use a permanent username exemption or ship testing credentials in the frontend.

Local-only testing should leave production untouched. The user answered the testing-scope question by deferring this work to the next sprint and requesting admin-side dynamic management; that supersedes the pending immediate-exemption question. No source change, commit/push, PR mutation, service restart or live exemption applied. Dirty FP-63 work preserved. PhilWatch's separate public path has not been independently probed and is included in FP-66 verification scope.
