#!/usr/bin/env bash
set -euo pipefail
LOG_DIR="$(pwd)/logs"; mkdir -p "$LOG_DIR"
ALERT_LOG="$LOG_DIR/alerts.log"

FILES=(
  "/var/log/syslog"     # Debian/Ubuntu
  "/var/log/messages"   # RHEL/Fedora
  "/var/log/auth.log"   # Debian/Ubuntu auth
  "/var/log/secure"     # RHEL/Fedora auth
)
PATTERNS=(
  "error" "failed password" "segfault" "panic"
  "oom-killer" "denied" "unauthorized" "warning"
)

log()  { echo "[$(date +'%F %T')] [monitor] $*" | tee -a "$LOG_DIR/monitor.log"; }

scan_file() {
  local f="$1"
  [[ -r "$f" ]] || return 0
  local found=0
  for p in "${PATTERNS[@]}"; do
    if grep -i -E "$p" "$f" >/dev/null 2>&1; then
      found=1
    fi
  done
  if [[ $found -eq 1 ]]; then
    log "Alerts found in $f — writing to $ALERT_LOG"
    {
      echo "===== $(date +'%F %T') — $f ====="
      grep -i -E "$(IFS='|'; echo "${PATTERNS[*]}")" "$f" | tail -n 100
      echo
    } >> "$ALERT_LOG"
  else
    log "No alerts in $f"
  fi
}

log "Starting log scan…"
for f in "${FILES[@]}"; do scan_file "$f"; done
log "Scan complete. See $ALERT_LOG for details."
