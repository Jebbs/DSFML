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

#ifndef DSFML_SOUNDSTREAM_H
#define DSFML_SOUNDSTREAM_H

//Headers
#include <SFML/Audio/Export.h>

//Get the format of the stream from the channel count
DSFML_AUDIO_API DUint sfSoundStream_getFormatFromChannelCount(DUint channelCount);

//start playing the sound data
DSFML_AUDIO_API void sfSoundStream_alSourcePlay(DUint sourceID);

//pause the sound data
DSFML_AUDIO_API void sfSoundStream_alSourcePause(DUint sourceID);

//stoop playing the sound data
DSFML_AUDIO_API void sfSoundStream_alSourceStop(DUint sourceID);

//Generate buffers for holding sound data
DSFML_AUDIO_API void sfSoundStream_alGenBuffers(DInt bufferCount, DUint* buffers);

//Delete the buffers
DSFML_AUDIO_API void sfSoundStream_deleteBuffers(DUint sourceID, DInt bufferCount, DUint* buffers);

//get the playing offset
DSFML_AUDIO_API DLong sfSoundStream_getPlayingOffset(DUint sourceID, DLong samplesProcessed, DUint theSampleRate, DUint theChannelCount);

//Clear the queue
DSFML_AUDIO_API void sfSoundStream_clearQueue(DUint sourceID);

//Get the number of buffers that have been processed
DSFML_AUDIO_API DInt sfSoundStream_getNumberOfBuffersProccessed(DUint sourceID);

//Unqueue buffers for playing
DSFML_AUDIO_API DUint sfSoundStream_UnqueueBuffer(DUint sourceID);

//get the size of a particular buffer
DSFML_AUDIO_API DInt sfSoundStream_getBufferSampleSize(DUint bufferID);

//Fill a buffer with data
DSFML_AUDIO_API void sfSoundStream_fillBuffer(DUint bufferID, const DShort* samples, DLong sampleCount, DUint soundFormat, DUint sampleRate);

//Put a buffer in the playing queue
DSFML_AUDIO_API void sfSoundStream_queueBuffer(DUint sourceID, DUint* bufferID);


#endif // DSFML_SOUNDSTREAM_H
