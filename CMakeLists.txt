cmake_minimum_required(VERSION 3.20.0)
project(BioCro CXX)

message(VERBOSE "Processing biocro-lib/src/CMakeLists.txt")
if(MESSAGE_LOG_LEVEL IN_LIST LOG_LEVELS_FOR_INDENTATION)
  list(APPEND CMAKE_MESSAGE_INDENT "  ")
endif()

set(CMAKE_CXX_STANDARD 11)
set(SKIP_BUILD_RPATH TRUE)
set(BUILD_WITH_INSTALL_NAME_DIR TRUE)
set(INSTALL_NAME_DIR "/Users/srohde/Documents/GitHub/gsrohde/public/DAWN/biocro-lib/src/build/")

include(CMakeDependentOption)
cmake_dependent_option(
  BIOCROLIB_STATIC
  "Build BioCro as a static library"
  ON
  "NOT BUILD_SHARED_LIBS"
  OFF
)

# set build type based on dependent option
if (BIOCROLIB_STATIC)
  set(BIOCROLIB_BUILD_TYPE STATIC)
else ()
  set(BIOCROLIB_BUILD_TYPE SHARED)
endif ()

# use build type in library definition
add_library(BioCro ${BIOCROLIB_BUILD_TYPE})

target_precompile_headers(BioCro PRIVATE
    "src/framework/ode_solver_library/boost_ode_solvers.h"
    "src/framework/ode_solver.h"
)

target_include_directories(BioCro INTERFACE "src")
target_include_directories(BioCro PUBLIC "inc")

target_sources(BioCro PRIVATE src/framework/validate_dynamical_system.cpp)
target_sources(BioCro PRIVATE src/framework/ode_solver.cpp)
target_sources(BioCro PRIVATE src/framework/dynamical_system.cpp)
target_sources(BioCro PRIVATE src/framework/utils/module_dependency_utilities.cpp)
target_sources(BioCro PRIVATE src/framework/modules.cpp)
target_sources(BioCro PRIVATE src/framework/quadratic_root.cpp)
target_sources(BioCro PRIVATE src/framework/state_map.cpp)
target_sources(BioCro PRIVATE src/framework/dynamical_system_helper_functions.cpp)
target_sources(BioCro PRIVATE src/framework/module_helper_functions.cpp)
target_sources(BioCro PRIVATE src/framework/ode_solver_library/ode_solver_factory.cpp)
target_sources(BioCro PRIVATE src/framework/ode_solver_library/boost_ode_solvers.cpp)
target_sources(BioCro PRIVATE src/module_library/AuxBioCro.cpp)
target_sources(BioCro PRIVATE src/module_library/multilayer_c4_canopy.cpp)
target_sources(BioCro PRIVATE src/module_library/c3_canopy.cpp)
target_sources(BioCro PRIVATE src/module_library/FvCB_assim.cpp)
target_sources(BioCro PRIVATE src/module_library/lightME.cpp)
target_sources(BioCro PRIVATE src/module_library/multilayer_canopy_properties.cpp)
target_sources(BioCro PRIVATE src/module_library/c3CanAC.cpp)
target_sources(BioCro PRIVATE src/module_library/module_library.cpp)
target_sources(BioCro PRIVATE src/module_library/collatz_photo.cpp)
target_sources(BioCro PRIVATE src/module_library/eC4photo.cpp)
target_sources(BioCro PRIVATE src/module_library/multilayer_c3_canopy.cpp)
target_sources(BioCro PRIVATE src/module_library/c4_leaf_photosynthesis.cpp)
target_sources(BioCro PRIVATE src/module_library/CanAC.cpp)
target_sources(BioCro PRIVATE src/module_library/c4photo.cpp)
target_sources(BioCro PRIVATE src/module_library/sunML.cpp)
target_sources(BioCro PRIVATE src/module_library/rue_leaf_photosynthesis.cpp)
target_sources(BioCro PRIVATE src/module_library/multilayer_rue_canopy.cpp)
target_sources(BioCro PRIVATE src/module_library/penman_monteith_leaf_temperature.cpp)
target_sources(BioCro PRIVATE src/module_library/c3photo.cpp)
target_sources(BioCro PRIVATE src/module_library/c3EvapoTrans.cpp)
target_sources(BioCro PRIVATE src/module_library/rasmussen_specific_heat.cpp)
target_sources(BioCro PRIVATE src/module_library/ball_berry_gs.cpp)
target_sources(BioCro PRIVATE src/module_library/c3_leaf_photosynthesis.cpp)

target_sources(BioCro INTERFACE
                 FILE_SET biocro_lib_headers
                   TYPE HEADERS
                   FILES src/framework/state_map.h
                         src/framework/biocro_simulation.h
                         src/framework/constants.h
                         src/framework/dynamical_system.h
                         src/framework/dynamical_system_helper_functions.h
                         src/framework/module.h
                         src/framework/module_creator.h
                         src/framework/module_factory.h
                         src/framework/module_helper_functions.h
                         src/framework/ode_solver.h
                         src/framework/ode_solver_library/ode_solver_factory.h
                         src/framework/state_map.h
                         src/framework/validate_dynamical_system.h
                         src/module_library/module_library.h
                    BASE_DIRS src
)
