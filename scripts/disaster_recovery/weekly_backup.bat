@echo off
REM ============================================================
REM Weekly Backup - Calls backup_database.sh manual
REM ============================================================

REM Get script directory
set "SCRIPT_DIR=%~dp0"

REM Go up 2 levels to project root, then to docker folder
cd /d "%SCRIPT_DIR%..\..\docker"

echo [%date% %time%] Running weekly backup...
docker-compose -f docker-compose.yml exec -T etl bash /app/scripts/disaster_recovery/backup_database.sh manual

exit /b %ERRORLEVEL%
