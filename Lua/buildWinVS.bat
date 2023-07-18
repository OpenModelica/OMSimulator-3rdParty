@echo off
REM run this on wsl using:
REM cmd.exe /C buildWinVS.bat VS15-Win64

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

IF EXIST "install\win\" RMDIR /S /Q install\win

CD lua-5.4.6\src
cl /MD /O2 /c /DLUA_BUILD_AS_DLL *.c
IF NOT ["%ERRORLEVEL%"]==["0"] GOTO fail
REN lua.obj lua.o
REN luac.obj luac.o
link /DLL /IMPLIB:lua.lib /OUT:lua.dll *.obj
link /OUT:lua.exe lua.o lua.lib
lib /OUT:lua.lib *.obj /NODEFAULTLIB:MSVCRT
link /OUT:luac.exe luac.o lua.lib
DEL *.o
DEL *.obj
CD ..\..

if not exist "install\win" MKDIR install\win
MOVE lua-5.4.6\src\*.exe install\win
MOVE lua-5.4.6\src\*.dll install\win
MOVE lua-5.4.6\src\*.lib install\win
MOVE lua-5.4.6\src\*.exp install\win

if not exist "install\win\include" MKDIR install\win\include
COPY lua-5.4.6\src\lauxlib.h install\win\include
COPY lua-5.4.6\src\lua.h install\win\include
COPY lua-5.4.6\src\lua.hpp install\win\include
COPY lua-5.4.6\src\luaconf.h install\win\include
COPY lua-5.4.6\src\lualib.h install\win\include

EXIT /B 0

:fail
ECHO 3rdParty/Lua failed!
EXIT /B 1
