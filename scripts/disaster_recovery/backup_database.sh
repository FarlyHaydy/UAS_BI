#!/bin/bash
###############################################################################
# DISASTER RECOVERY - DATABASE BACKUP SCRIPT
# Data Warehouse Pariwisata Jakarta 2025
# Compatible with Docker & Local environments
# 
# Usage:
#   ./backup_database.sh manual    # Manual backup
#   ./backup_database.sh auto      # Pre-ETL backup
#   ./backup_database.sh monthly   # Monthly backup (only runs on day 01)
###############################################################################

set -e  # Exit on error

###############################################################################
# 0. DETECT ENVIRONMENT & RESOLVE PATHS
###############################################################################

# Detect if running in Docker
if [ -f "/.dockerenv" ]; then
    IS_DOCKER=true
    echo "[INFO] Running in Docker environment"
else
    IS_DOCKER=false
    echo "[INFO] Running in local environment"
fi

# Base directory = folder tempat script ini berada
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Resolve project root
if [ "$IS_DOCKER" = true ]; then
    # Docker: /app adalah root project
    PROJECT_ROOT="/app"
    ENV_FILE="$PROJECT_ROOT/.env"
    BACKUP_DIR="$PROJECT_ROOT/data/backups/backups"
else
    # Local: naik 2 level ke root project
    PROJECT_ROOT="$SCRIPT_DIR/../.."
    ENV_FILE="$PROJECT_ROOT/.env"
    BACKUP_DIR="$PROJECT_ROOT/data/backups/backups"
fi

echo "[INFO] Project root: $PROJECT_ROOT"
echo "[INFO] Backup directory: $BACKUP_DIR"

# Load environment variables dari .env
if [ -f "$ENV_FILE" ]; then
    echo "[INFO] Loading .env from: $ENV_FILE"
    set -a
    source "$ENV_FILE"
    set +a
else
    echo "[WARN] .env file not found at: $ENV_FILE"
    echo "[INFO] Using environment variables from shell"
fi

# Add PostgreSQL to PATH (untuk Local/Windows environment)
if [ "$IS_DOCKER" = false ] && ! command -v psql &> /dev/null; then
    PG_PATHS=(
        "/c/Program Files/PostgreSQL/18/bin"
        "C:/Program Files/PostgreSQL/18/bin"
        "/usr/bin"
        "/usr/local/bin"
    )
    for pg_path in "${PG_PATHS[@]}"; do
        if [ -d "$pg_path" ]; then
            export PATH="$PATH:$pg_path"
            echo "[INFO] Added PostgreSQL to PATH: $pg_path"
            break
        fi
    done
fi

###############################################################################
# 1. CONFIGURATION
###############################################################################

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-dw_pariwisata_jakarta}"
DB_USER="${DB_USER:-postgres}"
# DB_PASSWORD diambil dari environment

# Backup configuration
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_TYPE="${1:-manual}"               # manual | auto | monthly

# Backup filenames (RAW .sql)
FULL_BACKUP="${BACKUP_DIR}/full_backup_${TIMESTAMP}.sql"
SCHEMA_BACKUP="${BACKUP_DIR}/schema_only_${TIMESTAMP}.sql"
DATA_BACKUP="${BACKUP_DIR}/data_only_${TIMESTAMP}.sql"
LOG_FILE="${BACKUP_DIR}/backup_log_${TIMESTAMP}.txt"

# Retention policy (days)
RETENTION_DAYS=30

# Mode khusus: MONTHLY (hanya jalan tanggal 01)
DAY_OF_MONTH=$(date +%d)
if [ "$BACKUP_TYPE" = "monthly" ] && [ "$DAY_OF_MONTH" != "01" ]; then
    echo "[INFO] Monthly mode: today is day $DAY_OF_MONTH, not 01 -> skipping backup" | tee -a "$LOG_FILE"
    exit 0
fi

# Create backup directory if not exists
mkdir -p "${BACKUP_DIR}"
echo "[INFO] Created backup directory: ${BACKUP_DIR}"

# Logging function
log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

###############################################################################
# 2. MAIN BACKUP PROCESS
###############################################################################

log_message "=========================================="
log_message "STARTING DATABASE BACKUP (${BACKUP_TYPE})"
log_message "=========================================="
log_message "Environment: $([ "$IS_DOCKER" = true ] && echo "Docker" || echo "Local")"
log_message "Database: ${DB_NAME}@${DB_HOST}:${DB_PORT}"
log_message "Backup Directory: ${BACKUP_DIR}"

# Check PostgreSQL tools availability
if ! command -v pg_dump &> /dev/null; then
    log_message "❌ ERROR: pg_dump not found!"
    log_message "   Please install PostgreSQL client tools"
    exit 1
fi

# Check PostgreSQL connection
log_message ""
log_message "Checking database connection..."
if ! PGPASSWORD="${DB_PASSWORD}" psql \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    -c "SELECT 1;" > /dev/null 2>&1; then
    log_message "❌ ERROR: Cannot connect to database!"
    log_message "   Host: ${DB_HOST}:${DB_PORT}"
    log_message "   Database: ${DB_NAME}"
    log_message "   User: ${DB_USER}"
    exit 1
fi
log_message "✅ Database connection successful"

###############################################################################
# 3. FULL BACKUP (Schema + Data)
###############################################################################

log_message ""
log_message "[1/3] Creating FULL backup (schema + data)..."

if PGPASSWORD="${DB_PASSWORD}" pg_dump \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    --format=plain \
    --no-owner \
    --no-acl \
    --verbose \
    --file="${FULL_BACKUP}" 2>> "${LOG_FILE}"; then

    SIZE=$(du -h "${FULL_BACKUP}" | cut -f1)
    log_message "✅ Full backup created: ${FULL_BACKUP} (${SIZE})"
else
    log_message "❌ ERROR: Full backup failed!"
    exit 1
fi

###############################################################################
# 4. SCHEMA-ONLY BACKUP (Structure)
###############################################################################

log_message ""
log_message "[2/3] Creating SCHEMA-ONLY backup..."

if PGPASSWORD="${DB_PASSWORD}" pg_dump \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    --schema-only \
    --format=plain \
    --no-owner \
    --no-acl \
    --file="${SCHEMA_BACKUP}" 2>> "${LOG_FILE}"; then

    SIZE=$(du -h "${SCHEMA_BACKUP}" | cut -f1)
    log_message "✅ Schema backup created: ${SCHEMA_BACKUP} (${SIZE})"
else
    log_message "⚠️  WARNING: Schema backup failed!"
fi

###############################################################################
# 5. DATA-ONLY BACKUP (Critical Tables)
###############################################################################

log_message ""
log_message "[3/3] Creating DATA-ONLY backup (critical tables)..."

CRITICAL_TABLES=(
    "fact_kunjungan"
    "dim_time"
    "dim_objek_wisata"
    "dim_wisatawan"
    "dim_price"
    "user_journey_log"
    "dashboard_performance_log"
)

if PGPASSWORD="${DB_PASSWORD}" pg_dump \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    --data-only \
    --format=plain \
    --no-owner \
    --no-acl \
    $(printf -- '-t %s ' "${CRITICAL_TABLES[@]}") \
    --file="${DATA_BACKUP}" 2>> "${LOG_FILE}"; then

    SIZE=$(du -h "${DATA_BACKUP}" | cut -f1)
    log_message "✅ Data backup created: ${DATA_BACKUP} (${SIZE})"
else
    log_message "⚠️  WARNING: Data backup failed!"
fi

###############################################################################
# 6. COMPRESS BACKUPS
###############################################################################

log_message ""
log_message "[4/5] Compressing backups..."

for file in "${FULL_BACKUP}" "${SCHEMA_BACKUP}" "${DATA_BACKUP}"; do
    if [ -f "${file}" ]; then
        if gzip "${file}"; then
            log_message "✅ Compressed: ${file}.gz"
        else
            log_message "⚠️  WARNING: Failed to compress ${file}"
        fi
    fi
done

###############################################################################
# 7. CLEANUP OLD BACKUPS (Retention Policy)
###############################################################################

log_message ""
log_message "[5/5] Applying retention policy (${RETENTION_DAYS} days)..."

DELETED_COUNT=0
while IFS= read -r -d '' old_file; do
    if rm -f "${old_file}"; then
        log_message "🗑️  Deleted old backup: $(basename "${old_file}")"
        ((DELETED_COUNT++))
    fi
done < <(find "${BACKUP_DIR}" -name "*.sql.gz" -type f -mtime +${RETENTION_DAYS} -print0 2>/dev/null)

log_message "Deleted ${DELETED_COUNT} old backup(s)"

###############################################################################
# 8. BACKUP SUMMARY
###############################################################################

log_message ""
log_message "=========================================="
log_message "BACKUP COMPLETED SUCCESSFULLY"
log_message "=========================================="
log_message "Summary:"
log_message "  - Full backup:   $(ls -lh ${FULL_BACKUP}.gz 2>/dev/null | awk '{print $5}' || echo 'N/A')"
log_message "  - Schema backup: $(ls -lh ${SCHEMA_BACKUP}.gz 2>/dev/null | awk '{print $5}' || echo 'N/A')"
log_message "  - Data backup:   $(ls -lh ${DATA_BACKUP}.gz 2>/dev/null | awk '{print $5}' || echo 'N/A')"
log_message "  - Log file:      ${LOG_FILE}"
log_message ""
log_message "Backup location: ${BACKUP_DIR}"
log_message "Total backups: $(ls -1 ${BACKUP_DIR}/*.gz 2>/dev/null | wc -l)"
log_message "=========================================="

exit 0
