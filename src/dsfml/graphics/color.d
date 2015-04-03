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

import std.math, std.traits;

import std.algorithm;

/++
 + Color is a utility struct for manipulating 32-bits RGBA colors.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1Color.php#details
 +/
struct Color
{
	ubyte r; /// Red component
	ubyte g; /// Green component
	ubyte b; /// Blue component
	ubyte a = 255; /// Alpha component

	static immutable Black = Color(0, 0, 0, 255);
	static immutable White = Color(255, 255, 255, 255);
	static immutable Red = Color(255, 0, 0, 255);
	static immutable Green = Color(0, 255, 0,255);
	static immutable Blue = Color(0, 0, 255,255);
	static immutable Yellow = Color(255, 255, 0, 255);
	static immutable Magenta = Color(255, 0, 255, 255);
	static immutable Cyan = Color(0, 255, 255, 255);
	static immutable Transparent = Color(0, 0, 0, 0);

	string toString() const
	{
		import std.conv;
		return "R: " ~ text(r) ~ " G: " ~ text(g) ~ " B: " ~ text(b) ~ " A: " ~ text(a);
	}

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
			//actually dividing or multiplying by a negative
			if(num < 1)
			{
				return Color(cast(ubyte)max(r*num, 0),
				             cast(ubyte)max(g*num, 0),
				             cast(ubyte)max(b*num, 0),
				             cast(ubyte)max(a*num, 0));
			}
			else
			{
				return Color(cast(ubyte)min(r*num, 255),
			             	 cast(ubyte)min(g*num, 255),
			             	 cast(ubyte)min(b*num, 255),
			            	 cast(ubyte)min(a*num, 255));
			}
		}
		static if(op == "/")
		{
			//actually multiplying or dividing by a negative
			if(num < 1)
			{
				return Color(cast(ubyte)min(r/num, 255),
				             cast(ubyte)min(g/num, 255),
				             cast(ubyte)min(b/num, 255),
				             cast(ubyte)min(a/num, 255));
			}
			else
			{
				return Color(cast(ubyte)max(r/num, 0),
			    	         cast(ubyte)max(g/num, 0),
			       	   		 cast(ubyte)max(b/num, 0),
			       		     cast(ubyte)max(a/num, 0));
			}
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
			//actually dividing or multiplying by a negative
			if(num < 1)
			{
				r = cast(ubyte)max(r*num, 0);
				g = cast(ubyte)max(g*num, 0);
				b = cast(ubyte)max(b*num, 0);
				a = cast(ubyte)max(a*num, 0);
			}
			else
			{
				r = cast(ubyte)min(r*num, 255);
				g = cast(ubyte)min(g*num, 255);
				b = cast(ubyte)min(b*num, 255);
				a = cast(ubyte)min(a*num, 255);
			}

			return this;
		}
		static if(op == "/")
		{
			//actually multiplying or dividing by a negative
			if( num < 1)
			{
				r = cast(ubyte)min(r/num, 255);
				g = cast(ubyte)min(g/num, 255);
				b = cast(ubyte)min(b/num, 255);
				a = cast(ubyte)min(a/num, 255);
			}
			else
			{
				r = cast(ubyte)max(r/num, 0);
				g = cast(ubyte)max(g/num, 0);
				b = cast(ubyte)max(b/num, 0);
				a = cast(ubyte)max(a/num, 0);
			}

			return this;
		}
	}
	
	bool opEquals(Color otherColor) const
	{
		return ((r == otherColor.r) && (g == otherColor.g) && (b == otherColor.b) && (a == otherColor.a));
	}
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;

		writeln("Unit test for Color");

		//will perform arithmatic on Color to make sure everything works right.

		Color color = Color(100,100,100, 100);

		color*= 2;//(200, 200, 200, 200)

		color = color *.5;//(100, 100, 100, 100)

		color = color / 2;//(50, 50, 50, 50)

		color/= 2;//(25, 25, 25, 25)

		color+= Color(40,20,10,5);//(65,45, 35, 30)


		color-= Color(5,10,20,40);//(60, 35, 15, 0)

		color = color + Color(40, 20, 10, 5);//(100, 55, 25, 5)

		color = color - Color(5, 10, 20, 40);//(95, 45, 5, 0)

		assert(color == Color(95, 45, 5, 0));

		writeln();
	}
}