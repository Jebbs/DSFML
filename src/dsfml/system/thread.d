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

///A module containing the DSFML Thread class
module dsfml.system.thread;

import core = core.thread;

/**
 *Utility class to manipulate threads.
 *
 *Threads provide a way to run multiple parts of the code in parallel.
 *
 *When you launch a new thread, the execution is split and both the new thread and the caller run in parallel. 
 *
 *To use a Thread, you construct it directly with the function to execute as the entry point of the thread.
 */
class Thread
{
	private core.Thread m_thread;

	///Construct the thread from a functor with no argument
	///
	///Params:
	///		fn  = The function to use as the entry point of the thread.
	///		sz  = The size of the stack.
	this(void function() fn, size_t sz = 0)
	{
		m_thread = new core.Thread(fn,sz);
	}

	///Construct the thread from a delegate with no argument
	///
	///Params:
	///		dg  = The delegate to use as the entry point of the thread.
	///		sz  = The size of the stack.
	this(void delegate() dg, size_t sz = 0)
	{
		m_thread = new core.Thread(dg, sz);
	}

	///Destructor
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
	}

	///Run the thread.
	void launch()
	{
		m_thread.start();
	}

	///Wait until the thread finishes.
	void wait()
	{
		if(m_thread.isRunning())
		{
			m_thread.join(true);
		}
	}

	version(linux)
	{
		static void XInitThreads()
		{
            linux_XInitThreads();
		}
	}

}

unittest
{


	version(DSFML_Unittest_System)
	{
		import std.stdio;
		import dsfml.system.sleep;
		import dsfml.system.time;
		

		void secondThreadHello()
		{
			for(int i = 0; i < 10; ++i)
			{
				writeln("Hello from the second thread!");
			}
		}




		writeln("Unit test for Thread class");
		writeln();

		writeln("Running two functions at once.");

		auto secondThread = new Thread(&secondThreadHello);


		secondThread.launch();

		for(int i = 0; i < 10; ++i)
		{
			writeln("Hello from the main thread!");
		}

		sleep(seconds(1));

		//writeln("Letting a thread run completely before going back to the main thread.");

		//secondThread = new Thread(&secondThreadHello);//To prevent threading errors, create a new thread before calling launch again

		//secondThread.launch();

		//secondThread.wait();

		//for(int i = 0; i < 10; ++i)
		//{
		//	writeln("Hello from the main thread!");
		//}
	}

}


version(linux) package extern(C) void linux_XInitThreads();

