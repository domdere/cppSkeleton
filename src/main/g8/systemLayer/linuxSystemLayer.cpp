#include "commonUtils/signalHandler.hpp"
#include "systemLayer/systemLayer.hpp"

#include <pthread.h>

namespace $root_namespace;format="camel,lower"$ { namespace systemlayer {

void SystemLayer::SetSignalHandler(commonUtils::SignalHandler& signalHandler)
{
}

boost::uint32_t SystemLayer::GetThreadId()
{
    return pthread_self();
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
