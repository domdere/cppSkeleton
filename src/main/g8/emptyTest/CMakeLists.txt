ADD_EXECUTABLE ( emptyTest
    "emptyTests.cpp"
    "fixtureTemplate.cpp" "fixtureTemplate.hpp"
    "main.cpp" )

# Unit test suites need to be linked to the boost unit test framework
TARGET_LINK_LIBRARIES ( emptyTest
    \${Boost_UNIT_TEST_FRAMEWORK_LIBRARY} )

# this registers the test suite to be run as part of the run-tests target
# it also adds a "run-emptyTest" target that specifically only runs these tests.
REGISTER_UNIT_TESTS( "emptyTest" )

LINK_PROFINY ( "emptyTest" )
LINK_LOGGING ( "emptyTest" )
