# ---------------------------------------------------------------
# Programmer(s): Daniel R. Reynolds @ SMU
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
# ARKode C++ parallel unit_tests
# ---------------------------------------------------------------

# List of test tuples of the form "name\;tasks\;args"
if (NOT SUNDIALS_PRECISION MATCHES "SINGLE")
  set(ARKODE_unit_tests
    "ark_heat2D_mri\;2\;0"
    "ark_heat2D_mri\;4\;1"
    )
endif()

if(MPI_CXX_COMPILER)
  # use MPI wrapper as the compiler
  set(CMAKE_CXX_COMPILER ${MPI_CXX_COMPILER})

  # disable C++ extensions (for known wrappers)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DMPICH_SKIP_MPICXX -DOMPI_SKIP_MPICXX -DLAM_BUILDING")
else()
  # add MPI_INCLUDE_PATH to include directories
  include_directories(${MPI_INCLUDE_PATH})
endif()

# Specify libraries to link against (through the target that was used to
# generate them) based on the value of the variable LINK_LIBRARY_TYPE
if(LINK_LIBRARY_TYPE MATCHES "static")
  set(ARKODE_LIB sundials_arkode_static)
  set(NVECP_LIB sundials_nvecparallel_static)
else()
  set(ARKODE_LIB sundials_arkode_shared)
  set(NVECP_LIB sundials_nvecparallel_shared)
endif()

# Set-up linker flags and link libraries
set(SUNDIALS_LIBS ${ARKODE_LIB} ${NVECP_LIB} ${EXTRA_LINK_LIBS})

# Add the build and install targets for each test
foreach(test_tuple ${ARKODE_unit_tests})

  # parse the test tuple
  list(GET test_tuple 0 test)
  list(GET test_tuple 1 number_of_tasks)
  list(GET test_tuple 2 test_args)

  # check if this test has already been added, only need to add
  # test source files once for testing with different inputs
  if(NOT TARGET ${test})
    
    # test source files
    add_executable(${test} ${test}.cpp)
    
    set_target_properties(${test} PROPERTIES FOLDER "unit_tests")
    
    # include location of public and private header files
    target_include_directories(${test} PRIVATE ${CMAKE_SOURCE_DIR}/include)
    target_include_directories(${test} PRIVATE ${CMAKE_SOURCE_DIR}/src)
    
    # libraries to link against
    target_link_libraries(${test} ${SUNDIALS_LIBS})
    
    if(NOT MPI_CXX_COMPILER)
      target_link_libraries(${test} ${MPI_LIBRARY} ${MPI_EXTRA_LIBRARIES})
    endif()
    
  endif()

  # check if test args are provided and set the test name
  if("${test_args}" STREQUAL "")
    set(test_name ${test})
  else()
    string(REGEX REPLACE " " "_" test_name ${test}_${test_args})
  endif()
  
  # add test to regression tests
  sundials_add_test(${test_name} ${test}
    TEST_ARGS ${test_args}
    MPI_NPROCS ${number_of_tasks}
    NODIFF)
  
endforeach()
