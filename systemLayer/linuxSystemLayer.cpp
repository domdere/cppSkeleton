#include "linuxSystemLayer/linuxSystemLayer.hpp"

#include <sys/types.h>

namespace projectnamespace { namespace linuxsystemlayer {

LinuxSystemLayer::LinuxSystemLayer(const std::string& appName)
:
    BaseSystemLayer(appName)
{}    

void LinuxSystemLayer::SetSignalHandler(commonUtils::SignalHandler& signalHandler)
{
}

boost::uint32_t LinuxSystemLayer::GetThreadId() const
{
    return gettid();
}

bool LinuxSystemLayer::Init(const boost::program_options::variables_map& commandLineParams)
{
    return true;
}
    
bool LinuxSystemLayer::LoadSettings(const boost::program_options::variables_map& commandLineParams)
{
    return true;
}

bool Shutdown(const boost::program_options::variables_map& commandLineParams)
{
    return true;
}
};

}}
