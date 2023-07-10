# IfcConvert
file(GLOB IFCCONVERT_CPP_FILES ../src/ifcconvert/*.cpp)
file(GLOB IFCCONVERT_H_FILES ../src/ifcconvert/*.h)
set(IFCCONVERT_FILES ${IFCCONVERT_CPP_FILES} ${IFCCONVERT_H_FILES})
ADD_EXECUTABLE(IfcConvert ${IFCCONVERT_FILES})
set_target_properties(IfcConvert PROPERTIES COMPILE_FLAGS "${CONVERT_PRECISION}")

TARGET_LINK_LIBRARIES(IfcConvert ${IFCOPENSHELL_LIBRARIES} ${OPENCASCADE_LIBRARIES} ${Boost_LIBRARIES} ${HDF5_LIBRARIES})

if ((NOT WIN32) AND BUILD_SHARED_LIBS)
    # Only set RPATHs when building shared libraries (i.e. IfcParse and
    # IfcGeom are dynamically linked). Not necessarily a perfect solution
    # but probably a good indication of whether RPATHs are necessary.
    SET_INSTALL_RPATHS(IfcConvert "${IFCOPENSHELL_LIBRARY_DIR};${OCC_LIBRARY_DIR};${Boost_LIBRARY_DIRS};${OPENCOLLADA_LIBRARY_DIR}")
endif ()

INSTALL(TARGETS IfcConvert
        ARCHIVE DESTINATION ${LIBDIR}
        LIBRARY DESTINATION ${LIBDIR}
        RUNTIME DESTINATION ${BINDIR}
)
