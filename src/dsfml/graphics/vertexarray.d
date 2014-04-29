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

/++
 + Define a set of one or more 2D primitives.
 + 
 + VertexArray is a very simple wrapper around a dynamic array of vertices and a primitives type.
 + 
 + It inherits Drawable, but unlike other drawables it is not transformable.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1VertexArray.php#details
 +/
class VertexArray : Drawable
{
	/**
	 * The type of primitive to draw.
	 * 
	 * Can be any of the following:
	 * - Points
	 * - Lines
	 * - Triangles
	 * - Quads
	 * 
	 * The default primitive type is Points.
	 */
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
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
	}

	/**
	 * Compute the bounding rectangle of the vertex array.
	 * 
	 * This function returns the axis-aligned rectangle that contains all the vertices of the array.
	 * 
	 * Returns: Bounding rectangle of the vertex array.
	 */
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

	/**
	 * Return the vertex count.
	 * 
	 * Returns: Number of vertices in the array
	 */
	uint getVertexCount()
	{
		import std.algorithm;
		return cast(uint)min(uint.max, Vertices.length);
	}

	/**
	 * Add a vertex to the array.
	 * 
	 * Params:
	 * 		vertex	= Vertex to add.
	 */
	void append(Vertex newVertex)
	{
		Vertices ~= newVertex;
	}

	/**
	 * Clear the vertex array.
	 * 
	 * This function removes all the vertices from the array. It doesn't deallocate the corresponding memory, so that adding new vertices after clearing doesn't involve reallocating all the memory.
	 */
	void clear()
	{
		Vertices.length = 0;
	}

	/**
	 * Draw the object to a render target.
	 * 
	 * Params:
	 *  		renderTarget =	Render target to draw to
	 *  		renderStates =	Current render states
	 */
	override void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		if(Vertices.length != 0)
		{
			renderTarget.draw(Vertices, primativeType,renderStates);
		}
	}

	/**
	 * Resize the vertex array.
	 * 
	 * If vertexCount is greater than the current size, the previous vertices are kept and new (default-constructed) vertices are added. If vertexCount is less than the current size, existing vertices are removed from the array.
	 * 
	 * Params:
	 * 		vertexCount	= New size of the array (number of vertices).
	 */
	void resize(uint length)
	{
		Vertices.length = length;
	}

	ref Vertex opIndex(size_t index)
	{
		return Vertices[index];
	}
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;
		import dsfml.graphics.texture;
		import dsfml.graphics.rendertexture;
		import dsfml.graphics.color;

		writeln("Unit test for VertexArray");

		auto texture = new Texture();

		assert(texture.loadFromFile("res/star.png"));



		auto dimensions = FloatRect(0,0,texture.getSize().x,texture.getSize().y);

		auto vertexArray = new VertexArray(PrimitiveType.Quads, 0);

		//Creates a vertex array at position (0,0) the width and height of the loaded texture
		vertexArray.append(Vertex(Vector2f(dimensions.left,dimensions.top), Color.Blue, Vector2f(dimensions.left,dimensions.top)));
		vertexArray.append(Vertex(Vector2f(dimensions.left,dimensions.height), Color.Blue, Vector2f(dimensions.left,dimensions.height)));
		vertexArray.append(Vertex(Vector2f(dimensions.width,dimensions.height), Color.Blue, Vector2f(dimensions.width,dimensions.height)));
		vertexArray.append(Vertex(Vector2f(dimensions.width,dimensions.top), Color.Blue, Vector2f(dimensions.width,dimensions.top)));


		auto renderStates = RenderStates(texture);


		auto renderTexture = new RenderTexture();
		
		assert(renderTexture.create(100,100));

		renderTexture.clear();

		//draw the VertexArray with the texture we loaded
		renderTexture.draw(vertexArray, renderStates);

		renderTexture.display();

		writeln();
	}
}