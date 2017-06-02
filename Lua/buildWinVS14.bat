@echo off

@call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86_amd64

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
