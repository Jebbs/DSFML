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
 * Vector3 is a simple class that defines a mathematical vector with three
 * coordinates (x, y and z). It can be used to represent anything that has three
 * dimensions: a size, a point, a velocity, etc.
 *
 * The template parameter `T` is the type of the coordinates. It can be any type
 * that supports arithmetic operations (+, -, /, *) and comparisons (==, !=),
 * for example int or float.
 *
* You generally don't have to care about the templated form (Vector2!(T)),
 * the most common specializations have special aliases:
 * $(UL
 * $(LI Vector3!(float) is Vector2f)
 * $(LI Vector3!(int) is Vector2i))
 *
 * Example:
 * ---
 * auto v1 = Vector3f(16.5f, 24.f, -8.2f);
 * v1.x = 18.2f;
 * float y = v1.y;
 * float z = v1.z;
 *
 * auto v2 = v1 * 5.f;
 * Vector3f v3;
 * v3 = v1 + v2;
 *
 * bool different = (v2 != v3);
 * ---
 *
 * See_Also:
 * $(VECTOR2_LINK)
 */
module dsfml.system.vector3;

import std.traits;

/**
 * Utility template struct for manipulating 3-dimensional vectors.
 */
struct Vector3(T)
	if(isNumeric!(T) || is(T == bool))
{
	/// X coordinate of the vector.
	T x;

	/// Y coordinate of the vector.
	T y;

	/// Z coordinate of the vector.
	T z;

	/**
	 * Construct the vector from its coordinates
	 *
	 * Params:
	 * 		X = X coordinate
	 * 		Y = Y coordinate
	 * 		Z = Z coordinate
	 */
	this(T X,T Y,T Z)
	{

		x = X;
		y = Y;
		z = Z;

	}

	/**
	 * Construct the vector from another type of vector
	 *
	 * Params:
	 * 	otherVector = Vector to convert.
	 */
	this(E)(Vector3!(E) otherVector)
	{
		x = cast(T)(otherVector.x);
		y = cast(T)(otherVector.y);
		z = cast(T)(otherVector.z);
	}

	/// Invert the members of the vector.
	Vector3!(T) opUnary(string s)() const
	if(s == "-")
	{
		return Vector3!(T)(-x,-y,-z);
	}

	/// Add/Subtract between two vector3's.
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

	/// Multiply/Divide a Vector3 with a numaric value.
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

	/// Assign Add/Subtract with another vector3.
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

	// Assign Multiply/Divide a Vector3 with a numaric value.
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

	/// Assign the value of another vector whose type can be converted to T.
	ref Vector3!(T) opAssign(E)(Vector3!(E) otherVector)
	{
		x = cast(T)(otherVector.x);
		y = cast(T)(otherVector.y);
		z = cast(T)(otherVector.z);
		return this;
	}

	/// Compare two vectors for equality.
	bool opEquals(E)(const Vector3!(E) otherVector) const
	if(isNumeric!(E))
	{
		return ((x == otherVector.x) && (y == otherVector.y)
				&& (z == otherVector.z));
	}

	/// Output the string representation of the Vector3.
	string toString() const
	{
		import std.conv;
		return "X: " ~ text(x) ~ " Y: " ~ text(y) ~ " Z: " ~ text(z);
	}
}

/// Definition of a Vector3 of integers.
alias Vector3!(int) Vector3i;

/// Definition of a Vector3 of floats.
alias Vector3!(float) Vector3f;

unittest
{
	version(DSFML_Unittest_System)
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
}
