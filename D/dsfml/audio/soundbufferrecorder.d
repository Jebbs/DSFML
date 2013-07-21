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

import std.stdio;

class SoundBufferRecorder:SoundRecorder
{
	this()
	{
		// Constructor code
	}

	SoundBuffer getBuffer()
	{
		return m_buffer;
	}

	protected
	{
	override bool onStart()
	{
		m_samples.length = 0;
		m_buffer = new SoundBuffer();

		return true;
	}

	override bool onProcessSamples(short[] samples)
	{
			writeln(samples.length);


			m_samples ~= samples;
				

		return true;
	}

	override void onStop()
	{
		if(m_samples.length >0)
		{
			m_buffer.loadFromSamples(m_samples,1,sampleRate);
		}
	}
	}

private:
	short[] m_samples;
	SoundBuffer m_buffer;

}



