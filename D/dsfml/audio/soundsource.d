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



	@property
	{
		void pitch(float newPitch)
		{
			sfSoundSource_setPitch(m_source,newPitch);
		}
		float pitch()
		{
			return sfSoundSource_getPitch(m_source);
		}
	}

	@property
	{
		void volume(float newVolume)
		{
			sfSoundSource_setVolume(m_source,newVolume);
		}
		float volume()
		{
			return sfSoundSource_getVolume(m_source);
		}
	}

	@property
	{
		void position(Vector3f newPosition)
		{
			sfSoundSource_setPosition(m_source,newPosition.x, newPosition.y,newPosition.z);
		}
		Vector3f position()
		{
			Vector3f temp;

			sfSoundSource_getPosition(m_source, &temp.x,&temp.y, &temp.z);

			return temp;
		}

	}

	@property
	{
		void relativeToListener(bool relative)
		{
			sfSoundSource_setRelativeToListener(m_source, relative);
		}
		bool relativeToListener()
		{
			return sfSoundSource_isRelativeToListener(m_source);
		}
	}

	@property
	{
		void minDistance(float distance)
		{
			sfSoundSource_setMinDistance(m_source, distance);
		}
		float minDistance()
		{
			return sfSoundSource_getMinDistance(m_source);
		}
	}

	@property
	{
		void attenuation(float newAttenuation)
		{
			sfSoundSource_setAttenuation(m_source, newAttenuation);
		}
		float attenuation()
		{
			return sfSoundSource_getAttenuation(m_source);
		}
	}


	~this()
	{
		debug writeln("Destroying SoundSource");
		sfSoundSource_destroy(&m_source);
	}

	protected
	{
		this()
		{
			sfSoundSource_ensureALInit();
			
			sfSoundSource_initialize(&m_source);
		}

		Status getStatus()
		{
			return cast(Status)sfSoundSource_getStatus(m_source);
		}

		uint m_source;
	}
}

private extern(C):


void sfSoundSource_ensureALInit();

void sfSoundSource_initialize(uint* sourceID);

void sfSoundSource_setPitch(uint sourceID, float pitch);

void sfSoundSource_setVolume(uint sourceID, float volume);

void sfSoundSource_setPosition(uint sourceID, float x, float y, float z);

void sfSoundSource_setRelativeToListener(uint sourceID,bool relative);

void sfSoundSource_setMinDistance(uint sourceID, float distance);

void sfSoundSource_setAttenuation(uint sourceID, float attenuation);


float sfSoundSource_getPitch(uint sourceID);

float sfSoundSource_getVolume(uint sourceID);

void sfSoundSource_getPosition(uint sourceID, float* x, float* y, float* z);

bool sfSoundSource_isRelativeToListener(uint sourceID);

float sfSoundSource_getMinDistance(uint sourceID);

float sfSoundSource_getAttenuation(uint sourceID);

int sfSoundSource_getStatus(uint sourceID);

void sfSoundSource_destroy(uint* souceID);

