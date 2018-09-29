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

#ifndef DSFML_TEXTURE_H
#define DSFML_TEXTURE_H

#include <DSFMLC/Graphics/Export.h>
#include <DSFMLC/Graphics/Types.h>
#include <DSFMLC/Window/Types.h>
#include <stddef.h>
#include <DSFMLC/System/DStream.hpp>

//Construct a new texture
DSFML_GRAPHICS_API sfTexture* sfTexture_construct(void);

//Create a new texture
DSFML_GRAPHICS_API DBool sfTexture_create(sfTexture* texture, DUint width, DUint height);

//Create a new texture from a file
DSFML_GRAPHICS_API DBool sfTexture_loadFromFile(sfTexture* texture, const char* filename, size_t filenameLength, DInt left, DInt top, DInt width, DInt height);

//Create a new texture from a file in memory
DSFML_GRAPHICS_API DBool sfTexture_loadFromMemory(sfTexture* texture, const void* data, size_t sizeInBytes, DInt left, DInt top, DInt width, DInt height);

//Create a new texture from a custom stream
DSFML_GRAPHICS_API DBool sfTexture_loadFromStream(sfTexture* texture, DStream* stream, DInt left, DInt top, DInt width, DInt height);

//Create a new texture from an image
DSFML_GRAPHICS_API DBool sfTexture_loadFromImage(sfTexture* texture, const sfImage* image, DInt left, DInt top, DInt width, DInt height);

//Copy an existing texture
DSFML_GRAPHICS_API sfTexture* sfTexture_copy(const sfTexture* texture);

//Destroy an existing texture
DSFML_GRAPHICS_API void sfTexture_destroy(sfTexture* texture);

//Return the size of the texture
DSFML_GRAPHICS_API void sfTexture_getSize(const sfTexture* texture, DUint* x, DUint* y);

//Copy a texture's pixels to an image
DSFML_GRAPHICS_API sfImage* sfTexture_copyToImage(const sfTexture* texture);

//Update a texture from an array of pixels
DSFML_GRAPHICS_API void sfTexture_updateFromPixels(sfTexture* texture, const DUbyte* pixels, DUint width, DUint height, DUint x, DUint y);

//Update a texture from an image
DSFML_GRAPHICS_API void sfTexture_updateFromImage(sfTexture* texture, const sfImage* image, DUint x, DUint y);

//Update a texture from the contents of a window
DSFML_GRAPHICS_API void sfTexture_updateFromWindow(sfTexture* texture, const void* window, DUint x, DUint y);

//Update a texture from the contents of a render-window
DSFML_GRAPHICS_API void sfTexture_updateFromRenderWindow(sfTexture* texture, const sfRenderWindow* renderWindow, DUint x, DUint y);

//Enable or disable the smooth filter on a texture
DSFML_GRAPHICS_API void sfTexture_setSmooth(sfTexture* texture, DBool smooth);

//Tell whether the smooth filter is enabled or not for a texture
DSFML_GRAPHICS_API DBool sfTexture_isSmooth(const sfTexture* texture);

//Enable or disable repeating for a texture
DSFML_GRAPHICS_API void sfTexture_setRepeated(sfTexture* texture, DBool repeated);

//Tell whether a texture is repeated or not
DSFML_GRAPHICS_API DBool sfTexture_isRepeated(const sfTexture* texture);

//Bind a texture for rendering
DSFML_GRAPHICS_API void sfTexture_bind(const sfTexture* texture);

//Get the maximum texture size allowed
DSFML_GRAPHICS_API DUint sfTexture_getMaximumSize();

#endif // SFML_TEXTURE_H
