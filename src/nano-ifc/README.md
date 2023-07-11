# NANO IFC

A minimal python wrapper of IfcOpenShell for interfacing with the taxonomy library and 
related tessellation capabilities.

Intended to provide a short feedback loop for testing the tessellation library with python

Based on https://github.com/krande/nanobind-minimal

## Installation

First install the pre-requisites for occt, cgal, nanobind + build requirements from conda-forge.

```bash
mamba env update -f environment.build.yml --prune
```

Activate the environment and install the package in editable mode.

```bash
pip install --no-build-isolation .
```

### Conda Build install

Installing as conda package

```bash
cd conda
mamba activate nano-ifc
boa build . --no-remove-work-dir
mamba install --use-local nano-ifc
```


