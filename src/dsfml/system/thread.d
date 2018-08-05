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
 * Threads provide a way to run multiple parts of the code in parallel. When you
 * launch a new thread, the execution is split and both the new thread and the
 * caller run in parallel.
 *
 * To use a $(U Thread), you construct it directly with the function to execute
 * as the entry point of the thread. $(U Thread) has multiple template
 * constructors, which means that you can use several types of entry points:
 * $(UL
 * $(LI functions with no arguments)
 * $(LI delegates with no arguments))
 *
 * $(PARA
 * The thread ends when its function is terminated. If the owner $(U Thread)
 * instance is destroyed before the thread is finished, the destructor will wait
 * (see `wait()`).)
 *
 * Example:
 * ---
 * // example 1: function
 * void threadFunc()
 * {
 *   ...
 * }
 *
 * auto thread = new Thread(&threadFunc);
 * thread.launch();
 *
 * // example 2: delegate
 * class Task
 * {
 *    void run()
 *    {
 *       ...
 *    }
 * }
 *
 * auto task = new Task();
 * auto thread = new Thread(&task.run);
 * thread.launch();
 * ---
 */
module dsfml.system.thread;

import core = core.thread;

/**
 * Utility class to manipulate threads.
 */
class Thread
{
	private core.Thread m_thread;

	/**
	 * Construct the thread from a functor with no argument
	 *
	 * Params:
	 * 		fn  = The function to use as the entry point of the thread
	 * 		sz  = The size of the stack
	 */
	this(void function() fn, size_t sz = 0)
	{
		m_thread = new core.Thread(fn,sz);
	}

	/**
	 * Construct the thread from a delegate with no argument
	 *
	 * Params:
	 * 		dg  = The delegate to use as the entry point of the thread
	 * 		sz  = The size of the stack
	 */
	this(void delegate() dg, size_t sz = 0)
	{
		m_thread = new core.Thread(dg, sz);
	}

	/// Destructor
	~this()
	{
		import dsfml.system.config;
		mixin(destructorOutput);
	}

	/// Run the thread.
	void launch()
	{
		m_thread.start();
	}

	/// Wait until the thread finishes.
	void wait()
	{
		if(m_thread.isRunning())
		{
			m_thread.join(true);
		}
	}
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import std.stdio;
		import dsfml.system.sleep;
		import core.time;

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
