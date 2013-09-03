ADD_LIBRARY( AppFW 
    appFW.cpp
    consoleAppMain.hpp )

TARGET_LINK_LIBRARIES( AppFW
    ${MiscLib} )
