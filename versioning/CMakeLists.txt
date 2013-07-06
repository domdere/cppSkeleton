# have to add a custom command to generate the version source files:

IF ( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )

    SET ( COMP_FLAGS "c: ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}, cpp: ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}" )

ELSE ( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )

    IF (${CMAKE_BUILD_TYPE} STREQUAL "Release")
        SET ( COMP_FLAGS "c: ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELEASE}, cpp: ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}" )
    ELSE (${CMAKE_BUILD_TYPE} STREQUAL "Release")

        IF (${CMAKE_BUILD_TYPE} STREQUAL "RelWithDebInfo")
            SET ( COMP_FLAGS "c: ${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_RELWITHDEBINFO}, cpp: ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}" )
        ENDIF (${CMAKE_BUILD_TYPE} STREQUAL "RelWithDebInfo")

    ENDIF (${CMAKE_BUILD_TYPE} STREQUAL "Release")

ENDIF ( ${CMAKE_BUILD_TYPE} STREQUAL "Debug" )


ADD_CUSTOM_COMMAND (
    OUTPUT "${ROOT_BIN_DIR}/versioning/version.hxx" "${ROOT_BIN_DIR}/versioning/version.cxx"
    COMMAND "${PYTHON_EXECUTABLE}"
    ARGS "${ROOT_SRC_DIR}/buildScripts/generateVersionCxx.py" 
        "--namespace" "projectnamespace"
        "--git" "${GIT_EXECUTABLE}" "${ROOT_SRC_DIR}"
        "--boost" "${Boost_LIB_VERSION}"
        "--hdf5" "${HDF5_VERSION}"
        "--json_spirit" "${Json_Spirit_VERSION}"
        "--log4cplus" "${LOG4CPLUS_VERSION}"
        "--soci" "${SOCI_VERSION_STRING}"
        "--poco" "${Poco_VERSION_STRING}"
        "--compilername" "${CMAKE_CXX_COMPILER}"
        "--cflags" "${COMP_FLAGS}"
        "--buildtype" "${CMAKE_BUILD_TYPE}"
        "${ROOT_BIN_DIR}/versioning" 
        "version.hxx"
        "version.cxx"
    DEPENDS ${ROOT_SRC_DIR}/buildScripts/generateVersionCxx.py
    WORKING_DIRECTORY "${ROOT_BIN_DIR}/versioning" )

ADD_CUSTOM_TARGET ( versionGen ALL DEPENDS
    "${ROOT_BIN_DIR}/versioning/version.hxx"
    "${ROOT_BIN_DIR}/versioning/version.cxx" )

ADD_LIBRARY( versioning
    "${ROOT_BIN_DIR}/versioning/version.hxx"
    "${ROOT_BIN_DIR}/versioning/version.cxx" )

ADD_DEPENDENCIES( versioning
    versionGen )

TARGET_LINK_LIBRARIES( versioning
    ${MiscLib} )
