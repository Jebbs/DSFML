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
string extension;
string libCompilerSwitches;
string docCompilerSwitches;
string interfaceSwitches;
string unittestCompilerSwitches;
bool buildStop;


//switch settings
bool buildingLibs;
bool buildingInterfaceFiles;
bool buildingDoc;
bool buildingWebsiteDocs;
bool showingHelp;
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
string[][string] objectList;


//checks for any inconsistencies with the passed switchs.
//Returns true if everything is ok and false if an error was found.
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

    archSwitch = "";


    version(DigitalMars)
    {
        initializeDMD();
    }
    else version(GNU)
    {
        initializeGDC();
    }
    else
    {
        initializeLDC();
    }

    if(force32Build)
    {
        version(Windows)
        {
            version(DigitalMars)
            {
                archSwitch = "-m32mscoff";
            }
        }
        else
        {
            archSwitch = "-m32";
        }
    }

    if(force64Build)
    {
        archSwitch = "-m64";
    }

    writeln();
}

/// Initialize the DMD compiler
void initializeDMD()
{

    string linkToSFMLLibs = "";

    version (Windows)
    {
        writeln("Building for Windows with dmd");
        prefix = "";
        extension = ".lib";
        objExt = ".obj";

        //Default to 64 bit on windows because why wouldn't we?
        if(!force64Build || !force32Build)
        {
            archSwitch = " -m64";
        }

        makefileProgram = "nmake";
        makefileType = `"NMake Makefiles"`;

        linkToSFMLLibs = "-L/LIBPATH:lib -L/LIBPATH:SFML\\lib "~
        "-L/LIBPATH:SFML\\extlibs\\libs-msvc-universal\\x64 ";

        linkToSFMLLibs ~=
        "dsfmlc-graphics.lib dsfmlc-window.lib dsfmlc-audio.lib " ~
        "dsfmlc-network.lib dsfmlc-system.lib ";

        linkToSFMLLibs~=
        "sfml-graphics.lib sfml-window.lib sfml-audio.lib "~
        "sfml-network.lib sfml-system.lib ";

        /*linkToSFMLLibs~=
        "opengl32.lib gdi32.lib flac.lib freetype.lib jpeg.lib ogg.lib "~
        "openal32.lib vorbis.lib vorbisenc.lib vorbisfile.lib ws2_32.lib "~
        "winmm.lib user32.lib ";
        */
    }
    else version(linux)
    {
        writeln("Building for Linux with dmd");
        prefix = "lib";
        extension = ".a";
        objExt = ".o";

        makefileProgram = "make";
        makefileType = `"Unix Makefiles"`;


        linkToSFMLLibs = "-L-Llib -L-LSFML/lib ";

        linkToSFMLLibs ~=
        "-L-ldsfmlc-graphics -L-ldsfmlc-window -L-ldsfmlc-audio " ~
        "-L-ldsfmlc-network -L-ldsfmlc-system ";

        linkToSFMLLibs ~=
        "-L-lsfml-graphics -L-lsfml-window -L-lsfml-audio "~
        "-L-lsfml-network -L-lsfml-system ";

        linkToSFMLLibs ~= "-L-lstdc++ ";

        //linkToSFMLLibs ~=
        //"-L-lstdc++ -L-lFLAC -L-logg -L-lvorbisfile -L-lvorbisenc -L-lvorbis "~
        //"-L-lopenal -L-lX11 -L-ludev -L-lGL -L-lXrandr -L-ljpeg -L-lfreetype";
    }
    else
    {
        writeln("Building for OSX with dmd");
        prefix = "lib";
        extension = ".a";
        objExt = ".o";

        makefileProgram = "make";
        makefileType = `"Unix Makefiles"`;


        linkToSFMLLibs = "-L-Llib -L-LSFML/lib ";

        linkToSFMLLibs ~=
        "-L-ldsfmlc-graphics -L-ldsfmlc-window -L-ldsfmlc-audio " ~
        "-L-ldsfmlc-network -L-ldsfmlc-system ";

        linkToSFMLLibs ~=
        "-L-lsfml-graphics -L-lsfml-window -L-lsfml-audio "~
        "-L-lsfml-network -L-lsfml-system ";

        linkToSFMLLibs ~= "-L-lstdc++ -L-rpath -L. ";

        //linkToSFMLLibs ~=
        //"-L-lstdc++ -L-lFLAC -L-logg -L-lvorbisfile -L-lvorbisenc -L-lvorbis "~
        //"-L-lopenal -L-lX11 -L-ludev -L-lGL -L-lXrandr -L-ljpeg -L-lfreetype";
    }

    singleFileSwitches = archSwitch ~ " -c -O -release -inline -Isrc";
    libCompilerSwitches = archSwitch ~ " -lib  -Isrc";
    docCompilerSwitches = " -c -o- -op -D -Dd../../doc -I../../src";
    interfaceSwitches = " -c -o- -op -H -Hd../import -I../src";

    unittestCompilerSwitches =
    "-main -unittest -version=DSFML_Unittest_System " ~
    "-version=DSFML_Unittest_Window -version=DSFML_Unittest_Graphics " ~
    "-version=DSFML_Unittest_Audio -version=DSFML_Unittest_Network "~
    linkToSFMLLibs;
    //unittestCompilerSwitches ="-main -unittest -version=DSFML_Unittest_Network "~linkToSFMLLibs;
    //libCompilerSwitches = "-lib -O -release -inline -I"~quoteString(impDirectory);
    //interfaceSwitches = " -c -o- -op -H -Hd"~quoteString(interfaceDirectory);
}

/// Initialize the GDC compiler
void initializeGDC()
{
    //need to set up for windows and macOS later

    string linkToSFMLLibs = "";

    version(linux)
    {
        writeln("Building for Linux with gdc");
        prefix = "lib";
        extension = ".a";
        objExt = ".o";

        makefileProgram = "make";
        makefileType = `"Unix Makefiles"`;

        linkToSFMLLibs = "-Llib -LSFML/lib ";

        linkToSFMLLibs ~=
        "-ldsfmlc-graphics -ldsfmlc-window -ldsfmlc-audio " ~
        "-ldsfmlc-network -ldsfmlc-system ";

        linkToSFMLLibs ~=
        "-lsfml-graphics -lsfml-window -lsfml-audio "~
        "-lsfml-network -lsfml-system ";

        linkToSFMLLibs ~= "-lstdc++ ";

        //linkToSFMLLibs ~=
        //"-lstdc++ -lFLAC -logg -lvorbisfile -lvorbisenc -lvorbis "~
        //"-lopenal -lX11 -ludev -lGL -lXrandr -ljpeg -lfreetype";
    }


    singleFileSwitches = archSwitch ~ " -c -O3 -frelease -Isrc";
    libCompilerSwitches = archSwitch ~ " -Isrc";
    docCompilerSwitches = " -c -fdoc -I../../src";
    interfaceSwitches = " -c -fintfc -I../src -o obj.o";

    unittestCompilerSwitches =
    "-funittest -fversion=DSFML_Unittest_System " ~
    "-fversion=DSFML_Unittest_Window -fversion=DSFML_Unittest_Graphics " ~
    "-fversion=DSFML_Unittest_Audio -fversion=DSFML_Unittest_Network "~
    linkToSFMLLibs;

}

/// Initialize the LDC compiler
void initializeLDC()
{
    string linkToSFMLLibs = "";

    //fix this before testing on windows
    version(Windows)
    {
        writeln("Building for Windows with ldc");
        prefix = "";
        extension = ".lib";
        objExt = ".obj";

        //Default to 64 bit on windows because why wouldn't we?
        if(!force64Build || !force32Build)
        {
            archSwitch = " -m64";
        }

        makefileProgram = "nmake";
        makefileType = `"NMake Makefiles"`;

         linkToSFMLLibs = "-L=/LIBPATH:lib -L=/LIBPATH:SFML\\lib "~
        "-L=/LIBPATH:SFML\\extlibs\\libs-msvc-universal\\x64 ";

        linkToSFMLLibs ~=
        "dsfmlc-graphics.lib dsfmlc-window.lib dsfmlc-audio.lib " ~
        "dsfmlc-network.lib dsfmlc-system.lib ";

        linkToSFMLLibs~=
        "sfml-graphics.lib sfml-window.lib sfml-audio.lib "~
        "sfml-network.lib sfml-system.lib ";

        /*linkToSFMLLibs~=
        "opengl32.lib gdi32.lib flac.lib freetype.lib jpeg.lib ogg.lib "~
        "openal32.lib vorbis.lib vorbisenc.lib vorbisfile.lib ws2_32.lib "~
        "winmm.lib user32.lib ";
        */
    }
    else version(linux)
    {
        writeln("Building for Linux with ldc");
        prefix = "lib";
        extension = ".a";
        objExt = ".o";

        makefileProgram = "make";
        makefileType = `"Unix Makefiles"`;


        linkToSFMLLibs = "-L=-Llib -L=-LSFML/lib ";

        linkToSFMLLibs ~=
        "-L=-ldsfmlc-graphics -L=-ldsfmlc-window -L=-ldsfmlc-audio " ~
        "-L=-ldsfmlc-network -L=-ldsfmlc-system ";

        linkToSFMLLibs ~=
        "-L=-lsfml-graphics -L=-lsfml-window -L=-lsfml-audio "~
        "-L=-lsfml-network -L=-lsfml-system ";

        linkToSFMLLibs ~= "-L=-lstdc++ ";

        //linkToSFMLLibs ~=
        //"-L=-lstdc++ -L=-lFLAC -L=-logg -L=-lvorbisfile -L=-lvorbisenc "~
        //"-L=-lvorbis -L=-lopenal -L=-lX11 -L=-ludev -L=-lGL -L=-lXrandr "~
        //"-L=-ljpeg -L=-lfreetype";
    }
    else
    {
        writeln("Building for OSX with ldc");
        prefix = "lib";
        extension = ".a";
        objExt = ".o";

        makefileProgram = "make";
        makefileType = `"Unix Makefiles"`;

        linkToSFMLLibs = "-L=-Llib -L=-LSFML/lib ";

        linkToSFMLLibs ~=
        "-L=-ldsfmlc-graphics -L=-ldsfmlc-window -L=-ldsfmlc-audio " ~
        "-L=-ldsfmlc-network -L=-ldsfmlc-system ";

        linkToSFMLLibs ~=
        "-L=-lsfml-graphics -L=-lsfml-window -L=-lsfml-audio "~
        "-L=-lsfml-network -L=-lsfml-system ";

        linkToSFMLLibs ~= "-L=-lstdc++ -L=-rpath -L=. ";
    }

    singleFileSwitches = archSwitch ~ " -c -O -release -oq -I=src";
    libCompilerSwitches = archSwitch ~ " -lib -I=src";
    docCompilerSwitches = " -c -o- -op -D -Dd=../../doc -I=../../src";
    interfaceSwitches = " -c -o- -op -H -Hd=../import -I=../src";

    unittestCompilerSwitches =
    "-main -unittest -d-version=DSFML_Unittest_System " ~
    "-d-version=DSFML_Unittest_Window -d-version=DSFML_Unittest_Graphics " ~
    "-d-version=DSFML_Unittest_Audio -d-version=DSFML_Unittest_Network "~
    linkToSFMLLibs;
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

    if(!exists("CMakeCache.txt"))
    {
        auto pid = spawnShell("cmake -G"~makefileType~" .");
        if(wait(pid) != 0)
        {
            //oh shit, what up?
            return false;
        }
    }

    //always try to rebuild c++ files. They will be skipped if nothing to do.
    auto pid = spawnProcess([makefileProgram]);
    if(wait(pid) != 0)
    {
        //oh shit, what up?
        return false;
    }

    writeln();

    //go trhough each module directory, build d source files if need be,
    //populate a list of all object files (both d and cpp),
    //and build a static lib.
    foreach(theModule;modules)
    {
        if(selectedModule != "" && theModule != selectedModule)
        {
            continue;
        }

        //+1 for lib file
        size_t numberOfFiles = fileList[theModule].length + 1;
        string files = "";

        foreach (i, name; fileList[theModule])
        {
            string objectFile = "src/dsfml/" ~theModule~"/"~name~objExt;
            string dFile = "src/dsfml/" ~theModule~"/"~name~".d";

            version(DigitalMars)
            {
                string buildCommand = compiler~dFile~singleFileSwitches~
                                  " -of" ~objectFile;
            }
            else version(GNU)
            {
                string buildCommand = compiler~dFile~singleFileSwitches~
                                  " -o" ~objectFile;
            }
            else version(LDC)
            {
                string buildCommand = compiler~dFile~singleFileSwitches~
                                  " -of=" ~objectFile;
            }

            if(needToBuild(objectFile, dFile))
            {
                progressOutput(i, numberOfFiles, dFile);

                auto status = executeShell(buildCommand);
                if(status.status !=0)
                {
                    writeln(status.output);
                    return false;
                }
            }

            files~= objectFile ~ " ";
        }

        string buildCommand = compiler ~ files;

        version(DigitalMars)
        {
            //adding the library to dmd doesn't work on OSX
            version(OSX)
            {
                buildCommand = "cd "~"src/dsfml/"~theModule~"/ && "~
                "ar -x ../../../lib/"~prefix~"dsfmlc-"~theModule~extension ~ " && "~
                " ar rcs ../../../lib/libdsfml-"~theModule~extension~" *"~objExt~"&& "~
                "cd ../../../";
            }
            else
            {
                //build the static libs directly
                buildCommand ~= " -lib -L-Llib/ -L-l"~"dsfmlc-"~theModule~extension ~
                " -oflib/"~prefix~"dsfml-"~theModule~extension~archSwitch;
            }
        }
        else version(GNU)
        {
            writeln("building the library");

            //we want to use ar here, so we'll completely reset the build command
            buildCommand = "cd "~"src/dsfml/"~theModule~"/ && "~
            "ar -x ../../../lib/"~prefix~"dsfmlc-"~theModule~extension ~ " && "~
            " ar rcs ../../../lib/libdsfml-"~theModule~extension~" *"~objExt~"&& "~
            "cd ../../../";
        }
        else
        {
            version(OSX)
            {
                buildCommand = "cd "~"src/dsfml/"~theModule~"/ && "~
                "ar -x ../../../lib/"~prefix~"dsfmlc-"~theModule~extension ~ " && "~
                " ar rcs ../../../lib/libdsfml-"~theModule~extension~" *"~objExt~"&& "~
                "cd ../../../";
            }
            else
            {
                buildCommand ~= " -lib lib/"~prefix~"dsfmlc-"~theModule~extension ~
                " -of=lib/"~prefix~"dsfml-"~theModule~extension~archSwitch;
            }
            //buildCommand ~= " -of="~quoteString(libDirectory~prefix~"dsfml-"~theModule~extension);
        }


        //always rebuilds the lib in case the cpp files were re-built
        auto status = executeShell(buildCommand);

        //writeln(buildCommand);

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

    import std.ascii: toUpper;
    //string[2] testModules = ["system", "network"];
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

    if(!exists("CMakeCache.txt"))
    {
        auto pid = spawnShell("cmake -G"~makefileType~" .");
        if(wait(pid) != 0)
        {
            //oh shit, what up?
            return false;
        }
    }

    //always try to rebuild c++ files. They will be skipped if nothing to do.
    auto pid = spawnProcess([makefileProgram]);
    if(wait(pid) != 0)
    {
        //oh shit, what up?
        return false;
    }

    string files = "";

    foreach(theModule;modules)
    {
        foreach(string name; fileList[theModule])
        {
            files~= "src/dsfml/" ~theModule~"/"~name~".d ";
        }
    }

    string buildCommand = compiler;

        version(DigitalMars)
        {
            buildCommand ~= files~" "~unittestCompilerSwitches~archSwitch;
            buildCommand ~= " -ofunittest/unittest";
        }
        else version(GNU)
        {
            std.file.write("main.d", "void main(){}");

            buildCommand ~= "main.d "~files~unittestCompilerSwitches~archSwitch~
            " -ounittest/unittest -Wl,--verbose";
        }
        else
        {
            buildCommand ~= unittestCompilerSwitches~archSwitch~" -oq "~files;
            buildCommand ~= "-of=unittest/unittest";
            //buildCommand ~= " -of="~quoteString(libDirectory~prefix~"dsfml-"~theModule~extension);
        }

        version(Windows)
        {
            buildCommand ~= ".exe";
        }

        writeln(buildCommand);


        //std.file.write("cmdFile")
        //remove(deleteme);



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
        foreach (i, name; fileList[theModule])
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
                docCompilerSwitches~" -o obj.o";
            }
            else
                buildCommand = compiler~dFile~ddoc~docCompilerSwitches;

            if(needToBuild(docFile, dFile))
            {
                progressOutput(i, numberOfFiles, outputFile);

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

        foreach (i, name; fileList[theModule])
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
                progressOutput(i+1, numberOfFiles, outputFile[3 .. $]);

                auto status = executeShell(buildCommand);
                if(status.status !=0)
                {
                    writeln(status.output);
                    return false;
                }
            }
        }

        rename("../import/dsfml/"~theModule~"/package.di",
               "../import/dsfml/"~theModule~"/package.d");
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
void progressOutput(size_t current, size_t total, string file)
{
    size_t percentage = ((current+1)*100)/total;

    writefln("[%3u%%] Building %s", percentage, file);
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

string singleSplitter(string haystack, char needle, ref int startPos)
{
    int i;
    for(i = startPos; i < haystack.length; i++)
    {
        if(haystack[i] == needle)
            break;
    }

    if(i >= haystack.length)
        return null;
    auto ret = haystack[startPos .. i];
    startPos = i+1;
    return ret;
}

string pathToMSVCToolChain()
{
    string dmdPath;
    auto paths = environment.get("PATH");
    int start = 0;
    auto path = singleSplitter(paths, ';', start);

    while(path !is null)
    {

        if(canFind(path, "dmd2"))
        {
            dmdPath = path;
        }
        path = singleSplitter(paths, ';', start);
    }

    File scFile = File(dmdPath~"\\sc.ini", "r");
    char[] buf;

    while(!canFind(buf, "VCINSTALLDIR="))
    {
        scFile.readln(buf);
        //writeln(buf);
    }

    //$-1 because the buffer ends with \n
    return buf[13 ..$-1].idup;

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

    /*
        writeln("lib ", buildingLibs);
        writeln("doc ", buildingDoc);
        writeln("import ",buildingInterfaceFiles);
        writeln("unittest ", buildingUnittests);
        writeln("all ", buildingAll);
        writeln("sharedDir ", unittestLibraryLocation);
        writeln("m32 ", force32Build);
        writeln("m64 ", force64Build);
        writeln("dmd ", forceDMD);
        writeln("gdc ", forceGDC);
        writeln("ldc ", foorceLDC);
    */

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
