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
 * Clock is a lightweight class for measuring time.
 *
 * Its provides the most precise time that the underlying OS can achieve
 * (generally microseconds or nanoseconds). It also ensures monotonicity, which
 * means that the returned time can never go backward, even if the system time
 * is changed.
 *
 * Example:
 * ---
 * auto clock = Clock();
 * ...
 * Duration duration1 = clock.getElapsedTime();
 * ...
 * Duration duration2 = clock.restart();
 * ---
 *
 * $(PARA The Duration value ($(I core.time.Duration)) returned by the clock can
 * then be converted to a number of seconds, milliseconds or even microseconds.)
 *
 * See_Also:
 * $(LINK2 https://dlang.org/library/core/time/duration.html, Duration)
 */
module dsfml.system.clock;

public import core.time;

/**
 * Utility class that measures the elapsed time.
 */
class Clock
{
	package MonoTime m_startTime;
	private alias currTime = MonoTime.currTime;

	/// Default constructor.
	this()
	{
		m_startTime = currTime;
	}

	/// Destructor
	~this()
	{
		import dsfml.system.config;
		mixin(destructorOutput);
	}

	/**
	 * Get the elapsed time.
	 *
	 * This function returns the time elapsed since the last call to `restart()`
	 * (or the construction of the instance if `restart()` has not been called).
	 *
	 * Returns: Time elapsed.
	 */
	Duration getElapsedTime() const
	{
		return currTime - m_startTime;
	}

	/**
	 * Restart the clock.
	 *
	 * This function puts the time counter back to zero. It also returns the
	 * time elapsed since the clock was started.
	 *
	 * Returns: Time elapsed.
	 */
	Duration restart()
	{
		MonoTime now = currTime;
		auto elapsed = now - m_startTime;
		m_startTime = now;

		return elapsed;
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

		while(clock.getElapsedTime().total!"seconds" < 5)
		{
			writeln(clock.getElapsedTime().total!"seconds");
			sleep(seconds(1));
		}

		writeln();
	}
}
