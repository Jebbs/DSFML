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

#ifndef DSFML_SOUNDFILE_H
#define DSFML_SOUNDFILE_H

//Headers
#include <SFML/Audio/Export.h>
#include <SFML/Audio/Types.h>

//Creates the sound file
DSFML_AUDIO_API sfSoundFile* sfSoundFile_create();

//Destroys the sound file
DSFML_AUDIO_API void sfSoundFile_destroy(sfSoundFile* file);

//Get the sample count of the sound file
DSFML_AUDIO_API DLong sfSoundFile_getSampleCount(const sfSoundFile* file);

//Get the channel count of the sound file
DSFML_AUDIO_API DUint sfSoundFile_getChannelCount( const sfSoundFile* file);

//Get the sample rate of the sound file
DSFML_AUDIO_API DUint sfSoundFile_getSampleRate(const sfSoundFile* file);

//Open a sound file for reading
DSFML_AUDIO_API DBool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename);

//Open a sound file in memory for reading
DSFML_AUDIO_API DBool sfSoundFile_openReadFromMemory(sfSoundFile* file,void* data, DLong sizeInBytes);

//Open a sound file from a custom stream for reading
DSFML_AUDIO_API DBool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream);

//Open a sound file for writting
DSFML_AUDIO_API DBool sfSoundFile_openWrite(sfSoundFile* file, const char* filename,DUint channelCount,DUint sampleRate);

//Read samples from a sound file
DSFML_AUDIO_API DLong sfSoundFile_read(sfSoundFile* file, DShort* data, DLong sampleCount);

//Write samples to a sound file
DSFML_AUDIO_API void sfSoundFile_write(sfSoundFile* file, const DShort* data, DLong sampleCount);

//Change the current read position in the sound file
DSFML_AUDIO_API void sfSoundFile_seek(sfSoundFile* file, DLong timeOffset);


#endif // DSFML_SOUNDFILE_H
