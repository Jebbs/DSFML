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

module dsfml.audio.soundbuffer;

import dsfml.audio.soundfile;
import dsfml.audio.sound;

import dsfml.system.inputstream;
import dsfml.system.time;

import std.stdio;

import std.string;

import std.algorithm;
import std.array;

import core.memory;

import dsfml.system.err;
import std.conv;

class SoundBuffer
{
	
	
	this()
	{
		//create the buffer
		
		sfSoundSource_ensureALInit();
		err.write(text(sfErrAudio_getOutput()));

		
		//Create the buffer
		sfSoundBuffer_alGenBuffers(&m_buffer);

		//use the existing buffer ID to create a mutable list of sounds attached to it

		m_sounds.add(m_buffer);

		//m_sounds[m_buffer] = new Sound[0];
	}
	
	~this()
	{

		//Detach 
		foreach(Sound sound;m_sounds[m_buffer])
		{
			sound.toString();
			sound.resetBuffer();
		}


		m_sounds.remove(m_buffer);

		
		sfSoundBuffer_alDeleteBuffer(&m_buffer);

	}
	
	//TODO: copy constructor
	
	bool loadFromFile(string filename)
	{
		SoundFile file;
		file.create();
		
		
		if(file.openReadFromFile(filename))
		{
			return initialize(file);
		}
		
		return false;
	}
	
	bool loadFromMemory(const(void)[] data)
	{
		SoundFile file;
		file.create();

		if(file.openReadFromMemory(data))
		{
			return initialize(file);
		}
		return false;
	}
	
	bool loadFromStream(InputStream stream)
	{
		SoundFile file;
		file.create();

		if(file.openReadFromStream(stream))
		{
			return initialize(file);
		}
		
		return false;
	}
	
	bool loadFromSamples(const(short[]) samples, uint channelCount, uint sampleRate)
	{
		if((samples.length >0) && (channelCount>0) && (sampleRate>0))
		{
			//resize m_samples' length to match
			m_samples.length = samples.length;
			//copy new samples
			m_samples[] = samples[];
			//update Internal Buffer
			return update(channelCount, sampleRate);
			
		}
		else
		{
			//Error...
			
			err.write("Failed to load sound buffer from samples (");
			err.write("array: ", samples, ",");
			err.write("");
			err.write("");

			return false;
		}
		
		
	}
	
	
	
	bool saveToFile(string filename)
	{
		SoundFile file;
		file.create();
		
		if(file.openWrite(filename,getChannelCount(),getSampleRate()))
		{
			file.write( m_samples);
			
			return true;
		}
		
		return false;
	}
	
	
	const(short[]) getSamples()
	{
		return m_samples;
		
	}
	
	uint getSampleRate()
	{
		return sfSoundBuffer_getSampleRate(m_buffer);
	}
	
	uint getChannelCount()
	{
		return sfSoundBuffer_getChannelCount(m_buffer);
	}
	
	Time getDuration()
	{
		return m_duration;
	}
	
	package
	{
		void attachSound(Sound sound) const
		{
			//TODO: Check to see if sound already exists in m_sounds
			//Sounds in m_sounds should always be unique
			m_sounds[m_buffer] ~=sound;
		}
		
		void detachSound(Sound sound) const
		{
			m_sounds.removeSound(m_buffer, sound);
		}
		
		uint m_buffer; /// OpenAL buffer identifier
	}

	
	private
	{
		bool initialize(SoundFile file)
		{
			
			
			// Retrieve the sound parameters
			size_t sampleCount = cast(size_t)file.getSampleCount();
			uint channelCount = file.getChannelCount();
			uint sampleRate = file.getSampleRate();
			
			
			// Read the samples from the provided file
			m_samples.length = sampleCount;

			
			if (file.read(m_samples) == sampleCount)
			{
				// Update the internal buffer with the new samples
				return update(channelCount, sampleRate);
			}
			else
			{
				return false;
			}
			
			
		}
		
		//TODO: Get this one set up later
		bool initialize(uint channelCount, uint sampleRate)
		{
			return false;
		}
		
		bool update(uint channelCount, uint sampleRate)
		{
			// Check parameters
			if ((channelCount == 0) || (sampleRate== 0) || (m_samples.length == 0))
			{
				return false;
			}
			
			
			// Find the good format according to the number of channels
			uint format = sfSoundStream_getFormatFromChannelCount(channelCount);
			
			
			// Check if the format is valid
			if (format == 0)
			{
				stderr.writeln("Failed to load sound buffer (unsupported number of channels: " ,channelCount, ")");
				return false;
			}
			
			//Fill the Buffer
			sfSoundBuffer_fillBuffer(m_buffer,&m_samples[0],m_samples.length,sampleRate, format);
			
			//Computer Duration
			m_duration = milliseconds(cast(int)(1000 * m_samples.length / sampleRate / channelCount));
			
			
			return true;
		}
		
		
		
		
		
		
		short[] m_samples; /// Samples buffer
		Time m_duration; /// Sound duration

		//Allows a sound buffer to remain const while still having a mutable list of sounds attached to it.
		private static SoundList m_sounds;

	}

}


///SoundList is a map of sorts that allows an array of sounds to be bound to a particular key.
///Being made of arrays intead of using an associative array allows items to be removed
///during a GC cycle since it is done with slices.
private struct SoundList
{
	uint[] m_keys;
	Sound[][] m_sounds;

	ref Sound[] opIndex(uint key)
	{
		return m_sounds[indexSearch(key)];
	}

	void add(uint key)
	{
		m_keys ~=key;
		m_sounds.length +=1;
	}

	void remove(uint key)
	{
		size_t removeIndex = indexSearch(key);

		m_keys.remove(removeIndex);
		m_sounds.remove(removeIndex);
	}

	void removeSound(uint key, Sound sound)
	{

		size_t index = indexSearch(key);

		int soundIndex;

		for(soundIndex = 0; soundIndex<m_sounds[index].length;++soundIndex)
		{
			if(sound is m_sounds[index][soundIndex])
			{
				break;
			}
		}
		
		
		m_sounds[index].remove(soundIndex);
	}


	size_t indexSearch(uint key)
	{
		size_t i;
		for(i = 0; i<m_keys.length;++i)
		{
			if(key == m_keys[i])
			{
				break;
			}
			
		}//Index search

		return i;
	}


}//SoundList


private extern(C++) interface sfmlInputStream
{
	long read(void* data, long size);
	
	long seek(long position);
	
	long tell();
	
	long getSize();
}

/*
private class sfmlStream:sfmlInputStream
{
	private InputStream myStream;
	
	this(InputStream stream)
	{
		myStream = stream;
	}
	
	extern(C++)long read(void* data, long size)
	{
		return myStream.read(data[0..cast(size_t)size]);
	}
	
	extern(C++)long seek(long position)
	{
		return myStream.seek(position);
	}
	
	extern(C++)long tell()
	{
		return myStream.tell();
	}
	
	extern(C++)long getSize()
	{
		return myStream.getSize();
	}
}

*/

private extern(C):

void sfSoundSource_ensureALInit();
uint sfSoundStream_getFormatFromChannelCount(uint channelCount);


void sfSoundBuffer_alGenBuffers(uint* bufferID);
void sfSoundBuffer_alDeleteBuffer(uint* bufferID);
uint sfSoundBuffer_getSampleRate(uint bufferID);
uint sfSoundBuffer_getChannelCount(uint bufferID);
void sfSoundBuffer_fillBuffer(uint bufferID, short* samples, long sampleSize, uint sampleRate, uint format);

const(char)* sfErrAudio_getOutput();



