module build;

import std.stdio;
import std.file;
import std.process;
import std.algorithm;
import std.array;


version(DigitalMars)
{
	bool isDMD = true;
	bool isGDC = false;
	bool isLDC = false;
	string compiler = "dmd ";
}
else version(GNU)
{
	bool isDMD = false;
	bool isGDC = true;
	bool isLDC = false;
	string compiler = "gdc ";
}
else version(LDC)
{
	bool isDMD = false;
	bool isGDC = false;
	bool isLDC = true;
	string compiler = "ldc2 ";
}
else
{
	static assert(false, "Unknown or unsupported compiler.");
}

//location settings
string currentDirectory;
string impDirectory;
string libDirectory;
string interfaceDirectory;
string docDirectory;
string unittestDirectory;

//build settings
string prefix;
string extension;
string libCompilerSwitches;
string docCompilerSwitches;
string interfaceCompilerSwitches;
string unittestCompilerSwitches;
bool buildStop;


//switch settings
bool buildingLibs;
bool buildingInterfaceFiles;
bool buildingDoc;
bool showingHelp;
bool force32Build;
bool force64Build;

bool buildingUnittests;
string unittestLibraryLocation;

bool buildingAll;

bool hasUnrecognizedSwitch;
string unrecognizedSwitch;


version(Windows)
{
	bool isWindows = true;
	bool isLinux = false;
	bool isMac = false;
}
else version(linux)
{
	bool isWindows = false;
	bool isLinux = true;
	bool isMac = false;
}
else version(OSX)
{
	bool isWindows = false;
	bool isLinux = false;
	bool isMac = true;
}
else
{
	static assert(false, "DSFML is only supported on OSX, Windows, and Linux.");
}


string[5] modules = ["system", "audio", "network", "window", "graphics"];

//This is to circumvent a bug in GDC's current Windows 32 bit builds.
//The aa is set up in the initialize function.
string[][string] fileList;




//parses and finds all given switches
void parseSwitches(string[] switches)
{
	//no switches passed
	if(switches.length ==0)
	{
		buildingLibs = true;
		return;
	}

	//find those switches!
	foreach(clswitch;switches)
	{

		switch(clswitch)
		{
			case "-help":
			{
				showingHelp = true;
				break;
			}
			case "-lib":
			{
				buildingLibs = true;
				break;
			}
			case "-doc":
			{
				buildingDoc = true;
				break;
			}
			case "-import":
			{
				buildingInterfaceFiles = true;
				break;
			}
			case "-m32":
			{
				force32Build = true;
				break;
			}
			case "-m64":
			{
				force64Build = true;
				break;
			}
			case "-dmd":
			{
				isDMD = true;
				isGDC = false;
				isLDC = false;
				compiler = "dmd ";
				break;
			}
			case "-gdc":
			{
				isDMD = false;
				isGDC = true;
				isLDC = false;
				compiler = "gdc ";
				break;
			}
			case "-ldc":
			{
				isDMD = false;
				isGDC = false;
				isLDC = true;
				compiler = "ldc2 ";
				break;
			}
			case "-unittest":
			{
				buildingUnittests = true;
				unittestLibraryLocation = "";
				break;
			}
			case "-all":
			{
				buildingAll = true;
				unittestLibraryLocation = "";
				break;
			}

			default:
			{


				//check for unittest switch
				auto result = clswitch.findSplit(":");

				//if some unknown switch
				if(result[0] == clswitch)
				{
					hasUnrecognizedSwitch = true;
					unrecognizedSwitch = clswitch;
					return;
				}
				else
				{
					//found unittest or all Switch
					if((result[0] == "-unittest"))
					{
						buildingUnittests = true;
						unittestLibraryLocation = result[2];
					}
					else if((result[0] == "-all"))
					{
						buildingAll = true;
						unittestLibraryLocation = result[2];
					}
					//found unknown switch that happened to have a : in it
					else
					{
						hasUnrecognizedSwitch = true;
						unrecognizedSwitch = clswitch;
						return;
					}
				}
			}
		}
	}


	//make sure the default happens if not building anything else
	if(!buildingLibs || !buildingDoc || !buildingInterfaceFiles || !buildingUnittests || !buildingAll)
	{
		buildingLibs = true;
	}

}

//checks for any inconsistencies with the passed switchs. Returns true if everything is ok and false if an error was found.
bool checkSwitchErrors()
{

	//if Switchs are used with -help
	if(showingHelp)
	{
		if(buildingLibs || buildingDoc || buildingInterfaceFiles || buildingUnittests || buildingAll || hasUnrecognizedSwitch || force32Build || force64Build)
		{
			writeln("Using -help will ignore all other switches.");
			return false;
		}
	}

	//can't force both
	if(force32Build && force64Build)
	{
		writeln("Can't use -m32 and -m64 together");
		return false;
	}

	//if other Switchs are used with -all
	if(buildingAll)
	{
		if(buildingLibs || buildingDoc || buildingInterfaceFiles || buildingUnittests)
		{
			writeln("Can't use -all with any other build switches (-lib, -doc, -import, -unittest)");
			return false;
		}

		if(unittestLibraryLocation == "")
		{
			writeln("Not putting in a location for shared libraries will work if they are in a standard location.");
		}

	}

	if(buildingUnittests)
	{
		if(unittestLibraryLocation == "")
		{
			writeln("Note: Not putting in a location for shared libraries will work only if they are in a standard location.");
		}
	}

	return true;
}

//initialize all build settings
void initialize()
{

	//Setting up our aa with our lists of files because GDC crashes when searching for them at runtime
	fileList["system"] = ["clock.d", "config.d", "err.d", "inputstream.d", "lock.d", "mutex.d", "package.d", "sleep.d", "string.d", "thread.d", "vector2.d", "vector3.d"];
	fileList["audio"] = ["listener.d", "music.d", "package.d", "sound.d", "soundbuffer.d", "soundbufferrecorder.d", "inputsoundfile.d", "soundrecorder.d", "soundsource.d", "soundstream.d"];
	fileList["network"] = ["ftp.d", "http.d", "ipaddress.d", "package.d", "packet.d", "socket.d", "socketselector.d", "tcplistener.d", "tcpsocket.d", "udpsocket.d"];
	fileList["window"] = ["context.d", "contextsettings.d", "event.d", "joystick.d", "keyboard.d", "mouse.d", "sensor.d", "touch.d", "package.d", "videomode.d", "window.d", "windowhandle.d"];
	fileList["graphics"] = ["blendmode.d", "circleshape.d", "color.d", "convexshape.d", "drawable.d", "font.d", "glyph.d", "image.d", "package.d", "primitivetype.d", "rect.d", "rectangleshape.d", "renderstates.d", "rendertarget.d", "rendertexture.d", "renderwindow.d", "shader.d", "shape.d", "sprite.d", "text.d", "texture.d", "transform.d", "transformable.d", "vertex.d", "vertexarray.d", "view.d"];


	if(isWindows)
	{
		currentDirectory = getcwd;
		impDirectory = currentDirectory~"\\src";
		libDirectory = currentDirectory~"\\lib\\";
		interfaceDirectory = currentDirectory~"\\import\\";
		docDirectory = currentDirectory~"\\doc\\";
		unittestDirectory = currentDirectory~"\\unittest\\";

		if(!exists(currentDirectory~"\\lib\\"))
		{
			mkdir(currentDirectory~"\\lib\\");
		}
	}
	else
	{
		currentDirectory = getcwd;
		impDirectory = `"`~currentDirectory~"/src"~`"`;
		libDirectory = `"`~currentDirectory~"/lib/"~`"`;
		interfaceDirectory = `"`~currentDirectory~"/import/"~`"`;
		docDirectory = `"`~currentDirectory~"/doc/"~`"`;
		unittestDirectory = `"`~currentDirectory~"/unittest/"~`"`;

		if(!exists(currentDirectory~"/lib/"))
		{
			mkdir(currentDirectory~"/lib/");
		}
	}

	

	if(isDMD)
	{
		initializeDMD();
	}
	else if(isGDC)
	{
		initializeGDC();
	}
	else
	{
		initializeLDC();
	}
	
	if(force32Build)
	{
		libCompilerSwitches = "-m32 "~libCompilerSwitches;
		unittestCompilerSwitches = "-m32 "~unittestCompilerSwitches;
	}

	if(force64Build)
	{
		libCompilerSwitches = "-m64 "~libCompilerSwitches;
		unittestCompilerSwitches = "-m64 "~unittestCompilerSwitches;
	}


	writeln();
}

void initializeDMD()
{
	if(isWindows)
	{
		writeln("Building for Windows with dmd");
		prefix = "";
		extension = ".lib";
		unittestCompilerSwitches = "-main -unittest -cov -I"~impDirectory~" dsfml-graphics.lib dsfml-window.lib dsfml-audio.lib dsfml-network.lib dsfml-system.lib dsfmlc-graphics.lib dsfmlc-window.lib dsfmlc-audio.lib dsfmlc-network.lib dsfmlc-system.lib ";

		if(!force64Build)
		{
			unittestCompilerSwitches~="-L+"~libDirectory;
		}
		else
		{
			unittestCompilerSwitches~="-L/LIBPATH:"~libDirectory;
		}
	}
	else if(isLinux)
	{
		writeln("Building for Linux with dmd");
		prefix = "lib";
		extension = ".a";
		unittestCompilerSwitches = "-main -unittest -cov -I"~impDirectory~" -L-ldsfml-graphics -L-ldsfml-window -L-ldsfml-audio -L-ldsfml-network -L-ldsfml-system -L-ldsfmlc-graphics -L-ldsfmlc-window -L-ldsfmlc-audio -L-ldsfmlc-network -L-ldsfmlc-system -L-L"~libDirectory;
	}
	else
	{
		writeln("Building for OSX with dmd");
		prefix = "lib";
		extension = ".a";
		unittestCompilerSwitches = "-main -unittest -cov -I"~impDirectory~" -L-ldsfml-graphics -L-ldsfml-window -L-ldsfml-audio -L-ldsfml-network -L-ldsfml-system -L-ldsfmlc-graphics -L-ldsfmlc-window -L-ldsfmlc-audio -L-ldsfmlc-network -L-ldsfmlc-system -L-L"~libDirectory;
	}

	unittestCompilerSwitches ="-version=DSFML_Unittest_System -version=DSFML_Unittest_Window -version=DSFML_Unittest_Graphics -version=DSFML_Unittest_Audio -version=DSFML_Unittest_Network "~unittestCompilerSwitches;


	libCompilerSwitches = "-lib -O -release -inline -I"~impDirectory;
	docCompilerSwitches = "-D -Dd"~docDirectory~" -c -o- -op";
	interfaceCompilerSwitches = "-H -Hd"~interfaceDirectory~" -c -o- -op";
}

void initializeGDC()
{
	if(isWindows)
	{
		writeln("Building for Windows with gdc");
	}
	else if(isLinux)
	{
		writeln("Building for Linux with gdc");
	}
	else
	{
		writeln("Building for OSX with gdc");
	}
	prefix = "lib";
	extension = ".a";
	unittestCompilerSwitches = "-fversion=DSFML_Unittest_System -fversion=DSFML_Unittest_Window -fversion=DSFML_Unittest_Graphics -fversion=DSFML_Unittest_Audio -fversion=DSFML_Unittest_Network -funittest -I"~impDirectory~" -ldsfml-graphics -ldsfml-window -ldsfml-audio -ldsfml-network -ldsfml-system -ldsfmlc-graphics -ldsfmlc-window -ldsfmlc-audio -ldsfmlc-network -ldsfmlc-system -L"~libDirectory;

	libCompilerSwitches = "-c -O3 -frelease -I"~impDirectory;
	docCompilerSwitches = " -fdoc -c";
	interfaceCompilerSwitches = " -fintfc -c";

}

void initializeLDC()
{
	//The stuff for windows probbly needs to be fixed
	if(isWindows)
	{
		writeln("Building for Windows with ldc");
		
		

		if(!force64Build)
		{
			prefix = "lib";
			extension = ".a";

			unittestCompilerSwitches = "-main -unittest -I="~impDirectory~" -L=-ldsfml-graphics -L=-ldsfml-window -L=-ldsfml-audio -L=-ldsfml-network -L=-ldsfml-system -L=-ldsfmlc-graphics -L=-ldsfmlc-window -L=-ldsfmlc-audio -L=-ldsfmlc-network -L=-ldsfmlc-system -L=-L"~libDirectory;

			unittestCompilerSwitches~="-L=-L"~libDirectory;
		}
		else
		{
			prefix = "";
			extension = ".lib";

			unittestCompilerSwitches = "-main -unittest -I="~impDirectory~" dsfml-graphics.lib dsfml-window.lib dsfml-audio.lib dsfml-network.lib dsfml-system.lib dsfmlc-graphics.lib dsfmlc-window.lib dsfmlc-audio.lib dsfmlc-network.lib dsfmlc-system.lib ";

			unittestCompilerSwitches~="-L=/LIBPATH:"~libDirectory;

		}
	}
	else if(isLinux)
	{
		writeln("Building for Linux with ldc");
		prefix = "lib";
		extension = ".a";
		unittestCompilerSwitches = "-main -singleobj -unittest -I="~impDirectory~" -L=-ldsfml-graphics -L=-ldsfml-window -L=-ldsfml-audio -L=-ldsfml-network -L=-ldsfml-system -L=-ldsfmlc-graphics -L=-ldsfmlc-window -L=-ldsfmlc-audio -L=-ldsfmlc-network -L=-ldsfmlc-system -L=-L"~libDirectory;
	}
	else
	{
		writeln("Building for OSX with ldc");
		prefix = "lib";
		extension = ".a";
		unittestCompilerSwitches = "-main -unittest -I="~impDirectory~" -L=-ldsfml-graphics -L=-ldsfml-window -L=-ldsfml-audio -L=-ldsfml-network -L=-ldsfml-system -L=-ldsfmlc-graphics -L=-ldsfmlc-window -L=-ldsfmlc-audio -L=-ldsfmlc-network -L=-ldsfmlc-system -L=-L"~libDirectory;
	}

	unittestCompilerSwitches ="-d-version=DSFML_Unittest_System -d-version=DSFML_Unittest_Window -d-version=DSFML_Unittest_Graphics -d-version=DSFML_Unittest_Audio -d-version=DSFML_Unittest_Network -oq "~unittestCompilerSwitches;


	libCompilerSwitches = `-lib -O3 -release -oq -enable-inlining -I=`~impDirectory;
	docCompilerSwitches = "-D -Dd="~docDirectory~" -c -o- -op";
	interfaceCompilerSwitches = "-H -Hd="~interfaceDirectory~" -c -o- -op";
}

//build the static libraries. Returns true on successful build, false on unsuccessful build
bool buildLibs()
{

	//This is because there is a bug that I haven't bothered to track down yet
	//It causes the static libs to be built twice if building unit tests.
	//Will fix properly when I care more.
	static bool builtOnce = false;

	if(builtOnce)
	{
		return true;
	}


	writeln("Building static libraries!");
	foreach(theModule;modules)
	{
		string files = "";

		foreach (string name; fileList[theModule])
		{
			if(isDFile(name))
			{
				files~= "src/dsfml/" ~theModule~"/"~name ~ " ";
			}
			
		}

		string buildCommand = compiler~ files ~ libCompilerSwitches;

		if(isDMD) 
		{
			//build the static libs directly
			buildCommand ~= " -of"~libDirectory~prefix~"dsfml-"~theModule~extension;
		}
		else if(isGDC)
		{
			//build the object stuff and then build the archive
			buildCommand ~= " -o"~libDirectory~"dsfml-"~theModule~".o"~" && ar rcs lib/libdsfml-"~theModule~extension~" " ~"lib/dsfml-"~theModule~".o";
		}
		else
		{
			buildCommand ~= " -of="~libDirectory~prefix~"dsfml-"~theModule~extension;
		}
		
		writeln("Building " ~ theModule~ " module.");
		
		auto status = executeShell(buildCommand);

		if(status.status !=0)
		{
			writeln(status.output);
			return false;
		}

		//If we had to build object files, let's delete them.
		if(exists("lib/dsfml-"~theModule~".o"))
		{
			remove("lib/dsfml-"~theModule~".o");
		}
		if(exists("lib/libdsfml-"~theModule~".o"))
		{
			remove("lib/libdsfml-"~theModule~".o");
		}
		
	}

	builtOnce = true;
	return true;
}

//build the unit test. Returns true on successful build, false on unsuccessful build
bool buildUnittests()
{
	writeln("Building unit tests!");
	string files = "";

	foreach(theModule;modules)
	{
		foreach (string name; fileList[theModule])
		{
			if(isDFile(name))
			{
				files~= "src/dsfml/" ~theModule~"/"~name ~ " ";
			}
			
		}
	}

	if(isGDC)
	{
		std.file.write("main.d", "void main(){}");
		files = "main.d "~files;
	}

	string buildCommand = compiler~files ~ unittestCompilerSwitches;

	if(isDMD)
	{
		buildCommand~=" -of"~unittestDirectory~"unittest";
	}
	else if(isGDC)
	{
		buildCommand~=" -o"~unittestDirectory~"unittest";	
	}
	else
	{
		buildCommand~=" -of="~unittestDirectory~"unittest";
	}

	if(isWindows)
	{
		buildCommand~=".exe" ;
	}
	
	//set up unit test library location
	{

		if(unittestLibraryLocation != "")
		{
			if(isDMD)
			{
				if(isWindows)
				{

					if(!force64Build)
					{
						buildCommand~=" -L+"~unittestLibraryLocation;
					}
					else
					{
						buildCommand~=" -L/LIBPATH:"~unittestLibraryLocation;
					}
				}
				else
				{
					buildCommand~=" -L-L"~unittestLibraryLocation;
				}
			}
			else if(isGDC)
			{
				buildCommand~=" -L"~unittestLibraryLocation;
			}
			else
			{
				if(isWindows)
				{
					buildCommand~=" -L=/LIBPATH:"~unittestLibraryLocation;
				}
				else
				{
					buildCommand~=" -L=-L"~unittestLibraryLocation;
				}
			}

		}
	}



	//writeln(buildCommand);

	auto status = executeShell(buildCommand);

	if(status.status !=0)
	{
		writeln(status.output);
		return false;
	}
	return true;
}

void buildDoc()
{
	writeln("Building documentation!");

	chdir("src");

	string files = "";
	foreach(theModule;modules)
	{
		foreach (string name; fileList[theModule])
		{
			if(isDFile(name))
			{
				files~= "dsfml/" ~theModule~"/"~name ~ " ";
			}
			
		}
	}

	string buildCommand = compiler~files ~ docCompilerSwitches;

	auto status = executeShell(buildCommand);

		if(status.status !=0)
		{
			writeln(status.output);
		}

	chdir("..");
}
void buildDocGDC()
{
	writeln("Building documentation!");

	chdir("src");

	foreach(theModule;modules)
	{
		foreach (string name; fileList[theModule])
		{
			if(isDFile(name))
			{
				string buildCommand = compiler~ "dsfml/" ~ theModule ~ name ~ docCompilerSwitches ~ " -fdoc-dir="~docDirectory~"dsfml/"~theModule;

				auto status = executeShell(buildCommand);

				if(status.status !=0)
				{
					writeln(status.output);
				}
			}
		}
	}

	chdir("..");
}

void buildInterfaceFiles()
{
	writeln("Building interface files!");

	chdir("src");

	string filelist = "";
	foreach(theModule;modules)
	{
		foreach (string name; dirEntries("dsfml/"~theModule, SpanMode.depth))
		{
			if(isDFile(name))
			{
				filelist~= name ~ " ";
			}
		}
	}

	//TODO: Fix this for GDC
	string buildCommand = compiler~filelist ~ interfaceCompilerSwitches;

	auto status = executeShell(buildCommand);

		if(status.status !=0)
		{
			writeln(status.output);
		}

	chdir("..");
}

void buildInterfaceFilesGDC()
{
	writeln("Building interface files!");

	chdir("src");

	foreach(theModule;modules)
	{
		foreach (string name; dirEntries("dsfml/"~theModule, SpanMode.depth))
		{

			if(isDFile(name))
			{

				string buildCommand = compiler~ name ~ interfaceCompilerSwitches ~ " -fintfc-dir="~interfaceDirectory~"dsfml/"~theModule;

				auto status = executeShell(buildCommand);

				if(status.status !=0)
				{
					writeln(status.output);
				}
			}

		}
	}	

	chdir("..");
}

void showHelp()
{
	writeln("Main switches:");
	writeln("-help      : Show all supported switches.");
	writeln("-lib       : Build static libraries");
	writeln("-doc       : Build documentation");
	writeln("-import    : Build interface files for importing");
	writeln("-unittest  : Build static libs and unittests");
	writeln("-all       : Build everything");
	writeln("-unittest:sharedDir  : Build static libs and unittests, sharedDir is the location of DSFMLC shared libraries");
	writeln("-all:sharedDir       : Build everything, sharedDir is the location of DSFMLC shared libraries");
	writeln();
	writeln("Modifier switches:");
	writeln("-m32        : force a 32 bit build");
	writeln("-m64        : force a 64 bit build");
	writeln("-dmd        : force using dmd as the compiler");
	writeln("-gdc        : force using gdc as the compiler");
	writeln("-ldc        : force using ldc as the compiler");

	writeln();
	writeln("Default (no switches passed) will be to build static libraries only with the compiler that built this script.");
}

//used to add quotes around full directories
//To be used in the next update (2.3)
string quoteString(string s)
{
	return `"`~s~`"`;
}

//checks if a file is a .d file.
//osx adds those stupid .DS_Store files when I am working on things, and I hate them.
bool isDFile(string name)
{
	string[] splitName = split(name, ".");

	return (splitName[$-1] == "d");
}

int main(string[] args)
{

	parseSwitches(args[1..$]);

	if(!checkSwitchErrors())
	{
		return -1;
	}


	if(unrecognizedSwitch || showingHelp)
	{
		if(unrecognizedSwitch)
		{
			writeln("Found unrecognized switch: ", unrecognizedSwitch);
		}

		showHelp();
		return -1;
	}

	writeln();
	initialize();
	if(buildingLibs)
	{
		if(!buildLibs())
		{
			return -1;
		}
	}
	if(buildingUnittests)
	{
		if(!buildLibs())
		{
			return -1;
		}
		if(!buildUnittests())
		{
			return -1;
		}
	}
	if(buildingDoc)
	{
		if(isGDC)
		{
			buildDocGDC();
		}
		else
		{
			buildDoc();
		}
	}
	if(buildingInterfaceFiles)
	{
		if(isGDC)
		{
			buildInterfaceFilesGDC();
		}
		else
		{
			buildInterfaceFiles();
		}
	}
	if(buildingAll)
	{
		if(!buildLibs())
		{
			return -1;
		}
		buildDoc();
		buildInterfaceFiles();
		if(!buildUnittests())
		{
			return -1;
		}
	}

	writeln("Done!");
	return 0;
}
