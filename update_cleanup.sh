#!/usr/bin/env bash
set -euo pipefail
LOG_DIR="$(pwd)/logs"; mkdir -p "$LOG_DIR"

log() { echo "[$(date +'%F %T')] [update] $*" | tee -a "$LOG_DIR/update.log"; }
err() { echo "[$(date +'%F %T')] [update][ERROR] $*" | tee -a "$LOG_DIR/update.log" >&2; }

require_root() {
  if [[ $EUID -ne 0 ]]; then
    err "Please run with sudo: sudo $0"
    exit 1
  fi
}

require_root

if command -v apt >/dev/null 2>&1; then
  PKG='apt'; CLEAN="apt autoremove -y && apt autoclean -y"
  UPDATE="apt update -y"; UPGRADE="apt upgrade -y"
elif command -v dnf >/dev/null 2>&1; then
  PKG='dnf'; CLEAN="dnf autoremove -y && dnf clean all -y"
  UPDATE="dnf check-update -y || true"; UPGRADE="dnf upgrade -y"
elif command -v yum >/dev/null 2>&1; then
  PKG='yum'; CLEAN="yum autoremove -y || true && yum clean all -y"
  UPDATE="yum check-update -y || true"; UPGRADE="yum update -y"
else
  err "Unsupported distro (apt/dnf/yum not found)."
  exit 1
fi

log "Package manager detected: $PKG"
log "Updating package lists…"
bash -c "$UPDATE"
log "Upgrading packages…"
bash -c "$UPGRADE"
log "Cleaning old packages/caches…"
bash -c "$CLEAN"
log "Disk usage after cleanup:"; df -h | tee -a "$LOG_DIR/update.log"
log "Done."
