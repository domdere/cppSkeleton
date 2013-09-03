#include "commonUtils/signalHandler.hpp"
#include "systemLayer/systemLayer.hpp"

namespace $root_namespace;format="camel,lower"$ { namespace systemlayer {

void SystemLayer::SetSignalHandler(commonUtils::SignalHandler& signalHandler)
{
}

boost::uint32_t SystemLayer::GetThreadId()
{
    // TODO
    return 0u;
}

bool SystemLayer::Init(const boost::program_options::variables_map& commandLineParams)
{
    return true;
}
    
bool SystemLayer::LoadSettings(const boost::program_options::variables_map& commandLineParams)
{
    return true;
}

bool SystemLayer::Shutdown(const boost::program_options::variables_map& commandLineParams)
{
    return true;
}

}}
