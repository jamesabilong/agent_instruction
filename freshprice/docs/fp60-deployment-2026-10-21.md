# FP-60 deployment verification — 2026-10-21

Result: **read-only deployment verification passes; proceed to FP-61 backend first**. No production write, service restart, migration, PR mutation or deployment was performed by this verification.

- [Backend run](https://github.com/jamesabilong/fpdocker/actions/runs/39564136705) and [frontend run](https://github.com/jamesabilong/fpdocker/actions/runs/39564148056) succeeded. Source merges are backend `a04c152719311d93367a835da03cdec263759007` and frontend `5547c4bf8f7ffd35d09951ee1514f5b1580608c7`. VPS Docker checkout is `5f364defe7202c16e839c58bfc3f35b8ee8221ef`.
- Actual running backend digest matches `sha256:c862b7e40fe9c20c0f479dad95bdd589556492508ddc94584df7f5624af77ba2`; frontend matches `sha256:3d76e01d8187f7e0f874a2f028897f68f9bef4adad9f843786fd000fb6f46fb1`. Service definitions retain mutable latest tags, so runtime immutable image IDs/RepoDigests were checked directly.
- All four Swarm services have exactly one healthy running container. Updates are completed or have no update state; none is paused/rolling back. PostgreSQL has the same actual image ID as the FP-59 verification despite an additional repository digest alias.
- Database inventory is exactly **37 migrations**, including `20261019000004-budget-accounting.cjs`; FP-61's receipt migration is absent as expected. Database/system identity and data volume match the protected checkpoint. A fresh private backend Sequelize connection runs `SELECT 1` successfully.
- PostgreSQL endpoint/spec have no published ports; its independent firewall guard is active/enabled. External 5432 connection times out. Public FreshPrice database/frontend and PhilWatch health pass. Worker is JavaScript/no-store with CDN no-store/CF BYPASS; manifest is application/manifest+json/no-cache with CDN no-store/CF DYNAMIC. FreshPrice database and PhilWatch public health were rechecked after host verification and still pass.
- FP-61 [backend #57](https://github.com/jamesabilong/fresh-price-backend/pull/57) and [frontend #55](https://github.com/jamesabilong/fresh-price-front/pull/55) are OPEN/MERGEABLE, both target **master**, and retain reviewed heads `1d1fa169`/`0d100ab5`.

Limits: authenticated accounting/payment/role production mutations were not run. Earlier isolated restored-copy FP-60 acceptance results remain separate from this live read-only check. Physical-device/installed-version testing remains waived, not passed. No purge was performed during verification; observed live cache headers pass.

Next: merge backend #57 only; wait for its automatic deployment and verify the receipt migration, runtime image and health before merging frontend #55. Do not batch merges. Safe evidence: `../evidence/fp60-deployment-2026-10-21.json`.
