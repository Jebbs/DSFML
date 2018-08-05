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

#include <DSFMLC/Audio/SoundBuffer.h>
#include "SoundBufferStruct.h"

sfSoundBuffer* sfSoundBuffer_construct()
{
    return new sfSoundBuffer;
}

DBool sfSoundBuffer_loadFromFile(sfSoundBuffer* soundBuffer, const char* filename, size_t length)
{
    return (soundBuffer->This.loadFromFile(std::string(filename, length)))?DTrue:DFalse;
}

DBool sfSoundBuffer_loadFromMemory(sfSoundBuffer* soundBuffer, const void* data, size_t sizeInBytes)
{
    return (soundBuffer->This.loadFromMemory(data, sizeInBytes))?DTrue:DFalse;
}

DBool sfSoundBuffer_loadFromStream(sfSoundBuffer* soundBuffer, DStream* stream)
{
    sfmlStream Stream = sfmlStream(stream);
    return (soundBuffer->This.loadFromStream(Stream))?DTrue:DFalse;
}

DBool sfSoundBuffer_loadFromSamples(sfSoundBuffer* soundBuffer, const DShort* samples, size_t sampleCount, DUint channelCount, DUint sampleRate)
{
    return (soundBuffer->This.loadFromSamples(samples, sampleCount, channelCount, sampleRate))?DTrue:DFalse;
}

sfSoundBuffer* sfSoundBuffer_copy(const sfSoundBuffer* soundBuffer)
{
     return new sfSoundBuffer(*soundBuffer);
}

void sfSoundBuffer_destroy(sfSoundBuffer* soundBuffer)
{
    delete soundBuffer;
}

DBool sfSoundBuffer_saveToFile(const sfSoundBuffer* soundBuffer, const char* filename, size_t length)
{
    return (soundBuffer->This.saveToFile(std::string(filename, length)))? DTrue: DFalse;
}

const DShort* sfSoundBuffer_getSamples(const sfSoundBuffer* soundBuffer)
{
    return soundBuffer->This.getSamples();
}

size_t sfSoundBuffer_getSampleCount(const sfSoundBuffer* soundBuffer)
{
    return soundBuffer->This.getSampleCount();
}

DUint sfSoundBuffer_getSampleRate(const sfSoundBuffer* soundBuffer)
{
    return soundBuffer->This.getSampleRate();
}

DUint sfSoundBuffer_getChannelCount(const sfSoundBuffer* soundBuffer)
{
    return soundBuffer->This.getChannelCount();
}

DLong sfSoundBuffer_getDuration(const sfSoundBuffer* soundBuffer)
{
    return soundBuffer->This.getDuration().asMicroseconds();
}
