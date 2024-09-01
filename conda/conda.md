# Local development using conda dependencies

Using a conda environment as a quick and easy way to build and test your project is a great way to ensure that your project is reproducible and that you can easily share your project with others. This guide will show you how to set up a conda environment for building your project.

```
mamba env update -f environment.yml
```

Then create a `.env.json` file containing the path to your `ifcopenshell-build` conda
environment.

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "env-vars",
      "hidden": true,
      "environment": {
        "PREFIX": "C:/Work/miniforge3/envs/ifcopenshell-build"
      }
    }
  ]
}
```