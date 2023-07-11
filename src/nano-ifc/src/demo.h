#pragma once

#include <vector>
#include <gp_XYZ.hxx>
#include <gp_Pnt.hxx>
#include <TopoDS_Solid.hxx>
#include <BRepPrimAPI_MakeBox.hxx>
#include <TDF_Label.hxx>
#include <TDataStd_Name.hxx>
#include <Quantity_Color.hxx>
#include <XCAFDoc_ColorType.hxx>
#include <XCAFDoc_ColorTool.hxx>
#include <optional>
#include "binding_core.h"


TopoDS_Solid create_occt_box(const std::vector<float> &box_origin, const std::vector<float> &box_dims);

void occ_module(nb::module_ &m);
