@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: CONFIGURATION
:: ==========================================
set "JAR_FILE=C:\Gertec\tc-server.jar"
set "AGENT_FILE=C:\Gertec\title-agent.jar"
set "BASE_DIR=C:\Gertec\Instances"
set "TOTAL_INSTANCES=2"
set "DELAY_SECONDS=3"
:: ==========================================

echo Starting %TOTAL_INSTANCES% TC-Server instances...
echo.

for /L %%i in (1,1,%TOTAL_INSTANCES%) do (
    set "INSTANCE_DIR=%BASE_DIR%\TC%%i"
    
    if not exist "!INSTANCE_DIR!" (
        mkdir "!INSTANCE_DIR!"
    )

    echo [%%i/%TOTAL_INSTANCES%] Launching instance in !INSTANCE_DIR! ...
    
    :: Starts the stock JAR file and then appends the Title-Agent
    start "TC-Server-%%i" javaw -javaagent:"%AGENT_FILE%= - Loja %%i" -Duser.home="!INSTANCE_DIR!" -jar "%JAR_FILE%"

    if %%i LSS %TOTAL_INSTANCES% (
        timeout /t %DELAY_SECONDS% /nobreak >nul
    )
)

echo.
echo All %TOTAL_INSTANCES% instances have been launched!
timeout /t 5
