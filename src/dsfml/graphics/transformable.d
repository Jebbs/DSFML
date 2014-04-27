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

//public import so that people don't have to worry about 
//importing transform when they import transformable
public import dsfml.graphics.transform; 

/++
 + Decomposed transform defined by a position, a rotation, and a scale.
 + 
 + This interface is provided for convenience, on top of Transform.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Transformable.php#details
 +/
interface Transformable
{
	/**
	 * The local origin of the object.
	 * 
	 * The origin of an object defines the center point for all transformations (position, scale, ratation).
	 * 
	 * The coordinates of this point must be relative to the top-left corner of the object, and ignore all transformations (position, scale, rotation). The default origin of a transformable object is (0, 0).
	 */
	@property
	{
		Vector2f origin(Vector2f newOrigin);
		Vector2f origin() const;
	}

	/// The position of the object. The default is (0, 0).
	@property
	{
		Vector2f position(Vector2f newPosition);
		Vector2f position() const;
	}

	/// The orientation of the object, in degrees. The default is 0 degrees. 
	@property
	{
		float rotation(float newRotation);
		float rotation() const;
	}

	/// The scale factors of the object. The default is (1, 1).
	@property
	{
		Vector2f scale(Vector2f newScale);
		Vector2f scale() const;
	}

	/**
	 * Get the inverse of the combined transform of the object.
	 * 
	 * Returns: Inverse of the combined transformations applied to the object.
	 */
	const(Transform) getTransform();

	/**
	 * Get the combined transform of the object.
	 * 
	 * Returns: Transform combining the position/rotation/scale/origin of the object.
	 */
	const(Transform) getInverseTransform();
	
}

/++
 + Decomposed transform defined by a position, a rotation, and a scale.
 + 
 + This template is provided for convenience, on top of Transformable (and Transform).
 + 
 + Transform, as a low-level class, offers a great level of flexibility but it is not always convenient to manage. Indeed, one can easily combine any kind of operation, such as a translation followed by a rotation followed by a scaling, but once the result transform is built, there's no way to go backward and, let's say, change only the rotation without modifying the translation and scaling.
 + 
 + The entire transform must be recomputed, which means that you need to retrieve the initial translation and scale factors as well, and combine them the same way you did before updating the rotation. This is a tedious operation, and it requires to store all the individual components of the final transform.
 + 
 + That's exactly what Transformable was written for: it hides these variables and the composed transform behind an easy to use interface. You can set or get any of the individual components without worrying about the others. It also provides the composed transform (as a Transform), and keeps it up-to-date.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Transformable.php#details
 +/
mixin template NormalTransformable()
{
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

	/**
	 * The local origin of the object.
	 * 
	 * The origin of an object defines the center point for all transformations (position, scale, ratation).
	 * 
	 * The coordinates of this point must be relative to the top-left corner of the object, and ignore all transformations (position, scale, rotation). The default origin of a transformable object is (0, 0).
	 */
	@property
	{
		Vector2f origin(Vector2f newOrigin)
		{
			m_origin = newOrigin;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newOrigin;
		}
		
		Vector2f origin() const
		{
			return m_origin;
		}
	}

	/// The position of the object. The default is (0, 0).
	@property
	{
		Vector2f position(Vector2f newPosition)
		{
			m_position = newPosition;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newPosition;
		}
		
		Vector2f position() const
		{
			return m_position;
		}
	}

	/// The orientation of the object, in degrees. The default is 0 degrees. 
	@property
	{
		float rotation(float newRotation)
		{
			m_rotation = cast(float)fmod(newRotation, 360);
			if(m_rotation < 0)
			{
				m_rotation += 360;
			}
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newRotation;
		}
		
		float rotation() const
		{
			return m_rotation;
		}
	}

	/// The scale factors of the object. The default is (1, 1).
	@property
	{
		Vector2f scale(Vector2f newScale)
		{
			m_scale = newScale;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
			return newScale;
		}
		
		Vector2f scale() const
		{
			return m_scale;
		}
	}

	/**
	 * Get the inverse of the combined transform of the object.
	 * 
	 * Returns: Inverse of the combined transformations applied to the object.
	 */
	const(Transform) getInverseTransform()
	{
		if (m_inverseTransformNeedUpdate)
		{
			m_inverseTransform = getTransform().getInverse();
			m_inverseTransformNeedUpdate = false;
		}
		
		return m_inverseTransform;
	}

	/**
	 * Get the combined transform of the object.
	 * 
	 * Returns: Transform combining the position/rotation/scale/origin of the object.
	 */
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
}
