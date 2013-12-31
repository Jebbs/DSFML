module build;

import std.stdio;
import std.file;
import std.process;

version(DigitalMars)
{

}
else
{
	static assert(false, "Only DMD is currently supported by this build script.");

}

string currentDirectory;
string impDirectory;
string libDirectory;

string prefix;
string extension;
string compilerSwitches;

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
	static assert(false, "DSFML is only supported on OSX, Windows, and Linux. Try using an OS someone actually likes. ;D");
}


string[5] modules = ["system", "audio", "network", "window", "graphics"];


void initialize()
{

	currentDirectory = getcwd;
	impDirectory = currentDirectory~"/src";
	libDirectory = currentDirectory~"/lib/";

	if(isWindows)
	{
		writeln("Building for Windows");
		prefix = "";
		extension = ".lib";
		compilerSwitches = "-lib -O -release -inline -property -I"~impDirectory;
	}
	else if(isLinux)
	{
		writeln("Building for Linux");
		prefix = "lib";
		extension = ".a";
		compilerSwitches = "-lib -O -release -inline -property -I"~impDirectory;
	}
	else
	{
		writeln("Building for OSX");
		prefix = "lib";
		extension = ".a";
		compilerSwitches = "-lib -O -release -inline -property -I"~impDirectory;
	}
	writeln();
}

void build()
{
	foreach(theModule;modules)
	{
		string fileList = "";

		foreach (string name; dirEntries("src/dsfml/"~theModule, SpanMode.depth))
		{
			fileList~= name ~ " ";
		}

		string buildCommand = "dmd "~ fileList ~ compilerSwitches ~ " -of"~libDirectory~prefix~"dsfml-"~theModule~"-2"~extension;
		
		writeln("Building " ~ theModule~ " module.");
		
		auto status = executeShell(buildCommand);
	}
}
void main(string[] args)
{

	writeln("You're about to build DSFML! Go you!");
	writeln();
	initialize();
	build();
	writeln("Done!");
}
