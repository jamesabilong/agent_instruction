# PhilWatch legacy service-worker recovery

## Production evidence — 2026-10-09

- `https://philwatch.com/` returns the PhilWatch Next.js document with `Cache-Control: private, no-cache, no-store, max-age=0, must-revalidate` and Cloudflare `DYNAMIC`. The homepage is already excluded from HTTP caching.
- `https://philwatch.com/sw.js` returns a Next.js HTML 404. Removing a worker script does not unregister a worker previously installed in a browser.
- `http://philwatch.com/` redirects to the HTTPS apex (308); `https://www.philwatch.com/` redirects to the HTTPS apex (302). Neither response redirects to FreshPrice.
- `https://freshprice.philwatch.com/sw.js` still returns `Cache-Control: max-age=14400`. The earlier FreshPrice worker-header fix is absent from the current production response and the starting Docker checkout.

An obsolete FreshPrice worker installed on the apex is the likely explanation for the reported wrong-app first load followed by a successful hard refresh. A worker registered only on the FreshPrice subdomain cannot control the apex: browser registrations and caches are scoped to an origin. The affected user's actual registration has not been inspected, so the historical wrong-host installation remains an inference. A controlled Chromium reproduction establishes that this mechanism produces the reported behavior.

## Local fix

- Sugilanon's `src/app/sw.js/route.ts` serves a replacement JavaScript worker at the legacy URL with browser, generic CDN, and Cloudflare `no-store` headers.
- The replacement skips waiting, unregisters itself, removes only Workbox precaches for its own scope, and reloads windows already controlled by the old worker. It has no fetch handler and does not claim healthy, uncontrolled PhilWatch windows.
- `RetireLegacyServiceWorker` checks only an existing root `/sw.js` registration when PhilWatch mounts, then requests an update. It never registers a worker for new visitors. This also retires a legacy registration after a successful hard refresh.
- Both production nginx variants serve FreshPrice `/sw.js` with `no-store`, and the manifest with the correct MIME type and revalidation headers. CDN caching is disabled for both URLs; hashed assets retain their one-year immutable policy.
- Cookies, localStorage, IndexedDB and unrelated caches are preserved. No `Clear-Site-Data` storage reset is used.

The fixes are committed locally: `a459648` on `fpdocker` branch `FP-64` and `b15da39` on Sugilanon `main`. They have not been pushed or deployed. Recovery depends on an online worker update; an affected visit may initially show the old page until the replacement activates. Keep the retirement endpoint available for returning devices.

## Verification

- Sugilanon lint and production build pass, including TypeScript and the `/sw.js` route.
- Isolated Chromium: installed a legacy navigation-caching worker, changed its script to a 404, and confirmed normal reloads continued to display FreshPrice. Serving the actual replacement route restored PhilWatch automatically, removed the worker registration and its precache, and preserved a localStorage sentinel and unrelated cache. Subsequent reloads stayed on PhilWatch.
- Chromium also verified that new visitors get no registration, recovery leaves a second origin's worker untouched, and the layout's update check retires an old worker after bypassing it to load PhilWatch.
- HTTP and TLS nginx syntax and response checks pass: worker/manifest headers and immutable assets. The expanded maintenance suite passes, including deep links, missing assets, planned maintenance, disconnected Caddy fallback and JSON API failures.

## Release and live verification

1. Publish the Docker changes to `fpdocker` master before the app dispatches, following repository authorization rules.
2. Release Sugilanon through `sugilanon-updated` so the apex serves the retirement route and client update check.
3. Rebuild/release the FreshPrice frontend through `frontend-updated`. A Sugilanon-only dispatch does not rebuild the frontend image containing nginx.
4. Purge these exact Cloudflare URLs after release: `https://philwatch.com/sw.js`, `https://freshprice.philwatch.com/sw.js`, and `https://freshprice.philwatch.com/manifest.webmanifest`.
5. Check both worker URLs with `curl -sS -D - URL -o /dev/null`: require HTTP 200, a JavaScript content type, `Cache-Control: no-store`, and no persistent Cloudflare cache HIT/positive Age. Check the FreshPrice manifest MIME/revalidation policy and a hashed asset's immutable policy.
6. Reopen PhilWatch normally on an affected device, allow the online update to finish, then revisit it. Confirm it stays on PhilWatch and no root legacy worker remains. Verify the real FreshPrice subdomain still has its normal PWA behavior.

The targeted purge requires access to the site's Cloudflare account. Do not substitute a whole-zone purge. If live responses still have a positive TTL, inspect Cloudflare cache-rule overrides and the deployed nginx image before closing the incident.
