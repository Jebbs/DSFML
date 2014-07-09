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
module dsfml.graphics.font;

import dsfml.graphics.texture;
import dsfml.graphics.glyph;
import dsfml.system.inputstream;
import dsfml.system.err;

/++
 + Class for loading and manipulating character fonts.
 + 
 + Fonts can be loaded from a file, from memory or from a custom stream, and supports the most common types of fonts.
 + 
 + See the loadFromFile function for the complete list of supported formats.
 + 
 + Once it is loaded, a Font instance provides three types of information about the font:
 + - Global metrics, such as the line spacing
 + - Per-glyph metrics, such as bounding box or kerning
 + - Pixel representation of glyphs
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1Font.php#details
 +/
class Font
{
	package sfFont* sfPtr;

	private Texture fontTexture;
	private fontStream m_stream;//keeps an instance of the C++ stream stored if used

	/// Defines an empty font
	this()
	{
		//Creates a null font
	}

	package this(sfFont* newFont)
	{
		sfPtr = newFont;
	}
	
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfFont_destroy(sfPtr);
	}

	/**
	 * Load the font from a file.
	 * 
	 * The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42. Note that this function know nothing about the standard fonts installed on the user's system, thus you can't load them directly.
	 * 
	 * Params:
	 * 		filename	= Path of the font file to load
	 * 
	 * Returns: True if loading succeeded, false if it failed.
	 */
	bool loadFromFile(string filename)
	{
		import std.conv;
		import std.string;
		//if the Font already exists, destroy it first
		if(sfPtr)
		{
			sfFont_destroy(sfPtr);
		}

		sfPtr = sfFont_createFromFile(toStringz(filename));

		if(sfPtr!is null)
		{
			fontTexture = new Texture(sfFont_getTexturePtr(sfPtr));
		}
		
		err.write(text(sfErr_getOutput()));
		
		return (sfPtr != null);
	}

	/**
	 * Load the font from a file in memory.
	 * 
	 * The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42. Warning: SFML cannot preload all the font data in this function, so the buffer pointed by data has to remain valid as long as the font is used.
	 * 
	 * Params:
	 * 		data	= data holding the font file
	 * 
	 * Returns: True if loading succeeded, false if it failed.
	 */
	bool loadFromMemory(const(void)[] data)
	{
		import std.conv;
		//if the Font already exists, destroy it first
		if(sfPtr)
		{
			sfFont_destroy(sfPtr);
		}

		sfPtr = sfFont_createFromMemory(data.ptr, data.length);

		if(sfPtr!is null)
		{
			fontTexture = new Texture(sfFont_getTexturePtr(sfPtr));
		}

		err.write(text(sfErr_getOutput()));

		return (sfPtr != null);
	}

	/**
	 * Load the font from a custom stream.
	 * 
	 * The supported font formats are: TrueType, Type 1, CFF, OpenType, SFNT, X11 PCF, Windows FNT, BDF, PFR and Type 42. Warning: SFML cannot preload all the font data in this function, so the contents of stream have to remain valid as long as the font is used.
	 * 
	 * Params:
	 * 		stream	= Source stream to read from
	 * 
	 * Returns: True if loading succeeded, false if it failed.
	 */
	bool loadFromStream(InputStream stream)
	{
		import std.conv;
		//if the Font already exists, destroy it first
		if(sfPtr)
		{
			sfFont_destroy(sfPtr);
		}
		m_stream = new fontStream(stream);

		sfPtr = sfFont_createFromStream(m_stream);

		if(sfPtr!is null)
		{
			fontTexture = new Texture(sfFont_getTexturePtr(sfPtr));
		}

		err.write(text(sfErr_getOutput()));
		
		return (sfPtr == null)?false:true;
	}

	/**
	 * Retrieve a glyph of the font.
	 * 
	 * Params:
	 * 		codePoint		= Unicode code point of the character ot get
	 * 		characterSize	= Reference character size
	 * 		bols			= Retrieve the bold version or the regular one?
	 * 
	 * Returns: The glyph corresponding to codePoint and characterSize
	 */
	Glyph getGlyph(dchar codePoint, uint characterSize, bool bold) const
	{
		Glyph temp;

		sfFont_getGlyph(sfPtr, cast(uint)codePoint, characterSize,bold,&temp.advance,&temp.bounds.left,&temp.bounds.top,&temp.bounds.width,&temp.bounds.height,&temp.textureRect.left,&temp.textureRect.top,&temp.textureRect.width,&temp.textureRect.height);

		return temp;
	}

	/**
	 * Get the kerning offset of two glyphs.
	 * 
	 * The kerning is an extra offset (negative) to apply between two glyphs when rendering them, to make the pair look more "natural". For example, the pair "AV" have a special kerning to make them closer than other characters. Most of the glyphs pairs have a kerning offset of zero, though.
	 * 
	 * Params:
	 * 		first			= Unicode code point of the first character
	 * 		second			= Unicode code point of the second character
	 * 		characterSize	= Reference character size
	 * 
	 * Returns: Kerning value for first and second, in pixels
	 */
	int getKerning (dchar first, dchar second, uint characterSize) const 
	{
		return sfFont_getKerning(sfPtr, cast(uint)first, cast(uint)second, characterSize);	
	}

	/**
	 * Get the line spacing.
	 * 
	 * The spacing is the vertical offset to apply between consecutive lines of text.
	 * 
	 * Params:
	 * 		characterSize	= Reference character size
	 * 
	 * Returns: Line spacing, in pixels
	 */
	int getLineSpacing (uint characterSize) const
	{
		return sfFont_getLineSpacing(sfPtr, characterSize);	
	}

	/**
	 * Retrieve the texture containing the loaded glyphs of a certain size.
	 * 
	 * The contents of the returned texture changes as more glyphs are requested, thus it is not very relevant. It is mainly used internally by Text.
	 * 
	 * Params:
	 * 		characterSize	= Reference character size
	 * 
	 * Returns: Texture containing the glyphs of the requested size
	 */
	const(Texture) getTexture (uint characterSize) const
	{
		//ToDo: cache texture somehow?
		//Possible: cache last size used using sound method(mutable instance storage)

		sfFont_updateTexture(sfPtr, characterSize);

		return fontTexture;
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
		assert(font.loadFromFile("res/unifont_upper.ttf"));

		Text text;
		text = new Text("Sample String", font);


		//draw text or something

		writeln();
	}
}


private:
private extern(C++) interface sfmlInputStream
{
	long read(void* data, long size);
	
	long seek(long position);
	
	long tell();
	
	long getSize();
}


private class fontStream:sfmlInputStream
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



package extern(C):
struct sfFont;

private extern(C):
//Create a new font from a file
sfFont* sfFont_createFromFile(const char* filename);


//Create a new image font a file in memory
sfFont* sfFont_createFromMemory(const void* data, size_t sizeInBytes);


//Create a new image font a custom stream
sfFont* sfFont_createFromStream(sfmlInputStream stream);


// Copy an existing font
sfFont* sfFont_copy(const sfFont* font);


//Destroy an existing font
void sfFont_destroy(sfFont* font);


//Get a glyph in a font
void sfFont_getGlyph(const(sfFont)* font, uint codePoint, int characterSize, bool bold, int* glyphAdvance, int* glyphBoundsLeft, int* glyphBoundsTop, int* glyphBoundsWidth, int* glyphBoundsHeight, int* glyphTextRectLeft, int* glyphTextRectTop, int* glyphTextRectWidth, int* glyphTextRectHeight);


//Get the kerning value corresponding to a given pair of characters in a font
int sfFont_getKerning(const(sfFont)* font, uint first, uint second, uint characterSize);


//Get the line spacing value
int sfFont_getLineSpacing(const(sfFont)* font, uint characterSize);


//Get the texture pointer for a particular font
sfTexture* sfFont_getTexturePtr(const(sfFont)* font);

//Update the internal texture associated with the font
void sfFont_updateTexture(const(sfFont)* font, uint characterSize);



const(char)* sfErr_getOutput();
