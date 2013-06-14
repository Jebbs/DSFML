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
#include <SFML/Audio/sfSoundFile.h>
#include <SFML/System/InputStream.hpp>
#include <SFML/Audio/SoundFileStruct.h>
#include <SFML/System/Err.hpp>
#include <SFML/System/Lock.hpp>

sfSoundFile* sfSoundFile_create()
{
return new sfSoundFile;
}

void sfSoundFile_destroy(sfSoundFile* file)
{
    delete file;
}

DLong sfSoundFile_getSampleCount(const sfSoundFile* file)
{
    return file->This.getSampleCount();
}

DUint sfSoundFile_getChannelCount( const sfSoundFile* file)
{
        return file->This.getChannelCount();
}

DUint sfSoundFile_getSampleRate(const sfSoundFile* file)
{
    DUint test = file->This.getSampleRate();
    return test;
}

DBool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename)
{
    if(file->This.openRead(filename))
    {
        return DTrue;
    }
    return DFalse;
}

DBool sfSoundFile_openReadFromMemory(sfSoundFile* file,void* data, DLong sizeInBytes)
{
    file->This.openRead(data,(size_t)sizeInBytes);
}

DBool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream)
{
    sf::InputStream* temp = (sf::InputStream*)stream;

    file->This.openRead(*temp);
}

DBool sfSoundFile_openWrite(sfSoundFile* file, const char* filename,DUint channelCount,DUint sampleRate)
{
    file->This.openWrite(filename,channelCount,sampleRate);
}

DLong sfSoundFile_read(sfSoundFile* file, DShort* data, DLong sampleCount)
{


    return file->This.read(data, (size_t)sampleCount);
}

void sfSoundFile_write(sfSoundFile* file, const DShort* data, DLong sampleCount)
{
    file->This.write(data,(size_t)sampleCount);
}

void sfSoundFile_seek(sfSoundFile* file, DLong timeOffset)
{

    sf::Time temp = sf::microseconds(timeOffset);
    sf::err()<<"Calling seek in SFML" << std::endl;
    file->This.seek(temp);
}
