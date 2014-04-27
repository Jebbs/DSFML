/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution


***All code is based on code written by Laurent Gomila***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML - For a full list see http://www.sfml-dev.org/license.php
*/

module dsfml.system.clock;

public import dsfml.system.time;

class Clock
{
	package sfClock* sfPtr;
	
	this()
	{
		sfPtr = sfClock_create();
	}
	
	package this(sfClock* clock)
	{
		sfPtr = clock;
	}
	
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfClock_destroy(sfPtr);
	}
	
	Time getElapsedTime() const
	{
		return Time(sfClock_getElapsedTime(sfPtr));
	}
	
	Time restart()
	{
		return Time(sfClock_restart(sfPtr));
	}
	
	@property
	Clock dup() const
	{
		return new Clock(sfClock_copy(sfPtr));
	}
	
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import std.stdio;
		import dsfml.system.sleep;
		import std.math;

		writeln("Unit test for Clock");

		Clock clock = new Clock();

		writeln("Counting Time for 5 seconds.(rounded to nearest second)");

		while(clock.getElapsedTime().asSeconds()<5)
		{
			writeln(ceil(clock.getElapsedTime().asSeconds()));
			sleep(seconds(1));
		}

		writeln();
	}
}


private extern(C):

struct sfClock;

sfClock* sfClock_create();
sfClock* sfClock_copy(const(sfClock*) clock);
void sfClock_destroy(sfClock* clock);
long sfClock_getElapsedTime(const(sfClock*) clock);
long sfClock_restart(sfClock* clock);

