cmake_minimum_required(VERSION 3.10)
project(tinyfd LANGUAGES C VERSION 3.18.2)

add_library(tinyfd STATIC tinyfiledialogs.c)
target_include_directories(tinyfd PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
