#!/usr/bin/python

from optparse import OptionParser, OptionGroup

import subprocess
#regex
import re

def versionString():
    return '1.0'

def usageString():
    return '%prog [options] hxxFilename cxxFilename\n\
    Where:\n\
        \'hxxFilename\' is the destination codegen file to write the header to\n\
        \'cxxFilename\' is the destination codegen file to write the information to\n\
\n\
    Generates a hxx/cxx pair that will embed versioning data in a C++ app'

def setopts():
    parser = OptionParser(usage=usageString(), version=versionString())

    parser.add_option('-v', '--verbose', action='store_true', dest='verbose', default=False,
        help='Verbose output')

    repoVersioningOptions = OptionGroup(
        parser,
        "Repo and Source control options",
        "Allows you to specify information required for embedding version info about your app")

    repoVersioningOptions.add_option('--git', type='string', dest='gitinfo', nargs=2,
        help='Info for getting the git versioning info, where GITEXE is the path to the git binary \
and REPO_PATH is the path to the repo from which the build is being made, if nothing is provided it will skip the git versioning',
        metavar='\"GITEXE REPO_PATH\"')

    parser.add_option_group(repoVersioningOptions)

    externalLibs = OptionGroup(
        parser,
        "External Libs",
        "Allows you to specify version numbers for external libraries that were built separately")

    externalLibs.add_option("--boost", type='string', dest='boostversion',
        help='Boost version.  Library providing a wide set of functionality to C++, http://www.boost.org/',
        metavar='VERSION')
    
    externalLibs.add_option("--hdf5", type='string', dest='hdf5version',
        help='HDF5 version.  Library that helps read and write to and from hdf5 files, a format that provides fast lookup to large collections of data, http://www.hdfgroup.org/HDF5/',
        metavar='VERSION')

    externalLibs.add_option("--json_spirit", type='string', dest='jsonspiritversion',
        help='Json Spirit version.  Library built on top of the Boost Spirit library providing the ability to build and parse JSON objects to and from strings',
        metavar='VERSION')
    
    externalLibs.add_option("--log4cplus", type='string', dest='log4cplusversion',
        help='Log4Cplus.  Logging library, http://log4cplus.sourceforge.net/',
        metavar='VERSION')
    
    externalLibs.add_option("--soci", type='string', dest='sociversion',
            help='Soci version.  Library providing database access functionality, http://soci.sourceforge.net',
        metavar='VERSION')

    externalLibs.add_option("--poco", type='string', dest='pocoversion',
        help='Poco version.  Library providing a wide set of networking functionality (e.g socket wrappers and http servers and clients) to C++, http://pocoproject.org',
        metavar='VERSION')
    
    parser.add_option_group(externalLibs)

    compilerInformation = OptionGroup(
        parser,
        "Compiler Options",
        "Information related to the compiler used to build the app")

    compilerInformation.add_option("--compilername", type='string', dest='compilername',
        help='The compiler/toolset used to build the app',
        metavar='NAME')

    compilerInformation.add_option("--compilerversion", type='string', dest='compilerversion',
        help='The version of the compiler used to build the app',
        metavar='VERSION')

    compilerInformation.add_option("--cflags", type='string', dest='cflags',
        help='The compiler flags that were used to build the binary',
        metavar='FLAGS')

    parser.add_option_group(compilerInformation)

    miscOpts = OptionGroup(parser, "Miscellaneous Options")

    miscOpts.add_option('--namespace', type='string', dest='namespace', default='projectnamespace',
        help='The namespace to put the versioning stuff in [default=\'%default\']',
        metavar='namespace')

    parser.add_option_group(miscOpts)

    return parser

def buildVersionString(
    gitRevId,
    gitBranch,
    gitBuildUser,
    boostVersion,
    hdf5Version,
    jsonSpiritVersion,
    log4cplusVersion,
    sociVersion,
    pocoVersion,
    compilerName,
    compilerVersion,
    cFlags):

    border = '-' * 61 + '\n'

    result = ''

    if gitRevId != None and gitBranch != None and gitBuildUser != None:
        result += 'Git Version Info:\n'
        result += '    Git Revision Id: ' + gitRevId + '\n'
        result += '    Git Build Branch: ' + gitBranch + '\n'
        result += '    Git Build User: ' + gitBuildUser + '\n\n'

    result += 'Library Info:\n' 

    if boostVersion != None:
        result += '    Boost Version: ' + boostVersion + '\n'

    if hdf5Version != None:
        result += '    HDF5 Version: ' + hdf5Version + '\n'

    if jsonSpiritVersion != None:
        result += '    Json Spirit Version: ' + jsonSpiritVersion + '\n'

    if log4cplusVersion != None:
        result += '    Log4cplus Version: ' + log4cplusVersion + '\n'

    if sociVersion != None:
        result += '    Soci Version: ' + sociVersion + '\n'

    if pocoVersion != None:
        result += '    Poco Version: ' + pocoVersion + '\n'

    result += '\n'

    result += 'Compiler Info:\n'

    if compilerName != None:
        result += '    Compiler: ' + compilerName + '\n'

    if compilerVersion != None:
        result += '    Compiler Version: ' + compilerVersion + '\n'

    if cFlags != None:
        result += '    Compile Flags: ' + cFlags + '\n'

    result = border + result + border

    return result

def buildHxxOutput(
    namespace,
    gitRevId,
    gitBranch,
    gitBuildUser,
    boostVersion,
    hdf5Version,
    jsonSpiritVersion,
    log4cplusVersion,
    sociVersion,
    pocoVersion,
    compilerName,
    compilerVersion,
    cFlags):

    result = ''

    result += '#pragma once\n'
    result += '\n'
    result += '/**\n'
    result += ' * This file is Auto generated, do not edit directly!\n'
    result += ' **/\n'
    result += '\n'
    result += '#include <string>\n'
    result += '\n'
    result += 'namespace ' + namespace + ' { namespace version {\n'
    result += '\n'
    result += 'namespace versionInfo\n'
    result += '{\n'

    result += '    // Versions are genned here at build time from values determined by cmake instead of building them from the macros in the respective library headers,\n'
    result += '    // this way it will have the library versions at cmake time for which the build was originally intended rather than whichever headers or shared libs\n' 
    result += '    // happen to be on the system at build time\n'
    
    result += '\n'


    if gitRevId != None:
        result += '    static const std::string GIT_REV_ID;\n'

    if gitBranch != None:
        result += '    static const std::string GIT_BRANCH;\n'

    if gitBuildUser != None:
        result += '    static const std::string GIT_BUILD_USER;\n'

    if boostVersion != None:
        result += '    static const std::string BOOST_VERSION;\n'

    if hdf5Version != None:
        result += '    static const std::string HDF5_VERSION;\n'

    if jsonSpiritVersion != None:
        result += '    static const std::string JSON_SPIRIT_VERSION;\n'

    if log4cplusVersion != None:
        result += '    static const std::string LOG4CPLUS_VERSION;\n'

    if sociVersion != None:
        result += '    static const std::string SOCI_VERSION;\n'

    if pocoVersion != None:
        result += '    static const std::string POCO_VERSION;\n'

    if compilerName != None:
        result += '    static const std::string COMPILER_NAME;\n'

    if compilerVersion != None:
        result += '    static const std::string COMPILER_VERSION;\n'

    if cFlags != None:
        result += '    static const std::string CFLAGS;\n'

    result += '}\n'
    result += '\n'
    result += 'static const std::string GetVersionString();\n'
    result += '\n'
    result += '}}\n'

    return result

def buildCxxOutput(
    headerName,
    namespace,
    gitRevId,
    gitBranch,
    gitBuildUser,
    boostVersion,
    hdf5Version,
    jsonSpiritVersion,
    log4cplusVersion,
    sociVersion,
    pocoVersion,
    compilerName,
    compilerVersion,
    cFlags):

    result = ''

    result += '/**\n'
    result += ' * This file is Auto generated, do not edit directly!\n'
    result += ' **/\n'
    result += '\n'
    result += '#include \"versioning/' + headerName + '\"\n'
    result += '\n'
    result += '#include <string>\n'
    result += '#include <sstream>\n'
    result += '\n'
    result += 'namespace ' + namespace + ' { namespace version {\n'
    result += '\n'
    result += 'namespace versionInfo\n'
    result += '{\n'

    result += '    // Versions are genned here at build time from values determined by cmake instead of building them from the macros in the respective library headers,\n'
    result += '    // this way it will have the library versions at cmake time for which the build was originally intended rather than whichever headers or shared libs\n' 
    result += '    // happen to be on the system at build time\n'
    
    result += '\n'


    if gitRevId != None:
        result += '    const std::string GIT_REV_ID(\"' + gitRevId + '\");\n'

    if gitBranch != None:
        result += '    const std::string GIT_BRANCH(\"' + gitBranch + '\");\n'

    if gitBuildUser != None:
        result += '    const std::string GIT_BUILD_USER(\"' + gitBuildUser + '\");\n'

    if boostVersion != None:
        result += '    const std::string BOOST_VERSION(\"' + boostVersion + '\");\n'

    if hdf5Version != None:
        result += '    const std::string HDF5_VERSION(\"' + hdf5Version + '\");\n'

    if jsonSpiritVersion != None:
        result += '    const std::string JSON_SPIRIT_VERSION(\"' +jsonSpiritVersion + '\");\n'

    if log4cplusVersion != None:
        result += '    const std::string LOG4CPLUS_VERSION(\"' + log4cplusVersion + '\");\n'

    if sociVersion != None:
        result += '    const std::string SOCI_VERSION(\"' + sociVersion + '\");\n'

    if pocoVersion != None:
        result += '    const std::string POCO_VERSION(\"' + pocoVersion + '\");\n'

    if compilerName != None:
        result += '    const std::string COMPILER_NAME(\"' + compilerName + '\");\n'

    if compilerVersion != None:
        result += '    const std::string COMPILER_VERSION(\"' + compilerVersion + '\");\n'

    if cFlags != None:
        result += '    const std::string CFLAGS(\"' + cFlags + '\");\n'

    result += '}\n'
    result += '\n'
    result += 'const std::string GetVersionString()\n'
    result += '{\n'
    result += '    std::string border(\"-------------------------------------------------------------\\n\");\n'
    result += '    std::stringstream result;\n'
    result += '\n'
    result += '    result << border;\n'
    result += '\n'
    result += '    result << \"Git Version Info: \\n\";\n'
    result += '\n'
    
    if gitRevId != None:
        result += '    result << \"    Git Rev Id: \" << versionInfo::GIT_REV_ID << \'\\n\';\n'

    if gitBranch != None:
        result += '    result << \"    Git Branch: \" << versionInfo::GIT_BRANCH << \'\\n\';\n'

    if gitBuildUser != None:
        result += '    result << \"    Git Build User: \" << versionInfo::GIT_BUILD_USER << \'\\n\';\n'

    result += '    result << \'\\n\';\n'
    result += '    result << \"Library Version Information:\\n\";\n'

    if boostVersion != None:
        result += '    result << \"    Boost Version: \" << versionInfo::BOOST_VERSION << \'\\n\';\n'

    if hdf5Version != None:
        result += '    result << \"    HDF5 Version: \" << versionInfo::HDF5_VERSION << \'\\n\';\n'

    if jsonSpiritVersion != None:
        result += '    result << \"    Json Spirit Version: \" << versionInfo::JSON_SPIRIT_VERSION << \'\\n\';\n'

    if log4cplusVersion != None:
        result += '    result << \"    Log4cplus Version: \" << versionInfo::LOG4CPLUS_VERSION << \'\\n\';\n'

    if sociVersion != None:
        result += '    result << \"    Soci Version: \" << versionInfo::SOCI_VERSION << \'\\n\';\n'

    if pocoVersion != None:
        result += '    result << \"    Poco Version: \" << versionInfo::POCO_VERSION << \'\\n\';\n'

    result += '    result << \'\\n\';\n'

    result += '    result << \"Compiler Information:\\n\";\n'

    if compilerName != None:
        result += '    result << \"    Compiler: \" << versionInfo::COMPILER_NAME << \'\\n\';\n'

    if compilerVersion != None:
        result += '    result << \"    Compiler Version: \" << versionInfo::COMPILER_VERSION << \'\\n\';\n'

    if cFlags != None:
        result += '    result << \"    Compiler Flags: \" << versionInfo::CFLAGS << \'\\n\';\n'

    result += '\n'
    result += '    result << border;\n'
    result += '\n'
    result += '    return result.str();\n'
    result += '}\n'
    result += '\n'
    result += '}}\n'

    return result


def main():

    parser = setopts()

    (options, args) = parser.parse_args()

    if len(args) != 2:
        parser.error('Invalid number of args, expected 2 args, received ' + str(len(args)))

    hxxFilename = args[0]
    cxxFilename = args[1]

    revId = None
    buildUser = None
    buildBranch = None

    if options.gitinfo != None:
        # NOTE (Dom De Re): interested in getting the (the ones with the '*' beside them are checked off):
        #   git revId *
        #   git branch name *
        #   git user who did the build *
        #   git remote? (I'm thinking no since its so common for there to be multiple
        #       remotes)
        revId = subprocess.check_output([options.gitinfo[0], 'rev-parse', 'HEAD'], cwd=options.gitinfo[1])[0:-1]

        # cut off the trailing '\n'
        buildUser = subprocess.check_output(
            [options.gitinfo[0], 'config', '--global', 'user.name'], 
            cwd=options.gitinfo[1])[0:-1] 

        currentBranchRegex = re.compile(r'^\* ')
        
        gitBranchOutput = subprocess.check_output(
            [options.gitinfo[0], 'branch'],
            cwd=options.gitinfo[1])

        for line in gitBranchOutput.split('\n'):
            matchResult = currentBranchRegex.match(line)
            if matchResult != None:
                # slice the matching part of the string off.
                buildBranch = line[matchResult.end():]
                break

    print(buildVersionString(
        revId,
        buildBranch,
        buildUser,
        options.boostversion,
        options.hdf5version,
        options.jsonspiritversion,
        options.log4cplusversion,
        options.sociversion,
        options.pocoversion,
        options.compilername,
        options.compilerversion,
        options.cflags)) 

    # construct and save out the header:

    print('Writing header to: %s' % (hxxFilename))
    
    try:
        with open(hxxFilename, 'w') as headerFile:
            headerFile.write(buildHxxOutput(
                options.namespace,
                revId,
                buildBranch,
                buildUser,
                options.boostversion,
                options.hdf5version,
                options.jsonspiritversion,
                options.log4cplusversion,
                options.sociversion,
                options.pocoversion,
                options.compilername,
                options.compilerversion,
                options.cflags)) 

    except IOError as fileError:
        print('Error (%d) opening file \'%s\': %s' % (fileError.args[0], hxxFilename, fileError.args[1]))
        exit(1)

    print('Writing cxx to: %s' % (cxxFilename))

    try:
        with open(cxxFilename, 'w') as cxxFile:
            cxxFile.write(buildCxxOutput(
                hxxFilename,
                options.namespace,
                revId,
                buildBranch,
                buildUser,
                options.boostversion,
                options.hdf5version,
                options.jsonspiritversion,
                options.log4cplusversion,
                options.sociversion,
                options.pocoversion,
                options.compilername,
                options.compilerversion,
                options.cflags))

    except IOError as fileError:
        print('Error (%d) opening file \'%s\': %s' % (fileError.args[0], cxxFilename, fileError.args[1]))
        exit(1)


    return

if __name__ == '__main__':
    main()
