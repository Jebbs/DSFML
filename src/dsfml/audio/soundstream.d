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

import std.stdio;

import dsfml.audio.soundsource;

import dsfml.system.time;

import dsfml.system.err;

class SoundStream:SoundSource
{
	public:

	struct Chunk
	{
		const(short)* samples;
		size_t sampleCount;
	}

	~this()
	{
		writeln("SoundStream Destroyed");
		stop();
	}
	void play()
	{

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

	void pause()
	{
		sfSoundStream_alSourcePause(m_source);
	}

	void stop()
	{
		m_isStreaming = false;

		//check to make sure the thread is already running before trying to join with main thread.
		if(m_thread.isRunning())
		{
			m_thread.join(true);
		}
	}

	@property
	{
		uint channelCount()
		{
			return m_channelCount;
		}
	}
	@property
	{
		uint sampleRate()
		{
			return m_sampleRate;
		}
	}

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

	protected:

	this()
	{
		m_thread = new Thread(&streamData);
		m_isStreaming = false;
		m_channelCount = 0;
		m_sampleRate = 0;
		m_format = 0;
		m_loop = false;
		m_samplesProcessed = 0;

	}

	void initialize(uint theChannelCount, uint theSampleRate)
	{
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

	abstract bool onGetData(ref Chunk data);

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

	enum 
	{
		BufferCount = 3
	}


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

