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

#include <DSFMLC/Graphics/Text.h>
#include <DSFMLC/Graphics/TextStruct.h>
#include <DSFMLC/Graphics/Font.h>
#include <SFML/Graphics/Color.hpp>

sfText* sfText_construct(void)
{
    sfText* text = new sfText;
    text->Font = 0;

    return text;
}

sfText* sfText_copy(const sfText* text)
{
    return new sfText(*text);
}

void sfText_destroy(sfText* text)
{
    delete text;
}

void sfText_setPosition(sfText* text, float positionX, float positionY)
{
    text->This.setPosition(positionX, positionY);
}

void sfText_setRotation(sfText* text, float angle)
{
    text->This.setRotation(angle);
}

void sfText_setScale(sfText* text, float scaleX, float scaleY)
{
    text->This.setScale(scaleX, scaleY);
}

void sfText_setOrigin(sfText* text, float originX, float originY)
{
    text->This.setOrigin(originX, originY);
}

void sfText_getPosition(const sfText* text, float* positionX, float* positionY)
{
    sf::Vector2f sfmlPos = text->This.getPosition();
    *positionX = sfmlPos.x;
    *positionY = sfmlPos.y;
}

float sfText_getRotation(const sfText* text)
{
    return text->This.getRotation();
}

void sfText_getScale(const sfText* text, float* scaleX, float* scaleY)
{
    sf::Vector2f sfmlScale = text->This.getScale();
    *scaleX = sfmlScale.x;
    *scaleY = sfmlScale.y;
}

void sfText_getOrigin(const sfText* text, float* originX, float* originY)
{
    sf::Vector2f sfmlOrigin = text->This.getOrigin();
    *originX = sfmlOrigin.x;
    *originY = sfmlOrigin.y;
}

void sfText_move(sfText* text, float offsetX, float offsetY)
{
    text->This.move(offsetX, offsetY);
}

void sfText_rotate(sfText* text, float angle)
{
    text->This.rotate(angle);
}

void sfText_scale(sfText* text, float factorX, float factorY)
{
    text->This.scale(factorX, factorY);
}

void sfText_getTransform(const sfText* text, float* transform)
{
    *reinterpret_cast<sf::Transform*>(transform) = text->This.getTransform();
}

void sfText_getInverseTransform(const sfText* text, float* transform)
{
    *reinterpret_cast<sf::Transform*>(transform) = text->This.getInverseTransform();
}

void sfText_setString(sfText* text, const char* string)
{
    text->This.setString(string);
}

void sfText_setUnicodeString(sfText* text, const DUint* string)
{
    sf::String UTF32Text = string;
    text->This.setString(UTF32Text);
}

void sfText_setFont(sfText* text, const sfFont* font)
{
    text->This.setFont(font->This);
    text->Font = font;
}

void sfText_setCharacterSize(sfText* text, DUint size)
{
    text->This.setCharacterSize(size);
}

void sfText_setStyle(sfText* text, DUint style)
{
    text->This.setStyle(style);
}

void sfText_setColor(sfText* text, DUbyte r, DUbyte g, DUbyte b, DUbyte a)
{
    text->This.setColor(sf::Color(r, g, b, a));
}

sfFont* sfText_getFont(const sfText* text)
{
    return const_cast<sfFont*>(text->Font);
}

DUint sfText_getCharacterSize(const sfText* text)
{
    return text->This.getCharacterSize();
}

DUint sfText_getStyle(const sfText* text)
{
    return text->This.getStyle();
}

void sfText_getColor(const sfText* text, DUbyte* r, DUbyte* g, DUbyte* b, DUbyte* a)
{
    sf::Color sfmlColor = text->This.getColor();
    *r = sfmlColor.r;
    *g = sfmlColor.g;
    *b = sfmlColor.b;
    *a = sfmlColor.a;
}

void sfText_findCharacterPos(const sfText* text, size_t index, float* posX, float* posY)
{
    sf::Vector2f sfmlPos = text->This.findCharacterPos(index);
    *posX = sfmlPos.x;
    *posY = sfmlPos.y;
}

void sfText_getLocalBounds(const sfText* text, float* left, float* top, float* width, float* height)
{
    sf::FloatRect sfmlRect = text->This.getLocalBounds();
    *left = sfmlRect.left;
    *top = sfmlRect.top;
    *width = sfmlRect.width;
    *height = sfmlRect.height;
}

void sfText_getGlobalBounds(const sfText* text, float* left, float* top, float* width, float* height)
{
    sf::FloatRect sfmlRect = text->This.getGlobalBounds();
    *left = sfmlRect.left;
    *top = sfmlRect.top;
    *width = sfmlRect.width;
    *height = sfmlRect.height;
}

const void* sfText_getVertexArray(const sfText* text)
{
    return text->This.getVertexArray();
}

DUint sfText_getVertexCount(const sfText* text)
{
    return static_cast<DUint>(text->This.getVertexCount());
}

DInt sfText_getPrimitiveType(const sfText* text)
{
    return static_cast<DInt>(text->This.getPrimitiveType());
}
