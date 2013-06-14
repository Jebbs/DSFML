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
#include <SFML/Audio/SoundRecorder.h>
#include <SFML/Audio/SoundRecorderStruct.h>
#include <SFML/Audio/InternalSoundRecorder.hpp>


sfSoundRecorder* sfSoundRecorder_create()
{
    return new sfSoundRecorder();
}

void sfSoundRecorder_destroy(sfSoundRecorder* recorder)
{
    delete recorder;
}

DBool sfSoundRecorder_initialize(sfSoundRecorder* recorder,DUint sampleRate)
{
    return recorder->This.initialize(sampleRate);
}

void sfSoundRecorder_startCapture(sfSoundRecorder* recorder)
{
    recorder->This.startCapture();
}

DInt sfSoundRecorder_getNumAvailableSamples(sfSoundRecorder* recorder)
{
    recorder->This.getSampleNumber();
}

DShort* sfSoundRecorder_getSamplePointer(sfSoundRecorder* recorder, DInt numSamples)
{
    recorder->This.getSamplePointer(numSamples);
}

void sfSoundRecorder_stopCapture(sfSoundRecorder* recorder)
{
    recorder->This.stopCapture();
}

void sfSoundRecorder_closeDevice(sfSoundRecorder* recorder)
{
    recorder->This.closeDevice();
}

DBool sfSoundRecorder_isAvailable()
{
    return InternalSoundRecorder::isAvailable();
}
