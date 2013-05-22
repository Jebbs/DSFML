module dsfml.audio.music;


import dsfml.system.mutex;
import dsfml.system.lock;


import dsfml.system.time;

import dsfml.audio.soundstream;

import dsfml.audio.soundfile;

import std.string;

import std.stdio;

class Music:SoundStream
{
	this()
	{
		m_file = sfSoundFile_create();

		m_mutex = new Mutex();

		m_mutex.lock();
		m_mutex.unlock();

		super();
		
	}

	bool openFromFile(string filename)
	{
		//stop music if already playing
		stop();

		if(!sfSoundFile_openReadFromFile(m_file,toStringz(filename)))
		{
			return false;
		}

		initialize();

		return true;
	}

	bool openFromMemory()
	{
		return false;
	}

	bool openFromStream()
	{
		return false;
	}

	Time getDuration()
	{
		return m_duration;
	}

	~this()
	{
		writeln("Destroying Music");
		stop();
		sfSoundFile_destroy(m_file);
	}

	protected
	{
		override bool onGetData(ref Chunk data)
		{
			Lock lock = Lock(m_mutex);

			data.sampleCount = cast(size_t)sfSoundFile_read(m_file,&m_samples[0],m_samples.length);
			data.samples = &m_samples[0];


			return data.sampleCount == m_samples.length;
		}

		override void onSeek(Time timeOffset)
		{
			Lock lock =Lock(m_mutex);

			sfSoundFile_seek(m_file,timeOffset.asMicroseconds());
		}
	}

	private
	{
		void initialize()
		{
			size_t sampleCount = cast(size_t)sfSoundFile_getSampleCount(m_file);

			uint channelCount = sfSoundFile_getChannelCount(m_file);

			uint sampleRate = sfSoundFile_getSampleRate(m_file);

			// Compute the music duration
			m_duration = Time.seconds(cast(float)(sampleCount) / sampleRate / channelCount);
			
			// Resize the internal buffer so that it can contain 1 second of audio samples
			m_samples.length = sampleRate * channelCount;

			// Initialize the stream
			super.initialize(channelCount, sampleRate);

		}
		
		sfSoundFile* m_file;
		Time m_duration;
		short[] m_samples;
		Mutex m_mutex;
	}
}

private extern(C):


