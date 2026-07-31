#########################################################################
## Sundials
message(STATUS "##### 3rdParty Sundials")
if(NOT OPENMODELICA_NEW_CMAKE_BUILD)
  # SUNDIALS (LLNL/sundials, submodule pinned to v7.8.0)
  # The patched 5.4.0 source copy was replaced by a pristine submodule, so
  # everything we used to patch into those sources is configured from here. Keep
  # this in sync with OpenModelica's OMCompiler/3rdParty/CMakeLists.txt: in the
  # integrated build (OPENMODELICA_NEW_CMAKE_BUILD) OMSimulator links the
  # SUNDIALS that OMC configured there, so the two have to agree.

  # Static only, like the rest of 3rdParty.
  set(BUILD_STATIC_LIBS ON CACHE BOOL "Build SUNDIALS static libraries" FORCE)
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build SUNDIALS shared libraries" FORCE)

  # OMSimulator only uses CVODE (SystemSC/SystemSC3) and KINSOL (AlgLoop), both
  # with the dense linear solver. No ARKODE/CVODES/IDA/IDAS, and no KLU - unlike
  # OMC we have no SuiteSparse in 3rdParty to build it against.
  set(SUNDIALS_ENABLE_CVODE ON CACHE BOOL "Enable the CVODE library" FORCE)
  set(SUNDIALS_ENABLE_KINSOL ON CACHE BOOL "Enable the KINSOL library" FORCE)
  set(SUNDIALS_ENABLE_ARKODE OFF CACHE BOOL "Enable the ARKODE library" FORCE)
  set(SUNDIALS_ENABLE_CVODES OFF CACHE BOOL "Enable the CVODES library" FORCE)
  set(SUNDIALS_ENABLE_IDA OFF CACHE BOOL "Enable the IDA library" FORCE)
  set(SUNDIALS_ENABLE_IDAS OFF CACHE BOOL "Enable the IDAS library" FORCE)
  set(SUNDIALS_ENABLE_KLU OFF CACHE BOOL "Enable KLU support" FORCE)
  set(SUNDIALS_ENABLE_LAPACK OFF CACHE BOOL "Enable LAPACK support" FORCE)

  # Doubles and a 64 bit sunindextype, matching OMC's settings.
  set(SUNDIALS_PRECISION "DOUBLE" CACHE STRING "SUNDIALS floating point precision" FORCE)
  set(SUNDIALS_INDEX_SIZE "64" CACHE STRING "SUNDIALS sunindextype size in bits" FORCE)

  # We use the C interfaces only, and want neither examples, benchmarks nor tests.
  set(SUNDIALS_ENABLE_FORTRAN OFF CACHE BOOL "Enable SUNDIALS Fortran interfaces" FORCE)
  set(SUNDIALS_ENABLE_C_EXAMPLES OFF CACHE BOOL "Build SUNDIALS C examples" FORCE)
  set(SUNDIALS_ENABLE_CXX_EXAMPLES OFF CACHE BOOL "Build SUNDIALS C++ examples" FORCE)
  set(SUNDIALS_ENABLE_EXAMPLES_INSTALL OFF CACHE BOOL "Install SUNDIALS examples" FORCE)
  set(SUNDIALS_ENABLE_BENCHMARKS OFF CACHE BOOL "Enable the SUNDIALS benchmark suite" FORCE)
  set(SUNDIALS_TEST_ENABLE_UNIT_TESTS OFF CACHE BOOL "Enable SUNDIALS unit tests" FORCE)

  # Upstream turns the extensive error checks on by default for Debug builds (and
  # warns about the performance hit while configuring). Keep SUNDIALS behaving the
  # same way in all build types.
  set(SUNDIALS_ENABLE_ERROR_CHECKS OFF CACHE BOOL "Enable SUNDIALS error checking" FORCE)

  add_subdirectory(sundials EXCLUDE_FROM_ALL)

  # SUNDIALS declares CMAKE_C_STANDARD and CMAKE_C_EXTENSIONS as *cache* variables
  # (cmake/SundialsSetupCompilers.cmake) - and the cache is global, not scoped to
  # the subdirectory - so configuring it would otherwise drag every C library
  # that comes after it (minizip, lua, ...) down to C99 as well. SUNDIALS' own
  # targets already captured the standard when they were created above, so
  # dropping the cache entries here only affects what follows.
  unset(CMAKE_C_STANDARD CACHE)
  unset(CMAKE_C_EXTENSIONS CACHE)
endif()

## Add aliases for the static libs. For readability.
## Linking one of these already provides the SUNDIALS include directories and the
## SUNDIALS_STATIC_DEFINE compile definition transitively - sundials_add_library()
## attaches both as PUBLIC usage requirements - so unlike with 5.4.0 we do not
## need an interface library of our own on top.

add_library(oms::3rd::sundials::cvode ALIAS sundials_cvode_static)
add_library(oms::3rd::sundials::kinsol ALIAS sundials_kinsol_static)

#########################################################################
## zlib.
message(STATUS "##### 3rdParty zlib")
set(ZLIB_BUILD_SHARED OFF CACHE BOOL "Disable zlib shared library")
set(ZLIB_BUILD_TESTING OFF CACHE BOOL "Disable zlib's own test suite; it registers global ctest targets (zlib_install, zlib_find_package_*, ...) that don't apply when zlib is only vendored as a static-lib dependency")
add_subdirectory(zlib EXCLUDE_FROM_ALL)
add_library(oms::3rd::zlib ALIAS zlibstatic)
# Expose zlibstatic as ZLIB::ZLIB so libzip's find_package(ZLIB) resolves to our
# in-tree build without requiring a system zlib (e.g. Alpine, Windows).
add_library(ZLIB::ZLIB ALIAS zlibstatic)
set(ZLIB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/zlib" CACHE PATH "" FORCE)
set(ZLIB_LIBRARY "zlibstatic" CACHE STRING "" FORCE)

#########################################################################
## minizip.
message(STATUS "##### 3rdParty minizip")
add_subdirectory(minizip EXCLUDE_FROM_ALL)
add_library(oms::3rd::minizip ALIAS oms_minizip)

#########################################################################
## fmi4c.
message(STATUS "##### 3rdParty fmi4c")
set(FMI4C_BUILD_SHARED OFF)
set(FMI4C_USE_SYSTEM_ZIP OFF)
set(FMI4C_USE_EXTERNAL_MINIZIP ON)
set(FMI4C_EXTERNAL_MINIZIP "oms::3rd::minizip" CACHE STRING "Defines an external target for minizip.")
add_subdirectory(fmi4c EXCLUDE_FROM_ALL)
add_library(oms::3rd::fmi4c ALIAS fmi4c)

#########################################################################
## Lua.
message(STATUS "##### 3rdParty Lua")
option(LUA_ENABLE_SHARED OFF)
add_subdirectory(Lua EXCLUDE_FROM_ALL)
add_library(oms::3rd::lua ALIAS lua_static)

#########################################################################
## PugiXml.
message(STATUS "##### 3rdParty PugiXml")
add_subdirectory(PugiXml EXCLUDE_FROM_ALL)
add_library(oms::3rd::pugixml::header ALIAS pugixml_header_only)

#########################################################################
## xerces
message(STATUS "##### 3rdParty xerces")
option(XERCES_BUILD_SHARED_LIBS OFF)
add_subdirectory(xerces EXCLUDE_FROM_ALL)
### xerces does not include the target directories by default, so we have to externally add the include directories
target_include_directories(xerces-c INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/xerces/src)
### Xerces_autoconf_config.hpp is generated at build directory and we have to include it
target_include_directories(xerces-c INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/xerces/src)
add_library(oms::3rd::xerces ALIAS xerces-c)

#########################################################################
## CTPL.
message(STATUS "##### 3rdParty CTPL")
add_subdirectory(CTPL EXCLUDE_FROM_ALL)
add_library(oms::3rd::ctpl::header ALIAS ctpl_header_only)

#########################################################################
## Dear ImGui.
if (OMS_ENABLE_OMSimulatorGui)
  message(STATUS "##### 3rdParty Dear ImGui")
  add_subdirectory(imgui EXCLUDE_FROM_ALL)
  add_library(oms::3rd::imgui ALIAS imgui)
endif ()

#########################################################################
## GLFW.
if (OMS_ENABLE_OMSimulatorGui)
  message(STATUS "##### 3rdParty GLFW")
  set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
  set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
  set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
  set(GLFW_BUILD_WAYLAND OFF CACHE BOOL "" FORCE)

  add_subdirectory(glfw EXCLUDE_FROM_ALL)
  add_library(oms::3rd::GLFW ALIAS glfw)
endif ()

#########################################################################
## tinyfiledialogs.
if (OMS_ENABLE_OMSimulatorGui)
  message(STATUS "##### 3rdParty tinyfiledialogs")
  add_subdirectory(tinyfd EXCLUDE_FROM_ALL)
  add_library(oms::3rd::tinyfd ALIAS tinyfd)
endif ()

#########################################################################
## nlohmann/json
message(STATUS "##### 3rdParty nlohmann/json")
add_subdirectory(json EXCLUDE_FROM_ALL)
add_library(oms::3rd::json::header ALIAS json_header_only)

#########################################################################
## libzip.
message(STATUS "##### 3rdParty libzip")
set(BUILD_REGRESS OFF CACHE BOOL "Disable regression tests")
set(BUILD_OSSFUZZ OFF CACHE BOOL "Disable fuzzers for ossfuzz")
set(BUILD_EXAMPLES OFF CACHE BOOL "Disable examples")
set(BUILD_DOC OFF CACHE BOOL "Disable documentation")
set(BUILD_TOOLS OFF CACHE BOOL "Disable zipcmp, zipmerge, ziptool binaries")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Build zip as a static library")
set(SHARED_LIB_VERSIONNING OFF CACHE BOOL "Disable SO versioning")
set(LIBZIP_DO_INSTALL OFF CACHE BOOL "Install libzip and the related files" FORCE)
set(ENABLE_OPENSSL OFF CACHE BOOL "Disable OpenSSL (not needed for FMUs)")
set(ENABLE_COMMONCRYPTO OFF CACHE BOOL "Disable CommonCrypto (not needed for FMUs)")
set(ENABLE_GNUTLS OFF CACHE BOOL "Disable GnuTLS (not needed for FMUs)")
set(ENABLE_MBEDTLS OFF CACHE BOOL "Disable mbed TLS (not needed for FMUs)")
set(ENABLE_WINDOWS_CRYPTO OFF CACHE BOOL "Disable Windows Crypto (not needed for FMUs)")
set(ENABLE_BZIP2 OFF CACHE BOOL "Disable BZip2 (not used in FMUs)")
set(ENABLE_LZMA OFF CACHE BOOL "Disable LZMA (not used in FMUs)")
set(ENABLE_ZSTD OFF CACHE BOOL "Disable Zstandard (not used in FMUs)")
add_subdirectory(libzip EXCLUDE_FROM_ALL)
add_library(oms::3rd::libzip ALIAS zip)

#########################################################################
## DCPLib.
message(STATUS "##### 3rdParty DCPLib")
set(DCPLIB_USE_EXTERNAL_XERCES ON CACHE BOOL "")
set(DCPLIB_USE_EXTERNAL_ZIP ON CACHE BOOL "")
set(DCPLIB_EXTERNAL_XERCES "oms::3rd::xerces" CACHE STRING "Defines an external target for xerces.")
set(DCPLIB_EXTERNAL_ZIP "oms::3rd::libzip" CACHE STRING "Defines an external target for libzip.")
add_subdirectory(DCPLib EXCLUDE_FROM_ALL)
add_library(oms::3rd::dcplib::core ALIAS Core)
add_library(oms::3rd::dcplib::master ALIAS Master)
add_library(oms::3rd::dcplib::slave ALIAS Slave)
add_library(oms::3rd::dcplib::ethernet ALIAS Ethernet)
add_library(oms::3rd::dcplib::zip ALIAS Zip)
add_library(oms::3rd::dcplib::xml ALIAS Xml)
