# Locate JsonSpirit library
# This module defines
#  Json_Spirit_FOUND
#  Json_Spirit_INCLUDE_DIR
#  Json_Spirit_LIBRARY_DIR
#  Json_Spirit_LIBRARY

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
FIND_PATH( Json_Spirit_LIBRARY_DIR json_spirit
    HINTS
    $ENV{JSONSPIRIT_DIR}
    PATH_SUFFIXES lib lib/json_spirit lib64 lib64/json_spirit
    PATHS
    /usr/local
    /usr )

# right now its only geared towards the common linux distros...
FIND_LIBRARY( Json_Spirit_LIBRARY json_spirit
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
