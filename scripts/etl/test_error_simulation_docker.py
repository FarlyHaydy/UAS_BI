"""
Test Error Simulation & Email Notification - DOCKER VERSION
Simulate ETL error to verify email notification is triggered
"""
import sys
import os

# Add to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

print("="*80)
print("TEST: ERROR SIMULATION & NOTIFICATION (DOCKER)")
print("="*80)
print()

# Check email configuration from environment
EMAIL_ENABLED = os.getenv('EMAIL_ENABLED', 'false').lower() == 'true'
ALERT_EMAIL_TO = os.getenv('ALERT_RECIPIENTS', os.getenv('ALERT_EMAIL_TO', ''))

if not EMAIL_ENABLED:
    print("⚠️  Email notifications are disabled")
    print("   Set EMAIL_ENABLED=true in .env to enable")
    print()

if not ALERT_EMAIL_TO:
    print("⚠️  Email recipients not configured")
    print("   Set ALERT_RECIPIENTS in .env")
    print()
    print("Test will continue (error handling works without email)")
    print()
else:
    print(f"✓ Email will be sent to: {ALERT_EMAIL_TO}")
    print()

# Import modules
try:
    from extract import DataExtractor
    from config import logger
except ImportError as e:
    print(f"❌ Import error: {e}")
    sys.exit(1)

# Backup original method
original_method = DataExtractor.extract_kunjungan_data

# Create error simulation
def simulate_error(self):
    """Simulate extraction error"""
    raise Exception("SIMULATED ERROR: Testing disaster recovery email notification from Docker")

# Monkey patch to inject error
DataExtractor.extract_kunjungan_data = simulate_error

print("✓ Injected simulated error into ETL pipeline")
print("  Error will occur at STEP 1: EXTRACT DATA")
print()
print("="*80)
print("RUNNING ETL WITH SIMULATED ERROR...")
print("="*80)
print()

# Run ETL (will fail and trigger email)
try:
    from main_etl import run_etl
    success = run_etl(skip_backup=True)
except Exception as e:
    print(f"ETL raised exception: {e}")
    success = False

print()
print("="*80)
if not success:
    print("✅ TEST PASSED!")
    print()
    print("ETL failed as expected (simulated error).")
    
    if EMAIL_ENABLED and ALERT_EMAIL_TO:
        print("Error notification should have been sent.")
        print()
        print(f"📧 Check email inbox: {ALERT_EMAIL_TO}")
        print()
        print("Expected email subject:")
        print("   [ERROR] ETL Process Failed - Action Required")
        print()
        print("Email should contain:")
        print("   - Error: SIMULATED ERROR")
        print("   - Stack trace")
        print("   - Timestamp and hostname")
    else:
        print()
        print("⚠️  Email notification not sent (disabled or not configured)")
else:
    print("❌ TEST FAILED!")
    print("   ETL should have failed but succeeded")

print("="*80)
print()

# Restore original method
DataExtractor.extract_kunjungan_data = original_method

print("✓ Original method restored")
print("Test completed")
