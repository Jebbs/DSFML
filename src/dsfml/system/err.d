module dsfml.system.err;

import std.stdio;

File err;

static this()
{
	//Let's our err output go to the console by default
	err = stderr;
}