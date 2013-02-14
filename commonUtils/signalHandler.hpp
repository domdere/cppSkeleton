#ifndef SIGNAL_HANDLER_HPP__
#define SIGNAL_HANDLER_HPP__

#include <boost/function.hpp>

namespace projectname { namespace commonutils {

class SignalHandler 
{
public:
    typedef boost::function<void (int)> ResetSignalCallback;
    typedef boost::function<const char* (int)> SignalToStringConversionCallback;	

    void CommonHandler(int signal);

    void DefaultHandler(int signal);

    void SigIntHandler(int signal);

    void SetResetSignalHandler(const ResetSignalCallback& callback) { mResetSignalHandler = callback; }

    void SetSignalToStringFunctor(const SignalToStringConversionCallback& functor)
    {
        mSignalToString = functor;
    }

private:
    ResetSignalCallback mResetSignalHandler;
    SignalToStringConversionCallback mSignalToString;
};

}}

#endif // SIGNAL_HANDLER_HPP__
