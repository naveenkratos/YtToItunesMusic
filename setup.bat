@echo off
setlocal

:: =============================================
:: setup.bat - Wrapper for initialSetup.ps1
:: =============================================

:: Change to the script directory
cd /d "%~dp0"

:: Check for admin privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Run initialSetup.ps1 with unrestricted execution
echo Running PowerShell setup script...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0initialSetup.ps1"

if %errorlevel% neq 0 (
    echo.
    echo ❌ Setup failed. Check errors above.
    pause
    exit /b %errorlevel%
)

echo.
echo ✅ Setup completed successfully.
pause
