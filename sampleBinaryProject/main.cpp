#include "appFW/consoleAppMain.hpp"
#include "profiny/profiny.hpp"

#include "commonUtils/accumulators.hpp"
#include "parallel/mapreduce.hpp"

#include "boost/range/algorithm.hpp"

#include <algorithm>
#include <array>
#include <iostream>

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

    commonutils::accumulators::MonoidSum<boost::uint32_t> sum(0u);

    std::array<boost::uint32_t, 10> numbers;

    boost::uint32_t num = 0u;

    boost::generate(
        numbers,
        [&num] ()
        {
            return num++;
        });

    for (const auto elt : numbers)
    {
        std::cout << elt << std::endl;
    }

    const auto result = parallel::mapreduce(numbers, sum, [] (boost::uint32_t in) -> boost::uint32_t
    {
        int count = 0;
        for (int i = 0; i < 100000000; ++i)
        {
            count++;
        }

        return 2*in;
    },
    4,
    1);

    std::cout << "final sum: " << result.GetResult() << std::endl;

    return 0;
}

}
