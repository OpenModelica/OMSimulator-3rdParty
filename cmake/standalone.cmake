# Bootstrap for building OMSimulator-3rdParty on its own.
#
# This directory is normally added as a subdirectory of the OMSimulator
# project, which sets up a number of things before it that are not part of this
# repository. This file provides the minimum needed so that
#
#   cmake -S . -B build && cmake --build build -j$(nproc)
#
# works standalone, which is what .github/workflows/build.yml uses to build-test
# this repository.
#
# It is included from CMakeLists.txt ONLY when this directory is the top of the
# build, so nothing here can change how OMSimulator itself is configured.
# include() does not open a new scope, so the options and settings below land in
# the caller exactly as OMSimulator would have provided them.

# --- from OMSimulator/CMakeLists.txt ---------------------------------------
# OPENMODELICA_NEW_CMAKE_BUILD is deliberately left undefined: standalone we are
# not part of the OpenModelica superproject, so 3rdParty configures its own
# SUNDIALS, exactly like a standalone OMSimulator build does.
option(OMS_ENABLE_OMSimulatorGui "Enable OMSimulator GUI component" OFF)

set(CMAKE_CXX_STANDARD 17)
set(CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_definitions(-DNOMINMAX)

# --- from OMSimulator/config.cmake/OMSimulatorTopLevelSettings.cmake -------
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(GNUInstallDirs)
set(CMAKE_INSTALL_LIBDIR "${CMAKE_INSTALL_LIBDIR}/${CMAKE_LIBRARY_ARCHITECTURE}")

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/install_cmake" CACHE PATH "Default installation directory" FORCE)
  set(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT FALSE)
endif()

if("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
  message(FATAL_ERROR "No in-source builds supported. Change to 'build' sub-directory and do 'cmake ..'.")
endif()

# --- the default build target ----------------------------------------------
# Every library here is added EXCLUDE_FROM_ALL.  Give it a target that depends
# on the whole set this repository exists to provide.
#
# Called from the bottom of CMakeLists.txt, once the targets exist. Only the
# ones that produce artifacts are listed; the header-only INTERFACE libraries
# (pugixml, CTPL, nlohmann/json) have nothing to compile.
macro(oms_3rdparty_add_build_all_target)
  add_custom_target(oms_3rdParty_all ALL)
  add_dependencies(oms_3rdParty_all
    sundials_cvode_static
    sundials_kinsol_static
    zlibstatic
    oms_minizip
    fmi4c
    lua_static
    xerces-c
    zip
    Core
    Master
    Slave
    Ethernet
    Zip
    Xml)

  if(OMS_ENABLE_OMSimulatorGui)
    add_dependencies(oms_3rdParty_all imgui glfw tinyfd)
  endif()
endmacro()
