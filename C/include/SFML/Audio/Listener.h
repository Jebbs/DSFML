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

#ifndef DSFML_AUDIO_LISTENER_H
#define DSFML_AUDIO_LISTENER_H

//Headers
#include <SFML/Audio/Export.h>

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


#endif // DSFML_AUDIO_LISTENER_H
