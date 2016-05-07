/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

///A module containing the Mutex class used by DSFML.
module dsfml.system.mutex;

import core = core.sync.mutex;

/**
 *Blocks concurrent access to shared resources from multiple threads.
 *
 *Mutex stands for "MUTual EXclusion".
 *
 *A mutex is a synchronization object, used when multiple threads are involved.
 *
 *When you want to protect a part of the code from being accessed simultaneously by multiple threads, you typically use a mutex.
 *When a thread is locked by a mutex, any other thread trying to lock it will be blocked until the mutex is released by the thread that locked it.
 *This way, you can allow only one thread at a time to access a critical region of your code.
 */
class Mutex
{
	private core.Mutex m_mutex;

	///Default Constructor
	this()
	{
		m_mutex = new core.Mutex();
	}

	//Destructor
	~this()
	{
		import dsfml.system.config;
		mixin(destructorOutput);
	}

	///Lock the mutex
	///
	///If the mutex is already locked in another thread, this call will block the execution until the mutex is released.
	void lock()
	{
		m_mutex.lock();
	}

	//Unlock the mutex
	void unlock()
	{
		m_mutex.unlock();
	}
}




unittest
{
	version(DSFML_Unittest_System)
	{
		import dsfml.system.thread;
		import dsfml.system.sleep;
		import core.time;
		import std.stdio;

		auto mutex = new Mutex();

		void secondThreadHello()
		{
			mutex.lock();
			for(int i = 0; i < 10; ++i)
			{
				writeln("Hello from the second thread!");
			}
			mutex.unlock();
		}


		writeln("Unit test for Mutex class");
		writeln();
	
		writeln("Locking a mutex and then unlocking it later.");
	
		auto secondThread = new Thread(&secondThreadHello);

		secondThread.launch();

		mutex.lock();
	
		for(int i = 0; i < 10; ++i)
		{
			writeln("Hello from the main thread!");
		}

		mutex.unlock();
		sleep(seconds(1));//let's this unit test finish before moving on to the next one.
		writeln();
	}
}
