@echo off
REM ============================================================
REM Daily Backup - Calls backup_database.sh auto
REM ============================================================

REM Get script directory
set "SCRIPT_DIR=%~dp0"

REM Go up 2 levels to project root, then to docker folder
cd /d "%SCRIPT_DIR%..\..\docker"

echo [%date% %time%] Running daily backup...
docker-compose -f docker-compose.yml exec -T etl bash /app/scripts/disaster_recovery/backup_database.sh auto

exit /b %ERRORLEVEL%
