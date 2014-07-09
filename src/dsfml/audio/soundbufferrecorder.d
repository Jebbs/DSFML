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

module dsfml.audio.soundbufferrecorder;

import dsfml.audio.soundrecorder;
import dsfml.audio.soundbuffer;


/++
 + Specialized SoundRecorder which stores the captured audio data into a sound buffer.
 + 
 + SoundBufferRecorder allows to access a recorded sound through a SoundBuffer, so that it can be played, saved to a file, etc.
 + 
 + It has the same simple interface as its base class (start(), stop()) and adds a function to retrieve the recorded sound buffer (getBuffer()).
 + 
 + As usual, don't forget to call the isAvailable() function before using this class (see SoundRecorder for more details about this).
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1SoundBufferRecorder.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
class SoundBufferRecorder:SoundRecorder
{
	private
	{
		short[] m_samples;
		SoundBuffer m_buffer;
	}
	
	this()
	{
		// Constructor code
		m_buffer = new SoundBuffer();
	}
	
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
	}
	
	/**
	 * Get the sound buffer containing the captured audio data.
	 * 
	 * The sound buffer is valid only after the capture has ended. This function provides a read-only access to the internal sound buffer, but it can be copied if you need to make any modification to it.
	 * 
	 * Returns: Read-only access to the sound buffer
	 */
	const(SoundBuffer) getBuffer() const
	{
		return m_buffer;
	}
	
	protected
	{
		/// Start capturing audio data.
		/// Returns: True to start the capture, or false to abort it
		override bool onStart()
		{
			m_samples.length = 0;
			m_buffer = new SoundBuffer();
			
			return true;
		}
		
		/**
		 * Process a new chunk of recorded samples.
		 * 
		 * Params:
		 * 		samples =	Array of the new chunk of recorded samples'
		 * 
		 * Returns: True to continue the capture, or false to stop it
		 */
		override bool onProcessSamples(const(short)[] samples)
		{
			m_samples ~= samples;
			
			return true;
		}
		
		/// Stop capturing audio data.
		/// 
		/// Reimplemented from SoundRecorder.
		override void onStop()
		{
			if(m_samples.length >0)
			{
				m_buffer.loadFromSamples(m_samples,1,sampleRate);
			}
		}
	}
}

unittest
{
	//When this unit test is run it occasionally throws an error which will vary, and
	//is obviously in OpenAL. Probably something to do with the way the binding is done. Will be fixed in 2.1.
	version(DSFML_Unittest_Audio)
	{
		import std.stdio;
		import dsfml.window.keyboard;
		import dsfml.audio.sound;
		import dsfml.system.time;
		import dsfml.system.clock;
		import dsfml.system.sleep;
		
		
		writeln("Unit test for SoundBufferRecorder.");
		
		auto recorder = new SoundBufferRecorder();
		
		assert(SoundRecorder.isAvailable());
		
		
		writeln("Press Enter to start recording.");
		while(!Keyboard.isKeyPressed(Keyboard.Key.Return))
		{
			//wait for the user to press enter
			if(Keyboard.isKeyPressed(Keyboard.Key.Return))
			{
				
				recorder.start();
			}
		}
		//make sure the next one diesn't trigger immediately
		if(Keyboard.isKeyPressed(Keyboard.Key.Return))
		{
			//wait until they release the key
			while(Keyboard.isKeyPressed(Keyboard.Key.Return))
			{
				//writeln(true);
			}
		}
		
		
		writeln("Press Enter to stop recording.");
		
		while(!Keyboard.isKeyPressed(Keyboard.Key.Return))
		{
			if(Keyboard.isKeyPressed(Keyboard.Key.Return))
			{
				recorder.stop();
			}
		}



		auto buffer = recorder.getBuffer();
		
		auto recorderDuration = buffer.getDuration();
		
		auto recorderSound = new Sound(buffer);
		
		auto clock = new Clock();
		
		recorderSound.play();
		while(clock.getElapsedTime() < recorderDuration)
		{
			//sound playing
		}
		
		
		
		
		writeln();
	}
}



