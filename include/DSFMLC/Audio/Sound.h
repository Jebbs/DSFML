/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) <2018> <Jeremy DeHaan>

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
Copyright (C) 2007-2018 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML - For a full list see http://www.sfml-dev.org/license.php
*/

#ifndef DSFML_SOUND_H
#define DSFML_SOUND_H

//Header
#include <DSFMLC/Audio/Export.h>
#include <DSFMLC/Audio/Types.h>


DSFML_AUDIO_API sfSound* sfSound_construct(void);

DSFML_AUDIO_API sfSound* sfSound_copy(const sfSound* sound);

DSFML_AUDIO_API void sfSound_destroy(sfSound* sound);

DSFML_AUDIO_API void sfSound_play(sfSound* sound);

DSFML_AUDIO_API void sfSound_pause(sfSound* sound);

DSFML_AUDIO_API void sfSound_stop(sfSound* sound);

DSFML_AUDIO_API void sfSound_setBuffer(sfSound* sound, const sfSoundBuffer* buffer);

//DSFML_AUDIO_API sfSoundBuffer* sfSound_getBuffer(const sfSound* sound);

DSFML_AUDIO_API void sfSound_setLoop(sfSound* sound, DBool loop);

DSFML_AUDIO_API DBool sfSound_getLoop(const sfSound* sound);

DSFML_AUDIO_API int sfSound_getStatus(const sfSound* sound);

DSFML_AUDIO_API void sfSound_setPitch(sfSound* sound, float pitch);

DSFML_AUDIO_API void sfSound_setVolume(sfSound* sound, float volume);

DSFML_AUDIO_API void sfSound_setPosition(sfSound* sound, float positionX, float positionY, float positionZ);

DSFML_AUDIO_API void sfSound_setRelativeToListener(sfSound* sound, DBool relative);

DSFML_AUDIO_API void sfSound_setMinDistance(sfSound* sound, float distance);

DSFML_AUDIO_API void sfSound_setAttenuation(sfSound* sound, float attenuation);

DSFML_AUDIO_API void sfSound_setPlayingOffset(sfSound* sound, DLong timeOffset);

DSFML_AUDIO_API float sfSound_getPitch(const sfSound* sound);

DSFML_AUDIO_API float sfSound_getVolume(const sfSound* sound);

DSFML_AUDIO_API void sfSound_getPosition(const sfSound* sound, float* positionX, float* positionY, float* positionZ);

DSFML_AUDIO_API DBool sfSound_isRelativeToListener(const sfSound* sound);

DSFML_AUDIO_API float sfSound_getMinDistance(const sfSound* sound);

DSFML_AUDIO_API float sfSound_getAttenuation(const sfSound* sound);

DSFML_AUDIO_API DLong sfSound_getPlayingOffset(const sfSound* sound);

#endif // DSFML_SOUND_H
