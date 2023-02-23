cmake_minimum_required(VERSION 2.8.9)
project(minizip)

IF(WIN32 AND MSVC)
  set(PLATFORM_STRING "win")
ELSEIF(WIN32 AND MINGW)
  set(PLATFORM_STRING "mingw")
ELSEIF(APPLE)
  set(PLATFORM_STRING "mac")
ELSE()
  set(PLATFORM_STRING "linux")
ENDIF()

include_directories(../install/${PLATFORM_STRING}/include/)

list(APPEND MINIZIP_SOURCES ioapi.c)
list(APPEND MINIZIP_SOURCES miniunz.c)
list(APPEND MINIZIP_SOURCES minizip.c)
list(APPEND MINIZIP_SOURCES unzip.c)
list(APPEND MINIZIP_SOURCES zip.c)

if (WIN32)
    list(APPEND MINIZIP_SOURCES iowin32.c)
endif()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
add_library(minizip STATIC ${MINIZIP_SOURCES})

install(TARGETS minizip DESTINATION lib/)
install(FILES minizip.h miniunz.h DESTINATION include/)
