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

#ifndef DSFML_TEXT_H
#define DSFML_TEXT_H

#include <DSFMLC/Graphics/Export.h>
#include <DSFMLC/Graphics/Types.h>
#include <DSFMLC/Graphics/Transform.h>
#include <stddef.h>

/// sfText styles
typedef enum
{
    sfTextRegular    = 0,      ///< Regular characters, no style
    sfTextBold       = 1 << 0, ///< Characters are bold
    sfTextItalic     = 1 << 1, ///< Characters are in italic
    sfTextUnderlined = 1 << 2  ///< Characters are underlined
} sfTextStyle;


//Create a new text
DSFML_GRAPHICS_API sfText* sfText_construct(void);

//Copy an existing text
DSFML_GRAPHICS_API sfText* sfText_copy(const sfText* text);

//Destroy an existing text
DSFML_GRAPHICS_API void sfText_destroy(sfText* text);

//Set the position of a text
DSFML_GRAPHICS_API void sfText_setPosition(sfText* text, float positionX, float positionY);

//Set the orientation of a text
DSFML_GRAPHICS_API void sfText_setRotation(sfText* text, float angle);

//Set the scale factors of a text
DSFML_GRAPHICS_API void sfText_setScale(sfText* text, float scaleX, float scaleY);

//Set the local origin of a text
DSFML_GRAPHICS_API void sfText_setOrigin(sfText* text, float originX, float originY);

//Get the position of a text
DSFML_GRAPHICS_API void sfText_getPosition(const sfText* text, float* positionX, float* positionY);

//Get the orientation of a text
DSFML_GRAPHICS_API float sfText_getRotation(const sfText* text);

//Get the current scale of a text
DSFML_GRAPHICS_API void sfText_getScale(const sfText* text, float* scaleX, float* scaleY);

//Get the local origin of a text
DSFML_GRAPHICS_API void sfText_getOrigin(const sfText* text, float* originX, float* originY);

//Move a text by a given offset
DSFML_GRAPHICS_API void sfText_move(sfText* text, float offsetX, float offsetY);

//Rotate a text
DSFML_GRAPHICS_API void sfText_rotate(sfText* text, float angle);

//Scale a text
DSFML_GRAPHICS_API void sfText_scale(sfText* text, float factorX, float factorY);

//Get the combined transform of a text
DSFML_GRAPHICS_API void sfText_getTransform(const sfText* text, float* transform);

//Get the inverse of the combined transform of a text
DSFML_GRAPHICS_API void sfText_getInverseTransform(const sfText* text, float* transform);

//Set the string of a text (from an ANSI string)
DSFML_GRAPHICS_API void sfText_setString(sfText* text, const char* string);

//Set the string of a text (from a unicode string)
DSFML_GRAPHICS_API void sfText_setUnicodeString(sfText* text, const DUint* string);

//Set the font of a text
DSFML_GRAPHICS_API void sfText_setFont(sfText* text, const sfFont* font);

//Set the character size of a text
DSFML_GRAPHICS_API void sfText_setCharacterSize(sfText* text, DUint size);

//Set the style of a text
DSFML_GRAPHICS_API void sfText_setStyle(sfText* text, DUint style);

//Set the global color of a text
DSFML_GRAPHICS_API void sfText_setColor(sfText* text, DUbyte r, DUbyte g, DUbyte b, DUbyte a);

//Get the string of a text (returns an ANSI string)
DSFML_GRAPHICS_API const char* sfText_getString(const sfText* text);

//Get the string of a text (returns a unicode string)
DSFML_GRAPHICS_API const DUint* sfText_getUnicodeString(const sfText* text);

//Get the font used by a text
DSFML_GRAPHICS_API sfFont* sfText_getFont(const sfText* text);

//Get the size of the characters of a text
DSFML_GRAPHICS_API DUint sfText_getCharacterSize(const sfText* text);

//Get the style of a text
DSFML_GRAPHICS_API DUint sfText_getStyle(const sfText* text);

//Get the global color of a text
DSFML_GRAPHICS_API void sfText_getColor(const sfText* text, DUbyte* r, DUbyte* g, DUbyte* b, DUbyte* a);

//Return the position of the \a index-th character in a text
DSFML_GRAPHICS_API void sfText_findCharacterPos(const sfText* text, size_t index, float* posX, float* posY);

//Get the local bounding rectangle of a text
DSFML_GRAPHICS_API void sfText_getLocalBounds(const sfText* text, float* left, float* top, float* width, float* height);

//Get the global bounding rectangle of a text
DSFML_GRAPHICS_API void sfText_getGlobalBounds(const sfText* text, float* left, float* top, float* width, float* height);

//Get the array of vertices this Text uses for drawing
DSFML_GRAPHICS_API const void* sfText_getVertexArray(const sfText* text);

//Get the number of vertices this Text uses for drawing
DSFML_GRAPHICS_API DUint sfText_getVertexCount(const sfText* text);

//Get the PrimitiveType this Text uses for drawing
DSFML_GRAPHICS_API DInt sfText_getPrimitiveType(const sfText* text);

#endif // SFML_TEXT_H
