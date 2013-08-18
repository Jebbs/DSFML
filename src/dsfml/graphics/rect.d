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
import std.conv;
import dsfml.system.vector2;

struct Rect(T)
	if(isNumeric!(T))
{
	T left = 0;
	T top = 0;
	T width= 0;
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
	

	
	bool contains(E)(E X, E Y)
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
	bool contains(E)(Vector2!(E) point)
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
	
	bool intersects(E)(Rect!(E) rectangle)
		if(isNumeric!(E))
	{
		Rect!(T) rect;
		
		return intersects(rectangle, rect);
	}
	
	bool intersects(E,O)(Rect!(E) rectangle, out Rect!(O) intersection)
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
	
	
	string toString()
	{
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

alias Rect!(int) IntRect;
alias Rect!(float) FloatRect;