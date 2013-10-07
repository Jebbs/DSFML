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
import std.typecons;

import std.stdio;

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

	@property
	{
		void texture(const(Texture) theTexture)
		{
			if(theTexture !is null)
			{
				
				m_texture = theTexture;
			}
			else
			{
				m_texture = emptyTexture;
			}
			
		}
		const(Texture) texture()
		{
			return m_texture;
		}
	}
	
	@property
	{
		void shader(const(Shader) theShader)
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
		const(Shader) shader()
		{
			return m_shader;
		}
	}


	static RenderStates Default()
	{

		RenderStates temp;

		temp.m_texture = emptyTexture;
		temp.m_shader = emptyShader;

		return temp;
	}

	package static Texture emptyTexture;
	package static Shader emptyShader;

	private static this()
	{
		emptyTexture = new Texture();
		emptyShader = new Shader();
	}
}