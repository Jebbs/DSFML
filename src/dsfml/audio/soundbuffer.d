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

/++
 + Storage for audio samples defining a sound.
 + 
 + A sample is a 16 bits signed integer that defines the amplitude of the sound at a given time. 
 + The sound is then restituted by playing these samples at a high rate (for example, 44100 samples per second is the standard rate used for playing CDs). 
 + In short, audio samples are like texture pixels, and a SoundBuffer is similar to a Texture.
 + 
 + A sound buffer can be loaded from a file (see loadFromFile() for the complete list of supported formats), from memory, from a custom stream (see InputStream) or directly from an array of samples. 
 + It can also be saved back to a file.
 + 
 + Sound buffers alone are not very useful: they hold the audio data but cannot be played. 
 + To do so, you need to use the sf::Sound class, which provides functions to play/pause/stop the sound as well as changing the way it is outputted (volume, pitch, 3D position, ...). 
 + This separation allows more flexibility and better performances: indeed a sf::SoundBuffer is a heavy resource, and any operation on it is slow (often too slow for real-time applications). 
 + On the other side, a sf::Sound is a lightweight object, which can use the audio data of a sound buffer and change the way it is played without actually modifying that data. Note that it is also possible to bind several Sound instances to the same SoundBuffer.
 + 
 + It is important to note that the Sound instance doesn't copy the buffer that it uses, it only keeps a reference to it.
 + Thus, a SoundBuffer must not be destructed while it is used by a Sound (i.e. never write a function that uses a local SoundBuffer instance for loading a sound).
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1SoundBuffer.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
class SoundBuffer
{
	private 
	{

		Time m_duration; 
		short[] m_samples;
	
		//Allows a sound buffer to remain const while still having a mutable list of sounds attached to it.
		static SoundList m_sounds;
	}
	
	this()
	{
		//create the buffer
		sfSoundSource_ensureALInit();
		err.write(text(sfErrAudio_getOutput()));
		
		//Create the buffer
		sfSoundBuffer_alGenBuffers(&m_buffer);

		//use the existing buffer ID to create a mutable list of sounds attached to it
		m_sounds.add(m_buffer);

	}

	~this()
	{
		debug import dsfml.system.config;
		mixin(destructorOutput);
		
		//Detach 
		foreach(Sound sound;m_sounds[m_buffer])
		{
			sound.toString();
			sound.resetBuffer();
		}
		
		
		m_sounds.remove(m_buffer);
		
		
		sfSoundBuffer_alDeleteBuffer(&m_buffer);
	}
	
	//TODO: copy constructor?
	//So many possible properties....
	/** 
	 * Get the array of audio samples stored in the buffer.
	 * 
	 *  The format of the returned samples is 16 bits signed integer (sf::Int16). 
	 *  The total number of samples in this array is given by the getSampleCount() function.
	 * 
	 *  Returns: Read-only pointer to the array of sound samples
	 */
	const(short[]) getSamples()
	{
		return m_samples;
	}

	/**
	 * Get the sample rate of the sound.
	 * 
	 * The sample rate is the number of samples played per second. 
	 * The higher, the better the quality (for example, 44100 samples/s is CD quality).
	 * 
	 * Returns: Sample rate (number of samples per second)
	 */
	uint getSampleRate()
	{
		return sfSoundBuffer_getSampleRate(m_buffer);
	}

	/**
	 * Get the number of channels used by the sound.
	 * 
	 * If the sound is mono then the number of channels will be 1, 2 for stereo, etc.
	 * 
	 * Returns: Number of channels
	 */
	uint getChannelCount()
	{
		return sfSoundBuffer_getChannelCount(m_buffer);
	}

	/**
	 * Get the total duration of the sound.
	 * 
	 * Returns: Sound duration
	 */
	Time getDuration()
	{
		return m_duration;
	}

	/**
	 * Load the sound buffer from a file.
	 * 
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Params:
	 * 		filename =	Path of the sound file to load
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
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

	/**
	 * Load the sound buffer from a file in memory.
	 * 
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Params:
	 * 		data =	The array of data
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
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

	/**
	 * Load the sound buffer from a custom stream.
	 * 
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Params:
	 * 		stream =	Source stream to read from
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
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

	/**
	 * Load the sound buffer from an array of audio samples.
	 * 
	 * The assumed format of the audio samples is 16 bits signed integer (short).
	 * 
	 * Params:
	 * 		samples =	Array of samples in memory
	 * 		channelCount =	Number of channels (1 = mono, 2 = stereo, ...)
	 * 		sampleRate =	Sample rate (number of samples to play per second)
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
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

	/**
	 * Save the sound buffer to an audio file.
	 * 
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Params:
	 * 		filename =	Path of the sound file to write
	 * 
	 * Returns: True if saving succeeded, false if it failed
	 */
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

	}

}

unittest
{
	version(DSFML_Unittest_Audio)
	{
		import std.stdio;

		writeln("Unit test for sound buffer");

		auto soundbuffer = new SoundBuffer();

		if(!soundbuffer.loadFromFile("cave1.ogg"))
		{
			//error
			return;
		}

		writeln("Sample Rate: ", soundbuffer.getSampleRate());

		writeln("Channel Count: ", soundbuffer.getChannelCount());

		writeln("Duration: ",soundbuffer.getDuration().asSeconds());

		writeln("Sample Count: ",soundbuffer.getSamples().length);

		//use sound buffer here

		writeln();
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


private extern(C):

void sfSoundSource_ensureALInit();
uint sfSoundStream_getFormatFromChannelCount(uint channelCount);


void sfSoundBuffer_alGenBuffers(uint* bufferID);
void sfSoundBuffer_alDeleteBuffer(uint* bufferID);
uint sfSoundBuffer_getSampleRate(uint bufferID);
uint sfSoundBuffer_getChannelCount(uint bufferID);
void sfSoundBuffer_fillBuffer(uint bufferID, short* samples, long sampleSize, uint sampleRate, uint format);

const(char)* sfErrAudio_getOutput();



