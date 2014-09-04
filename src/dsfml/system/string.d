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

///This module contains functions for interacting with strings going to and from 
///a C/C++ library. This module has no dependencies.
module dsfml.system.string;

//Returns a string copy of a zero terminated C style string
immutable(T)[] toString(T)(in const(T)* str) pure
	if (is(T == dchar)||is(T == wchar)||is(T == char))
{
	return str[0..strlen(str)].idup;
}

//returns a C style string from a D string type
const(T)* toStringz(T)(in immutable(T)[] str) nothrow 
	if (is(T == dchar)||is(T == wchar)||is(T == char))
{
	//TODO: get rid of GC usage
	static T[] copy;//a means to store the copy after returning the address

	//Already zero terminated
	if(str[$-1] == 0)
	{
		return str.ptr;
	}
	//not zero terminated
	else
	{
		copy = new T[str.length+1];
		copy[0..str.length] = str[];
		copy[$-1] = 0;

		return copy.ptr;

	}
}

//get's the length of a C style string
size_t strlen(T)(in const(T)* str) pure nothrow
if (is(T == dchar)||is(T == wchar)||is(T == char))
{
	size_t n = 0;
	for (; str[n] != 0; ++n) {}
	return n;
}

unittest
{
	version(DSFML_Unittest_System)
	{
		import std.stdio;
		
		writeln("Unit test for sleep function");


	}

}
