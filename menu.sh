#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"; mkdir -p "$LOG_DIR"

pause() { read -rp "Press Enter to continue…"; }

while true; do
  clear
  echo "==============================="
  echo "  System Maintenance Suite"
  echo "==============================="
  echo "1) Run Backup"
  echo "2) Run Update & Cleanup (requires sudo)"
  echo "3) Run Log Monitor"
  echo "4) View Logs"
  echo "5) Exit"
  echo "-------------------------------"
  read -rp "Choose an option [1-5]: " ch

  case "$ch" in
    1)
      read -rp "Source dir (default: \$HOME): " src
      read -rp "Backup dir (default: ./backups): " dst
      "${SCRIPT_DIR}/backup.sh" "${src:-$HOME}" "${dst:-$SCRIPT_DIR/backups}"
      pause;;
    2)
      sudo "${SCRIPT_DIR}/update_cleanup.sh"
      pause;;
    3)
      sudo "${SCRIPT_DIR}/log_monitor.sh"
      pause;;
    4)
      echo "--- Log files ---"
      ls -1 "$LOG_DIR" || true
      echo
      read -rp "Enter log filename to view (or blank to go back): " lf
      [[ -n "${lf:-}" && -f "$LOG_DIR/$lf" ]] && less "$LOG_DIR/$lf" || true
      ;;
    5) exit 0;;
    *) echo "Invalid choice"; sleep 1;;
  esac
done
