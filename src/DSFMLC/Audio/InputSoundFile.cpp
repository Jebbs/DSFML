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
#include <DSFMLC/Audio/InputSoundFile.h>
#include <SFML/System/InputStream.hpp>
#include <SFML/System/Lock.hpp>
#include "InputSoundFileStruct.h"

sfInputSoundFile* sfInputSoundFile_create()
{
return new sfInputSoundFile;
}

void sfInputSoundFile_destroy(sfInputSoundFile* file)
{
    delete file;
}

DLong sfInputSoundFile_getSampleCount(const sfInputSoundFile* file)
{
    return file->This.getSampleCount();
}

DUint sfInputSoundFile_getChannelCount( const sfInputSoundFile* file)
{
        return file->This.getChannelCount();
}

DUint sfInputSoundFile_getSampleRate(const sfInputSoundFile* file)
{
    DUint test = file->This.getSampleRate();
    return test;
}

DBool sfInputSoundFile_openFromFile(sfInputSoundFile* file, const char* filename, size_t length)
{
    if(file->This.openFromFile(std::string(filename, length)))
    {
        return DTrue;
    }
    return DFalse;
}

DBool sfInputSoundFile_openFromMemory(sfInputSoundFile* file,void* data, DLong sizeInBytes)
{
    bool toReturn = file->This.openFromMemory(data,(size_t)sizeInBytes);

    return toReturn?DTrue:DFalse;
}

DBool sfInputSoundFile_openFromStream(sfInputSoundFile* file, DStream* stream)
{
    file->stream = sfmlStream(stream);

    bool toReturn = file->This.openFromStream(file->stream);

    return toReturn?DTrue:DFalse;
}

DLong sfInputSoundFile_read(sfInputSoundFile* file, DShort* data, DLong sampleCount)
{
    return file->This.read(data, (size_t)sampleCount);
}

void sfInputSoundFile_seek(sfInputSoundFile* file, DLong timeOffset)
{

    sf::Time temp = sf::microseconds(timeOffset);
    file->This.seek(temp);
}
