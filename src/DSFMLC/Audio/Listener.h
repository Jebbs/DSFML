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

#ifndef DSFML_AUDIO_LISTENER_H
#define DSFML_AUDIO_LISTENER_H

#include <DSFMLC/Audio/Export.h>

//Set the global volume
DSFML_AUDIO_API void sfListener_setGlobalVolume(float volume);

//Get the global volume
DSFML_AUDIO_API float sfListener_getGlobalVolume(void);

//Set the position of the Listener
DSFML_AUDIO_API void sfListener_setPosition(float x, float y, float z);

//Get the position of the Listener
DSFML_AUDIO_API void sfListener_getPosition(float* x, float* y, float* z);

//Set the direction of the Listener
DSFML_AUDIO_API void sfListener_setDirection(float x, float y, float z);

//Get the direction of the Listener
DSFML_AUDIO_API void sfListener_getDirection(float* x, float* y, float* z);

//Set the upward vector of the Listener
DSFML_AUDIO_API void sfListener_setUpVector(float x, float y, float z);

//Get the upward vector of the Listener
DSFML_AUDIO_API void sfListener_getUpVector(float* x, float* y, float* z);

#endif // DSFML_AUDIO_LISTENER_H
