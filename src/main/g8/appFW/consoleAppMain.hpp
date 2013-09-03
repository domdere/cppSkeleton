/**
 * Includes basic setup code that all console/commandline apps
 * and a place to hide any platform specific stuff that might 
 * come up before getting into the common code
 **/

#include "commonAppInit/commonAppInit.hpp"

#include <boost/program_options.hpp>

#include <string>

namespace po = boost::program_options;

namespace projectnamespace {

// All apps might use a standard output for "-h", so it would be handy for each app to have a
// name defined to insert in that output.
std::string GetApplicationName();

void AddAppOptions(po::options_description& desc);

int AppMain(const po::variables_map& vm);

}

int main(int argc, char** argv)
{
    namespace ns = projectnamespace;

    // for now all this does is call a main function that the app will define,
    // but eventually i may get all the system level initialisation to occur inside
    // one class and call that instead, with the app plugging into that class.

    po::options_description options(projectnamespace::GetApplicationName());

    ns::commonAppInit::CommonAppInit::PopulateCommandLineOptions(options);

    ns::AddAppOptions(options);

    po::variables_map vm;
    po::store(
        boost::program_options::parse_command_line(argc, argv, options),
        vm);

    po::notify(vm);

    if (!ns::commonAppInit::CommonAppInit::HandleCommonOptions(options, vm))
    {
        return 0;
    }

    ns::commonAppInit::CommonAppInit::Initialise(vm);

    ns::AppMain(vm);
}

