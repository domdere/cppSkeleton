#pragma once

/**
 * An attempt to abstract some of the linux/windows specific code that happens on
 * startup and shutdown.
 *
 * Depending on the system you are building on, cmake will select different implementations of this header to link in
 **/

namespace boost
{
    namespace program_options
    {
        class variables_map;
    }
}

namespace projectnamespace { namespace systemlayer {

namespace commonUtils
{
    class SignalHandler;
}

class SystemLayer
{
public:
    static void SetSignalHandler(commonUtils::SignalHandler& signalHandler);

    static boost::uint32_t GetThreadId();

private:

    /// \brief Initialise anything that the application layer is going to expect initialised beforehand.
    static bool Init(const boost::program_options::variables_map& commandLineParams);
    
    // Load any settings that might be needed to construct the app layer
    static bool LoadSettings(const boost::program_options::variables_map& commandLineParams);

    // Undo the stuff done in the system layer Init method,
    // called after the application layer has shutdown and returned the flow of execution.
    static bool Shutdown(const boost::program_options::variables_map& commandLineParams);
};

}}
