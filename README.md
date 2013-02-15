An empty project for starting a Cpp project from.

Comes with the following requirements (each can be removed to your taste).

(installation instructions provided below for libraries)

Libraries:
    Boost
    HDF5
    json_spirit
    log4cplus
    soci
    Poco

Apps/Executables:
    Python: Build system uses python to generate some of the codegen output
    Git: Versioning by default embeds Git version information from the repo you are building from

-----
Boost
-----

Currently trialed with version 1.53.0, built from source with the following command line options:

./b2 -j 4 --layout=versioned -s BZIP2_SOURCE=<path to bzip2 source> -s ZLIB_SOURCE=<path to zlib source> variant=debug,release threading=multi link=shared runtime-link=shared  toolset=gcc address-model=64 stage

obviously that requires you to download a copy of the bzip2 and zlib source, if you got the libraries on your machine already you can omit those, and I believe they arent required for windows machines either.

----
HDF5
----

(CMake: Yes)

Currently trialed with version 1.8.10-patch1

built with the following cmake options:

for the shared libs:

-DBUILD_SHARED_LIBS=ON -DHDF5_BUILD_CPP_LIB=ON -DHDF5_BUILD_HL_LIB=ON -DHDF5_ENABLE_THREADSAFE=ON

for the static libs:

-DBUILD_STATIC_EXECS=ON -DBUILD_SHARED_LIBS=OFF -DHDF5_BUILD_CPP_LIB=ON -DHDF5_BUILD_HL_LIB=ON -DHDF5_ENABLE_THREADSAFE=ON

-----------
json_spirit
-----------

(CMake: Yes)

Currently trialling with version 4.05 (it generally seems pretty stable, chances are this is still the latest version when you are reading this)

made a minor change to the CMakeList, it wasn't copying over the json_spirit_writer_options.h file over so i added it to the install:

$ diff CMakeLists.txt.old CMakeLists.txt
18c18,19
<   DESTINATION include)
---
>   ${CMAKE_SOURCE_DIR}/json_spirit/json_spirit_writer_options.h
>   DESTINATION include)

---------
log4cplus
---------

(CMake: Yes)

Currently building with version 1.1.1 

without any options it builds the shared libs.

add

-DBUILD_SHARED_LIBS:BOOL=FALSE to the command line to make it build static versions

----
soci
----

(CMake: Yes)

Currently building with version 3.1.0

Soci requires mysql-dev libs installed, in windows some environment variables might need to be specified for the cmake files to find it


for ubuntu:
sudo apt-get install libmysql++-dev

will suffice.

I add the -DSOCI_EMPTY:BOOL=FALSE command line parameter to stop it from building the empty soci backend, less clutter, remove that param if you
want to develop a SOCI backend perhaps...

instead of taking in a parameter at cmake time to decide between shared and static it has separate shared and static targets for you to choose from at build time..

----
Poco
----

(CMake: No, perhaps one of the few disappointing things about it so far)

currently built with version 1.4.6

Ubuntu/Linux:

    handy ./configure flags:

    --static : builds static libs, can be used in conjunction with --shared to build both types
    --shared : builds shared libs, can be used in conjunction with --static to build both types

    --cflags : additional flags you want to pass to the compiler, e.g "-Wall" and/or "-m64" 


`sudo make install` installs the libraries fine on ubuntu,

for windows, the ones you want are: Net, Util, XML and Foundation
