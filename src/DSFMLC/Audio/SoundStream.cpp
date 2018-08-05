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

#include <DSFMLC/Audio/SoundStream.h>
#include <SFML/Audio/SoundSource.hpp>
#include <SFML/System/Time.hpp>
#include <SFML/System/Vector3.hpp>

sfSoundStream* sfSoundStream_construct(SoundStreamCallBacks* callBacks)
{
    return new sfSoundStream(callBacks);
}

void sfSoundStream_destroy(sfSoundStream* soundStream)
{
    delete soundStream;
}

void sfSoundStream_initialize(sfSoundStream* soundStream, DUint channelCount, DUint sampleRate)
{
    soundStream->This.SoundStreamInitialize(channelCount, sampleRate);
}

void sfSoundStream_play(sfSoundStream* soundStream)
{
    soundStream->This.play();
}

void sfSoundStream_pause(sfSoundStream* soundStream)
{
    soundStream->This.pause();
}

void sfSoundStream_stop(sfSoundStream* soundStream)
{
    soundStream->This.stop();
}

DInt sfSoundStream_getStatus(const sfSoundStream* soundStream)
{
    return static_cast<DInt>(soundStream->This.getStatus());
}

DUint sfSoundStream_getChannelCount(const sfSoundStream* soundStream)
{
    return soundStream->This.getChannelCount();
}

DUint sfSoundStream_getSampleRate(const sfSoundStream* soundStream)
{
    return soundStream->This.getSampleRate();
}

void sfSoundStream_setPitch(sfSoundStream* soundStream, float pitch)
{
    soundStream->This.setPitch(pitch);
}

void sfSoundStream_setVolume(sfSoundStream* soundStream, float volume)
{
    soundStream->This.setVolume(volume);
}

void sfSoundStream_setPosition(sfSoundStream* soundStream, float positionX, float positionY, float positionZ)
{
    soundStream->This.setPosition(sf::Vector3f(positionX, positionY, positionZ));
}

void sfSoundStream_setRelativeToListener(sfSoundStream* soundStream, DBool relative)
{
    (relative == DTrue)? soundStream->This.setRelativeToListener(true) : soundStream->This.setRelativeToListener(false);
}

void sfSoundStream_setMinDistance(sfSoundStream* soundStream, float distance)
{
    soundStream->This.setMinDistance(distance);
}

void sfSoundStream_setAttenuation(sfSoundStream* soundStream, float attenuation)
{
    soundStream->This.setAttenuation(attenuation);
}

void sfSoundStream_setPlayingOffset(sfSoundStream* soundStream, DLong timeOffset)
{
    soundStream->This.setPlayingOffset(sf::microseconds(timeOffset));
}

void sfSoundStream_setLoop(sfSoundStream* soundStream, DBool loop)
{
    (loop == DTrue)? soundStream->This.setLoop(true): soundStream->This.setLoop(false);
}

float sfSoundStream_getPitch(const sfSoundStream* soundStream)
{
    return soundStream->This.getPitch();
}

float sfSoundStream_getVolume(const sfSoundStream* soundStream)
{
    return soundStream->This.getVolume();
}

void sfSoundStream_getPosition(const sfSoundStream* soundStream, float* positionX, float* positionY, float* positionZ)
{
    sf::Vector3f position = soundStream->This.getPosition();

    *positionX = position.x;
    *positionY = position.y;
    *positionZ = position.z;
}

DBool sfSoundStream_isRelativeToListener(const sfSoundStream* soundStream)
{
    return (soundStream->This.isRelativeToListener())? DTrue: DFalse;
}

float sfSoundStream_getMinDistance(const sfSoundStream* soundStream)
{
    return soundStream->This.getMinDistance();
}

float sfSoundStream_getAttenuation(const sfSoundStream* soundStream)
{
    return soundStream->This.getAttenuation();
}

DBool sfSoundStream_getLoop(const sfSoundStream* soundStream)
{
    return (soundStream->This.getLoop())? DTrue: DFalse;
}

DLong sfSoundStream_getPlayingOffset(const sfSoundStream* soundStream)
{
    return soundStream->This.getPlayingOffset().asMicroseconds();
}
