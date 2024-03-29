# ---------------------------------------------------------------
# Programmer(s): Daniel R. Reynolds @ SMU
#                Radu Serban @ LLNL
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
# CMakeLists.txt file for the IDAS library
# ---------------------------------------------------------------

# install(CODE "MESSAGE(\"\nInstall IDAS\n\")")

# Add F90 module if F2003 interface is enabled
if(F2003_FOUND AND F2003_INTERFACE_ENABLE)
  add_subdirectory(fmod)
endif(F2003_FOUND AND F2003_INTERFACE_ENABLE)

# Add variable idas_SOURCES with the sources for the IDAS library
set(idas_SOURCES
  idas.c
  idaa.c
  idas_direct.c
  idas_io.c
  idas_ic.c
  idaa_io.c
  idas_ls.c
  idas_bbdpre.c
  idas_nls.c
  idas_nls_sim.c
  idas_nls_stg.c
  idas_spils.c
  )

# Add variable shared_SOURCES with the common SUNDIALS sources which will
# also be included in the IDAS library
set(shared_SOURCES
  ${sundials_SOURCE_DIR}/src/sundials/sundials_nvector.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_matrix.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_linearsolver.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_nonlinearsolver.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_math.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_band.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_dense.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_direct.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_iterative.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_version.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_nvector_senswrapper.c
  ${sundials_SOURCE_DIR}/src/sundials/sundials_futils.c
  ${sundials_SOURCE_DIR}/src/nvector/serial/nvector_serial.c
  )

# Add variable sunmatrix_SOURCES with the common SUNMatrix sources which will
# also be included in the IDAS library
set(sunmatrix_SOURCES
  ${sundials_SOURCE_DIR}/src/sunmatrix/band/sunmatrix_band.c
  ${sundials_SOURCE_DIR}/src/sunmatrix/dense/sunmatrix_dense.c
  ${sundials_SOURCE_DIR}/src/sunmatrix/sparse/sunmatrix_sparse.c
  )

# Add variable sunlinsol_SOURCES with the common SUNLinearSolver sources which will
# also be included in the IDAS library
set(sunlinsol_SOURCES
  ${sundials_SOURCE_DIR}/src/sunlinsol/band/sunlinsol_band.c
  ${sundials_SOURCE_DIR}/src/sunlinsol/dense/sunlinsol_dense.c
  ${sundials_SOURCE_DIR}/src/sunlinsol/spbcgs/sunlinsol_spbcgs.c
  ${sundials_SOURCE_DIR}/src/sunlinsol/spfgmr/sunlinsol_spfgmr.c
  ${sundials_SOURCE_DIR}/src/sunlinsol/spgmr/sunlinsol_spgmr.c
  ${sundials_SOURCE_DIR}/src/sunlinsol/sptfqmr/sunlinsol_sptfqmr.c
  ${sundials_SOURCE_DIR}/src/sunlinsol/pcg/sunlinsol_pcg.c
  )

# Add variable sunnonlinsol_SOURCES with the common SUNNonlinearSolver sources
# which will also be included in the IDAS library
set(sunnonlinsol_SOURCES
  ${sundials_SOURCE_DIR}/src/sunnonlinsol/newton/sunnonlinsol_newton.c
  ${sundials_SOURCE_DIR}/src/sunnonlinsol/fixedpoint/sunnonlinsol_fixedpoint.c
  )

# Add variable idas_HEADERS with the exported IDAS header files
set(idas_HEADERS
  idas.h
  idas_bbdpre.h
  idas_direct.h
  idas_ls.h
  idas_spils.h
  )

# Add prefix with complete path to the IDAS header files
add_prefix(${sundials_SOURCE_DIR}/include/idas/ idas_HEADERS)

# Add source directories to include directories for access to
# implementation only header files.
include_directories(. ${sundials_SOURCE_DIR}/src/sundials)

# Define C preprocessor flag -DBUILD_SUNDIALS_LIBRARY
add_definitions(-DBUILD_SUNDIALS_LIBRARY)

# Build the static library
if(SUNDIALS_BUILD_STATIC_LIBS)

  # Add the build target for the static IDAS library
  add_library(sundials_idas_static STATIC
    ${idas_SOURCES} ${shared_SOURCES} ${sunmatrix_SOURCES} ${sunlinsol_SOURCES}
    ${sunnonlinsol_SOURCES})

  # Set the library name and make sure it is not deleted
  set_target_properties(sundials_idas_static
    PROPERTIES OUTPUT_NAME sundials_idas CLEAN_DIRECT_OUTPUT 1)

  # Install the IDA library
  install(TARGETS sundials_idas_static DESTINATION ${CMAKE_INSTALL_LIBDIR})

endif(SUNDIALS_BUILD_STATIC_LIBS)

# Build the shared library
if(SUNDIALS_BUILD_SHARED_LIBS)

  # Add the build target for the IDAS library
  add_library(sundials_idas_shared SHARED
    ${idas_SOURCES} ${shared_SOURCES} ${sunmatrix_SOURCES} ${sunlinsol_SOURCES}
    ${sunnonlinsol_SOURCES})

  if(UNIX)
    target_link_libraries(sundials_idas_shared m)
  endif()

  # Set the library name and make sure it is not deleted
  set_target_properties(sundials_idas_shared
    PROPERTIES OUTPUT_NAME sundials_idas CLEAN_DIRECT_OUTPUT 1)

  # Set VERSION and SOVERSION for shared libraries
  set_target_properties(sundials_idas_shared
    PROPERTIES VERSION ${idaslib_VERSION} SOVERSION ${idaslib_SOVERSION})

  # Install the IDAS library
  install(TARGETS sundials_idas_shared DESTINATION ${CMAKE_INSTALL_LIBDIR})

endif(SUNDIALS_BUILD_SHARED_LIBS)

# Install the IDAS header files
install(FILES ${idas_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/idas)

#
message(STATUS "Added IDAS module")
