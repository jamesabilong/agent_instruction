# FP-66 implementation start — October 22, 2026

At the user's request, Jira FP-62 and FP-63 were moved to Done through the authenticated browser after their deployed release/backup verification completed. FP-66 was moved from To Do to In Progress in active sprint 338. The board visibly shows two Done and one In Progress; local proof is retained outside this repository.

The first local implementation slice is the shared client-IP trust boundary. Backend and Docker example changes are on local `FP-66` branches from the released master commits. Nothing is deployed or enabled in production by this work.

## Initial behavior

- Replaces Express's numeric one-hop proxy trust with an explicit identity middleware before logging and rate limiting. Socket mode is the safe default and ignores forwarding headers; requests in that mode cannot qualify for a future testing exemption. This default alone does not separate production visitors behind the Docker gateway.
- Optional authenticated-edge mode requires a protected random 32-byte-or-longer base64url assertion credential, overwrites the request identity only after constant-time credential validation, canonicalizes a single exact IPv4/IPv6 address and rejects malformed/duplicate/missing assertions. It never falls back to a shared socket bucket on invalid edge assertions.
- Removes the assertion credential from parsed/raw request headers before downstream logging/handlers. Existing limiters use the canonical verified identity and retain IPv6 subnet grouping. Password/session/role checks are unchanged. Only the exact existing read-only DB readiness GET/HEAD remains available without an edge assertion.
- Docker examples describe Caddy's trusted CDN CIDRs/right-to-left parsing and overwriting both custom headers on the existing FreshPrice and PhilWatch proxy routes. They are integration snippets, not an automatic installer. A credential is needed because Docker gateway and alternative nginx/Next origin paths cannot safely authenticate a caller by hop count/private subnet alone. Protect internal hops/configuration/admin access; no credential belongs in browser bundles or Git.

The integration follows Caddy's [trusted proxy parsing](https://caddyserver.com/docs/caddyfile/options) and [upstream-header configuration](https://caddyserver.com/docs/caddyfile/directives/reverse_proxy). The future operator must verify current CDN ranges against [Cloudflare's published ranges](https://www.cloudflare.com/ips/). No public range list is guessed or activated here.

## Verification and remaining work

The targeted identity suite passes 25 checks, including local real HTTP limiter separation/spoofing, IPv4/IPv6 equivalence/grouping, duplicate/malformed assertions, header redaction, readiness scope and default socket behavior. JavaScript syntax checks pass. The initial sandboxed run could not complete local listeners and was stopped; the permission-enabled rerun passed. The broader shared-backend unit regression also passes: 31 files, 244 tests, zero failures/skips. Tests use the local sibling testing workspace; no full FP-66 database/browser acceptance is claimed.

This starter is not release-ready. Finish/test both actual proxy paths and server-side API consumers before strict mode can ship: internal SSR requests do not have a browser visitor assertion, and need an explicit safe policy rather than receiving the visitor-assertion credential indiscriminately. Validate installed Caddy syntax/version, preserve TLS/maintenance behavior, and verify independent real public clients/direct-origin spoof resistance. The image-only deployment workflow does not reconcile new Swarm environment values; use a separately reviewed targeted rollout. No production configuration was changed.

Remaining FP-66 feature work: persisted exact own-account/IP rules with additive migrations; server-side current admin authorization and recent password reauthentication; default one-hour/bounded expiry; explicit IP replacement and revocation; login-only enforcement retaining global/register/reset protection; shared-replica/restart/concurrency behavior; redacted audit; admin management UI; normal cooldown/reset and audited operator recovery; full database/API/browser acceptance for both FreshPrice and PhilWatch.
