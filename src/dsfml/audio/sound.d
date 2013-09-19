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

import std.stdio;

import std.typecons;


class Sound : SoundSource
{
	this()
	{
		// Constructor code
	}

	this(const(SoundBuffer) buffer)
	{
		setBuffer(buffer);
	}
	//TODO: copy constructor

	~this()
	{
		debug writeln("Destroying Sound");
		//stop the sound
		stop();

		//detach the buffer
		if(m_buffer !is null)
		{
			m_buffer.detachSound(this);
		}
	}
	void play()
	{
		sfSoundStream_alSourcePlay(m_source);
	}

	void pause()
	{
		sfSoundStream_alSourcePause(m_source);
	}

	void stop()
	{
		sfSoundStream_alSourceStop(m_source);
	}


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
	@property
	{
		Status status()
		{
			return super.getStatus();
		}
	}
	void resetBuffer()
	{
		//stop the current sound;
		stop();
		//Detach the buffer
		sfSound_detachBuffer(m_source);
		//reset this sound's buffer
		m_buffer = null;
	}

	//Const AND able to be rebound
	private Rebindable!(const(SoundBuffer)) m_buffer;
}

/*
private struct ChangeableConst(T)
{
	T m_object;
	
	alias getObject this;
	
	this(const(T) object)
	{
		m_object = cast(T)object;
	}


	
	const(T) getObject()//works with both classes and structs?
	{
		return m_object;
	}
}
*/
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



