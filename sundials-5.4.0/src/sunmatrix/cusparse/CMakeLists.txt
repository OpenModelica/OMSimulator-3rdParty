# ---------------------------------------------------------------
# Programmer(s): Cody J. Balos @ LLNL
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
# CMakeLists.txt file for the CUDA cuSPARSE SUNMatrix
# ---------------------------------------------------------------

# install(CODE "MESSAGE(\"\nInstall SUNMATRIX_CUSPARSE\n\")")

# Add variable cusparse_SOURCES with the sources for the cusparse lib
set(cusparse_SOURCES
  sunmatrix_cusparse.cu
  )

# Add variable shared_SOURCES with the common SUNDIALS sources which will
# also be included in the NVECCUDA library
set(shared_SOURCES
  ${sundials_SOURCE_DIR}/src/sundials/sundials_matrix.c
  ${sundials_SOURCE_DIR}/src/sunmemory/cuda/sundials_cuda_memory.cu
  )

# Add variable cusparse_HEADERS with the exported cusparse header files
set(cusparse_HEADERS
  ${sundials_SOURCE_DIR}/include/sunmatrix/sunmatrix_cusparse.h
  ${sundials_SOURCE_DIR}/include/sunmemory/sunmemory_cuda.h
  )

# Define C preprocessor flag -DBUILD_SUNDIALS_LIBRARY
add_definitions(-DBUILD_SUNDIALS_LIBRARY)

if(SUNDIALS_BUILD_STATIC_LIBS)
  add_library(sundials_sunmatrixcusparse_static STATIC ${cusparse_SOURCES} ${shared_SOURCES})
  target_link_libraries(sundials_sunmatrixcusparse_static
                        PUBLIC
                        sundials_nveccuda_static
                        ${CUDA_cusparse_LIBRARY}
                        PRIVATE
                        ${CUDA_cusolver_LIBRARY})
  target_include_directories(sundials_sunmatrixcusparse_static
                             PRIVATE . ${sundials_SOURCE_DIR}/src/sundials)
  set_target_properties(sundials_sunmatrixcusparse_static PROPERTIES
                        OUTPUT_NAME sundials_sunmatrixcusparse
                        CLEAN_DIRECT_OUTPUT 1)
  install(TARGETS sundials_sunmatrixcusparse_static DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(SUNDIALS_BUILD_STATIC_LIBS)

if(SUNDIALS_BUILD_SHARED_LIBS)
  add_library(sundials_sunmatrixcusparse_shared SHARED ${cusparse_SOURCES} ${shared_SOURCES})
  target_link_libraries(sundials_sunmatrixcusparse_shared
                        PUBLIC
                        sundials_nveccuda_shared
                        ${CUDA_cusparse_LIBRARY}
                        PRIVATE
                        ${CUDA_cusolver_LIBRARY})
  target_include_directories(sundials_sunmatrixcusparse_shared
                             PRIVATE . ${sundials_SOURCE_DIR}/src/sundials)
  set_target_properties(sundials_sunmatrixcusparse_shared PROPERTIES
                        OUTPUT_NAME sundials_sunmatrixcusparse
                        CLEAN_DIRECT_OUTPUT 1
                        VERSION ${sunmatrixlib_VERSION}
                        SOVERSION ${sunmatrixlib_SOVERSION})
  install(TARGETS sundials_sunmatrixcusparse_shared DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(SUNDIALS_BUILD_SHARED_LIBS)

# Install the CUDA NVector header files
install(FILES ${cusparse_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/sunmatrix)

#
message(STATUS "Added SUNMATRIX_CUSPARSE module")
