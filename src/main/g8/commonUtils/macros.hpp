#ifndef COMMONUTILS_MACROS_HPP__
#define COMMONUTILS_MACROS_HPP__

#ifdef __GNUC__

    #define LIKELY(x) __builtin_expect(!!(x), 1)
    #define UNLIKELY(x) __builtin_expect(!!(x), 0)

#else

    #define LIKELY(x) (x)
    #define UNLIKELY(x) (x)

#endif // __GNUC__

#endif // COMMONUTILS_MACROS_HPP__
