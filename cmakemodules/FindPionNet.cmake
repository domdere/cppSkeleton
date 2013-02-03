# Locate PionNet library
# This module defines
#  PIONNET_FOUND
#  PIONNET_LIBRARIES
#  PIONNET_INCLUDE_DIR

FIND_PATH(PIONNET_INCLUDE_DIR pion/logger.hpp
  HINTS
  $ENV{PIONNET_DIR}
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

IF ( WIN32 )
    FIND_LIBRARY ( PIONNET_LIBRARY
        NAMES pion-net pion.lib
        HINTS
        $ENV{PIONNET_DIR}
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
ELSE ( WIN32 )
    FIND_LIBRARY ( PIONNET_LIBRARY
        NAMES pion-net libpion.a
        HINTS
        $ENV{PIONNET_DIR}
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
ENDIF ( WIN32 )

IF ( PIONNET_DEBUG )
    MESSAGE ( STATUS "Pion library: ${PIONNET_LIBRARY}, Pion Include: ${PIONNET_INCLUDE_DIR}" )
ENDIF ( PIONNET_DEBUG )

#FIND_LIBRARY(PIONCOMMON_LIBRARY
#  NAMES pion-common
#  HINTS
#  $ENV{PIONNET_DIR}
#  PATH_SUFFIXES lib64 lib
#  PATHS
#  ~/Library/Frameworks
#  /Library/Frameworks
#  /usr/local
#  /usr
#  /sw
#  /opt/local
#  /opt/csw
#  /opt
#)

#IF(PIONNET_LIBRARY AND PIONCOMMON_LIBRARY)
#    SET(PIONNET_LIBRARIES debug ${PIONNET_LIBRARY} ${PIONCOMMON_LIBRARY} optimized ${PIONNET_LIBRARY} ${PIONCOMMON_LIBRARY} CACHE STRING "PionNet Libraries")
#ENDIF()


IF ( PIONNET_LIBRARY )
    SET ( PIONNET_LIBRARIES debug ${PIONNET_LIBRARY} optimized ${PIONNET_LIBRARY} CACHE STRING "PionNet Libraries" )
ENDIF ( PIONNET_LIBRARY )

INCLUDE(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set PIONNET_FOUND to TRUE if
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PionNet DEFAULT_MSG PIONNET_LIBRARIES PIONNET_INCLUDE_DIR)

MARK_AS_ADVANCED(PIONNET_INCLUDE_DIR PIONNET_LIBRARIES)
