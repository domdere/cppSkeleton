#Locate the Poco llibrary
# This module defines Poco_FOUND
# Poco_INCLUDE_DIR
# Poco_LIBRARY_DIR
# Poco_FOUNDATION_LIBRARY
# Poco_XML_LIBRARY
# Poco_NET_LIBRARY

IF (WIN32)
    FIND_PATH ( Poco_INCLUDE_DIR Poco/Poco.h 
        HINTS
        $ENV{POCO_ROOT}
        PATH_SUFFIXES include
        PATHS
        C:/poco )

    FIND_PATH ( Poco_LIBRARY_DIR PocoFoundationmd.lib
        HINTS
        $ENV{POCO_ROOT}
        PATH_SUFFIXES lib lib64
        PATHS
        C:/poco )

    SET ( Poco_LIBRARIES "" )

    INCLUDE ( FindPackageHandleStandardArgs )

    FOREACH ( COMPONENT ${Poco_FIND_COMPONENTS} )
        IF (Poco_DEBUG)
            MESSAGE ( STATUS "Looking for Poco${COMPONENT}md.lib in ${Poco_LIBRARY_DIR}" )
        ENDIF (Poco_DEBUG)
        STRING ( TOUPPER "${COMPONENT}" UPPERCOMPONENT)
        FIND_LIBRARY ( Poco_${UPPERCOMPONENT}_LIBRARY Poco${COMPONENT}md.lib 
            PATHS
            ${Poco_LIBRARY_DIR})

        IF (Poco_${UPPERCOMPONENT}_LIBRARY )
            LIST ( APPEND Poco_LIBRARIES "${Poco_${UPPERCOMPONENT}_LIBRARY}" )
        ENDIF (Poco_${UPPERCOMPONENT}_LIBRARY )

        FIND_PACKAGE_HANDLE_STANDARD_ARGS ( Poco_${UPPERCOMPONENT} DEFAULT_MSG 
            Poco_${UPPERCOMPONENT}_LIBRARY )

    ENDFOREACH ( COMPONENT )

    IF (Poco_DEBUG)
        MESSAGE ( STATUS "INCLUDE: ${Poco_INCLUDE_DIR}, LIBRARY_DIR: ${Poco_LIBRARY_DIR}, FOUNDATION_LIBRARY: ${Poco_FOUNDATION_LIBRARY}, XML_LIBRARY: ${Poco_XML_LIBRARY}, NET_LIBRARY: ${Poco_NET_LIBRARY}" )
    ENDIF (Poco_DEBUG)

ELSE (WIN32)
ENDIF (WIN32)

FIND_PACKAGE_HANDLE_STANDARD_ARGS ( Poco DEFAULT_MSG
    Poco_INCLUDE_DIR )

MARK_AS_ADVANCED ( Poco_INCLUDE_DIR )
