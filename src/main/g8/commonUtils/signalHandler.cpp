#include "commonUtils/signalHandler.hpp"

namespace $root_namespace;format="camel,lower"$ { namespace commonutils {

void SignalHandler::CommonHandler(int signal)
{
    // reset the handler.
    if (mResetSignalHandler)
    {
        mResetSignalHandler(signal);
    }
    else
    {
        // TODO: Log something with log4cplus?
    }

    if (mSignalToString)
    {
        // TODO: Log the signal we received...
    }

    // TODO: flush logging once its sorted out, since
    // this app might be going down pretty darn soon....

    return;
}

void SignalHandler::DefaultHandler(int signal)
{
    CommonHandler(signal);
    
    exit(33);
};

void SignalHandler::SigIntHandler(int signal)
{
    CommonHandler(signal);

    // TODO: Tell the app to shutdown gracefully...

    exit(34);
}

}}
