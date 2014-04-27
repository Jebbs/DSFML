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

/++
 + Drawable representation of a texture, with its own transformations, color, etc.
 + 
 + Sprite is a drawable class that allows to easily display a texture (or a part of it) on a render target.
 + 
 + It inherits all the functions from Transformable: position, rotation, scale, origin. It also adds sprite-specific properties such as the texture to use, the part of it to display, and some convenience functions to change the overall color of the sprite, or to get its bounding rectangle.
 + 
 + Sprite works in combination with the Texture class, which loads and provides the pixel data of a given texture.
 + 
 + The separation of Sprite and Texture allows more flexibility and better performances: indeed a Texture is a heavy resource, and any operation on it is slow (often too slow for real-time applications). On the other side, a Sprite is a lightweight object which can use the pixel data of a Texture and draw it with its own transformation/color/blending attributes.
 + 
 + It is important to note that the Sprite instance doesn't copy the texture that it uses, it only keeps a reference to it. Thus, a Texture must not be destroyed while it is used by a Sprite (i.e. never write a function that uses a local Texture instance for creating a sprite).
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1Sprite.php#details
 +/
class Sprite : Drawable, Transformable
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

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
	}

	/**
	 * The sub-rectangle of the texture that the sprite will display.
	 * 
	 * The texture rect is useful when you don't want to display the whole texture, but rather a part of it. By default, the texture rect covers the entire texture.
	 */
	@property
	{
		IntRect textureRect(IntRect rect)
		{
			if (rect != m_textureRect)
			{
				m_textureRect = rect;
				updatePositions();
				updateTexCoords();
			}
			return rect;
		}
		IntRect textureRect()
		{
			return m_textureRect;
		}
	}

	/**
	 * The global color of the sprite.
	 * 
	 * This color is modulated (multiplied) with the sprite's texture. It can be used to colorize the sprite, or change its global opacity. By default, the sprite's color is opaque white.
	 */
	@property
	{
		Color color(Color newColor)
		{
			// Update the vertices' color
			m_vertices[0].color = newColor;
			m_vertices[1].color = newColor;
			m_vertices[2].color = newColor;
			m_vertices[3].color = newColor;
			return newColor;
		}
		Color color()
		{
			return m_vertices[0].color;
		}
		
	}

	/**
	 * Get the global bounding rectangle of the entity.
	 * 
	 * The returned rectangle is in global coordinates, which means that it takes in account the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the sprite in the global 2D world's coordinate system.
	 * 
	 * Returns: Global bounding rectangle of the entity
	 */
	FloatRect getGlobalBounds()
	{
		return getTransform().transformRect(getLocalBounds());
	}

	/**
	 * Get the local bounding rectangle of the entity.
	 * 
	 * The returned rectangle is in local coordinates, which means that it ignores the transformations (translation, rotation, scale, ...) that are applied to the entity. In other words, this function returns the bounds of the entity in the entity's coordinate system.
	 * 
	 * Returns: Local bounding rectangle of the entity
	 */
	FloatRect getLocalBounds()
	{
		float width = (abs(m_textureRect.width));
		float height = (abs(m_textureRect.height));
		return FloatRect(0f, 0f, width, height);
	}

	/**
	 * Get the source texture of the sprite.
	 * 
	 * If the sprite has no source texture, a NULL pointer is returned. The returned pointer is const, which means that you can't modify the texture when you retrieve it with this function.
	 * 
	 * Returns: The sprite's texture
	 */
	const(Texture) getTexture()
	{
		return m_texture;
	}

	/**
	 * Change the source texture of the shape.
	 * 
	 * The texture argument refers to a texture that must exist as long as the sprite uses it. Indeed, the sprite doesn't store its own copy of the texture, but rather keeps a pointer to the one that you passed to this function. If the source texture is destroyed and the sprite tries to use it, the behaviour is undefined. texture can be NULL to disable texturing.
	 * 
	 * If resetRect is true, the TextureRect property of the sprite is automatically adjusted to the size of the new texture. If it is false, the texture rect is left unchanged.
	 * 
	 * Params:
	 * 		texture		= New texture
	 * 		resetRect	= Should the texture rect be reset to the size of the new texture?
	 */
	void setTexture(const(Texture) texture, bool rectReset = false)
	{
		if(rectReset || ((m_texture is null) && (m_textureRect == IntRect())))
		{
			textureRect(IntRect(0,0,texture.getSize().x,texture.getSize().y));
		}
		
		m_texture = texture;
	}

	/**
	 * Draw the sprite to a render target.
	 * 
	 * Params:
	 * 		renderTarget	= Target to draw to
	 * 		renderStates	= Current render states
	 */
	override void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		if (m_texture)
		{
			renderStates.transform *= getTransform();
			renderStates.texture = m_texture;
			renderTarget.draw(m_vertices, PrimitiveType.Quads, renderStates);
		}
	}

	/**
	 * Create a new Sprite with the same data. Note that the texture is not copied, only its reference.
	 * 
	 * Returns: A new Sprite object with the same data.
	 */
	@property
	Sprite dup() const
	{
		Sprite temp = new Sprite();
		// properties from Transformable
		temp.origin = origin;
		temp.position = position;
		temp.rotation = rotation;
		temp.scale = scale;
		// properties from Sprite:
		temp.setTexture(m_texture);
		temp.color = m_vertices[0].color;
		temp.textureRect = m_textureRect;
		return temp;
	}

	//TODO: should these be protected?
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

}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;

		import dsfml.graphics.rendertexture;

		writeln("Unit test for Sprite");

		auto texture = new Texture();

		assert(texture.loadFromFile("res/star.png"));

		auto sprite = new Sprite(texture);


		auto renderTexture = new RenderTexture();

		assert(renderTexture.create(100,100));

		renderTexture.clear();

		renderTexture.draw(sprite);

		renderTexture.display();

		writeln();
	}
}