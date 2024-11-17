#########################################################################
## Sundials
if(NOT OPENMODELICA_NEW_CMAKE_BUILD)
  option(SUNDIALS_BUILD_SHARED_LIBS "Build shared libraries" OFF)
  option(SUNDIALS_EXAMPLES_ENABLE_C "Build SUNDIALS C examples" OFF)
  add_subdirectory(sundials-5.4.0 EXCLUDE_FROM_ALL)

  ## Sundials thoughtfully has organized its headers cleanly in one include/ directory
  ## Take advantage of that to transitively provide the headers when an external target links to
  ## any one of the sundials' libs.
  add_library(sundials_interface INTERFACE)
  target_include_directories(sundials_interface INTERFACE ${sundials_SOURCE_DIR}/include/)
  ## The sundials_config.h files are generated in the build directory. Add it as an include dir.
  target_include_directories(sundials_interface INTERFACE ${sundials_BINARY_DIR}/include/)

  ## Add an interface lib for linking ot the static libs. This will transitively add
  ## DLINK_SUNDIALS_STATIC to anything that links to the static sundials libs.
  add_library(sundials_interface_static INTERFACE)
  target_link_libraries(sundials_interface_static INTERFACE sundials_interface)
  target_compile_definitions(sundials_interface_static INTERFACE LINK_SUNDIALS_STATIC)

  ## Now that the includes and defines are attached to a utility interface library (sundials_interface_static) link it
  ## to the sundials static libs so they can be found when the sundials lib is linked-to from an external lib.
  ### Note! It should have been enough for the scope here to be INTERFACE instead of PUBLIC. However,
  ### that does not seem to work. This should be fine anyway.
  target_link_libraries(sundials_cvode_static PUBLIC sundials_interface_static)
  target_link_libraries(sundials_kinsol_static PUBLIC sundials_interface_static)
endif()

add_library(oms::3rd::cvode ALIAS sundials_cvode_static)
add_library(oms::3rd::kinsol ALIAS sundials_kinsol_static)

#########################################################################
## zlib.
## Used by minizip and fmi4c. It should be added before them.
add_subdirectory(zlib EXCLUDE_FROM_ALL)
add_library(oms::3rd::zlib ALIAS zlibstatic)

#########################################################################
## minizip.
add_subdirectory(minizip EXCLUDE_FROM_ALL)
add_library(oms::3rd::minizip ALIAS oms_minizip)

#########################################################################
## fmi4c.
set(FMI4C_BUILD_SHARED OFF)
set(FMI4C_USE_SYSTEM_ZIP OFF)
set(FMI4C_USE_EXTERNAL_MINIZIP ON)
set(FMI4C_EXTERNAL_MINIZIP "oms::3rd::minizip" CACHE STRING "Defines an external target for minizip.")
add_subdirectory(fmi4c EXCLUDE_FROM_ALL)
add_library(oms::3rd::fmi4c ALIAS fmi4c)

#########################################################################
## Lua.
option(LUA_ENABLE_SHARED OFF)
add_subdirectory(Lua EXCLUDE_FROM_ALL)
add_library(oms::3rd::lua ALIAS lua_static)

#########################################################################
## PugiXml.
add_subdirectory(PugiXml EXCLUDE_FROM_ALL)
add_library(oms::3rd::pugixml::header ALIAS pugixml_header_only)

#########################################################################
## xerces
option(XERCES_BUILD_SHARED_LIBS OFF)
add_subdirectory(xerces EXCLUDE_FROM_ALL)
### xerces does not include the target directories by default, so we have to externally add the include directories
target_include_directories(xerces-c INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/xerces/src)
### Xerces_autoconf_config.hpp is generated at build directory and we have to include it
target_include_directories(xerces-c INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/xerces/src)
add_library(oms::3rd::xerces ALIAS xerces-c)

#########################################################################
## CTPL.
add_subdirectory(CTPL EXCLUDE_FROM_ALL)
add_library(oms::3rd::ctpl::header ALIAS ctpl_header_only)

#########################################################################
## Dear ImGui.
add_subdirectory(imgui EXCLUDE_FROM_ALL)
add_library(oms::3rd::imgui ALIAS imgui)
