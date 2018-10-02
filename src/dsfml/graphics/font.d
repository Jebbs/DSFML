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
 *
 * Fonts can be loaded from a file, from memory or from a custom stream, and
 * supports the most common types of fonts. See the `loadFromFile` function for
 * the complete list of supported formats.
 *
 * Once it is loaded, a $(U Font) instance provides three types of information
 * about the font:
 * $(UL
 * $(LI Global metrics, such as the line spacing)
 * $(LI Per-glyph metrics, such as bounding box or kerning)
 * $(LI Pixel representation of glyphs))
 *
 * $(PARA
 * Fonts alone are not very useful: they hold the font data but cannot make
 * anything useful of it. To do so you need to use the $(TEXT_LINK) class, which
 * is able to properly output text with several options such as character size,
 * style, color, position, rotation, etc.
 * This separation allows more flexibility and better performances: indeed a
 & $(U Font) is a heavy resource, and any operation on it is slow (often too
 * slow for real-time applications). On the other side, a $(TEXT_LINK) is a
 * lightweight object which can combine the glyphs data and metrics of a
 * $(U Font) to display any text on a render target.
 * Note that it is also possible to bind several $(TEXT_LINK) instances to the
 * same $(U Font).
 *
 * It is important to note that the $(TEXT_LINK) instance doesn't copy the font
 * that it uses, it only keeps a reference to it. Thus, a $(U Font) must not be
 * destructed while it is used by a $(TEXT_LINK).)
 *
 * Example:
 * ---
 * // Declare a new font
 * auto font = new Font();
 *
 * // Load it from a file
 * if (!font.loadFromFile("arial.ttf"))
 * {
 *     // error...
 * }
 *
 * // Create a text which uses our font
 * auto text1 = new Text();
 * text1.setFont(font);
 * text1.setCharacterSize(30);
 * text1.setStyle(Text.Style.Regular);
 *
 * // Create another text using the same font, but with different parameters
 * auto text2 = new Text();
 * text2.setFont(font);
 * text2.setCharacterSize(50);
 * text2.setStyle(Text.Style.Italic);
 * ---
 *
 * $(PARA Apart from loading font files, and passing them to instances of
 * $(TEXT_LINK), you should normally not have to deal directly with this class.
 * However, it may be useful to access the font metrics or rasterized glyphs for
 * advanced usage.
 *
 * Note that if the font is a bitmap font, it is not scalable, thus not all
 * requested sizes will be available to use. This needs to be taken into
 * consideration when using $(TEXT_LINK).
 * If you need to display text of a certain size, make sure the corresponding
 * bitmap font that supports that size is used.)
 *
 * See_Also:
 * $(TEXT_LINK)
 */
module dsfml.graphics.font;

import dsfml.graphics.texture;
import dsfml.graphics.glyph;
import dsfml.system.inputstream;
import dsfml.system.err;

/**
 * Class for loading and manipulating character fonts.
 */
class Font
{

    /// Holds various information about a font.
    struct Info
    {
        /// The font family.
        const(char)[] family;
    }

    package sfFont* sfPtr;
    private Info m_info;
    private Texture[int] textures;

    //keeps an instance of the C++ stream stored if used
    private fontStream m_stream;

    /**
     * Default constructor.
     *
     * Defines an empty font.
     */
    this()
    {
        sfPtr = sfFont_construct();
    }

    package this(sfFont* newFont)
    {
        sfPtr = newFont;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfFont_destroy(sfPtr);
    }

    /**
     * Load the font from a file.
     *
     * The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT,
     * X11 PCF, Windows FNT, BDF, PFR and Type 42. Note that this function know
     * nothing about the standard fonts installed on the user's system, thus you
     * can't load them directly.
     *
     * DSFML cannot preload all the font data in this function, so the file has
     * to remain accessible until the Font object loads a new font or is
     * destroyed.
     *
     * Params:
     * 		filename	= Path of the font file to load
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromFile(const(char)[] filename)
    {
        return sfFont_loadFromFile(sfPtr, filename.ptr, filename.length);
    }

    /**
     * Load the font from a file in memory.
     *
     * The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT,
     * X11 PCF, Windows FNT, BDF, PFR and Type 42.
     *
     * DSFML cannot preload all the font data in this function, so the buffer
     * pointed by data has to remain valid until the Font object loads a new
     * font or is destroyed.
     *
     * Params:
     * 		data	= data holding the font file
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromMemory(const(void)[] data)
    {
        return sfFont_loadFromMemory(sfPtr, data.ptr, data.length);
    }

    /**
     * Load the font from a custom stream.
     *
     * The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT,
     * X11 PCF, Windows FNT, BDF, PFR and Type 42.
     *
     * DSFML cannot preload all the font data in this function, so the contents
     * of stream have to remain valid as long as the font is used.
     *
     * Params:
     * 		stream	= Source stream to read from
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream stream)
    {
        m_stream = new fontStream(stream);
        return sfFont_loadFromStream(sfPtr, m_stream);
    }

    ref const(Info) getInfo() const
    {
        return m_info;
    }

    /**
     * Retrieve a glyph of the font.
     *
     * Params:
     * 		codePoint		 = Unicode code point of the character ot get
     * 		characterSize	 = Reference character size
     * 		bold			 = Retrieve the bold version or the regular one?
     *      outlineThickness = Thickness of outline (when != 0 the glyph will not be filled)
     *
     * Returns: The glyph corresponding to codePoint and characterSize.
     */
    Glyph getGlyph(dchar codePoint, uint characterSize, bool bold, float outlineThickness = 0) const
    {
        Glyph temp;

        sfFont_getGlyph(sfPtr, cast(uint)codePoint, characterSize, bold, outlineThickness, &temp.advance,&temp.bounds.left,&temp.bounds.top,&temp.bounds.width,&temp.bounds.height,&temp.textureRect.left,&temp.textureRect.top,&temp.textureRect.width,&temp.textureRect.height);

        return temp;
    }

    /**
     * Get the kerning offset of two glyphs.
     *
     * The kerning is an extra offset (negative) to apply between two glyphs
     * when rendering them, to make the pair look more "natural". For example,
     * the pair "AV" have a special kerning to make them closer than other
     * characters. Most of the glyphs pairs have a kerning offset of zero,
     * though.
     *
     * Params:
     * 		first			= Unicode code point of the first character
     * 		second			= Unicode code point of the second character
     * 		characterSize	= Reference character size
     *
     * Returns: Kerning value for first and second, in pixels.
     */
    float getKerning (dchar first, dchar second, uint characterSize) const
    {
        return sfFont_getKerning(sfPtr, cast(uint)first, cast(uint)second, characterSize);
    }

    /**
     * Get the line spacing.
     *
     * The spacing is the vertical offset to apply between consecutive lines of
     * text.
     *
     * Params:
     * 		characterSize	= Reference character size
     *
     * Returns: Line spacing, in pixels.
     */
    float getLineSpacing (uint characterSize) const
    {
        return sfFont_getLineSpacing(sfPtr, characterSize);
    }

    /**
     * Get the position of the underline.
     *
     * Underline position is the vertical offset to apply between the baseline
     * and the underline.
     *
     * Params:
     * 		characterSize	= Reference character size
     *
     * Returns: Underline position, in pixels.
     */
    float getUnderlinePosition (uint characterSize) const
    {
        return sfFont_getUnderlinePosition(sfPtr, characterSize);
    }

    /**
     * Get the thickness of the underline.
     *
     * Underline thickness is the vertical size of the underline.
     *
     * Params:
     * 		characterSize	= Reference character size
     *
     * Returns: Underline thickness, in pixels.
     */
    float getUnderlineThickness (uint characterSize) const
    {
        return sfFont_getUnderlineThickness(sfPtr, characterSize);
    }

    /**
     * Retrieve the texture containing the loaded glyphs of a certain size.
     *
     * The contents of the returned texture changes as more glyphs are
     * requested, thus it is not very relevant. It is mainly used internally by
     * Text.
     *
     * Params:
     * 		characterSize	= Reference character size
     *
     * Returns: Texture containing the glyphs of the requested size.
     */
    const(Texture) getTexture (uint characterSize)
    {
        Texture ret = textures.get(characterSize, null);

        if(ret is null)
        {
            ret = new Texture(sfFont_getTexture(sfPtr, characterSize));
            textures[characterSize] = ret;
        }

        return ret;
    }

    /**
     * Performs a deep copy on the font.
     *
     * Returns: The duplicated font.
     */
    @property
    Font dup() const
    {
        return new Font(sfFont_copy(sfPtr));
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;

        import dsfml.graphics.text;

        writeln("Unitest for Font");

        auto font = new Font();
        assert(font.loadFromFile("res/Warenhaus-Standard.ttf"));

        Text text;
        text = new Text("Sample String", font);


        //draw text or something

        writeln();
    }
}


private:
private extern(C++) interface fontInputStream
{
    long read(void* data, long size);

    long seek(long position);

    long tell();

    long getSize();
}


private class fontStream:fontInputStream
{
    private InputStream myStream;

    this(InputStream stream)
    {
        myStream = stream;
    }

    extern(C++)long read(void* data, long size)
    {
        return myStream.read(data[0..cast(size_t)size]);
    }

    extern(C++)long seek(long position)
    {
        return myStream.seek(position);
    }

    extern(C++)long tell()
    {
        return myStream.tell();
    }

    extern(C++)long getSize()
    {
        return myStream.getSize();
    }
}

package extern(C) struct sfFont;

private extern(C):

sfFont* sfFont_construct();

//Create a new font from a file
bool sfFont_loadFromFile(sfFont* font, const(char)* filename, size_t length);

//Create a new image font a file in memory
bool sfFont_loadFromMemory(sfFont* font, const(void)* data, size_t sizeInBytes);

//Create a new image font a custom stream
bool sfFont_loadFromStream(sfFont* font, fontInputStream stream);

// Copy an existing font
sfFont* sfFont_copy(const sfFont* font);

//Destroy an existing font
void sfFont_destroy(sfFont* font);

//Get a glyph in a font
void sfFont_getGlyph(const(sfFont)* font, uint codePoint, int characterSize, bool bold, float outlineThickness, float* glyphAdvance, float* glyphBoundsLeft, float* glyphBoundsTop, float* glyphBoundsWidth, float* glyphBoundsHeight, int* glyphTextRectLeft, int* glyphTextRectTop, int* glyphTextRectWidth, int* glyphTextRectHeight);

//Get the kerning value corresponding to a given pair of characters in a font
float sfFont_getKerning(const(sfFont)* font, uint first, uint second, uint characterSize);

//Get the line spacing value
float sfFont_getLineSpacing(const(sfFont)* font, uint characterSize);

//Get the position of the underline
float sfFont_getUnderlinePosition (const(sfFont)* font, uint characterSize);

//Get the thickness of the underline
float sfFont_getUnderlineThickness (const(sfFont)* font, uint characterSize);

//Get the font texture for a given character size
sfTexture* sfFont_getTexture(const(sfFont)* font, uint characterSize);
