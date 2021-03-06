SET OMS_VS_TARGET=%~1
IF ["%OMS_VS_TARGET%"]==["VS14-Win32"] SET OMS_VS_PLATFORM=32 && SET OMS_VS_VERSION="Visual Studio 14 2015"
IF ["%OMS_VS_TARGET%"]==["VS14-Win64"] SET OMS_VS_PLATFORM=64 && SET OMS_VS_VERSION="Visual Studio 14 2015 Win64"
IF ["%OMS_VS_TARGET%"]==["VS15-Win32"] SET OMS_VS_PLATFORM=32 && SET OMS_VS_VERSION="Visual Studio 15 2017"
IF ["%OMS_VS_TARGET%"]==["VS15-Win64"] SET OMS_VS_PLATFORM=64 && SET OMS_VS_VERSION="Visual Studio 15 2017 Win64"

IF NOT DEFINED OMS_VS_VERSION (
  ECHO No argument or unsupported argument given. Use one of the following VS version strings:
  ECHO   "VS14-Win32" for Visual Studio 14 2015
  ECHO   "VS14-Win64" for Visual Studio 14 2015 Win64
  ECHO   "VS15-Win32" for Visual Studio 15 2017
  ECHO   "VS15-Win64" for Visual Studio 15 2017 Win64
  GOTO fail
)

SET OMS_VS_TARGET
SET OMS_VS_VERSION
SET OMS_VS_PLATFORM
ECHO.

SET VSCMD_START_DIR="%CD%"

IF ["%OMS_VS_TARGET%"]==["VS14-Win32"] @CALL "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86
IF ["%OMS_VS_TARGET%"]==["VS14-Win64"] @CALL "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64
IF ["%OMS_VS_TARGET%"]==["VS15-Win32"] @CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
IF ["%OMS_VS_TARGET%"]==["VS15-Win64"] @CALL "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

IF EXIST "install\win\" RMDIR /S /Q install\win && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
IF EXIST "win32\bin.msvc\" RMDIR /S /Q win32\bin.msvc && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail

CD win32
cscript configure.js compiler=msvc prefix=$(MAKEDIR)\..\install\win debug=yes iconv=no
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
nmake /f Makefile.msvc install
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
CD..

IF EXIST "config.h" DEL config.h
IF EXIST "include\libxml\xmlversion.h" DEL include\libxml\xmlversion.h
IF EXIST "win32\Makefile" DEL win32\Makefile
IF EXIST "win32\config.msvc" DEL win32\config.msvc
IF EXIST "win32\bin.msvc\" RMDIR /S /Q win32\bin.msvc && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
IF EXIST "win32\int.a.dll.msvc\" RMDIR /S /Q win32\int.a.dll.msvc && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
IF EXIST "win32\int.a.msvc\" RMDIR /S /Q win32\int.a.msvc && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
IF EXIST "win32\int.msvc\" RMDIR /S /Q win32\int.msvc && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
IF EXIST "win32\int.utils.msvc\" RMDIR /S /Q win32\int.utils.msvc && IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail

EXIT /B 0

:fail
ECHO 3rdParty/libxml2 failed!
EXIT /B 1
