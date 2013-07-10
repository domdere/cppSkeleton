CMAKE_MINIMUM_REQUIRED(  VERSION 2.8 )

# Change this project name to whatever you desire, will require that you go through
# and refactor all instances of PROJECTNAME_SOURCE_DIR and PROJECTNAME_BINARY_DIR though

PROJECT ( PROJECTNAME )

MESSAGE ( "*** Source directory detected as: ${PROJECTNAME_SOURCE_DIR}" )
MESSAGE ( "*** Build directory detected as: ${PROJECTNAME_BINARY_DIR}" ) 

SET ( ROOT_SRC_DIR "${PROJECTNAME_SOURCE_DIR}" )
SET ( ROOT_BIN_DIR "${PROJECTNAME_BINARY_DIR}" )

SET ( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${ROOT_SRC_DIR}/cmakemodules/") 

# valid values for CMAKE_BUILD_TYPE:
# -DCMAKE_BUILD_TYPE:STRING=Release
# -DCMAKE_BUILD_TYPE:STRING=Debug

IF ( NOT CMAKE_BUILD_TYPE )
    MESSAGE ( STATUS "Build Type: Unset, assuming Debug" )
    SET (CMAKE_BUILD_TYPE "Debug" )
ELSE ( NOT CMAKE_BUILD_TYPE )
    MESSAGE ( STATUS "Build Type: ${CMAKE_BUILD_TYPE}" )
ENDIF ( NOT CMAKE_BUILD_TYPE )

INCLUDE ( CheckTypeSize )

SET ( CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS}" )

# with profiny, if PROFINY_CALL_GRAPH_PROFILER is defined, its call graph mode is activated,
# if PROFINY_FLAT_PROFILER is defined, its flat profiler mode is activated,
# if neither is activated, profiling is off entirely.
# see https://code.google.com/p/profiny/wiki/WikiProfiny
#
OPTION ( CALL_GRAPH_PROFILING "Set to true to activate Profiny Call Graph Profiling" OFF)
OPTION ( FLAT_PROFILING "Set to true to activate Profiny Call Graph Profiling" OFF)

SET ( PROFILING "OFF" )

IF ( CALL_GRAPH_PROFILING AND FLAT_PROFILING )

    MESSAGE ( FATAL_ERROR "Cannot have both Call Graph Profiling and Flat Profiling Enabled, choose one.")

ENDIF ( CALL_GRAPH_PROFILING AND FLAT_PROFILING )

IF ( CALL_GRAPH_PROFILING )

    MESSAGE ( STATUS "Enabling Call Graph Profiling.." )
    ADD_DEFINITIONS ( -DPROFINY_CALL_GRAPH_PROFILER )
    SET ( PROFILING "ON" )

ENDIF ( CALL_GRAPH_PROFILING )

IF ( FLAT_PROFILING )

    MESSAGE ( STATUS "Enabling Flat Profiling.." )
    ADD_DEFINITIONS ( -DPROFINY_FLAT_PROFILER )
    SET ( PROFILING "ON" )

ENDIF ( FLAT_PROFILING )

# Note that profiny has link requirements, requires boost::system and boost::timer
MACRO ( LINK_PROFINY projectName )
    IF ( PROFILING STREQUAL "ON" )
        TARGET_LINK_LIBRARIES ( ${projectName} ${Boost_SYSTEM_LIBRARY} ${Boost_TIMER_LIBRARY} )
    ENDIF ( PROFILING STREQUAL "ON" )
ENDMACRO ( LINK_PROFINY projectName )

CHECK_TYPE_SIZE ( "void*" PTR_SIZE )

IF ( PTR_SIZE EQUAL 4 )
    SET ( IS32BIT TRUE )
    SET ( BITNESS "32-Bit" )
ELSE ( PTR_SIZE EQUAL 4 )
    SET ( IS32BIT FALSE )
    SET ( BITNESS "64-Bit" )
ENDIF ( PTR_SIZE EQUAL 4 )

MESSAGE ( STATUS "${BITNESS} system detected" )

MESSAGE ( STATUS "System Name: ${CMAKE_SYSTEM_NAME}" )

MACRO ( ADD_SUBPROJECT directory )
    MESSAGE ( STATUS "Adding subproject: ${directory}" )
    ADD_SUBDIRECTORY ( ${directory} )
ENDMACRO ( ADD_SUBPROJECT directory )

SET ( DESIRED_BOOST_VERSION "1_49_0" )

MACRO ( DISPLAY_BOOST_LIB_INFO )
    FOREACH ( component ${ARGN} )
        STRING ( TOUPPER ${component} upperComponent )
        
        IF ( Boost_${upperComponent}_FOUND )
            MESSAGE ( STATUS "${component} libs found at: ${Boost_${upperComponent}_LIBRARY}" )
            MESSAGE ( STATUS "${component} debug libs found at: ${Boost_${upperComponent}_LIBRARY_DEBUG}" )
            MESSAGE ( STATUS "${component} release libs found at: ${Boost_${upperComponent}_LIBRARY_RELEASE}" )
        ELSE ( Boost_${upperComponent}_FOUND )
            MESSAGE ( ERROR " ${component} libs NOT found!" )
        ENDIF ( Boost_${upperComponent}_FOUND )
    ENDFOREACH ( component ${ARGN} )
ENDMACRO ( DISPLAY_BOOST_LIB_INFO )

MACRO ( DISPLAY_POCO_LIB_INFO )
    IF (POCO_FOUND )
        MESSAGE ( STATUS "Poco version: ${Poco_VERSION_STRING}" )
        MESSAGE ( STATUS "Poco includes were found at: ${Poco_INCLUDE_DIR}" )
        MESSAGE ( STATUS "Poco libs were found at: ${Poco_LIBRARY_DIR}" )
        MESSAGE ( STATUS "Poco dynamic libs were found at: ${Poco_BINARY_DIR}" )
        MESSAGE ( STATUS "Poco libs found: ${Poco_LIBRARIES}" )

        FOREACH ( component ${ARGN} )
            STRING ( TOUPPER ${component} upperComponent )
            
            IF ( POCO_${upperComponent}_FOUND )
                MESSAGE ( STATUS "${component} lib found: ${Poco_${upperComponent}_LIBRARY}" )
            ELSE ( POCO_${upperComponent}_FOUND )
                MESSAGE ( ERROR " ${component} libs NOT found!" )
            ENDIF ( POCO_${upperComponent}_FOUND )
        ENDFOREACH ( component ${ARGN} )

    ELSE (POCO_FOUND )
        MESSAGE ( ERROR " Poco libs were NOT found! Try setting the Env variable POCO_ROOT to the directory containing the include and lib dirs for Poco..." )
    ENDIF (POCO_FOUND )

ENDMACRO ( DISPLAY_POCO_LIB_INFO )

MACRO ( DISPLAY_JSON_SPIRIT_LIB_INFO )
    IF (JSON_SPIRIT_FOUND )
        MESSAGE ( STATUS "Json Spirit version: " ${Json_Spirit_VERSION} )
        MESSAGE ( STATUS "Json Spirit includes were found at: " ${Json_Spirit_INCLUDE_DIR} )
        MESSAGE ( STATUS "Json Spirit lib(s) were found at: " ${Json_Spirit_LIBRARY_DIR} )
        MESSAGE ( STATUS "Json Spirit lib(s) found: " ${Json_Spirit_LIBRARY} )
    ELSE (JSON_SPIRIT_FOUND )
        MESSAGE ( ERROR " Json Spirit libs NOT found!" )
    ENDIF (JSON_SPIRIT_FOUND )
ENDMACRO ( DISPLAY_JSON_SPIRIT_LIB_INFO )

MACRO ( DISPLAY_SOCI_LIB_INFO )
    IF ( SOCI_FOUND )
        MESSAGE ( STATUS "Soci version: " ${SOCI_VERSION_STRING} )
        MESSAGE ( STATUS "Soci includes were found at: " ${SOCI_INCLUDE_DIR} )
        MESSAGE ( STATUS "Soci lib(s) found: " ${SOCI_LIBRARY} )
    ELSE (SOCI_FOUND )
        MESSAGE ( ERROR " Soci libs NOT found!" )
    ENDIF (SOCI_FOUND )
ENDMACRO ( DISPLAY_SOCI_LIB_INFO )

MACRO ( DISPLAY_LOG4CPLUS_LIB_INFO )
    IF (LOG4CPLUS_FOUND )
        MESSAGE ( STATUS "log4cplus version: " ${LOG4CPLUS_VERSION} )
        MESSAGE ( STATUS "log4cplus includes were found at: " ${LOG4CPLUS_INCLUDE_DIR} )
        MESSAGE ( STATUS "log4cplus lib(s) found: " ${LOG4CPLUS_LIBRARIES} )
    ELSE (LOG4CPLUS_FOUND )
        MESSAGE ( ERROR " log4cplus libs NOT found!" )
    ENDIF (LOG4CPLUS_FOUND )
ENDMACRO ( DISPLAY_LOG4CPLUS_LIB_INFO )

MACRO ( DISPLAY_HDF5_LIB_INFO )
    IF (HDF5_FOUND )
        MESSAGE ( STATUS "Hdf5 version: " ${HDF5_VERSION} )
        MESSAGE ( STATUS "Hdf5 includes were found at: " ${HDF5_INCLUDE_DIR} )
        MESSAGE ( STATUS "Hdf5 lib(s) found: " ${HDF5_LIBRARIES} )
    ELSE (HDF5_FOUND )
        MESSAGE ( ERROR " Hdf5 libs NOT found!" )
    ENDIF (HDF5_FOUND )
ENDMACRO ( DISPLAY_HDF5_LIB_INFO )

MACRO ( DISPLAY_PYTHON_INTERP_INFO )

    IF ( PYTHONINTERP_FOUND )
        MESSAGE ( STATUS "Python ${PYTHON_VERSION_STRING} Interpreter was found at ${PYTHON_EXECUTABLE}" )
    ELSE ( PYTHONINTERP_FOUND )
        MESSAGE ( ERROR "Python Interpreter was NOT found, the build process requires it." ) 
    ENDIF ( PYTHONINTERP_FOUND )

ENDMACRO ( DISPLAY_PYTHON_INTERP_INFO )

MACRO (DISPLAY_GIT_INFO )
    IF ( GIT_FOUND )
        MESSAGE ( STATUS "Git Vers.${GIT_VERSION_STRING} was found at: ${GIT_EXECUTABLE}" )
    ELSE ( GIT_FOUND )
        MESSAGE ( ERROR "Git was not found, its required for versioning" )
    ENDIF ( GIT_FOUND )
ENDMACRO (DISPLAY_GIT_INFO )

IF ( WIN32 )
    # need these for windows
    SET (MiscLib winmm.lib comctl32.lib)

    # need to set any special search paths for boost etc...?
ENDIF ( WIN32 )

IF ( ${CMAKE_SYSTEM_NAME} STREQUAL "Linux" )
    MESSAGE ( STATUS "Linux detected, telling compiler to link in pthreads..." )
    SET ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread" )
ENDIF ( ${CMAKE_SYSTEM_NAME} STREQUAL "Linux" )
 

MESSAGE ( STATUS "Searching for third party libraries...." )

MESSAGE ( STATUS "Any find package CMake modules you wish to use can go in: ${CMAKE_MODULE_PATH}" )

MESSAGE ( STATUS "Boost: " )
# Disable auto linking, its a bit of a pain in windows.
ADD_DEFINITIONS ( -DBOOST_ALL_NO_LIB )

# want to use static boost libs?
IF (WIN32)
    SET ( Boost_USE_STATIC_LIBS ON )
ENDIF (WIN32)

IF ( CMAKE_COMPILER_IS_GNUCXX )
    SET ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall" )
ENDIF ( CMAKE_COMPILER_IS_GNUCXX )

FIND_PACKAGE ( Boost REQUIRED COMPONENTS date_time thread unit_test_framework program_options system timer )

IF ( Boost_FOUND )
    MESSAGE ( STATUS "Boost includes were found at: ${Boost_INCLUDE_DIR}" )
    MESSAGE ( STATUS "Boost libs were found at: ${Boost_LIBRARY_DIRS}" )
    MESSAGE ( STATUS "" )

DISPLAY_BOOST_LIB_INFO ( date_time thread unit_test_framework program_options )

ELSE ( Boost_FOUND )
    MESSAGE ( ERROR " Boost libs were NOT found!" )
ENDIF ( Boost_FOUND )

MESSAGE (STATUS "Poco: " )

FIND_PACKAGE ( Poco REQUIRED COMPONENTS XML Net Util Foundation )

DISPLAY_POCO_LIB_INFO ( XML Net Util Foundation )

MESSAGE ( STATUS "Json Spirit: " )

FIND_PACKAGE ( JsonSpirit )

DISPLAY_JSON_SPIRIT_LIB_INFO ()

MESSAGE (STATUS "Soci: ")

IF ( IS32BIT )
    SET ( LIB_SUFFIX "32" )
ELSE ( IS32BIT )
    SET ( LIB_SUFFIX "64" )
ENDIF ( IS32BIT )

FIND_PACKAGE ( Soci  )

DISPLAY_SOCI_LIB_INFO ()

MESSAGE ( STATUS "Log4CPlus: " )

FIND_PACKAGE (Log4cplus REQUIRED )

DISPLAY_LOG4CPLUS_LIB_INFO ()

MESSAGE ( STATUS "HDF5: " )

FIND_PACKAGE ( HDF5 REQUIRED )

DISPLAY_HDF5_LIB_INFO ()

FIND_PACKAGE ( PythonInterp )

DISPLAY_PYTHON_INTERP_INFO ()

OPTION ( USE_GIT_FOR_VERSIONING "Set to true if building from a Git repo so git versioning info can be provided, switch off if building from an exported archive" ON)

IF ( USE_GIT_FOR_VERSIONING )
    FIND_PACKAGE( Git )
    
    # I'll leave the macro in just in case, but the find package for git actually displays the same info
    # macro below displays...
    #DISPLAY_GIT_INFO()
ENDIF ( USE_GIT_FOR_VERSIONING )

# Main include directories:
INCLUDE_DIRECTORIES (
    ${ROOT_SRC_DIR}
    ${ROOT_BIN_DIR}
    ${Boost_INCLUDE_DIR}
    ${Poco_INCLUDE_DIR}
    ${Json_Spirit_INCLUDE_DIR}
    ${SOCI_INCLUDE_DIR}
    ${LOG4CPLUS_INCLUDE_DIR}
    ${HDF5_INCLUDE_DIR} )

# I don't include ${Poco_BINARY_DIR} in the link directories because on linux it seems to get set
# to the include dir...
# (I havent tried it on windows yet)
# LINK_DIRECTORIES is not necessary, use TARGET_LINK_DIRECTORIES with
# the absolute paths to the libs instead
# LINK_DIRECTORIES (
#    ${Boost_LIBRARY_DIRS}
#    ${Poco_LIBRARY_DIR} )

#SET ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -lpthread -lm -dl -lz -Wl,-rpath,'\$ORIGIN'" )

IF ( CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX )

    SET ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -ggdb -g" )
    SET ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -ggdb -g" )

    SET ( CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -std=c99 -pedantic -Wall -Wextra -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -Wfloat-equal -Wmissing-format-attribute -Wmissing-noreturn -Wpacked -Wdisabled-optimization -Wformat=2 -Wendif-labels -Wdeclaration-after-statement -Wold-style-definition -Winvalid-pch -Wvariadic-macros -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wunused-macros -Wunsafe-loop-optimizations -Wc++-compat -Wstrict-overflow -Wlogical-op -Wlarger-than=2048 -Wvla -Wsync-nand -Wframe-larger-than=16384 -Wpacked-bitfield-compat -Wstrict-overflow=5 -Wjump-misses-init -Wunsuffixed-float-constants -Wdouble-promotion -Wsuggest-attribute=const -Wtrampolines -Wstack-usage=8192 -Wvector-operation-performance -O3 -fomit-frame-pointer -finline-functions -floop-parallelize-all -ftree-parallelize-loops=4")

    SET ( CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -std=c99 -pedantic -Wall -Wextra -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wredundant-decls -Wnested-externs -Winline -Wfloat-equal -Wmissing-format-attribute -Wmissing-noreturn -Wpacked -Wdisabled-optimization -Wformat=2 -Wendif-labels -Wdeclaration-after-statement -Wold-style-definition -Winvalid-pch -Wvariadic-macros -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wunused-macros -Wunsafe-loop-optimizations -Wc++-compat -Wstrict-overflow -Wlogical-op -Wlarger-than=2048 -Wvla -Wsync-nand -Wframe-larger-than=16384 -Wpacked-bitfield-compat -Wstrict-overflow=5 -Wjump-misses-init -Wunsuffixed-float-constants -Wdouble-promotion -Wsuggest-attribute=const -Wtrampolines -Wstack-usage=8192 -Wvector-operation-performance -O3 -fomit-frame-pointer -finline-functions -floop-parallelize-all -ftree-parallelize-loops=4")

    SET ( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -pedantic -Wall -Wextra -Wundef -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Wmissing-declarations -Wredundant-decls -Winline -Wfloat-equal -Wmissing-format-attribute -Wmissing-noreturn -Wpacked -Wdisabled-optimization -Wformat=2 -Wendif-labels -Winvalid-pch -Wvariadic-macros -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wunused-macros -Wunsafe-loop-optimizations -Wstrict-overflow -Wlogical-op -Wlarger-than=2048 -Wvla -Wsync-nand -Wframe-larger-than=16384 -Wpacked-bitfield-compat -Wstrict-overflow=5 -Wdouble-promotion -Wsuggest-attribute=const -Wtrampolines -Wstack-usage=8192 -Wvector-operation-performance -O3 -fomit-frame-pointer -finline-functions -floop-parallelize-all -ftree-parallelize-loops=4")

    SET ( CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -pedantic -Wall -Wextra -Wundef -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wwrite-strings -Wconversion -Wmissing-declarations -Wredundant-decls -Winline -Wfloat-equal -Wmissing-format-attribute -Wmissing-noreturn -Wpacked -Wdisabled-optimization -Wformat=2 -Wendif-labels -Winvalid-pch -Wvariadic-macros -Winit-self -Wmissing-include-dirs -Wswitch-default -Wswitch-enum -Wunused-macros -Wunsafe-loop-optimizations -Wstrict-overflow -Wlogical-op -Wlarger-than=2048 -Wvla -Wsync-nand -Wframe-larger-than=16384 -Wpacked-bitfield-compat -Wstrict-overflow=5 -Wdouble-promotion -Wsuggest-attribute=const -Wtrampolines -Wstack-usage=8192 -Wvector-operation-performance -O3 -fomit-frame-pointer -finline-functions -floop-parallelize-all -ftree-parallelize-loops=4")

ENDIF ( CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX )

# Sub Projects:
ADD_SUBPROJECT(appFW)
ADD_SUBPROJECT(commonUtils)
ADD_SUBPROJECT(commonAppInit)
ADD_SUBPROJECT(logging)
ADD_SUBPROJECT(profiny)
ADD_SUBPROJECT(sampleBinaryProject)
ADD_SUBPROJECT(systemLayer)
ADD_SUBPROJECT(versioning)

