# if cmake_osx_sysroot is undefined set it
if (NOT DEFINED CMAKE_OSX_SYSROOT or NOT DEFINED CMAKE_OSX_DEPLOYMENT_TARGET)
    set(CMAKE_OSX_SYSROOT "/Users/runner/work/MacOSX10.15.sdk" CACHE PATH "macOS SDK path" FORCE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "macOS deployment target" FORCE)
else ()
    message(STATUS "macOS SDK path is ${CMAKE_OSX_SYSROOT}")
    message(STATUS "macOS deployment target is ${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif ()

if (DEFINED CMAKE_OSX_SYSROOT)
    message(STATUS "Setting macOS sysroot to ${CMAKE_OSX_SYSROOT}")
else ()
    message(FATAL_ERROR "CMAKE_OSX_SYSROOT is not defined. Please set it to the path of the macOS SDK you want to use.")
endif ()

if (DEFINED CMAKE_OSX_DEPLOYMENT_TARGET)
    message(STATUS "Setting macOS deployment target to ${CMAKE_OSX_DEPLOYMENT_TARGET}")
else ()
    message(FATAL_ERROR "CMAKE_OSX_DEPLOYMENT_TARGET is not defined. Please set it to the minimum macOS version you want to support.")
endif ()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isysroot ${CMAKE_OSX_SYSROOT} -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -isysroot ${CMAKE_OSX_SYSROOT} -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}")