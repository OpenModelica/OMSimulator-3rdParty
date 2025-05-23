cmake_minimum_required(VERSION 3.10)

project(imgui LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(IMGUI_SOURCES
    imgui.cpp
    imgui_demo.cpp
    imgui_draw.cpp
    imgui_tables.cpp
    imgui_widgets.cpp
    backends/imgui_impl_glfw.cpp
    backends/imgui_impl_opengl3.cpp
)

add_library(imgui STATIC)

target_sources(imgui PRIVATE ${IMGUI_SOURCES})

target_include_directories(imgui PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/backends)
target_link_libraries(imgui PRIVATE oms::3rd::GLFW)

# Link libraries based on the operating system
if (UNIX AND NOT APPLE)
    target_link_libraries(imgui PRIVATE GL)
elseif (APPLE)
    find_package(glfw3 REQUIRED)
    target_link_libraries(imgui PRIVATE OpenGL)
elseif (WIN32)
    target_link_libraries(imgui PRIVATE opengl32)
endif()
