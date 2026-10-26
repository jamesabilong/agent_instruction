# FP-66 readiness continuation — October 26, 2026

The user authorized remaining release-readiness checks and publishing the agent-instructions repository, explicitly withholding merge/deployment authorization. All four [feature drafts](fp-66-publication-2026-10-26.md) remain the release candidates. No production migration, configuration change, restart, deployment, exemption or feature mutation was performed.

## Newly completed checks

- Both public sites pass baseline read-only health: FreshPrice `/healthz`, PhilWatch `/health`, and `/api/platform/db/health` through each domain return 200 with `Cache-Control: no-store`; both database responses report healthy. These four requests come from one network origin. They do not verify app revision, migration count, backup, actual visitor separation or FP-66 deployment.
- Retrieved the current [official Cloudflare IPv4](https://www.cloudflare.com/ips-v4) and [IPv6](https://www.cloudflare.com/ips-v6) lists: 15 + 7 public networks, no duplicates/private/default ranges. Exact fetched-content hashes are retained in the [sanitized evidence](../evidence/fp-66-readiness-2026-10-26.json). These lists require revalidation at rollout time.
- Adapted and validated both reviewed Caddy snippets with all 22 official public ranges using cached local Caddy **v2.11.4** in disposable read-only, network-none containers without published ports. Verified strict parsing, `X-Forwarded-For`, visitor-IP/key overwrite and internal-key removal in both domain proxy policies. Only a synthetic credential and HTTP fixture sites were used. This validates the candidate snippets with a local version, not installed production Caddy, production TLS/maintenance configuration, actual CDN ingress or real independent clients.
- Confirmed separate instructions repository `main` matches its fetched remote before publication. Backend draft #60 still targets master, is draft/MERGEABLE and retains exact reviewed head `68945dd`. Full four-draft verification and 271/303 units/both app builds are retained in the [publication](fp-66-publication-2026-10-26.md) and [review](fp-66-review-2026-10-26.md) records; no source changes in this continuation.

The first range fetch using Python's default user-agent was denied; curl retrieved the official lists. Two local adapter assertions initially assumed a JSON boolean and a different expanded placeholder/header casing. Actual adapter output uses strict-mode value `1`, `{http.vars.client_ip}` and case-preserving deletion names; assertions were corrected to test that exact representation and case-insensitive HTTP names. Final adaptation/validation and both policy assertions pass. No application assertion or trust policy was weakened.

## Checks pending authenticated SSH

Existing noninteractive SSH authentication was rejected (`Permission denied (publickey,password)`). No app terminal is attached. Requested a user-authenticated, locally protected multiplex connection so command tools can intentionally reuse the user's password-authenticated SSH session without handling the password. Never put the password in chat, files, environment or command arguments.

Until authenticated access is available, these are **unverified**, not passed:

1. Installed Caddy version/modules, active versus file configuration, both exact upstream routes, right-to-left public CDN trust, credential placement, protected admin endpoint/config permissions, and preservation of TLS/maintenance behavior. [Caddy documentation](https://caddyserver.com/docs/caddyfile/options#trusted-proxies-strict) documents strict parsing since v2.8; local v2.11.4 success does not establish installed-version compatibility.
2. Actual running service/image identities, existing live 41-migration baseline, database identity/volume/private connectivity, PostgreSQL guard and protected backup inventory/age. Public health alone cannot establish these facts.
3. FP-66 exact migration 41→42 and recovery on an isolated restored production backup. Earlier October 22 recovery certified the then-current 41-migration release, not FP-66. Local synthetic FP-66 migration tests remain passing but do not close the restored-production-data gate. Do not create a new production backup without authorization for that operation; inspect the existing protected backup first and keep its age explicit. Never restore/rehearse into production.

## Later authorized rollout and activation gates

The following need a separately authorized rollout and cannot be certified against undeployed FP-66 code:

- Install separate protected edge/content credentials and coordinate targeted Swarm settings, preserving the on-host environment for later full-stack updates. Do not generate/publish real credentials or configure services in this readiness continuation.
- Publish Docker release configuration first, then deploy compatible backend/schema before the admin frontend with exemptions disabled; coordinate PhilWatch server-content support before strict mode. Validate the installed Caddy configuration before changing its active configuration.
- Verify two independent real public clients and forged/direct-origin assertions through both actual sites with FP-66 running, before exemption activation. The agent's one network origin and synthetic proxy clients cannot satisfy this gate. No live exemption is needed as a deployment test.
- Verify intended actual images, migration 42, preserved database identity/volume, fresh private DB connection, health/content and PostgreSQL guard after every authorized deployment stage. Keep normal cooldown/socket-mode rollback and audited operator revocation available.

Keep Jira In Progress and drafts unmerged. Instruction-only publication does not deploy app code. Raw fixtures/configs and local diagnostics stay outside Git under `/private/tmp/fp66-readiness-20261026`; only sanitized metadata is published.
