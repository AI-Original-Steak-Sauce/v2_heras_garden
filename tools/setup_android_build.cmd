@echo off
REM Android Build Environment Setup Script
REM Run this script AS ADMINISTRATOR to set up Android build environment
REM Created: 2025-12-30

echo ================================================
echo Circe's Garden - Android Build Environment Setup
echo ================================================
echo.

REM Check for admin privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script requires Administrator privileges.
    echo [ERROR] Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo [OK] Administrator privileges confirmed
echo.

REM ================================================
REM Step 1: Install OpenJDK 17
REM ================================================
echo [1/4] Installing OpenJDK 17...
echo ------------------------------------------------

echo Downloading Microsoft OpenJDK 17...
powershell -Command "winget install --id=Microsoft.OpenJDK.17 -e --source winget --silent" 2>nul

if %errorLevel% equ 0 (
    echo [OK] OpenJDK 17 installed successfully
) else (
    echo [WARNING] Winget install failed, trying manual download...
    echo Please download from: https://aka.ms/download-jdk/microsoft-jdk-17.0.17-windows-x64.msi
    echo And run the MSI installer manually.
)

echo.

REM ================================================
REM Step 2: Install Android SDK
REM ================================================
echo [2/4] Installing Android SDK...
echo ------------------------------------------------

echo Downloading Android SDK (command-line tools)...
powershell -Command "winget install --id=Google.AndroidSDK -e --source winget" 2>nul

if %errorLevel% neq 0 (
    echo [WARNING] Winget install failed, trying manual setup...
    echo Please download Android Studio from: https://developer.android.com/studio
    echo Or install command-line tools manually.
)

echo.

REM ================================================
REM Step 3: Set Environment Variables
REM ================================================
echo [3/4] Setting environment variables...
echo ------------------------------------------------

REM Set JAVA_HOME
setx JAVA_HOME "C:\Program Files\Microsoft\jdk\jdk-17.0.17.10-hotspot" /M >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] JAVA_HOME set to: C:\Program Files\Microsoft\jdk\jdk-17.0.17.10-hotspot
) else (
    echo [WARNING] Could not set JAVA_HOME automatically
)

REM Set ANDROID_HOME
setx ANDROID_HOME "C:\Users\%USERNAME%\AppData\Local\Android\Sdk" /M >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] ANDROID_HOME set to: C:\Users\%USERNAME%\AppData\Local\Android\Sdk
) else (
    echo [WARNING] Could not set ANDROID_HOME automatically
)

REM Add JAVA_HOME to PATH
setx PATH "%JAVA_HOME%\bin;%PATH%" /M >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Added JAVA_HOME/bin to system PATH
) else (
    echo [WARNING] Could not update PATH automatically
)

REM Add Android SDK tools to PATH
setx PATH "%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%PATH%" /M >nul 2>&1
if %errorLevel% equ 0 (
    echo [OK] Added Android SDK tools to system PATH
) else (
    echo [WARNING] Could not add Android tools to PATH
)

echo.

REM ================================================
REM Step 4: Install Godot Export Templates
REM ================================================
echo [4/4] Godot Export Templates...
echo ------------------------------------------------
echo Please open Godot 4.5.1 and go to:
echo   Editor ^> Manage Export Templates ^> Download and Install v4.5.1
echo.
echo Or download manually from:
echo   https://github.com/godotengine/godot/releases/download/4.5.1-stable/Godot_v4.5.1-stable_export_templates.tpz
echo.

REM ================================================
REM Summary
REM ================================================
echo ================================================
echo SETUP COMPLETE (or partially complete)
echo ================================================
echo.
echo Next steps:
echo 1. Restart your terminal/command prompt
echo 2. Verify Java: java -version
echo 3. Verify Android SDK: sdkmanager --version
echo 4. Open Godot, go to Editor ^> Export ^> Add ^> Android
echo 5. Configure the Android export preset
echo 6. Build APK
echo.
echo Documentation: docs/execution/ANDROID_BUILD_READY.md
echo.
pause
