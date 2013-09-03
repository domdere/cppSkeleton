#ifdef INCLUDE_PROFINY

    #include "profiny.h"

#else
    #define PROFINY_SCOPE
    #define PROFINY_SCOPE_WITH_ID(ID)
    #define PROFINY_NAMED_SCOPE(NAME)
    #define PROFINY_NAMED_SCOPE_WITH_ID(NAME, ID)
#endif
