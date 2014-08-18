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
import dsfml.system.time;
import dsfml.system.inputstream;

import dsfml.audio.soundstream;


/++
 + Streamed music played from an audio file.
 + 
 + Musics are sounds that are streamed rather than completely loaded in memory.
 + 
 + This is especially useful for compressed musics that usually take hundreds of MB when they are uncompressed: by streaming it instead of loading it entirely, you avoid saturating the memory and have almost no loading delay.
 + 
 + Apart from that, a Music has almost the same features as the SoundBuffer / Sound pair: you can play/pause/stop it, request its parameters (channels, sample rate), change the way it is played (pitch, volume, 3D position, ...), etc.
 + 
 + As a sound stream, a music is played in its own thread in order not to block the rest of the program. This means that you can leave the music alone after calling play(), it will manage itself very well.
 + 
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1Music.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
class Music : SoundStream
{
	import dsfml.audio.soundfile;

	private
	{
		SoundFile m_file;
		Time m_duration;
		short[] m_samples;
		Mutex m_mutex;
	}

	this()
	{
		m_file.create();

		m_mutex = new Mutex();

		super();
	}

	/**
	 * Open a music from an audio file.
	 * 
	 * This function doesn't start playing the music (call play() to do so). 
	 * 
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Params:
	 * 		filename =	Path of the music file to open.
	 * Returns: True if loading succeeded, false if it failed.
	 */
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

	/**
	 * Open a music from an audio file in memory.
	 * 
	 * This function doesn't start playing the music (call play() to do so).
	 *
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Since the music is not loaded completely but rather streamed continuously, the data must remain available as long as the music is playing (ie. you can't deallocate it right after calling this function).
	 * 
	 * Params:
	 * 		data =	The array of data
	 * Returns: True if loading succeeded, false if it failed.
	 */
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

	/**
	 * Open a music from an audio file in memory.
	 * 
	 * This function doesn't start playing the music (call play() to do so). 
	 * 
	 * Here is a complete list of all the supported audio formats: ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam, w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
	 * 
	 * Since the music is not loaded completely but rather streamed continuously, the stream must remain available as long as the music is playing (ie. you can't deallocate it right after calling this function).
	 * 
	 * Params:
	 * 		stream =	Source stream to read from
	 * Returns: True if loading succeeded, false if it failed.
	 */
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

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		stop();
	}

	/// Get the total duration of the music.
	/// Returns: Music duration
	Time getDuration()
	{
		return m_duration;
	}

	protected
	{
		/**
		 * Request a new chunk of audio samples from the stream source.
		 * 
		 * This function fills the chunk from the next samples to read from the audio file.
		 * 
		 * Params:
		 * 		samples =	Array of samples to fill
		 * 
		 * Returns: True to continue playback, false to stop.
		 */
		override bool onGetData(ref const(short)[] samples)
		{
			import dsfml.system.lock;

			Lock lock = Lock(m_mutex);

			auto length = cast(size_t)m_file.read(m_samples);
			samples = m_samples[0..length];

			return (samples.length == m_samples.length);
		}
		/**
		 * Change the current playing position in the stream source.
		 * 
		 * Params:
		 * 		timeOffset =	New playing position, from the beginning of the music
		 * 
		 * Implements SoundStream.
		 */
		override void onSeek(Time timeOffset)
		{
			import dsfml.system.lock;

			Lock lock =Lock(m_mutex);

			m_file.seek(timeOffset.asMicroseconds());
		}
	}

	private
	{
		/**
		 * Define the audio stream parameters.
		 * 
		 * This function must be called by derived classes as soon as they know the audio settings of the stream to play. Any attempt to manipulate the stream (play(), ...) before calling this function will fail. 
		 * 
		 * It can be called multiple times if the settings of the audio stream change, but only when the stream is stopped.
		 * 
		 * Params:
		 * 		channelCount =	Number of channels of the stream
		 * 		sampleRate =	Sample rate, in samples per second
		 */
		void initialize()
		{
			size_t sampleCount = cast(size_t)m_file.getSampleCount();

			uint channelCount = m_file.getChannelCount();

			uint sampleRate = m_file.getSampleRate();

			// Compute the music duration
			m_duration = seconds(cast(float)(sampleCount) / sampleRate / channelCount);
			
			// Resize the internal buffer so that it can contain 1 second of audio samples
			m_samples.length = sampleRate * channelCount;

			// Initialize the stream
			super.initialize(channelCount, sampleRate);

		}

	}
}

unittest
{
	version(DSFML_Unittest_Audio)
	{
		import std.stdio;
		import dsfml.system.clock;

		writeln("Unit test for Music Class");

		auto music = new Music();

		//TODO: update this for a real unit test users can run themselves.
		if(!music.openFromFile("res/hal1.ogg"))
		{
			return;
		}

		auto clock = new Clock();

		writeln("Playing music for 5 seconds");

		music.play();
		while(clock.getElapsedTime().asSeconds() < 5)
		{
			//playing music in seoarate thread while main thread is stuck here
		}

		music.stop();




		writeln();
	}
}


