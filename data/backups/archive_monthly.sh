#!/bin/bash
###############################################################################
# Archive latest backup set as MONTHLY (full + schema + data + log)
###############################################################################

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$BASE_DIR/backups"
ARCHIVE_DIR="$BASE_DIR/archive/monthly"

mkdir -p "$ARCHIVE_DIR"

# Ambil full backup terbaru
LATEST_FULL=$(ls -t "$BACKUP_DIR"/full_backup_*.sql.gz 2>/dev/null | head -1)

if [ -z "$LATEST_FULL" ]; then
  echo "No full backup found to archive (monthly)."
  exit 0
fi

# Contoh: full_backup_20251202_094900.sql.gz
BASENAME=$(basename "$LATEST_FULL")          # full_backup_20251202_094900.sql.gz
TIMESTAMP=${BASENAME#full_backup_}          # 20251202_094900.sql.gz
TIMESTAMP=${TIMESTAMP%.sql.gz}              # 20251202_094900

# Tag bulan, misal: 202512 (Desember 2025)
MONTH_TAG=$(date +%Y%m)

echo "Latest backup set timestamp: $TIMESTAMP (month tag: $MONTH_TAG)"

# Daftar file yang mau di-archive (jika ada):
FILES_TO_ARCHIVE=(
  "full_backup_${TIMESTAMP}.sql.gz"
  "schema_only_${TIMESTAMP}.sql.gz"
  "data_only_${TIMESTAMP}.sql.gz"
  "backup_log_${TIMESTAMP}.txt"
)

for fname in "${FILES_TO_ARCHIVE[@]}"; do
  SRC="$BACKUP_DIR/$fname"
  if [ -f "$SRC" ]; then
    # Nama di archive: monthly_202512_<original_name>
    DEST="$ARCHIVE_DIR/monthly_${MONTH_TAG}_${fname}"
    cp "$SRC" "$DEST"
    echo "Archived: $SRC -> $DEST"
  else
    echo "Skip (not found): $SRC"
  fi
done

echo "Monthly backup set archived to: $ARCHIVE_DIR"
