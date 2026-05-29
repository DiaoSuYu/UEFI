@REM +-----------------------------------+
@REM | Enable delayed variable expansion |
@REM +-----------------------------------+
@REM This allows using "!" to access variables that are modified within loops or conditional blocks.
@REM Without this, the script would use the value of variables at the time the loop or block is entered, rather than during execution.
setlocal EnableDelayedExpansion


@REM +-----------------+
@REM | Set Environment |
@REM +-----------------+
@REM REM Set the root of the workspace to the current directory
set WORKSPACE=%CD%

@REM Set the path where all custom build tools are stored
set BUILD_TOOLS_PATH=%WORKSPACE%\Tools\BuildTools

@REM Set the path to EDK2 BaseTools (used for building UEFI applications)
set EDK_TOOLS_PATH=%WORKSPACE%\edk2\BaseTools

@REM Set the path to Cygwin (used for Unix-like build tools on Windows)
set CYGWIN_HOME=%BUILD_TOOLS_PATH%\Cygwin64

@REM Add Cygwin's binaries to the environment
set CLANG_BIN=%BUILD_TOOLS_PATH%\Cygwin64\bin

@REM Define the Git executable to use for version control
set GIT_COMMAND=%BUILD_TOOLS_PATH%\Git\cmd\git.exe

@REM Set the path to NASM assembler (used for assembling source code)
set NASM_PREFIX=%BUILD_TOOLS_PATH%\NASM\

@REM Set the Python installation used by EDK2 scripts
set PYTHON_HOME=%BUILD_TOOLS_PATH%\Python\Python313

@REM Set the Python executable path explicitly
set PYTHON_COMMAND=%BUILD_TOOLS_PATH%\Python\Python313\python.exe

@REM Define the version of Visual Studio to use
set VS_VERSION=2022

@REM Define the version of MSVC (Microsoft C++ compiler toolset) to use
set MSVC_VERSION=14.43.34808

@REM Set the root path of Visual Studio installation
set VS_ROOT_PATH=%BUILD_TOOLS_PATH%\MSVC\Microsoft Visual Studio\%VS_VERSION%\Community

@REM Set the root path of the Windows SDK
set WINDOWS_KITS_ROOT_PATH=%BUILD_TOOLS_PATH%\WindowsKits

@REM Define the specific version of the Windows SDK to use
set WINSDK_VERSION=10.0.22621.0

@REM Set INCLUDE paths for MSVC compiler and Windows SDK headers
set INCLUDE=%VS_ROOT_PATH%\VC\Tools\MSVC\%MSVC_VERSION%\include;%INCLUDE%
set INCLUDE=%WINDOWS_KITS_ROOT_PATH%\10\Include\%WINSDK_VERSION%\shared;%INCLUDE%
set INCLUDE=%WINDOWS_KITS_ROOT_PATH%\10\Include\%WINSDK_VERSION%\ucrt;%INCLUDE%
set INCLUDE=%WINDOWS_KITS_ROOT_PATH%\10\Include\%WINSDK_VERSION%\um;%INCLUDE%
set INCLUDE=%WINDOWS_KITS_ROOT_PATH%\10\Include\%WINSDK_VERSION%\winrt;%INCLUDE%

@REM Set LIB paths for MSVC compiler and Windows SDK libraries
set LIB=%VS_ROOT_PATH%\VC\Tools\MSVC\%MSVC_VERSION%\lib\x86;%LIB%
set LIB=%WINDOWS_KITS_ROOT_PATH%\10\Lib\%WINSDK_VERSION%\ucrt\x86;%LIB%
set LIB=%WINDOWS_KITS_ROOT_PATH%\10\Lib\%WINSDK_VERSION%\um\x86;%LIB%

@REM # Ensure C:\Windows and C:\Windows\system32 is included in the system PATH (for core system tools)
set PATH=C:\Windows;%PATH%
set PATH=C:\Windows\system32;%PATH%



@REM +-------------------------------+
@REM | Disable SSL certificate check |
@REM +-------------------------------+
%GIT_COMMAND% config --global http.sslVerify false


@REM +-------------------------------+
@REM | Disable CRLF auto-conversion  |
@REM +-------------------------------+
%GIT_COMMAND% config --global core.autocrlf false


@REM +-------------------------------+
@REM | Update submodule in root path |
@REM +-------------------------------+
%GIT_COMMAND% submodule update --init


@REM +--------------------------+
@REM | Update submodule in edk2 |
@REM +--------------------------+
cd edk2
%GIT_COMMAND% submodule update --init


@REM +--------------------------------------------------------------------+
@REM | Set environment variable of 'Visual Studio C++ Compiler and Tools' |
@REM +--------------------------------------------------------------------+
call "%VS_ROOT_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x86


@REM +-------------------------------------------------------------------------+
@REM | Rebuild basetools, it will not real rebuild basetools if it has rebuilt |
@REM +-------------------------------------------------------------------------+
edksetup.bat Rebuild