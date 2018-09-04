/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
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
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

/// A module containing the sleep function.
module dsfml.system.sleep;

public import dsfml.system.time;

/**
 * Make the current thread sleep for a given duration.
 *
 * sleep is the best way to block a program or one of its threads, as it doesn't
 * consume any CPU power.
 *
 * Params:
 *		duration = The length of time to sleep for
 */
void sleep(Time duration)
{
	import core.thread: Thread;
	import core.time: usecs;
	Thread.sleep(usecs(duration.asMicroseconds()));
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import std.stdio;

		writeln("Unit test for sleep function");

		writeln("Start!(sleeping for 1 second)");
		sleep(seconds(1));
		writeln("Done! Now sleeping for 2 seconds.");
		sleep(seconds(2));
		writeln("Done! I think you get the idea.");
		writeln();
	}
}
