# Locate HDF5 library
# This module defines
#  HDF5_FOUND, if false, do not try to link to HDF5
#  HDF5_LIBRARIES
#  HDF5_INCLUDE_DIR, where to find h5cpp.h

IF(MSVC)

  FIND_PATH(HDF5_INCLUDE_DIR cpp/h5cpp.h
    HINTS
    $ENV{HDF5_DIR}
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


  FIND_LIBRARY(HDF5_LIBRARY
    NAMES hdf5dll.lib
    HINTS
    $ENV{HDF5_DIR}
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

  FIND_LIBRARY(HDF5_CPP_LIBRARY
    NAMES hdf5_cppdll.lib
    HINTS
    $ENV{HDF5_DIR}
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

  FIND_PATH(HDF5_INCLUDE_DIR cpp/H5Cpp.h
    HINTS
    $ENV{HDF5_DIR}
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

  FIND_LIBRARY(HDF5_LIBRARY
    NAMES hdf5
    HINTS
    $ENV{HDF5_DIR}
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

  FIND_LIBRARY(HDF5_CPP_LIBRARY
    NAMES hdf5_cpp
    HINTS
    $ENV{HDF5_DIR}
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

ENDIF(MSVC)

IF(MSVC)
  FIND_LIBRARY(HDF5_DEBUG_LIBRARY
    NAMES hdf5ddll
    HINTS
    $ENV{HDF5_DIR}
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

FIND_LIBRARY(HDF5_CPP_DEBUG_LIBRARY
  NAMES hdf5_cppddll
  HINTS
  $ENV{HDF5_DIR}
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
  SET(HDF5_DEBUG_LIBRARY ${HDF5_LIBRARY})
  SET(HDF5_CPP_DEBUG_LIBRARY ${HDF5_CPP_LIBRARY})
ENDIF(MSVC)

IF ( NOT HDF5_DEBUG_LIBRARY )
    SET ( HDF5_DEBUG_LIBRARY ${HDF5_LIBRARY} )
ENDIF ( NOT HDF5_DEBUG_LIBRARY )

IF ( NOT HDF5_CPP_DEBUG_LIBRARY )
    SET ( HDF5_CPP_DEBUG_LIBRARY ${HDF5_CPP_LIBRARY} )
ENDIF ( NOT HDF5_CPP_DEBUG_LIBRARY )

# Determine the version of the HDF5 libs from H5public.h

SET ( HDF5_MAJOR_VERSION 0 )
SET ( HDF5_MINOR_VERSION 0 )
SET ( HDF5_RELEASE_VERSION 0 )
SET ( HDF5_PATCH_VERSION "" )

FILE ( STRINGS "${HDF5_INCLUDE_DIR}/H5public.h" HDF5_VERSION_H_CONTENTS REGEX "#define H5_VERS_MAJOR" )

IF ( HDF5_DEBUG )
    MESSAGE ( STATUS "[${CMAKE_CURRENT_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}]: looking for HDF5 version in ${HDF5_INCLUDE_DIR}/H5public.h" )
ENDIF ( HDF5_DEBUG )

STRING ( REGEX REPLACE ".*#define H5_VERS_MAJOR[^0-9]*([0-9]+).*" "\\1" HDF5_MAJOR_VERSION "${HDF5_VERSION_H_CONTENTS}")

FILE ( STRINGS "${HDF5_INCLUDE_DIR}/H5public.h" HDF5_VERSION_H_CONTENTS REGEX "#define H5_VERS_MINOR" )

STRING ( REGEX REPLACE ".*#define H5_VERS_MINOR[^0-9]*([0-9]+).*" "\\1" HDF5_MINOR_VERSION "${HDF5_VERSION_H_CONTENTS}")

FILE ( STRINGS "${HDF5_INCLUDE_DIR}/H5public.h" HDF5_VERSION_H_CONTENTS REGEX "#define H5_VERS_RELEASE" )

STRING ( REGEX REPLACE ".*#define H5_VERS_RELEASE[^0-9]*([0-9]+).*" "\\1" HDF5_RELEASE_VERSION "${HDF5_VERSION_H_CONTENTS}")

IF ( HDF5_DEBUG )
    MESSAGE ( STATUS "HDF5_VERSION_H_CONTENTS=${HDF5_VERSION_H_CONTENTS}")
    MESSAGE ( STATUS "HDF5_RELEASE_VERSION=${HDF5_RELEASE_VERSION}")
ENDIF ( HDF5_DEBUG )


FILE ( STRINGS "${HDF5_INCLUDE_DIR}/H5public.h" HDF5_VERSION_H_CONTENTS REGEX "#define H5_VERS_SUBRELEASE" )

IF ( NOT HDF5_VERSION_H_CONTENTS STREQUAL "" )
    STRING ( REGEX REPLACE ".*#define H5_VERS_SUBRELEASE.*\\\"([a-zA-Z0-9]+)\\\".*" "\\1" HDF5_PATCH_VERSION "${HDF5_VERSION_H_CONTENTS}")
    
    SET ( HDF5_VERSION "${HDF5_MAJOR_VERSION}.${HDF5_MINOR_VERSION}.${HDF5_RELEASE_VERSION}-${HDF5_PATCH_VERSION}")
ELSE ( NOT HDF5_VERSION_H_CONTENTS STREQUAL "" )
    SET ( HDF5_VERSION "${HDF5_MAJOR_VERSION}.${HDF5_MINOR_VERSION}.${HDF5_RELEASE_VERSION}")
ENDIF ( NOT HDF5_VERSION_H_CONTENTS STREQUAL "" )


SET (HDF5_VERSION ${HDF5_VERSION} CACHE INTERNAL "The version number for the HDF5 Libraries" )

IF(HDF5_LIBRARY AND HDF5_DEBUG_LIBRARY AND HDF5_CPP_LIBRARY AND HDF5_CPP_DEBUG_LIBRARY)
  SET(HDF5_LIBRARIES debug ${HDF5_DEBUG_LIBRARY} ${HDF5_CPP_DEBUG_LIBRARY} optimized ${HDF5_LIBRARY} ${HDF5_CPP_DEBUG_LIBRARY} CACHE STRING "HDF5 Libraries")
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(HDF5 DEFAULT_MSG HDF5_LIBRARIES HDF5_INCLUDE_DIR)

MARK_AS_ADVANCED(HDF5_INCLUDE_DIR HDF5_LIBRARIES)
