//
// Created by Kristoffer on 11/07/2023.
//
#include <vector>
#include <gp_XYZ.hxx>
#include <gp_Pnt.hxx>
#include <TopoDS_Solid.hxx>
#include <BRepPrimAPI_MakeBox.hxx>
#include "binding_core.h"
#include <BRepMesh_IncrementalMesh.hxx>
#include <Poly_Triangulation.hxx>
#include <TopExp_Explorer.hxx>
#include <TopoDS.hxx>


TopoDS_Solid create_occt_box(const std::vector<float> &box_origin, const std::vector<float> &box_dims) {
    gp_Pnt aBoxOrigin(box_origin[0], box_origin[1], box_origin[2]);
    gp_XYZ aBoxDims(box_dims[0], box_dims[1], box_dims[2]);

    return BRepPrimAPI_MakeBox(aBoxOrigin, aBoxDims.X(), aBoxDims.Y(), aBoxDims.Z());
}


struct MeshData {
    Handle(Poly_Triangulation) triangulation;
    std::vector<int> faceIndices;
    std::vector<float> positions;
};

MeshData create_mesh(const TopoDS_Solid &box) {
    // Mesh the shape
    BRepMesh_IncrementalMesh meshMaker(box, 0.1);
    meshMaker.Perform();

    MeshData meshData;

    // Extract the triangulation
    TopExp_Explorer faceExplorer;
    for (faceExplorer.Init(box, TopAbs_FACE); faceExplorer.More(); faceExplorer.Next()) {
        TopoDS_Face face = TopoDS::Face(faceExplorer.Current());

        TopLoc_Location location;
        Handle(Poly_Triangulation) triangulation = BRep_Tool::Triangulation(face, location);

        if (!triangulation.IsNull()) {
            // Add the triangulation to the struct
            meshData.triangulation = triangulation;

            // Add the face index to the vector
            meshData.faceIndices.push_back(triangulation->NbTriangles());

            // Assuming one position per triangle, change this if necessary
            for (int i = 1; i <= triangulation->NbTriangles(); i++) {
                // Placeholder calculation, replace with actual calculation of position
                float position = static_cast<float>(i);
                meshData.positions.push_back(position);
            }
        }
    }

    return meshData;
}

std::vector<MeshData> get_tessellated_boxes(std::vector<std::vector<float>> &box_origins,
                                            std::vector<std::vector<float>> &box_dims) {
    std::vector<MeshData> meshDataVector;

    for (int i = 0; i < box_origins.size(); i++) {
        TopoDS_Solid box = create_occt_box(box_origins[i], box_dims[i]);
        MeshData meshData = create_mesh(box);
        meshDataVector.push_back(meshData);
    }

    return meshDataVector;
}


void occ_module(nb::module_ &m) {
    m.def("get_tessellated_boxes", &get_tessellated_boxes, "box_origins"_a, "box_dimss"_a,
          "Get a list of box meshes based on the input box origins and dimensions");
    nb::class_<MeshData>(std::move(m), "Mesh")
            .def_rw("positions", &MeshData::positions)
            .def_rw("indices", &MeshData::faceIndices);
}