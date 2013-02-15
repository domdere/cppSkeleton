ADD_LIBRARY( commonAppInit 
    commonAppInit.cpp commonAppInit.hpp )

TARGET_LINK_LIBRARIES( commonAppInit
    ${LOG4CPLUS_LIBRARIES}
    ${Boost_PROGRAM_OPTIONS_LIBRARY}
    ${MiscLib} )
