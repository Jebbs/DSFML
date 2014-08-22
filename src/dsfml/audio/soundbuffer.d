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
import std.string;

/++
 + Storage for audio samples defining a sound.
 + 
 + A sample is a 16 bits signed integer that defines the amplitude of the sound at a given time. The sound is then restituted by playing these samples at a high rate (for example, 44100 samples per second is the standard rate used for playing CDs). In short, audio samples are like texture pixels, and a SoundBuffer is similar to a Texture.
 + 
 + A sound buffer can be loaded from a file (see loadFromFile() for the complete list of supported formats), from memory, from a custom stream (see InputStream) or directly from an array of samples. It can also be saved back to a file.
 + 
 + Sound buffers alone are not very useful: they hold the audio data but cannot be played. To do so, you need to use the sf::Sound class, which provides functions to play/pause/stop the sound as well as changing the way it is outputted (volume, pitch, 3D position, ...). 
 + 
 + This separation allows more flexibility and better performances: indeed a sf::SoundBuffer is a heavy resource, and any operation on it is slow (often too slow for real-time applications). On the other side, a sf::Sound is a lightweight object, which can use the audio data of a sound buffer and change the way it is played without actually modifying that data. Note that it is also possible to bind several Sound instances to the same SoundBuffer.
 + 
 + It is important to note that the Sound instance doesn't copy the buffer that it uses, it only keeps a reference to it. Thus, a SoundBuffer must not be destructed while it is used by a Sound (i.e. never write a function that uses a local SoundBuffer instance for loading a sound).
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1SoundBuffer.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
class SoundBuffer
{
	package sfSoundBuffer* sfPtr;

	this()
	{
		sfPtr = sfSoundBuffer_create();
		err.write(text(sfErr_getOutput()));
	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfSoundBuffer_destroy(sfPtr);
	}
	
	//TODO: copy constructor?
	//So many possible properties....

	/** 
	 * Get the array of audio samples stored in the buffer.
	 * 
	 *  The format of the returned samples is 16 bits signed integer (sf::Int16). The total number of samples in this array is given by the getSampleCount() function.
	 * 
	 *  Returns: Read-only pointer to the array of sound samples
	 */
	const(short[]) getSamples() const
	{
		if(sfSoundBuffer_getSampleCount(sfPtr) > 0)
		{
			return sfSoundBuffer_getSamples(sfPtr)[0 .. sfSoundBuffer_getSampleCount(sfPtr)];
		}
		else
		{
			return null;
		}
	}

	/**
	 * Get the sample rate of the sound.
	 * 
	 * The sample rate is the number of samples played per second. The higher, the better the quality (for example, 44100 samples/s is CD quality).
	 * 
	 * Returns: Sample rate (number of samples per second)
	 */
	uint getSampleRate() const
	{
		return sfSoundBuffer_getSampleRate(sfPtr);
	}

	/**
	 * Get the number of channels used by the sound.
	 * 
	 * If the sound is mono then the number of channels will be 1, 2 for stereo, etc.
	 * 
	 * Returns: Number of channels
	 */
	uint getChannelCount() const
	{
		return sfSoundBuffer_getChannelCount(sfPtr);
	}

	/**
	 * Get the total duration of the sound.
	 * 
	 * Returns: Sound duration
	 */
	Time getDuration() const
	{
		return microseconds(sfSoundBuffer_getDuration(sfPtr));
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
		sfPtr = sfSoundBuffer_createFromFile(toStringz(filename));
		
		if(sfPtr)
		{
			return true;
		}
		else
		{
			err.write(text(sfErr_getOutput()));
			return false;
		}
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
		sfPtr = sfSoundBuffer_createFromMemory(data.ptr, data.length);
		
		if(sfPtr)
		{
			return true;
		}
		else
		{
			err.write(text(sfErr_getOutput()));
			return false;
		}
	}

	/*
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

		sfPtr = sfSoundBuffer_createFromStream(stream);
		
		if(sfPtr)
		{
			return true;
		}
		else
		{
			err.write(text(sfErr_getOutput()));
			return false;
		}
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

		sfPtr = sfSoundBuffer_createFromSamples(samples.ptr, samples.length, channelCount, sampleRate);

		if(sfPtr)
		{
			return true;
		}
		else
		{
			err.write(text(sfErr_getOutput()));
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
		sfSoundBuffer_saveToFile(sfPtr, toStringz(filename));
		
		if(sfPtr)
		{
			return true;
		}
		else
		{
			err.write(text(sfErr_getOutput()));
			return false;
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

		if(!soundbuffer.loadFromFile("res/cave1.ogg"))
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


package struct sfSoundBuffer;

private extern(C):

sfSoundBuffer* sfSoundBuffer_create();

sfSoundBuffer* sfSoundBuffer_createFromFile(const char* filename);

sfSoundBuffer* sfSoundBuffer_createFromMemory(const void* data, size_t sizeInBytes);

sfSoundBuffer* sfSoundBuffer_createFromStream(InputStream stream);

sfSoundBuffer* sfSoundBuffer_createFromSamples(const short* samples, size_t sampleCount, uint channelCount, uint sampleRate);

sfSoundBuffer* sfSoundBuffer_copy(const sfSoundBuffer* soundBuffer);

void sfSoundBuffer_destroy(sfSoundBuffer* soundBuffer);

bool sfSoundBuffer_saveToFile(const sfSoundBuffer* soundBuffer, const char* filename);

const(short)* sfSoundBuffer_getSamples(const sfSoundBuffer* soundBuffer);

size_t sfSoundBuffer_getSampleCount(const sfSoundBuffer* soundBuffer);

uint sfSoundBuffer_getSampleRate(const sfSoundBuffer* soundBuffer);

uint sfSoundBuffer_getChannelCount(const sfSoundBuffer* soundBuffer);

long sfSoundBuffer_getDuration(const sfSoundBuffer* soundBuffer);

const(char)* sfErr_getOutput();

