#!/usr/bin/env bash
set -euo pipefail
python3 - <<'PY'
import pathlib, re, json, subprocess
p = pathlib.Path('/var/backups/freshprice/fp-restore-20261021T011813Z-1873577')
log = (p/'private-execution.log').read_text(errors='replace')
names = ['database.dump','uploads.tar.gz','archive-inventory.txt','restored-migration-count.txt','restored-roundtrip.dump','original-normalized.sql','restored-normalized.sql','SHA256SUMS','services-after.json']
print(json.dumps({'artifacts': {n: (p/n).stat().st_size if (p/n).exists() else None for n in names}}))
patterns = {
 'container-create-error': r'Error response from daemon|docker: Error',
 'memory-limit-error': r'cannot set memory|memory limit|not enough memory|Cannot allocate memory',
 'readiness-failed': r'no response|rejecting connections',
 'connection-failed': r'connection to server .* failed|could not connect',
 'missing-role': r'role .* does not exist',
 'existing-object': r'already exists',
 'permission-denied': r'permission denied',
 'archive-invalid': r'unsupported version|does not appear to be a valid archive|unexpected end of file',
 'restore-command-error': r'pg_restore: error:',
 'disk-full': r'No space left on device',
 'sql-error': r'ERROR:',
 'comparison-differs': r'Files .* differ',
 'init-complete': r'PostgreSQL init process complete',
 'pg-ready': r'accepting connections',
}
print(json.dumps({'log_signals': {key: len(re.findall(pattern,log)) for key,pattern in patterns.items()}}))
for n in ['restored-migration-count.txt']:
 if (p/n).exists():
  value=(p/n).read_text().strip()
  print(json.dumps({n: value if value.isdigit() else 'non-numeric'}))
for kind, command in [('temporary-container',['docker','container','inspect']),('temporary-volume',['docker','volume','inspect'])]:
 r=subprocess.run(command+['fp-restore-20261021T011813Z-1873577'],capture_output=True)
 print(kind+': '+('present' if r.returncode==0 else 'absent'))
print('No private log lines or database contents displayed.')
PY
