# Adding Unit Tests

See `emptyTest/` for an explicit example.

In particular look at:

-   `emptyTest/CMakeLists.txt`:

    -   Register the executable as a unit test suite.  This will allow you to run all the unit tests from a sing
le target called `run-tests` in addition to adding a specific target to run the named test suite.

            # this registers the test suite to be run as part of the run-tests target
            # it also adds a "run-emptyTest" target that specifically only runs these tests.
            REGISTER_UNIT_TESTS( "emptyTest" )

    -   Link the Boost Test framework in:

            # Unit test suites need to be linked to the boost unit test framework
            TARGET_LINK_LIBRARIES ( emptyTest
                ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY} )

    -   `emptyTest/emptyTests.cpp`:
        -   One file like this for each test suite would be recommended
    -   `emptyTest/fixtureTemplate.hpp` and `emptyTest/fixtureTemplate.cpp`:
        -   If the test suite you are writing requires fixtures then these two files are worth glancing at for a starting point.
