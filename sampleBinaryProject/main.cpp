#include "appFW/consoleAppMain.hpp"
#include "profiny/profiny.hpp"

#include "parallel/transform.hpp"

#include <boost/range/algorithm/generate.hpp>
#include <boost/range/algorithm/transform.hpp>

#include <array>
#include <iostream>
#include <vector>

namespace projectnamespace {

void AddAppOptions(po::options_description& desc)
{
}

std::string GetApplicationName()
{
    return "sampleBinaryProject";
}

int AppMain(const po::variables_map& vm)
{
    PROFINY_SCOPE

    std::vector<boost::uint32_t> mTest(1000000);

    boost::uint32_t counter = 0u;

    boost::generate(mTest, [&counter]() 
    {
        return counter++;
    });

    std::array<boost::uint32_t, 1000000> outArray;

    {
        PROFINY_SCOPE
        parallel::transform(mTest, outArray.data(), [] (boost::uint32_t in) -> boost::uint32_t
        {
            return 2 * in;
        },
        4,
        10);
    }

    return 0;
}

}
