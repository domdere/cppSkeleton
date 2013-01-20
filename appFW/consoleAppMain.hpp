/**
 * Includes basic setup code that all console/commandline apps
 * and a place to hide any platform specific stuff that might 
 * come up before getting into the common code
 **/

#include <string>

namespace projectnamespace {

// All apps might use a standard output for "-h", so it would be handy for each app to have a
// name defined to insert in that output.
std::string GetApplicationName();

int AppMain(int argc, char** argv);

}

int main(int argc, char** argv)
{
    // for now all this does is call a main function that the app will define,
    // but eventually i may get all the system level initialisation to occur inside
    // one class and call that instead, with the app plugging into that class.

    projectnamespace::AppMain(argc, argv);
}

