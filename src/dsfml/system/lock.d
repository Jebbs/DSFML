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

//Only useful for DSFML mutexes! Can easily be rewritten for built in mutexes.
module dsfml.system.lock;

import dsfml.system.mutex;

struct Lock
{
	private Mutex m_mutex;

	this(Mutex mutex)
	{
		m_mutex = mutex;

		m_mutex.lock();
	}

	~this()
	{
		m_mutex.unlock();
	}
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import dsfml.system.thread;
		import dsfml.system.mutex;
		import dsfml.system.sleep;
		import dsfml.system.time;
		import std.stdio;
	
		Mutex mutex = new Mutex();

		void mainThreadHello()
		{
			auto lock = Lock(mutex);
			for(int i = 0; i < 10; ++i)
			{
				writeln("Hello from the main thread!");
			}
			//unlock auto happens here
		}
		void secondThreadHello()
		{
			auto lock = Lock(mutex);
			for(int i = 0; i < 10; ++i)
			{
				writeln("Hello from the second thread!");
			}
			//unlock auto happens here
		}
	
	
		writeln("Unit test for Lock struct");
		writeln();
	
		writeln("Using a lock in the main and second thread.");
	
		auto secondThread = new Thread(&secondThreadHello);
	
		secondThread.launch();

		mainThreadHello();
	

		sleep(seconds(1));//let's this unit test finish before moving on to the next one.
		writeln();
	}
}


