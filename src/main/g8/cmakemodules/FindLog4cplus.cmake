# Locate Log4cplus library
# This module defines
#  LOG4CPLUS_FOUND, if false, do not try to link to Log4cplus
#  LOG4CPLUS_LIBRARIES
#  LOG4CPLUS_INCLUDE_DIR, where to find log4cplus.hpp
#  LOG4CPLUS_VERSION

FIND_PATH(LOG4CPLUS_INCLUDE_DIR log4cplus/logger.h
  HINTS
    $ENV{LOG4CPLUS_DIR}
    ${LOG4CPLUS_DIR}
  PATH_SUFFIXES include
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
)

FIND_LIBRARY(LOG4CPLUS_LIBRARY
  NAMES log4cplus log4cplus.lib
  HINTS
      $ENV{LOG4CPLUS_DIR}
      ${LOG4CPLUS_DIR}
  PATH_SUFFIXES lib64 lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw
  /opt/local
  /opt/csw
  /opt
)

OPTION (LOG4CPLUS_DEBUG "Debug mode for the CMake FindLog4Cplus module." OFF)

IF ( LOG4CPLUS_DEBUG )
    MESSAGE ( STATUS "Includes: ${LOG4CPLUS_INCLUDE_DIR}" )
    MESSAGE ( STATUS "Library: ${LOG4CPLUS_LIBRARY}" )
ENDIF ( LOG4CPLUS_DEBUG )

IF(MSVC)
  FIND_LIBRARY(LOG4CPLUS_DEBUG_LIBRARY
    NAMES log4cplusD
    HINTS
        $ENV{LOG4CPLUS_DIR}
        ${LOG4CPLUS_DIR}
    PATH_SUFFIXES lib64 lib
    PATHS
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local
    /usr
    /sw
    /opt/local
    /opt/csw
    /opt
  )
ELSE(MSVC)
  SET(LOG4CPLUS_DEBUG_LIBRARY ${LOG4CPLUS_LIBRARY})
ENDIF(MSVC)

IF(LOG4CPLUS_LIBRARY AND LOG4CPLUS_DEBUG_LIBRARY)
  SET(LOG4CPLUS_LIBRARIES debug ${LOG4CPLUS_DEBUG_LIBRARY} optimized ${LOG4CPLUS_LIBRARY} CACHE STRING "Log4cplus Libraries")
ENDIF()

# Determine the version of log4cplus from log4cplus/version.h

SET ( LOG4CPLUS_VERSION 0 )

# log4cplus does something a little convoluted in their version.h header.
# they define a macro to create the version #define and the string #define,
# we'll have to pull the version info out of the macro call...
# e.g #define LOG4CPLUS_VERSION LOG4CPLUS_MAKE_VERSION(1, 0, 4)
FILE ( STRINGS "${LOG4CPLUS_INCLUDE_DIR}/log4cplus/version.h" LOG4CPLUS_VERSION_H_CONTENTS REGEX "#define LOG4CPLUS_VERSION LOG4CPLUS_MAKE_VERSION" )

# At this stage, LOG4CPLUS_VERSION_H_CONTENTS should look something like this:
# #define LOG4CPLUS_VERSION LOG4CPLUS_MAKE_VERSION(1, 0, 4)

IF ( LOG4CPLUS_DEBUG )
    MESSAGE ( STATUS "[${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}]: looking for Log4Cplus version in ${LOG4CPLUS_INCLUDE_DIR}/log4cplus/version.h" )
    MESSAGE ( STATUS "[${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}]: ${LOG4CPLUS_INCLUDE_DIR}/log4cplus/version.h contents: ${LOG4CPLUS_VERSION_H_CONTENTS}" )
ENDIF ( LOG4CPLUS_DEBUG )

STRING ( REGEX REPLACE ".*#define LOG4CPLUS_VERSION LOG4CPLUS_MAKE_VERSION.([0-9, ]+)..*" "\\1" LOG4CPLUS_VERSION "${LOG4CPLUS_VERSION_H_CONTENTS}")

# At this point LOG4CPLUS_VERSION should look something like this:
# "1, 0, 4"

IF ( LOG4CPLUS_DEBUG )
    MESSAGE ( STATUS "[${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}]: LOG4CPLUS_VERSION: ${LOG4CPLUS_VERSION}" )
ENDIF ( LOG4CPLUS_DEBUG )

# Now replace the ", "s with "."s
STRING ( REGEX REPLACE ", " "." LOG4CPLUS_VERSION "${LOG4CPLUS_VERSION}")

# now it should be something like this:
# "1.0.4"

SET (LOG4CPLUS_VERSION ${LOG4CPLUS_VERSION} CACHE INTERNAL "The version number for the Log4cplus Libraries" )



INCLUDE(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set LOG4CPLUS_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Log4cplus DEFAULT_MSG LOG4CPLUS_LIBRARIES LOG4CPLUS_INCLUDE_DIR)

MARK_AS_ADVANCED(LOG4CPLUS_INCLUDE_DIR LOG4CPLUS_LIBRARIES LOG4CPLUS_LIBRARY)
