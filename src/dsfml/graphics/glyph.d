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
 * A glyph is the visual representation of a character.
 *
 * The $(U Glyph) structure provides the information needed to handle the glyph:
 * $(UL
 * $(LI its coordinates in the font's texture)
 * $(LI its bounding rectangle)
 * $(LI the offset to apply to get the starting position of the next glyph))
 *
 * See_Also:
 * $(FONT_LINK)
 */
module dsfml.graphics.glyph;

public import dsfml.graphics.rect;

/**
 * Structure describing a glyph.
 */
struct Glyph
{
    /// Offset to move horizontally to the next character.
    float advance;
    /// Bounding rectangle of the glyph, in coordinates relative to the baseline.
    FloatRect bounds;
    /// Texture coordinates of the glyph inside the font's texture.
    IntRect textureRect;
}
