# have to add a custom command to generate the version source files:

ADD_CUSTOM_COMMAND (
    OUTPUT "${ROOT_BIN_DIR}/versioning/version.hxx" "${ROOT_BIN_DIR}/versioning/version.cxx"
    COMMAND "${PYTHON_EXECUTABLE}"
    ARGS "${ROOT_SRC_DIR}/buildScripts/generateVersionCxx.py" 
        "--git ${GIT_EXECUTABLE} ${ROOT_SRC_DIR}"
        "--boost ${Boost_VERSION}"
        "--hdf5 ${HDF5_VERSION}"
        "--json_spirit ${Json_Spirit_VERSION}"
        "--log4cplus ${LOG4CPLUS_VERSION}"
        "--soci ${SOCI_VERSION_STRING}"
        "--poco ${Poco_VERSION_STRING}"
    DEPENDS ${ROOT_SRC_DIR}/buildScripts/generateVersionCxx.py
    WORKING_DIRECTORY "${ROOT_BIN_DIR}/Versioning" )

ADD_LIBRARY( Versioning
    version.hxx version.cxx )

TARGET_LINK_LIBRARIES( Versioning
    ${MiscLib} )
