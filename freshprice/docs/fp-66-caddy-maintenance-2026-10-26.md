# FP-66 fresh checkpoint and Caddy maintenance — October 26, 2026

## Result and authorization

The user explicitly authorized a fresh protected backup, safe Caddy upgrade, readiness rechecks and agent-instructions publication, while withholding app PR merge/deployment. **Caddy 2.11.7 is installed and running; the earlier 2.6.2 compatibility blocker is resolved.** The fresh-backup and exact FP-66 migration/recovery checks pass. All existing sites, app images, database identity/volume/live 41-migration inventory and PostgreSQL guard pass final checks.

No app PR was merged/deployed, no production database migration ran, and no FP-66 visitor-trust configuration, real credential or login exemption was activated. [Sanitized maintenance evidence](../evidence/fp-66-caddy-maintenance-2026-10-26.json). Earlier [host readiness](fp-66-host-readiness-2026-10-26.md) is the historical pre-maintenance checkpoint.

## Fresh protected backup and recovery

Created `/var/backups/freshprice/fp-restore-20261026T031411Z-2355358` at approximately **11:14 Manila** (03:14 UTC). Directory is root-only mode 0700; database dump is mode 0600. Captured a fresh consistent PostgreSQL custom dump, live uploads, runtime environment/Compose configuration, Caddy configuration and service/image identities. No private payload was exported off the VPS.

The 226,036-byte database archive has SHA-256 `8545c75fa53661d2985e09b6a7a37e57ce862aec0994ee1409d72888b815a5bc`. Full backup checksums pass. An isolated disposable PostgreSQL 14 restore using the cached production image matches full normalized schema, COPY row multisets and sequences: **46 COPY blocks, 581 rows**, live baseline **41 migrations**. Production container/service identities and health are unchanged by the backup; temporary resources were removed.

Then rehearsed the exact FP-66 migration from backend `68945dd319bbd583cd6ada52a027ae35970437e7`, migration SHA-256 `43d40c7f48527ed60020c6f0b0724163973a4bad71a9c7a7487908d07e057384`, against a separate restored copy of that fresh archive. The scratch PostgreSQL/Node containers have network none, no published ports, resource bounds and a dedicated Unix socket. No production environment, app startup, scheduler or outbound integration is supplied.

Migration **41→42** preserves all original rows and sequences. Empty rollback/reapply, one-rule-per-account/FK constraints, three populated rollback guards, rule deletion on account removal and audit retention pass. Independent post-migration restore matches full normalized schema/data/sequences: **48 COPY blocks, 583 rows**, including explicit synthetic migration/audit history. All temporary labelled containers/volumes were removed; production service specifications remained unchanged. Private rehearsal source/results and derived dumps remain protected inside the VPS checkpoint.

Recovery scope remains on-VPS: owners/ACLs are normalized, global roles/full-server/off-host recovery is not certified, and uploads were copied while online rather than atomically with the database snapshot. Refresh the checkpoint if the eventual app rollout is materially delayed. This rehearsal does not establish restored-data browser/device/PWA acceptance.

## Caddy upgrade and rollback materials

Used the [official stable signed APT repository](https://caddyserver.com/docs/install#debian-ubuntu-raspbian) and pinned package **2.11.7**, the current [official release](https://github.com/caddyserver/caddy/releases/tag/v2.11.7). Preserved the old Ubuntu package `2.6.2-6ubuntu0.24.04.3`, old binary, active/file configuration, systemd unit and `/var/lib/caddy` certificate storage under root-only `/var/backups/freshprice/fp-caddy-20261026T031638Z` before installation.

The vendor source uses its dedicated signing keyring. APT metadata/package authentication remains enforced. Staged package SHA-256 is `a22b914ffd1958da42bc7ab13b7b62c6100634e0798ab594891d2d61d53ba749`. The extracted candidate binary validated the existing Caddyfile and produced identical routes before installation; package simulation upgraded only Caddy with zero removals. Installation preserved the existing configuration with `--force-confold` and limited unrelated needrestart activity to listing.

The package performed Caddy's restart; no extra restart was needed. Verified the running daemon's executable matches the installed binary, service is active/enabled, installed config validation passes, active JSON equals the adapted file, and the Caddyfile SHA-256 remains `da312c829943d99395a7b46c036d219e6ae01613ff7966c4146c11d33729dd59`. No rollback was needed. Package audit is clean. The official stable repository/key remain installed for maintained package updates.

Rollback materials remain protected at the checkpoint. The reviewed procedure was to reinstall its exact old `.deb` with explicit downgrade and retained config, restart only Caddy, then reverify HTTPS; certificate/config archives are available for separately diagnosed recovery if needed. The staged maintenance runner automatically attempted package rollback on upgrade/health failure; that path was not executed or certified by this successful upgrade.

## Rerun readiness and shared-site checks

- Direct origin HTTPS with certificate verification passes before and after for FreshPrice, PhilWatch and portfolio (200) and `www.philwatch.com` (same 302 redirect). Eight public checks preserve status, final URL, page title and content type across all four hosts and FreshPrice/PhilWatch app/database health.
- Existing Caddy upstreams/routes/TLS/maintenance configuration are preserved. The admin listener remains loopback-only and FP-66 trust remains inactive.
- All four existing FreshPrice-stack services are healthy with unchanged actual images/service specifications. Database identity/data volume, live 41 migrations/no FP-66 tables, fresh backend connectivity, unpublished PostgreSQL port and enabled/active public-interface guard pass.
- Refetched the current official [Cloudflare IPv4](https://www.cloudflare.com/ips-v4) and [IPv6](https://www.cloudflare.com/ips-v6) ranges: 15 + 7. Installed **2.11.7** adapts both reviewed Caddyfile snippets with strict right-to-left parsing and both target proxy header policies.
- A protected, **non-active** copy of the full existing configuration plus proposed FP-66 trust/header fields validates with installed Caddy. All other configuration is preserved, and active config is checked unchanged afterwards. Only synthetic credentials are used. This is candidate validation, not live FP-66 client-separation evidence.

## Remaining app-release gates

Keep all four PRs draft/unmerged and Jira In Progress. Separate app merge/deployment authorization is still required. During that later authorized release: publish Docker configuration first, deploy compatible backend/schema before admin UI, coordinate PhilWatch support, install distinct protected edge/content credentials with targeted Swarm/on-host settings, and verify intended images/migration 42/database/health/guard at each stage. Test two independent real public clients plus forged/direct-origin assertions on both actual paths before exemption activation. Keep exemptions disabled; no live exemption is a deployment test.

No new app source changes or broad repeat of byte-identical unit/browser suites was needed for this host maintenance. Existing exact-source synthetic acceptance retains its documented scope; the fresh restored-copy and installed-Caddy checks above are newly executed evidence.
