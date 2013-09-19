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

import dsfml.graphics.drawable;
import dsfml.graphics.transformable;

import dsfml.graphics.texture;

import dsfml.system.vector2;

import dsfml.graphics.rect;

import dsfml.graphics.transform;

import dsfml.graphics.color;

import dsfml.graphics.renderstates;

import dsfml.graphics.rendertarget;

import dsfml.graphics.vertexarray;

import dsfml.graphics.primitivetype;

import std.math;

debug import std.stdio;

class Shape:Drawable,Transformable
{
	mixin NormalTransformable;

	private Vector2f computeNormal(Vector2f p1, Vector2f p2)
	{
		Vector2f normal = Vector2f(p1.y - p2.y, p2.x - p1.x);
		float length = sqrt(normal.x * normal.x + normal.y * normal.y);
		if (length != 0f)
		{
			normal /= length;
		}
		return normal;
	}
	
	private float dotProduct(Vector2f p1, Vector2f p2)
	{
		return (p1.x * p2.x) + (p1.y * p2.y);
	}
	
	void setTexture(const(Texture) texture, bool resetRect)
	{
		if((texture !is null) && (resetRect || (m_texture is null)))
		{
			textureRect = IntRect(0, 0, texture.getSize().x, texture.getSize().y);
		}
		
		//texture is only used as constant data, so this is safe
		m_texture = (texture is null)? null:cast(Texture)texture;
		
	}
	//get texture
	const(Texture) getTexture() const
	{
		return m_texture;
	}
	
	@property
	{
		//Set Texture Rect
		void textureRect(IntRect rect)
		{
			m_textureRect = rect;
			updateTexCoords();
		}
		//get texture Rect
		IntRect textureRect() const
		{
			return m_textureRect;
		}
	}
	
	@property
	{
		//set Fill color
		void fillColor(Color color)
		{
			m_fillColor = color;
			updateFillColors();
		}
		//get fill color
		Color fillColor() const
		{
			return m_fillColor;
		}
	}
	
	@property
	{
		//set outline color
		void outlineColor(Color color)
		{
			m_outlineColor = color;
			updateOutlineColors();
		}
		//get outline color
		Color outlineColor() const
		{
			return m_outlineColor;
		}
	}
	
	@property
	{
		//set ouline thickness
		void outlineThickness(float thickness)
		{
			m_outlineThickness = thickness;
			update();
		}
		//get outline thickness
		float outlineThickness() const
		{
			return m_outlineThickness;
		}
	}
	
	@property
	{
		abstract uint pointCount();
	}
	
	abstract Vector2f getPoint(uint index) const;
	
	//get local bounds
	FloatRect getLocalBounds() const
	{
		return m_bounds;
	}
	
	//get global bounds
	FloatRect getGlobalBounds()
	{
		return getTransform().transformRect(getLocalBounds());
	}
	
	override void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		renderStates.transform = renderStates.transform * getTransform();
		
		// Render the inside
		renderStates.texture = m_texture;
		
	
		renderTarget.draw(m_vertices, renderStates);

		// Render the outline
		if (m_outlineThickness != 0)
		{
			renderStates.texture = null;
			renderTarget.draw(m_outlineVertices, renderStates);
		}
		
		
	}
	
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
		
		protected this()
		{
			m_vertices = new VertexArray(PrimitiveType.TrianglesFan,0);
			m_outlineVertices = new VertexArray(PrimitiveType.TrianglesStrip,0);
		}
		
		//Member data
		//Can't make m_texture const, as const data can only be initialized in a constructor
		Texture m_texture; /// Texture of the shape
		IntRect m_textureRect; /// Rectangle defining the area of the source texture to display
		Color m_fillColor; /// Fill color
		Color m_outlineColor; /// Outline color
		float m_outlineThickness; /// Thickness of the shape's outline
		VertexArray m_vertices; /// Vertex array containing the fill geometry
		VertexArray m_outlineVertices; /// Vertex array containing the outline geometry
		FloatRect m_insideBounds; /// Bounding rectangle of the inside (fill)
		FloatRect m_bounds; /// Bounding rectangle of the whole shape (outline + fill)
	}
}

