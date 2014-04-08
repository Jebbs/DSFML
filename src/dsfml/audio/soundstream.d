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
	private
	{
		Thread m_thread;
		bool m_isStreaming;
		uint m_buffers[BufferCount];
		uint m_channelCount;
		uint m_sampleRate;
		uint m_format;
		bool m_loop;
		long m_samplesProcessed;
		bool m_endBuffers[BufferCount];
	}

	struct Chunk
	{
		const(short)* samples;
		size_t sampleCount;
	}

	protected this()
	{
		m_thread = new Thread(&streamData);
		m_isStreaming = false;
		m_channelCount = 0;
		m_sampleRate = 0;
		m_format = 0;
		m_loop = false;
		m_samplesProcessed = 0;
		
	}

	~this()
	{
		debug import dsfml.system.config;
		mixin(destructorOutput);
		stop();
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
			return m_channelCount;
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
			return m_sampleRate;
		}
	}
	
	/// The current status of the stream (stopped, paused, playing)
	/// Returns: Current status
	@property
	{
		Status status()
		{
			Status temp = super.getStatus();
			
			//to compensate for the lag between play() and alSourcePlay()
			if((temp == Status.Stopped) && m_isStreaming)
			{
				temp = Status.Playing;
			}
			
			return temp;
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
			stop();
			
			onSeek(offset);
			m_samplesProcessed = cast(long)(offset.asSeconds() * m_sampleRate * m_channelCount);
			m_isStreaming = true;
			m_thread.start();
			
		}

		Time playingOffset()
		{
			if((m_sampleRate!=0) && (m_channelCount !=0))
			{
				return microseconds(sfSoundStream_getPlayingOffset(m_source, m_samplesProcessed, m_sampleRate, m_channelCount));
			}
			
			return Time.Zero;
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
			m_loop = loop;
		}

		bool isLooping()
		{
			return m_loop;
		}
	}

	/// Pause the audio stream.
	/// 
	/// This function pauses the stream if it was playing, otherwise (stream already paused or stopped) it has no effect.
	void pause()
	{
		sfSoundStream_alSourcePause(m_source);
	}

	/// Play or resume playing the audio stream.
	/// 
	/// This function starts the stream if it was stopped, resumes it if it was paused, and restarts it from beginning if it was it already playing. This function uses its own thread so that it doesn't block the rest of the program while the stream is played.
	void play()
	{
		import dsfml.system.err;

		//check to see if sound parameters ave been set
		if(m_format == 0)
		{
			err.writeln("Faile to play audio stream: sound parameters have not been initialized (call Initialization fisrt)");
			return;
		}
		
		//If the sound is already playing(probably paused), just resume it.
		if(m_isStreaming)
		{
			sfSoundStream_alSourcePlay(m_source);
			return;
		}
		
		//Move to the beginning
		onSeek(Time.Zero);
		
		//Start updating the stream in a separate thread to avoid blocking the application
		m_samplesProcessed = 0;
		m_isStreaming = true;
		m_thread.start();
	}

	/// Stop playing the audio stream
	/// 
	/// This function stops the stream if it was playing or paused, and does nothing if it was already stopped. It also resets the playing position (unlike pause()).
	void stop()
	{
		m_isStreaming = false;

		//check to make sure the thread is already running before trying to join with main thread.
		if(m_thread.isRunning())
		{
			m_thread.join(true);
		}
	}

protected:
	/**
	 * Define the audio stream parameters.
	 * 
	 * This function must be called by derived classes as soon as they know the audio settings of the stream to play. Any attempt to manipulate the stream (play(), ...) before calling this function will fail. It can be called multiple times if the settings of the audio stream change, but only when the stream is stopped.
	 * 
	 * Params:
	 * 		theChannelCount =	Number of channels of the stream
	 * 		theSampleRate =		Sample rate, in samples per second
	 */
	void initialize(uint theChannelCount, uint theSampleRate)
	{
		import dsfml.system.err;

		m_channelCount = theChannelCount;
		m_sampleRate = theSampleRate;

		//Deduce the format from number of channels
		m_format = sfSoundStream_getFormatFromChannelCount(theChannelCount);

		//check if the format is valid
		if(m_format == 0)
		{
			m_channelCount = 0;
			m_sampleRate = 0;

			err.writeln("Unsupported number of channels");
		}
	}

	/**
	 * Request a new chunk of audio.
	 * 
	 * This function must be overridden by derived classes to provide the audio samples to play. It is called continuously by the streaming loop, in a separate thread. The source can choose to stop the streaming loop at any time, by returning false to the caller.
	 * 
	 * Params:
	 * 		data =	Chunk of data to fill
	 * 
	 * Returns: True to continue playback, false to stop.
	 */
	abstract bool onGetData(ref Chunk data);

	/**
	 * Change the current playing position in the stream source.
	 * 
	 * This function must be overriden by derived classes to allow random seeking into the stream source.
	 * 
	 * Params:
	 * 		timeOffset =	New playing position, relative to the beginning of the stream.
	 * 
	 * Implemented in Music.
	 */
	abstract void onSeek(Time timeOffset);


private:

	void streamData()
	{
		//create the buffers
		sfSoundStream_alGenBuffers(BufferCount,m_buffers.ptr);
		for(int i = 0; i< BufferCount;++i)
		{
			m_endBuffers[i] = false;
		}

		//fill the queue
		bool requestStop = fillQueue();

		//Play the sound
		sfSoundStream_alSourcePlay(m_source);


		while(m_isStreaming)
		{
			//the stream has been interrupted!
			if(super.getStatus() == Status.Stopped)
			{
				if(!requestStop)
				{
					//just continue
					sfSoundStream_alSourcePlay(m_source);
				}
				else
				{
					m_isStreaming = false;
				}
			}

			//Get the number of buffers that have been processed

			int nbProcessed = sfSoundStream_getNumberOfBuffersProccessed(m_source);

			while(nbProcessed-- !=0)
			{
				//pop the first unused buffer from the queue
				uint buffer = sfSoundStream_UnqueueBuffer(m_source);

				//find its number
				uint bufferNum = 0;
				for(int i = 0; i<BufferCount; ++i)
				{
					if(m_buffers[i] == buffer)
					{
						bufferNum = i;
						break;
					}
				}

				//Retrieve its size and add it to the samples count

				if(m_endBuffers[bufferNum])
				{
					//This was the last buffer: reset the count;
					m_samplesProcessed = 0;
					m_endBuffers[bufferNum] = false;

				}
				else
				{
					m_samplesProcessed += sfSoundStream_getBufferSampleSize(buffer);
				}

				//Fill it and push it back into the playing queue
				if(!requestStop)
				{
					if(fillAndPushBuffer(bufferNum))
					{
						requestStop = true;
					}
				}

			}//while nbProcessed

			//leave some time for the other threads if still streaming
			if(super.getStatus() != Status.Stopped)
			{
				Thread.sleep(dur!("msecs")(10));
			}


		}//while streaming


		//Stop the playback
		sfSoundStream_alSourceStop(m_source);

		//Unqueue any buffer left in the queue
		clearQueue();

		//Delete the buffers
		sfSoundStream_deleteBuffers(m_source,BufferCount,m_buffers.ptr);
	}
	 

	bool fillAndPushBuffer(uint bufferNum)
	{
		bool requestStop = false;

		Chunk data;

		//Acquire audio data
		if(!onGetData(data))
		{
			//Mark the buffer as the last one
			m_endBuffers[bufferNum] = true;

			//check if the stream must loop or stop
			if(m_loop)
			{
				onSeek(Time.Zero);

				//If we previously had no data, try to fill the buffer once again
				if(data.sampleCount == 0)
				{
					return fillAndPushBuffer(bufferNum);
				}
			}
			else
			{
				//not looping: request stop
				requestStop = true;
			}
		}//on get data

		//fill the buffer if some data was returned
		if(data.sampleCount>0)
		{
			uint buffer = m_buffers[bufferNum];

			//fill the buffer
			sfSoundStream_fillBuffer(buffer, data.samples,data.sampleCount,m_format,m_sampleRate);

			//push it into the queue
			sfSoundStream_queueBuffer(m_source, &buffer);
		}

		return requestStop;
	}

	bool fillQueue()
	{
		// Fill and enqueue all the available buffers
		bool requestStop = false;
		for (int i = 0; (i < BufferCount) && !requestStop; ++i)
		{
			if (fillAndPushBuffer(i))
				requestStop = true;
		}
		
		return requestStop;
	}

	void clearQueue()
	{
		sfSoundStream_clearQueue(m_source);
	}

	enum BufferCount = 3;

}

private extern(C):

uint sfSoundStream_getFormatFromChannelCount(uint channelCount);

void sfSoundStream_alSourcePlay(uint sourceID);

void sfSoundStream_alSourcePause(uint sourceID);

void sfSoundStream_alSourceStop(uint sourceID);

void sfSoundStream_alGenBuffers(int bufferCOunt, uint* buffers);

void sfSoundStream_deleteBuffers(uint sourceID, int bufferCount, uint* buffers);

void sfSoundStream_clearQueue(uint sourceID);

int sfSoundStream_getNumberOfBuffersProccessed(uint sourceID);

long sfSoundStream_getPlayingOffset(uint sourceID, long samplesProcessed, uint theSampleRate, uint theChannelCount);

uint sfSoundStream_UnqueueBuffer(uint sourceID);

int sfSoundStream_getBufferSampleSize(uint bufferID);

void sfSoundStream_fillBuffer(uint bufferID, const short* samples, long sampleCount, uint soundFormat, uint sampleRate);

void sfSoundStream_queueBuffer(uint sourceID, uint* bufferID);

