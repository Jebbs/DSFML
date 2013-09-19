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
module dsfml.graphics.circleshape;

import dsfml.graphics.shape;

import dsfml.system.vector2;

debug import std.stdio;

import std.math;

class CircleShape:Shape
{
	private
	{
		float m_radius; /// Radius of the circle
		uint m_pointCount; /// Number of points composing the circle
	}
	
	this(float radius = 0, uint pointCount = 30)
	{
		m_radius = radius;
		
		m_pointCount = pointCount;
		
		update();
	}
	
	~this()
	{
		debug writeln("Destroying CircleShape");
	}

	CircleShape dup() const
	{
		CircleShape temp = new CircleShape(m_radius, m_pointCount);
		
		temp.position = position;
		temp.rotation = rotation;
		temp.scale = scale;
		temp.origin = origin;
		
		return temp;
	}
	
	
	@property
	{
		void pointCount(uint newPointCount)
		{
			m_pointCount = newPointCount;
		}
		override uint pointCount()
		{
			return m_pointCount;
		}
	}
	
	override Vector2f getPoint(uint index) const
	{
		
		static const(float) pi = 3.141592654f;
		
		float angle = index * 2 * pi / m_pointCount - pi / 2;
		
		
		float x = cos(angle) * m_radius;
		float y = sin(angle) * m_radius;
		
		
		return Vector2f(m_radius + x, m_radius + y);
	}
	
	
	
	@property
	{
		void radius(float newRadius)
		{
			m_radius = newRadius;
			update();
		}
		float radius()
		{
			return m_radius;
		}
	}
	
	
}