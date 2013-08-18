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
module dsfml.graphics.transformable;

import dsfml.system.vector2;

import dsfml.graphics.transform;



interface Transformable
{
	
	@property
	{
		void position(Vector2f newPosition);
		Vector2f position() const;
	}
	
	@property
	{
		void rotation(float newRotation);
		float rotation() const;
	}
	
	@property
	{
		void scale(Vector2f newScale);
		Vector2f scale() const;
	}
	
	@property
	{
		void origin(Vector2f newOrigin);
		Vector2f origin() const;
	}
	
	const(Transform) getTransform();
	
	const(Transform) getInverseTransform();
	
}

mixin template NormalTransformable()
{
	@property
	{
		void position(Vector2f newPosition)
		{
			m_position = newPosition;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		Vector2f position() const
		{
			return m_position;
		}
	}
	
	@property
	{
		void rotation(float newRotation)
		{
			m_rotation = cast(float)fmod(newRotation, 360);
			if(m_rotation < 0)
			{
				m_rotation += 360;
			}
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		float rotation() const
		{
			return m_rotation;
		}
	}
	
	@property
	{
		void scale(Vector2f newScale)
		{
			m_scale = newScale;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		Vector2f scale() const
		{
			return m_scale;
		}
	}
	
	@property
	{
		void origin(Vector2f newOrigin)
		{
			m_origin = newOrigin;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		Vector2f origin() const
		{
			return m_origin;
		}
	}
	
	const(Transform) getTransform()
	{
		
		if (m_transformNeedUpdate)
		{
			float angle = -m_rotation * 3.141592654f / 180f;
			float cosine = cast(float)(cos(angle));
			float sine = cast(float)(sin(angle));
			float sxc = m_scale.x * cosine;
			float syc = m_scale.y * cosine;
			float sxs = m_scale.x * sine;
			float sys = m_scale.y * sine;
			float tx = -m_origin.x * sxc - m_origin.y * sys + m_position.x;
			float ty = m_origin.x * sxs - m_origin.y * syc + m_position.y;
			
			m_transform = Transform( sxc, sys, tx,
			                        -sxs, syc, ty,
			                        0f, 0f, 1f);
			m_transformNeedUpdate = false;
		}
		
		
		return m_transform;
	}
	
	const(Transform) getInverseTransform()
	{
		if (m_inverseTransformNeedUpdate)
		{
			m_inverseTransform = getTransform().getInverse();
			m_inverseTransformNeedUpdate = false;
		}
		
		return m_inverseTransform;
	}
	
	
	
	private
	{
		Vector2f m_origin = Vector2f(0,0); ///< Origin of translation/rotation/scaling of the object
		Vector2f m_position = Vector2f(0,0); ///< Position of the object in the 2D world
		float m_rotation = 0; ///< Orientation of the object, in degrees
		Vector2f m_scale = Vector2f(1,1); ///< Scale of the object
		Transform m_transform; ///< Combined transformation of the object
		bool m_transformNeedUpdate; ///< Does the transform need to be recomputed?
		Transform m_inverseTransform; ///< Combined transformation of the object
		bool m_inverseTransformNeedUpdate; ///< Does the transform need to be recomputed?
	}
}