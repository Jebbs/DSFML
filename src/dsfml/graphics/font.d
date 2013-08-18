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

import std.string;

debug import std.stdio;
class Font
{
	package sfFont* sfPtr;
		
	this()
	{
		//Creates a null font
	}
	
	~this()
	{
		debug writeln("Destroying Font");
		sfFont_destroy(sfPtr);
	}
	
	bool loadFromFile(string filename)
	{
		sfPtr = sfFont_createFromFile(toStringz(filename));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromMemory(const(void)* data, int sizeInBytes)
	{
		sfPtr = sfFont_createFromMemory(data, sizeInBytes);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(void* stream)
	{
		sfPtr = sfFont_createFromStream(stream);
		return (sfPtr == null)?false:true;
	}
	
	package this(sfFont* newFont)
	{
		sfPtr = newFont;
	}
	
	Font dup() const
	{
		return new Font(sfFont_copy(sfPtr));
	}
	
	Glyph getGlyph(dchar codePoint, uint characterSize, bool bold) const
	{
		Glyph temp;

		sfFont_getGlyph(sfPtr, cast(uint)codePoint, characterSize,bold,&temp.advance,&temp.bounds.left,&temp.bounds.top,&temp.bounds.width,&temp.bounds.height,&temp.textureRect.left,&temp.textureRect.top,&temp.textureRect.width,&temp.textureRect.height);

		return temp;
		//return(bold)? Glyph(sfFont_getGlyph(sfPtr, codePoint, CharacterSize, sfTrue)):Glyph(sfFont_getGlyph(sfPtr, codePoint, CharacterSize, sfFalse));
	}
	
	int getKerning (dchar first, dchar second, uint characterSize) const 
	{
		return sfFont_getKerning(sfPtr, cast(uint)first, cast(uint)second, characterSize);	
	}
	
	int getLineSpacing (uint characterSize) const
	{
		return sfFont_getLineSpacing(sfPtr, characterSize);	
	}
	
	const(Texture) getTexture (uint characterSize) const
	{
		//ToDo: cache texture somehow?
		//Possible: cache last size used using sound method(mutable instance storage


		return new Texture(sfFont_getTexture(sfPtr, characterSize));

	}








}


package extern(C):
struct sfFont;

//Create a new font from a file
sfFont* sfFont_createFromFile(const char* filename);


//Create a new image font a file in memory
sfFont* sfFont_createFromMemory(const void* data, size_t sizeInBytes);


//Create a new image font a custom stream
sfFont* sfFont_createFromStream(void* stream);


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


//Get the texture containing the glyphs of a given size in a font
sfTexture* sfFont_getTexture(const(sfFont)* font, uint characterSize);
