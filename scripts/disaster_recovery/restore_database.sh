#!/bin/bash
###############################################################################
# DISASTER RECOVERY - DATABASE RESTORE SCRIPT
# Data Warehouse Pariwisata Jakarta 2025
# Compatible with Docker & Local environments
# 
# Usage: 
#   ./restore_database.sh <backup_file.sql.gz> [auto|--force]
#
# Examples:
#   Docker:  ./restore_database.sh /app/data/backups/backups/full_backup_20251208_140300.sql.gz
#   Local:   ./restore_database.sh data/backups/backups/full_backup_20251208_140300.sql.gz
#   Auto:    ./restore_database.sh backup.sql.gz auto
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

# Base directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Resolve paths based on environment
if [ "$IS_DOCKER" = true ]; then
    PROJECT_ROOT="/app"
    ENV_FILE="$PROJECT_ROOT/.env"
    BACKUP_DIR="$PROJECT_ROOT/data/backups/backups"
else
    PROJECT_ROOT="$SCRIPT_DIR/../.."
    ENV_FILE="$PROJECT_ROOT/.env"
    BACKUP_DIR="$PROJECT_ROOT/data/backups/backups"
    
    # Add PostgreSQL to PATH (Windows/Local)
    if ! command -v psql &> /dev/null; then
        PG_PATHS=(
            "/c/Program Files/PostgreSQL/18/bin"
            "/c/Program Files/PostgreSQL/17/bin"
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
fi

echo "[INFO] Project root: $PROJECT_ROOT"
echo "[INFO] Backup directory: $BACKUP_DIR"

# Load environment variables
if [ -f "$ENV_FILE" ]; then
    echo "[INFO] Loading .env from: $ENV_FILE"
    set -a
    source "$ENV_FILE" 2>/dev/null || {
        echo "[WARN] Error loading .env, trying dos2unix conversion..."
        tr -d '\r' < "$ENV_FILE" > /tmp/.env.unix
        source /tmp/.env.unix
        rm /tmp/.env.unix
    }
    set +a
else
    echo "[WARN] .env file not found at: $ENV_FILE"
fi

###############################################################################
# 1. CONFIGURATION
###############################################################################

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-dw_pariwisata_jakarta}"
DB_USER="${DB_USER:-postgres}"

# Arguments
BACKUP_FILE="$1"
MODE="$2"

# Check if running in auto mode
AUTO_MODE=false
if [ "$MODE" == "auto" ] || [ "$MODE" == "--auto" ] || [ "$MODE" == "--force" ]; then
    AUTO_MODE=true
fi

###############################################################################
# 2. VALIDATE ARGUMENTS
###############################################################################

if [ -z "${BACKUP_FILE}" ]; then
    echo ""
    echo "ERROR: Backup file not specified!"
    echo ""
    echo "Usage: $0 <backup_file.sql.gz> [auto|--force]"
    echo ""
    echo "Available backups in ${BACKUP_DIR}:"
    ls -lh "${BACKUP_DIR}"/*.sql.gz 2>/dev/null || echo "  (no backups found)"
    echo ""
    echo "Examples:"
    if [ "$IS_DOCKER" = true ]; then
        echo "  $0 /app/data/backups/backups/full_backup_20251208_140300.sql.gz"
    else
        echo "  $0 data/backups/backups/full_backup_20251208_140300.sql.gz"
    fi
    exit 1
fi

# If relative path, resolve it
if [[ ! "$BACKUP_FILE" = /* ]]; then
    # Relative path
    if [ "$IS_DOCKER" = true ]; then
        BACKUP_FILE="/app/${BACKUP_FILE}"
    else
        BACKUP_FILE="${PROJECT_ROOT}/${BACKUP_FILE}"
    fi
fi

if [ ! -f "${BACKUP_FILE}" ]; then
    echo "ERROR: Backup file not found: ${BACKUP_FILE}"
    echo ""
    echo "Available backups:"
    ls -lh "${BACKUP_DIR}"/*.sql.gz 2>/dev/null || echo "  (no backups found)"
    exit 1
fi

###############################################################################
# 3. WARNING & CONFIRMATION
###############################################################################

echo ""
echo "=========================================="
echo "DATABASE RESTORE OPERATION"
echo "=========================================="
echo "⚠️  WARNING: This will REPLACE ALL DATA in the database!"
echo ""
echo "Environment : $([ "$IS_DOCKER" = true ] && echo 'Docker' || echo 'Local')"
echo "Database    : ${DB_NAME}@${DB_HOST}:${DB_PORT}"
echo "Backup file : ${BACKUP_FILE}"
echo "Backup size : $(du -h "${BACKUP_FILE}" 2>/dev/null | cut -f1 || echo "unknown")"
echo ""

# Ask for confirmation unless in auto mode
if [ "$AUTO_MODE" = false ]; then
    read -p "⚠️  Type 'yes' to proceed with restore: " CONFIRM
    if [ "${CONFIRM}" != "yes" ]; then
        echo ""
        echo "Restore cancelled by user"
        exit 0
    fi
else
    echo "[AUTO MODE] Proceeding with restore automatically..."
fi

###############################################################################
# 4. PRE-RESTORE SAFETY BACKUP
###############################################################################

echo ""
echo "[1/5] Creating safety backup before restore..."
mkdir -p "${BACKUP_DIR}"
SAFETY_BACKUP="${BACKUP_DIR}/pre_restore_backup_$(date +%Y%m%d_%H%M%S).sql.gz"

if PGPASSWORD="${DB_PASSWORD}" pg_dump \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    --format=plain \
    --no-owner \
    --no-acl 2>/dev/null | gzip > "${SAFETY_BACKUP}"; then
    echo "✅ Safety backup created: ${SAFETY_BACKUP}"
    echo "   Size: $(du -h "${SAFETY_BACKUP}" | cut -f1)"
else
    echo "⚠️  WARNING: Could not create safety backup (database may not exist)"
fi

###############################################################################
# 5. DECOMPRESS BACKUP
###############################################################################

echo ""
echo "[2/5] Decompressing backup file..."
TEMP_SQL="/tmp/restore_temp_$(date +%s).sql"

if [[ "${BACKUP_FILE}" == *.gz ]]; then
    gunzip -c "${BACKUP_FILE}" > "${TEMP_SQL}" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: Failed to decompress backup"
        exit 1
    fi
else
    cp "${BACKUP_FILE}" "${TEMP_SQL}"
fi

if [ ! -f "${TEMP_SQL}" ]; then
    echo "❌ ERROR: Failed to prepare backup file"
    exit 1
fi

echo "✅ Backup decompressed: ${TEMP_SQL}"
echo "   Size: $(du -h "${TEMP_SQL}" 2>/dev/null | cut -f1 || echo "unknown")"

###############################################################################
# 6. TERMINATE ACTIVE CONNECTIONS
###############################################################################

echo ""
echo "[3/5] Terminating active database connections..."

PGPASSWORD="${DB_PASSWORD}" psql \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "postgres" \
    -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${DB_NAME}' AND pid <> pg_backend_pid();" \
    > /dev/null 2>&1

echo "✅ Active connections terminated"

###############################################################################
# 7. DROP & RECREATE DATABASE
###############################################################################

echo ""
echo "[4/5] Recreating database..."

# Drop database
PGPASSWORD="${DB_PASSWORD}" psql \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "postgres" \
    -c "DROP DATABASE IF EXISTS ${DB_NAME};" \
    > /dev/null 2>&1

echo "   🗑️  Old database dropped"

# Create database
PGPASSWORD="${DB_PASSWORD}" psql \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "postgres" \
    -c "CREATE DATABASE ${DB_NAME};" \
    > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Database recreated: ${DB_NAME}"
else
    echo "❌ ERROR: Failed to recreate database"
    rm -f "${TEMP_SQL}"
    exit 1
fi

###############################################################################
# 8. RESTORE DATA
###############################################################################

echo ""
echo "[5/5] Restoring data from backup..."
echo "    ⏳ This may take several minutes..."

RESTORE_LOG="/tmp/restore_output_$(date +%s).log"

if PGPASSWORD="${DB_PASSWORD}" psql \
    -h "${DB_HOST}" \
    -p "${DB_PORT}" \
    -U "${DB_USER}" \
    -d "${DB_NAME}" \
    -f "${TEMP_SQL}" \
    > "${RESTORE_LOG}" 2>&1; then
    
    echo "✅ Data restored successfully!"
else
    echo "⚠️  WARNING: Restore completed with some errors"
    echo "    Check log: ${RESTORE_LOG}"
fi

###############################################################################
# 9. VERIFY RESTORE
###############################################################################

echo ""
echo "Verifying restored data..."
echo ""
echo "Record counts:"
echo "----------------------------------------"

# List of tables to verify
tables=("fact_kunjungan" "dim_time" "dim_objek_wisata" "dim_wisatawan" "dim_price" "staging_kunjungan_raw")

for table in "${tables[@]}"; do
    COUNT=$(PGPASSWORD="${DB_PASSWORD}" psql \
        -h "${DB_HOST}" \
        -p "${DB_PORT}" \
        -U "${DB_USER}" \
        -d "${DB_NAME}" \
        -t -c "SELECT COUNT(*) FROM ${table};" 2>/dev/null | tr -d ' ')
    
    if [ -z "$COUNT" ]; then
        COUNT="0 (table not found)"
    else
        # Format number with commas
        COUNT=$(printf "%'d" "$COUNT")
    fi
    
    printf "  %-30s: %s records\n" "${table}" "${COUNT}"
done

echo "----------------------------------------"

###############################################################################
# 10. CLEANUP
###############################################################################

echo ""
echo "Cleaning up temporary files..."
rm -f "${TEMP_SQL}" 2>/dev/null

# Keep restore log for debugging
if [ -f "${RESTORE_LOG}" ]; then
    FINAL_LOG="${BACKUP_DIR}/restore_log_$(date +%Y%m%d_%H%M%S).txt"
    mv "${RESTORE_LOG}" "${FINAL_LOG}"
    echo "Restore log saved: ${FINAL_LOG}"
fi

echo ""
echo "=========================================="
echo "RESTORE COMPLETED SUCCESSFULLY ✅"
echo "=========================================="
echo ""
echo "Safety backup location: ${SAFETY_BACKUP}"
echo "You can delete it after verifying the restore"
echo ""
echo "Next steps:"
if [ "$IS_DOCKER" = true ]; then
    echo "  1. Verify data: docker-compose exec postgres psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT COUNT(*) FROM fact_kunjungan;'"
    echo "  2. Run ETL:     docker-compose exec etl python /app/scripts/etl/main_etl.py"
else
    echo "  1. Verify data: psql -U ${DB_USER} -d ${DB_NAME} -c 'SELECT COUNT(*) FROM fact_kunjungan;'"
    echo "  2. Run ETL:     python scripts/etl/main_etl.py"
fi
echo ""

exit 0
