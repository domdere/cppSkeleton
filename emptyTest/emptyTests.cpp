#include "emptyTest/fixtureTemplate.hpp"

#include <boost/test/unit_test.hpp>


namespace projectnamespace { namespace libname { namespace sublibname { namespace test {

// First arg is the name of the suite.
// Second arg is the name of the Fixture class
BOOST_FIXTURE_TEST_SUITE(ExampleTestSuite, FixtureTemplate)

// if you don't need any fixtures for the test suite,
// you can mark the start of the suite with:
// BOOST_AUTO_TEST_SUITE(ExampleTestSuite)

BOOST_AUTO_TEST_CASE(TestCase)
{
    BOOST_CHECK_MESSAGE(false, "Test cases have not been written yet.");
}


BOOST_AUTO_TEST_SUITE_END()

}}}} // namespace projectnamespace { namespace libname { namespace sublibname { namespace test {
