//
// Created by Kristoffer on 11/07/2023.
//
#include <vector>
#include <gp_XYZ.hxx>
#include <gp_Pnt.hxx>
#include <TopoDS_Solid.hxx>
#include <BRepPrimAPI_MakeBox.hxx>
#include <TDataStd_Name.hxx>


TopoDS_Solid create_box(const std::vector<float> &box_origin, const std::vector<float> &box_dims) {
    gp_Pnt aBoxOrigin(box_origin[0], box_origin[1], box_origin[2]);
    gp_XYZ aBoxDims(box_dims[0], box_dims[1], box_dims[2]);

    return BRepPrimAPI_MakeBox(aBoxOrigin, aBoxDims.X(), aBoxDims.Y(), aBoxDims.Z());
}

void step_writer_module(nb::module_ &m) {
    m.def("write_box_to_step", &create_box, "box_origin"_a, "box_dims"_a,
          "Write a box to a step file");
}