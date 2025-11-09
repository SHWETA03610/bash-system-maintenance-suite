#!/usr/bin/env bash
set -euo pipefail
SOURCE_DIR="${1:-$HOME}"        
BACKUP_DIR="${2:-$(pwd)/backups}"  
RETENTION_DAYS="${RETENTION_DAYS:-7}"  
LOG_DIR="$(pwd)/logs"
mkdir -p "$BACKUP_DIR" "$LOG_DIR"

log()  { echo "[$(date +'%F %T')] [backup] $*" | tee -a "$LOG_DIR/backup.log"; }
err()  { echo "[$(date +'%F %T')] [backup][ERROR] $*" | tee -a "$LOG_DIR/backup.log" >&2; }

if [[ ! -d "$SOURCE_DIR" ]]; then
  err "Source directory not found: $SOURCE_DIR"
  exit 1
fi

STAMP="$(date +'%Y%m%d_%H%M%S')"
ARCHIVE="$BACKUP_DIR/backup_${STAMP}.tar.gz"

log "Starting backup of '$SOURCE_DIR' -> '$ARCHIVE'"
tar --exclude='.cache' --exclude='*.tmp' -czf "$ARCHIVE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"
log "Backup completed: $(du -h "$ARCHIVE" | awk '{print $1}')"

log "Pruning backups older than $RETENTION_DAYS days"
find "$BACKUP_DIR" -type f -name 'backup_*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete | sed 's/^/[deleted] /' | tee -a "$LOG_DIR/backup.log"

log "Done."
