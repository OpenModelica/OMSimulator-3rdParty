@echo off
REM run this on wsl using:
REM cmd.exe /C buildWinVS.bat VS15-Win64

if ["%~1"]==["VS14-Win64"] SET OMS_VS_VERSION="Visual Studio 14 2015 Win64"
if ["%~1"]==["VS14-Win32"] SET OMS_VS_VERSION="Visual Studio 14 2015"
if ["%~1"]==["VS15-Win64"] SET OMS_VS_VERSION="Visual Studio 15 2017 Win64"

REM exit if no VS version could be recognized
IF NOT DEFINED OMS_VS_VERSION (
	echo No argument or unsupported argument given. Supported: VS14-Win64, VS14-Win32, VS15-WIN64
	echo Default to "Visual Studio 14 2015 Win64".
	pause
	SET OMS_VS_VERSION="Visual Studio 14 2015 Win64"
)

echo Using %OMS_VS_VERSION%

SET "VSCMD_START_DIR=%CD%"
if ["%~1"]==["VS14-Win64"] @call "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86_amd64 8.1
if ["%~1"]==["VS14-Win32"] @call "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" x86
if ["%~1"]==["VS15-Win64"] @call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

cd lua-5.3.4\src
cl /MD /O2 /c /DLUA_BUILD_AS_DLL *.c
ren lua.obj lua.o
ren luac.obj luac.o
link /DLL /IMPLIB:lua.lib /OUT:lua.dll *.obj
link /OUT:lua.exe lua.o lua.lib
lib /OUT:lua.lib *.obj /NODEFAULTLIB:MSVCRT
link /OUT:luac.exe luac.o lua.lib
DEL *.o
DEL *.obj
cd ..\..

if not exist "install\win" MKDIR install\win
MOVE lua-5.3.4\src\*.exe install\win
MOVE lua-5.3.4\src\*.dll install\win
MOVE lua-5.3.4\src\*.lib install\win
MOVE lua-5.3.4\src\*.exp install\win

if not exist "install\win\include" MKDIR install\win\include
COPY lua-5.3.4\src\lauxlib.h install\win\include
COPY lua-5.3.4\src\lua.h install\win\include
COPY lua-5.3.4\src\lua.hpp install\win\include
COPY lua-5.3.4\src\luaconf.h install\win\include
COPY lua-5.3.4\src\lualib.h install\win\include
