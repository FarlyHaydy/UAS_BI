"""
Helper functions untuk ETL process
Enhanced with error notification support for Docker environment
"""
import logging
import pandas as pd
from datetime import datetime
import os
import sys
import subprocess
import traceback


logger = logging.getLogger(__name__)


def clean_text(text):
    """Clean text data"""
    if pd.isna(text):
        return None
    return str(text).strip()


def extract_periode_info(periode_data):
    """
    Extract year, month, quarter from periode_data
    Input: 202501 (YYYYMM)
    Output: {'tahun': 2025, 'bulan': 1, 'kuartal': 1}
    """
    try:
        periode_str = str(periode_data)
        tahun = int(periode_str[:4])
        bulan = int(periode_str[4:])
        kuartal = (bulan - 1) // 3 + 1
        
        nama_bulan_dict = {
            1: 'Januari', 2: 'Februari', 3: 'Maret', 4: 'April',
            5: 'Mei', 6: 'Juni', 7: 'Juli', 8: 'Agustus',
            9: 'September', 10: 'Oktober', 11: 'November', 12: 'Desember'
        }
        
        return {
            'tahun': tahun,
            'bulan': bulan,
            'nama_bulan': nama_bulan_dict.get(bulan),
            'kuartal': kuartal
        }
    except Exception as e:
        logger.error(f"Error parsing periode {periode_data}: {e}")
        return None


def extract_wilayah_from_alamat(alamat):
    """
    Extract wilayah (Jakarta Pusat, Jakarta Utara, dll) from alamat
    """
    if pd.isna(alamat):
        return 'Tidak Diketahui'
    
    wilayah_keywords = [
        'Jakarta Pusat', 'Jakarta Utara', 'Jakarta Selatan',
        'Jakarta Barat', 'Jakarta Timur', 'Kepulauan Seribu'
    ]
    
    alamat_upper = str(alamat).upper()
    for wilayah in wilayah_keywords:
        if wilayah.upper() in alamat_upper:
            return wilayah
    
    return 'Jakarta'  # Default


def handle_missing_values(df, strategy='drop'):
    """
    Handle missing values in DataFrame (NOT-USED)
    strategy: 'drop', 'fill_zero', 'fill_mean'
    """
    if strategy == 'drop':
        return df.dropna()
    elif strategy == 'fill_zero':
        return df.fillna(0)
    elif strategy == 'fill_mean':
        return df.fillna(df.mean())
    return df


def log_etl_step(step_name, status, message=""):
    """Log ETL step with timestamp"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_message = f"[{timestamp}] {step_name} - {status}: {message}"
    
    if status == "ERROR":
        logger.error(log_message)
    elif status == "WARNING":
        logger.warning(log_message)
    else:
        logger.info(log_message)
    
    # Also print to console for visibility
    if status == "ERROR":
        print(f"❌ {log_message}")
    elif status == "WARNING":
        print(f"⚠️  {log_message}")
    elif status == "SUCCESS":
        print(f"✅ {log_message}")
    else:
        print(f"ℹ️  {log_message}")


def validate_data_quality(df, required_columns):
    """
    Validate data quality
    Returns: (is_valid, error_messages)
    """
    errors = []
    
    # Check required columns
    missing_cols = set(required_columns) - set(df.columns)
    if missing_cols:
        errors.append(f"Missing columns: {missing_cols}")
    
    # Check for empty dataframe
    if df.empty:
        errors.append("DataFrame is empty")
    
    # Check for duplicates
    duplicates = df.duplicated().sum()
    if duplicates > 0:
        logger.warning(f"Found {duplicates} duplicate rows")
    
    is_valid = len(errors) == 0
    return is_valid, errors


###############################################################################
# ERROR NOTIFICATION FUNCTIONS (DOCKER-COMPATIBLE)
###############################################################################


def send_error_notification(error_type, error_message, stack_trace="", context="ETL Process"):
    """
    Send error notification via email using send_notification.py script
    Compatible with Docker environment
    
    Args:
        error_type: Type of error (e.g., "DATABASE_ERROR", "EXTRACTION_ERROR")
        error_message: Brief error description
        stack_trace: Full stack trace (optional)
        context: Context where error occurred (default: "ETL Process")
    
    Returns:
        bool - True if notification sent successfully, False otherwise
    """
    try:
        # Get notification script path
        current_dir = os.path.dirname(os.path.abspath(__file__))
        notification_script = os.path.join(
            current_dir,
            '..',
            'disaster_recovery',
            'send_notification.py'
        )
        
        notification_script = os.path.normpath(notification_script)
        
        # Check if notification script exists
        if not os.path.exists(notification_script):
            logger.warning(f"Notification script not found: {notification_script}")
            print(f"⚠️  Cannot send notification: script not found")
            return False
        
        # Build detailed message
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S WITA')
        is_docker = os.path.exists('/.dockerenv')
        
        detailed_message = f"""
╔════════════════════════════════════════════════════════════════╗
║           ETL ERROR NOTIFICATION                               ║
║           Data Warehouse Pariwisata Jakarta 2025               ║
╚════════════════════════════════════════════════════════════════╝

⚠️  ERROR DETECTED

Context         : {context}
Error Type      : {error_type}
Timestamp       : {timestamp}
Environment     : {'Docker Container' if is_docker else 'Local'}
Database        : {os.getenv('DB_NAME', 'dw_pariwisata_jakarta')}
Host            : {os.getenv('DB_HOST', 'localhost')}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ERROR MESSAGE:

{error_message}
"""
        
        if stack_trace:
            detailed_message += f"""
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STACK TRACE:

{stack_trace}
"""
        
        detailed_message += """
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 RECOMMENDED ACTIONS:

1. Check ETL logs:
   docker-compose logs etl

2. Check database status:
   docker-compose exec postgres psql -U postgres -d dw_pariwisata_jakarta -c "SELECT 1;"

3. Re-run ETL if needed:
   docker-compose exec etl python /app/scripts/etl/main_etl.py

4. Contact system administrator if issue persists

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is an automated notification from DW Monitoring System.
"""
        
        # Generate subject
        subject = f"{error_type} - {context}"
        
        # Call notification script
        logger.info(f"Sending error notification: {error_type}")
        
        result = subprocess.run(
            [
                sys.executable,
                notification_script,
                '--type', 'error',
                '--subject', subject,
                '--message', detailed_message
            ],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        if result.returncode == 0:
            logger.info("✓ Error notification sent successfully")
            print("✅ Error notification sent")
            return True
        else:
            logger.error(f"Failed to send notification: {result.stderr}")
            print(f"❌ Notification failed: {result.stderr}")
            return False
            
    except subprocess.TimeoutExpired:
        logger.error("Notification timeout after 30 seconds")
        print("❌ Notification timeout")
        return False
    except Exception as e:
        logger.error(f"Error sending notification: {e}")
        print(f"⚠️  Could not send notification: {e}")
        return False


def send_success_notification(summary_data, elapsed_time=0):
    """
    Send success notification after ETL completes
    
    Args:
        summary_data: Dictionary with ETL summary (record counts, etc.)
        elapsed_time: Time taken for ETL process (seconds)
    
    Returns:
        bool - True if notification sent successfully
    """
    try:
        # Check if success notifications are enabled
        email_on_success = os.getenv('EMAIL_ON_SUCCESS', 'true').lower() == 'true'
        
        if not email_on_success:
            logger.info("Success notifications disabled (EMAIL_ON_SUCCESS=false)")
            return False
        
        # Get notification script path
        current_dir = os.path.dirname(os.path.abspath(__file__))
        notification_script = os.path.join(
            current_dir,
            '..',
            'disaster_recovery',
            'send_notification.py'
        )
        notification_script = os.path.normpath(notification_script)
        
        if not os.path.exists(notification_script):
            return False
        
        # Format elapsed time
        minutes = int(elapsed_time // 60)
        seconds = int(elapsed_time % 60)
        time_str = f"{minutes}m {seconds}s"
        
        # Build success message
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S WITA')
        is_docker = os.path.exists('/.dockerenv')
        
        message = f"""
╔════════════════════════════════════════════════════════════════╗
║           ETL SUCCESS NOTIFICATION                             ║
║           Data Warehouse Pariwisata Jakarta 2025               ║
╚════════════════════════════════════════════════════════════════╝

✅ ETL PROCESS COMPLETED SUCCESSFULLY

Timestamp       : {timestamp}
Execution Time  : {time_str}
Environment     : {'Docker Container' if is_docker else 'Local'}
Database        : {os.getenv('DB_NAME', 'dw_pariwisata_jakarta')}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DATA WAREHOUSE SUMMARY:
"""
        
        # Add summary data
        if summary_data:
            for key, value in summary_data.items():
                if key != 'orphan_facts':
                    message += f"\n  {key:30s}: {value:>10,} records"
        
        message += """

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All data loaded successfully. Data warehouse is ready for analysis.

This is an automated notification from DW Monitoring System.
"""
        
        # Send notification
        result = subprocess.run(
            [
                sys.executable,
                notification_script,
                '--type', 'success',
                '--subject', 'ETL Process Completed Successfully',
                '--message', message
            ],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        return result.returncode == 0
        
    except Exception as e:
        logger.warning(f"Could not send success notification: {e}")
        return False


def send_warning_notification(warning_type, warning_message):
    """
    Send warning notification for non-critical issues
    
    Args:
        warning_type: Type of warning
        warning_message: Warning description
    
    Returns:
        bool - True if notification sent successfully
    """
    try:
        # Check if warning notifications are enabled
        email_on_warning = os.getenv('EMAIL_ON_WARNING', 'true').lower() == 'true'
        
        if not email_on_warning:
            logger.info("Warning notifications disabled (EMAIL_ON_WARNING=false)")
            return False
        
        # Get notification script path
        current_dir = os.path.dirname(os.path.abspath(__file__))
        notification_script = os.path.join(
            current_dir,
            '..',
            'disaster_recovery',
            'send_notification.py'
        )
        notification_script = os.path.normpath(notification_script)
        
        if not os.path.exists(notification_script):
            return False
        
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S WITA')
        
        message = f"""
⚠️  ETL WARNING

Type      : {warning_type}
Timestamp : {timestamp}
Database  : {os.getenv('DB_NAME', 'dw_pariwisata_jakarta')}

WARNING DETAILS:

{warning_message}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

This is a non-critical warning. ETL may have completed but with issues.
Please review and take action if needed.
"""
        
        result = subprocess.run(
            [
                sys.executable,
                notification_script,
                '--type', 'warning',
                '--subject', f'ETL Warning - {warning_type}',
                '--message', message
            ],
            capture_output=True,
            text=True,
            timeout=30
        )
        
        return result.returncode == 0
        
    except Exception as e:
        logger.warning(f"Could not send warning notification: {e}")
        return False


###############################################################################
# UTILITY DECORATORS FOR ERROR HANDLING
###############################################################################


def with_error_notification(error_type="GENERAL_ERROR"):
    """
    Decorator to automatically send notification on function error
    
    Usage:
        @with_error_notification("EXTRACTION_ERROR")
        def extract_data():
            # your code here
    """
    def decorator(func):
        def wrapper(*args, **kwargs):
            try:
                return func(*args, **kwargs)
            except Exception as e:
                error_msg = str(e)
                stack = traceback.format_exc()
                
                logger.error(f"{error_type} in {func.__name__}: {error_msg}")
                
                # Send notification
                send_error_notification(
                    error_type=error_type,
                    error_message=error_msg,
                    stack_trace=stack,
                    context=f"Function: {func.__name__}"
                )
                
                # Re-raise exception
                raise
        
        return wrapper
    return decorator
