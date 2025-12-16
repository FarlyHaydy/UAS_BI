"""
Main ETL orchestrator with Disaster Recovery
Menjalankan full ETL pipeline: Extract -> Staging -> Transform (from staging) -> Load to DW
Enhanced with Pre-ETL Backup & Error Notification
TRADITIONAL APPROACH: Transform FROM staging database
DOCKER & LOCAL COMPATIBLE VERSION
"""
from extract import DataExtractor
from transform import DataTransformer
from load import DataLoader
from config import logger
from utils import log_etl_step, send_error_notification, send_success_notification
from sqlalchemy import text
import sys
import time
import os
import subprocess
import traceback
from datetime import datetime
import pandas as pd


# Write start marker
print("\n" + "="*80)
print(f"[{datetime.now()}] ETL Started")
print(f"Working Directory: {os.getcwd()}")
print(f"Script Path: {os.path.abspath(__file__)}")
print(f"Environment: {'Docker' if os.path.exists('/.dockerenv') else 'Local'}")
print("="*80 + "\n")


###############################################################################
# DISASTER RECOVERY FUNCTIONS
###############################################################################

def run_pre_etl_backup():
    """
    Run database backup before ETL process starts
    Compatible with Docker & Local environments
    Returns: bool - True if successful, False if failed
    """
    try:
        log_etl_step("BACKUP", "START", "Running pre-ETL database backup")
        print("\n" + "="*80)
        print("PRE-ETL BACKUP")
        print("="*80)
        
        # Detect environment
        is_docker = os.path.exists('/.dockerenv')
        
        # Get backup script path
        if is_docker:
            backup_script = '/app/scripts/disaster_recovery/backup_database.sh'
        else:
            current_dir = os.path.dirname(os.path.abspath(__file__))
            backup_script = os.path.join(
                current_dir, '..', 'disaster_recovery', 'backup_database.sh'
            )
            backup_script = os.path.normpath(backup_script)
        
        print(f"📂 Environment: {'Docker' if is_docker else 'Local'}")
        print(f"📂 Backup script: {backup_script}")
        
        # Check if backup script exists
        if not os.path.exists(backup_script):
            log_etl_step("BACKUP", "WARNING", f"Backup script not found: {backup_script}")
            print("⚠️  Backup script not found - skipping backup")
            return False
        
        # Make script executable (Unix-like systems)
        try:
            os.chmod(backup_script, 0o755)
        except:
            pass
        
        # Run backup script
        print("🔄 Executing backup script...")
        
        result = subprocess.run(
            ['bash', backup_script, 'auto'],
            capture_output=True,
            text=True,
            encoding='utf-8',
            errors='ignore',
            timeout=300  # 5 minutes timeout
        )
        
        # Check success
        if "BACKUP COMPLETED SUCCESSFULLY" in result.stdout or result.returncode == 0:
            log_etl_step("BACKUP", "SUCCESS", "Pre-ETL backup completed successfully")
            print("✅ Pre-ETL backup completed")
            
            # Show backup location
            if is_docker:
                print("   Backup location: /app/data/backups/")
            else:
                print(f"   Backup location: data/backups/")
            
            return True
        else:
            log_etl_step("BACKUP", "WARNING", f"Backup warning: {result.stderr[:200]}")
            print(f"⚠️  Backup warning (ETL will continue)")
            if result.stderr:
                print(f"   Error: {result.stderr[:500]}")
            return False
            
    except subprocess.TimeoutExpired:
        log_etl_step("BACKUP", "ERROR", "Backup timeout after 5 minutes")
        print("❌ Backup timeout - continuing ETL without backup")
        return False
    except Exception as e:
        log_etl_step("BACKUP", "ERROR", f"Backup failed: {e}")
        print(f"❌ Backup error: {e}")
        traceback.print_exc()
        return False


###############################################################################
# MAIN ETL FUNCTION (TRADITIONAL APPROACH)
###############################################################################

def run_etl(skip_price=False, skip_backup=False, keep_staging=True):
    """
    Run full ETL process with disaster recovery features
    TRADITIONAL APPROACH: Extract → Staging → Transform FROM staging → Load to DW
    
    Flow:
      1. Extract RAW dari Excel → memory DataFrame
      2. Load RAW ke staging tables
      3. Transform FROM staging database (SQL queries)
      4. Build dimensions FROM staging (traditional way)
      5. Load fact FROM staging using JOIN
    
    Args:
        skip_price (bool): Skip dim_price loading (default: False)
        skip_backup (bool): Skip pre-ETL backup (default: False)
        keep_staging (bool): Keep staging data after ETL (default: True)
    
    Returns:
        bool - True if successful, False if failed
    """
    start_time = time.time()
    backup_success = False
    
    try:
        log_etl_step("ETL", "START", "Starting full ETL process (Traditional - Transform from staging)")
        
        # ==========================================
        # STEP 0: PRE-ETL BACKUP (Disaster Recovery)
        # ==========================================
        if not skip_backup:
            backup_success = run_pre_etl_backup()
            if backup_success:
                print("✅ Safety backup created - ETL can proceed safely")
            else:
                print("⚠️  No backup created - proceeding with caution")
        else:
            print("\n⊘ Pre-ETL backup skipped (--skip-backup flag)")
        
        # Initialize classes
        extractor = DataExtractor()
        transformer = DataTransformer()
        loader = DataLoader()
        
        # ==========================================
        # STEP 1: EXTRACT (Get raw data from sources)
        # ==========================================
        print("\n" + "="*80)
        print("STEP 1: EXTRACT DATA FROM SOURCES")
        print("="*80)
        
        df_kunjungan = extractor.extract_kunjungan_data()
        print(f"✓ Extracted {len(df_kunjungan)} kunjungan records (RAW data)")
        
        df_harga = extractor.extract_harga_data()
        if df_harga is not None:
            print(f"✓ Extracted {len(df_harga)} harga records (RAW data)")
        else:
            print(f"⚠ Harga data not available (will skip dim_price)")
            skip_price = True
        
        # ==========================================
        # STEP 2: LOAD RAW DATA TO STAGING
        # ==========================================
        print("\n" + "="*80)
        print("STEP 2: LOAD RAW DATA TO STAGING")
        print("="*80)
        print("💡 Staging will be used for transformation (Traditional ETL)")
        
        # Load raw kunjungan data to staging
        loader.load_to_staging(df_kunjungan, table_name='staging_kunjungan_raw')
        print(f"✓ Loaded {len(df_kunjungan)} RAW records to staging_kunjungan_raw")
        
        # Load raw harga data to staging (if available)
        if not skip_price and df_harga is not None:
            loader.load_to_staging(df_harga, table_name='staging_harga_tiket_raw')
            print(f"✓ Loaded {len(df_harga)} RAW harga records to staging_harga_tiket_raw")
        
        # ==========================================
        # STEP 3: BUILD DIMENSIONS FROM STAGING
        # ==========================================
        print("\n" + "="*80)
        print("STEP 3: BUILD DIMENSIONS FROM STAGING DATABASE")
        print("="*80)
        print("💡 Reading data FROM staging tables using SQL queries")
        
        # Build dim_time FROM staging 
        df_dim_time = transformer.build_dim_time()
        loader.load_dim_time(df_dim_time)
        print(f"✓ Loaded dim_time ({len(df_dim_time)} records) FROM staging")
        
        # Build dim_objek_wisata FROM staging 
        df_dim_objek = transformer.build_dim_objek_wisata()
        loader.load_dim_objek_wisata(df_dim_objek)
        print(f"✓ Loaded dim_objek_wisata ({len(df_dim_objek)} records) FROM staging")
        
        # dim_wisatawan (static - already in DB)
        print(f"✓ dim_wisatawan already exists (2 records: Nusantara, Mancanegara)")
        
        # Load dim_price (if available)
        if not skip_price and df_harga is not None:
            df_harga_transformed = transformer.transform_harga_data(df_harga)
            count = loader.load_dim_price(df_harga_transformed, truncate=True)
            print(f"✓ Loaded dim_price ({count} records)")
        else:
            print(f"⊘ Skipped dim_price (no data or skip_price=True)")
        
        # ==========================================
        # STEP 4: LOAD FACT FROM STAGING
        # ==========================================
        print("\n" + "="*80)
        print("STEP 4: LOAD FACT TABLE FROM STAGING")
        print("="*80)
        print("💡 Using SQL JOIN to merge staging with dimensions")
        
        # Load fact FROM staging using SQL JOIN (traditional way!)
        loader.load_fact_kunjungan()
        
        # Get count of loaded facts
        with loader.engine.connect() as conn:
            result = conn.execute(text("SELECT COUNT(*) FROM fact_kunjungan"))
            fact_count = result.scalar()
        
        print(f"✓ Loaded fact_kunjungan ({fact_count} records) FROM staging")
        print("  ✓ SQL JOIN with dim_time, dim_objek_wisata, dim_wisatawan")
        print("  ✓ Foreign key lookups completed via database")
        print("  ✓ Staging records marked as processed")
        
        # ==========================================
        # STEP 5: DATA QUALITY VERIFICATION
        # ==========================================
        print("\n" + "="*80)
        print("STEP 5: DATA QUALITY VERIFICATION")
        print("="*80)
        
        results = loader.verify_data_quality()
        if results:
            print("\nData Warehouse Summary:")
            print("-" * 80)
            for table, count in results.items():
                if table != 'orphan_facts':
                    print(f"  {table:30s}: {count:>10,} records")
            print("-" * 80)
            
            if results['orphan_facts'] > 0:
                print(f"\n⚠ WARNING: Found {results['orphan_facts']} orphan fact records!")
            else:
                print(f"\n✅ Data quality check passed - No orphan records")
        
        # ==========================================
        # STEP 6: STAGING CLEANUP
        # ==========================================
        print("\n" + "="*80)
        print("STEP 6: STAGING CLEANUP")
        print("="*80)
        
        if keep_staging:
            print("✓ Staging data retained for audit trail")
            print("  → All records marked as is_processed = TRUE")
        else:
            loader.truncate_staging()
            print("✓ Staging tables truncated (cleanup completed)")
        
        # Calculate execution time
        elapsed_time = time.time() - start_time
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        
        log_etl_step("ETL", "SUCCESS", f"ETL process completed in {minutes}m {seconds}s")
        
        print("\n" + "="*80)
        print("ETL PROCESS COMPLETED SUCCESSFULLY! ✅")
        print(f"Total execution time: {minutes}m {seconds}s")
        if backup_success:
            is_docker = os.path.exists('/.dockerenv')
            print(f"Backup location: {'/app/data/backups/' if is_docker else 'data/backups/'}")
        print("="*80)
        
        # Send success notification (if enabled)
        send_success_notification(results, elapsed_time)
        
        return True
        
    except Exception as e:
        elapsed_time = time.time() - start_time
        
        # Format detailed error message
        error_details = f"""
Exception Type  : {type(e).__name__}
Error Message   : {str(e)}
Elapsed Time    : {elapsed_time:.2f}s

Stack Trace:
{traceback.format_exc()}
"""
        
        # Log to file
        log_etl_step("ETL", "ERROR", f"ETL process failed after {elapsed_time:.2f}s: {e}")
        
        # Print to console
        print("\n" + "="*80)
        print(f"❌ ETL PROCESS FAILED")
        print(f"Error: {e}")
        print(f"Time elapsed: {elapsed_time:.2f}s")
        print("="*80)
        
        print("\n=== FULL ERROR TRACEBACK ===")
        traceback.print_exc()
        
        # Send error notification
        print("\n" + "="*80)
        print("SENDING ERROR NOTIFICATION...")
        print("="*80)
        
        notification_sent = send_error_notification(
            error_type="ETL_PROCESS_ERROR",
            error_message=str(e),
            stack_trace=traceback.format_exc(),
            context="ETL Process"
        )
        
        if not notification_sent:
            print("\n💡 TIP: Configure email alerts in .env file:")
            print("   EMAIL_ENABLED=true")
            print("   SMTP_USERNAME=your-email@gmail.com")
            print("   SMTP_PASSWORD=your-app-password")
            print("   ALERT_RECIPIENTS=admin@example.com")
        
        # Recovery suggestions
        print("\n" + "="*80)
        print("🔧 RECOVERY SUGGESTIONS:")
        print("="*80)
        print("1. Check database connection:")
        print("   docker-compose exec postgres psql -U postgres -d dw_pariwisata_jakarta")
        print("")
        print("2. Check logs:")
        print("   docker-compose logs etl")
        print("")
        print("3. Re-run ETL:")
        print("   docker-compose exec etl python /app/scripts/etl/main_etl.py")
        print("="*80)
        
        return False


###############################################################################
# QUICK PRICE UPDATE FUNCTION
###############################################################################

def run_price_only():
    """
    Run ETL untuk dim_price saja (quick update harga)
    """
    try:
        print("\n" + "="*80)
        print("QUICK ETL: UPDATE DIM_PRICE ONLY")
        print("="*80)
        
        extractor = DataExtractor()
        transformer = DataTransformer()
        loader = DataLoader()
        
        # Extract
        print("\n[1/3] Extracting harga data...")
        df_harga = extractor.extract_harga_data()
        
        if df_harga is None:
            print("❌ No harga data available")
            return False
        
        print(f"✓ Extracted {len(df_harga)} harga records")
        
        # Transform
        print("\n[2/3] Transforming harga data...")
        df_transformed = transformer.transform_harga_data(df_harga)
        print(f"✓ Transformed {len(df_transformed)} harga records")
        
        # Load
        print("\n[3/3] Loading to dim_price...")
        count = loader.load_dim_price(df_transformed, truncate=True)
        print(f"✓ Loaded {count} price records")
        
        print("\n" + "="*80)
        print("DIM_PRICE UPDATE COMPLETED! ✅")
        print("="*80)
        
        return True
        
    except Exception as e:
        print(f"\n❌ FAILED: {e}")
        traceback.print_exc()
        
        # Send notification for price update failure
        send_error_notification(
            error_type="PRICE_UPDATE_ERROR",
            error_message=str(e),
            stack_trace=traceback.format_exc(),
            context="Price Update (Quick ETL)"
        )
        
        return False


###############################################################################
# MAIN ENTRY POINT
###############################################################################

if __name__ == "__main__":
    import argparse
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description='ETL Process for Data Warehouse Pariwisata Jakarta with Disaster Recovery',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python main_etl.py                    # Full ETL with backup
  python main_etl.py --skip-backup      # Full ETL without backup
  python main_etl.py --skip-price       # ETL without dim_price
  python main_etl.py --price-only       # Quick price update only
  
ETL Flow (TRADITIONAL APPROACH):
  Step 0: Pre-ETL Backup (Disaster Recovery)
  Step 1: Extract (Get RAW data from Excel → memory)
  Step 2: Load to Staging (RAW data)
  Step 3: Build Dimensions (FROM staging using SQL)
  Step 4: Load Fact (FROM staging using SQL JOIN)
  Step 5: Data Quality Verification
  Step 6: Staging Cleanup (optional)
  
Environment Variables (.env):
  DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD
  EMAIL_ENABLED, SMTP_USERNAME, SMTP_PASSWORD, ALERT_RECIPIENTS
        """
    )
    
    parser.add_argument('--skip-price', action='store_true', 
                       help='Skip dim_price loading')
    parser.add_argument('--skip-backup', action='store_true',
                       help='Skip pre-ETL backup (not recommended)')
    parser.add_argument('--price-only', action='store_true',
                       help='Update dim_price only (quick mode)')
    
    args = parser.parse_args()
    
    # Print header
    print("\n" + "╔" + "="*78 + "╗")
    print("║" + " "*15 + "ETL PROCESS - DW PARIWISATA JAKARTA 2025" + " "*23 + "║")
    print("║" + " "*20 + "with Disaster Recovery Features" + " "*27 + "║")
    print("╚" + "="*78 + "╝")
    print(f"\nStarted at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S WITA')}")
    
    # Run appropriate ETL mode
    if args.price_only:
        success = run_price_only()
    else:
        success = run_etl(
            skip_price=args.skip_price,
            skip_backup=args.skip_backup,
        )
    
    # Exit with appropriate code
    exit_code = 0 if success else 1
    
    if success:
        print("\n🎉 ETL completed successfully")
    else:
        print("\n💥 ETL failed - check logs and error messages above")
    
    print(f"\nExit code: {exit_code}")
    sys.exit(exit_code)
