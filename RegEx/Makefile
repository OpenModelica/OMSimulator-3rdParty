
# on mingw and clang, add exe extension, clang doesn't add it by default
ifeq (MINGW,$(findstring MINGW,$(shell uname)))
ifeq (clang++,$(findstring clang++,$(CXX)))
	EXT=.exe
endif
endif

RegEx:
	$(CXX) -std=c++11 -o OMSRegEx$(EXT) OMSRegEx.cpp

