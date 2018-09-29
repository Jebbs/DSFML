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

#ifndef DSFML_TRANSFORM_H
#define DSFML_TRANSFORM_H

#include <DSFMLC/Graphics/Export.h>
#include <DSFMLC/Graphics/Types.h>

//Return the inverse of a transform
DSFML_GRAPHICS_API void sfTransform_getInverse(const float* transform, float* inverse);

//Apply a transform to a 2D point
DSFML_GRAPHICS_API void sfTransform_transformPoint(const float* transform, float xIn, float yIn, float* xOut, float* yOut);

//Apply a transform to a rectangle
DSFML_GRAPHICS_API void sfTransform_transformRect(const float* transform, float leftIn, float topIn, float widthIn, float heightIn, float* leftOut, float* topOut, float* widthOut, float* heightOut);

//Combine two transforms
DSFML_GRAPHICS_API void sfTransform_combine(float* transform, const float* other);

//Combine a transform with a translation
DSFML_GRAPHICS_API void sfTransform_translate(float* transform, float x, float y);

//Combine the current transform with a rotation
DSFML_GRAPHICS_API void sfTransform_rotate(float* transform, float angle);

//Combine the current transform with a rotation
DSFML_GRAPHICS_API void sfTransform_rotateWithCenter(float* transform, float angle, float centerX, float centerY);

//Combine the current transform with a scaling
DSFML_GRAPHICS_API void sfTransform_scale(float* transform, float scaleX, float scaleY);

//Combine the current transform with a scaling
DSFML_GRAPHICS_API void sfTransform_scaleWithCenter(float* transform, float scaleX, float scaleY, float centerX, float centerY);


#endif // SFML_TRANSFORM_H
