#include "appFW/consoleAppMain.hpp"
#include "profiny/profiny.hpp"

#include <iostream>

namespace $root_namespace;format="camel,lower"$ {

void AddAppOptions(po::options_description& desc)
{
}

std::string GetApplicationName()
{
    return "$executable_name;format="camel"$";
}

int AppMain(const po::variables_map& vm)
{
    PROFINY_SCOPE

    return 0;
}

}
