# FP-66 readiness continuation — October 26, 2026

The user authorized remaining release-readiness checks and publishing the agent-instructions repository, explicitly withholding merge/deployment authorization. All four [feature drafts](fp-66-publication-2026-10-26.md) remain the release candidates. No production migration, configuration change, restart, deployment, exemption or feature mutation was performed.

Authenticated follow-up: **installed Caddy 2.6.2 rejects the candidate's global trusted-proxy and strict options, blocking strict-mode release**. Live baseline checks and the explicitly approved October 22 restored-backup migration/recovery now pass; no production change. [Host/restored-copy results and remaining gates](fp-66-host-readiness-2026-10-26.md) supersede the earlier SSH-pending checkpoint.

## Newly completed checks

- Both public sites pass baseline read-only health: FreshPrice `/healthz`, PhilWatch `/health`, and `/api/platform/db/health` through each domain return 200 with `Cache-Control: no-store`; both database responses report healthy. These four requests come from one network origin. They do not verify app revision, migration count, backup, actual visitor separation or FP-66 deployment.
- Retrieved the current [official Cloudflare IPv4](https://www.cloudflare.com/ips-v4) and [IPv6](https://www.cloudflare.com/ips-v6) lists: 15 + 7 public networks, no duplicates/private/default ranges. Exact fetched-content hashes are retained in the [sanitized evidence](../evidence/fp-66-readiness-2026-10-26.json). These lists require revalidation at rollout time.
- Adapted and validated both reviewed Caddy snippets with all 22 official public ranges using cached local Caddy **v2.11.4** in disposable read-only, network-none containers without published ports. Verified strict parsing, `X-Forwarded-For`, visitor-IP/key overwrite and internal-key removal in both domain proxy policies. Only a synthetic credential and HTTP fixture sites were used. This validates the candidate snippets with a local version, not installed production Caddy, production TLS/maintenance configuration, actual CDN ingress or real independent clients.
- Confirmed separate instructions repository `main` matches its fetched remote before publication. Backend draft #60 still targets master, is draft/MERGEABLE and retains exact reviewed head `68945dd`. Full four-draft verification and 271/303 units/both app builds are retained in the [publication](fp-66-publication-2026-10-26.md) and [review](fp-66-review-2026-10-26.md) records; no source changes in this continuation.

The first range fetch using Python's default user-agent was denied; curl retrieved the official lists. Two local adapter assertions initially assumed a JSON boolean and a different expanded placeholder/header casing. Actual adapter output uses strict-mode value `1`, `{http.vars.client_ip}` and case-preserving deletion names; assertions were corrected to test that exact representation and case-insensitive HTTP names. Final adaptation/validation and both policy assertions pass. No application assertion or trust policy was weakened.

## Authenticated host and restored-copy checks

The user established an explicitly shared authenticated SSH connection after the initial key-authentication rejection. Read-only inventory confirms four healthy services, exact recorded backend/frontend release digests, 41 live migrations, absent FP-66 schema, preserved DB identity/volume, fresh private connectivity and enabled/active PostgreSQL guard. Active Caddy config matches its file, has the expected FreshPrice/PhilWatch upstreams, a loopback-only admin listener and no FP-66 trust policy. Installed Caddy 2.6.2 fails both candidate global-option probes; upgrading it needs separate authorization.

After automatic review initially rejected an unspecified sensitive-data export, the user explicitly approved copying only the protected October 22 dump locally for the isolated rehearsal. Checksum matched. Exact FP-66 41→42 migration, preservation, empty down/up, three populated rollback guards, account-deletion audit retention and independent post-migration full restore pass. Local raw dumps and temporary containers/volumes were removed; production inventory remains unchanged. [Detailed results](fp-66-host-readiness-2026-10-26.md).

This proves recovery on that existing snapshot, not a fresh October 26 release-time backup, restored-data browser/device acceptance or full-server/global-role recovery. A supported installed Caddy and fresh checkpoint (or explicit snapshot-age acceptance) remain prerequisites. No new production backup was authorized or created.

## Later authorized rollout and activation gates

The following need a separately authorized rollout and cannot be certified against undeployed FP-66 code:

- Install separate protected edge/content credentials and coordinate targeted Swarm settings, preserving the on-host environment for later full-stack updates. Do not generate/publish real credentials or configure services in this readiness continuation.
- Publish Docker release configuration first, then deploy compatible backend/schema before the admin frontend with exemptions disabled; coordinate PhilWatch server-content support before strict mode. Validate the installed Caddy configuration before changing its active configuration.
- Verify two independent real public clients and forged/direct-origin assertions through both actual sites with FP-66 running, before exemption activation. The agent's one network origin and synthetic proxy clients cannot satisfy this gate. No live exemption is needed as a deployment test.
- Verify intended actual images, migration 42, preserved database identity/volume, fresh private DB connection, health/content and PostgreSQL guard after every authorized deployment stage. Keep normal cooldown/socket-mode rollback and audited operator revocation available.

Keep Jira In Progress and drafts unmerged. Instruction-only publication does not deploy app code. Raw fixtures/configs and local diagnostics stay outside Git under `/private/tmp/fp66-readiness-20261026`; only sanitized metadata is published.
