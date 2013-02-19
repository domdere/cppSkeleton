#Locate the Poco llibrary
# This module defines Poco_FOUND
# Poco_INCLUDE_DIR
# Poco_LIBRARY_DIR
# Poco_FOUNDATION_LIBRARY
# Poco_XML_LIBRARY
# Poco_NET_LIBRARY
# Poco_VERSION
# Poco_VERSION_STRING

INCLUDE ( FindPackageHandleStandardArgs )

OPTION ( Poco_DEBUG "Debug mode for the find_package module for Poco" OFF )

IF (WIN32)
    FIND_PATH ( Poco_INCLUDE_DIR Poco/Poco.h 
        HINTS
        $ENV{POCO_ROOT}
        PATH_SUFFIXES include
        PATHS
        C:/poco )

    FIND_PATH ( Poco_LIBRARY_DIR PocoNetmd.lib
        HINTS
        $ENV{POCO_ROOT}
        PATH_SUFFIXES lib lib64
        PATHS
        C:/poco )

ELSE (WIN32)
    FIND_PATH ( Poco_INCLUDE_DIR Poco/Poco.h 
        HINTS
        $ENV{POCO_ROOT}
        PATH_SUFFIXES include
        PATHS
        /usr/local )

    FIND_PATH ( Poco_LIBRARY_DIR libPocoNet.so
        HINTS
        $ENV{POCO_ROOT}
        PATH_SUFFIXES lib lib64
        PATHS
        /usr/local )

ELSE (WIN32)
ENDIF (WIN32)

SET ( Poco_LIBRARIES "" )


FOREACH ( COMPONENT ${Poco_FIND_COMPONENTS} )

    STRING ( TOUPPER "${COMPONENT}" UPPERCOMPONENT)

    IF ( WIN32 )
        IF (Poco_DEBUG)
            MESSAGE ( STATUS "Looking for Poco${COMPONENT}md.lib in ${Poco_LIBRARY_DIR}" )
        ENDIF (Poco_DEBUG)
        FIND_LIBRARY ( Poco_${UPPERCOMPONENT}_LIBRARY Poco${COMPONENT}md.lib 
            PATHS
            ${Poco_LIBRARY_DIR})

    ELSE ( WIN32 )
        IF (Poco_DEBUG)
            MESSAGE ( STATUS "Looking for libPoco${COMPONENT}d.so in ${Poco_LIBRARY_DIR}" )
        ENDIF (Poco_DEBUG)
        FIND_LIBRARY ( Poco_${UPPERCOMPONENT}_LIBRARY libPoco${COMPONENT}.so 
            PATHS
            ${Poco_LIBRARY_DIR})
    ENDIF ( WIN32 )


    IF (Poco_${UPPERCOMPONENT}_LIBRARY )
        LIST ( APPEND Poco_LIBRARIES "${Poco_${UPPERCOMPONENT}_LIBRARY}" )
    ENDIF (Poco_${UPPERCOMPONENT}_LIBRARY )

    FIND_PACKAGE_HANDLE_STANDARD_ARGS ( Poco_${UPPERCOMPONENT} DEFAULT_MSG 
        Poco_${UPPERCOMPONENT}_LIBRARY )

ENDFOREACH ( COMPONENT )

# determine the version of Poco, it seems to keep it in a #define is a sensible manner similar to
# Boost and Soci.

SET ( Poco_VERSION 0 )

FILE ( STRINGS "${Poco_INCLUDE_DIR}/Poco/Version.h" POCO_VERSION_H_CONTENTS REGEX "#define POCO_VERSION" )

IF ( Poco_DEBUG )
    MESSAGE ( STATUS "[${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}]: looking for Poco version in ${Poco_INCLUDE_DIR}/Poco/Version.h (contents: ${POCO_VERSION_H_CONTENTS})" )
ENDIF ( Poco_DEBUG )

STRING ( REGEX REPLACE ".*#define POCO_VERSION[^0-9]*0x([0-9]+).*" "\\1" Poco_VERSION "${POCO_VERSION_H_CONTENTS}")

SET (Poco_VERSION ${Poco_VERSION} CACHE INTERNAL "The version number for the Poco Libraries" )

# version format described in Poco/Version.h

IF ( NOT "${Poco_VERSION}" STREQUAL "0" )
    MATH ( EXPR Poco_MAJOR_VERSION "${Poco_VERSION} / 1000000" )
    MATH ( EXPR Poco_MINOR_VERSION "${Poco_VERSION} / 10000 % 100" )
    MATH ( EXPR Poco_PATCH_VERSION "${Poco_VERSION} / 100 % 100" )

    SET (Poco_VERSION_STRING "${Poco_MAJOR_VERSION}.${Poco_MINOR_VERSION}.${Poco_PATCH_VERSION}")
ENDIF ( NOT "${Poco_VERSION}" STREQUAL "0" )


IF (Poco_DEBUG)
    MESSAGE ( STATUS "INCLUDE: ${Poco_INCLUDE_DIR}, LIBRARY_DIR: ${Poco_LIBRARY_DIR}, FOUNDATION_LIBRARY: ${Poco_FOUNDATION_LIBRARY}, XML_LIBRARY: ${Poco_XML_LIBRARY}, NET_LIBRARY: ${Poco_NET_LIBRARY}" )
ENDIF (Poco_DEBUG)

FIND_PACKAGE_HANDLE_STANDARD_ARGS ( Poco DEFAULT_MSG
    Poco_INCLUDE_DIR )

MARK_AS_ADVANCED ( Poco_INCLUDE_DIR )
