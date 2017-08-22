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

/**
 * By default, $(U err) outputs to the same location as `stderr`, which is the
 * console if there's one available.
 *
 * It is a standard std.stdio.File instance, so it supports all the functions as
 * defined by this structure (write, writeln, open, lock, etc.)
 *
 * $(U err) can be redirected to write to another output, independantly of
 * `stderr`, by using the `open` function. Note that unlike SFML's `err()`,
 * DSFML's `err` cannot be redirected to 'nothing' at this time.
 *
 * Example:
 * ---
 * // Redirect to a file
 * auto file = File("dsfml-log.txt", "w");
 * auto previous = err;
 * err = file;
 *
 * // Restore the original output
 * err = previous;
 * ---
 */
module dsfml.system.err;

import std.stdio;

/**
* Standard std.stdio.File instance used by DSFML to output warnings and errors.
*/
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
