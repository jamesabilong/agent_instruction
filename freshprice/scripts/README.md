# Operator utilities

These are reviewed reference tools, not automatic deployment hooks. Read the
source and verify its target/checkpoint before execution. Production writes,
backups or configuration changes require explicit authorization for that action;
never run restored-data fixtures or migration rehearsals against production.

- `backup-isolated-restore.sh`: creates a protected production backup and a bounded
  isolated disposable PostgreSQL restore comparison. It writes backups and
  temporary Docker resources but does not migrate/restore the production DB.
- `compare-restored-sql.py`: normalized base dump comparison helper.
- `diagnose-restore.sh`: metadata-only diagnostic for the recorded October 21
  checkpoint; inspect the fixed checkpoint path before using elsewhere.
- `inspect-postgres-exposure.sh`: read-only live inventory apart from root-only
  diagnostic snapshots; no firewall/database configuration change.
- `verify-deployed-release.py`: read-only runtime digests, service health,
  migration inventory, DB identity/volume/private connectivity and guard checks.
  Arguments are release stage, backend digest, frontend digest and Docker SHA.
  The recorded checkpoint path is deliberately fixed; revise/review it for a new
  recovery baseline rather than blindly reusing it.

Runtime firewall source/install instructions belong to the `fpdocker` repository,
under `firewall/` and `scripts/install-postgres-guard.sh`. The production guard is
already installed; its fresh-install helper refuses an existing installation.

Test-only HTTP/service fixtures, acceptance assertions, TLS helper and migration
rehearsal runners are retained outside Git in the local workspace at
`testing/operations/release-2026-10-21/`. They depend on protected exported payloads
and recorded checkpoints; this repository alone does not provision those inputs.
Keep local testing backups and do not publish generated seeders or TLS keys.
