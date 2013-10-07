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
module dsfml.graphics.color;

import std.conv;
import std.traits;
import std.algorithm;

struct Color
{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a = 255;

	static immutable Black = Color(0, 0, 0, 255);
	static immutable White = Color(255, 255, 255, 255);
	static immutable Red = Color(255, 0, 0, 255);
	static immutable Green = Color(0, 255, 0,255);
	static immutable Blue = Color(0, 0, 255,255);
	static immutable Yellow = Color(255, 255, 0, 255);
	static immutable Magenta = Color(255, 0, 255, 255);
	static immutable Cyan = Color(0, 255, 255, 255);
	static immutable Transparent = Color(0, 0, 0, 0);
	
	Color opBinary(string op)(Color otherColor) const
		if((op == "+") || (op == "-"))
	{
		static if(op == "+")
		{
			return Color(cast(ubyte)min(r+otherColor.r, 255),
			             cast(ubyte)min(g+otherColor.g, 255),
			             cast(ubyte)min(b+otherColor.b, 255),
			             cast(ubyte)min(a+otherColor.a, 255));
		}
		static if(op == "-")
		{
			return Color(cast(ubyte)max(r-otherColor.r, 0),
			             cast(ubyte)max(g-otherColor.g, 0),
			             cast(ubyte)max(b-otherColor.b, 0),
			             cast(ubyte)max(a-otherColor.a, 0));
		}
	}
	
	Color opBinary(string op, E)(E num) const
		if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			return Color(cast(ubyte)min(r*num, 255),
			             cast(ubyte)min(g*num, 255),
			             cast(ubyte)min(b*num, 255),
			             cast(ubyte)min(a*num, 255));
		}
		static if(op == "/")
		{
			return Color(cast(ubyte)max(r/num, 0),
			             cast(ubyte)max(g/num, 0),
			             cast(ubyte)max(b/num, 0),
			             cast(ubyte)max(a/num, 0));
		}
	}
	
	ref Color opOpAssign(string op)(Color otherColor)
		if((op == "+") || (op == "-"))
	{
		static if(op == "+")
		{
			r = cast(ubyte)min(r+otherColor.r, 255);
			g = cast(ubyte)min(g+otherColor.g, 255);
			b = cast(ubyte)min(b+otherColor.b, 255);
			a = cast(ubyte)min(a+otherColor.a, 255);
			return this;
		}
		static if(op == "-")
		{
			r = cast(ubyte)max(r-otherColor.r, 0);
			g = cast(ubyte)max(g-otherColor.g, 0);
			b = cast(ubyte)max(b-otherColor.b, 0);
			a = cast(ubyte)max(a-otherColor.a, 0);
			return this;
		}
	}
	
	ref Color opOpAssign(string op, E)(E num)
		if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			r = cast(ubyte)min(r*num, 255);
			g = cast(ubyte)min(g*num, 255);
			b = cast(ubyte)min(b*num, 255);
			a = cast(ubyte)min(a*num, 255);
			return this;
		}
		static if(op == "/")
		{
			r = cast(ubyte)max(r/num, 0);
			g = cast(ubyte)max(g/num, 0);
			b = cast(ubyte)max(b/num, 0);
			a = cast(ubyte)max(a/num, 0);
			return this;
		}
	}
	
	bool opEquals(Color otherColor) const
	{
		return ((r == otherColor.r) && (g == otherColor.g) && (b == otherColor.b) && (a == otherColor.a));
	}
	
	string toString() const
	{
		return "R: " ~ text(r) ~ " G: " ~ text(g) ~ " B: " ~ text(b) ~ " A: " ~ text(a);
	}
}
