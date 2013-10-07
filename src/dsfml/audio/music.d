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

module dsfml.audio.music;


import dsfml.system.mutex;
import dsfml.system.lock;


import dsfml.system.time;
import dsfml.system.inputstream;

import dsfml.audio.soundstream;

import dsfml.audio.soundfile;

import std.string;

import std.stdio;

class Music:SoundStream
{
	this()
	{
		m_file.create();

		m_mutex = new Mutex();

		m_mutex.lock();
		m_mutex.unlock();

		super();
		
	}

	bool openFromFile(string filename)
	{
		//stop music if already playing
		stop();

		if(!m_file.openReadFromFile(filename))
		{
			return false;
		}

		initialize();

		return true;
	}

	bool openFromMemory(const(void)[] data)
	{
		stop();

		if(!m_file.openReadFromMemory(data))
		{
			return false;
		}

		initialize();
		return true;
	}

	bool openFromStream(InputStream stream)
	{
		stop();

		if(!m_file.openReadFromStream(stream))
		{
			return false;
		}

		initialize();

		return true;
	}

	Time getDuration()
	{
		return m_duration;
	}

	~this()
	{
		writeln("Destroying Music");
		stop();
	}

	protected
	{
		override bool onGetData(ref Chunk data)
		{
			Lock lock = Lock(m_mutex);

			data.sampleCount = cast(size_t)m_file.read(m_samples);
			data.samples = &m_samples[0];


			return data.sampleCount == m_samples.length;
		}

		override void onSeek(Time timeOffset)
		{
			Lock lock =Lock(m_mutex);

			m_file.seek(timeOffset.asMicroseconds());
		}
	}

	private
	{
		void initialize()
		{
			size_t sampleCount = cast(size_t)m_file.getSampleCount();

			uint channelCount = m_file.getChannelCount() ;

			uint sampleRate = m_file.getSampleRate();

			// Compute the music duration
			m_duration = seconds(cast(float)(sampleCount) / sampleRate / channelCount);
			
			// Resize the internal buffer so that it can contain 1 second of audio samples
			m_samples.length = sampleRate * channelCount;

			// Initialize the stream
			super.initialize(channelCount, sampleRate);

		}
		
		//sfSoundFile* m_file;
		SoundFile m_file;
		Time m_duration;
		short[] m_samples;
		Mutex m_mutex;
	}
}

private extern(C):


