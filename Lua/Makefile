RM=rm -rf
MKDIR=mkdir -p

# ugly fix for macosx
detected_OS := $(shell uname -s)
ifeq ($(detected_OS),Darwin)
	LUA_TARGET := macosx
	INSTALL_DIR := install/mac
else ifeq (MINGW,$(findstring MINGW,$(detected_OS)))
	LUA_TARGET := mingw
	INSTALL_DIR := install/mingw
	EXE := .exe
else
	LUA_TARGET := linux
	INSTALL_DIR := install/linux
endif

.PHONY: Lua distclean

Lua:
	@echo
	@echo "# make Lua"
	@echo
	$(MAKE) -C lua-5.3.4 $(LUA_TARGET)
	$(RM) lua-5.3.4/src/*.o
	$(MKDIR) $(INSTALL_DIR)
	mv lua-5.3.4/src/liblua.a $(INSTALL_DIR)
	mv lua-5.3.4/src/lua$(EXE) $(INSTALL_DIR)
	mv lua-5.3.4/src/luac$(EXE) $(INSTALL_DIR)
	$(MKDIR) $(INSTALL_DIR)/include
	cp lua-5.3.4/src/lauxlib.h $(INSTALL_DIR)/include
	cp lua-5.3.4/src/lua.h $(INSTALL_DIR)/include
	cp lua-5.3.4/src/lua.hpp $(INSTALL_DIR)/include
	cp lua-5.3.4/src/luaconf.h $(INSTALL_DIR)/include
	cp lua-5.3.4/src/lualib.h $(INSTALL_DIR)/include

distclean:
	@echo
	@echo "# make distclean"
	@echo
	$(RM) $(INSTALL_DIR)
