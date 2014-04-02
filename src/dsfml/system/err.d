module dsfml.system.err;

import std.stdio;

File err;

static this()
{
	//Let's our err output go to the console by default
	err = stderr;
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import std.stdio;
		import std.file;
		
		writeln("Unit test for err");
	
		
		writeln("Writing a line to err");
		err.writeln("This line was written with err.");

		writeln("Routing err to a file, and then writing to it.");
		err.open("log.txt", "w");
		err.writeln("This line was written with err after being routed to log.txt");
		err.detach();//need to detach before being able to read the contents of the file(it's in use while open)

		writeln("Reading log.txt to confirm its contents.");

		auto contents = cast(string)read("log.txt");

		writeln("The contents of the text file are as follows: ", contents);

		writeln("Routing err back to the console.");
		err = stderr;//in this case, stderr is still writing to the console, but I could have used stdout as well.

		writeln("And writing to err one final time.");
		err.writeln("This is the last line in the unit test to be written to err!");
	
		writeln();

	}
	
}