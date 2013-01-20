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

namespace projectnamespace { namespace systemlayer {

class BaseSystemLayer : public ISystemLayer
{
public:
    BaseSystemLayer(const std::string& appName);    

    virtual ~BaseSystemLayer() {}

    // ISystemLayer Methods.

    virtual int Main(int argc, char** argv);

    virtual void SetSignalHandler(commonUtils::SignalHandler& signalHandler) = 0;

    virtual boost::uint32_t GetThreadId() const = 0;

    // End ISystemLayer Methods.

private:
    // set up the command-line options to be used by the application.
    void PopulateCommandLineOptions();
    
    // logging is a non-platform specific system that all applications will expect
    // to be setup..
    void InitialiseLoggingSystem();

    /// \brief Initialise anything that the application layer is going to expect initialised beforehand.
    virtual bool Init(const boost::program_options::variables_map& commandLineParams) = 0;
    
    // Load any settings that might be needed to construct the app layer
    virtual bool LoadSettings(const boost::program_options::variables_map& commandLineParams) = 0;

    // Undo the stuff done in the system layer Init method,
    // called after the application layer has shutdown and returned the flow of execution.
    virtual bool Shutdown(const boost::program_options::variables_map& commandLineParams) = 0;

    bool StartUpAppLayer(const boost::program_options::variables_map& commandLineParams);

    // command line options.
    boost::program_options::options_description mOptionsDescription;

    // The Application Layer..
};

}}
