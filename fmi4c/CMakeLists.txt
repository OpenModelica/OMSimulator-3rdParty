cmake_minimum_required(VERSION 3.15)
project(fmi4c C)
set(CMAKE_C_STANDARD 99)

include(CMakeDependentOption)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

option(FMI4C_BUILD_DOCUMENTATION "Build Doxygen documentation" OFF)
option(FMI4C_BUILD_TEST "Build test executable" OFF)
option(FMI4C_BUILD_SHARED "Build as shared library (DLL)" ON)
option(FMI4C_USE_SYSTEM_ZIP "Use system utilities for unzipping" ON)
option(FMI4C_USE_EXTERNAL_MINIZIP "Use minizip target provided by FMI4C_EXTERNAL_MINIZIP" OFF)
#this option is only enabled when FMI4C_USE_SYSTEM_ZIP=OFF
cmake_dependent_option(FMI4C_USE_INCLUDED_ZLIB "Use the included zlib (statically linked) even if a system version is available" OFF "NOT FMI4C_USE_SYSTEM_ZIP" OFF)

# Set default debug postfix
if (NOT CMAKE_DEBUG_POSTFIX)
    set(CMAKE_DEBUG_POSTFIX d)
endif()

if (FMI4C_BUILD_DOCUMENTATION)
    add_subdirectory(doc)
endif()

set(SRCFILES
    src/fmi4c.c
    src/fmi4c_utils.c
    3rdparty/ezxml/ezxml.c)

if (FMI4C_BUILD_SHARED)
    add_library(fmi4c SHARED ${SRCFILES})
else()
    add_library(fmi4c STATIC ${SRCFILES})
endif()

target_compile_definitions(fmi4c PUBLIC HAVE_MEMMOVE=1 EZXML_NOMMAP USE_FILE32API)
if (FMI4C_BUILD_SHARED)
    # Only set DLLEXPORT when producing the library, when consumed dllimport will be assumed
    target_compile_definitions(fmi4c PRIVATE FMI4C_DLLEXPORT)
else()
    # When using as a static library (on windows) FMI4C_STATIC must be defined, otherwise dllimport will be assumed
    target_compile_definitions(fmi4c PUBLIC FMI4C_STATIC)
    # Must use position independent code if intend to include static fmi4c lib into shared (dll) consumer
    set_target_properties(fmi4c PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()

target_include_directories(fmi4c
        PUBLIC
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
        "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/3rdparty>"
        "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
        PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}/src"
)

# Internal dependency (PRIVATE) on libdl on Linux
target_link_libraries(fmi4c PRIVATE ${CMAKE_DL_LIBS})

target_link_libraries(fmi4c PUBLIC oms::3rd::minizip)
target_compile_definitions(fmi4c PRIVATE FMI4C_WITH_MINIZIP)

if (FMI4C_BUILD_TEST)
    enable_testing()
    add_subdirectory(test)
    if (WIN32 AND FMI4C_BUILD_SHARED)
        # On Windows there is no RPATH, so fmi4c.dll must be copied to the test directory if test should be runnable from any directory
        add_custom_command(TARGET fmi4c POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:fmi4c> "${CMAKE_CURRENT_BINARY_DIR}/test")
    endif()
endif()


configure_package_config_file(cmake/config.cmake.in
        "${CMAKE_CURRENT_BINARY_DIR}/fmi4c-config.cmake"
        INSTALL_DESTINATION "${CMAKE_INSTALL_DATADIR}/fmi4c"
        NO_SET_AND_CHECK_MACRO)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/fmi4c-config.cmake"
        DESTINATION "${CMAKE_INSTALL_DATADIR}/fmi4c")

if(NOT FMI4C_USE_EXTERNAL_MINIZIP)
    install(TARGETS fmi4c EXPORT "fmi4c-targets")
endif()

install(DIRECTORY "include/" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
install(DIRECTORY "3rdparty/fmi" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")

if(NOT FMI4C_USE_EXTERNAL_MINIZIP)
    # If building a static library, also include the local static zlib if it was built
    if (NOT FMI4C_USE_SYSTEM_ZIP AND NOT FMI4C_BUILD_SHARED AND TARGET zlibstatic)
        install(TARGETS zlibstatic EXPORT "fmi4c-targets")
    endif()

    install(EXPORT "fmi4c-targets"
            NAMESPACE "fmi4c::"
            DESTINATION "${CMAKE_INSTALL_DATADIR}/fmi4c")
endif()
