module dsfml.audio.soundsource;

import dsfml.system.vector3;

import std.stdio;
class SoundSource
{
	enum Status
	{
		Stopped,
		Paused,
		Playing
	}

	this(const ref SoundSource copy)
	{
		//Copy Constructor
	}

	protected this()
	{
		ensureALInit();

		SoundSourceInitialize(&m_source);
	}

	@property
	{
		void pitch(float newPitch)
		{
			SoundSourceSetPitch(m_source,newPitch);
		}
		float pitch()
		{
			return SoundSourceGetPitch(m_source);
		}
	}

	@property
	{
		void volume(float newVolume)
		{
			SoundSourceSetVolume(m_source,newVolume);
		}
		float volume()
		{
			return SoundSourceGetVolume(m_source);
		}
	}

	@property
	{
		void position(Vector3f newPosition)
		{
			SoundSourceSetPosition(m_source,newPosition.x, newPosition.y,newPosition.z);
		}
		Vector3f position()
		{
			Vector3f temp;

			SoundSourceGetPosition(m_source, &temp.x,&temp.y, &temp.z);

			return temp;
		}

	}

	@property
	{
		void relativeToListener(bool relative)
		{
			SoundSourceSetRelativeToListener(m_source, relative);
		}
		bool relativeToListener()
		{
			return SoundSourceIsRelativeToListener(m_source);
		}
	}

	@property
	{
		void minDistance(float distance)
		{
			SoundSourceSetMinDistance(m_source, distance);
		}
		float minDistance()
		{
			return SoundSourceGetMinDistance(m_source);
		}
	}

	@property
	{
		void attenuation(float newAttenuation)
		{
			SoundSourceSetAttenuation(m_source, newAttenuation);
		}
		float attenuation()
		{
			return SoundSourceGetAttenuation(m_source);
		}
	}


	~this()
	{
		debug writeln("Destroying SoundSource");
		SoundSourceDestroy(&m_source);
	}

	private int m_source;
}

extern(C):


void ensureALInit();

void SoundSourceInitialize(int* sourceID);

void SoundSourceSetPitch(uint sourceID, float pitch);

void SoundSourceSetVolume(uint sourceID, float volume);

void SoundSourceSetPosition(uint sourceID, float x, float y, float z);

void SoundSourceSetRelativeToListener(uint sourceID,bool relative);

void SoundSourceSetMinDistance(uint sourceID, float distance);

void SoundSourceSetAttenuation(uint sourceID, float attenuation);


float SoundSourceGetPitch(uint sourceID);

float SoundSourceGetVolume(uint sourceID);

void SoundSourceGetPosition(uint sourceID, float* x, float* y, float* z);

bool SoundSourceIsRelativeToListener(uint sourceID);

float SoundSourceGetMinDistance(uint sourceID);

float SoundSourceGetAttenuation(uint sourceID);

int SoundSourceGetStatus(uint sourceID);

void SoundSourceDestroy(int* souceID);

