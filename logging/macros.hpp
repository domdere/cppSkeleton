#ifndef LOGGING_MACROS_HPP_
#define LOGGING_MACROS_HPP_

#ifndef NO_LOGGING

    #include <log4cplus/logger.h>
    #include <log4cplus/loggingmacros.h>
    #include <log4cplus/configurator.h>

    #define LOG_INFO LOG4CPLUS_INFO 
    #define LOG_DEBUG LOG4CPLUS_DEBUG
    #define LOG_ERROR LOG4CPLUS_ERROR

    #define LOG_TEXT LOG4CPLUS_TEXT

    #define GET_LOGGER_INSTANCE(instanceName, name) log4cplus::Logger instanceName = log4cplus::Logger::getInstance(LOG_TEXT(#name))

    #define INITIALISE_LOGGING_BASIC log4cplus::BasicConfigurator; configurator.configure();

#else // NO_LOGGING

    #define LOG_INFO
    #define LOG_DEBUG
    #define LOG_ERROR

    #define LOG_TEXT

    #define GET_LOGGER_INSTANCE(instanceName, name)

    #define INITIALISE_LOGGING_BASIC

#endif // NO_LOGGING

#endif // LOGGING_MACROS_HPP_
