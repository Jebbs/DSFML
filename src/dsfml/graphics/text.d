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
module dsfml.graphics.text;

import dsfml.graphics.font;
import dsfml.graphics.glyph;
import dsfml.graphics.color;

import dsfml.system.vector2;

import dsfml.graphics.rect;

import dsfml.graphics.transform;
import dsfml.graphics.transformable;
import dsfml.graphics.drawable;
import dsfml.graphics.texture;
import std.typecons;

import dsfml.graphics.vertexarray;
import dsfml.graphics.vertex;

import dsfml.graphics.rendertarget;
import dsfml.graphics.renderstates;
import dsfml.graphics.primitivetype;

import std.math;

import std.string;
import std.conv;

import std.typecons;

import std.utf;

import std.algorithm;

import std.stdio;

class Text:Drawable,Transformable
{
private:

	dstring m_string;
	Rebindable!(const(Font)) m_font;
	uint m_characterSize;
	Style m_style;
	Color m_color;
	VertexArray m_vertices;
	FloatRect m_bounds;

	//used for caching the font texture
	uint lastSizeUsed = 0;
	Rebindable!(const(Texture)) lastTextureUsed;

	void updateGeometry()
	{
		// Clear the previous geometry
		m_vertices.clear();
		m_bounds = FloatRect();
		
		// No font: nothing to draw
		if (m_font is null)
			return;

		// No text: nothing to draw
		if (m_string.length == 0)
			return;
		// Compute values related to the text style
		bool bold = (m_style & Style.Bold) != 0;
		bool underlined = (m_style & Style.Underlined) != 0;
		float italic = (m_style & Style.Italic) ? 0.208f : 0f; // 12 degrees
		float underlineOffset = m_characterSize * 0.1f;
		float underlineThickness = m_characterSize * (bold ? 0.1f : 0.07f);
		
		// Precompute the variables needed by the algorithm
		float hspace = cast(float)(m_font.getGlyph(' ', m_characterSize, bold).advance);
		float vspace = cast(float)(m_font.getLineSpacing(m_characterSize));
		float x = 0f;
		float y = cast(float)(m_characterSize);
		
		// Create one quad for each character
		float minX = m_characterSize, minY = m_characterSize, maxX = 0, maxY = 0;
		dchar prevChar = 0;
		for (size_t i = 0; i < m_string.length; ++i)
		{
			dchar curChar = m_string[i];

			
			// Apply the kerning offset
			x += cast(float)(m_font.getKerning(prevChar, curChar, m_characterSize));

			prevChar = curChar;

			// If we're using the underlined style and there's a new line, draw a line
			if (underlined && (curChar == '\n'))
			{
				float top = y + underlineOffset;
				float bottom = top + underlineThickness;
				
				m_vertices.append(Vertex(Vector2f(0, top), m_color, Vector2f(1, 1)));
				m_vertices.append(Vertex(Vector2f(x, top), m_color, Vector2f(1, 1)));
				m_vertices.append(Vertex(Vector2f(x, bottom), m_color, Vector2f(1, 1)));
				m_vertices.append(Vertex(Vector2f(0, bottom), m_color, Vector2f(1, 1)));
			}
			
			// Handle special characters
			if ((curChar == ' ') || (curChar == '\t') || (curChar == '\n') || (curChar == '\v'))
			{
				// Update the current bounds (min coordinates)
				minX = min(minX, x);
				minY = min(minY, y);
				
				final switch (curChar)
				{
					case ' ' : x += hspace; break;
					case '\t' : x += hspace * 4; break;
					case '\n' : y += vspace; x = 0; break;
					case '\v' : y += vspace * 4; break;
				}
				
				// Update the current bounds (max coordinates)
				maxX = max(maxX, x);
				maxY = max(maxY, y);
				
				// Next glyph, no need to create a quad for whitespace
				continue;
			}



			// Extract the current glyph's description
			Glyph glyph = m_font.getGlyph(curChar, m_characterSize, bold);
			
			int left = glyph.bounds.left;
			int top = glyph.bounds.top;
			int right = glyph.bounds.left + glyph.bounds.width;
			int bottom = glyph.bounds.top + glyph.bounds.height;
			
			float u1 = cast(float)(glyph.textureRect.left);
			float v1 = cast(float)(glyph.textureRect.top);
			float u2 = cast(float)(glyph.textureRect.left + glyph.textureRect.width);
			float v2 = cast(float)(glyph.textureRect.top + glyph.textureRect.height);
			
			// Add a quad for the current character
			m_vertices.append(Vertex(Vector2f(x + left - italic * top, y + top), m_color, Vector2f(u1, v1)));
			m_vertices.append(Vertex(Vector2f(x + right - italic * top, y + top), m_color, Vector2f(u2, v1)));
			m_vertices.append(Vertex(Vector2f(x + right - italic * bottom, y + bottom), m_color, Vector2f(u2, v2)));
			m_vertices.append(Vertex(Vector2f(x + left - italic * bottom, y + bottom), m_color, Vector2f(u1, v2)));

			// Update the current bounds
			minX = min(minX, x + left - italic * bottom);
			maxX = max(maxX, x + right - italic * top);
			minY = min(minY, y + top);
			maxY = max(maxY, y + bottom);

			// Advance to the next character
			x += glyph.advance;
		}
		
		// If we're using the underlined style, add the last line
		if (underlined)
		{
			float top = y + underlineOffset;
			float bottom = top + underlineThickness;
			
			m_vertices.append(Vertex(Vector2f(0, top), m_color, Vector2f(1, 1)));
			m_vertices.append(Vertex(Vector2f(x, top), m_color, Vector2f(1, 1)));
			m_vertices.append(Vertex(Vector2f(x, bottom), m_color, Vector2f(1, 1)));
			m_vertices.append(Vertex(Vector2f(0, bottom), m_color, Vector2f(1, 1)));
		}
		
		// Update the bounding rectangle
		m_bounds.left = minX;
		m_bounds.top = minY;
		m_bounds.width = maxX - minX;
		m_bounds.height = maxY - minY;
	}



public:
	mixin NormalTransformable;
	enum Style
	{
		Regular = 0, ///< Regular characters, no style
		Bold = 1 << 0, ///< Bold characters
		Italic = 1 << 1, ///< Italic characters
		Underlined = 1 << 2 ///< Underlined characters
	}

	this()
	{
		m_string = "";
		m_characterSize = 30;
		m_style = Style.Regular;
		m_color = Color(255,255,255);
		m_vertices = new VertexArray(PrimitiveType.Quads,0);
		m_bounds = FloatRect();
	}

	this(dstring text, const(Font) font, uint characterSize = 30)
	{
		m_string = text;
		m_characterSize = characterSize;
		m_style = Style.Regular;
		m_color = Color(255,255,255);
		m_vertices = new VertexArray(PrimitiveType.Quads,0);
		m_bounds = FloatRect();
		m_font = font;
		updateGeometry();
	}
	~this()
	{
		writeln("Destroying Text");
	}

	void setString(dstring text)
	{
		m_string = text;
		updateGeometry();
	}

	void setFont(const(Font) font)
	{
		m_font = font;
		updateGeometry();
	}

	void setCharacterSize(uint size)
	{
		m_characterSize = size;
		updateGeometry();
	}

	void setStyle(Style style)
	{
		m_style = style;
		updateGeometry();
	}

	void setColor(Color color)
	{
		m_color = color;
		updateGeometry();
	}

	dstring getString() const
	{
		return m_string;
	}

	const(Font) getFont() const
	{
		if(m_font is null)
		{
			return null;
		}
		else
		{
			return m_font;
		}
	}

	uint getCharacterSize() const
	{
		return m_characterSize;
	}

	Style getStyle() const
	{
		return m_style;
	}

	Color getColor() const
	{
		return m_color;
	}

	Vector2f findCharacterPos(size_t index)
	{
		// Make sure that we have a valid font
		if(m_font !is null)
		{
			return Vector2f(0,0);
		}

		// Adjust the index if it's out of range
		if(index > m_string.length)
		{
			index = m_string.length;
		}


		bool bold  = (m_style & Style.Bold) != 0;



		float hspace = cast(float)(m_font.getGlyph(' ', m_characterSize, bold).advance);
		float vspace = cast(float)(m_font.getLineSpacing(m_characterSize));

		Vector2f position;
		dchar prevChar = 0;
		for (size_t i = 0; i < index; ++i)
		{
			dchar curChar = m_string[i];
			
			// Apply the kerning offset
			position.x += cast(float)(m_font.getKerning(prevChar, curChar, m_characterSize));
			prevChar = curChar;
			
			// Handle special characters
			switch (curChar)
			{
				case ' ' : position.x += hspace; continue;
				case '\t' : position.x += hspace * 4; continue;
				case '\n' : position.y += vspace; position.x = 0; continue;
				case '\v' : position.y += vspace * 4; continue;
				default:
					break;
			}
			
			// For regular characters, add the advance offset of the glyph
			position.x += cast(float)(m_font.getGlyph(curChar, m_characterSize, bold).advance);
		}
		
		// Transform the position to global coordinates
		position = getTransform().transformPoint(position);
		
		return position;

	
	}

	FloatRect getLocalBounds() const
	{
		return m_bounds;
	}

	FloatRect getGlobalBounds()
	{
		return getTransform().transformRect(getLocalBounds());
	}

	void draw(RenderTarget renderTarget, RenderStates renderStates)
	{
		if ((m_font !is null) && (m_characterSize>0))
		{
			renderStates.transform *= getTransform();

			//only call getTexture if the size has changed
			if(m_characterSize != lastSizeUsed)
			{
				//update the size
				lastSizeUsed = m_characterSize;
				//grab the new texture
				lastTextureUsed = m_font.getTexture(m_characterSize);
			}
			updateGeometry();
			renderStates.texture =  m_font.getTexture(m_characterSize);

			renderTarget.draw(m_vertices, renderStates);
		}
	}

}

alias std.utf.toUTFz!(const(dchar)*) toUTF32z;

package extern(C):

struct sfText;