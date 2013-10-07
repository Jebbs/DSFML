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

module dsfml.audio.soundrecorder;

import core.thread;
import std.stdio;

import dsfml.system.err;
import std.conv;

class SoundRecorder
{
	 protected this()
	{
		sfSoundSource_ensureALInit();
		err.write(text(sfErrAudio_getOutput()));

		m_thread = new Thread(&record);
		m_isCapturing = false;
		recorder = sfSoundRecorder_create();
	}

	~this()
	{
		sfSoundRecorder_destroy(recorder);
	}
   	void start(uint theSampleRate = 44100)
	{
		//Initialize the device before starting to capture
		if(!sfSoundRecorder_initialize(recorder, theSampleRate))
		{
			err.write(text(sfErrAudio_getOutput()));
			return;
		}

		m_sampleRate = theSampleRate;

		//notify the derived class
		if(onStart())
		{
			//start the capture
			sfSoundRecorder_startCapture(recorder);
			//start the capturing in a new thread to avoid blocking the main thread
			m_isCapturing = true;
			m_thread.start();
		}

	}
	void stop()
	{
		//stop the capturing thread
		m_isCapturing = false;
		m_thread.join(true);
	}

	@property
	{
		uint sampleRate()
		{
			return m_sampleRate;
		}
	}

	static bool isAvailable()
	{
		return sfSoundRecorder_isAvailable();
	}

	protected
	{
		abstract bool onStart();

		abstract bool onProcessSamples(short[] samples);

		abstract void onStop();

	}

	private
	{
		void record()
		{
			while(m_isCapturing)
			{

				processCapturedSamples();


				//don't bother the CPU while waiting for more captured data
				Thread.sleep( dur!("msecs")( 100) );
			}
			//capture is finished: cleanup everything
			cleanup();

			//notify derived class
			onStop();
		}

		void processCapturedSamples()
		{
			//writeln("Capturing");
			//short* samples;
			int samplesAvailable = sfSoundRecorder_getNumAvailableSamples(recorder);//sfSoundRecorder_captureSamples(captureDevice, samples, recorder);

			if(samplesAvailable > 0)
			{

				short* samples = sfSoundRecorder_getSamplePointer(recorder, samplesAvailable);


			
				//forward them to the derived class
				if(!onProcessSamples(samples[0 .. samplesAvailable]))
				{
					//The user wants to stop the capture
					m_isCapturing = false;
				}
			}

		}

		void cleanup()
		{
			//stop the capture
			sfSoundRecorder_stopCapture(recorder);

			//get the samples left in the buffer
			processCapturedSamples();

			//close the device
			sfSoundRecorder_closeDevice(recorder);
			//captureDevice = null;

		}

		Thread m_thread;
		//short[] m_samples;
		sfSoundRecorder* recorder;
		uint m_sampleRate;
		bool m_isCapturing;
	}

}





private extern(C):

void sfSoundSource_ensureALInit();
struct sfSoundRecorder;

sfSoundRecorder* sfSoundRecorder_create();

void sfSoundRecorder_destroy(sfSoundRecorder* recorder);

bool sfSoundRecorder_initialize(sfSoundRecorder* recorder, uint sampleRate); 

void sfSoundRecorder_startCapture(sfSoundRecorder* recorder);

int sfSoundRecorder_getNumAvailableSamples(sfSoundRecorder* recorder);

short* sfSoundRecorder_getSamplePointer(sfSoundRecorder* recorder, int numSamples);

void sfSoundRecorder_stopCapture(sfSoundRecorder* recorder);

void sfSoundRecorder_closeDevice(sfSoundRecorder* recorder);

bool sfSoundRecorder_isAvailable();

const(char)* sfErrAudio_getOutput();
