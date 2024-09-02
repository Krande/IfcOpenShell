# Local C++ development with IfcOpenshell using conda dependencies and CMakePresets.json

To quickly start working with the C++ portion of IfcOpenShell, you can use
a conda environment to manage the dependencies. This guide will show you how

Open your terminal, go to the neighbouring `conda` directory and run the following commands:

```bash
mamba env update -f environment.yml
```

Then create a `.env.json` file next to your CMakeLists.txt file containing the path to your newly 
created `ifcopenshell-build` conda environment.

Use the following content:

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "env-vars",
      "hidden": true,
      "environment": {
        "PREFIX": "/path/to/your/miniforge3/envs/ifcopenshell-build"
      }
    }
  ]
}
```

Then open CLion (or your favorite CMake-compatible IDE) and open the project. 
When asked to load the CMakePresets.json file, select it and choose the various pre-sets from inside the
CMakePresets.json.