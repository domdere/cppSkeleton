# Locate JsonSpirit library
# This module defines
#  Json_Spirit_FOUND
#  Json_Spirit_INCLUDE_DIR
#  Json_Spirit_LIBRARY_DIR
#  Json_Spirit_LIBRARY


OPTION ( JSON_SPIRIT_DEBUG "Debug mode for Json spirit find package" OFF )

# defaults to ON because the default "make install" target for json built and installed
# static libs, library seems small and lightweight enough to warrant stati libs too
OPTION ( JSON_SPIRIT_USE_STATIC_LIBS "Options to use static json_spirit libs" ON )

FIND_PATH( Json_Spirit_INCLUDE_DIR json_spirit.h
    HINTS
    $ENV{JSONSPIRIT_DIR}
    PATH_SUFFIXES include include/json_spirit
    PATHS
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local
    /usr
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt )

# right now its only geared towards the common linux distros...

IF ( MSVC )
    # dont know what the library is named in windows i'll add it here once i give it a try...
ELSE ( MSVC )

    IF ( JSON_SPIRIT_USE_STATIC_LIBS )
        SET ( JSON_LIBRARY_NAME "libjson_spirit.a" )
    ELSE ( JSON_SPIRIT_USE_STATIC_LIBS )
        # not sure about this one either
        SET ( JSON_LIBRARY_NAME "libjson_spirit.so" )
    ENDIF ( JSON_SPIRIT_USE_STATIC_LIBS )

ENDIF ( MSVC )

IF (JSON_SPIRIT_DEBUG)
    MESSAGE ( STATUS "Looking for: ${JSON_LIBRARY_NAME}" )
ENDIF (JSON_SPIRIT_DEBUG)

FIND_PATH( Json_Spirit_LIBRARY_DIR ${JSON_LIBRARY_NAME}
    HINTS
    $ENV{JSONSPIRIT_DIR}
    PATH_SUFFIXES lib lib/json_spirit lib64 lib64/json_spirit
    PATHS
    /usr/local
    /usr )

# right now its only geared towards the common linux distros...
FIND_LIBRARY( Json_Spirit_LIBRARY ${JSON_LIBRARY_NAME}
    HINTS
    $ENV{JSONSPIRIT_DIR}
    PATH_SUFFIXES lib lib/json_spirit lib64 lib64/json_spirit
    PATHS
    /usr/local
    /usr )


INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(Json_Spirit DEFAULT_MSG 
	Json_Spirit_INCLUDE_DIR 
    Json_Spirit_LIBRARY_DIR 
    Json_Spirit_LIBRARY )

MARK_AS_ADVANCED(Json_Spirit_INCLUDE_DIR)
