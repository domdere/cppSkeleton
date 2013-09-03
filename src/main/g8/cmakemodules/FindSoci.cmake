###############################################################################
# CMake module to search for SOCI library
#
# WARNING: This module is experimental work in progress.
#
# This module defines:
#  SOCI_INCLUDE_DIRS        = include dirs to be used when using the soci library
#  SOCI_LIBRARY             = full path to the soci library
#  SOCI_VERSION             = the soci version found (not yet. soci does not provide that info.)
#  SOCI_FOUND               = true if soci was found
#
# This module respects:
#  LIB_SUFFIX         = (64|32|"") Specifies the suffix for the lib directory
#
# For each component you specify in find_package(), the following variables are set.
#
#  SOCI_${COMPONENT}_PLUGIN = full path to the soci plugin
#  SOCI_${COMPONENT}_FOUND
#
# Copyright (c) 2011 Michael Jansen <info@michael-jansen.biz>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
#
###############################################################################
#
### Global Configuration Section
#
SET(_SOCI_ALL_PLUGINS    mysql odbc postgresql sqlite3)
SET(_SOCI_REQUIRED_VARS  SOCI_INCLUDE_DIR SOCI_LIBRARY)

#
### FIRST STEP: Find the soci headers.
#
FIND_PATH(
    SOCI_INCLUDE_DIR soci.h
    HINTS $ENV{SOCI_DIR}
    PATH "/usr/local"
    PATH_SUFFIXES include "include/soci")
MARK_AS_ADVANCED(SOCI_INCLUDE_DIR)

SET(SOCI_INCLUDE_DIRS ${SOCI_INCLUDE_DIR})

# REAL SECOND STEP (Dom De Re): extract the version number from the version.h header:

SET ( SOCI_VERSION 0 )
SET ( SOCI_LIB_VERSION "" )

FILE ( STRINGS "${SOCI_INCLUDE_DIR}/version.h" SOCI_VERSION_H_CONTENTS REGEX "#define SOCI_VERSION" )

IF ( SOCI_DEBUG )
    MESSAGE ( STATUS "[${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}]: looking for Soci version in ${SOCI_INCLUDE_DIR}/version.h" )
ENDIF ( SOCI_DEBUG )

STRING ( REGEX REPLACE ".*#define SOCI_VERSION ([0-9]+).*" "\\1" SOCI_VERSION "${SOCI_VERSION_H_CONTENTS}")

SET (SOCI_VERSION ${SOCI_VERSION} CACHE INTERNAL "The version number for the Soci Libraries" )

IF ( NOT "${SOCI_VERSION}" STREQUAL "0" )
    MATH ( EXPR SOCI_MAJOR_VERSION "${SOCI_VERSION} / 100000" )
    MATH ( EXPR SOCI_MINOR_VERSION "${SOCI_VERSION} / 100 % 1000" )
    MATH ( EXPR SOCI_PATCH_VERSION "${SOCI_VERSION} % 100" )
ENDIF ( NOT "${SOCI_VERSION}" STREQUAL "0" )

# REAL STEP 2a: build the lib suffixes that are used for windows...
SET ( SOCI_VERSION_STRING "${SOCI_MAJOR_VERSION}.${SOCI_MINOR_VERSION}.${SOCI_PATCH_VERSION}" )

MESSAGE ( STATUS "Soci version found: ${SOCI_VERSION_STRING}" )

IF ( "${SOCI_PATCH_VERSION}" STREQUAL "0" )
    SET ( SOCI_VERSION_LIB_SUFFIX "${SOCI_MAJOR_VERSION}_${SOCI_MINOR_VERSION}" ) 
ELSEIF ( "${SOCI_PATCH_VERSION}" STREQUAL "0" )
    SET ( SOCI_VERSION_LIB_SUFFIX "${SOCI_MAJOR_VERSION}_${SOCI_MINOR_VERSION}_${SOCI_PATCH_VERSION}" ) 
ENDIF ( "${SOCI_PATCH_VERSION}" STREQUAL "0" )


#
### SECOND STEP: Find the soci core library. Respect LIB_SUFFIX
#

IF ( SOCI_DEBUG )
    MESSAGE ( STATUS "Looking for soci libs in ${SOCI_INCLUDE_DIR}/../lib${LIB_SUFFIX}" )
    MESSAGE ( STATUS "Version Lib Suffix: ${SOCI_VERSION_LIB_SUFFIX}" )
ENDIF ( SOCI_DEBUG )

FIND_LIBRARY(
    SOCI_LIBRARY
    NAMES soci_core soci_core_${SOCI_VERSION_LIB_SUFFIX}
    HINTS ${SOCI_INCLUDE_DIR}/..
    PATH_SUFFIXES lib${LIB_SUFFIX})
MARK_AS_ADVANCED(SOCI_LIBRARY)

GET_FILENAME_COMPONENT(SOCI_LIBRARY_DIR ${SOCI_LIBRARY} PATH)
MARK_AS_ADVANCED(SOCI_LIBRARY_DIR)

#
### THIRD STEP: Find all installed plugins if the library was found
#
IF(SOCI_INCLUDE_DIR AND SOCI_LIBRARY)

    MESSAGE(STATUS "Soci found: Looking for plugins")
    FOREACH(plugin IN LISTS _SOCI_ALL_PLUGINS)

        FIND_LIBRARY(
            SOCI_${plugin}_PLUGIN
            NAMES soci_${plugin} libsoci_${plugin}_${SOCI_VERSION_LIB_SUFFIX}
            HINTS ${SOCI_INCLUDE_DIR}/..
            PATH_SUFFIXES lib${LIB_SUFFIX})
        MARK_AS_ADVANCED(SOCI_${plugin}_PLUGIN)

        IF(SOCI_${plugin}_PLUGIN)
            MESSAGE(STATUS "    * Plugin ${plugin} found ${SOCI_${plugin}_LIBRARY}.")
            SET(SOCI_${plugin}_FOUND True)
        ELSE()
            MESSAGE(STATUS "    * Plugin ${plugin} not found.")
            SET(SOCI_${plugin}_FOUND False)
        ENDIF()

    ENDFOREACH()

    #
    ### FOURTH CHECK: Check if the required components were all found
    #
    FOREACH(component ${Soci_FIND_COMPONENTS})
        IF(${SOCI_${component}_FOUND})
            # Does not work with NOT ... . No idea why.
        ELSE()
            MESSAGE(SEND_ERROR "Required component ${component} not found.")
        ENDIF()
    ENDFOREACH()

ENDIF()

#
### ADHERE TO STANDARDS
#
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Soci DEFAULT_MSG ${_SOCI_REQUIRED_VARS})
