#pragma once

/**
 * An attempt to abstract some of the platform specific code that happens on
 * startup and shutdown.
 **/

#include "commonUtils/ISystemLayer.hpp"

#include <boost/program_options.hpp>

namespace boost
{
    namespace program_options
    {
        class variables_map;
    }
};

namespace projectnamespace { namespace commonSystemInit {

class CommonSystemInit
{
public:
    static CommonSystemInit(
        const std::string& appName, 
        boost::program_options::options_description& options);

    static int Main(int argc, char** argv);

private:
    // set up the command-line options to be used by the application.
    static void PopulateCommandLineOptions(
        boost::program_options::options_description& options);
    
    // logging is a non-platform specific system that all applications will expect
    // to be setup..
    static void InitialiseLoggingSystem();

    static bool StartUpAppLayer(const boost::program_options::variables_map& commandLineParams);

};

}}
