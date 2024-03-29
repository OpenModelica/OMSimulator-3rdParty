# ------------------------------------------------------------------------
# Programmer(s): Cody J. Balos @ LLNL
# ------------------------------------------------------------------------
# SUNDIALS Copyright Start
# Copyright (c) 2002-2020, Lawrence Livermore National Security
# and Southern Methodist University.
# All rights reserved.
#
# See the top-level LICENSE and NOTICE files for details.
#
# SPDX-License-Identifier: BSD-3-Clause
# SUNDIALS Copyright End
# ------------------------------------------------------------------------
# CMakeLists.txt file for the F2003 SPTFQMR SUNLinearSolver object library
# ------------------------------------------------------------------------

set(sunlinsolsptfqmr_SOURCES fsunlinsol_sptfqmr_mod.f90 fsunlinsol_sptfqmr_mod.c)

if(SUNDIALS_BUILD_STATIC_LIBS)
  sundials_add_f2003_interface_library(sundials_fsunlinsolsptfqmr_mod_static STATIC_OBJECT
    ${sunlinsolsptfqmr_SOURCES}
  )
  add_dependencies(sundials_fsunlinsolsptfqmr_mod_static_obj sundials_fgeneric_static_obj)
  set_target_properties(sundials_fsunlinsolsptfqmr_mod_static
    PROPERTIES OUTPUT_NAME sundials_fsunlinsolsptfqmr_mod CLEAN_DIRECT_OUTPUT 1)
  install(TARGETS sundials_fsunlinsolsptfqmr_mod_static DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(SUNDIALS_BUILD_STATIC_LIBS)

if(SUNDIALS_BUILD_SHARED_LIBS)
  sundials_add_f2003_interface_library(sundials_fsunlinsolsptfqmr_mod_shared SHARED_OBJECT
    ${sunlinsolsptfqmr_SOURCES}
  )
  add_dependencies(sundials_fsunlinsolsptfqmr_mod_shared_obj sundials_fgeneric_shared_obj)
  set_target_properties(sundials_fsunlinsolsptfqmr_mod_shared
    PROPERTIES OUTPUT_NAME sundials_fsunlinsolsptfqmr_mod CLEAN_DIRECT_OUTPUT 1)
  set_target_properties(sundials_fsunlinsolsptfqmr_mod_shared
    PROPERTIES VERSION ${nveclib_VERSION} SOVERSION ${nveclib_SOVERSION})
  install(TARGETS sundials_fsunlinsolsptfqmr_mod_shared DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(SUNDIALS_BUILD_SHARED_LIBS)

message(STATUS "Added SUNLINSOL_SPTFQMR F2003 interface")
