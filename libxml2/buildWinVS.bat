cd win32
rd /s/q install
rd /s/q win32/bin.msvc
cscript configure.js compiler=msvc prefix=$(MAKEDIR)\..\install\win debug=yes iconv=no
nmake /f Makefile.msvc install
cd..
