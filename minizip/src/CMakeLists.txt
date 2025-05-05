cmake_minimum_required(VERSION 3.14)
project(minizip)

set(MINIZIP_SOURCES ioapi.c
                    miniunz.c
                    minizip.c
                    unzip.c
                    zip.c)

if (WIN32)
    list(APPEND MINIZIP_SOURCES iowin32.c)
endif()

add_library(oms_minizip STATIC ${MINIZIP_SOURCES})

target_include_directories(oms_minizip PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
