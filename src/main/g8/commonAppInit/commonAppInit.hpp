#pragma once

/**
 * An attempt to abstract some of the platform specific code that happens on
 * startup and shutdown.
 **/

#include <boost/program_options.hpp>

namespace boost
{
    namespace program_options
    {
        class variables_map;
    }
}

namespace $root_namespace;format="camel,lower"$ { namespace commonAppInit {

class CommonAppInit
{
public:
    static int Initialise(const boost::program_options::variables_map& commandLineArgs);

    // set up the command-line options to be used by the application.
    static void PopulateCommandLineOptions(
        boost::program_options::options_description& options);

    /// @brief primarily for the --help and --version options.
    /// @return true if the program should continue execution, false otherwise
    static bool HandleCommonOptions(
        const boost::program_options::options_description& options, 
        const boost::program_options::variables_map& vm);
    
private:
    // logging is a non-platform specific system that all applications will expect
    // to be setup..
    static void InitialiseLoggingSystem(const boost::program_options::variables_map& commandLineArgs);

    static bool StartUpAppLayer(const boost::program_options::variables_map& commandLineParams);

};

}}
