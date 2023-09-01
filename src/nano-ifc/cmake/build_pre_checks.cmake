if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    message(STATUS "Building for x64 architecture")
else ()
    message(FATAL_ERROR "This project requires a 64-bit toolchain. Please update your toolchain arch to 'x86_amd64'")
endif ()

if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "Build type not set, defaulting to Release")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif ()
message(STATUS "Build type: " ${CMAKE_BUILD_TYPE})

if (APPLE)
    # Use file parent directory to refer to neighboring files
    get_filename_component(PARENT_DIR ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)
    include(${PARENT_DIR}/build_pre_apple.cmake)
endif ()