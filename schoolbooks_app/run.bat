@echo off
REM Launch script for SchoolBooks Flutter app on Windows

cd /d "%~dp0"

echo.
echo ==========================================
echo    SchoolBooks Flutter Launcher
echo ==========================================
echo.
echo 1. Run on Android Emulator (Recommended)
echo 2. Run on Web (Chrome)
echo 3. Run on Windows Desktop
echo 4. Show available devices
echo 0. Exit
echo.

set /p choice="Choose option (1-4): "

if "%choice%"=="1" (
    echo.
    echo Starting on Android Emulator...
    echo.
    call flutter run -d emulator-5554
) else if "%choice%"=="2" (
    echo.
    echo Starting on Chrome...
    echo.
    call flutter run -d chrome
) else if "%choice%"=="3" (
    echo.
    echo Starting on Windows...
    echo.
    call flutter run -d windows
) else if "%choice%"=="4" (
    echo.
    echo Available devices:
    echo.
    call flutter devices
) else if "%choice%"=="0" (
    echo Goodbye!
) else (
    echo Invalid choice!
)

pause
