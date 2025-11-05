#!/usr/bin/env bash
set -euo pipefail

pass() { echo "[PASS] $*"; }
fail() { echo "[FAIL] $*" >&2; exit 1; }

# Test backup creates a .tar.gz
./backup.sh "$HOME" ./backups >/dev/null
LATEST="$(ls -1t backups/backup_*.tar.gz | head -n1 || true)"
[[ -f "$LATEST" ]] && pass "Backup archive created: $LATEST" || fail "Backup archive missing."

# Test update script is present (don’t run full upgrade in tests)
[[ -x ./update_cleanup.sh ]] && pass "update_cleanup.sh is executable" || fail "update_cleanup.sh not executable"

# Test monitor writes logs
sudo ./log_monitor.sh >/dev/null
[[ -s logs/monitor.log ]] && pass "Monitor wrote log" || fail "Monitor log missing"

echo "All basic tests passed."
