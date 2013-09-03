#ifndef EMPTYTEST_FIXTURES_TEMPLATE_HPP__
#define EMPTYTEST_FIXTURES_TEMPLATE_HPP__

namespace projectnamespace { namespace libname { namespace sublibname { namespace test {

// One of these is required for every unique combination of fixtures you wish to build a test suite from.

class FixtureTemplate
{
public:
    FixtureTemplate();
    
    virtual ~FixtureTemplate();

protected:
    // Fixtures go here as data members of the fixtures class
    // as do any helper methods you wish to use form teh test cases.
    // each test case will be deriving from this class,
    // hence it has access to all public/protected members of this class.

private:
    // and you'll be able to hide stuff from the test cases here.
};

}}}} // namespace projectnamespace { namespace libname { namespace sublibname { namespace test {

#endif // EMPTYTEST_FIXTURES_TEMPLATE_HPP__
