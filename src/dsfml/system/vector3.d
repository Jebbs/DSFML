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

module dsfml.system.vector3;

import std.traits;
import std.conv;

struct Vector3(T)
	if(isNumeric!(T))
{
	T x;
	T y;
	T z;
	
	this(T X,T Y,T Z)
	{
		
		x = X;
		y = Y;	
		z = Z;
		
	}

	
	Vector3!(T) opUnary(string s)() const
	if(s == "-")
	{
		return Vector3!(T)(-x,-y,-z);
	}
	
	// Add/Subtract between two vector3's
	Vector3!(T) opBinary(string op,E)(Vector3!(E) otherVector) const
	if(isNumeric!(E) && ((op == "+") || (op == "-")))
	{
		static if (op == "+")
		{
			return Vector3!(T)(cast(T)(x+otherVector.x),cast(T)(y+otherVector.y),cast(T)(z + otherVector.z));
		}
		static if(op == "-")
		{
			return Vector3!(T)(cast(T)(x-otherVector.x),cast(T)(y-otherVector.y),cast(T)(z - otherVector.z));
		}
		
	}
	
	
	
	// Multiply/Divide a Vector3 with a numaric value
	Vector3!(T) opBinary(string op,E)(E num) const
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if (op == "*")
		{
			return Vector3!(T)(cast(T)(x*num),cast(T)(y*num),cast(T)(z*num));
		}
		static if(op == "/")
		{
			return Vector3!(T)(cast(T)(x/num),cast(T)(y/num),cast(T)(z/num));
		}
	}
	
	
	
	// Assign Add/Subtract with another vector3
	ref Vector3!(T) opOpAssign(string op, E)(Vector3!(E) otherVector)
	if(isNumeric!(E) && ((op == "+") || (op == "-")))
	{
		static if(op == "+")
		{
			x += otherVector.x;
			y += otherVector.y;
			z += otherVector.z;
			return this;
		}
		static if(op == "-")
		{
			x -= otherVector.x;
			y -= otherVector.y;
			z -= otherVector.z;
			return this;
		}
	}
	
	//Assign Multiply/Divide a Vector3 with a numaric value
	ref Vector3!(T) opOpAssign(string op,E)(E num)
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			x *= num;
			y *= num;
			z *= num;
			return this;
		}
		static if(op == "/")
		{
			x /= num;
			y /= num;
			z /= num;
			return this;
		}
	}
	
	
	/* Omitted for the same reason as Vector3's normalize.
* I very much would like to include it though!
Vector3!(T) normalize()
{
double length = cbrt(cast(float)((x * x) + (y*y) + (z*z)));
if(length != 0)
{
return Vector3!(T)( cast(T)(x/length), cast(T)(y/length),cast(T)(y/length));
}
else
{
return Vector3!(T)(0,0,0);
}
}

//Likewise with the other normalize method.
*/
	string toString() const
	{
		return "X: " ~ text(x) ~ " Y: " ~ text(y) ~ text(" Z: ") ~ text(z);
	}
}

alias Vector3!(int) Vector3i;
alias Vector3!(float) Vector3f;

unittest
{
	import std.stdio;
	
	writeln("Unit test for Vector3");
	
	auto floatVector3 = Vector3f(100,100,100);
	
	assert((floatVector3/2) == Vector3f(50,50,50));
	
	assert((floatVector3*2) == Vector3f(200,200,200));
	
	assert((floatVector3 + Vector3f(50, 0,100)) == Vector3f(150, 100,200));

	assert((floatVector3 - Vector3f(50,0,300)) == Vector3f(50,100,-200));
	
	floatVector3/=2;
	
	assert(floatVector3 == Vector3f(50,50,50));
	
	floatVector3*=2;
	
	assert(floatVector3 == Vector3f(100,100,100));
	
	floatVector3+= Vector3f(50,0,100);
	
	assert(floatVector3 == Vector3f(150,100,200));
	
	floatVector3-=Vector3f(50,100,50);
	
	assert(floatVector3 == Vector3f(100,0,150));
	
	
	writeln("Vector3 tests passed");
	writeln();

}


