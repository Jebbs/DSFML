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


// Headers
#include <DSFMLC/Graphics/Font.h>
#include <DSFMLC/Graphics/FontStruct.h>
#include <SFML/System/InputStream.hpp>

sfFont* sfFont_construct()
{
    sfFont* font = new sfFont;
    font->fontTexture = new sfTexture;

    //Delete the internal texture and set OwnInstance to false
    //This will allow us to set the sf::Texture vatiable to the address
    //of the one returned by the font without copying it or destroying it.
    delete font->fontTexture->This;
    font->fontTexture->This = 0;
    font->fontTexture->OwnInstance = false;

    return font;
}

DBool sfFont_loadFromFile(sfFont* font, const char* filename, size_t length)
{
    return (font->This.loadFromFile(std::string(filename, length)))?DTrue:DFalse;
}



DBool sfFont_loadFromMemory(sfFont* font, const void* data, size_t sizeInBytes)
{
    return (font->This.loadFromMemory(data, sizeInBytes))?DTrue:DFalse;
}



DBool sfFont_loadFromStream(sfFont* font, DStream* stream)
{
    font->Stream = sfmlStream(stream);
    return (font->This.loadFromStream(font->Stream))?DTrue:DFalse;
}



sfFont* sfFont_copy(const sfFont* font)
{
    return new sfFont(*font);
}



void sfFont_destroy(sfFont* font)
{
    //purposefully do not delete the texture as that is handled by the D Texture class
    delete font;
}



void sfFont_getGlyph(const sfFont* font, DUint codePoint, DInt characterSize, DBool bold, float* glyphAdvance, float* glyphBoundsLeft, float* glyphBoundsTop, float* glyphBoundsWidth, float* glyphBoundsHeight, DInt* glyphTextRectLeft, DInt* glyphTextRectTop, DInt* glyphTextRectWidth, DInt* glyphTextRectHeight)
{

    sf::Glyph SFMLGlyph = font->This.getGlyph(codePoint, characterSize, bold == DTrue);

    *glyphAdvance           = SFMLGlyph.advance;
    *glyphBoundsLeft        = SFMLGlyph.bounds.left;
    *glyphBoundsTop         = SFMLGlyph.bounds.top;
    *glyphBoundsWidth       = SFMLGlyph.bounds.width;
    *glyphBoundsHeight      = SFMLGlyph.bounds.height;
    *glyphTextRectLeft      = SFMLGlyph.textureRect.left;
    *glyphTextRectTop       = SFMLGlyph.textureRect.top;
    *glyphTextRectWidth     = SFMLGlyph.textureRect.width;
    *glyphTextRectHeight    = SFMLGlyph.textureRect.height;


}



float sfFont_getKerning(const sfFont* font, DUint first, DUint second, DUint characterSize)
{
    return font->This.getKerning(first, second, characterSize);
}



float sfFont_getLineSpacing(const sfFont* font, DUint characterSize)
{
    return font->This.getLineSpacing(characterSize);
}


float sfFont_getUnderlinePosition(const sfFont* font, DUint characterSize)
{
    return font->This.getUnderlinePosition(characterSize);
}

float sfFont_getUnderlineThickness(const sfFont* font, DUint characterSize)
{
    return font->This.getUnderlineThickness(characterSize);
}


sfTexture* sfFont_getTexturePtr(const sfFont* font)
{
    return font->fontTexture;
}

void sfFont_updateTexture(const sfFont* font, DUint characterSize)
{

    //Get the address of the underlying sf::Texture to avoid copying it.
    //This is safe because the underlying sf::Texture is only exposed in const form.
    font->fontTexture->This = const_cast<sf::Texture*>(&(font->This.getTexture(characterSize)));

}
