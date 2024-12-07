REM This script is used to activate the conda environment for the build process
set VS_PATH=
for /f "usebackq tokens=*" %%i in (`"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set VS_PATH=%%i
if not defined VS_PATH (
    echo "Visual Studio not found"
    exit 1
)
call "%VS_PATH%\VC\Auxiliary\Build\vcvarsall.bat" x64

if errorlevel 1 exit 1