/*
Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty. 
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, 
and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
*/

module dsfml.audio;

import std.string;
debug import std.stdio;

public import dsfml.system;


//final and abstract to force not being instanced 
final abstract class Listener
{
	@property
	{
		static void GlobalVolume(float volume)
		{
			sfListener_setGlobalVolume(volume);
		}
		static float GlobalVolume()
		{
			return sfListener_getGlobalVolume();
		}

	}

	@property
	{
		void Position(Vector3f position)
		{
			sfListener_setPosition(position.tosfVector3f());
		}
		Vector3f Position()
		{
			return Vector3f(sfListener_getPosition());
		}
	}

	@property
	{
		void Direction(Vector3f orientation)
		{
			sfListener_setDirection(orientation.tosfVector3f());
		}
		Vector3f Direction()
		{
			return Vector3f(sfListener_getDirection());
		}
	}
}


class Music
{
	package sfMusic* sfPtr;

	this()
	{
		//Creates a null Music
	}
	
	bool loadFromFile(string filename)
	{
		sfPtr = sfMusic_createFromFile(toStringz(filename));
		return (sfPtr == null)?false:true;
	}

	bool loadFromMemory(const(void)* data,size_t sizeInBytes)
	{
		sfPtr = sfMusic_createFromMemory(data,sizeInBytes);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(ref sfInputStream stream)
	{
		sfPtr = sfMusic_createFromStream(&stream);
		return (sfPtr == null)?false:true;
	}
	
	~this()
	{
		debug writeln("Destroying Music");
		sfMusic_destroy(sfPtr);
	}

	@property
	{
		void isLooping(bool loop)
		{
			loop?sfMusic_setLoop(sfPtr,sfTrue):sfMusic_setLoop(sfPtr,sfFalse);
		}
		bool isLooping()
		{
			return (sfMusic_getLoop(sfPtr) == sfTrue)?true: false;
		}
	}

	@property
	{
		Time duration()
		{
			return Time(sfMusic_getDuration(sfPtr));
		}
	}

	void play()
	{
		sfMusic_play(sfPtr);
	}

	void pause()
	{
		sfMusic_pause(sfPtr);
	}

	void stop()
	{
		sfMusic_stop(sfPtr);
	}

	@property
	{
		uint channelCount()
		{
			return sfMusic_getChannelCount(sfPtr);
		}
	}

	@property
	{
		uint sampleRate()
		{
			return sfMusic_getSampleRate(sfPtr);
		}
	}
	@property
	{
		SoundStatus status()
		{
			return sfMusic_getStatus(sfPtr);
		}
	}

	@property
	{
		void playingOffset(Time offset)
		{
			sfMusic_setPlayingOffset(sfPtr, offset.asMilliseconds());
		}
		Time playingOffset()
		{
			return Time(sfMusic_getPlayingOffset(sfPtr));
		}
	}

	@property
	{
		void pitch(float setPitch)
		{
			sfMusic_setPitch(sfPtr,setPitch);
		}
		float pitch()
		{
			return sfMusic_getPitch(sfPtr);
		}
	}

	@property
	{
		void volume(float setVolume)
		{
			sfMusic_setVolume(sfPtr,setVolume);
		}
		float volume()
		{
			return sfMusic_getVolume(sfPtr);
		}
	}

	@property
	{
		void position(Vector3f setPosition)
		{
			sfMusic_setPosition(sfPtr, setPosition.tosfVector3f());
		}
		Vector3f position()
		{
			return Vector3f(sfMusic_getPosition(sfPtr));
		}
	}

	@property
	{
		void relativeToListener(bool relative)
		{
			relative?sfMusic_setRelativeToListener(sfPtr,sfTrue):sfMusic_setRelativeToListener(sfPtr,sfFalse);
		}
		bool relativeToListener()
		{
			return (sfMusic_isRelativeToListener(sfPtr) == sfTrue)?true:false;
		}
	}

	@property
	{
		void minDistance(float distance)
		{
			sfMusic_setMinDistance(sfPtr,distance);
		}

		float minDistance()
		{
			return sfMusic_getMinDistance(sfPtr);
		}
	}

	@property
	{
		void attenuation(float setAttenuation)
		{
			sfMusic_setAttenuation(sfPtr, setAttenuation);
		}
		float attenuation()
		{
			return sfMusic_getAttenuation(sfPtr);
		}
		
	}

}


class Sound
{
	sfSound* sfPtr;
	this()
	{
		sfPtr = sfSound_create();
	}
	this(const(SoundBuffer) soundBuffer)
	{
		sfPtr = sfSound_create();
		sfSound_setBuffer(sfPtr,soundBuffer.sfPtr);
	}
	~this()
	{
		debug writeln("Destroying Sound");
		sfSound_destroy(sfPtr);
	}
	void play()
	{
		sfSound_play(sfPtr);
	}
	
	void pause()
	{
		sfSound_pause(sfPtr);
	}
	
	void stop()
	{
		sfSound_stop(sfPtr);
	}

	@property
	{
		void buffer(const(SoundBuffer) soundBuffer)
		{
			sfSound_setBuffer(sfPtr,soundBuffer.sfPtr);
		}
		//Returns a read only copy of the current sound buffer
		const(SoundBuffer) buffer()
		{
			return new SoundBuffer(sfSound_getBuffer(sfPtr));

		}
	}

	@property
	{
		void isLooping(bool loop)
		{
		loop?sfSound_setLoop(sfPtr,sfTrue):sfSound_setLoop(sfPtr,sfFalse);
		}
		bool isLooping()
		{
			return (sfSound_getLoop(sfPtr) == sfTrue)?true: false;
		}
	}

	@property
	{
		SoundStatus status()
		{
			return sfSound_getStatus(sfPtr);
		}
	}
	
	@property
	{
		void playingOffset(Time offset)
		{
			sfSound_setPlayingOffset(sfPtr, offset.InternalsfTime);
		}
		Time playingOffset()
		{
			return Time(sfSound_getPlayingOffset(sfPtr));
		}
	}
	
	@property
	{
		void pitch(float setPitch)
		{
			sfSound_setPitch(sfPtr,setPitch);
		}
		float pitch()
		{
			return sfSound_getPitch(sfPtr);
		}
	}
	
	@property
	{
		void volume(float setVolume)
		{
			sfSound_setVolume(sfPtr,setVolume);
		}
		float volume()
		{
			return sfSound_getVolume(sfPtr);
		}
	}
	
	@property
	{
		void position(Vector3f setPosition)
		{
			sfSound_setPosition(sfPtr, setPosition.tosfVector3f());
		}
		Vector3f position()
		{
			return Vector3f(sfSound_getPosition(sfPtr));
		}
	}
	
	@property
	{
		void relativeToListener(bool relative)
		{
		relative?sfSound_setRelativeToListener(sfPtr,sfTrue):sfSound_setRelativeToListener(sfPtr,sfFalse);
		}
		bool relativeToListener()
		{
			return (sfSound_isRelativeToListener(sfPtr) == sfTrue)?true:false;
		}
	}
	
	@property
	{
		void minDistance(float distance)
		{
			sfSound_setMinDistance(sfPtr,distance);
		}
		
		float minDistance()
		{
			return sfSound_getMinDistance(sfPtr);
		}
	}
	
	@property
	{
		void attenuation(float setAttenuation)
		{
			sfSound_setAttenuation(sfPtr, setAttenuation);
		}
		float attenuation()
		{
			return sfSound_getAttenuation(sfPtr);
		}
		
		
	}


}


class SoundBuffer
{
	sfSoundBuffer* sfPtr;

	this()
	{
		//Creates a null 
	}

	bool loadFromFile(string filename)
	{
		sfPtr = sfSoundBuffer_createFromFile(toStringz(filename));
		return (sfPtr == null)?false:true;
	}

	bool loadFromMemory(const(void)* data,size_t sizeInBytes)
	{
		sfPtr = sfSoundBuffer_createFromMemory(data,sizeInBytes);
		return (sfPtr == null)?false:true;
	}

	bool loadFromStream(ref sfInputStream stream)
	{
		sfPtr = sfSoundBuffer_createFromStream(&stream);
		return (sfPtr == null)?false:true;
	}

	bool loadFromSamples(ref const(short[]) samples, uint channelCount, uint sampleRate)
	{
		sfPtr = sfSoundBuffer_createFromSamples(samples.ptr, samples.length, channelCount, sampleRate);
		return (sfPtr == null)?false:true;
	}
	package this(const(sfSoundBuffer)* copy)
	{
		sfPtr = sfSoundBuffer_copy(copy);
	}
	~this()
	{
		debug writeln("Destroying Sound Buffer");
		sfSoundBuffer_destroy(sfPtr);
	}

	bool saveToFile(const(char)* filename)
	{
		return (sfSoundBuffer_saveToFile(sfPtr, filename) == 1)?true:false;
	}


	const(short[]) getSamples()
	{
		return sfSoundBuffer_getSamples(sfPtr)[0..sfSoundBuffer_getSampleCount(sfPtr)];

	}

	uint getSampleRate()
	{
		return sfSoundBuffer_getSampleRate(sfPtr);
	}

	uint getChannelCount()
	{
		return sfSoundBuffer_getChannelCount(sfPtr);
	}

	Time getDuration()
	{
		return Time(sfSoundBuffer_getDuration(sfPtr));
	}

}


class SoundBufferRecorder
{
	sfSoundBufferRecorder* sfPtr;

	this()
	{
		sfPtr = sfSoundBufferRecorder_create();
	}

	~this()
	{
		debug writeln("Destroying Sound Buffer Recorder");
		sfSoundBufferRecorder_destroy(sfPtr);
	}

	void start(uint sampleRate)
	{
		sfSoundBufferRecorder_start(sfPtr, sampleRate);
	}

	void stop()
	{
		sfSoundBufferRecorder_stop(sfPtr);
	}

	uint getSampleRate()
	{
		return sfSoundBufferRecorder_getSampleRate(sfPtr);
	}

	const(SoundBuffer) getBuffer()
	{
		return new SoundBuffer(sfSoundBufferRecorder_getBuffer(sfPtr));
	}


}



//SoundRecorder planned for Revision 2(for when I have more time to look into C callbacks)


//SoundStreams planned for Revision 2(for when I have more time to look into C callbacks)



package:
struct sfMusic;
struct sfSound;
struct sfSoundBuffer;
struct sfSoundBufferRecorder;
struct sfSoundRecorder;
struct sfSoundStream;

//Sound Recorder 
extern(C)
{
	alias sfBool function(void*) sfSoundRecorderStartCallback;
	alias sfBool function(const(short)*,size_t,void*) sfSoundRecorderProcessCallback;
	alias void function(void*) sfSoundRecorderStopCallback;
}



enum SoundStatus
{
	Stopped,
	Paused,
	Playing,
}


struct sfSoundStreamChunk
{
	short* samples;
	uint sampleCount;
}

extern(C)
{
	alias sfBool function(sfSoundStreamChunk*,void*) sfSoundStreamGetDataCallback;
	alias void function(sfTime,void*) sfSoundStreamSeekCallback;
}


package extern(C)
{

	//Listener
	void  sfListener_setGlobalVolume(float volume);
	float sfListener_getGlobalVolume();
	void sfListener_setPosition(sfVector3f position);
	sfVector3f sfListener_getPosition();
	void sfListener_setDirection(sfVector3f orientation);
	sfVector3f sfListener_getDirection();

	//Music
	sfMusic* sfMusic_createFromFile(const(char)* filename);
	sfMusic* sfMusic_createFromMemory(const(void)* data,size_t sizeInBytes);
	sfMusic* sfMusic_createFromStream(sfInputStream* stream);
	void  sfMusic_destroy(sfMusic* music);
	void  sfMusic_setLoop(sfMusic* music,sfBool loop);
	sfBool sfMusic_getLoop(const(sfMusic)* music);
	sfTime sfMusic_getDuration(const(sfMusic)* music);
	void sfMusic_play(sfMusic* music);
	void sfMusic_pause(sfMusic* music);
	void sfMusic_stop(sfMusic* music);
	uint sfMusic_getChannelCount(const(sfMusic)* music);
	uint sfMusic_getSampleRate(const(sfMusic)* music);
	SoundStatus sfMusic_getStatus(const(sfMusic)* music);
	sfTime sfMusic_getPlayingOffset(const(sfMusic)* music);
	void sfMusic_setPitch(sfMusic* music,float pitch);
	void sfMusic_setVolume(sfMusic* music,float volume);
	void sfMusic_setPosition(sfMusic* music,sfVector3f position);
	void sfMusic_setRelativeToListener(sfMusic* music,sfBool relative);
	void sfMusic_setMinDistance(sfMusic* music,float distance);
	void sfMusic_setAttenuation(sfMusic* music,float attenuation);
	void sfMusic_setPlayingOffset(sfMusic* music,int timeOffset);
	float sfMusic_getPitch(const(sfMusic)* music);
	float sfMusic_getVolume(const(sfMusic)* music);
	sfVector3f sfMusic_getPosition(const(sfMusic)* music);
	sfBool sfMusic_isRelativeToListener(const(sfMusic)* music);
	float sfMusic_getMinDistance(const(sfMusic)* music);
	float sfMusic_getAttenuation(const(sfMusic)* music);

	//Sound
	sfSound* sfSound_create();
	sfSound* sfSound_copy(const(sfSound)* sound);
	void sfSound_destroy(sfSound* sound);
	void sfSound_play(sfSound* sound);
	void sfSound_pause(sfSound* sound);
	void sfSound_stop(sfSound* sound);
	void sfSound_setBuffer(sfSound* sound,const(sfSoundBuffer)* buffer);
	const(sfSoundBuffer)* sfSound_getBuffer(const(sfSound)* sound);
	void sfSound_setLoop(sfSound* sound,sfBool loop);
	sfBool sfSound_getLoop(const(sfSound)* sound);
	SoundStatus sfSound_getStatus(const(sfSound)* sound);
	void sfSound_setPitch(sfSound* sound,float pitch);
	void sfSound_setVolume(sfSound* sound,float volume);
	void sfSound_setPosition(sfSound* sound,sfVector3f position);
	void sfSound_setRelativeToListener(sfSound* sound,sfBool relative);
	void sfSound_setMinDistance(sfSound* sound,float distance);
	void sfSound_setAttenuation(sfSound* sound,float attenuation);
	void sfSound_setPlayingOffset(sfSound* sound,sfTime timeOffset);
	float sfSound_getPitch(const(sfSound)* sound);
	float sfSound_getVolume(const(sfSound)* sound);
	sfVector3f sfSound_getPosition(const(sfSound)* sound);
	sfBool sfSound_isRelativeToListener(const(sfSound)* sound);
	float sfSound_getMinDistance(const(sfSound)* sound);
	float sfSound_getAttenuation(const(sfSound)* sound);
	sfTime sfSound_getPlayingOffset(const(sfSound)* sound);

	//Sound Buffer
	sfSoundBuffer* sfSoundBuffer_createFromFile(const(char)* filename);
	sfSoundBuffer* sfSoundBuffer_createFromMemory(const(void)* data,size_t sizeInBytes);
	sfSoundBuffer* sfSoundBuffer_createFromStream(sfInputStream* stream);
	sfSoundBuffer* sfSoundBuffer_createFromSamples(const(short)* samples,size_t sampleCount,uint channelCount,uint sampleRate);
	sfSoundBuffer* sfSoundBuffer_copy(const(sfSoundBuffer)* soundBuffer);
	void sfSoundBuffer_destroy(sfSoundBuffer* soundBuffer);
	sfBool sfSoundBuffer_saveToFile(const(sfSoundBuffer)* soundBuffer,const(char)* filename);
	const(short)* sfSoundBuffer_getSamples(const(sfSoundBuffer)* soundBuffer);
	size_t sfSoundBuffer_getSampleCount(const(sfSoundBuffer)* soundBuffer);
	uint sfSoundBuffer_getSampleRate(const(sfSoundBuffer)* soundBuffer);
	uint sfSoundBuffer_getChannelCount(const(sfSoundBuffer)* soundBuffer);
	sfTime sfSoundBuffer_getDuration(const(sfSoundBuffer)* soundBuffer);

	//Sound Buffer Recorder
	sfSoundBufferRecorder* sfSoundBufferRecorder_create();
	void sfSoundBufferRecorder_destroy(sfSoundBufferRecorder* soundBufferRecorder);
	void sfSoundBufferRecorder_start(sfSoundBufferRecorder* soundBufferRecorder,uint sampleRate);
	void sfSoundBufferRecorder_stop(sfSoundBufferRecorder* soundBufferRecorder);
	uint sfSoundBufferRecorder_getSampleRate(const(sfSoundBufferRecorder)* soundBufferRecorder);
	const(sfSoundBuffer)* sfSoundBufferRecorder_getBuffer(const(sfSoundBufferRecorder)* soundBufferRecorder);

	//SoundRecorder
	sfSoundRecorder* sfSoundRecorder_create(sfSoundRecorderStartCallback onStart,sfSoundRecorderProcessCallback onProcess,sfSoundRecorderStopCallback onStop,void* userData);
	void sfSoundRecorder_destroy(sfSoundRecorder* soundRecorder);
	void sfSoundRecorder_start(sfSoundRecorder* soundRecorder,uint sampleRate);
	void sfSoundRecorder_stop(sfSoundRecorder* soundRecorder);
	uint sfSoundRecorder_getSampleRate(const(sfSoundRecorder)* soundRecorder);
	sfBool sfSoundRecorder_isAvailable();

	//SoundStream
	sfSoundStream* sfSoundStream_create(sfSoundStreamGetDataCallback onGetData,sfSoundStreamSeekCallback onSeek,uint channelCount,int sampleRate,void* userData);
	void sfSoundStream_destroy(sfSoundStream* soundStream);
	void sfSoundStream_play(sfSoundStream* soundStream);
	void sfSoundStream_pause(sfSoundStream* soundStream);
	void sfSoundStream_stop(sfSoundStream* soundStream);
	SoundStatus sfSoundStream_getStatus(const(sfSoundStream)* soundStream);
	uint sfSoundStream_getChannelCount(const(sfSoundStream)* soundStream);
	uint sfSoundStream_getSampleRate(const(sfSoundStream)* soundStream);
	void sfSoundStream_setPitch(sfSoundStream* soundStream,float pitch);
	void sfSoundStream_setVolume(sfSoundStream* soundStream,float volume);
	void sfSoundStream_setPosition(sfSoundStream* soundStream,sfVector3f position);
	void sfSoundStream_setRelativeToListener(sfSoundStream* soundStream,sfBool relative);
	void sfSoundStream_setMinDistance(sfSoundStream* soundStream,float distance);
	void sfSoundStream_setAttenuation(sfSoundStream* soundStream,float attenuation);
	void sfSoundStream_setPlayingOffset(sfSoundStream* soundStream,sfTime timeOffset);
	void sfSoundStream_setLoop(sfSoundStream* soundStream,sfBool loop);
	float sfSoundStream_getPitch(const(sfSoundStream)* soundStream);
	float sfSoundStream_getVolume(const(sfSoundStream)* soundStream);
	sfVector3f sfSoundStream_getPosition(const(sfSoundStream)* soundStream);
	sfBool sfSoundStream_isRelativeToListener(const(sfSoundStream)* soundStream);
	float sfSoundStream_getMinDistance(const(sfSoundStream)* soundStream);
	float sfSoundStream_getAttenuation(const(sfSoundStream)* soundStream);
	sfBool sfSoundStream_getLoop(const(sfSoundStream)* soundStream);
	sfTime sfSoundStream_getPlayingOffset(const(sfSoundStream)* soundStream);
}