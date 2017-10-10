////////////////////////////////////////////////////////////
//
// SFML - Simple and Fast Multimedia Library
// Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it freely,
// subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented;
//    you must not claim that you wrote the original software.
//    If you use this software in a product, an acknowledgment
//    in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such,
//    and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.
//
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
#include <DSFMLC/Graphics/DText.hpp>
#include <SFML/Graphics/Texture.hpp>
#include <SFML/Graphics/RenderTarget.hpp>
#include <cassert>


namespace sf
{
////////////////////////////////////////////////////////////
DText::DText() :
m_string       (),
m_font         (NULL),
m_characterSize(30),
m_style        (Regular),
m_color        (255, 255, 255),
m_vertices     (Quads),
m_bounds       ()
{

}


////////////////////////////////////////////////////////////
DText::DText(const String& string, const Font& font, unsigned int characterSize) :
m_string       (string),
m_font         (&font),
m_characterSize(characterSize),
m_style        (Regular),
m_color        (255, 255, 255),
m_vertices     (Quads),
m_bounds       ()
{
    updateGeometry();
}


////////////////////////////////////////////////////////////
void DText::setString(const String& string)
{
    m_string = string;
    updateGeometry();
}


////////////////////////////////////////////////////////////
void DText::setFont(const Font& font)
{
    if (m_font != &font)
    {
        m_font = &font;
        updateGeometry();
    }
}


////////////////////////////////////////////////////////////
void DText::setCharacterSize(unsigned int size)
{
    if (m_characterSize != size)
    {
        m_characterSize = size;
        updateGeometry();
    }
}


////////////////////////////////////////////////////////////
void DText::setStyle(Uint32 style)
{
    if (m_style != style)
    {
        m_style = style;
        updateGeometry();
    }
}


////////////////////////////////////////////////////////////
void DText::setColor(const Color& color)
{
    if (color != m_color)
    {
        m_color = color;
        for (unsigned int i = 0; i < getVertexCount(); ++i)
            m_vertices[i].color = m_color;
    }
}


////////////////////////////////////////////////////////////
const String& DText::getString() const
{
    return m_string;
}


////////////////////////////////////////////////////////////
const Font* DText::getFont() const
{
    return m_font;
}


////////////////////////////////////////////////////////////
unsigned int DText::getCharacterSize() const
{
    return m_characterSize;
}


////////////////////////////////////////////////////////////
Uint32 DText::getStyle() const
{
    return m_style;
}


////////////////////////////////////////////////////////////
const Color& DText::getColor() const
{
    return m_color;
}


////////////////////////////////////////////////////////////
Vector2f DText::findCharacterPos(std::size_t index) const
{
    // Make sure that we have a valid font
    if (!m_font)
        return Vector2f();

    // Adjust the index if it's out of range
    if (index > m_string.getSize())
        index = m_string.getSize();

    // Precompute the variables needed by the algorithm
    bool  bold   = (m_style & Bold) != 0;
    float hspace = static_cast<float>(m_font->getGlyph(L' ', m_characterSize, bold).advance);
    float vspace = static_cast<float>(m_font->getLineSpacing(m_characterSize));

    // Compute the position
    Vector2f position;
    Uint32 prevChar = 0;
    for (std::size_t i = 0; i < index; ++i)
    {
        Uint32 curChar = m_string[i];

        // Apply the kerning offset
        position.x += static_cast<float>(m_font->getKerning(prevChar, curChar, m_characterSize));
        prevChar = curChar;

        // Handle special characters
        switch (curChar)
        {
            case L' ' :  position.x += hspace;                 continue;
            case L'\t' : position.x += hspace * 4;             continue;
            case L'\n' : position.y += vspace; position.x = 0; continue;
            case L'\v' : position.y += vspace * 4;             continue;
        }

        // For regular characters, add the advance offset of the glyph
        position.x += static_cast<float>(m_font->getGlyph(curChar, m_characterSize, bold).advance);
    }

    // Transform the position to global coordinates
    position = getTransform().transformPoint(position);

    return position;
}


////////////////////////////////////////////////////////////
FloatRect DText::getLocalBounds() const
{
    return m_bounds;
}


////////////////////////////////////////////////////////////
FloatRect DText::getGlobalBounds() const
{
    return getTransform().transformRect(getLocalBounds());
}

//Get the array of vertices this DText uses for drawing
const Vertex* DText::getVertexArray() const
{
    return &m_vertices[0];
}

//Get the number of vertices this Text uses for drawing
unsigned int DText::getVertexCount() const
{
    return static_cast<unsigned int>(m_vertices.size());
}
    
//Get the PrimitiveType this DText uses for drawing
PrimitiveType DText::getPrimitiveType() const
{
    return m_primitiveType;
}

////////////////////////////////////////////////////////////
void DText::draw(RenderTarget& target, RenderStates states) const
{
    if (m_font)
    {
        states.transform *= getTransform();
        states.texture = &m_font->getTexture(m_characterSize);
        target.draw(getVertexArray(),getVertexCount(),getPrimitiveType(), states);
    }
}


////////////////////////////////////////////////////////////
void DText::updateGeometry()
{
    // Clear the previous geometry
    m_vertices.clear();
    m_bounds = FloatRect();

    // No font: nothing to draw
    if (!m_font)
        return;

    // No text: nothing to draw
    if (m_string.isEmpty())
        return;

    // Compute values related to the text style
    bool  bold               = (m_style & Bold) != 0;
    bool  underlined         = (m_style & Underlined) != 0;
    float italic             = (m_style & Italic) ? 0.208f : 0.f; // 12 degrees
    float underlineOffset    = m_characterSize * 0.1f;
    float underlineThickness = m_characterSize * (bold ? 0.1f : 0.07f);

    // Precompute the variables needed by the algorithm
    float hspace = static_cast<float>(m_font->getGlyph(L' ', m_characterSize, bold).advance);
    float vspace = static_cast<float>(m_font->getLineSpacing(m_characterSize));
    float x      = 0.f;
    float y      = static_cast<float>(m_characterSize);

    // Create one quad for each character
    Uint32 prevChar = 0;
    for (std::size_t i = 0; i < m_string.getSize(); ++i)
    {
        Uint32 curChar = m_string[i];

        // Apply the kerning offset
        x += static_cast<float>(m_font->getKerning(prevChar, curChar, m_characterSize));
        prevChar = curChar;

        // If we're using the underlined style and there's a new line, draw a line
        if (underlined && (curChar == L'\n'))
        {
            float top = y + underlineOffset;
            float bottom = top + underlineThickness;

            m_vertices.push_back(Vertex(Vector2f(0, top),    m_color, Vector2f(1, 1)));
            m_vertices.push_back(Vertex(Vector2f(x, top),    m_color, Vector2f(1, 1)));
            m_vertices.push_back(Vertex(Vector2f(x, bottom), m_color, Vector2f(1, 1)));
            m_vertices.push_back(Vertex(Vector2f(0, bottom), m_color, Vector2f(1, 1)));
        }

        // Handle special characters
        switch (curChar)
        {
            case L' ' :  x += hspace;        continue;
            case L'\t' : x += hspace * 4;    continue;
            case L'\n' : y += vspace; x = 0; continue;
            case L'\v' : y += vspace * 4;    continue;
        }

        // Extract the current glyph's description
        const Glyph& glyph = m_font->getGlyph(curChar, m_characterSize, bold);

        int left   = glyph.bounds.left;
        int top    = glyph.bounds.top;
        int right  = glyph.bounds.left + glyph.bounds.width;
        int bottom = glyph.bounds.top  + glyph.bounds.height;

        float u1 = static_cast<float>(glyph.textureRect.left);
        float v1 = static_cast<float>(glyph.textureRect.top);
        float u2 = static_cast<float>(glyph.textureRect.left + glyph.textureRect.width);
        float v2 = static_cast<float>(glyph.textureRect.top  + glyph.textureRect.height);

        // Add a quad for the current character
        m_vertices.push_back(Vertex(Vector2f(x + left  - italic * top,    y + top),    m_color, Vector2f(u1, v1)));
        m_vertices.push_back(Vertex(Vector2f(x + right - italic * top,    y + top),    m_color, Vector2f(u2, v1)));
        m_vertices.push_back(Vertex(Vector2f(x + right - italic * bottom, y + bottom), m_color, Vector2f(u2, v2)));
        m_vertices.push_back(Vertex(Vector2f(x + left  - italic * bottom, y + bottom), m_color, Vector2f(u1, v2)));

        // Advance to the next character
        x += glyph.advance;
    }

    // If we're using the underlined style, add the last line
    if (underlined)
    {
        float top = y + underlineOffset;
        float bottom = top + underlineThickness;

        m_vertices.push_back(Vertex(Vector2f(0, top),    m_color, Vector2f(1, 1)));
        m_vertices.push_back(Vertex(Vector2f(x, top),    m_color, Vector2f(1, 1)));
        m_vertices.push_back(Vertex(Vector2f(x, bottom), m_color, Vector2f(1, 1)));
        m_vertices.push_back(Vertex(Vector2f(0, bottom), m_color, Vector2f(1, 1)));
    }

    // Recompute the bounding rectangle
    m_bounds = getBounds();
}

//Get the boundary of the vertex array
FloatRect DText::getBounds() const
{
        if (!m_vertices.empty())
        {
            float left = m_vertices[0].position.x;
            float top = m_vertices[0].position.y;
            float right = m_vertices[0].position.x;
            float bottom = m_vertices[0].position.y;
            for (std::size_t i = 1; i < m_vertices.size(); ++i)
            {
                Vector2f position = m_vertices[i].position;
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
            // Array is empty
            return FloatRect();
        }


 
}

} // namespace sf
