@echo off
setlocal enabledelayedexpansion

REM Use SHORT PATH (8.3 format)
for %%i in ("C:\File Perkuliahan\SEMESTER 7\File Matkul Semester 7\Kecerdasan Bisnis (BI)\File Tugas\UAS\UAS_DW_Pariwisata_Jakarta") do set SHORT_PATH=%%~si

set COMPOSE_PATH=%SHORT_PATH%\docker\docker-compose.yml
set LOG_DIR=%SHORT_PATH%\logs\task_scheduler

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

set TIMESTAMP=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set LOG_FILE=%LOG_DIR%\etl_run_%TIMESTAMP%.log

echo ======================================================================== > "%LOG_FILE%"
echo ETL Task Scheduler - Started: %date% %time% >> "%LOG_FILE%"
echo Using short path: %SHORT_PATH% >> "%LOG_FILE%"
echo Docker Compose: %COMPOSE_PATH% >> "%LOG_FILE%"
echo ======================================================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

echo.
echo ========================================
echo ETL TASK SCHEDULER
echo ========================================
echo Started: %date% %time%
echo Short path: %SHORT_PATH%
echo.

REM Check Docker
echo [1/3] Checking Docker...
echo [1/3] Checking Docker... >> "%LOG_FILE%"
docker --version >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
    echo ERROR: Docker not available! >> "%LOG_FILE%"
    echo ERROR: Docker not available!
    pause
    exit /b 1
)

REM Check containers
echo [2/3] Checking containers...
echo [2/3] Checking containers... >> "%LOG_FILE%"
docker-compose -f "%COMPOSE_PATH%" ps >> "%LOG_FILE%" 2>&1

docker-compose -f "%COMPOSE_PATH%" ps etl 2>nul | findstr "Up" >nul
if errorlevel 1 (
    echo Starting containers...
    echo Starting containers... >> "%LOG_FILE%"
    docker-compose -f "%COMPOSE_PATH%" up -d >> "%LOG_FILE%" 2>&1
    if errorlevel 1 (
        echo ERROR: Failed to start containers! >> "%LOG_FILE%"
        echo ERROR: Failed to start containers!
        pause
        exit /b 1
    )
    timeout /t 30 /nobreak > nul
)

REM Run ETL
echo [3/3] Running ETL...
echo [3/3] Running ETL... >> "%LOG_FILE%"
echo ---------------------------------------- >> "%LOG_FILE%"
docker-compose -f "%COMPOSE_PATH%" exec -T etl python /app/scripts/etl/main_etl.py >> "%LOG_FILE%" 2>&1
set EXIT_CODE=%ERRORLEVEL%
echo ---------------------------------------- >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

REM Result (FIXED LOGIC)
if %EXIT_CODE% equ 0 (
    echo SUCCESS: ETL completed >> "%LOG_FILE%"
    echo ======================================================================== >> "%LOG_FILE%"
    echo.
    echo ========================================
    echo ETL COMPLETED SUCCESSFULLY!
    echo ========================================
    echo Finished: %date% %time%
    echo Exit code: %EXIT_CODE%
    echo Log: %LOG_FILE%
    echo.
    goto :success
) else (
    echo ERROR: ETL failed (exit code: %EXIT_CODE%) >> "%LOG_FILE%"
    echo ======================================================================== >> "%LOG_FILE%"
    echo.
    echo ========================================
    echo ETL FAILED!
    echo ========================================
    echo Exit code: %EXIT_CODE%
    echo Finished: %date% %time%
    echo Log: %LOG_FILE%
    echo.
    
    REM Send notification
    docker-compose -f "%COMPOSE_PATH%" exec -T etl python /app/scripts/disaster_recovery/send_notification.py --type error --message "ETL failed with exit code %EXIT_CODE%" >> "%LOG_FILE%" 2>&1
    goto :failed
)

:success
echo Press any key to exit...
pause > nul
exit /b 0

:failed
echo Press any key to exit...
pause > nul
exit /b %EXIT_CODE%
