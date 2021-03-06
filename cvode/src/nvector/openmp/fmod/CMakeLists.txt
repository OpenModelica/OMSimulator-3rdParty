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
# CMakeLists.txt file for the F2003 openmp NVECTOR object library
# ---------------------------------------------------------------

set(nvecopenmp_SOURCES fnvector_openmp_mod.f90 fnvector_openmp_mod.c)

if(BUILD_STATIC_LIBS)
  sundials_add_f2003_interface_library(sundials_fnvecopenmp_mod_static STATIC_OBJECT
    ${nvecopenmp_SOURCES}
  )
  add_dependencies(sundials_fnvecopenmp_mod_static_obj sundials_fgeneric_static_obj)
  set_target_properties(sundials_fnvecopenmp_mod_static
    PROPERTIES OUTPUT_NAME sundials_fnvecopenmp_mod CLEAN_DIRECT_OUTPUT 1)
  install(TARGETS sundials_fnvecopenmp_mod_static DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(BUILD_STATIC_LIBS)

if(BUILD_SHARED_LIBS)
  sundials_add_f2003_interface_library(sundials_fnvecopenmp_mod_shared SHARED_OBJECT
    ${nvecopenmp_SOURCES}
  )
  add_dependencies(sundials_fnvecopenmp_mod_shared_obj sundials_fgeneric_shared_obj)
  set_target_properties(sundials_fnvecopenmp_mod_shared
    PROPERTIES OUTPUT_NAME sundials_fnvecopenmp_mod CLEAN_DIRECT_OUTPUT 1)
  set_target_properties(sundials_fnvecopenmp_mod_shared
    PROPERTIES VERSION ${nveclib_VERSION} SOVERSION ${nveclib_SOVERSION})
  install(TARGETS sundials_fnvecopenmp_mod_shared DESTINATION ${CMAKE_INSTALL_LIBDIR})
endif(BUILD_SHARED_LIBS)

message(STATUS "Added NVECTOR_OPENMP F2003 interface")
