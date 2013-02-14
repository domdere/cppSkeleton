#pragma once
#include "systemLayer/systemLayer.hpp"

#include <sys/types.h>

namespace projectnamespace { namespace systemlayer {

void SystemLayer::SetSignalHandler(commonUtils::SignalHandler& signalHandler)
{
}

boost::uint32_t SystemLayer::GetThreadId() const
{
    return gettid();
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
};

}}
