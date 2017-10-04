/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2017 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 */

/**
 * $(U InputSoundFile) decodes audio samples from a sound file. It is used
 * internally by higher-level classes such as $(SOUNDBUFFER_LINK) and
 * $(MUSIC_LINK), but can also be useful if you want to process or analyze audio
 * files without playing them, or if you want to implement your own version of
 * $(MUSIC_LINK) with more specific features.
 *
 * Example:
 * ---
 * // Open a sound file
 * auto file = new InputSoundFile();
 * if (!file.openFromFile("music.ogg"))
 * {
 *      //error
 * }
 *
 * // Print the sound attributes
 * writeln("duration: ", file.getDuration().total!"seconds");
 * writeln("channels: ", file.getChannelCount());
 * writeln("sample rate: ", file.getSampleRate());
 * writeln("sample count: ", file.getSampleCount());
 *
 * // Read and process batches of samples until the end of file is reached
 * short samples[1024];
 * long count;
 * do
 * {
 *     count = file.read(samples, 1024);
 *
 *     // process, analyze, play, convert, or whatever
 *     // you want to do with the samples...
 * }
 * while (count > 0);
 * ---
 *
 * See_Also:
 * $(OUTPUTSOUNDFILE_LINK)
 */
module dsfml.audio.inputsoundfile;

import std.string;
import dsfml.system.inputstream;
import dsfml.system.err;

public import core.time;

/**
 * Provide read access to sound files.
 */
class InputSoundFile
{
    private sfInputSoundFile* m_soundFile;

    //keeps an instance of the C++ interface stored if used
    private soundFileStream m_stream;

    /// Default constructor.
    this()
    {
        m_soundFile = sfInputSoundFile_create();
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config: destructorOutput;
        mixin(destructorOutput);
        sfInputSoundFile_destroy(m_soundFile);
    }

    /**
     * Open a sound file from the disk for reading.
     *
     * The supported audio formats are: WAV (PCM only), OGG/Vorbis, FLAC. The
     * supported sample sizes for FLAC and WAV are 8, 16, 24 and 32 bit.
     *
     * Params:
     *	filename = Path of the sound file to load
     *
     * Returns: true if the file was successfully opened.
     */
    bool openFromFile(const(char)[] filename)
    {
        import dsfml.system.string;
        bool toReturn = sfInputSoundFile_openFromFile(m_soundFile, filename.ptr, filename.length);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
        return toReturn;
    }

    /**
     * Open a sound file in memory for reading.
     *
     * The supported audio formats are: WAV (PCM only), OGG/Vorbis, FLAC. The
     * supported sample sizes for FLAC and WAV are 8, 16, 24 and 32 bit.
     *
     * Params:
     *	data = file data in memory
     *
     * Returns: true if the file was successfully opened.
     */
    bool openFromMemory(const(void)[] data)
    {
        import dsfml.system.string;
        bool toReturn = sfInputSoundFile_openFromMemory(m_soundFile, data.ptr, data.length);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
        return toReturn;
    }

    /**
     * Open a sound file from a custom stream for reading.
     *
     * The supported audio formats are: WAV (PCM only), OGG/Vorbis, FLAC. The
     * supported sample sizes for FLAC and WAV are 8, 16, 24 and 32 bit.
     *
     * Params:
     *	stream = Source stream to read from
     *
     * Returns: true if the file was successfully opened.
     */
    bool openFromStream(InputStream stream)
    {
        import dsfml.system.string;
        m_stream = new soundFileStream(stream);

        bool toReturn  = sfInputSoundFile_openFromStream(m_soundFile, m_stream);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
        return toReturn;
    }

    /**
     * Read audio samples from the open file.
     *
     * Params:
     *	samples = array of samples to fill
     *
     * Returns: Number of samples actually read (may be less samples.length)
     */
    long read(short[] samples)
    {
        return sfInputSoundFile_read(m_soundFile, samples.ptr, samples.length);

    }

    /**
     * Change the current read position to the given sample offset.
     *
     * This function takes a sample offset to provide maximum precision. If you
     * need to jump to a given time, use the other overload.
     *
     * The sample offset takes the channels into account. Offsets can be
     * calculated like this: sampleNumber * sampleRate * channelCount.
     * If the given offset exceeds to total number of samples, this function
     * jumps to the end of the sound file.
     *
     * Params:
     *	sampleOffset = Index of the sample to jump to, relative to the beginning
     */
    void seek(long sampleOffset)
    {
        sfInputSoundFile_seek(m_soundFile, sampleOffset);

        //Temporary fix for a bug where attempting to write to err
        //throws an exception in a thread created in C++. This causes
        //the program to explode. Hooray.

        //This fix will skip the call to err.write if there was no error
        //to report. If there is an error, well, the program will still explode,
        //but the user should see the error prior to the call that will make the
        //program explode.

        string temp = dsfml.system.string.toString(sfErr_getOutput());
        if(temp.length > 0)
        {
            err.write(temp);
        }
    }

    /**
     * Change the current read position to the given time offset.
     *
     * Using a time offset is handy but imprecise. If you need an accurate
     * result, consider using the overload which takes a sample offset.
     *
     * If the given time exceeds to total duration, this function jumps to the
     * end of the sound file.
     *
     * Params:
     *	timeOffset = Time to jump to, relative to the beginning
     */
    void seek(Duration timeOffset)
    {
        seek(timeOffset.total!"usecs");
    }

    /**
     * Get the total number of audio samples in the file
     *
     * Returns: Number of samples.
     */
    long getSampleCount()
    {
        return sfInputSoundFile_getSampleCount(m_soundFile);
    }

    /**
     * Get the sample rate of the sound
     *
     * Returns: Sample rate, in samples per second.
     */
    uint getSampleRate()
    {
        return sfInputSoundFile_getSampleRate(m_soundFile);
    }

    /**
     * Get the number of channels used by the sound
     *
     * Returns: Number of channels (1 = mono, 2 = stereo).
     */
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
