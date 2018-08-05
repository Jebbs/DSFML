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

#ifndef DSFML_SOUNDSTREAMSTRUCT_H
#define DSFML_SOUNDSTREAMSTRUCT_H

#include <SFML/Audio/SoundStream.hpp>
#include <DSFMLC/Config.h>

struct sfChunk
{
	const DShort* samples;
	DUint sampleCount;
};

typedef struct sfChunk sfChunk;

//class to use in D
class SoundStreamCallBacks
{
public:
	virtual DBool onGetData(sfChunk* chunk);
	virtual void onSeek(DLong time);
};

class sfSoundStreamImp : public sf::SoundStream
{

private:
	SoundStreamCallBacks* callBacks;

public:

	sfSoundStreamImp(SoundStreamCallBacks* newCallBacks)
	{
		callBacks = newCallBacks;

	}

	void SoundStreamInitialize(DUint channelCount, DUint sampleRate)
	{
	    initialize(channelCount, sampleRate);
	}

protected:
	virtual bool onGetData(Chunk& data)
	{
		sfChunk chunk;
		DBool ret = callBacks->onGetData(&chunk);

		data.samples = chunk.samples;
		data.sampleCount = chunk.sampleCount;

		return (ret == DTrue);
	}

	virtual void onSeek(sf::Time timeOffset)
	{
		callBacks->onSeek(timeOffset.asMicroseconds());
	}
};

struct sfSoundStream
{
	sfSoundStream(SoundStreamCallBacks* newCallBacks):
	This(newCallBacks)
	{
	}

	sfSoundStreamImp This;
};

#endif // DSFML_SOUNDSTREAMSTRUCT_H
