IF (MSVC)
    add_debug_variants(LIBXML2_LIBRARIES "${LIBXML2_LIBRARIES}" d)
ENDIF ()

if (WITH_OPENCASCADE)
    # Open CASCADE
    IF ("${OCC_INCLUDE_DIR}" STREQUAL "")
        FIND_PATH(OCC_INCLUDE_DIR Standard_Version.hxx
                [PATHS
                /usr/include/occt
                /usr/include/oce
                /usr/include/opencascade
                ]
                REQUIRED
        )
        IF (OCC_INCLUDE_DIR)
            MESSAGE(STATUS "Found Open CASCADE include files in: ${OCC_INCLUDE_DIR}")
        ELSE ()
            MESSAGE(FATAL_ERROR "Unable to find Open CASCADE include directory, specify OCC_INCLUDE_DIR manually.")
        ENDIF ()
    ELSE ()
        SET(OCC_INCLUDE_DIR ${OCC_INCLUDE_DIR} CACHE FILEPATH "Open CASCADE header files")
        MESSAGE(STATUS "Looking for Open CASCADE include files in: ${OCC_INCLUDE_DIR}")
    ENDIF ()

    SET(OPENCASCADE_LIBRARY_NAMES
            TKernel TKMath TKBRep TKGeomBase TKGeomAlgo TKG3d TKG2d TKShHealing TKTopAlgo TKMesh TKPrim TKBool TKBO
            TKFillet TKSTEP TKSTEPBase TKSTEPAttr TKXSBase TKSTEP209 TKIGES TKOffset TKHLR

            # @todo investigate the exact conditions when this is necessary
            TKBin
    )

    IF ("${OCC_LIBRARY_DIR}" STREQUAL "")
        find_library(OCC_LIBRARY TKernel
                [PATHS
                /usr/lib
                ]
                REQUIRED
        )
        IF (OCC_LIBRARY)
            GET_FILENAME_COMPONENT(OCC_LIBRARY_DIR ${OCC_LIBRARY} PATH)
            MESSAGE(STATUS "Found Open CASCADE library files in: ${OCC_LIBRARY_DIR}")
        ELSE ()
            MESSAGE(FATAL_ERROR "Unable find Open CASCADE library directory, specify OCC_LIBRARY_DIR manually.")
        ENDIF ()
    ELSE ()
        SET(OCC_LIBRARY_DIR ${OCC_LIBRARY_DIR} CACHE FILEPATH "Open CASCADE library files")
        MESSAGE(STATUS "Looking for Open CASCADE library files in: ${OCC_LIBRARY_DIR}")
    ENDIF ()

    FIND_LIBRARY(libTKernel NAMES TKernel TKerneld PATHS ${OCC_LIBRARY_DIR} NO_DEFAULT_PATH)
    IF (libTKernel)
        MESSAGE(STATUS "Required Open Cascade Library files found")
    ELSE ()
        MESSAGE(FATAL_ERROR "Unable to find Open Cascade library files, aborting")
    ENDIF ()

    # Use the found libTKernel as a template for all other OCC libraries
    # TODO Extract this into macro/function
    foreach (lib ${OPENCASCADE_LIBRARY_NAMES})
        # Make sure we'll handle the Windows/MSVC debug postfix convention too.
        string(REPLACE TKerneld "${lib}" lib_path "${libTKernel}")
        string(REPLACE TKernel "${lib}" lib_path "${lib_path}")
        list(APPEND OPENCASCADE_LIBRARIES "${lib_path}")
    endforeach ()

    if (MSVC)
        add_definitions(-DHAVE_NO_DLL)
        add_debug_variants(OPENCASCADE_LIBRARIES "${OPENCASCADE_LIBRARIES}" d)
    endif ()
    if (WIN32)
        # OCC might require linking to Winsock depending on the version and build configuration
        list(APPEND OPENCASCADE_LIBRARIES ws2_32.lib)
    endif ()

    # Make sure cross-referenced symbols between static OCC libraries get
    # resolved. Also add thread and rt libraries.
    get_filename_component(libTKernelExt ${libTKernel} EXT)
    if ("${libTKernelExt}" STREQUAL ".a")
        set(OCCT_STATIC ON)
    endif ()

    if (WASM_BUILD)
        set(CMAKE_FIND_ROOT_PATH "${CMAKE_FIND_ROOT_PATH_BACKUP}")
    endif ()

    if (OCCT_STATIC)
        find_package(Threads)

        if (WASM_BUILD)
            set(OPENCASCADE_LIBRARIES ${OPENCASCADE_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
        else ()
            # OPENCASCADE_LIBRARIES repeated N times below in order to fix cyclic dependencies - use --start-group ... --end-group instead?
            # tfk: --start-group ... --end-group didn't work on the apple linker when last tested
            if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                set(OPENCASCADE_LIBRARIES -Wl,--start-group ${OPENCASCADE_LIBRARIES} -Wl,--end-group)
            else ()
                set(OPENCASCADE_LIBRARIES ${OPENCASCADE_LIBRARIES} ${OPENCASCADE_LIBRARIES} ${OPENCASCADE_LIBRARIES} ${OPENCASCADE_LIBRARIES} ${OPENCASCADE_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})
            endif ()
        endif ()

        if (NOT APPLE AND NOT WIN32)
            set(OPENCASCADE_LIBRARIES ${OPENCASCADE_LIBRARIES} "rt")
        endif ()
        if (NOT WIN32)
            set(OPENCASCADE_LIBRARIES ${OPENCASCADE_LIBRARIES} "dl")
        endif ()
    endif ()

endif ()
