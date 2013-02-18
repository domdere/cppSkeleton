#!/usr/bin/python

from optparse import OptionParser, OptionGroup

import subprocess
#regex
import re

def versionString():
    return '1.0'

def usageString():
    return '%prog [options] output\n\
    Where:\n\
        \'output\' is the destination codegen file to write this info to\n\
\n\
    Generates a cxx file that will embed versioning data in a C++ app'

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
    pocoVersion):

    border = '-' * 57 + '\n'

    result = ''

    if gitRevId != None and gitBranch != None and gitBuildUser != None:
        result += 'Git Revision Id: ' + gitRevId + '\n'
        result += 'Git Build Branch: ' + gitBranch + '\n'
        result += 'Git Build User: ' + gitBuildUser + '\n'

    if boostVersion != None:
        result += 'Boost Version: ' + boostVersion + '\n'

    if hdf5Version != None:
        result += 'HDF5 Version: ' + hdf5Version + '\n'

    if jsonSpiritVersion != None:
        result += 'Json Spirit Version: ' + jsonSpiritVersion + '\n'

    if log4cplusVersion != None:
        result += 'Log4cplus Version: ' + log4cplusVersion + '\n'

    if sociVersion != None:
        result += 'Soci Version: ' + sociVersion + '\n'

    if pocoVersion != None:
        result += 'Poco Version: ' + pocoVersion + '\n'

    result = border + result + border

    return result

def main():

    parser = setopts()

    (options, args) = parser.parse_args()

    if len(args) != 1:
        parser.error('Invalid number of args, expected 1 args, received ' + str(len(args)))

    outputFilename = args[0]

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
        options.pocoversion)) 

    return

if __name__ == '__main__':
    main()
