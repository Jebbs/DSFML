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

module dsfml.audio.soundstream;


import core.thread;

import dsfml.audio.soundsource;

import dsfml.system.time;

import dsfml.system.vector3;

import dsfml.system.err;


/++
 + Abstract base class for streamed audio sources.
 + 
 + Unlike audio buffers (see SoundBuffer), audio streams are never completely loaded in memory.
 + 
 + Instead, the audio data is acquired continuously while the stream is playing. This behaviour allows to play a sound with no loading delay, and keeps the memory consumption very low.
 + 
 + Sound sources that need to be streamed are usually big files (compressed audio musics that would eat hundreds of MB in memory) or files that would take a lot of time to be received (sounds played over the network).
 + 
 + SoundStream is a base class that doesn't care about the stream source, which is left to the derived class. SFML provides a built-in specialization for big files (see Music). No network stream source is provided, but you can write your own by combining this class with the network module.
 + 
 + A derived class has to override two virtual functions:
 + 		- onGetData fills a new chunk of audio data to be played.
 + 		- onSeek changes the current playing position in the source
 + 
 + It is important to note that each SoundStream is played in its own separate thread, so that the streaming loop doesn't block the rest of the program. In particular, the OnGetData and OnSeek virtual functions may sometimes be called from this separate thread. It is important to keep this in mind, because you may have to take care of synchronization issues if you share data between threads.
 + 
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1SoundStream.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
class SoundStream:SoundSource
{



	package sfSoundStream* sfPtr;

	private SoundStreamCallBacks callBacks;

	protected this()
	{
		//create a blank pointer in case functions might be called before it is initialized (eg, stop() in Music's openFromFile)
		sfPtr = sfSoundStream_create(0, 0, null);

		callBacks = new SoundStreamCallBacks(this);

	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfSoundStream_destroy(sfPtr);
	}

	protected void initialize(uint channelCount, uint sampleRate)
	{
		import std.conv;

		//destroy the blank pointer so we can create the real instance
		sfSoundStream_destroy(sfPtr);

		sfPtr = sfSoundStream_create(channelCount, sampleRate, callBacks);

		err.write(text(sfErr_getOutput()));
	}



	@property
	{
		void pitch(float newPitch)
		{
			sfSoundStream_setPitch(sfPtr, newPitch);
		}
		
		float pitch()
		{
			return sfSoundStream_getPitch(sfPtr);
		}
	}
	
	/**
	 * The volume of the sound.
	 * 
	 * The volume is a vlue between 0 (mute) and 100 (full volume). The default value for the volume is 100.
	 */
	@property
	{
		void volume(float newVolume)
		{
			sfSoundStream_setVolume(sfPtr, newVolume);
		}

		float volume()
		{
			return sfSoundStream_getVolume(sfPtr);
		}
	}
	
	/**
	 * The 3D position of the sound in the audio scene.
	 * 
	 * Only sounds with one channel (mono sounds) can be spatialized. The default position of a sound is (0, 0, 0).
	 */
	@property
	{
		void position(Vector3f newPosition)
		{
			sfSoundStream_setPosition(sfPtr, newPosition.x, newPosition.y, newPosition.z);
		}
		
		Vector3f position()
		{
			Vector3f temp;
			sfSoundStream_getPosition(sfPtr, &temp.x, &temp.y, &temp.z);
			return temp;
		}
	}

	/**
	* Whether or not the stream should loop after reaching the end.
	*
	* If set, the stream will restart from the beginning after reaching the end and so on, until it is stopped or looping is set to false.
	*
	* Default looping state for streams is false.
	*/
	@property
	{
		void isLooping(bool loop)
		{
			sfSoundStream_setLoop(sfPtr, loop);
		}
		
		bool isLooping()
		{
			return sfSoundStream_getLoop(sfPtr);
		}
	}

	/**
	* The current playing position (from the beginning) of the stream.
	*
	* The playing position can be changed when the stream is either paused or playing.
	*/
	@property
	{
		void playingOffset(Time offset)
		{
			sfSoundStream_setPlayingOffset(sfPtr, offset.asMicroseconds());
			
		}
		
		Time playingOffset()
		{
			return microseconds(sfSoundStream_getPlayingOffset(sfPtr));
		}
	}
	
	/**
	 * Make the sound's position relative to the listener (true) or absolute (false).
	 * 
	 * Making a sound relative to the listener will ensure that it will always be played the same way regardless the position of the listener.  This can be useful for non-spatialized sounds, sounds that are produced by the listener, or sounds attached to it. The default value is false (position is absolute).
	 */
	@property
	{
		void relativeToListener(bool relative)
		{
			sfSoundStream_setRelativeToListener(sfPtr, relative);
		}
		
		bool relativeToListener()
		{
			return sfSoundStream_isRelativeToListener(sfPtr);
		}
	}
	
	/**
	 * The minimum distance of the sound.
	 * 
	 * The "minimum distance" of a sound is the maximum distance at which it is heard at its maximum volume. Further than the minimum distance, it will start to fade out according to its attenuation factor. A value of 0 ("inside the head of the listener") is an invalid value and is forbidden. The default value of the minimum distance is 1.
	 */
	@property
	{
		void minDistance(float distance)
		{
			sfSoundStream_setMinDistance(sfPtr, distance);
		}
		
		float minDistance()
		{
			return sfSoundStream_getMinDistance(sfPtr);
		}
	}
	
	/**
	 * The attenuation factor of the sound.
	 * 
	 * The attenuation is a multiplicative factor which makes the sound more or less loud according to its distance from the listener. An attenuation of 0 will produce a non-attenuated sound, i.e. its volume will always be the same whether it is heard from near or from far. 
	 * 
	 * On the other hand, an attenuation value such as 100 will make the sound fade out very quickly as it gets further from the listener. The default value of the attenuation is 1.
	 */
	@property
	{
		void attenuation(float newAttenuation)
		{
			sfSoundStream_setAttenuation(sfPtr, newAttenuation);
		}
		
		float attenuation()
		{
			return sfSoundStream_getAttenuation(sfPtr);
		}
	}


	/**
	* The number of channels of the stream.
	*
	* 1 channel means mono sound, 2 means stereo, etc.
	*
	* Returns: Number of channels
	*/
	@property
	{
		uint channelCount()
		{
			return sfSoundStream_getChannelCount(sfPtr);
		}
	}
	
	/**
	* The stream sample rate of the stream
	*
	* The sample rate is the number of audio samples played per second. The higher, the better the quality.
	*
	* Returns: Sample rate, in number of samples per second.
	*/
	@property
	{
		uint sampleRate()
		{
			return sfSoundStream_getSampleRate(sfPtr);
		}
	}

	@property
	{
		Status status()
		{
			return cast(Status)sfSoundStream_getStatus(sfPtr);
		}
	}

	void play()
	{
		import std.conv;

		sfSoundStream_play(sfPtr);

		err.write(text(sfErr_getOutput()));
	}

	void pause()
	{
		sfSoundStream_pause(sfPtr);
	}

	void stop()
	{
		sfSoundStream_stop(sfPtr);
	}

	abstract bool onGetData(ref const(short)[] samples);

	abstract void onSeek(Time timeOffset);
	

}

private extern(C++)
{
	struct Chunk
	{
		const(short)* samples;
		size_t sampleCount;
	}
}

private extern(C++) interface sfmlSoundStreamCallBacks
{
public:
	bool onGetData(Chunk* chunk);
	void onSeek(long time);
}


class SoundStreamCallBacks: sfmlSoundStreamCallBacks
{
	SoundStream m_stream;
	
	this(SoundStream stream)
	{
		m_stream = stream;
	}
	
	extern(C++) bool onGetData(Chunk* chunk)
	{
		const(short)[] samples;

		auto ret = m_stream.onGetData(samples);

		(*chunk).samples = samples.ptr;
		(*chunk).sampleCount = samples.length;

		return ret;

	}
	
	extern(C++) void onSeek(long time)
	{
		m_stream.onSeek(microseconds(time));
	}
	
	
	
}

private extern(C):



struct sfSoundStream;


sfSoundStream* sfSoundStream_create( uint channelCount, uint sampleRate, sfmlSoundStreamCallBacks callBacks);

void sfSoundStream_destroy(sfSoundStream* soundStream);

void sfSoundStream_play(sfSoundStream* soundStream);

void sfSoundStream_pause(sfSoundStream* soundStream);

void sfSoundStream_stop(sfSoundStream* soundStream);

int sfSoundStream_getStatus(const sfSoundStream* soundStream);

uint sfSoundStream_getChannelCount(const sfSoundStream* soundStream);

uint sfSoundStream_getSampleRate(const sfSoundStream* soundStream);

void sfSoundStream_setPitch(sfSoundStream* soundStream, float pitch);

void sfSoundStream_setVolume(sfSoundStream* soundStream, float volume);

void sfSoundStream_setPosition(sfSoundStream* soundStream, float positionX, float positionY, float positionZ);

void sfSoundStream_setRelativeToListener(sfSoundStream* soundStream, bool relative);

void sfSoundStream_setMinDistance(sfSoundStream* soundStream, float distance);

void sfSoundStream_setAttenuation(sfSoundStream* soundStream, float attenuation);

void sfSoundStream_setPlayingOffset(sfSoundStream* soundStream, long timeOffset);

void sfSoundStream_setLoop(sfSoundStream* soundStream, bool loop);

float sfSoundStream_getPitch(const sfSoundStream* soundStream);

float sfSoundStream_getVolume(const sfSoundStream* soundStream);

void sfSoundStream_getPosition(const sfSoundStream* soundStream, float* positionX, float* positionY, float* positionZ);

bool sfSoundStream_isRelativeToListener(const sfSoundStream* soundStream);

float sfSoundStream_getMinDistance(const sfSoundStream* soundStream);

float sfSoundStream_getAttenuation(const sfSoundStream* soundStream);

bool sfSoundStream_getLoop(const sfSoundStream* soundStream);

long sfSoundStream_getPlayingOffset(const sfSoundStream* soundStream);

const(char)* sfErr_getOutput();
