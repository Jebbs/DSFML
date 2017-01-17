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

#ifndef DSFML_SOUNDRECORDER_H
#define DSFML_SOUNDRECORDER_H

//Headers
#include <DSFMLC/Audio/Export.h>
#include <DSFMLC/Audio/SoundRecorderStruct.h>
#include <stddef.h>

DSFML_AUDIO_API sfSoundRecorder* sfSoundRecorder_construct(SoundRecorderCallBacks* newCallBacks);

DSFML_AUDIO_API void sfSoundRecorder_destroy(sfSoundRecorder* soundRecorder);

DSFML_AUDIO_API void sfSoundRecorder_start(sfSoundRecorder* soundRecorder, DUint sampleRate);

DSFML_AUDIO_API void sfSoundRecorder_stop(sfSoundRecorder* soundRecorder);

DSFML_AUDIO_API DUint sfSoundRecorder_getSampleRate(const sfSoundRecorder* soundRecorder);

DSFML_AUDIO_API DBool sfSoundRecorder_setDevice (sfSoundRecorder* soundRecorder, const char * name, size_t length);

DSFML_AUDIO_API const char * sfSoundRecorder_getDevice(const sfSoundRecorder* soundRecorder);

DSFML_AUDIO_API DBool sfSoundRecorder_isAvailable(void);

DSFML_AUDIO_API const char * sfSoundRecorder_getDefaultDevice (void);

DSFML_AUDIO_API const char ** sfSoundRecorder_getAvailableDevices (size_t* count);

DSFML_AUDIO_API void sfSoundRecorder_setProcessingInterval(sfSoundRecorder* soundRecorder, DUlong time);

#endif // DSFML_SOUNDRECORDER_H
