module dsfml.audio.soundbuffer;

import dsfml.audio.soundfile;
import dsfml.audio.sound;

import dsfml.system.inputstream;
import dsfml.system.time;

import std.stdio;

import std.string;

import std.algorithm;
import std.array;

class SoundBuffer
{

	
	this()
	{
		//create the buffer

		sfSoundSource_ensureALInit();

		//Create the buffer
		sfSoundBuffer_alGenBuffers(&m_buffer);
	}

	~this()
	{
		debug writeln("Destroying Sound Buffer");

		//Detach 
		foreach(Sound sound;m_sounds)
		{
			sound.resetBuffer();
		}

		sfSoundBuffer_alDeleteBuffer(&m_buffer);
	}

	//TODO: copy constructor
	
	bool loadFromFile(string filename)
	{
		sfSoundFile* file = sfSoundFile_create();
		scope(exit)
		{
			sfSoundFile_destroy(file);
		}


		if(sfSoundFile_openReadFromFile(file,toStringz(filename)))
		{
			return initialize(file);
		}
		
		return false;
	}
	
	bool loadFromMemory(const(void)* data,size_t sizeInBytes)
	{
		sfSoundFile* file = sfSoundFile_create();
		scope(exit)
		{
			sfSoundFile_destroy(file);
		}
		if(sfSoundFile_openReadFromMemory(file,data, sizeInBytes))
		{
			return initialize(file);
		}
		return false;
	}
	
	bool loadFromStream(InputStream stream)
	{
		sfSoundFile* file = sfSoundFile_create();
		scope(exit)
		{
			sfSoundFile_destroy(file);
		}
		if(sfSoundFile_openReadFromStream(file,&stream))
		{
			return initialize(file);
		}

		return false;
	}
	
	bool loadFromSamples(ref const(short[]) samples, uint channelCount, uint sampleRate)
	{
		if((samples.length >0) && (channelCount>0) && (sampleRate>0))
		{

			//copy new samples
			m_samples[] = samples[];
			//update Internal Buffer
			return update(channelCount, sampleRate);

		}
		else
		{
			//Error...

			stderr.writeln("Failed to load the buffer from samples");
			return false;
		}


	}


	
	bool saveToFile(string filename)
	{
		sfSoundFile* file = sfSoundFile_create();
		scope(exit)
		{
			sfSoundFile_destroy(file);
		}

		if(sfSoundFile_openWrite(file, toStringz(filename),getChannelCount(),getSampleRate()))
		{
			sfSoundFile_write(file, &m_samples[0], m_samples.length);

			return true;
		}

		return false;
	}
	
	
	const(short[]) getSamples()
	{
		return m_samples;
		
	}
	
	uint getSampleRate()
	{
		return sfSoundBuffer_getSampleRate(m_buffer);
	}
	
	uint getChannelCount()
	{
		return sfSoundBuffer_getChannelCount(m_buffer);
	}
	
	Time getDuration()
	{
		return m_duration;
	}

	package
	{
		void attachSound(Sound sound)
		{
			m_sounds ~=sound;
		}

		void detachSound(Sound sound)
		{
			int index;
			
			for(index = 0; index<m_sounds.length;++index)
			{
				if(sound is m_sounds[index])
				{
					break;
				}
			}
			
			
			m_sounds = m_sounds.remove(index);
		}

		uint m_buffer; /// OpenAL buffer identifier
	}

	private
	{
		bool initialize(sfSoundFile* file)
		{


			// Retrieve the sound parameters
			size_t sampleCount = cast(size_t)sfSoundFile_getSampleCount(file);
			uint channelCount = sfSoundFile_getChannelCount(file);
			uint sampleRate = sfSoundFile_getSampleRate(file);

			
			// Read the samples from the provided file
			m_samples.length = sampleCount;


			if (sfSoundFile_read(file, &m_samples[0], sampleCount) == sampleCount)
			{
				// Update the internal buffer with the new samples
				return update(channelCount, sampleRate);
			}
			else
			{
				return false;
			}


		}

		//TODO: Get this one set up later
		bool initialize(uint channelCount, uint sampleRate)
		{
			return false;
		}

		bool update(uint channelCount, uint sampleRate)
		{
			// Check parameters
			if ((channelCount == 0) || (sampleRate== 0) || (m_samples.length == 0))
			{
				return false;
			}


			// Find the good format according to the number of channels
			uint format = sfSoundStream_getFormatFromChannelCount(channelCount);


			// Check if the format is valid
			if (format == 0)
			{
				stderr.writeln("Failed to load sound buffer (unsupported number of channels: " ,channelCount, ")");
				return false;
			}

			//Fill the Buffer
			sfSoundBuffer_fillBuffer(m_buffer,&m_samples[0],m_samples.length,sampleRate, format);

			//Computer Duration
			m_duration = Time.milliseconds(1000 * m_samples.length / sampleRate / channelCount);


			return true;
		}






		short[] m_samples; /// Samples buffer
		Time m_duration; /// Sound duration
		Sound[] m_sounds; //Will this work?!
	}
	
}

private extern(C):

void sfSoundSource_ensureALInit();
uint sfSoundStream_getFormatFromChannelCount(uint channelCount);


void sfSoundBuffer_alGenBuffers(uint* bufferID);
void sfSoundBuffer_alDeleteBuffer(uint* bufferID);
uint sfSoundBuffer_getSampleRate(uint bufferID);
uint sfSoundBuffer_getChannelCount(uint bufferID);
void sfSoundBuffer_fillBuffer(uint bufferID, short* samples, long sampleSize, uint sampleRate, uint format);

