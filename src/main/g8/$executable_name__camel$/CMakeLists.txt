SET ( $executable_name;format="camel"$Sources
    main.cpp )

ADD_EXECUTABLE ( $executable_name;format="camel"$
    \${$executable_name;format="camel"$Sources} )

# any third party libs that need to be present for linking,
# or any other lib targets within the main project that need to be built
# and linked in.
TARGET_LINK_LIBRARIES ( $executable_name;format="camel"$
    commonAppInit
    \${Boost_PROGRAM_OPTIONS_LIBRARY} )

LINK_PROFINY ( "$executable_name;format="camel"$" )
