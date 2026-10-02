# FP-43 — Maintenance and missing-page recovery

Jira: https://fresh-price.atlassian.net/browse/FP-43
Drafted and implemented locally 2026-10-02. See `fp-43-recovery-runbook.md` for behavior, verification and rollout. Jira update remains unavailable through the connected tool.

## Description
Provide clear, mobile-friendly recovery screens when FreshPrice cannot reach its API or a visitor opens a broken link. The screen itself must load without API data or authentication. Use a consistent FreshPrice design with distinct messages for temporary service unavailability, offline connectivity, missing pages/content, and unexpected application errors.

Keep the requested URL and unsaved form input during temporary outages. Never present a failed request as a successful save or automatically replay a write.

## User-facing states
- **API unavailable:** “FreshPrice is temporarily unavailable. We’re having trouble connecting. Please try again shortly.” Show **Try again** and **Go home**. Use this for confirmed API unavailability, including connection failures, timeouts, and gateway 502/503/504 responses. Do not claim scheduled maintenance unless maintenance mode is explicitly enabled.
- **Offline:** “You appear to be offline. Check your connection and try again.” Preserve already loaded content with a stale/offline label where supported; disable actions that require a confirmed server response.
- **Broken link:** “Page not found. This link may be incorrect or the page may have moved.” Show **Go home** and **Back** with a safe home fallback. Cover unknown routes and missing/deleted product, recipe, or community content.
- **Unexpected error:** “Something went wrong.” Provide a safe retry/reload option through the existing route error boundary.
- **Planned maintenance:** Reuse the unavailable layout with explicit maintenance copy only when enabled through deployment configuration.

## Expected behavior / acceptance criteria
1. Unknown public, user, and admin URLs show the not-found screen, including direct visits and page refreshes. Protected URLs continue to enforce existing authorization.
2. A confirmed resource 404 shows content-not-found; an API 404 alone never triggers global maintenance. Authentication/authorization errors, validation errors, and rate limits keep their existing appropriate handling.
3. API downtime is handled both on initial load and during an active session. One failing optional/background endpoint does not take over the entire app.
4. Outage detection uses bounded request timeouts and a deduplicated readiness check. If the check also fails, show service-unavailable on API-dependent views. A browser network error is described as a connection problem, not proof of server maintenance.
5. Try again is disabled while checking, prevents overlapping checks, and restores the original view after readiness and its required read requests succeed. No redirect/reload loop or automatic resubmission of POST/PUT/DELETE requests.
6. Preserve session state and in-memory form values across the outage screen. Never clear authentication because of a timeout or 5xx response. Existing logout/session isolation rules still apply.
7. Screens are accessible by keyboard and screen reader, have a meaningful page title and focused heading, and work on narrow/mobile layouts. Their text, styles, and essential assets are bundled locally.
8. The production server continues to serve the SPA for valid deep links. Missing assets and API paths must not receive index.html. Maintenance/health responses must not be cached as successful data by the service worker.
9. Supply an independent static maintenance fallback for planned maintenance or frontend upstream failure at the serving proxy where feasible. Return HTTP 503 with Retry-After for that fallback. API endpoints retain JSON error semantics. Document that a total DNS/TLS/hosting outage requires an independently hosted edge fallback.

## Implementation plan
1. **Confirm routing and deployment behavior.** Inspect the React router, existing RouteErrorBoundary, Axios client, PWA caching, readiness endpoint, and active production proxy. Specify which failures are local to a view and which confirm broader unavailability.
2. **Build shared recovery UI.** Add reusable layouts and accessible copy for unavailable, offline, not-found, and unexpected-error states. Add wildcard routes and map missing resource responses to content-not-found.
3. **Centralize availability handling.** Extend API error classification and introduce a small availability coordinator. Use a bounded, uncached, unauthenticated readiness request, with no interceptor recursion or request storms. Check API/database readiness without exposing diagnostics. Keep forms mounted while displaying the temporary fallback.
4. **Add recovery controls.** Retry reads explicitly, preserve the current path/query, and suppress duplicate checks. Pause any optional background retries while hidden/offline; use capped backoff if automatic checks are added. Clear the outage state only after successful recovery.
5. **Add deployment fallback.** Configure a static page and an explicit maintenance switch independent of the API process. Preserve API status codes and valid SPA deep links. Document enable/disable and rollback steps for the actual deployment topology.
6. **Verify and release.** Add unit tests for error classification/state transitions and Chromium tests for direct broken links, missing resources, API-down startup, mid-session failure, offline mode, repeated retry, recovery with unsaved input, and unaffected authentication. Test production-build deep links, missing assets, static 503 responses, and service-worker behavior locally/staging. Run lint, unit tests, build, and relevant backend/proxy checks. Update FreshPrice documentation before release.

## Scope notes
This ticket covers the recovery experience and its deployment fallback. It does not implement offline writes, automatic write replay, an incident-management dashboard, or infrastructure high availability. SPA not-found screens may initially return HTTP 200 from the static host; genuine document-level 404 status requires route-aware hosting and should be tracked separately if needed.

