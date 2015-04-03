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
module dsfml.graphics.rect;

import std.traits;

import dsfml.system.vector2;

/++
 + Utility class for manipulating 2D axis aligned rectangles.
 + 
 + A rectangle is defined by its top-left corner and its size.
 + 
 + It is a very simple class defined for convenience, so its member variables (left, top, width and height) are public and can be accessed directly, just like the vector classes (Vector2 and Vector3).
 + 
 + To keep things simple, Rect doesn't define functions to emulate the properties that are not directly members (such as right, bottom, center, etc.), it rather only provides intersection functions.
 + 
 + Rect uses the usual rules for its boundaries:
 + - The let and top edges are included in the rectangle's area
 + - The right (left + width) and bottom (top + height) edges are excluded from the rectangle's area
 + 
 + This means that IntRect(0, 0, 1, 1) and IntRect(1, 1, 1, 1) don't intersect.
 + 
 + Rect is a template and may be used with any numeric type, but for simplicity the instanciations used by SFML are typedefed:
 + - Rect!(int) is IntRect
 + - Rect!(float) is FloatRect
 + 
 + So that you don't have to care about the template syntax.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Rect.php#details
 +/
struct Rect(T)
	if(isNumeric!(T))
{
	/// Left coordinate of the rectangle.
	T left = 0;
	/// Top coordinate of the rectangle.
	T top = 0;
	/// Width of the rectangle.
	T width= 0;
	/// HEight of the rectangle.
	T height = 0;
	

	this(T rectLeft, T rectTop, T rectWidth, T rectHeight)
	{
		left = rectLeft;
		top = rectTop;
		width = rectWidth;
		height = rectHeight;
	}
	
	this(Vector2!(T) position, Vector2!(T) size)
	{
		left = position.x;
		top = position.y;
		width = size.x;
		height = size.y;
	}

	/**
	 * Check if a point is inside the rectangle's area.
	 * 
	 * Params:
	 * 		x	= X coordinate of the point to test
	 * 		y	= Y coordinate of the point to test
	 * 
	 * Returns: True if the point is inside, false otherwise.
	 */
	bool contains(E)(E X, E Y) const
		if(isNumeric!(E))
	{
		if(left <= X && X<= (left + width))
		{
			if(top <= Y && Y <= (top + height))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	/**
	 * Check if a point is inside the rectangle's area.
	 * 
	 * Params:
	 * 		point	= Point to test
	 * 
	 * Returns: True if the point is inside, false otherwise.
	 */
	bool contains(E)(Vector2!(E) point) const
		if(isNumeric!(E))
	{
		if(left <= point.x && point.x<= (left + width))
		{
			if(top <= point.y && point.y <= (top + height))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}

	/**
	 * Check the intersection between two rectangles.
	 * 
	 * Params:
	 * 		rectangle	= Rectangle to test
	 * 
	 * Returns: True if rectangles overlap, false otherwise.
	 */
	bool intersects(E)(Rect!(E) rectangle) const
	if(isNumeric!(E))
	{
		Rect!(T) rect;
		
		return intersects(rectangle, rect);
	}

	/**
	 * Check the intersection between two rectangles.
	 * 
	 * This overload returns the overlapped rectangle in the intersection parameter.
	 * 
	 * Params:
	 * 		rectangle		= Rectangle to test
	 * 		intersection	= Rectangle to be filled with the intersection
	 * 
	 * Returns: True if rectangles overlap, false otherwise.
	 */
	bool intersects(E,O)(Rect!(E) rectangle, out Rect!(O) intersection) const
		if(isNumeric!(E) && isNumeric!(O))
	{
		O interLeft = intersection.max(left, rectangle.left);
		O interTop = intersection.max(top, rectangle.top);
		O interRight = intersection.min(left + width, rectangle.left + rectangle.width);
		O interBottom = intersection.min(top + height, rectangle.top + rectangle.height);
		
		if ((interLeft < interRight) && (interTop < interBottom))
		{
			intersection = Rect!(O)(interLeft, interTop, interRight - interLeft, interBottom - interTop);
			return true;
		}
		else
		{
			intersection = Rect!(O)(0, 0, 0, 0);
			return false;
		}
	}

	bool opEquals(E)(const Rect!(E) otherRect) const
		if(isNumeric!(E))
	{
		return ((left == otherRect.left) && (top == otherRect.top) && (width == otherRect.width) && (height == otherRect.height) );
	}

	string toString()
	{
		import std.conv;
		return "Left: " ~ text(left) ~ " Top: " ~ text(top) ~ " Width: " ~ text(width) ~ " Height: " ~ text(height);
	}
	
	private T max(T a, T b)
	{
		if(a>b)
		{
			return a;
		}
		else
		{
			return b;
		}
	}
	
	private T min(T a, T b)
	{
		if(a<b)
		{
			return a;
		}
		else
		{
			return b;
		}
	}

}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;

		writeln("Unit test for Rect");

		auto rect1 = IntRect(0,0,100,100);
		auto rect2 = IntRect(10,10,100,100);
		auto rect3 = IntRect(10,10,10,10);
		auto point = Vector2f(-20,-20);



		assert(rect1.intersects(rect2));

		FloatRect interRect;

		rect1.intersects(rect2, interRect);

		assert(interRect == IntRect(10,10, 90, 90));

		assert(rect1.contains(10,10));

		assert(!rect1.contains(point));

		writeln();
	}
}

alias Rect!(int) IntRect;
alias Rect!(float) FloatRect;