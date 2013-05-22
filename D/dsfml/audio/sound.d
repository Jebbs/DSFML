module dsfml.audio.sound;

import dsfml.audio.soundbuffer;
import dsfml.audio.soundsource;

import dsfml.system.time;

import std.stdio;

class Sound : SoundSource
{
	this()
	{
		// Constructor code
	}

	this(SoundBuffer buffer)
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


	void setBuffer(SoundBuffer buffer)
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
			return Time.seconds(sfSound_getPlayingOffset(m_source));
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
		stop();

		//Detach the buffer
		sfSound_detachBuffer(m_source);
		m_buffer = null;
	}

	//Can't be const because of attach, detach and setBuffer, but won't change inside of sound
	private SoundBuffer m_buffer;
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



