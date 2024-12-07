# CMakePresets.json and Conda for fast debugging

first install your conda environment

```bash
mamba create -n ifctest_old boost-cpp=1.78 hdf5=1.12.1 cmake ninja swig occt=7.7.2=*novtk* libxml2 mpir cgal-cpp nlohmann_json zlib mpfr
```

Maybe you want to compare it with another environment

```bash
mamba create -n ifctest_new boost-cpp=1.82 hdf5=1.12.1 cmake ninja swig occt=7.7.2=*novtk* libxml2 mpir cgal-cpp nlohmann_json zlib mpfr
```
Then activate it


Start your IDE and let it discover the CMakePresets.json file. 

Then select the preset `env-vars` and start debugging.

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "env-vars",
      "hidden": true,
      "environment": {
        "PREFIX_OLD": "C:\\miniforge3\\envs\\ifcva10_0",
        "PREFIX_NEW": "C:\\miniforge3\\envs\\ifcva10_1"
      }
    }
  ]
}
```
