IF (MSVC)
    SET ( SYSTEM_LAYER_CPP "windowsSystemLayer.cpp" )
    MESSAGE ( STATUS "MSVC detected, selecting to use ${SYSTEM_LAYER_CPP}" )
ELSE (MSVC)
    SET ( SYSTEM_LAYER_CPP "linuxSystemLayer.cpp" )
    MESSAGE ( STATUS "linux detected, selecting to use ${SYSTEM_LAYER_CPP}" )
ENDIF (MSVC)


ADD_LIBRARY( systemLayer 
    ${SYSTEM_LAYER_CPP}
    systemLayer.hpp )

TARGET_LINK_LIBRARIES( systemLayer
    commonUtils
    ${MiscLib} )
