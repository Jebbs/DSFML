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

module dsfml.audio.soundfile;

import std.string;
import dsfml.system.inputstream;
import dsfml.system.err;
import std.conv;

package:

struct SoundFile
{
	private sfSoundFile* m_soundFile;
	private soundFileStream m_stream;//keeps an instance of the C++ interface stored if used

	void create()
	{
		m_soundFile = sfSoundFile_create();
	}
	
	~this()
	{
		sfSoundFile_destroy(m_soundFile);
	}

	bool openReadFromFile(string filename)
	{
		bool toReturn = sfSoundFile_openReadFromFile(m_soundFile, toStringz(filename));
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}

	bool openReadFromMemory(const(void)[] data)
	{
		bool toReturn = sfSoundFile_openReadFromMemory(m_soundFile, data.ptr, data.length);
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}
	bool openReadFromStream(InputStream stream)
	{
		m_stream = new soundFileStream(stream);

		bool toReturn  = sfSoundFile_openReadFromStream(m_soundFile, m_stream);
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}

	bool openWrite(string filename,uint channelCount,uint sampleRate)
	{
		bool toReturn = sfSoundFile_openWrite(m_soundFile, toStringz(filename),channelCount,sampleRate);
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}

	long read(ref short[] data)
	{
		return sfSoundFile_read(m_soundFile,data.ptr, data.length);

	}

	void write(const(short)[] data)
	{
		sfSoundFile_write(m_soundFile, data.ptr, data.length);
	}

	void seek(long timeOffset)
	{
		sfSoundFile_seek(m_soundFile, timeOffset);
		err.write(text(sfErr_getOutput()));
	}

	long getSampleCount()
	{
		return sfSoundFile_getSampleCount(m_soundFile);
	}
	uint getSampleRate()
	{
		return sfSoundFile_getSampleRate(m_soundFile);
	}
	uint getChannelCount()
	{
		return sfSoundFile_getChannelCount(m_soundFile);
	}




}

private
{

extern(C++) interface sfmlInputStream
{
	long read(void* data, long size);
	
	long seek(long position);
	
	long tell();
	
	long getSize();
}


class soundFileStream:sfmlInputStream
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

struct sfSoundFile;

sfSoundFile* sfSoundFile_create();

void sfSoundFile_destroy(sfSoundFile* file);

long sfSoundFile_getSampleCount(const sfSoundFile* file);

uint sfSoundFile_getChannelCount( const sfSoundFile* file);

uint sfSoundFile_getSampleRate(const sfSoundFile* file);

bool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename);

bool sfSoundFile_openReadFromMemory(sfSoundFile* file,const(void)* data, long sizeInBytes);

bool sfSoundFile_openReadFromStream(sfSoundFile* file, sfmlInputStream stream);

//bool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream);

bool sfSoundFile_openWrite(sfSoundFile* file, const(char)* filename,uint channelCount,uint sampleRate);

long sfSoundFile_read(sfSoundFile* file, short* data, long sampleCount);

void sfSoundFile_write(sfSoundFile* file, const short* data, long sampleCount);

void sfSoundFile_seek(sfSoundFile* file, long timeOffset);
	}
}
