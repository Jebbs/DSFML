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

#ifndef DSFML_SOUNDSOURCE_H
#define DSFML_SOUNDSOURCE_H


#include <DSFMLC/Audio/ALCheck.hpp>
#include <DSFMLC/Audio/Export.h>
#include <SFML/Audio/SoundSource.hpp>



//Define the audio methods used within sf::SoundSource

DSFML_AUDIO_API void sfSoundSource_ensureALInit();

DSFML_AUDIO_API void sfSoundSource_initialize(DUint* sourceID);

DSFML_AUDIO_API void sfSoundSource_setPitch(DUint sourceID, float pitch);

DSFML_AUDIO_API void sfSoundSource_setVolume(DUint sourceID, float volume);

DSFML_AUDIO_API void sfSoundSource_setPosition(DUint sourceID, float x, float y, float z);

DSFML_AUDIO_API void sfSoundSource_setRelativeToListener(DUint sourceID,DBool relative);

DSFML_AUDIO_API void sfSoundSource_setMinDistance(DUint sourceID, float distance);

DSFML_AUDIO_API void sfSoundSource_setAttenuation(DUint sourceID, float attenuation);



DSFML_AUDIO_API float sfSoundSource_getPitch(DUint sourceID);

DSFML_AUDIO_API float sfSoundSource_getVolume(DUint sourceID);

DSFML_AUDIO_API void sfSoundSource_getPosition(DUint sourceID, float* x, float* y, float* z);

DSFML_AUDIO_API DBool sfSoundSource_isRelativeToListener(DUint sourceID);

DSFML_AUDIO_API float sfSoundSource_getMinDistance(DUint sourceID);

DSFML_AUDIO_API float sfSoundSource_getAttenuation(DUint sourceID);

DSFML_AUDIO_API DInt sfSoundSource_getStatus(DUint sourceID);

DSFML_AUDIO_API void sfSoundSource_destroy(DUint* sourceID);

#endif // DSFML_SOUNDSOURCE_H
