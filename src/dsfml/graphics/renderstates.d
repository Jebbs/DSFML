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
module dsfml.graphics.renderstates;

import dsfml.graphics.blendmode;
import dsfml.graphics.transform;
import dsfml.graphics.texture;
import dsfml.graphics.shader;
import std.typecons:Rebindable;

/++
 + Define the states used for drawing to a RenderTarget.
 + 
 + There are four global states that can be applied to the drawn objects:
 + - the blend mode: how pixels of the object are blended with the background
 + - the transform: how the object is positioned/rotated/scaled
 + - the texture: what image is mapped to the object
 + - the shader: what custom effect is applied to the object
 + 
 + High-level objects such as sprites or text force some of these states when they are drawn. For example, a sprite will set its own texture, so that you don't have to care about it when drawing the sprite.
 + 
 + The transform is a special case: sprites, texts and shapes (and it's a good idea to do it with your own drawable classes too) combine their transform with the one that is passed in the RenderStates structure. So that you can use a "global" transform on top of each object's transform.
 + 
 + Most objects, especially high-level drawables, can be drawn directly without defining render states explicitely – the default set of states is ok in most cases.
 + 
 + If you want to use a single specific render state, for example a shader, you can pass it directly to the Draw function: RenderStates has an implicit one-argument constructor for each state.
 + 
 + When you're inside the Draw function of a drawable object (inherited from sf::Drawable), you can either pass the render states unmodified, or change some of them. For example, a transformable object will combine the current transform with its own transform. A sprite will set its texture. Etc.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1RenderStates.php#details
 +/
struct RenderStates
{
	BlendMode blendMode;
	Transform transform;
	private
	{
		Rebindable!(const(Texture)) m_texture;
		Rebindable!(const(Shader)) m_shader;
	}

	this(BlendMode theBlendMode)
	{
		blendMode = theBlendMode;
		transform = Transform();

		m_texture = emptyTexture;
		m_shader = emptyShader;

	}

	this(Transform theTransform)
	{
		transform = theTransform;

		blendMode = BlendMode.Alpha;

		m_texture = emptyTexture;
		m_shader = emptyShader;
	}

	this(const(Texture) theTexture)
	{
		if(theTexture !is null)
		{
			
			m_texture = theTexture;
		}
		else
		{
			m_texture = emptyTexture;
		}

		blendMode = BlendMode.Alpha;

		transform = Transform();
		m_shader = emptyShader;
	}

	this(const(Shader) theShader)
	{
		if(theShader !is null)
		{
			m_shader = theShader;
		}
		else
		{
			m_shader = emptyShader;
		}
	}

	this(BlendMode theBlendMode, Transform theTransform, const(Texture) theTexture, const(Shader) theShader)
	{
		blendMode = theBlendMode;
		transform = theTransform;
		if(theTexture !is null)
		{
			
			m_texture = theTexture;
		}
		else
		{
			m_texture = emptyTexture;
		}
		if(theShader !is null)
		{
			m_shader = theShader;
		}
		else
		{
			m_shader = emptyShader;
		}
	}

	/// The shader to apply while rendering.
	@property
	{
		const(Shader) shader(const(Shader) theShader)
		{
			if(theShader !is null)
			{
				m_shader = theShader;
			}
			else
			{
				m_shader = emptyShader;
			}
			return theShader;
		}
		const(Shader) shader()
		{
			return m_shader;
		}
	}

	/// The texture to apply while rendering.
	@property
	{
		const(Texture) texture(const(Texture) theTexture)
		{
			if(theTexture !is null)
			{
				
				m_texture = theTexture;
			}
			else
			{
				m_texture = emptyTexture;
			}
			return theTexture;
		}
		const(Texture) texture()
		{
			return m_texture;
		}
	}

	/// A default, empty render state.
	@property
	static RenderStates Default()
	{
		RenderStates temp;//make a static variable?

		temp.m_texture = emptyTexture;
		temp.m_shader = emptyShader;

		return temp;
	}

	//Creates empty an epty texture and shader for continuous use to prevent
	//creating them on the fly
	package static Texture emptyTexture;
	package static Shader emptyShader;

	private static this()
	{
		emptyTexture = new Texture();
		emptyShader = new Shader();
	}
}
