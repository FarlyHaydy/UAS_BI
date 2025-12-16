"""
Test 6: Database Restore from Backup
Test disaster recovery restore procedure
"""
import sys
import os
import subprocess
from pathlib import Path

print("="*80)
print("TEST 6: DATABASE RESTORE")
print("="*80)
print()

# Get backup directory
current_dir = Path(__file__).parent
project_root = current_dir.parent.parent
backup_dir = project_root / 'data' / 'backups' / 'backups'

# Find latest backup file
backup_files = sorted(backup_dir.glob('full_backup_*.sql.gz'), reverse=True)

if not backup_files:
    print("No backup files found!")
    print(f"   Looked in: {backup_dir}")
    print()
    print("Run ETL first to create backups:")
    print("   python main_etl.py")
    sys.exit(1)

latest_backup = backup_files[0]
print(f"Latest backup found: {latest_backup.name}")
print(f"   Size: {latest_backup.stat().st_size / 1024:.0f} KB")
print(f"   Date: {latest_backup.stat().st_mtime}")
print()

# Ask for confirmation
print("WARNING: This will restore database from backup!")
print("Current database data will be replaced.")
print()
response = input("Do you want to proceed? (yes/no): ").strip().lower()

if response != 'yes':
    print()
    print("TEST 6 CANCELLED")
    print("Database restore cancelled by user")
    sys.exit(0)

print()
print("="*80)
print("STARTING RESTORE PROCESS...")
print("="*80)
print()

# Get restore script
restore_script = project_root / 'data' / 'backups' / 'restore_script.sh'

if not restore_script.exists():
    print(f"Restore script not found: {restore_script}")
    sys.exit(1)

# Make executable
os.chmod(restore_script, 0o755)

# Detect Git Bash
git_bash_paths = [
    r'C:\Program Files\Git\bin\bash.exe',
    r'C:\Program Files (x86)\Git\bin\bash.exe',
]
bash_exe = None
for path in git_bash_paths:
    if os.path.exists(path):
        bash_exe = path
        break

if not bash_exe and os.name == 'nt':
    print("Git Bash not found - cannot run restore script on Windows")
    sys.exit(1)

# Prepare command
if os.name == 'nt':
    # Convert Windows path to Git Bash path
    backup_path_bash = str(latest_backup).replace('\\', '/').replace('C:', '/c')
    command = [bash_exe, str(restore_script), backup_path_bash, 'auto']  # ← ADD 'auto'
else:
    command = [str(restore_script), str(latest_backup), 'auto']  # ← ADD 'auto'

# Load environment for PostgreSQL
from dotenv import load_dotenv
load_dotenv(project_root / '.env')

env = os.environ.copy()
env['DB_HOST'] = os.getenv('DB_HOST', 'localhost')
env['DB_PORT'] = os.getenv('DB_PORT', '5432')
env['DB_NAME'] = os.getenv('DB_NAME', 'dw_pariwisata_jakarta')
env['DB_USER'] = os.getenv('DB_USER', 'postgres')
env['DB_PASSWORD'] = os.getenv('DB_PASSWORD', '')

# Add PostgreSQL to PATH
if os.name == 'nt':
    pg_path = r'C:\Program Files\PostgreSQL\18\bin'
    if os.path.exists(pg_path):
        env['PATH'] = env.get('PATH', '') + os.pathsep + pg_path

print(f"Running restore script...")
print(f"   Command: {' '.join(command)}")
print()

# Run restore script
try:
    # For Windows, we need to provide stdin for confirmation
    result = subprocess.run(
        command,
        cwd=str(restore_script.parent),
        env=env,
        input='yes\n',  # Auto-confirm restore
        capture_output=True,
        text=True,
        encoding='utf-8',
        errors='ignore',
        timeout=300
    )
    
    # Show output
    if result.stdout:
        print(result.stdout)
    
    if result.stderr:
        print("STDERR:", result.stderr)
    
    print()
    print("="*80)
    if result.returncode == 0 or "RESTORE COMPLETED SUCCESSFULLY" in result.stdout:
        print("TEST 6 PASSED!")
        print()
        print("Database restored successfully!")
        print()
        print("Verify restored data:")
        print("   Run: python main_etl.py")
        print("   Or check database directly:")
        print(f"   psql -U postgres -d {env['DB_NAME']} -c 'SELECT COUNT(*) FROM fact_kunjungan;'")
    else:
        print("TEST 6 WARNING")
        print(f"   Return code: {result.returncode}")
        print("   Check output above for details")
    print("="*80)
    
except subprocess.TimeoutExpired:
    print("TEST 6 FAILED - Timeout after 5 minutes")
except Exception as e:
    print(f"TEST 6 FAILED - Error: {e}")
    import traceback
    traceback.print_exc()
