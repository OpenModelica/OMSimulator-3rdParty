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
# Every library here is added EXCLUDE_FROM_ALL, because in the OMSimulator build
# they are pulled in by whatever links them. Standalone there is no such
# consumer, so `cmake --build build` would happily build nothing at all. Give it
# a target that depends on every library this repository builds.
#
# The set is collected from the buildsystem rather than listed by hand, so that
# adding or dropping a dependency here does not need a matching edit in this
# file. Only real libraries are picked up: executables and utility targets that
# the vendored projects define for their own tools are not what we ship, and the
# header-only INTERFACE libraries (pugixml, CTPL, nlohmann/json and all of
# DCPLib) have nothing to compile in the first place. OBJECT libraries are left
# out as well - SUNDIALS defines one per module and links them into the static
# libraries below, so they get built either way and would only make the target
# list unreadable.
function(_oms_3rdparty_collect_libraries dir out_var)
  set(libraries "")

  get_property(targets DIRECTORY "${dir}" PROPERTY BUILDSYSTEM_TARGETS)
  foreach(target IN LISTS targets)
    get_target_property(type ${target} TYPE)
    if(type STREQUAL "STATIC_LIBRARY"
       OR type STREQUAL "SHARED_LIBRARY"
       OR type STREQUAL "MODULE_LIBRARY")
      list(APPEND libraries ${target})
    endif()
  endforeach()

  get_property(subdirs DIRECTORY "${dir}" PROPERTY SUBDIRECTORIES)
  foreach(subdir IN LISTS subdirs)
    _oms_3rdparty_collect_libraries("${subdir}" sublibraries)
    list(APPEND libraries ${sublibraries})
  endforeach()

  set(${out_var} "${libraries}" PARENT_SCOPE)
endfunction()

# Called from the bottom of CMakeLists.txt, once the targets exist.
macro(oms_3rdparty_add_build_all_target)
  _oms_3rdparty_collect_libraries("${CMAKE_CURRENT_SOURCE_DIR}" _oms_3rdparty_libraries)
  list(REMOVE_DUPLICATES _oms_3rdparty_libraries)
  list(SORT _oms_3rdparty_libraries)
  message(STATUS "##### 3rdParty standalone build targets: ${_oms_3rdparty_libraries}")

  add_custom_target(oms_3rdParty_all ALL)
  add_dependencies(oms_3rdParty_all ${_oms_3rdparty_libraries})
endmacro()
