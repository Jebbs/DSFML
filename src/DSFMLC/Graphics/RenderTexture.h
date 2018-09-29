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

#ifndef SFML_RENDERTEXTURE_H
#define SFML_RENDERTEXTURE_H

#include <DSFMLC/Graphics/Export.h>
#include <DSFMLC/Graphics/Types.h>

//Construct a new render texture
DSFML_GRAPHICS_API sfRenderTexture* sfRenderTexture_construct(void);

// Construct a new render texture
DSFML_GRAPHICS_API DBool sfRenderTexture_create(sfRenderTexture* renderTexture, DUint width, DUint height, DBool depthBuffer);

// Destroy an existing render texture
DSFML_GRAPHICS_API void sfRenderTexture_destroy(sfRenderTexture* renderTexture);

// Get the size of the rendering region of a render texture
DSFML_GRAPHICS_API void sfRenderTexture_getSize(const sfRenderTexture* renderTexture, DUint* x, DUint* y);

// Activate or deactivate a render texture as the current target for rendering
DSFML_GRAPHICS_API DBool sfRenderTexture_setActive(sfRenderTexture* renderTexture, DBool active);

//  Update the contents of the target texture
DSFML_GRAPHICS_API void sfRenderTexture_display(sfRenderTexture* renderTexture);

//  Clear the rendertexture with the given color
DSFML_GRAPHICS_API void sfRenderTexture_clear(sfRenderTexture* renderTexture, DUbyte r, DUbyte g, DUbyte b, DUbyte a);

//  Change the current active view of a render texture
DSFML_GRAPHICS_API void sfRenderTexture_setView(sfRenderTexture* renderTexture, float centerX, float centerY, float sizeX,
												float sizeY, float rotation, float viewportLeft, float viewportTop, float viewportWidth,
												float viewportHeight);

//  Get the current active view of a render texture
DSFML_GRAPHICS_API void sfRenderTexture_getView(const sfRenderTexture* renderTexture, float* centerX, float* centerY, float* sizeX,
												float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
												float* viewportHeight);

//  Get the default view of a render texture
DSFML_GRAPHICS_API void sfRenderTexture_getDefaultView(const sfRenderTexture* renderTexture, float* centerX, float* centerY, float* sizeX,
														float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
														float* viewportHeight);

//  Draw primitives defined by an array of vertices to a render texture
DSFML_GRAPHICS_API void sfRenderTexture_drawPrimitives(sfRenderTexture* renderTexture,
                                                       const void* vertices, DUint vertexCount,
                                                       DInt type, DInt colorSrcFactor, DInt colorDstFactor,
														DInt colorEquation, DInt alphaSrcFactor, DInt alphaDstFactor,
														DInt alphaEquation,const float* transform, const sfTexture* texture, const sfShader* shader);

//  Save the current OpenGL render states and matrices
DSFML_GRAPHICS_API void sfRenderTexture_pushGLStates(sfRenderTexture* renderTexture);

//  Restore the previously saved OpenGL render states and matrices
DSFML_GRAPHICS_API void sfRenderTexture_popGLStates(sfRenderTexture* renderTexture);

//  Reset the internal OpenGL states so that the target is ready for drawing
DSFML_GRAPHICS_API void sfRenderTexture_resetGLStates(sfRenderTexture* renderTexture);

//  Get the target texture of a render texture
DSFML_GRAPHICS_API sfTexture* sfRenderTexture_getTexture(const sfRenderTexture* renderTexture);

//  Enable or disable the smooth filter on a render texture
DSFML_GRAPHICS_API void sfRenderTexture_setSmooth(sfRenderTexture* renderTexture, DBool smooth);

//  Tell whether the smooth filter is enabled or not for a render texture
DSFML_GRAPHICS_API DBool sfRenderTexture_isSmooth(const sfRenderTexture* renderTexture);

#endif // SFML_RENDERTEXTURE_H
