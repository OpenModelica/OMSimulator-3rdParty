

add_library(oms_regex STATIC)
target_sources(oms_regex PRIVATE OMSRegEx.cpp)

target_include_directories(oms_regex INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
