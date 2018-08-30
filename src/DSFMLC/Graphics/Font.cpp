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

#include <DSFMLC/Graphics/Font.h>
#include <DSFMLC/Graphics/FontStruct.h>
#include <SFML/System/InputStream.hpp>

sfFont* sfFont_construct()
{
    sfFont* font = new sfFont;
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
    delete font;
}

void sfFont_getGlyph(const sfFont* font, DUint codePoint, DInt characterSize, DBool bold, float outlineThickness, float* glyphAdvance, float* glyphBoundsLeft, float* glyphBoundsTop, float* glyphBoundsWidth, float* glyphBoundsHeight, DInt* glyphTextRectLeft, DInt* glyphTextRectTop, DInt* glyphTextRectWidth, DInt* glyphTextRectHeight)
{
    sf::Glyph SFMLGlyph = font->This.getGlyph(codePoint, characterSize, bold == DTrue, outlineThickness);

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

sfTexture* sfFont_getTexture(const sfFont* font, DUint characterSize)
{
    //This is safe because the D Texture that uses this is only exposed as const 
    return new sfTexture(const_cast<sf::Texture*>(&(font->This.getTexture(characterSize))));
}
