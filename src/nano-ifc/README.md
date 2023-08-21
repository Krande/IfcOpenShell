# NANO IFC

A minimal python wrapper of IfcOpenShell for interfacing with the taxonomy library and 
related tessellation capabilities.

Intended to provide a short feedback loop for testing the tessellation library with python

Based on https://github.com/krande/nanobind-minimal

## Development Installation

Install the pre-requisites such as occt, cgal, nanobind + build requirements from conda-forge.

```bash
mamba env update -f environment.build.yml --prune
```

Activate the environment and install the package in editable mode.

```bash
pip install --no-build-isolation .
```

Tip! If you want to get type hints from the c++ packages in your conda environment,
I recommend creating a batch file to set the environment variables and use that as an environment file.

Either run the batch file as part of the start up routine for your IDE or if you are using 
CLION you can point to the env.bat file using

`Build, Execution, Deployment > Toolchains -> Add Environment -> Environment file.`

See the [`env.bat`](env.bat) file as an example of how you can set the environment variables using a batch file
from packages in your conda environment.


### Conda Build install

Installing as conda package

```bash
cd conda
mamba activate nano-ifc
boa build . --no-remove-work-dir
mamba install --use-local nano-ifc
```


