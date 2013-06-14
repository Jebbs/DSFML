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

#ifndef DSFML_SOUND_H
#define DSFML_SOUND_H

//Header
#include <SFML/Audio/Export.h>


//Assign a buffer to the sound
DSFML_AUDIO_API void sfSound_assignBuffer(DUint sourceID, DUint bufferID);

//Detach any buffer associated to the sound
DSFML_AUDIO_API void sfSound_detachBuffer(DUint sourceID);

//Set if the sound should loop or not
DSFML_AUDIO_API void sfSound_setLoop(DUint sourceID,DBool loop);

//check if the sound is looping or not
DSFML_AUDIO_API DBool sfSound_getLoop(DUint sourceID);

//Set the playing offset for the sound
DSFML_AUDIO_API void sfSound_setPlayingOffset(DUint sourceID, float offset);

//Get the playing offset for the sound
DSFML_AUDIO_API float sfSound_getPlayingOffset(DUint sourceID);

#endif // DSFML_SOUND_H
