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

/**
 * $(U Lock) is a RAII wrapper for DSFML's Mutex.
 *
 * By unlocking it in its destructor, it ensures that the mutex will always be
 * released when the current scope (most likely a function) ends. This is even
 * more important when an exception or an early return statement can interrupt
 * the execution flow of the function.
 *
 * For maximum robustness, $(U Lock) should always be used to lock/unlock a
 * mutex.
 *
 * Note that this structure is provided for convenience when porting projects
 * from SFML to DSFML. The same effect can be achieved with scope guards and
 * Mutex.
 *
 * Example:
 * ---
 * auto mutex = Mutex();
 *
 * void function()
 * {
 *     auto lock = Lock(mutex); // mutex is now locked
 *
 *	   // mutex is unlocked if this function throws
 *     functionThatMayThrowAnException();
 *
 *     if (someCondition)
 *         return; // mutex is unlocked
 *
 * } // mutex is unlocked
 * ---
 *
 * $(PARA Because the mutex is not explicitly unlocked in the code, it may
 * remain locked longer than needed. If the region of the code that needs to be
 * protected by the mutex is not the entire function, a good practice is to
 * create a smaller, inner scope so that the lock is limited to this part of the
 * code.)
 *
 * Example:
 * ---
 * auto mutex = Mutex();
 *
 * void function()
 * {
 *     {
 *       auto lock = Lock(mutex);
 *       codeThatRequiresProtection();
 *
 *     } // mutex is unlocked here
 *
 *     codeThatDoesntCareAboutTheMutex();
 * }
 * ---
 *
 * $(PARA Having a mutex locked longer than required is a bad practice which can
 * lead to bad performances. Don't forget that when a mutex is locked, other
 * threads may be waiting doing nothing until it is released.)
 *
 * See_Also:
 * $(MUTEX_LINK)
 */
module dsfml.system.lock;

import dsfml.system.mutex;

/**
* Automatic wrapper for locking and unlocking mutexes.
*/
struct Lock
{
	private Mutex m_mutex;

	/**
	 * Construct the lock with a target mutex.
	 *
	 * The mutex passed to Lock is automatically locked.
	 *
	 * Params:
	 *   	mutex =	Mutex to lock
	 */
	this(Mutex mutex)
	{
		m_mutex = mutex;

		m_mutex.lock();
	}

	/// Destructor
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
		import core.time;
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

		//let this unit test finish before moving on to the next one
		sleep(seconds(1));
		writeln();
	}
}
