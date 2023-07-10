OPTION(COLLADA_SUPPORT "Build IfcConvert with COLLADA support (requires OpenCOLLADA)." ON)
if (NOT MINIMAL_BUILD)
    UNIFY_ENVVARS_AND_CACHE(OPENCOLLADA_INCLUDE_DIR)
    UNIFY_ENVVARS_AND_CACHE(OPENCOLLADA_LIBRARY_DIR)
endif ()


IF (NOT MINIMAL_BUILD AND COLLADA_SUPPORT)
    # Find OpenCOLLADA
    IF ("${OPENCOLLADA_INCLUDE_DIR}" STREQUAL "")
        MESSAGE(STATUS "No OpenCOLLADA include directory specified")
        SET(OPENCOLLADA_INCLUDE_DIR "/usr/include/opencollada" CACHE FILEPATH "OpenCOLLADA header files")
    ELSE ()
        SET(OPENCOLLADA_INCLUDE_DIR "${OPENCOLLADA_INCLUDE_DIR}" CACHE FILEPATH "OpenCOLLADA header files")
    ENDIF ()

    IF ("${OPENCOLLADA_LIBRARY_DIR}" STREQUAL "")
        MESSAGE(STATUS "No OpenCOLLADA library directory specified")
        FIND_LIBRARY(OPENCOLLADA_FRAMEWORK_LIB NAMES OpenCOLLADAFramework
                PATHS /usr/lib64/opencollada /usr/lib/opencollada /usr/lib64 /usr/lib /usr/local/lib64 /usr/local/lib)
        GET_FILENAME_COMPONENT(OPENCOLLADA_LIBRARY_DIR ${OPENCOLLADA_FRAMEWORK_LIB} PATH)
    ENDIF ()

    FIND_LIBRARY(OpenCOLLADAFramework NAMES OpenCOLLADAFramework OpenCOLLADAFrameworkd PATHS ${OPENCOLLADA_LIBRARY_DIR} NO_DEFAULT_PATH)
    if (OpenCOLLADAFramework)
        message(STATUS "OpenCOLLADA library files found")
    else ()
        message(FATAL_ERROR "COLLADA_SUPPORT enabled, but unable to find OpenCOLLADA libraries. "
                "Disable COLLADA_SUPPORT or fix OpenCOLLADA paths to proceed.")
    endif ()

    SET(OPENCOLLADA_LIBRARY_DIR "${OPENCOLLADA_LIBRARY_DIR}" CACHE FILEPATH "OpenCOLLADA library files")

    SET(OPENCOLLADA_INCLUDE_DIRS "${OPENCOLLADA_INCLUDE_DIR}/COLLADABaseUtils" "${OPENCOLLADA_INCLUDE_DIR}/COLLADAStreamWriter")

    FIND_FILE(COLLADASWStreamWriter_h "COLLADASWStreamWriter.h" ${OPENCOLLADA_INCLUDE_DIRS})
    IF (COLLADASWStreamWriter_h)
        MESSAGE(STATUS "OpenCOLLADA header files found")
        ADD_DEFINITIONS(-DWITH_OPENCOLLADA)
        set(SWIG_DEFINES ${SWIG_DEFINES} -DWITH_OPENCOLLADA)

        SET(OPENCOLLADA_LIBRARY_NAMES
                GeneratedSaxParser MathMLSolver OpenCOLLADABaseUtils OpenCOLLADAFramework OpenCOLLADASaxFrameworkLoader
                OpenCOLLADAStreamWriter UTF buffer ftoa
        )

        # Use the found OpenCOLLADAFramework as a template for all other OpenCOLLADA libraries
        foreach (lib ${OPENCOLLADA_LIBRARY_NAMES})
            # Make sure we'll handle the Windows/MSVC debug postfix convention too.
            string(REPLACE OpenCOLLADAFrameworkd "${lib}" lib_path "${OpenCOLLADAFramework}")
            string(REPLACE OpenCOLLADAFramework "${lib}" lib_path "${lib_path}")
            list(APPEND OPENCOLLADA_LIBRARIES "${lib_path}")
        endforeach ()

        if ("${PCRE_LIBRARY_DIR}" STREQUAL "")
            if (WIN32)
                find_library(pcre_library NAMES pcre pcred PATHS ${OPENCOLLADA_LIBRARY_DIR} NO_DEFAULT_PATH)
            else ()
                find_library(pcre_library NAMES pcre PATHS ${OPENCOLLADA_LIBRARY_DIR})
            endif ()
            GET_FILENAME_COMPONENT(PCRE_LIBRARY_DIR ${pcre_library} PATH)
        else ()
            find_library(pcre_library NAMES pcre pcred PATHS ${PCRE_LIBRARY_DIR} NO_DEFAULT_PATH)
        endif ()

        if (pcre_library)
            SET(OPENCOLLADA_LIBRARY_DIR ${OPENCOLLADA_LIBRARY_DIR} ${PCRE_LIBRARY_DIR})
            if (MSVC)
                # Add release lib regardless whether release or debug found. Debug version will be appended below.
                list(APPEND OPENCOLLADA_LIBRARIES "${PCRE_LIBRARY_DIR}/pcre.lib")
            else ()
                list(APPEND OPENCOLLADA_LIBRARIES "${pcre_library}")
            endif ()
        else ()
            message(FATAL_ERROR "COLLADA_SUPPORT enabled, but unable to find PCRE. "
                    "Disable COLLADA_SUPPORT or fix PCRE_LIBRARY_DIR path to proceed.")
        endif ()

        IF (MSVC)
            add_debug_variants(OPENCOLLADA_LIBRARIES "${OPENCOLLADA_LIBRARIES}" d)
        ENDIF ()
    ELSE ()
        message(FATAL_ERROR "COLLADA_SUPPORT enabled, but unable to find OpenCOLLADA headers. "
                "Disable COLLADA_SUPPORT or fix OpenCOLLADA paths to proceed.")
    ENDIF ()
ENDIF ()
