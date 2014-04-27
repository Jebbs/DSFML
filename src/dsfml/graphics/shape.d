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
module dsfml.graphics.shape;

import dsfml.system.vector2;

import dsfml.graphics.color;
import dsfml.graphics.drawable;
import dsfml.graphics.primitivetype;
import dsfml.graphics.rect;
import dsfml.graphics.rendertarget;
import dsfml.graphics.renderstates;
import dsfml.graphics.texture;
import dsfml.graphics.transformable;
import dsfml.graphics.vertexarray;

import std.typecons : Rebindable;

/++
 + Base class for textured shapes with outline.
 + 
 + Shape is a drawable class that allows to define and display a custom convex shape on a render target.
 + 
 + It's only an abstract base, it needs to be specialized for concrete types of shapes (circle, rectangle, convex polygon, star, ...).
 + 
 + In addition to the attributes provided by the specialized shape classes, a shape always has the following attributes:
 + - a texture
 + - a texture rectangle
 + - a fill color
 + - an outline color
 + - an outline thickness
 + 
 + Each feature is optional, and can be disabled easily:
 + - the texture can be null
 + - the fill/outline colors can be sf::Color::Transparent
 + - the outline thickness can be zero
 + 
 + You can write your own derived shape class, there are only two virtual functions to override:
 + - getPointCount must return the number of points of the shape
 + - getPoint must return the points of the shape
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Shape.php#details
 +/
class Shape : Drawable, Transformable
{
	mixin NormalTransformable;

	protected this()
	{
		m_vertices = new VertexArray(PrimitiveType.TrianglesFan,0);
		m_outlineVertices = new VertexArray(PrimitiveType.TrianglesStrip,0);
	}

	private
	{
		Rebindable!(const(Texture)) m_texture; /// Texture of the shape
		IntRect m_textureRect; /// Rectangle defining the area of the source texture to display
		Color m_fillColor; /// Fill color
		Color m_outlineColor; /// Outline color
		float m_outlineThickness; /// Thickness of the shape's outline
		VertexArray m_vertices; /// Vertex array containing the fill geometry
		VertexArray m_outlineVertices; /// Vertex array containing the outline geometry
		FloatRect m_insideBounds; /// Bounding rectangle of the inside (fill)
		FloatRect m_bounds; /// Bounding rectangle of the whole shape (outline + fill)
	}

	/**
	 * The sub-rectangle of the texture that the shape will display.
	 * 
	 * The texture rect is useful when you don't want to display the whole texture, but rather a part of it. By default, the texture rect covers the entire texture.
	 */
	@property
	{
		//Set Texture Rect
		IntRect textureRect(IntRect rect)
		{
			m_textureRect = rect;
			updateTexCoords();
			return rect;
		}
		//get texture Rect
		IntRect textureRect() const
		{
			return m_textureRect;
		}
	}

	/**
	 * The fill color of the shape.
	 * 
	 * This color is modulated (multiplied) with the shape's texture if any. It can be used to colorize the shape, or change its global opacity. You can use Color.Transparent to make the inside of the shape transparent, and have the outline alone. By default, the shape's fill color is opaque white.
	 */
	@property
	{
		//set Fill color
		Color fillColor(Color color)
		{
			m_fillColor = color;
			updateFillColors();
			return color;
		}
		//get fill color
		Color fillColor() const
		{
			return m_fillColor;
		}
	}

	/**
	 * The outline color of the shape.
	 * 
	 * By default, the shape's outline color is opaque white.
	 */
	@property
	{
		//set outline color
		Color outlineColor(Color color)
		{
			m_outlineColor = color;
			updateOutlineColors();
			return color;
		}
		//get outline color
		Color outlineColor() const
		{
			return m_outlineColor;
		}
	}

	/**
	 * The thickness of the shape's outline.
	 * 
	 * Note that negative values are allowed (so that the outline expands towards the center of the shape), and using zero disables the outline. By default, the outline thickness is 0.
	 */
	@property
	{
		//set ouline thickness
		float outlineThickness(float thickness)
		{
			m_outlineThickness = thickness;
			update();
			return thickness;
		}
		//get outline thickness
		float outlineThickness() const
		{
			return m_outlineThickness;
		}
	}

	/**
	 * Get the total number of points in the shape.
	 * 
	 * Returns: Number of points in the shape.
	 */
	@property
	{
		abstract uint pointCount();
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
	FloatRect getLocalBounds() const
	{
		return m_bounds;
	}

	/**
	 * Get a point of the shape.
	 * 
	 * The result is undefined if index is out of the valid range.
	 * 
	 * Params:
	 * 		index	= Index of the point to get, in range [0 .. getPointCount() - 1]
	 * 
	 * Returns: Index-th point of the shape
	 */
	abstract Vector2f getPoint(uint index) const;

	/**
	 * Get the source texture of the shape.
	 * 
	 * If the shape has no source texture, a NULL pointer is returned. The returned pointer is const, which means that you can't modify the texture when you retrieve it with this function.
	 * 
	 * Returns: The shape's texture
	 */
	const(Texture) getTexture() const
	{
		return m_texture;
	}

	/**
	 * Change the source texture of the shape.
	 * 
	 * The texture argument refers to a texture that must exist as long as the shape uses it. Indeed, the shape doesn't store its own copy of the texture, but rather keeps a pointer to the one that you passed to this function. If the source texture is destroyed and the shape tries to use it, the behaviour is undefined. texture can be NULL to disable texturing.
	 * 
	 * If resetRect is true, the TextureRect property of the shape is automatically adjusted to the size of the new texture. If it is false, the texture rect is left unchanged.
	 * 
	 * Params:
	 * 		texture		= New texture
	 * 		resetRect	= Should the texture rect be reset to the size of the new texture?
	 */
	void setTexture(const(Texture) texture, bool resetRect = false)
	{
		if((texture !is null) && (resetRect || (m_texture is null)))
		{
			textureRect = IntRect(0, 0, texture.getSize().x, texture.getSize().y);
		}
		
		m_texture = (texture is null)? null:texture;
	}

	/**
	 * Draw the shape to a render target.
	 * 
	 * Params:
	 * 		renderTarget	= Target to draw to
	 * 		renderStates	= Current render states
	 */
	override void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		renderStates.transform = renderStates.transform * getTransform();
		renderStates.texture = m_texture;
		renderTarget.draw(m_vertices, renderStates);

		// Render the outline
		if (m_outlineThickness != 0)
		{
			renderStates.texture = null;
			renderTarget.draw(m_outlineVertices, renderStates);
		}
	}

	/**
	 * Recompute the internal geometry of the shape.
	 * 
	 * This function must be called by the derived class everytime the shape's points change (ie. the result of either getPointCount or getPoint is different).
	 */
	protected void update()
	{
		// Get the total number of points of the shape
		uint count = pointCount();
		if (count < 3)
		{
			m_vertices.resize(0);
			m_outlineVertices.resize(0);
			return;
		}
		
		m_vertices.resize(count + 2); // + 2 for center and repeated first point
		
		// Position
		for (uint i = 0; i < count; ++i)
		{
			m_vertices[i + 1].position = getPoint(i);
		}
		m_vertices[count + 1].position = m_vertices[1].position;
		
		// Update the bounding rectangle
		m_vertices[0] = m_vertices[1]; // so that the result of getBounds() is correct
		m_insideBounds = m_vertices.getBounds();

		// Compute the center and make it the first vertex
		m_vertices[0].position.x = m_insideBounds.left + m_insideBounds.width / 2;
		m_vertices[0].position.y = m_insideBounds.top + m_insideBounds.height / 2;
		
		// Color
		updateFillColors();
		
		// Texture coordinates
		updateTexCoords();
		
		// Outline
		updateOutline();
	}
	
	private
	{
		Vector2f computeNormal(Vector2f p1, Vector2f p2)
		{
			Vector2f normal = Vector2f(p1.y - p2.y, p2.x - p1.x);
			float length = sqrt(normal.x * normal.x + normal.y * normal.y);
			if (length != 0f)
			{
				normal /= length;
			}
			return normal;
		}
		
		float dotProduct(Vector2f p1, Vector2f p2)
		{
			return (p1.x * p2.x) + (p1.y * p2.y);
		}

		//update methods
		void updateFillColors()
		{
			for(uint i = 0; i < m_vertices.getVertexCount(); ++i)
			{
				m_vertices[i].color = m_fillColor;
			}
		}
		
		void updateTexCoords()
		{
			
			for (uint i = 0; i < m_vertices.getVertexCount(); ++i)
			{
				float xratio = (m_vertices[i].position.x - m_insideBounds.left) / m_insideBounds.width;
				float yratio = (m_vertices[i].position.y - m_insideBounds.top) / m_insideBounds.height;
				
				m_vertices[i].texCoords.x = m_textureRect.left + m_textureRect.width * xratio;
				m_vertices[i].texCoords.y = m_textureRect.top + m_textureRect.height * yratio;
				
			}
			
			
		}
		
		void updateOutline()
		{
			uint count = m_vertices.getVertexCount() - 2;
			m_outlineVertices.resize((count + 1) * 2);
			
			for (uint i = 0; i < count; ++i)
			{
				uint index = i + 1;
				
				// Get the two segments shared by the current point
				Vector2f p0 = (i == 0) ? m_vertices[count].position : m_vertices[index - 1].position;
				Vector2f p1 = m_vertices[index].position;
				Vector2f p2 = m_vertices[index + 1].position;
				
				// Compute their normal
				Vector2f n1 = computeNormal(p0, p1);
				Vector2f n2 = computeNormal(p1, p2);
				
				// Make sure that the normals point towards the outside of the shape
				// (this depends on the order in which the points were defined)
				if (dotProduct(n1, m_vertices[0].position - p1) > 0)
					n1 = -n1;
				if (dotProduct(n2, m_vertices[0].position - p1) > 0)
					n2 = -n2;
				
				// Combine them to get the extrusion direction
				float factor = 1f + (n1.x * n2.x + n1.y * n2.y);
				Vector2f normal = (n1 + n2) / factor;
				
				// Update the outline points
				m_outlineVertices[i * 2 + 0].position = p1;
				m_outlineVertices[i * 2 + 1].position = p1 + normal * m_outlineThickness;
			}
			
			// Duplicate the first point at the end, to close the outline
			m_outlineVertices[count * 2 + 0].position = m_outlineVertices[0].position;
			m_outlineVertices[count * 2 + 1].position = m_outlineVertices[1].position;
			
			// Update outline colors
			updateOutlineColors();
			
			// Update the shape's bounds
			m_bounds = m_outlineVertices.getBounds();
		}
		
		void updateOutlineColors()
		{
			for (uint i = 0; i < m_outlineVertices.getVertexCount(); ++i)
			{
				m_outlineVertices[i].color = m_outlineColor;
			}
		}

	}
}

unittest
{
	//meant to be inherited. Unit test?
}
