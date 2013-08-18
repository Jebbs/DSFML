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

module dsfml.audio.soundfile;

//TODO: Create a structure around this for code cleanliness?


package extern(C):

struct sfSoundFile;

sfSoundFile* sfSoundFile_create();

void sfSoundFile_destroy(sfSoundFile* file);

long sfSoundFile_getSampleCount(const sfSoundFile* file);

uint sfSoundFile_getChannelCount( const sfSoundFile* file);

uint sfSoundFile_getSampleRate(const sfSoundFile* file);

bool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename);

bool sfSoundFile_openReadFromMemory(sfSoundFile* file,const(void)* data, long sizeInBytes);

bool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream);

bool sfSoundFile_openWrite(sfSoundFile* file, const(char)* filename,uint channelCount,uint sampleRate);

long sfSoundFile_read(sfSoundFile* file, short* data, long sampleCount);

void sfSoundFile_write(sfSoundFile* file, const short* data, long sampleCount);

void sfSoundFile_seek(sfSoundFile* file, long timeOffset);
