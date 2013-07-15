#ifndef LOGGING_MACROS_HPP_
#define LOGGING_MACROS_HPP_

#include <log4cplus/logger.h>
#include <log4cplus/loggingmacros.h>

#define LOG_INFO LOG4CPLUS_INFO 
#define LOG_DEBUG LOG4CPLUS_DEBUG
#define LOG_ERROR LOG4CPLUS_ERROR

#define LOG_TEXT LOG4CPLUS_TEXT

#define GET_LOGGER_INSTANCE(instanceName, name) log4cplus::Logger instanceName = log4cplus::Logger::getInstance(LOG_TEXT(#name))

#endif // LOGGING_MACROS_HPP_
