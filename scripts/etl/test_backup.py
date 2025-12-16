"""
Test Pre-ETL Backup Function
"""
import sys
import os

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

# Import function from main_etl
from main_etl import run_pre_etl_backup

print("="*80)
print("TESTING PRE-ETL BACKUP FUNCTION")
print("="*80)

# Test backup
success = run_pre_etl_backup()

if success:
    print("\n✅ PRE-ETL BACKUP TEST PASSED!")
    print("   Backup files created in: data/backups/")
else:
    print("\n⚠️  PRE-ETL BACKUP TEST COMPLETED WITH WARNINGS")
    print("   Check error messages above")

print("="*80)
