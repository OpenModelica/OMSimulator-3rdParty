cd win32
cscript configure.js compiler=msvc prefix=$(MAKEDIR)\..\install\win debug=yes iconv=no
nmake /f Makefile.msvc install
cd..
