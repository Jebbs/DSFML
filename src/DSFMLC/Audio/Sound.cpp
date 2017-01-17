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
#include <DSFMLC/Audio/Sound.h>
#include "SoundStruct.h"
#include <SFML/System/Time.hpp>
#include <SFML/System/Vector3.hpp>
#include <DSFMLC/Config.h>

sfSound* sfSound_construct(void)
{
    return new sfSound;
}

sfSound* sfSound_copy(const sfSound* sound)
{
    return new sfSound(*sound);
}

void sfSound_destroy(sfSound* sound)
{
    delete sound;
}

void sfSound_play(sfSound* sound)
{
    sound->This.play();
}

void sfSound_pause(sfSound* sound)
{
    sound->This.pause();
}

void sfSound_stop(sfSound* sound)
{
    sound->This.stop();
}

void sfSound_setBuffer(sfSound* sound, const sfSoundBuffer* buffer)
{
    sound->This.setBuffer(buffer->This);
    sound->Buffer = buffer;
}

//sfSoundBuffer* sfSound_getBuffer(const sfSound* sound)
//{
//    return const_cast<sfSoundBuffer*>(sound->Buffer);
//}

void sfSound_setLoop(sfSound* sound, DBool loop)
{
    (loop == DTrue)?sound->This.setLoop(true):sound->This.setLoop(false);
}

DBool sfSound_getLoop(const sfSound* sound)
{
    return (sound->This.getLoop())?DTrue:DFalse;
}

int sfSound_getStatus(const sfSound* sound)
{
    return static_cast<int>(sound->This.getStatus());
}

void sfSound_setPitch(sfSound* sound, float pitch)
{
    sound->This.setPitch(pitch);
}

void sfSound_setVolume(sfSound* sound, float volume)
{
    sound->This.setVolume(volume);
}

void sfSound_setPosition(sfSound* sound, float positionX, float positionY, float positionZ)
{
    sound->This.setPosition(sf::Vector3f(positionX, positionY, positionZ));
}

void sfSound_setRelativeToListener(sfSound* sound, DBool relative)
{
    (relative == DTrue)?sound->This.setRelativeToListener(true):sound->This.setRelativeToListener(false);
}

void sfSound_setMinDistance(sfSound* sound, float distance)
{
    sound->This.setMinDistance(distance);
}

void sfSound_setAttenuation(sfSound* sound, float attenuation)
{
    sound->This.setAttenuation(attenuation);
}

void sfSound_setPlayingOffset(sfSound* sound, DLong timeOffset)
{
    sound->This.setPlayingOffset(sf::microseconds(timeOffset));
}

float sfSound_getPitch(const sfSound* sound)
{
    return sound->This.getPitch();
}

float sfSound_getVolume(const sfSound* sound)
{
    return sound->This.getVolume();
}

void sfSound_getPosition(const sfSound* sound, float* positionX, float* positionY, float* positionZ)
{
    sf::Vector3f position = sound->This.getPosition();

    *positionX = position.x;
    *positionY = position.y;
    *positionZ = position.z;
}

DBool sfSound_isRelativeToListener(const sfSound* sound)
{
    return (sound->This.isRelativeToListener())?DTrue:DFalse;
}

float sfSound_getMinDistance(const sfSound* sound)
{
    return sound->This.getMinDistance();
}

float sfSound_getAttenuation(const sfSound* sound)
{
   return sound->This.getAttenuation();
}

DLong sfSound_getPlayingOffset(const sfSound* sound)
{
    sf::Time offset = sound->This.getPlayingOffset();

    return offset.asMicroseconds();
}
