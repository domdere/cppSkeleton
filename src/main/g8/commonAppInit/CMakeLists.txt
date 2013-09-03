ADD_LIBRARY( commonAppInit 
    commonAppInit.cpp commonAppInit.hpp )

TARGET_LINK_LIBRARIES( commonAppInit
    versioning
    ${Boost_PROGRAM_OPTIONS_LIBRARY}
    ${MiscLib} )

LINK_LOGGING( "commonAppInit" )
