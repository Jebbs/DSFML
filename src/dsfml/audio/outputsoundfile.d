/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

module dsfml.audio.outputsoundfile;

import std.string;
import dsfml.system.err;

/**
 *Provide write access to sound files.
 *
 *This class encodes audio samples to a sound file.
 *
 *It is used internally by higher-level classes such as sf::SoundBuffer, but can also be useful if you want to create audio files from
 *custom data sources, like generated audio samples.
 */
struct OutputSoundFile
{
	private sfOutputSoundFile* m_soundFile;

	void create()
	{
		m_soundFile = sfOutputSoundFile_create();
	}

	~this()
	{
		sfOutputSoundFile_destroy(m_soundFile);
	}

	bool openFromFile(const(char)[] filename,uint channelCount,uint sampleRate)
	{
		import dsfml.system.string;
		bool toReturn = sfOutputSoundFile_openFromFile(m_soundFile, filename.ptr, filename.length,channelCount,sampleRate);
		err.write(toString(sfErr_getOutput()));
		return toReturn;
	}

	void write(const(short)[] data)
	{
		sfOutputSoundFile_write(m_soundFile, data.ptr, data.length);
	}

}

extern(C) const(char)* sfErr_getOutput();


private extern(C)
{

struct sfOutputSoundFile;

sfOutputSoundFile* sfOutputSoundFile_create();

void sfOutputSoundFile_destroy(sfOutputSoundFile* file);

bool sfOutputSoundFile_openFromFile(sfOutputSoundFile* file, const(char)* filename, size_t length, uint channelCount,uint sampleRate);

void sfOutputSoundFile_write(sfOutputSoundFile* file, const short* data, long sampleCount);

}
