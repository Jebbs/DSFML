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

#include <DSFMLC/Graphics/Transform.h>
#include <SFML/Graphics/Transform.hpp>
#include <DSFMLC/Graphics/CreateTransform.hpp>
#include <cstring>

void sfTransform_getMatrix(const float* transform, float* matrix)
{
    sf::Transform createed = createTransform(transform);
    if (matrix)
        std::memcpy(matrix, createed.getMatrix(), 16 * sizeof(float));
}

void sfTransform_getInverse(const float* transform, float* inverse)
{
    createTransform(createTransform(transform).getInverse(), inverse);
}

void sfTransform_transformPoint(const float* transform, float xIn, float yIn, float* xOut, float* yOut)
{
    sf::Vector2f sfmlPoint = createTransform(transform).transformPoint(xIn, yIn);

    *xOut = sfmlPoint.x;
    *yOut = sfmlPoint.y;
}

void sfTransform_transformRect(const float* transform, float leftIn, float topIn, float widthIn, float heightIn, float* leftOut, float* topOut, float* widthOut, float* heightOut)
{
    sf::FloatRect sfmlRect = createTransform(transform).transformRect(sf::FloatRect(leftIn, topIn, widthIn, heightIn));

    *leftOut = sfmlRect.left;
    *topOut = sfmlRect.top;
    *widthOut = sfmlRect.width;
    *heightOut = sfmlRect.height;
}

void sfTransform_combine(float* transform, const float* other)
{
    createTransform(createTransform(transform).combine(createTransform(other)),transform);
}

void sfTransform_translate(float* transform, float x, float y)
{
    createTransform(createTransform(transform).translate(x, y), transform);
}

void sfTransform_rotate(float* transform, float angle)
{
    createTransform(createTransform(transform).rotate(angle),transform);
}

void sfTransform_rotateWithCenter(float* transform, float angle, float centerX, float centerY)
{
    createTransform(createTransform(transform).rotate(angle, centerX, centerY),transform);
}

void sfTransform_scale(float* transform, float scaleX, float scaleY)
{
    createTransform(createTransform(transform).scale(scaleX, scaleY),transform);
}

void sfTransform_scaleWithCenter(float* transform, float scaleX, float scaleY, float centerX, float centerY)
{
    createTransform(createTransform(transform).scale(scaleX, scaleY, centerX, centerY),transform);
}
