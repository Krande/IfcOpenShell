@echo off

:: This is a batch file to set the environment variables for the project
:: It is not strictly necessary, but it provides you with type hints when working with the OpenCascade c++ library
:: distributed using conda-forge
::
:: mamba env update -f environment.build.yml --prune
:: mamba activate ifcopenshell-build
::
:: Note!
:: You have to add a .env file to the root of the project where you set PREFIX=<path to your conda env>

set MY_PY_VER=311
:: this will read the .env file and set the environment variables
for /f delims= %%x in ('type .env') do set %%x

set LIBRARY_PREFIX=%PREFIX%/Library
set CMAKE_PREFIX_PATH=%PREFIX%;%LIBRARY_PREFIX%/include;%LIBRARY_PREFIX%/lib;%LIBRARY_PREFIX%/bin

set OCC_LIBRARY_DIR=%LIBRARY_PREFIX%/lib/cmake/opencascade
set OCC_INCLUDE_DIR=%LIBRARY_PREFIX%/include/opencascade

set CGAL_DIR=%LIBRARY_PREFIX%/lib/cmake/CGAL

set GMP_INCLUDE_DIR=%LIBRARY_PREFIX%/include
set GMP_LIBRARY_DIR=%LIBRARY_PREFIX%/lib
set MPFR_LIBRARY_DIR=%LIBRARY_PREFIX%/lib
set COLLADA_SUPPORT=OFF
set HDF5_SUPPORT=ON
set HDF5_INCLUDE_DIR=%LIBRARY_PREFIX%/include
set HDF5_LIBRARY_DIR=%LIBRARY_PREFIX%/lib
set JSON_INCLUDE_DIR=%LIBRARY_PREFIX%/include
set PYTHON_INCLUDE_DIR=%PREFIX%/include
set PYTHON_EXECUTABLE=%PREFIX%/python.exe
set PYTHON_LIBRARY=%PREFIX%/libs/python%MY_PY_VER%.lib
set BUILD_IFCPYTHON=ON
set BUILD_IFCGEOM=ON
set COLLADA_SUPPORT=OFF
set BUILD_EXAMPLES=OFF
set BUILD_GEOMSERVER=OFF
set GLTF_SUPPORT=ON
set BUILD_CONVERT=ON
set BUILD_IFCMAX=OFF
set IFCXML_SUPPORT=ON
set Boost_LIBRARYDIR=%LIBRARY_PREFIX%/lib
set Boost_INCLUDEDIR=%LIBRARY_PREFIX%/include
set Boost_USE_STATIC_LIBS=OFF

set PYTHON_EXECUTABLE=%PREFIX%/python.exe
set PYTHON_LIBRARY=%PREFIX%/libs/python%MY_PY_VER%.lib