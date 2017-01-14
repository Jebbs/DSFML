/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

module dsfml.audio.inputsoundfile;

import std.string;
import dsfml.system.inputstream;
import dsfml.system.err;

package:

struct InputSoundFile
{
	private sfInputSoundFile* m_soundFile;
	private soundFileStream m_stream;//keeps an instance of the C++ interface stored if used

	void create()
	{
		m_soundFile = sfInputSoundFile_create();
	}

	~this()
	{
		sfInputSoundFile_destroy(m_soundFile);
	}

	bool openFromFile(const(char)[] filename)
	{
		import dsfml.system.string;
		bool toReturn = sfInputSoundFile_openFromFile(m_soundFile, filename.ptr, filename.length);
		err.write(toString(sfErr_getOutput()));
		return toReturn;
	}

	bool openFromMemory(const(void)[] data)
	{
		import dsfml.system.string;
		bool toReturn = sfInputSoundFile_openFromMemory(m_soundFile, data.ptr, data.length);
		err.write(toString(sfErr_getOutput()));
		return toReturn;
	}
	bool openFromStream(InputStream stream)
	{
		import dsfml.system.string;
		m_stream = new soundFileStream(stream);

		bool toReturn  = sfInputSoundFile_openFromStream(m_soundFile, m_stream);
		err.write(toString(sfErr_getOutput()));
		return toReturn;
	}

	long read(ref short[] data)
	{
		return sfInputSoundFile_read(m_soundFile,data.ptr, data.length);

	}

	void seek(long timeOffset)
	{
		import dsfml.system.string;
		sfInputSoundFile_seek(m_soundFile, timeOffset);

		//Temporary fix for a bug where attempting to write to err
		//throws an exception in a thread created in C++. This causes
		//the program to explode. Hooray.

		//This fix will skip the call to err.write if there was no error
		//to report. If there is an error, well, the program will still explode,
		//but the user should see the error prior to the call that will make the
		//program explode.

		string temp = toString(sfErr_getOutput());
		if(temp.length > 0)
		{
		    err.write(temp);
		}
	}

	long getSampleCount()
	{
		return sfInputSoundFile_getSampleCount(m_soundFile);
	}
	uint getSampleRate()
	{
		return sfInputSoundFile_getSampleRate(m_soundFile);
	}
	uint getChannelCount()
	{
		return sfInputSoundFile_getChannelCount(m_soundFile);
	}




}

private
{

extern(C++) interface soundInputStream
{
	long read(void* data, long size);

	long seek(long position);

	long tell();

	long getSize();
}


class soundFileStream:soundInputStream
{
	private InputStream myStream;

	this(InputStream stream)
	{
		myStream = stream;
	}

	extern(C++)long read(void* data, long size)
	{
		return myStream.read(data[0..cast(size_t)size]);
	}

	extern(C++)long seek(long position)
	{
		return myStream.seek(position);
	}

	extern(C++)long tell()
	{
		return myStream.tell();
	}

	extern(C++)long getSize()
	{
		return myStream.getSize();
	}
}


extern(C) const(char)* sfErr_getOutput();


extern(C)
{

struct sfInputSoundFile;

sfInputSoundFile* sfInputSoundFile_create();

void sfInputSoundFile_destroy(sfInputSoundFile* file);

long sfInputSoundFile_getSampleCount(const sfInputSoundFile* file);

uint sfInputSoundFile_getChannelCount( const sfInputSoundFile* file);

uint sfInputSoundFile_getSampleRate(const sfInputSoundFile* file);

bool sfInputSoundFile_openFromFile(sfInputSoundFile* file, const char* filename, size_t length);

bool sfInputSoundFile_openFromMemory(sfInputSoundFile* file,const(void)* data, long sizeInBytes);

bool sfInputSoundFile_openFromStream(sfInputSoundFile* file, soundInputStream stream);

bool sfInputSoundFile_openForWriting(sfInputSoundFile* file, const(char)* filename,uint channelCount,uint sampleRate);

long sfInputSoundFile_read(sfInputSoundFile* file, short* data, long sampleCount);

void sfInputSoundFile_seek(sfInputSoundFile* file, long timeOffset);
	}
}
