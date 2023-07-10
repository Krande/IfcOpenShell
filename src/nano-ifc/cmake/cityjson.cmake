message(STATUS "Building CityJSON support")
set(CITYJSON_CONVERT_FILES
        ../src/ifcconvert/cityjson/geobim.cpp
        ../src/ifcconvert/cityjson/global_execution_context.cpp
        ../src/ifcconvert/cityjson/opening_collector.cpp
        ../src/ifcconvert/cityjson/processing.cpp
        ../src/ifcconvert/cityjson/radius_comparison.cpp
        ../src/ifcconvert/cityjson/radius_execution_context.cpp
        ../src/ifcconvert/cityjson/settings.cpp
        ../src/ifcconvert/cityjson/writer.cpp
)

add_library(cityjson_converter ${CITYJSON_CONVERT_FILES})
target_include_directories(cityjson_converter PRIVATE ../src)
set(IFCOPENSHELL_LIBRARIES ${IFCOPENSHELL_LIBRARIES} cityjson_converter)

if (NOT MINIMAL_BUILD AND WITH_CGAL AND CITYJSON_SUPPORT)
    add_definitions(-DIFOPSH_WITH_CGAL)
    set(SWIG_DEFINES ${SWIG_DEFINES} -DIFOPSH_WITH_CGAL)
endif ()