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

#include <DSFMLC/Audio/OutputSoundFile.h>
#include "OutputSoundFileStruct.h"

sfOutputSoundFile* sfOutputSoundFile_create()
{
	return new sfOutputSoundFile;
}

void sfOutputSoundFile_destroy(sfOutputSoundFile* file)
{
    delete file;
}

DBool sfOutputSoundFile_openFromFile(sfOutputSoundFile* file, const char* filename, size_t length, DUint channelCount, DUint sampleRate)
{
    bool toReturn = file->This.openFromFile(std::string(filename, length), channelCount, sampleRate);

    return toReturn?DTrue:DFalse;
}

void sfOutputSoundFile_write(sfOutputSoundFile* file, const DShort* data, DLong sampleCount)
{
    file->This.write(data,(size_t)sampleCount);
}
