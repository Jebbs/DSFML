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

#ifndef DSFML_INPUTSOUNDFILE_H
#define DSFML_INPUTSOUNDFILE_H

//Headers
#include <DSFMLC/Audio/Export.h>
#include <DSFMLC/Audio/Types.h>
#include <DSFMLC/System/DStream.hpp>
#include <stddef.h>

//Creates the sound file
DSFML_AUDIO_API sfInputSoundFile* sfInputSoundFile_create();

//Destroys the sound file
DSFML_AUDIO_API void sfInputSoundFile_destroy(sfInputSoundFile* file);

//Get the sample count of the sound file
DSFML_AUDIO_API DLong sfInputSoundFile_getSampleCount(const sfInputSoundFile* file);

//Get the channel count of the sound file
DSFML_AUDIO_API DUint sfInputSoundFile_getChannelCount( const sfInputSoundFile* file);

//Get the sample rate of the sound file
DSFML_AUDIO_API DUint sfInputSoundFile_getSampleRate(const sfInputSoundFile* file);

//Open a sound file for reading
DSFML_AUDIO_API DBool sfInputSoundFile_openFromFile(sfInputSoundFile* file, const char* filename, size_t length);

//Open a sound file in memory for reading
DSFML_AUDIO_API DBool sfInputSoundFile_openFromMemory(sfInputSoundFile* file,void* data, DLong sizeInBytes);

//Open a sound file from a custom stream for reading
DSFML_AUDIO_API DBool sfInputSoundFile_openFromStream(sfInputSoundFile* file, DStream* stream);

//Read samples from a sound file
DSFML_AUDIO_API DLong sfInputSoundFile_read(sfInputSoundFile* file, DShort* data, DLong sampleCount);

//Change the current read position in the sound file
DSFML_AUDIO_API void sfInputSoundFile_seek(sfInputSoundFile* file, DLong timeOffset);


#endif // DSFML_INPUTSOUNDFILE_H
