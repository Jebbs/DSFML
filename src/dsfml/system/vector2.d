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

module dsfml.system.vector2;

import std.traits;
import std.conv;

struct Vector2(T)
	if(isNumeric!(T))
{
	public T x;
	public T y;
	
	this(T X,T Y)
	{	
		x = X;
		y = Y;	
	}
	

	
	//I think it could be a useful function, but
	//since it isn't part of the API I will leave it out for now.
	
	/*
//Returns a copy of the normalized vector instead of changing current one.
Vector2!(T) normalized()
{
double length = sqrt(cast(double)((x * x) +(y*y)));
if(length != 0)
{
return Vector2!(T)( cast(T)(x/length), cast(T)(y/length));
}
else
{
return Vector2!(T)(0,0);
}
}

//Had plans for a method that normalizes the vector instead of returning
//a normalized copy, but also not part of the API


*/
	
	Vector2!(T) opUnary(string s)() const
	if (s == "-")
	{
		return Vector2!(T)(-x, -y);
	}
	
	// Add/Subtract between two vector2's
	Vector2!(T) opBinary(string op, E)(Vector2!(E) otherVector) const
	if(isNumeric!(E) && ((op == "+") || (op == "-")))
	{
		static if (op == "+")
		{
			return Vector2!(T)(cast(T)(x+otherVector.x),cast(T)(y+otherVector.y));
		}
		static if(op == "-")
		{
			return Vector2!(T)(cast(T)(x-otherVector.x),cast(T)(y-otherVector.y));
		}
	}
	
	
	
	// Multiply/Divide a vector with a numaric value
	Vector2!(T) opBinary (string op, E)(E num) const
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if (op == "*")
		{
			return Vector2!(T)(cast(T)(x*num),cast(T)(y*num));
		}
		static if(op == "/")
		{
			return Vector2!(T)(cast(T)(x/num),cast(T)(y/num));
		}
	}
	
	
	// Assign Add/Subtract with another vector2
	ref Vector2!(T) opOpAssign(string op, E)(Vector2!(E) otherVector)
	if(isNumeric!(E) && ((op == "+") || (op == "-")))
	{
		static if(op == "+")
		{
			x = cast(T)(x + otherVector.x);
			y = cast(T)(y + otherVector.y);
			return this;
		}
		static if(op == "-")
		{
			x = cast(T)(x - otherVector.x);
			y = cast(T)(y - otherVector.y);
			return this;
		}
	}
	
	//Assign Multiply/Divide with a numaric value
	ref Vector2!(T) opOpAssign(string op,E)(E num)
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			x *= num;
			y *= num;
			return this;
		}
		static if(op == "/")
		{
			x /= num;
			y /= num;
			return this;
		}
	}
	
	
	//Compare operator
	bool opEquals(E)(const Vector2!(E) otherVector) const
	{
		return ((x == otherVector.x) && (y == otherVector.y));
	}
	
	//figured it would be useful for testing, debugging, etc
	string toString() const
	{
		return "X: " ~ text(x) ~ " Y: " ~ text(y);
	}
}

alias Vector2!(int) Vector2i;
alias Vector2!(float) Vector2f;
alias Vector2!(uint) Vector2u;

unittest
{
	import std.stdio;

	writeln("Unit test for Vector2");

	auto floatVector2 = Vector2f(100,100);

	assert((floatVector2/2) == Vector2f(50,50));

	assert((floatVector2*2) == Vector2f(200,200));

	assert((floatVector2 + Vector2f(50, 0)) == Vector2f(150, 100));

	assert((floatVector2 - Vector2f(50,0)) == Vector2f(50,100));

	floatVector2/=2;

	assert(floatVector2 == Vector2f(50,50));

	floatVector2*=2;

	assert(floatVector2 == Vector2f(100,100));

	floatVector2+= Vector2f(50,0);

	assert(floatVector2 == Vector2f(150,100));

	floatVector2-=Vector2f(50,100);

	assert(floatVector2 == Vector2f(100,0));


	writeln("Vector2 tests passed");
	writeln();


}

