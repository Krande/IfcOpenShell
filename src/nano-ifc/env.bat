@echo off

:: This is a batch file to set the environment variables for the project
:: It is not strictly necessary, but it provides you with type hints when working with the OpenCascade c++ library
:: distributed using conda-forge
::
:: mamba env update -f environment.build.yml --prune
:: mamba activate nano-ifc
::
:: Note!
:: You have to add a .env file to the root of the project where you set PREFIX=<path to your ada-cpp conda env>

set MY_PY_VER=311

:: set this file's parent directory as a variable
set THIS_DIR=%~dp0

:: read the .env file located in THIS_DIR and set the environment variables.
:: the .env file should contain a line like this:
:: PREFIX=C:\Users\your_user_name\mambaforge3\envs\ada-cpp
for /f "tokens=*" %%i in (%THIS_DIR%.env) do set %%i

set LIBRARY_PREFIX=%PREFIX%/Library
set CMAKE_PREFIX_PATH=%PREFIX%;%LIBRARY_PREFIX%/include;%LIBRARY_PREFIX%/lib;%LIBRARY_PREFIX%/bin

set OpenCASCADE_DIR=%LIBRARY_PREFIX%/lib/cmake/opencascade
set OpenCASCADE_INCLUDE_DIR=%LIBRARY_PREFIX%/include/opencascade

set CGAL_DIR=%LIBRARY_PREFIX%/lib/cmake/CGAL

set PYTHON_EXECUTABLE=%PREFIX%/python.exe
set PYTHON_LIBRARY=%PREFIX%/libs/python%MY_PY_VER%.lib