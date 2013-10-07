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
module dsfml.graphics.sprite;

import dsfml.graphics.drawable;
import dsfml.graphics.transformable;
import dsfml.graphics.transform;
import dsfml.graphics.texture;
import dsfml.graphics.rect;
import dsfml.graphics.vertex;

import dsfml.graphics.color;
import dsfml.graphics.rendertarget;
import dsfml.graphics.renderstates;
import dsfml.graphics.primitivetype;

import dsfml.system.vector2;
import std.typecons;

import std.stdio;

class Sprite:Drawable,Transformable
{
	mixin NormalTransformable;

	private
	{
		Vertex[4] m_vertices;
		Rebindable!(const(Texture)) m_texture;
		IntRect m_textureRect;
	}

	this()
	{
		m_texture = null;
		m_textureRect = IntRect();
	}
	
	this(const(Texture) texture)
	{
		// Constructor code
		m_textureRect = IntRect();
		setTexture(texture);
	}

	
	Sprite dup() const
	{
		return new Sprite();
	}

	
	void setTexture(const(Texture) texture, bool rectReset = false)
	{
		if(rectReset || ((m_texture is null) && (m_textureRect == IntRect())))
		{
			textureRect(IntRect(0,0,texture.getSize().x,texture.getSize().y));
		}

		m_texture = texture;
	}

	const(Texture) getTexture()
	{
		return m_texture;
	}
	
	@property
	{
		void textureRect(IntRect rect)
		{
			if (rect != m_textureRect)
			{
				m_textureRect = rect;
				updatePositions();
				updateTexCoords();
			}
			
		}
		
		IntRect textureRect()
		{
			return m_textureRect;
		}
	}
	
	@property//color
	{
		void color(Color newColor)
		{
			// Update the vertices' color
			m_vertices[0].color = color;
			m_vertices[1].color = color;
			m_vertices[2].color = color;
			m_vertices[3].color = color;
		}
		
		Color color()
		{
			return m_vertices[0].color;
		}
		
	}
	

	FloatRect getLocalBounds()
	{
		float width = (abs(m_textureRect.width));
		float height = (abs(m_textureRect.height));
		
		return FloatRect(0f, 0f, width, height);
	}
	
	FloatRect getGlobalBounds()
	{
		return FloatRect();
	}
	
	override void draw(RenderTarget renderTarget, RenderStates renderStates)// const
	{
		if (m_texture)
		{
			renderStates.transform *= getTransform();
			renderStates.texture = m_texture;
			renderTarget.draw(m_vertices, PrimitiveType.Quads, renderStates);
		}
	}
	
	void updatePositions()
	{
		FloatRect bounds = getLocalBounds();
		
		m_vertices[0].position = Vector2f(0, 0);
		m_vertices[1].position = Vector2f(0, bounds.height);
		m_vertices[2].position = Vector2f(bounds.width, bounds.height);
		m_vertices[3].position = Vector2f(bounds.width, 0);
	}

	void updateTexCoords()
	{
		float left = (m_textureRect.left);
		float right = left + m_textureRect.width;
		float top = (m_textureRect.top);
		float bottom = top + m_textureRect.height;
		
		m_vertices[0].texCoords = Vector2f(left, top);
		m_vertices[1].texCoords = Vector2f(left, bottom);
		m_vertices[2].texCoords = Vector2f(right, bottom);
		m_vertices[3].texCoords = Vector2f(right, top);
	}

	
	~this()
	{
		debug writeln("Destroying Sprite");

	}
	
}
