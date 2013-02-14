/**
 * An attempt to abstract some of the platform specific code that happens on
 * startup and shutdown.
 **/

#include "commonSystemInit/commonSystemInit.hpp"

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.hpp>
#include <log4cplus/configurator.h>

#include <boost/program_options.hpp>

namespace projectnamespace { namespace systemlayer {

CommonSystemInit::CommonSystemInit(const std::string& appName)
:
    mCommandLineOptions(appName)    

int CommonSystemInit::Main(int argc, char** argv)
{
    PopulateCommandLineOptions();    

    boost::program_options::variables_map commandLineParams;
    boost::program_options::store(
        boost::program_options::parse_command_line(argc, argv, mCommandLineOptions),
        commandLineParams);

    if (vm.count("help"))
    {
        std::cout << mCommandLineOptions << std::endl;
        return 0;
    }

    InitialiseLoggingSystem(commandLineParams);

    if (!Init(commandLineParams) ||
        !LoadSettings(commandLineParams) ||
        !StartUpAppLayer(commandLineParams))
    {
        Shutdown(commandLineParams);
        return 1;
    }

    // TODO: app layers main method.

    Shutdown(commandLineParams);

    // logging system apparently doesnt need any shutdown.... 

    return 0;
}

void CommonSystemInit::SetSignalHandler(commonUtils::SignalHandler& signalHandler)
{
}

boost::uint32_t CommonSystemInit::GetThreadId() const
{
}

void CommonSystemInit::PopulateCommandLineOptions()
{
}

// logging is a non-platform specific system that all applications will expect
// to be setup..
void CommonSystemInit::InitialiseLoggingSystem()
{
    log4cplus::BasicConfigurator configurator;
    configurator.configure();

    log4cplus::Logger logger = log4cplus::Logger::getInstance(LOG4CPLUS_TEXT("CommonSystemInit"));
    LOG4CPLUS_INFO(logger, LOG4CPLUS_TEXT("Logging system initialised...")); 
}

bool StartUpAppLayer(const boost::program_options::variables_map& commandLineParams)
{
    // TODO: create the app layer and run its Setup method.
    return true;
}

}}
