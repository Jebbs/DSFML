/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2017 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 */

module build;

import std.stdio;
import std.file;
import std.process;
import std.algorithm;
import std.array;
import std.getopt;

static if (__VERSION__ < 2068L)
{
	static assert(0, "Please upgrade your compiler to v2.068 or later");
}

version(DigitalMars)
{
    string compiler = "dmd ";
}
else version(GNU)
{
    string compiler = "gdc ";
}
else version(LDC)
{
    string compiler = "ldc2 ";
}
else
{
    static assert(false, "Unknown or unsupported compiler.");
}

//build settings
string prefix;
string postfix;
string extension;
string linkerInclude;
string libSwitches;
string docSwitches;
string interfaceSwitches;
string unittestSwitches;

//switch settings
bool buildingLibs;
bool buildingInterfaceFiles;
bool buildingDoc;
bool buildingWebsiteDocs;
bool debugLibs;
bool force32Build;
bool force64Build;

bool buildingUnittests;
string unittestLibraryLocation;

bool buildingAll;

bool hasUnrecognizedSwitch;
string unrecognizedSwitch;

string makefileType;
string makefileProgram;
string objExt;
string singleFileSwitches;
string archSwitch;


//Possibly use this to completely automate the process for dmd/ldc users on windows
//environment.get("VCINSTALLDIR");
//will need to find an alternative for gdc users on windows in regards to mingw

version(Windows)
{
}
else version(linux)
{
}
else version(OSX)
{
}
//FreeBSD Support coming soon!
else
{
    static assert(false, "DSFML is only supported on OSX, Windows, and Linux.");
}


string[5] modules = ["system", "audio", "network", "window", "graphics"];
string selectedModule;

//lists of d files and c++ object files
string[][string] fileList;
string[string] objectList;


/**
 * Checks for any inconsistencies with the passed switchs.
 *
 * Returns: true if no errors were found, false otherwise.
 */
bool checkSwitchErrors()
{
    //can't force both
    if(force32Build && force64Build)
    {
        writeln("Can't use -m32 and -m64 together");
        return false;
    }

    //if other Switchs are used with -all
    if(buildingAll)
    {
        if(buildingLibs || buildingDoc ||
           buildingInterfaceFiles || buildingUnittests)
        {
            writeln("Can't use -all with any other build switches ",
                    "(-lib, -doc, -import, -unittest)");

            return false;
        }
    }

    return true;
}

//initialize all build settings
void initialize()
{
    archSwitch = "";
    postfix = "";

    if(force32Build)
    {
        archSwitch = " -m32";
    }

    if(force64Build)
    {
        archSwitch = " -m64";
    }

    version (Windows)
    {
        write("Building for Windows ");
        prefix = "";
        extension = ".lib";
        objExt = ".obj";

        //Default to 64 bit on windows because why wouldn't we?
        if(!force64Build || !force32Build)
        {
            archSwitch = " -m64";
        }

        if(force32Build)
        {
            archSwitch = " -m32mscoff";
        }

        makefileProgram = "nmake";
        makefileType = `"NMake Makefiles"`;
        linkerInclude = "";
    }
    else
    {
        version(linux)
            write("Building for Linux ");
        else
            write("Building for OSX ");

        prefix = "lib";
        extension = ".a";
        objExt = ".o";

        makefileProgram = "make";
        makefileType = `"Unix Makefiles"`;
    }

    version(DigitalMars)
    {
        writeln("with dmd");
        initializeDMD();
    }
    else version(GNU)
    {
        writeln("with gdc");
        initializeGDC();
    }
    else version(LDC)
    {
        writeln("with ldc");
        initializeLDC();
    }

    // add links to the SFML files for building the unit tests
    unittestSwitches ~= lib("sfml-graphics")~lib("sfml-window")~
                        lib("sfml-audio")~lib("sfml-network")~
                        lib("sfml-system");

    //need to link to c++ standard library on these systems
    version(Posix)
    {
        unittestSwitches ~= lib("stdc++");
    }

    //Does OSX need to include rpath for unittests?

    //populate file lists
    fileList["system"] = ["clock", "config", "err", "inputstream", "lock",
                          "mutex", "package", "sleep", "string", "thread",
                          "time", "vector2", "vector3"];

    fileList["audio"] = ["listener", "music", "package", "sound",
                         "soundbuffer", "soundbufferrecorder",
                         "inputsoundfile", "outputsoundfile",
                         "soundrecorder", "soundsource", "soundstream"];

    fileList["network"] = ["ftp", "http", "ipaddress", "package",
                           "packet", "socket", "socketselector",
                           "tcplistener", "tcpsocket", "udpsocket"];

    fileList["window"] = ["context", "contextsettings", "event", "joystick",
                          "keyboard", "mouse", "sensor", "touch", "package",
                          "videomode", "window", "windowhandle"];

    fileList["graphics"] = ["blendmode", "circleshape", "color", "convexshape",
                            "drawable", "font", "glsl", "glyph", "image",
                            "package", "primitivetype", "rect",
                            "rectangleshape", "renderstates", "rendertarget",
                            "rendertexture", "renderwindow", "shader", "shape",
                            "sprite", "text", "texture", "transform",
                            "transformable", "vertex", "vertexarray", "view"];

    //populate C++ object list
    string dir = "src/DSFMLC/System/CMakeFiles/dsfmlc-system.dir/";
    objectList["system"] = dir~"Err.cpp"~objExt~" "~
                           dir~"ErrStream.cpp"~objExt~" "~
                           dir~"String.cpp"~objExt~" ";

    dir = "src/DSFMLC/Audio/CMakeFiles/dsfmlc-audio.dir/";
    objectList["audio"] = dir~"InputSoundFile.cpp"~objExt~" "~
                          dir~"Listener.cpp"~objExt~" "~
                          dir~"OutputSoundFile.cpp"~objExt~" "~
                          dir~"Sound.cpp"~objExt~" "~
                          dir~"SoundBuffer.cpp"~objExt~" "~
                          dir~"SoundRecorder.cpp"~objExt~" "~
                          dir~"SoundStream.cpp"~objExt~" ";

    dir = "src/DSFMLC/Network/CMakeFiles/dsfmlc-network.dir/";
    objectList["network"] = dir~"Ftp.cpp"~objExt~" "~
                            dir~"Http.cpp"~objExt~" "~
                            dir~"IpAddress.cpp"~objExt~" "~
                            dir~"Packet.cpp"~objExt~" "~
                            dir~"SocketSelector.cpp"~objExt~" "~
                            dir~"TcpListener.cpp"~objExt~" "~
                            dir~"TcpSocket.cpp"~objExt~" "~
                            dir~"UdpSocket.cpp"~objExt~" ";

    dir = "src/DSFMLC/Window/CMakeFiles/dsfmlc-window.dir/";
    objectList["window"] = dir~"Context.cpp"~objExt~" "~
                           dir~"Joystick.cpp"~objExt~" "~
                           dir~"Keyboard.cpp"~objExt~" "~
                           dir~"Mouse.cpp"~objExt~" "~
                           dir~"Sensor.cpp"~objExt~" "~
                           dir~"Touch.cpp"~objExt~" "~
                           dir~"VideoMode.cpp"~objExt~" "~
                           dir~"Window.cpp"~objExt~" ";

    dir = "src/DSFMLC/Graphics/CMakeFiles/dsfmlc-graphics.dir/";
    objectList["graphics"] = dir~"Font.cpp"~objExt~" "~
                             dir~"Image.cpp"~objExt~" "~
                             dir~"RenderTexture.cpp"~objExt~" "~
                             dir~"RenderWindow.cpp"~objExt~" "~
                             dir~"Shader.cpp"~objExt~" "~
                             dir~"Texture.cpp"~objExt~" "~
                             dir~"Transform.cpp"~objExt~" ";

    if(debugLibs)
    {
        singleFileSwitches = " -g " ~ singleFileSwitches;
        postfix = "-d";
    }

    writeln();
}

/// Initialize the DMD compiler
void initializeDMD()
{
    singleFileSwitches = archSwitch ~ " -c -O -release -inline -Isrc -of";
    libSwitches = archSwitch ~ " -lib -oflib/"~prefix~"dsfml-";
    docSwitches = " -c -o- -op -D -Dd../../doc -I../../src";
    interfaceSwitches = " -c -o- -op -H -Hd../import -I../src";

    unittestSwitches =
    archSwitch ~ " -main -unittest -version=DSFML_Unittest_System " ~
    "-version=DSFML_Unittest_Window -version=DSFML_Unittest_Graphics " ~
    "-version=DSFML_Unittest_Audio -version=DSFML_Unittest_Network " ~
    "-ofunittest/unittest";

    version (Windows)
    {
        unittestSwitches ~= ".exe -L/LIBPATH:lib -L/LIBPATH:SFML\\lib ";
    }
    else
    {
        linkerInclude = "-L-l";
        unittestSwitches ~= " -L-LSFML/lib ";
    }
}

/// Initialize the GDC compiler
void initializeGDC()
{
    //need to set up for windows and macOS later

    singleFileSwitches = archSwitch ~ " -c -O3 -frelease -Isrc -o";
    libSwitches = "ar rcs ./lib/libdsfml-";
    docSwitches = " -c -fdoc -I../../src";
    interfaceSwitches = " -c -fintfc -I../src -o obj.o";

    unittestSwitches =
    archSwitch ~ " -funittest -fversion=DSFML_Unittest_System " ~
    "-fversion=DSFML_Unittest_Window -fversion=DSFML_Unittest_Graphics " ~
    "-fversion=DSFML_Unittest_Audio -fversion=DSFML_Unittest_Network " ~
    "-ounittest/unittest";

    version(linux)
    {
        linkerInclude = "-l";
        unittestSwitches ~= " -LSFML/lib ";
    }
}

/// Initialize the LDC compiler
void initializeLDC()
{
    string linkToSFMLLibs = "";

    singleFileSwitches = archSwitch ~ " -c -O -release -oq -I=src -of=";
    libSwitches = archSwitch ~ " -lib -of=lib/"~prefix~"dsfml-";
    docSwitches = " -c -o- -op -D -Dd=../../doc -I=../../src";
    interfaceSwitches = " -c -o- -op -H -Hd=../import -I=../src";

    unittestSwitches =
    archSwitch ~ " -main -unittest -d-version=DSFML_Unittest_System " ~
    "-d-version=DSFML_Unittest_Window -d-version=DSFML_Unittest_Graphics " ~
    "-d-version=DSFML_Unittest_Audio -d-version=DSFML_Unittest_Network " ~
    "-of=unittest/unittest";

    version(Windows)
    {
         unittestSwitches ~= ".exe -L=/LIBPATH:lib -L=/LIBPATH:SFML\\lib ";
    }
    else
    {
        linkerInclude = "-L=-l";
        unittestSwitches ~= " -L=-LSFML/lib ";
    }
}

/**
 * Build the DSFMLC source files.
 *
 * Returns: true on successful build, false otherwise.
 */
bool buildDSFMLC()
{
    chdir("src/DSFMLC/");

    // generate the cmake files on the first run
    if(!exists("CMakeCache.txt"))
    {
        auto pid = spawnShell("cmake -G"~makefileType~" .");
        if(wait(pid) != 0)
        {
            return false;
        }
    }

    //always try to rebuild c++ files. They will be skipped if nothing to do.
    auto pid = spawnProcess([makefileProgram]);
    if(wait(pid) != 0)
    {
        return false;
    }

    writeln();

    chdir("../..");

    return true;
}

/**
 * Build the static libraries.
 *
 * Returns: true on successful build, false otherwise.
 */
bool buildLibs()
{
    import std.ascii: toUpper;

    if(!exists("lib/"))
    {
        mkdir("lib/");
    }

    if(!buildDSFMLC())
        return false;

    foreach(theModule;modules)
    {
        //+1 to include the library file in the count
        size_t numberOfFiles = fileList[theModule].length + 1;
        string files = "";

        string objLocation = "obj/"~(debugLibs?"debug":"release")~
            "/dsfml/" ~theModule~"/";

        if(!exists(objLocation))
        {
            mkdirRecurse(objLocation);
        }

        foreach (fileNumber, name; fileList[theModule])
        {
            string objectFile = objLocation~name~objExt;

            string dFile = "src/dsfml/" ~theModule~"/"~name~".d";
            string buildCommand = compiler~dFile~singleFileSwitches~objectFile;

            if(needToBuild(objectFile, dFile))
            {
                progressOutput(fileNumber, numberOfFiles, dFile);

                auto status = executeShell(buildCommand);

                if(status.status !=0)
                {
                    writeln(status.output);
                    return false;
                }
            }

            files~= objectFile ~ " ";
        }

        files ~= objectList[theModule];

        string buildCommand = compiler ~ files;

        version(GNU)
        {
            //We're using ar here, so we'll completely reset the build command
            buildCommand = libSwitches~theModule~postfix~extension~" "~files;
        }
        else
        {
            buildCommand ~= libSwitches~theModule~postfix~extension;
        }

        //always rebuilds the lib in case the cpp files were re-built
        auto status = executeShell(buildCommand);

        if(status.status !=0)
        {
            writeln("Something happened!");
            writeln(status.output);
            return false;
        }

        writeln("[100%] Built "~prefix~"dsfml-" ~ theModule~extension);
    }

    return true;
}

/**
 * Build DSFML unit tests.
 *
 * Returns: true if unit tests could be built, false if not.
 */
bool buildUnittests()
{
    import std.ascii: toUpper;

    if(!findSFML())
        return false;

    if(!buildDSFMLC())
        return false;

    string files = "";

    foreach(theModule;modules)
    {
        foreach(string name; fileList[theModule])
        {
            files~= "src/dsfml/" ~theModule~"/"~name~".d ";
        }

        files ~= objectList[theModule];
    }

    string buildCommand = compiler;

    version(GNU)
    {
        std.file.write("main.d", "void main(){}");

        buildCommand ~= "main.d ";
    }

    buildCommand ~= files~unittestSwitches;

    write("Building unittest/unitest");
    version(Windows)
        writeln(".exe");
    else
        writeln();

    auto status = executeShell(buildCommand);

    version(GNU)
    {
        std.file.remove("main.d");
    }

    if(status.status !=0)
    {
        writeln(status.output);
        return false;
    }

    return true;
}

/**
 * Build DSFML documentation.
 *
 * Returns: true if documentation could be built, false if not.
 */
bool buildDocumentation()
{
    if(!exists("doc/"))
    {
        mkdir("doc/");
    }

    chdir("src/dsfml/");

    string docExtension;
    string ddoc;
    if(buildingWebsiteDocs)
    {
        docExtension = ".php";

        version(GNU)
            ddoc = "../../doc/website_documentation.ddoc";
        else
            ddoc = " ../../doc/website_documentation.ddoc";
    }
    else
    {
        docExtension = ".html";
        version(GNU)
            ddoc = "../../doc/default_ddoc_theme.ddoc";
        else
            ddoc = " ../../doc/local_documentation.ddoc";
    }

    foreach(theModule;modules)
    {
        if(selectedModule != "" && theModule != selectedModule)
        {
            continue;
        }

        // skipping package.d
        size_t numberOfFiles = fileList[theModule].length -1 ;
        foreach (fileNumber, name; fileList[theModule])
        {
            if (name == "package")
                continue;

            string docFile = "../../doc/"~theModule~"/"~name~docExtension;
            string outputFile = name~docExtension;
            string dFile = theModule~"/"~name~".d";

            string buildCommand;

            version(GNU)
            {
                buildCommand = compiler~dFile~" -fdoc-inc="~ddoc~
                " -fdoc-dir=../../doc/dsfml/"~theModule~
                docSwitches~" -o obj.o";
            }
            else
                buildCommand = compiler~dFile~ddoc~docSwitches;

            if(needToBuild(docFile, dFile))
            {
                progressOutput(fileNumber, numberOfFiles, outputFile);

                auto status = executeShell(buildCommand);
                if(status.status !=0)
                {
                    writeln(status.output);
                    return false;
                }

                if(docExtension!=".html")
                    rename("../../doc/"~theModule~"/"~name~".html",
                           "../../doc/"~theModule~"/"~name~docExtension);
            }
        }
    }

    version(GNU)
        core.stdc.stdio.remove("obj.o");

    chdir("../..");

    return true;
}

/**
 * Build DSFML interface files.
 *
 * Returns: true if documentation could be built, false if not.
 */
bool buildInterfaceFiles()
{
    if(!exists("import/"))
    {
        mkdir("import/");
    }

    chdir("src/");

    foreach(theModule;modules)
    {
        size_t numberOfFiles = fileList[theModule].length;

        foreach (fileNumber, name; fileList[theModule])
        {
            string dFile = "dsfml/"~theModule~"/"~name~".d";
            string outputFile = "../import/dsfml/"~theModule~"/"~name~".di";
            if(name == "package")
                outputFile.length = outputFile.length - 1;

            version(GNU)
            {
                interfaceSwitches ~= " -fintfc-dir=../import/dsfml/"~theModule;
            }

            string buildCommand = compiler~dFile~interfaceSwitches;

            if(needToBuild(outputFile, dFile))
            {
                progressOutput(fileNumber, numberOfFiles, outputFile[3 .. $]);

                auto status = executeShell(buildCommand);
                if(status.status !=0)
                {
                    writeln(status.output);
                    return false;
                }
            }
        }

        if(exists("../import/dsfml/"~theModule~"/package.di"))
        {
            rename("../import/dsfml/"~theModule~"/package.di",
                   "../import/dsfml/"~theModule~"/package.d");
        }
    }

    version(GNU)
        core.stdc.stdio.remove("obj.o");

    chdir("../..");

    return true;
}

/**
 * Display the progress as a percentage given the current file is next.
 *
 * Display example:
 * [ 20%] Building dsfml/src/system/clock.d
 */
void progressOutput(size_t currentFile, size_t totalFiles, string fileName)
{
    size_t percentage = ((currentFile+1)*100)/totalFiles;

    writefln("[%3u%%] Building %s", percentage, fileName);
}

/**
 * Checks the timestamps on the object file and its associated source file.
 *
 * If the source file has been more recently updated than the object file was
 * built, or if the object file doesn't yet exist, this will return true.
 */
bool needToBuild(string objLocation, string srcLocation)
{
    import std.file: exists, timeStamp = timeLastModified;

    return exists(objLocation)?timeStamp(objLocation) < timeStamp(srcLocation):
                               true;
}

/**
 * Search for SFML shared libraries in the submodule directory.
 *
 * Returns: true if SFML shared libraries can be found, false otherwise.
 */
bool findSFML()
{
    version(Windows)
    {
        //technically, we also need .lib files because Windows is stupid, but
        //the build script will only look for the .dll's.
        string dynamicExtension = "-2.dll";
    }
    else version(linux)
    {
        string dynamicExtension = ".so";
    }
    else
    {
        string dynamicExtension = ".dylib";
    }

    //check to make sure ALL SFML libs were built
    foreach(theModule; modules)
    {
        if(!exists("SFML/lib/"~prefix~"sfml-"~theModule~dynamicExtension))
        {
            writeln("SFML/lib/"~prefix~"sfml-"~theModule~dynamicExtension,
                    " not found.");
            writeln("Building unit tests requires SFML libs in ",
                    "dsfml/SFML/lib/ directory.");
            return false;
        }
    }

    return true;
}

/**
 * Builds a string consisting of the linker flags, library name, and extention.
 *
 * This is to simplify building the list of libraries needed when building unit
 * tests.
 *
 */
string lib(string library)
{
    version(Windows)
        return linkerInclude~library~extension~" ";
    else
        return linkerInclude~library~" ";
}

int main(string[] args)
{
    GetoptResult optInfo;
    try
    {
        optInfo = getopt(args,
        "lib", "Build static libraries.", &buildingLibs,
        "m32", "Force 32 bit building.", &force32Build,
        "m64", "Force 64 bit building.", &force64Build,
        "unittest", "Build DSFML unit test executable.", &buildingUnittests,
        "doc", "Build DSFML documentation.", &buildingDoc,
        "webdoc", "Build the DSFML website documentation.", &buildingWebsiteDocs,
        "import", "Generate D interface files.", &buildingInterfaceFiles,
        "debug", "Build debug libraries (ignored when not building libraries).", &debugLibs
        );
    }
    catch(GetOptException e)
    {
        writeln(e.msg);
        return -1;
    }

    if(optInfo.helpWanted)
    {
        defaultGetoptPrinter("Switch Information\n"
        ~"Default (no switches passed) will be to build static libraries with the compiler that built this.",
        optInfo.options);
        return 0;
    }

    //default to building libs
    if(!buildingLibs && !buildingDoc && !buildingInterfaceFiles &&
       !buildingWebsiteDocs && !buildingUnittests && !buildingAll)
    {
        buildingLibs = true;
    }

    if(!checkSwitchErrors())
    {
        return -1;
    }

    writeln();
    initialize();

    if(buildingLibs)
    {
        if(!buildLibs())
            return -1;
    }
    if(buildingUnittests)
    {
        if(!buildUnittests())
            return -1;
    }
    if(buildingDoc || buildingWebsiteDocs)
    {
        if(!buildDocumentation())
            return -1;
    }
    if(buildingInterfaceFiles)
    {
        if(!buildInterfaceFiles())
            return -1;
    }

    return 0;
}
