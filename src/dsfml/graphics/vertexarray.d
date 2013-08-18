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
module dsfml.graphics.vertexarray;

import dsfml.graphics.vertex;
import dsfml.graphics.primitivetype;

import dsfml.graphics.rect;

import dsfml.graphics.drawable;

import dsfml.graphics.rendertarget;

import dsfml.graphics.renderstates;

import dsfml.system.vector2;


import std.algorithm;
debug import std.stdio;

class VertexArray:Drawable
{
	
	PrimitiveType primativeType;
	private Vertex[] Vertices;
	
	
	this(PrimitiveType type, uint vertexCount)
	{
		primativeType = type;
		
		Vertices = new Vertex[vertexCount];
	}
	
	private this(PrimitiveType type, Vertex[] vertices)
	{
		primativeType = type;
		
		Vertices = vertices;
	}
	
	~this()
	{
		debug writeln("Destroying Vertex Array");
	}
	
	VertexArray dup() const
	{
		return new VertexArray(this.primativeType,Vertices.dup);
	}
	
	
	ref Vertex opIndex(size_t index)
	{
		return Vertices[index];
	}
	
	
	void append(Vertex newVertex)
	{
		Vertices ~= newVertex;
	}
	void clear()
	{
		Vertices.length = 0;
	}
	
	void resize(uint length)
	{
		Vertices.length = length;
	}
	
	uint getVertexCount()
	{
		return cast(uint)min(uint.max, Vertices.length);
	}
	
	
	FloatRect getBounds()
	{
		
		if (Vertices.length>0)
		{
			float left = Vertices[0].position.x;
			float top = Vertices[0].position.y;
			float right = Vertices[0].position.x;
			float bottom = Vertices[0].position.y;
			
			for (size_t i = 1; i < Vertices.length; ++i)
			{
				Vector2f position = Vertices[i].position;
				
				// Update left and right
				if (position.x < left)
					left = position.x;
				else if (position.x > right)
					right = position.x;
				
				// Update top and bottom
				if (position.y < top)
					top = position.y;
				else if (position.y > bottom)
					bottom = position.y;
			}
			
			return FloatRect(left, top, right - left, bottom - top);
		}
		else
		{
			return FloatRect(0,0,0,0);
		}
		
		
	}
	
	
	override void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		if(Vertices.length != 0)
		{
			renderTarget.draw(Vertices, primativeType,renderStates);
		}
		
	}
	
	
}