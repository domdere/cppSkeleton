#pragma once

/**
 * An attempt to abstract some of the linux specific code that happens on
 * startup and shutdown.
 **/

#include "systemLayer/BaseSystemLayer.hpp"

namespace projectnamespace { namespace linuxsystemlayer {

class LinuxSystemLayer : public systemlayer::BaseSystemLayer
{
public:
    LinuxSystemLayer(const std::string& appName);    

    virtual ~LinuxSystemLayer() {}

    // ISystemLayer Methods.

    virtual void SetSignalHandler(commonUtils::SignalHandler& signalHandler);

    virtual boost::uint32_t GetThreadId() const;

    // End ISystemLayer Methods.

private:

    // BaseSystemLayer Methods.

    /// \brief Initialise anything that the application layer is going to expect initialised beforehand.
    virtual bool Init(const boost::program_options::variables_map& commandLineParams);
    
    // Load any settings that might be needed to construct the app layer
    virtual bool LoadSettings(const boost::program_options::variables_map& commandLineParams);

    // Undo the stuff done in the system layer Init method,
    // called after the application layer has shutdown and returned the flow of execution.
    virtual bool Shutdown(const boost::program_options::variables_map& commandLineParams);

    // End BaseSystemLayer Methods.
};

}}
