RM=rm -rf
MKDIR=mkdir -p

.PHONY: Lua distclean

Lua:
	@echo
	@echo "# make Lua"
	@echo
	$(MAKE) -C lua-5.3.4 linux
	$(RM) lua-5.3.4/src/*.o
	$(MKDIR) install/linux
	mv lua-5.3.4/src/liblua.a install/linux
	mv lua-5.3.4/src/lua install/linux
	mv lua-5.3.4/src/luac install/linux
	$(MKDIR) install/linux/include
	cp lua-5.3.4/src/lauxlib.h install/linux/include
	cp lua-5.3.4/src/lua.h install/linux/include
	cp lua-5.3.4/src/lua.hpp install/linux/include
	cp lua-5.3.4/src/luaconf.h install/linux/include
	cp lua-5.3.4/src/lualib.h install/linux/include

distclean:
	@echo
	@echo "# make distclean"
	@echo
	$(RM) install/linux
