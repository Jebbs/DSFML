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
#include <SFML/Audio/SoundStream.h>
#include <SFML/Audio/SoundSource.hpp>
#include <SFML/Audio/ALCheck.hpp>
#include <SFML/Audio/AudioDevice.hpp>
#include <SFML/System/Time.hpp>

DUint sfSoundStream_getFormatFromChannelCount(DUint channelCount)
{
    return sf::priv::AudioDevice::getFormatFromChannelCount(channelCount);
}

void sfSoundStream_alSourcePlay(DUint sourceID)
{
    alCheck(alSourcePlay(sourceID));
}

void sfSoundStream_alSourcePause(DUint sourceID)
{
    alCheck(alSourcePause(sourceID));
}

void sfSoundStream_alSourceStop(DUint sourceID)
{
    alCheck(alSourceStop(sourceID));
}

void sfSoundStream_alGenBuffers(DInt bufferCount, DUint* buffers)
{
    alCheck(alGenBuffers(bufferCount, buffers));
}


void sfSoundStream_deleteBuffers(DUint sourceID, DInt bufferCount, DUint* buffers)
{
    alCheck(alSourcei(sourceID, AL_BUFFER, 0));
    alCheck(alDeleteBuffers(bufferCount, buffers));
}

DLong sfSoundStream_getPlayingOffset(DUint sourceID,DLong samplesProcessed,  DUint theSampleRate, DUint theChannelCount)
{
    ALfloat secs = 0.f;
    alCheck(alGetSourcef(sourceID, AL_SEC_OFFSET, &secs));

    return sf::seconds(secs + static_cast<float>(samplesProcessed) / theSampleRate / theChannelCount).asMicroseconds();
}


void sfSoundStream_clearQueue(DUint sourceID)
{

    // Get the number of buffers still in the queue
    ALint nbQueued;
    alCheck(alGetSourcei(sourceID, AL_BUFFERS_QUEUED, &nbQueued));

    // Unqueue them all
    ALuint buffer;
    for (ALint i = 0; i < nbQueued; ++i)
    {
        alCheck(alSourceUnqueueBuffers(sourceID, 1, &buffer));
    }

}

DInt sfSoundStream_getNumberOfBuffersProccessed(DUint sourceID)
{
    ALint nbProcessed = 0;
    alCheck(alGetSourcei(sourceID, AL_BUFFERS_PROCESSED, &nbProcessed));
    return nbProcessed;
}

DUint sfSoundStream_UnqueueBuffer(DUint sourceID)
{
    ALuint buffer;
    alCheck(alSourceUnqueueBuffers(sourceID, 1, &buffer));
    return buffer;
}

DInt sfSoundStream_getBufferSampleSize(DUint bufferID)
{
    ALint size, bits;
    alCheck(alGetBufferi(bufferID, AL_SIZE, &size));
    alCheck(alGetBufferi(bufferID, AL_BITS, &bits));
    return size / (bits / 8);
}

void sfSoundStream_fillBuffer(DUint bufferID, const DShort* samples, DLong sampleCount, DUint soundFormat, DUint sampleRate)
{

    ALsizei size = static_cast<ALsizei>(sampleCount) * sizeof(DShort);
    alCheck(alBufferData(bufferID, soundFormat, samples, size, sampleRate));
}

void sfSoundStream_queueBuffer(DUint sourceID, DUint* bufferID)
{
     alCheck(alSourceQueueBuffers(sourceID, 1, bufferID));
}


