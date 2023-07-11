cmake_minimum_required(VERSION 3.20)

project(nano-ifc LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)

include(cmake/build_pre_checks.cmake)

if (APPLE)
    include(cmake/build_pre_apple.cmake)
endif ()

find_package(Python 3 COMPONENTS Interpreter Development.Module REQUIRED)

# create a empty list called NANO_IFC_LINK_LIBS
set(NANO_IFC_LINK_LIBS)

# Create a list called NANO_IFC_SOURCES of all cpp files inside the src dir
set(NANO_IFC_SOURCES
        src/nanoifc.cpp
        src/demo.cpp
        ../ifcgeom/taxonomy.cpp
)

# Add dependencies
include(cmake/dep_cgal.cmake)
include(cmake/dep_occt.cmake)

# Add NanoBind
include(cmake/nano_bind.cmake)

# Link libraries
target_link_libraries(_nano_ifc_ext_impl PRIVATE NANO_IFC_LINK_LIBS)

# Install
install(TARGETS _nano_ifc_ext_impl LIBRARY DESTINATION .)