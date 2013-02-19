ADD_LIBRARY( commonAppInit 
    commonAppInit.cpp commonAppInit.hpp )

TARGET_LINK_LIBRARIES( commonAppInit
    versioning
    ${LOG4CPLUS_LIBRARIES}
    ${Boost_PROGRAM_OPTIONS_LIBRARY}
    ${MiscLib} )
