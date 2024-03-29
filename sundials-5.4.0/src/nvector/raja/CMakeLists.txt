# ---------------------------------------------------------------
# Programmer(s): Slaven Peles and Cody J. Balos @ LLNL
# ---------------------------------------------------------------
# SUNDIALS Copyright Start
# Copyright (c) 2002-2020, Lawrence Livermore National Security
# and Southern Methodist University.
# All rights reserved.
#
# See the top-level LICENSE and NOTICE files for details.
#
# SPDX-License-Identifier: BSD-3-Clause
# SUNDIALS Copyright End
# ---------------------------------------------------------------
# CMakeLists.txt file for the RAJA NVECTOR library
# ---------------------------------------------------------------

# install(CODE "MESSAGE(\"\nInstall NVECTOR_RAJA\n\")")

# Add variable nvecraja_SOURCES with the sources for the NVECRAJA lib
set(nvecraja_SOURCES
  nvector_raja.cu
)

# Add variable shared_SOURCES with the common SUNDIALS sources which will
# also be included in the NVECRAJA library
set(shared_SOURCES
  ${PROJECT_SOURCE_DIR}/src/sundials/sundials_nvector.c
  ${PROJECT_SOURCE_DIR}/src/sundials/sundials_math.c
  ${PROJECT_SOURCE_DIR}/src/sundials/sundials_memory.c
  ${PROJECT_SOURCE_DIR}/src/sunmemory/cuda/sundials_cuda_memory.cu
)

# Add variable nvecraja_HEADERS with the exported NVECRAJA header files
set(nvecraja_HEADERS
  ${PROJECT_SOURCE_DIR}/include/nvector/nvector_raja.h
  ${PROJECT_SOURCE_DIR}/include/sunmemory/sunmemory_cuda.h
  )

# Define C preprocessor flag -DBUILD_SUNDIALS_LIBRARY
add_definitions(-DBUILD_SUNDIALS_LIBRARY)

# Rules for building and installing the static library:
#  - Add the build target for the NVECRAJA library
#  - Set the library name and make sure it is not deleted
#  - Install the NVECRAJA library
if(SUNDIALS_BUILD_STATIC_LIBS)
  add_library(sundials_nveccudaraja_static STATIC ${nvecraja_SOURCES} ${shared_SOURCES})
  target_compile_features(sundials_nveccudaraja_static PUBLIC cxx_std_11)
  target_compile_options(sundials_nveccudaraja_static PUBLIC
    $<$<COMPILE_LANGUAGE:CUDA>:--expt-extended-lambda>)
  target_link_libraries(sundials_nveccudaraja_static PUBLIC RAJA)
  target_include_directories(sundials_nveccudaraja_static PRIVATE . ${PROJECT_SOURCE_DIR}/src/sundials)
  set_target_properties(sundials_nveccudaraja_static PROPERTIES
                        OUTPUT_NAME sundials_nveccudaraja
                        CLEAN_DIRECT_OUTPUT 1)
  install(TARGETS sundials_nveccudaraja_static DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(SUNDIALS_BUILD_STATIC_LIBS)

# Rules for building and installing the shared library:
#  - Add the build target for the NVECRAJA library
#  - Set the library name and make sure it is not deleted
#  - Set VERSION and SOVERSION for shared libraries
#  - Install the NVECRAJA library
if(SUNDIALS_BUILD_SHARED_LIBS)
  add_library(sundials_nveccudaraja_shared SHARED ${nvecraja_SOURCES} ${shared_SOURCES})
  target_compile_features(sundials_nveccudaraja_shared PUBLIC cxx_std_11)
  target_compile_options(sundials_nveccudaraja_shared PUBLIC
    $<$<COMPILE_LANGUAGE:CUDA>:--expt-extended-lambda>)
  target_link_libraries(sundials_nveccudaraja_shared PUBLIC RAJA)
  target_include_directories(sundials_nveccudaraja_shared PRIVATE . ${PROJECT_SOURCE_DIR}/src/sundials)
  set_target_properties(sundials_nveccudaraja_shared PROPERTIES
                        OUTPUT_NAME sundials_nveccudaraja
                        CLEAN_DIRECT_OUTPUT 1
                        VERSION ${nveclib_VERSION}
                        SOVERSION ${nveclib_SOVERSION})
  install(TARGETS sundials_nveccudaraja_shared DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(SUNDIALS_BUILD_SHARED_LIBS)

# Install the NVECRAJA header files
install(FILES ${nvecraja_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/nvector)
install(FILES ${PROJECT_SOURCE_DIR}/include/sunmemory/sunmemory_cuda.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/sunmemory)

message(STATUS "Added NVECTOR_RAJA module")
