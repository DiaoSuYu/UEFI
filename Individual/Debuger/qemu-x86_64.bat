@ECHO OFF
REM ============================================================
REM UEFI Debug Environment Launcher - Simple Version
REM ============================================================

REM Change to script directory
cd /d "%~dp0"

echo ============================================================
echo UEFI Debug Environment Launcher
echo ============================================================
echo.

REM ============================================================
REM Step 1: Kill Existing Processes
REM ============================================================

echo [1/8] Stopping existing debug processes...

REM Kill WinDbg
tasklist /FI "IMAGENAME eq windbg.exe" 2>NUL | find /I "windbg.exe" >NUL
if %errorlevel% equ 0 (
    echo Stopping WinDbg...
    taskkill /F /IM windbg.exe >NUL 2>&1
    timeout /t 1 /nobreak >NUL
)

REM Kill SoftDebugger
tasklist /FI "IMAGENAME eq SoftDebugger.exe" 2>NUL | find /I "SoftDebugger.exe" >NUL
if %errorlevel% equ 0 (
    echo Stopping SoftDebugger...
    taskkill /F /IM SoftDebugger.exe >NUL 2>&1
    timeout /t 1 /nobreak >NUL
)

REM Kill eXdi
tasklist /FI "IMAGENAME eq eXdi.exe" 2>NUL | find /I "eXdi.exe" >NUL
if %errorlevel% equ 0 (
    echo Stopping eXdi...
    taskkill /F /IM eXdi.exe >NUL 2>&1
    timeout /t 1 /nobreak >NUL
)

REM Kill QEMU
tasklist /FI "IMAGENAME eq qemu-system-x86_64.exe" 2>NUL | find /I "qemu-system-x86_64.exe" >NUL
if %errorlevel% equ 0 (
    echo Stopping QEMU...
    taskkill /F /IM qemu-system-x86_64.exe >NUL 2>&1
    timeout /t 1 /nobreak >NUL
)

echo OK: Existing processes stopped
echo.

REM ============================================================
REM Step 2: Release Port 20715 (Terminal Redirection)
REM ============================================================

echo [2/8] Checking and releasing port 20715...

REM Check if port 20715 is in use
for /f "tokens=5" %%a in ('netstat -ano ^| find ":20715"') do (
    if not "%%a"=="0" (
        echo Port 20715 is in use by process ID %%a
        taskkill /F /PID %%a >NUL 2>&1
        if %errorlevel% equ 0 (
            echo Released port 20715
        ) else (
            echo Failed to release port 20715
        )
    )
)

echo OK: Port 20715 checked
echo.

REM ============================================================
REM Step 3: Check Administrator Privileges
REM ============================================================

echo [3/8] Checking administrator privileges...
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script requires Administrator privileges!
    echo.
    echo Please right-click this file and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)
echo OK: Running as Administrator
echo.

REM ============================================================
REM Step 4: Set Paths
REM ============================================================

echo [4/8] Setting up environment paths...

REM Set base paths
set "BASE_DIR=%CD%"
set "DEBUG_TOOLS_PATH=..\..\Tools\DebugTools"

REM Convert to absolute path
pushd "%DEBUG_TOOLS_PATH%"
set "DEBUG_TOOLS_PATH=%CD%"
popd

set "SOFT_DEBUGGER_DIR=%DEBUG_TOOLS_PATH%\Intel(R) UEFI Development Kit Debugger Tool"
set "QEMU_EXE=%DEBUG_TOOLS_PATH%\QEMU\qemu-system-x86_64.exe"
set "EXDI_EXE=%SOFT_DEBUGGER_DIR%\eXdi.exe"
set "WINDbg_DIR=%SOFT_DEBUGGER_DIR%\Debugging Tools for Windows (x86)"

echo BASE_DIR: "%BASE_DIR%"
echo DEBUG_TOOLS_PATH: "%DEBUG_TOOLS_PATH%"
echo SOFT_DEBUGGER_DIR: "%SOFT_DEBUGGER_DIR%"
echo.

REM ============================================================
REM Step 5: Verify Files
REM ============================================================

echo [5/8] Verifying required files...

if not exist "%SOFT_DEBUGGER_DIR%" (
    echo ERROR: SoftDebugger directory not found
    echo Path: "%SOFT_DEBUGGER_DIR%"
    pause
    exit /b 1
)

if not exist "%QEMU_EXE%" (
    echo ERROR: QEMU not found
    echo Path: "%QEMU_EXE%"
    pause
    exit /b 1
)

if not exist "%EXDI_EXE%" (
    echo ERROR: eXdi.exe not found
    echo Path: "%EXDI_EXE%"
    pause
    exit /b 1
)

if not exist "%WINDbg_DIR%" (
    echo ERROR: WinDbg directory not found
    echo Path: "%WINDbg_DIR%"
    pause
    exit /b 1
)

echo OK: All required files found
echo.

REM ============================================================
REM Step 6: Create System Directory Link
REM ============================================================

echo [6/8] Checking system directory...

set "SYSTEM_DIR=C:\Program Files (x86)\Intel\Intel(R) UEFI Development Kit Debugger Tool"

REM Check if system directory exists
if not exist "%SYSTEM_DIR%" (
    echo System directory not found, creating directory junction...
    
    REM Create parent directory if needed
    if not exist "C:\Program Files (x86)\Intel" (
        mkdir "C:\Program Files (x86)\Intel" 2>nul
    )
    
    REM Create directory junction (requires admin)
    mklink /J "%SYSTEM_DIR%" "%SOFT_DEBUGGER_DIR%" >nul 2>&1
    if %errorlevel% equ 0 (
        echo OK: Created directory junction
    ) else (
        echo WARNING: Failed to create directory junction
        echo You may need to manually create the directory or run as Administrator
    )
) else (
    echo OK: System directory exists
)
echo.

REM ============================================================
REM Step 7: Register COM Components
REM ============================================================

echo [7/8] Registering COM components...

set "TARGET_DLL=%SOFT_DEBUGGER_DIR%\eXdips.dll"

if not exist "%TARGET_DLL%" (
    echo ERROR: eXdips.dll not found
    echo Path: "%TARGET_DLL%"
    pause
    exit /b 1
)

REM Register the DLL
regsvr32 /s "%TARGET_DLL%"
if %errorlevel% equ 0 (
    echo OK: eXdips.dll registered successfully
) else (
    echo WARNING: Failed to register eXdips.dll
    echo Some features may not work correctly
)
echo.

REM ============================================================
REM Step 8: Start Debug Environment
REM ============================================================

echo [8/8] Starting debug environment...
echo.
echo Starting WinDbg...
start "" /D "%SOFT_DEBUGGER_DIR%" "%EXDI_EXE%" /LaunchWinDbg

echo.
echo Waiting for debugger to initialize...
timeout /t 3 /nobreak >nul

echo.
echo Starting QEMU...
"%QEMU_EXE%" -bios OVMF.fd -usbdevice disk:HDD_BOOT.IMA -serial pipe:QemuPipeDbg

echo.
echo ============================================================
echo Debug session ended
echo ============================================================
echo Press any key to close...
pause