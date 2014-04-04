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

module dsfml.system.time;

import std.traits;

struct Time
{
	private long m_microseconds;
	
	package this(long microseconds)
	{
		m_microseconds = microseconds;
	}
	
	public float asSeconds()
	{
		return m_microseconds/1000000f;
	}
	int asMilliseconds()
	{
		return cast(int)(m_microseconds / 1000);
	}
	long asMicroseconds()
	{
		return m_microseconds;
	}
	

	
	static immutable(Time) Zero;
	
	bool opEquals(const ref Time rhs)
	{
		return m_microseconds == rhs.m_microseconds;
	}
	
	int opCmp(const ref Time rhs)
	{
		if(opEquals(rhs))
		{
			return 0;
		}
		else if(m_microseconds < rhs.m_microseconds)
		{
			return -1;
		}
		else
		{
			return 1;
		}

		
	}
	
	Time opUnary(string s)() const
	if (s == "-")
	{
		return microseconds(-m_microseconds);
	}
	
	
	Time opBinary(string op)(Time rhs) const
	if((op == "+") || (op == "-"))
	{
		static if (op == "+")
		{
			return microseconds(m_microseconds + rhs.m_microseconds);
		}
		static if(op == "-")
		{
			return microseconds(m_microseconds - rhs.m_microseconds);
		}
	}
	
	ref Time opOpAssign(string op)(Time rhs)
	if((op == "+") || (op == "-"))
	{
		static if(op == "+")
		{
			m_microseconds += rhs.m_microseconds;
			return this;
		}
		static if(op == "-")
		{
			m_microseconds -= rhs.m_microseconds;
			return this;
		}
	}
	
	
	Time opBinary (string op, E)(E num) const
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if (op == "*")
		{
			return microseconds(m_microseconds * num);
		}
		static if(op == "/")
		{
			return microseconds(m_microseconds / num);
		}
	}
	
	
	ref Time opOpAssign(string op,E)(E num)
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			m_microseconds *= num;
			return this;
		}
		static if(op == "/")
		{
			m_microseconds /= num;
			return this;
		}
	}
	
}

Time seconds(float amount)
{
	return Time(cast(long)(amount * 1000000));
}

Time milliseconds(int amount)
{
	return Time(amount*1000);
}

Time microseconds(long amount)
{
	return Time( amount);
}

unittest
{
	version(DSFML_Unittest_System)
	{

		import std.stdio;

		writeln("Unit test for Time Struct");

		auto time = seconds(1);

		assert(time.asSeconds() == 1);

		assert((time*2).asSeconds() == 2);

		assert((time/2).asSeconds() == .5f);

		assert((time+seconds(1)).asSeconds() == 2);

		assert((time-seconds(1)).asSeconds() == 0);

		time += seconds(1);

		assert(time.asSeconds() == 2);

		time -= seconds(1);

		assert(time.asSeconds() == 1);

		time/=2;

		assert(time.asSeconds() == .5f);

		time*=2;

		assert(time.asSeconds() == 1);

		writeln("Time Struct passes all tests.");
		writeln();
	}
}
