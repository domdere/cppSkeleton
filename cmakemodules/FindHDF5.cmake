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
    NAMES hdf5dll
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
    NAMES hdf5_cppdll
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

  FIND_PATH(HDF5_INCLUDE_DIR H5Cpp.h
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

IF(HDF5_LIBRARY AND HDF5_DEBUG_LIBRARY AND HDF5_CPP_LIBRARY AND HDF5_CPP_DEBUG_LIBRARY)
  SET(HDF5_LIBRARIES debug ${HDF5_DEBUG_LIBRARY} ${HDF5_CPP_DEBUG_LIBRARY} optimized ${HDF5_LIBRARY} ${HDF5_CPP_DEBUG_LIBRARY} CACHE STRING "HDF5 Libraries")
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(HDF5 DEFAULT_MSG HDF5_LIBRARIES HDF5_INCLUDE_DIR)

MARK_AS_ADVANCED(HDF5_INCLUDE_DIR HDF5_LIBRARIES)
