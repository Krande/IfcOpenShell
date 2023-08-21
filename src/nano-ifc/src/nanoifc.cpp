#include "binding_core.h"
#include "demo.h"

// Define the modules that will be exposed in python
NB_MODULE(_nano_ifc_ext_impl, m) {
    occ_module(m);
}