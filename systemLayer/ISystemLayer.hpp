#pragma once

/**
 * An attempt to abstract some of the platform specific code that happens on
 * startup and shutdown.
 **/

#include "commonUtils/signalHandler.hpp"

namespace projectnamespace { namespace systemlayer {

class ISystemLayer
{
public:
    virtual ~ISystemLayer() {}

    virtual int Main(int argc, char** argv) = 0;

    // sets the priority of the process.
    virtual bool SetProcessPriority(void* start, unsigned int size) = 0;

    virtual void SetSignalHandler(commonUtils::SignalHandler& signalHandler) = 0;

    virtual boost::uint32_t GetThreadId() const = 0;
};

}}
