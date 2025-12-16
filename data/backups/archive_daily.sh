#!/bin/bash
# Archive latest backup set as DAILY (full + schema + data + log)

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$BASE_DIR/backups"
ARCHIVE_DIR="$BASE_DIR/archive/daily"

mkdir -p "$ARCHIVE_DIR"

# Ambil full backup terbaru
LATEST_FULL=$(ls -t "$BACKUP_DIR"/full_backup_*.sql.gz 2>/dev/null | head -1)

if [ -z "$LATEST_FULL" ]; then
  echo "No full backup found to archive (daily)."
  exit 0
fi

# Contoh: full_backup_20251202_094900.sql.gz
BASENAME=$(basename "$LATEST_FULL")              # full_backup_20251202_094900.sql.gz
TIMESTAMP=${BASENAME#full_backup_}              # 20251202_094900.sql.gz
TIMESTAMP=${TIMESTAMP%.sql.gz}                  # 20251202_094900

# Tag untuk nama file archive, misal: 20251202_094900
DATE_TAG="$TIMESTAMP"

echo "Latest backup set timestamp: $DATE_TAG"

# Daftar pola file yang mau di-archive:
# - full_backup_<TS>.sql.gz
# - schema_only_<TS>.sql.gz
# - data_only_<TS>.sql.gz
# - backup_log_<TS>.txt
FILES_TO_ARCHIVE=(
  "full_backup_${DATE_TAG}.sql.gz"
  "schema_only_${DATE_TAG}.sql.gz"
  "data_only_${DATE_TAG}.sql.gz"
  "backup_log_${DATE_TAG}.txt"
)

for fname in "${FILES_TO_ARCHIVE[@]}"; do
  SRC="$BACKUP_DIR/$fname"
  if [ -f "$SRC" ]; then
    DEST="$ARCHIVE_DIR/daily_${DATE_TAG}_${fname}"
    cp "$SRC" "$DEST"
    echo "Archived: $SRC -> $DEST"
  else
    echo "Skip (not found): $SRC"
  fi
done

echo "Daily backup set archived to: $ARCHIVE_DIR"
