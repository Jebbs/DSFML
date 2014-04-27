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

module dsfml.audio.sound;

import dsfml.audio.soundbuffer;
import dsfml.audio.soundsource;

import dsfml.system.time;

/++
 + Regular sound that can be played in the audio environment.
 + Sound is the class used to play sounds.
 + 
 + It provides:
 + 		- Control (play, pause, stop)
 + 		- Ability to modify output parameters in real-time (pitch, volume, ...)
 + 		- 3D spatial features (position, attenuation, ...).
 + 
 + Sound is perfect for playing short sounds that can fit in memory and require no latency, like foot steps or gun shots. For longer sounds, like background musics or long speeches, rather see Music (which is based on streaming).
 + 
 + In order to work, a sound must be given a buffer of audio data to play. Audio data (samples) is stored in SoundBuffer, and attached to a sound with the setBuffer() function. The buffer object attached to a sound must remain alive as long as the sound uses it. Note that multiple sounds can use the same sound buffer at the same time.
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Sound.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
class Sound : SoundSource
{
	import std.typecons:Rebindable;

	//Const AND able to be rebound. Word.
	private Rebindable!(const(SoundBuffer)) m_buffer;

	this()
	{
		// Constructor code
	}

	this(const(SoundBuffer) buffer)
	{
		setBuffer(buffer);
	}
	//TODO: copy constructor?

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		//stop the sound
		stop();

		//detach the buffer
		if(m_buffer !is null)
		{
			//m_buffer.detachSound(this);
		}
	}

	/** 
	 * Whether or not the sound should loop after reaching the end.
	 * 
	 * If set, the sound will restart from beginning after reaching the end and so on, until it is stopped or setLoop(false) is called.
	 * 
	 * The default looping state for sound is false.
	 */
	@property
	{
		void isLooping(bool loop)
		{
			sfSound_setLoop(m_source, loop);
		}

		bool isLooping()
		{
			return sfSound_getLoop(m_source);
		}
	}
	
	/**
	 * Change the current playing position (from the beginning) of the sound.
	 * 
	 * The playing position can be changed when the sound is either paused or playing.
	 */
	@property
	{
		void playingOffset(Time offset)
		{
			sfSound_setPlayingOffset(m_source, offset.asSeconds());
		}

		Time playingOffset()
		{
			return seconds(sfSound_getPlayingOffset(m_source));
		}
	}

	/// Get the current status of the sound (stopped, paused, playing).
	/// Returns: Current status of the sound
	@property
	{
		Status status()
		{
			return super.getStatus();
		}
	}

	// Property? 
	// (note: if this is changed to a property, change the 
	// documentation at the top of the file accordingly)
	/*
	 * Set the source buffer containing the audio data to play. It is important to note that the sound buffer is not copied, thus the SoundBuffer instance must remain alive as long as it is attached to the sound.
	 * 
	 * Params:
	 * 		buffer =	Sound buffer to attach to the sound
	 */
	void setBuffer(const(SoundBuffer) buffer)
	{
		//First detach from the previous buffer
		if(m_buffer !is null)
		{
			stop();
			
			m_buffer.detachSound(this);
		}
		
		//assign the new buffer
		m_buffer = buffer;
		m_buffer.attachSound(this);
		sfSound_assignBuffer(m_source, m_buffer.m_buffer);
		
		
	}

	/// Pause the sound.
	/// 
	/// This function pauses the sound if it was playing, otherwise (sound already paused or stopped) it has no effect.
	void pause()
	{
		sfSoundStream_alSourcePause(m_source);
	}

	/**
	 * Start or resume playing the sound.
	 * 
	 * This function starts the stream if it was stopped, resumes it if it was paused, and restarts it from beginning if it was it already playing.
	 * 
	 * This function uses its own thread so that it doesn't block the rest of the program while the sound is played.
	 */
	void play()
	{
		sfSoundStream_alSourcePlay(m_source);
	}

	/// Reset the internal buffer of the sound.
	/// 
	/// This function is for internal use only, you don't have to use it. It is called by the SoundBuffer that this sound uses, when it is destroyed in order to prevent the sound from using a dead buffer.
	void resetBuffer()
	{
		//stop the current sound;
		stop();
		//Detach the buffer
		sfSound_detachBuffer(m_source);
		//reset this sound's buffer
		m_buffer = null;
	}

	/// Stop playing the sound.
	/// 
	/// This function stops the sound if it was playing or paused, and does nothing if it was already stopped. It also resets the playing position (unlike pause()).
	void stop()
	{
		sfSoundStream_alSourceStop(m_source);
	}

}

unittest
{
	version(DSFML_Unittest_Audio)
	{
		import std.stdio;
		import dsfml.system.clock;
		import dsfml.system.time;


		writeln("Unit test for Sound class");

		//first, get a sound buffer

		auto soundbuffer = new SoundBuffer();
	
		if(!soundbuffer.loadFromFile("res/cave1.ogg"))
		{
			//error
			return;
		}

		float duration = soundbuffer.getDuration().asSeconds();

		auto sound = new Sound(soundbuffer);


		auto clock = new Clock();
		//play the sound!
		sound.play();


		while(clock.getElapsedTime().asSeconds()< duration)
		{
			//wait for sound to finish
		}


		writeln();
	}
}

private extern(C):

void sfSoundStream_alSourcePlay(uint sourceID);

void sfSoundStream_alSourcePause(uint sourceID);

void sfSoundStream_alSourceStop(uint sourceID);

void sfSound_assignBuffer(uint sourceID, uint bufferID);

void sfSound_detachBuffer(uint sourceID);

void sfSound_setLoop(uint sourceID,bool loop);

bool sfSound_getLoop(uint sourceID);

void sfSound_setPlayingOffset(uint sourceID, float offset);

float sfSound_getPlayingOffset(uint sourceID);



