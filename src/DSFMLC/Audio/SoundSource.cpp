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

#include <DSFMLC/Audio/SoundSource.h>

void sfSoundSource_ensureALInit()
{
    sf::priv::ensureALInit();
}

void sfSoundSource_initialize(DUint* sourceID)
{
    //Note: In debug builds, alCheck will insert priv::alCheckError(__FILE__, __LINE__)
    //to check for errors. Using namespace sf makes sure that we are already in
    //sf so that using namespace priv doesn't give errors.
    using namespace sf;

    alCheck(alGenSources(1, sourceID));
    alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
}

void sfSoundSource_setPitch(DUint sourceID, float pitch)
{
    using namespace sf;
    alCheck(alSourcef(sourceID, AL_PITCH, pitch));
}

void sfSoundSource_setVolume(DUint sourceID, float volume)
{
    using namespace sf;
    alCheck(alSourcef(sourceID, AL_GAIN, volume * 0.01f));
}

void sfSoundSource_setPosition(DUint sourceID, float x, float y, float z)
{
    using namespace sf;
    alCheck(alSource3f(sourceID, AL_POSITION, x, y, z));
}

void sfSoundSource_setRelativeToListener(DUint sourceID,DBool relative)
{
    using namespace sf;
    alCheck(alSourcei(sourceID, AL_SOURCE_RELATIVE, relative));
}

void sfSoundSource_setMinDistance(DUint sourceID, float distance)
{
    using namespace sf;
    alCheck(alSourcef(sourceID, AL_REFERENCE_DISTANCE, distance));
}

void sfSoundSource_setAttenuation(DUint sourceID, float attenuation)
{
    using namespace sf;
    alCheck(alSourcef(sourceID, AL_ROLLOFF_FACTOR, attenuation));
}


float sfSoundSource_getPitch(DUint sourceID)
{
    using namespace sf;
    ALfloat pitch;
    alCheck(alGetSourcef(sourceID, AL_PITCH, &pitch));

    return pitch;
}

float sfSoundSource_getVolume(DUint sourceID)
{
    using namespace sf;
    ALfloat gain;
    alCheck(alGetSourcef(sourceID, AL_GAIN, &gain));

    return gain * 100.f;
}

void sfSoundSource_getPosition(DUint sourceID, float* x, float* y, float* z)
{
    using namespace sf;
    alCheck(alGetSource3f(sourceID, AL_POSITION, x, y, z));
}

DBool sfSoundSource_isRelativeToListener(DUint sourceID)
{
    using namespace sf;
    ALint relative;
    alCheck(alGetSourcei(sourceID, AL_SOURCE_RELATIVE, &relative));

    return relative;
}

float sfSoundSource_getMinDistance(DUint sourceID)
{
    using namespace sf;
    ALfloat distance;
    alCheck(alGetSourcef(sourceID, AL_REFERENCE_DISTANCE, &distance));

    return distance;
}

float sfSoundSource_getAttenuation(DUint sourceID)
{
    using namespace sf;
    ALfloat attenuation;
    alCheck(alGetSourcef(sourceID, AL_ROLLOFF_FACTOR, &attenuation));

    return attenuation;
}

DInt sfSoundSource_getStatus(DUint sourceID)
{
    using namespace sf;
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
    using namespace sf;
     alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
    alCheck(alDeleteSources(1, sourceID));
}
