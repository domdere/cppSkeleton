#include "appFW/consoleAppMain.hpp"

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
    return 0;
}

}
