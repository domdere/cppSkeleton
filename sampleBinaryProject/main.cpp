#include "appFW/consoleAppMain.hpp"
#include "profiny/profiny.hpp"

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

    return 0;
}

}
