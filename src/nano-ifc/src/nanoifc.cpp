#include "binding_core.h"
#include "demo.h"

// Define the modules that will be exposed in python
NB_MODULE(_nano_ifc_ext_impl, m) {
    step_writer_module(m);
    geom_module(m);
}