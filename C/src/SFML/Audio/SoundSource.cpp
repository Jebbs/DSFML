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

//Headers
#include <SFML/Audio/SoundSource.h>

void sfSoundSource_ensureALInit()
{
    sf::priv::ensureALInit();
}

void sfSoundSource_initialize(DUint* sourceID)
{
    alCheck(alGenSources(1, sourceID));
    alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
}

void sfSoundSource_setPitch(DUint sourceID, float pitch)
{
    alCheck(alSourcef(sourceID, AL_PITCH, pitch));
}

void sfSoundSource_setVolume(DUint sourceID, float volume)
{
    alCheck(alSourcef(sourceID, AL_GAIN, volume * 0.01f));
}

void sfSoundSource_setPosition(DUint sourceID, float x, float y, float z)
{
    alCheck(alSource3f(sourceID, AL_POSITION, x, y, z));
}

void sfSoundSource_setRelativeToListener(DUint sourceID,DBool relative)
{
    alCheck(alSourcei(sourceID, AL_SOURCE_RELATIVE, relative));
}

void sfSoundSource_setMinDistance(DUint sourceID, float distance)
{
    alCheck(alSourcef(sourceID, AL_REFERENCE_DISTANCE, distance));
}

void sfSoundSource_setAttenuation(DUint sourceID, float attenuation)
{
    alCheck(alSourcef(sourceID, AL_ROLLOFF_FACTOR, attenuation));
}


float sfSoundSource_getPitch(DUint sourceID)
{
    ALfloat pitch;
    alCheck(alGetSourcef(sourceID, AL_PITCH, &pitch));

    return pitch;
}

float sfSoundSource_getVolume(DUint sourceID)
{
    ALfloat gain;
    alCheck(alGetSourcef(sourceID, AL_GAIN, &gain));

    return gain * 100.f;
}

void sfSoundSource_getPosition(DUint sourceID, float* x, float* y, float* z)
{
    alCheck(alGetSource3f(sourceID, AL_POSITION, x, y, z));
}

DBool sfSoundSource_isRelativeToListener(DUint sourceID)
{
    ALint relative;
    alCheck(alGetSourcei(sourceID, AL_SOURCE_RELATIVE, &relative));

    return relative;
}

float sfSoundSource_getMinDistance(DUint sourceID)
{
    ALfloat distance;
    alCheck(alGetSourcef(sourceID, AL_REFERENCE_DISTANCE, &distance));

    return distance;
}

float sfSoundSource_getAttenuation(DUint sourceID)
{
    ALfloat attenuation;
    alCheck(alGetSourcef(sourceID, AL_ROLLOFF_FACTOR, &attenuation));

    return attenuation;
}

DInt sfSoundSource_getStatus(DUint sourceID)
{
    ALint status;
    alCheck(alGetSourcei(sourceID, AL_SOURCE_STATE, &status));

    switch (status)
    {
        case AL_INITIAL :
        case AL_STOPPED : return sf::SoundSource::Stopped;
        case AL_PAUSED :  return sf::SoundSource::Paused;
        case AL_PLAYING : return sf::SoundSource::Playing;
    }

    return sf::SoundSource::Stopped;
}

void sfSoundSource_destroy(DUint* sourceID)
{
     alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
    alCheck(alDeleteSources(1, sourceID));
}
