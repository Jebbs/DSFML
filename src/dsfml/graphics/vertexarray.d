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
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
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

	uint getVertexCount()
	{
		import std.algorithm;
		return cast(uint)min(uint.max, Vertices.length);
	}

	void append(Vertex newVertex)
	{
		Vertices ~= newVertex;
	}

	void clear()
	{
		Vertices.length = 0;
	}

	override void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		if(Vertices.length != 0)
		{
			renderTarget.draw(Vertices, primativeType,renderStates);
		}
	}

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