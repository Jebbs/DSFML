/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

/**
 * $(U Text) is a drawable class that allows one to easily display some text
 * with a custom style and color on a render target.
 *
 * It inherits all the functions from $(TRANSFORMABLE_LINK): position, rotation,
 * scale, origin. It also adds text-specific properties such as the font to use,
 * the character size, the font style (bold, italic, underlined), the global
 * color and the text to display of course. It also provides convenience
 * functions to calculate the graphical size of the text, or to get the global
 * position of a given character.
 *
 * $(U Text) works in combination with the $(FONT_LINK) class, which loads and
 * provides the glyphs (visual characters) of a given font.
 *
 * The separation of $(FONT_LINK) and $(U Text) allows more flexibility and
 * better performances: indeed a $(FONT_LINK) is a heavy resource, and any
 * operation on it is slow (often too slow for real-time applications). On the
 * other side, a $(U Text) is a lightweight object which can combine the glyphs
 * data and metrics of a $(FONT_LINK) to display any text on a render target.
 *
 * It is important to note that the $(U Text) instance doesn't copy the font
 * that it uses, it only keeps a reference to it. Thus, a $(FONT_LINK) must not
 * be destructed while it is used by a $(U Text).
 *
 * See also the note on coordinates and undistorted rendering in
 * $(TRANSFORMABLE_LINK).
 *
 * example:
 * ---
 * // Declare and load a font
 * auto font = new Font();
 * font.loadFromFile("arial.ttf");
 *
 * // Create a text
 * auto text = new Text("hello", font);
 * text.setCharacterSize(30);
 * text.setStyle(Text.Style.Bold);
 * text.setColor(Color.Red);
 *
 * // Draw it
 * window.draw(text);
 * ---
 *
 * See_Also:
 * $(FONT_LINK), $(TRANSFORMABLE_LINK)
 */
module dsfml.graphics.text;

import dsfml.graphics.font;
import dsfml.graphics.glyph;
import dsfml.graphics.color;
import dsfml.graphics.rect;
import dsfml.graphics.transformable;
import dsfml.graphics.drawable;
import dsfml.graphics.texture;
import dsfml.graphics.vertexarray;
import dsfml.graphics.vertex;
import dsfml.graphics.rendertarget;
import dsfml.graphics.renderstates;
import dsfml.graphics.primitivetype;

import dsfml.system.vector2;

/**
 * Graphical text that can be drawn to a render target.
 */
class Text : Drawable, Transformable
{
    /// Enumeration of the string drawing styles.
    enum Style
    {
        /// Regular characters, no style
        Regular = 0,
        /// Bold characters
        Bold = 1 << 0,
        /// Italic characters
        Italic = 1 << 1,
        /// Underlined characters
        Underlined = 1 << 2,
        /// Strike through characters
        StrikeThrough = 1 << 3
    }

    mixin NormalTransformable;

    private
    {
        dchar[] m_string;
        Font m_font;
        uint m_characterSize;
        Style m_style;
        Color m_fillColor;
        Color m_outlineColor;
        float m_outlineThickness;
        VertexArray m_vertices;
        VertexArray m_outlineVertices;
        FloatRect m_bounds;
        bool m_geometryNeedUpdate;

        //helper function to copy input string into character buffer
        void stringCopy(T)(const(T)[] str)
        if (is(T == dchar)||is(T == wchar)||is(T == char))
        {
            import std.utf: byDchar;

            //make a conservative estimate on how much room we'll need
            m_string.reserve(dchar.sizeof * str.length);
            m_string.length = 0;

            foreach(dchar c; str.byDchar())
                m_string~=c;
        }
    }

    /**
     * Default constructor
     *
     * Creates an empty text.
     */
    this()
    {
        m_characterSize = 30;
        m_style = Style.Regular;
        m_fillColor = Color(255,255,255);
        m_outlineColor = Color(0,0,0);
        m_outlineThickness = 0;
        m_vertices = new VertexArray(PrimitiveType.Triangles);
        m_outlineVertices = new VertexArray(PrimitiveType.Triangles);
        m_bounds = FloatRect();
        m_geometryNeedUpdate = false;
    }

    /**
     * Construct the text from a string, font and size
     *
     * Note that if the used font is a bitmap font, it is not scalable, thus not
     * all requested sizes will be available to use. This needs to be taken into
     * consideration when setting the character size. If you need to display
     * text of a certain size, make sure the corresponding bitmap font that
     * supports that size is used.
     *
     * Params:
     *	text          = Text assigned to the string
     *	font          = Font used to draw the string
     *	characterSize = Base size of characters, in pixels
     *
     * Deprecated: Use the constructor that takes a 'const(dchar)[]' instead.
     */
    deprecated("Use the constructor that takes a 'const(dchar)[]' instead.")
    this(T)(const(T)[] text, Font font, uint characterSize = 30)
        if (is(T == dchar)||is(T == wchar)||is(T == char))
    {
        stringCopy(text);
        m_font = font;
        m_characterSize = characterSize;
        m_style = Style.Regular;
        m_fillColor = Color(255,255,255);
        m_outlineColor = Color(0,0,0);
        m_outlineThickness = 0;
        m_vertices = new VertexArray(PrimitiveType.Triangles);
        m_outlineVertices = new VertexArray(PrimitiveType.Triangles);
        m_bounds = FloatRect();
        m_geometryNeedUpdate = true;
    }

    /**
     * Construct the text from a string, font and size
     *
     * Note that if the used font is a bitmap font, it is not scalable, thus not
     * all requested sizes will be available to use. This needs to be taken into
     * consideration when setting the character size. If you need to display
     * text of a certain size, make sure the corresponding bitmap font that
     * supports that size is used.
     *
     * Params:
     *	text          = Text assigned to the string
     *	font          = Font used to draw the string
     *	characterSize = Base size of characters, in pixels
     */
    this(T)(const(dchar)[] text, Font font, uint characterSize = 30)
    {
        stringCopy(text);
        m_font = font;
        m_characterSize = characterSize;
        m_style = Style.Regular;
        m_fillColor = Color(255,255,255);
        m_outlineColor = Color(0,0,0);
        m_outlineThickness = 0;
        m_vertices = new VertexArray(PrimitiveType.Triangles);
        m_outlineVertices = new VertexArray(PrimitiveType.Triangles);
        m_bounds = FloatRect();
        m_geometryNeedUpdate = true;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
    }

    @property
    {
        /**
         * The character size in pixels.
         *
         * The default size is 30.
         *
         * Note that if the used font is a bitmap font, it is not scalable, thus
         * not all requested sizes will be available to use. This needs to be
         * taken into consideration when setting the character size. If you need
         * to display text of a certain size, make sure the corresponding bitmap
         * font that supports that size is used.
         */
        uint characterSize(uint size)
        {
            if(m_characterSize != size)
            {
                m_characterSize = size;
                m_geometryNeedUpdate = true;
            }
            return m_characterSize;
        }

        /// ditto
        uint characterSize() const
        {
            return m_characterSize;
        }
    }

    /**
     * Set the character size.
     *
     * The default size is 30.
     *
     * Note that if the used font is a bitmap font, it is not scalable, thus
     * not all requested sizes will be available to use. This needs to be
     * taken into consideration when setting the character size. If you need
     * to display text of a certain size, make sure the corresponding bitmap
     * font that supports that size is used.
     *
     * Params:
     * 		size	= New character size, in pixels.
     *
     * Deprecated: Use the 'characterSize' property instead.
     */
    deprecated("Use the 'characterSize' property instead.")
    void setCharacterSize(uint size)
    {
        characterSize = size;
    }

    /**
     * Get the character size.
     *
     * Returns: Size of the characters, in pixels.
     *
     * Deprecated: Use the 'characterSize' property instead.
     */
    deprecated("Use the 'characterSize' property instead.")
    uint getCharacterSize() const
    {
        return characterSize;
    }

    /**
     * Set the fill color of the text.
     *
     * By default, the text's color is opaque white.
     *
     * Params:
     * 		color	= New color of the text.
     *
     * Deprecated: Use the 'fillColor' or 'outlineColor' properties instead.
     */
    deprecated("Use the 'fillColor' or 'outlineColor' properties instead.")
    void setColor(Color color)
    {
        fillColor = color;
    }

    /**
     * Get the fill color of the text.
     *
     * Returns: Fill color of the text.
     *
     * Deprecated: Use the 'fillColor' or 'outlineColor' properties instead.
     */
    deprecated("Use the 'fillColor' or 'outlineColor' properties instead.")
    Color getColor() const
    {
        return fillColor;
    }

    @property
    {
        /**
        * The fill color of the text.
        *
        * By default, the text's fill color is opaque white. Setting the fill
        * color to a transparent color with an outline will cause the outline to
        * be displayed in the fill area of the text.
        */
        Color fillColor(Color color)
        {
            if(m_fillColor != color)
            {
                m_fillColor = color;

                // Change vertex colors directly, no need to update whole geometry
                // (if geometry is updated anyway, we can skip this step)
                if(!m_geometryNeedUpdate)
                {
                    for(int i = 0; i < m_vertices.getVertexCount(); ++i)
                    {
                        m_vertices[i].color = m_fillColor;
                    }
                }
            }

            return m_fillColor;
        }

        /// ditto
        Color fillColor() const
        {
            return m_fillColor;
        }
    }

    @property
    {
        /**
        * The outline color of the text.
        *
        * By default, the text's outline color is opaque black.
        */
        Color outlineColor(Color color)
        {
            if(m_outlineColor != color)
            {
                m_outlineColor = color;

                // Change vertex colors directly, no need to update whole geometry
                // (if geometry is updated anyway, we can skip this step)
                if(!m_geometryNeedUpdate)
                {
                    for(int i = 0; i < m_outlineVertices.getVertexCount(); ++i)
                    {
                        m_outlineVertices[i].color = m_outlineColor;
                    }
                }
            }

            return m_outlineColor;
        }

        /// ditto
        Color outlineColor() const
        {
            return m_outlineColor;
        }
    }

    @property
    {
        /**
        * The outline color of the text.
        *
        * By default, the text's outline color is opaque black.
        */
        float outlineThickness(float thickness)
        {
            if(m_outlineThickness != thickness)
            {
                m_outlineThickness = thickness;
                m_geometryNeedUpdate = true;
            }

            return m_outlineThickness;
        }

        /// ditto
        float outlineThickness() const
        {
            return m_outlineThickness;
        }
    }

    @property
    {
        /**
        * The text's font.
        */
        const(Font) font(Font newFont)
        {
            if (m_font !is newFont)
            {
                m_font = newFont;
                m_geometryNeedUpdate = true;
            }

            return m_font;
        }

        /// ditto
        const(Font) font() const
        {
            return m_font;
        }
    }

    /**
     * Set the text's font.
     *
     * Params:
     * 		newFont	= New font
     *
     * Deprecated: Use the 'font' property instead.
     */
    deprecated("Use the 'font' property instead.")
    void setFont(Font newFont)
    {
        font = newFont;
    }

    /**
     * Get thet text's font.
     *
     * Returns: Text's font.
     *
     * Deprecated: Use the 'font' property instead.
     */
    deprecated("Use the 'font' property instead.")
    const(Font) getFont() const
    {
        return font;
    }

    /**
     * Get the global bounding rectangle of the entity.
     *
     * The returned rectangle is in global coordinates, which means that it
     * takes in account the transformations (translation, rotation, scale, ...)
     * that are applied to the entity. In other words, this function returns the
     * bounds of the sprite in the global 2D world's coordinate system.
     *
     * Returns: Global bounding rectangle of the entity.
     */
    @property FloatRect globalBounds()
    {
        return getTransform().transformRect(localBounds);
    }

    /**
     * Get the global bounding rectangle of the entity.
     *
     * The returned rectangle is in global coordinates, which means that it
     * takes in account the transformations (translation, rotation, scale, ...)
     * that are applied to the entity. In other words, this function returns the
     * bounds of the sprite in the global 2D world's coordinate system.
     *
     * Returns: Global bounding rectangle of the entity.
     *
     * Deprecated: Use the 'globalBounds' property instead.
     */
    deprecated("Use the 'globalBounds' property instead.")
    FloatRect getGlobalBounds()
    {
        return globalBounds;
    }

    /**
     * Get the local bounding rectangle of the entity.
     *
     * The returned rectangle is in local coordinates, which means that it
     * ignores the transformations (translation, rotation, scale, ...) that are
     * applied to the entity. In other words, this function returns the bounds
     * of the entity in the entity's coordinate system.
     *
     * Returns: Local bounding rectangle of the entity.
     */
    @property FloatRect localBounds() const
    {
        return m_bounds;
    }

    /**
     * Get the local bounding rectangle of the entity.
     *
     * The returned rectangle is in local coordinates, which means that it
     * ignores the transformations (translation, rotation, scale, ...) that are
     * applied to the entity. In other words, this function returns the bounds
     * of the entity in the entity's coordinate system.
     *
     * Returns: Local bounding rectangle of the entity.
     *
     * Deprecated: Use the 'globalBounds' property instead.
     */
    deprecated("Use the 'localBounds' property instead.")
    FloatRect getLocalBounds() const
    {
        return localBounds;
    }

    @property
    {
        /**
         * The text's style.
         *
         * You can pass a combination of one or more styles, for example
         * Style.Bold | Text.Italic.
         */
        Style style(Style newStyle)
        {
            if(m_style != newStyle)
            {
                m_style = newStyle;
                m_geometryNeedUpdate = true;
            }

            return m_style;
        }

        /// ditto
        Style style() const
        {
            return m_style;
        }
    }

    /**
     * Set the text's style.
     *
     * You can pass a combination of one or more styles, for example
     * Style.Bold | Text.Italic.
     *
     * Params:
     *      newStyle = New style
     *
     * Deprecated: Use the 'style' property instead.
     */
    deprecated("Use the 'style' property instead.")
    void setStyle(Style newStyle)
    {
        style = newStyle;
    }

    /**
     * Get the text's style.
     *
     * Returns: Text's style.
     *
     * Deprecated: Use the 'style' property instead.
     */
    deprecated("Use the 'style' property instead.")
    Style getStyle() const
    {
        return style;
    }

    @property
    {
        /**
         * The text's string.
         *
         * A text's string is empty by default.
         */
        const(dchar)[] string(const(dchar)[] str)
        {
            // Because of the conversion, assume the text is new
            stringCopy(str);
            m_geometryNeedUpdate = true;
            return m_string;
        }
        /// ditto
        const(dchar)[] string() const
        {
            return m_string;
        }
    }

    /**
     * Set the text's string.
     *
     * A text's string is empty by default.
     *
     * Params:
     * 		text	= New string
     *
     * Deprecated: Use the 'string' property instead.
     */
    deprecated("Use the 'string' property instead.")
    void setString(T)(const(T)[] text)
        if (is(T == dchar)||is(T == wchar)||is(T == char))
    {
        // Because of the conversion, assume the text is new
        stringCopy(text);
        m_geometryNeedUpdate = true;
    }

    /**
     * Get a copy of the text's string.
     *
     * Returns: a copy of the text's string.
     *
     * Deprecated: Use the 'string' property instead.
     */
    deprecated("Use the 'string' property instead.")
    const(T)[] getString(T=char)() const
        if (is(T == dchar)||is(T == wchar)||is(T == char))
    {
        import std.utf: toUTF8, toUTF16, toUTF32;

        static if(is(T == char))
		    return toUTF8(m_string);
	    else static if(is(T == wchar))
		    return toUTF16(m_string);
	    else static if(is(T == dchar))
		    return toUTF32(m_string);
    }

    /**
     * Draw the object to a render target.
     *
     * Params:
     *  		renderTarget =	Render target to draw to
     *  		renderStates =	Current render states
     */
    void draw(RenderTarget renderTarget, RenderStates renderStates)
    {
        if (m_font !is null)
        {
            ensureGeometryUpdate();

            renderStates.transform *= getTransform();
            renderStates.texture =  m_font.getTexture(m_characterSize);

            // Only draw the outline if there is something to draw
            if (m_outlineThickness != 0)
                renderTarget.draw(m_outlineVertices, renderStates);

            renderTarget.draw(m_vertices, renderStates);
        }
    }

    /**
     * Return the position of the index-th character.
     *
     * This function computes the visual position of a character from its index
     * in the string. The returned position is in global coordinates
     * (translation, rotation, scale and origin are applied). If index is out of
     * range, the position of the end of the string is returned.
     *
     * Params:
     * 		index	= Index of the character
     *
     * Returns: Position of the character.
     */
    Vector2f findCharacterPos(size_t index)
    {
        // Make sure that we have a valid font
        if(m_font is null)
        {
            return Vector2f(0,0);
        }

        // Adjust the index if it's out of range
        if(index > m_string.length)
        {
            index = m_string.length;
        }

        // Precompute the variables needed by the algorithm
        bool bold  = (m_style & Style.Bold) != 0;
        float hspace = cast(float)(m_font.getGlyph(' ', m_characterSize, bold).advance);
        float vspace = cast(float)(m_font.getLineSpacing(m_characterSize));

        // Compute the position
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
                default : break;
            }

            // For regular characters, add the advance offset of the glyph
            position.x += cast(float)(m_font.getGlyph(curChar, m_characterSize, bold).advance);
        }

        // Transform the position to global coordinates
        position = getTransform().transformPoint(position);

        return position;
    }

private:
    void ensureGeometryUpdate()
    {
        import std.math: floor;
        import std.algorithm: max, min;

        // Add an underline or strikethrough line to the vertex array
        static void addLine(VertexArray vertices, float lineLength,
                            float lineTop, ref const(Color) color, float offset,
                            float thickness, float outlineThickness = 0)
        {
            float top = floor(lineTop + offset - (thickness / 2) + 0.5f);
            float bottom = top + floor(thickness + 0.5f);

            vertices.append(Vertex(Vector2f(-outlineThickness,             top    - outlineThickness), color, Vector2f(1, 1)));
            vertices.append(Vertex(Vector2f(lineLength + outlineThickness, top    - outlineThickness), color, Vector2f(1, 1)));
            vertices.append(Vertex(Vector2f(-outlineThickness,             bottom + outlineThickness), color, Vector2f(1, 1)));
            vertices.append(Vertex(Vector2f(-outlineThickness,             bottom + outlineThickness), color, Vector2f(1, 1)));
            vertices.append(Vertex(Vector2f(lineLength + outlineThickness, top    - outlineThickness), color, Vector2f(1, 1)));
            vertices.append(Vertex(Vector2f(lineLength + outlineThickness, bottom + outlineThickness), color, Vector2f(1, 1)));
        }

        // Add a glyph quad to the vertex array
        static void addGlyphQuad(VertexArray vertices, Vector2f position,
                                 ref const(Color) color, ref const(Glyph) glyph,
                                 float italic, float outlineThickness = 0)
        {
            float left   = glyph.bounds.left;
            float top    = glyph.bounds.top;
            float right  = glyph.bounds.left + glyph.bounds.width;
            float bottom = glyph.bounds.top  + glyph.bounds.height;

            float u1 = glyph.textureRect.left;
            float v1 = glyph.textureRect.top;
            float u2 = glyph.textureRect.left + glyph.textureRect.width;
            float v2 = glyph.textureRect.top  + glyph.textureRect.height;

            vertices.append(Vertex(Vector2f(position.x + left  - italic * top    - outlineThickness, position.y + top    - outlineThickness), color, Vector2f(u1, v1)));
            vertices.append(Vertex(Vector2f(position.x + right - italic * top    - outlineThickness, position.y + top    - outlineThickness), color, Vector2f(u2, v1)));
            vertices.append(Vertex(Vector2f(position.x + left  - italic * bottom - outlineThickness, position.y + bottom - outlineThickness), color, Vector2f(u1, v2)));
            vertices.append(Vertex(Vector2f(position.x + left  - italic * bottom - outlineThickness, position.y + bottom - outlineThickness), color, Vector2f(u1, v2)));
            vertices.append(Vertex(Vector2f(position.x + right - italic * top    - outlineThickness, position.y + top    - outlineThickness), color, Vector2f(u2, v1)));
            vertices.append(Vertex(Vector2f(position.x + right - italic * bottom - outlineThickness, position.y + bottom - outlineThickness), color, Vector2f(u2, v2)));
        }

        // Do nothing, if geometry has not changed
        if (!m_geometryNeedUpdate)
            return;

        // Mark geometry as updated
        m_geometryNeedUpdate = false;

        // Clear the previous geometry
        m_vertices.clear();
        m_outlineVertices.clear();
        m_bounds = FloatRect();

        // No font or text: nothing to draw
        if (!m_font || m_string.length == 0)
            return;

        // Compute values related to the text style
        bool  bold               = (m_style & Style.Bold) != 0;
        bool  underlined         = (m_style & Style.Underlined) != 0;
        bool  strikeThrough      = (m_style & Style.StrikeThrough) != 0;
        float italic             = (m_style & Style.Italic) ? 0.208f : 0.0f; // 12 degrees
        float underlineOffset    = m_font.getUnderlinePosition(m_characterSize);
        float underlineThickness = m_font.getUnderlineThickness(m_characterSize);

        // Compute the location of the strike through dynamically
        // We use the center point of the lowercase 'x' glyph as the reference
        // We reuse the underline thickness as the thickness of the strike through as well
        FloatRect xBounds = m_font.getGlyph('x', m_characterSize, bold).bounds;
        float strikeThroughOffset = xBounds.top + xBounds.height / 2.0f;

        // Precompute the variables needed by the algorithm
        float hspace = m_font.getGlyph(' ', m_characterSize, bold).advance;
        float vspace = m_font.getLineSpacing(m_characterSize);
        float x      = 0.0f;
        float y      = cast(float)m_characterSize;

        // Create one quad for each character
        float minX = cast(float)m_characterSize;
        float minY = cast(float)m_characterSize;
        float maxX = 0.0f;
        float maxY = 0.0f;
        dchar prevChar = '\0';
        for (size_t i = 0; i < m_string.length; ++i)
        {
            dchar curChar = m_string[i];

            // Apply the kerning offset
            x += m_font.getKerning(prevChar, curChar, m_characterSize);
            prevChar = curChar;

            // If we're using the underlined style and there's a new line, draw a line
            if (underlined && (curChar == '\n'))
            {
                addLine(m_vertices, x, y, m_fillColor, underlineOffset, underlineThickness);

                if (m_outlineThickness != 0)
                    addLine(m_outlineVertices, x, y, m_outlineColor, underlineOffset, underlineThickness, m_outlineThickness);
            }

            // If we're using the strike through style and there's a new line, draw a line across all characters
            if (strikeThrough && (curChar == '\n'))
            {
                addLine(m_vertices, x, y, m_fillColor, strikeThroughOffset, underlineThickness);

                if (m_outlineThickness != 0)
                    addLine(m_outlineVertices, x, y, m_outlineColor, strikeThroughOffset, underlineThickness, m_outlineThickness);
            }

            // Handle special characters
            if ((curChar == ' ') || (curChar == '\t') || (curChar == '\n'))
            {
                // Update the current bounds (min coordinates)
                minX = min(minX, x);
                minY = min(minY, y);

                switch (curChar)
                {
                    case ' ':  x += hspace;        break;
                    case '\t': x += hspace * 4;    break;
                    case '\n': y += vspace; x = 0; break;
                    default : break;
                }

                // Update the current bounds (max coordinates)
                maxX = max(maxX, x);
                maxY = max(maxY, y);

                // Next glyph, no need to create a quad for whitespace
                continue;
            }

            // Apply the outline
            if (m_outlineThickness != 0)
            {
                Glyph glyph = m_font.getGlyph(curChar, m_characterSize, bold, m_outlineThickness);

                float left   = glyph.bounds.left;
                float top    = glyph.bounds.top;
                float right  = glyph.bounds.left + glyph.bounds.width;
                float bottom = glyph.bounds.top  + glyph.bounds.height;

                // Add the outline glyph to the vertices
                addGlyphQuad(m_outlineVertices, Vector2f(x, y), m_outlineColor, glyph, italic, m_outlineThickness);

                // Update the current bounds with the outlined glyph bounds
                minX = min(minX, x + left   - italic * bottom - m_outlineThickness);
                maxX = max(maxX, x + right  - italic * top    - m_outlineThickness);
                minY = min(minY, y + top    - m_outlineThickness);
                maxY = max(maxY, y + bottom - m_outlineThickness);
            }

            // Extract the current glyph's description
            const Glyph glyph = m_font.getGlyph(curChar, m_characterSize, bold);

            // Add the glyph to the vertices
            addGlyphQuad(m_vertices, Vector2f(x, y), m_fillColor, glyph, italic);

            // Update the current bounds with the non outlined glyph bounds
            if (m_outlineThickness == 0)
            {
                float left   = glyph.bounds.left;
                float top    = glyph.bounds.top;
                float right  = glyph.bounds.left + glyph.bounds.width;
                float bottom = glyph.bounds.top  + glyph.bounds.height;

                minX = min(minX, x + left  - italic * bottom);
                maxX = max(maxX, x + right - italic * top);
                minY = min(minY, y + top);
                maxY = max(maxY, y + bottom);
            }

            // Advance to the next character
            x += glyph.advance;
        }

        // If we're using the underlined style, add the last line
        if (underlined && (x > 0))
        {
            addLine(m_vertices, x, y, m_fillColor, underlineOffset, underlineThickness);

            if (m_outlineThickness != 0)
                addLine(m_outlineVertices, x, y, m_outlineColor, underlineOffset, underlineThickness, m_outlineThickness);
        }

        // If we're using the strike through style, add the last line across all characters
        if (strikeThrough && (x > 0))
        {
            addLine(m_vertices, x, y, m_fillColor, strikeThroughOffset, underlineThickness);

            if (m_outlineThickness != 0)
                addLine(m_outlineVertices, x, y, m_outlineColor, strikeThroughOffset, underlineThickness, m_outlineThickness);
        }

        // Update the bounding rectangle
        m_bounds.left = minX;
        m_bounds.top = minY;
        m_bounds.width = maxX - minX;
        m_bounds.height = maxY - minY;
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;
        import dsfml.graphics.rendertexture;

        writeln("Unit test for Text");

        auto renderTexture = new RenderTexture();

        renderTexture.create(400,200);

        auto font = new Font();
        assert(font.loadFromFile("res/Warenhaus-Standard.ttf"));

        Text regular = new Text("Regular", font, 20);
        Text bold = new Text("Bold", font, 20);
        Text italic = new Text("Italic", font, 20);
        Text boldItalic = new Text("Bold Italic", font, 20);
        Text strikeThrough = new Text("Strike Through", font, 20);
        Text italicStrikeThrough = new Text("Italic Strike Through", font, 20);
        Text boldStrikeThrough = new Text("Bold Strike Through", font, 20);
        Text boldItalicStrikeThrough = new Text("Bold Italic Strike Through", font, 20);
        Text outlined = new Text("Outlined", font, 20);
        Text outlinedBoldItalicStrikeThrough = new Text("Outlined Bold Italic Strike Through", font, 20);

        bold.style = Text.Style.Bold;
        bold.position = Vector2f(0,20);

        italic.style = Text.Style.Italic;
        italic.position = Vector2f(0,40);

        boldItalic.style = Text.Style.Bold | Text.Style.Italic;
        boldItalic.position = Vector2f(0,60);

        strikeThrough.style = Text.Style.StrikeThrough;
        strikeThrough.position = Vector2f(0,80);

        italicStrikeThrough.style = Text.Style.Italic | Text.Style.StrikeThrough;
        italicStrikeThrough.position = Vector2f(0,100);

        boldStrikeThrough.style = Text.Style.Bold | Text.Style.StrikeThrough;
        boldStrikeThrough.position = Vector2f(0,120);

        boldItalicStrikeThrough.style = Text.Style.Bold | Text.Style.Italic | Text.Style.StrikeThrough;
        boldItalicStrikeThrough.position = Vector2f(0,140);

        outlined.outlineColor = Color.Red;
        outlined.outlineThickness = 0.5f;
        outlined.position = Vector2f(0,160);

        outlinedBoldItalicStrikeThrough.style = Text.Style.Bold | Text.Style.Italic | Text.Style.StrikeThrough;
        outlinedBoldItalicStrikeThrough.outlineColor = Color.Red;
        outlinedBoldItalicStrikeThrough.outlineThickness = 0.5f;
        outlinedBoldItalicStrikeThrough.position = Vector2f(0,180);

        writeln(regular.string);

        renderTexture.clear();

        renderTexture.draw(regular);
        renderTexture.draw(bold);
        renderTexture.draw(italic);
        renderTexture.draw(boldItalic);
        renderTexture.draw(strikeThrough);
        renderTexture.draw(italicStrikeThrough);
        renderTexture.draw(boldStrikeThrough);
        renderTexture.draw(boldItalicStrikeThrough);
        renderTexture.draw(outlined);
        renderTexture.draw(outlinedBoldItalicStrikeThrough);

        renderTexture.display();

        //grab that texture for usage
        auto texture = renderTexture.getTexture();

        texture.copyToImage().saveToFile("Text.png");

        writeln();
    }
}
