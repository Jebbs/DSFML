/*
Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty. 
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
*/

module dsfml.system;

import std.math;
import std.conv;
import std.traits;
import std.utf;

debug import std.stdio;


class Clock
{
	package sfClock* sfPtr;

	this()
	{
		sfPtr = sfClock_create();
	}

	package this(sfClock* clock)
	{
		sfPtr = clock;
	}

	~this()
	{
		debug writeln("Destroying Clock");
		sfClock_destroy(sfPtr);
	}

	Time getElapsedTime() const
	{
		return Time(sfClock_getElapsedTime(sfPtr));
	}

	Time restart()
	{
		return Time(sfClock_restart(sfPtr));
	}

	Clock dup() const
	{
		return new Clock(sfClock_copy(sfPtr));
	}

}


//InputStreams class planned for Revision 2(for when I have more time to look into C callbacks and test)


struct Time
{
	package sfTime InternalsfTime;

	package this(sfTime newTime)
	{
		InternalsfTime = newTime;
	}

	float asSeconds() 
	{
		return InternalsfTime.microseconds/1000000f;
	}
	int asMilliseconds() 
	{
		return cast(int)(InternalsfTime.microseconds / 1000);
	}
	long asMicroseconds() 
	{
		return InternalsfTime.microseconds;
	}

	static Time seconds(float amount)
	{
		return Time(sfSeconds(amount));
	}
	
	static Time milliseconds(int amount)
	{
		return Time(sfMilliseconds(amount));
	}
	
	static Time microseconds(long amount)
	{
		return Time( sfMicroseconds(amount));
	}

	static immutable(Time) Zero;

	bool opEquals(const ref Time rhs)
	{
		return InternalsfTime.microseconds == rhs.InternalsfTime.microseconds;
	}

	int opCmp(const ref Time rhs)
	{
		if(opEquals(rhs))
		{
			return 0;
		}
		else if(InternalsfTime.microseconds < rhs.InternalsfTime.microseconds)
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
		return microseconds(-InternalsfTime.microseconds);
	}


	Time opBinary(string op)(Time rhs) const
	if((op == "+") || (op == "-"))
	{
		static if (op == "+")
		{
			return asMicroseconds(InternalsfTime.microseconds + rhs.InternalsfTime.microseconds);
		}
		static if(op == "-")
		{
			return asMicroseconds(InternalsfTime.microseconds - rhs.InternalsfTime.microseconds);
		}
	}

	ref Time opOpAssign(string op)(Time rhs) 
	if((op == "+") || (op == "-"))
	{
		static if(op == "+")
		{
			InternalsfTime.microseconds += rhs.InternalsfTime.microseconds;
			return this;
		}
		static if(op == "-")
		{
			InternalsfTime.microseconds -= rhs.InternalsfTime.microseconds;
			return this;
		}
	}


	Time opBinary (string op, E)(E num) const
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if (op == "*")
		{
			return microseconds(InternalsfTime.microseconds * num);
		}
		static if(op == "/")
		{
			return microseconds(InternalsfTime.microseconds / num);
		}
	}


	ref Time opOpAssign(string op,E)(E num)
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			InternalsfTime.microseconds *= num;
			return this;
		}
		static if(op == "/")
		{
			InternalsfTime.microseconds /= num;
			return this;
		}
	}

}



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
	
	package this(sfVector2f vector2)
	{
		x = cast(T)vector2.x;
		y = cast(T)vector2.y;
	}

	package this(sfVector2i vector2)
	{
		x = cast(T)vector2.x;
		y = cast(T)vector2.y;
	}

	package this(sfVector2u vector2)
	{
		x = cast(T)vector2.x;
		y = cast(T)vector2.y;
	}

	//Easy converting into CSFML types
	package sfVector2f tosfVector2f() const 
	{
		return sfVector2f(cast(float)x, cast(float)y);
	}
	package sfVector2i tosfVector2i() const
	{
		return sfVector2i(cast(int)x, cast(int)y);
	}
	package sfVector2u tosfVector2u() const
	{
		return sfVector2u(cast(uint)x, cast(uint)y);
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

	package this(sfVector3f vector3)
	{
		x = cast(T)vector3.x;
		y = cast(T)vector3.y;
		z = cast(T)vector3.z;
	}

	package sfVector3f tosfVector3f()
	{
		return sfVector3f(cast(float)x, cast(float)y, cast(float)z);
	}
	
	Vector3!(T) opUnary(string s)() const
	if(s == "-")
	{ 
		return Vector3!(T)(-x,-y,-z); 
	}
	
	// Add/Subtract between two vector3's
	Vector3!(T) opBinary(string op,E)(Vector3!(E) otherVector) const
	if(isNumeric!(E) && ((s == "+") || (s == "-")))
	{
		static if (op == "+")
		{
			return Vector3!(T)(cast(T)(x+otherVector.x),cast(T)(y+otherVector.y),cast(T)(z + otherVctor.z));
		}
		static if(op == "-")
		{
			return Vector2!(T)(cast(T)(x-otherVector.x),cast(T)(y-otherVector.y),cast(T)(z - otherVctor.z));
		}
		
	}



	// Multiply/Divide a Vector3 with a numaric value
	Vector3!(T) opBinary(string op,E)(E num) const
	if(isNumeric!(E) && ((s == "*") || (s == "/")))
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
	if(isNumeric!(E) && ((s == "+") || (s == "-")))
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
	ref Vector3!(T) opOpAssign(string op)(T num)
	if(isNumeric!(E) && ((s == "*") || (s == "/")))
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


	/*  Omitted for the same reason as Vector2's normalize. 
	 *  I very much would like to include it though!
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


enum DSFML_VERSION
{
	MAJOR = 2,
	MINOR = 0,
	REVISION = 1
}


//Left in Revision 1 for those that want to play with C callbacks in D
//until I get the InputStream class working
struct sfInputStream
{
	sfInputStreamReadFunc read;
	sfInputStreamSeekFunc seek;
	sfInputStreamTellFunc tell;
	sfInputStreamGetSizeFunc getSize;
	void *userData;
}

extern(C)
{
	alias long function(void*, long, void*) sfInputStreamReadFunc;
	alias long function(long, void*) sfInputStreamSeekFunc;
	alias long function(void*) sfInputStreamTellFunc;
	alias long function(void*) sfInputStreamGetSizeFunc;
}


//Internal binding portion
//User should not even know this stuff exists!
package:


//Takes a dstring(a UTF-32 string), makes sure it has a \0 character at the end of it, and returns a pointer of uints for SFML to use.
const(uint)* toUint32Ptr(ref dstring theDstring)
{
	return cast(const(uint)*)toUTFz!(const(dchar)*)(theDstring);
}

alias int sfBool;
enum sfFalse = 0;
enum sfTrue = 1;

struct sfClock;


struct sfTime
{
	long microseconds;
}
immutable(sfTime) sfTime_Zero;
struct sfVector2i
{
	int x;
	int y;
}
struct sfVector2u
{
	uint x;
	uint y;
}
struct sfVector2f
{
	float x;
	float y;
}
struct sfVector3f
{
	float x;
	float y;
	float z;
}
extern (C) 
{
	//Clock
	sfClock* sfClock_create();
	sfClock* sfClock_copy(const(sfClock*) clock);
	void sfClock_destroy(sfClock* clock);
	sfTime sfClock_getElapsedTime(const(sfClock*) clock);
	sfTime sfClock_restart(sfClock* clock);
	float sfTime_asSeconds(sfTime time);
	int sfTime_asMilliseconds(sfTime time);
	long sfTime_asMicroseconds(sfTime time);
	sfTime sfSeconds(float amount);
	sfTime sfMilliseconds(int amount);
	sfTime sfMicroseconds(long amount);


}


