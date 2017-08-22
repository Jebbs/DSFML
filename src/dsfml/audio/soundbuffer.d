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
 * A sound buffer holds the data of a sound, which is an array of audio samples.
 * A sample is a 16 bits signed integer that defines the amplitude of the sound
 * at a given time. The sound is then restituted by playing these samples at a
 * high rate (for example, 44100 samples per second is the standard rate used
 * for playing CDs). In short, audio samples are like texture pixels, and a
 * SoundBuffer is similar to a Texture.
 *
 * A sound buffer can be loaded from a file (see loadFromFile() for the complete
 * list of supported formats), from memory, from a custom stream
 * (see InputStream) or directly from an array of samples. It can also be saved
 * back to a file.
 *
 * Sound buffers alone are not very useful: they hold the audio data but cannot
 * be played. To do so, you need to use the sf::Sound class, which provides
 * functions to play/pause/stop the sound as well as changing the way it is
 * outputted (volume, pitch, 3D position, ...).
 *
 * This separation allows more flexibility and better performances: indeed a
 * SoundBuffer is a heavy resource, and any operation on it is slow (often too
 * slow for real-time applications). On the other side, a Sound is a lightweight
 * object, which can use the audio data of a sound buffer and change the way it
 * is played without actually modifying that data. Note that it is also possible
 * to bind several Sound instances to the same SoundBuffer.
 *
 * It is important to note that the Sound instance doesn't copy the buffer that
 * it uses, it only keeps a reference to it. Thus, a SoundBuffer must not be
 * destructed while it is used by a Sound (i.e. never write a function that uses
 * a local SoundBuffer instance for loading a sound).
 *
 *Example:
 * ---
 * // Declare a new sound buffer
 * auto buffer = SoundBuffer();
 *
 * // Load it from a file
 * if (!buffer.loadFromFile("sound.wav"))
 * {
 *     // error...
 * }
 *
 * // Create a sound source and bind it to the buffer
 * auto sound1 = new Sound();
 * sound1.setBuffer(buffer);
 *
 * // Play the sound
 * sound1.play();
 *
 * // Create another sound source bound to the same buffer
 * auto sound2 = new Sound();
 * sound2.setBuffer(buffer);
 *
 * // Play it with a higher pitch -- the first sound remains unchanged
 * sound2.pitch = 2;
 * sound2.play();
 * ---
 *
 * See_Also:
 * $(SOUND_LINK), $(SOUNDBUFFERRECORDER_LINK)
 */
module dsfml.audio.soundbuffer;

public import core.time;

import dsfml.audio.inputsoundfile;
import dsfml.audio.sound;

import dsfml.system.inputstream;

import std.stdio;

import std.string;

import std.algorithm;
import std.array;

import dsfml.system.err;

/**
 * Storage for audio samples defining a sound.
 */
class SoundBuffer
{
    package sfSoundBuffer* sfPtr;

    /// Default constructor.
    this()
    {
        import dsfml.system.string;
        sfPtr = sfSoundBuffer_construct();
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfSoundBuffer_destroy(sfPtr);
    }

    /**
     * Get the array of audio samples stored in the buffer.
     *
     * The format of the returned samples is 16 bits signed integer (short).
     *
     *  Returns: Read-only array of sound samples.
     */
    const(short[]) getSamples() const
    {
        auto sampleCount = sfSoundBuffer_getSampleCount(sfPtr);
        if(sampleCount > 0)
            return sfSoundBuffer_getSamples(sfPtr)[0 .. sampleCount];

        return null;
    }

    /**
     * Get the sample rate of the sound.
     *
     * The sample rate is the number of samples played per second. The higher,
     * the better the quality (for example, 44100 samples/s is CD quality).
     *
     * Returns: Sample rate (number of samples per second).
     */
    uint getSampleRate() const
    {
        return sfSoundBuffer_getSampleRate(sfPtr);
    }

    /**
     * Get the number of channels used by the sound.
     *
     * If the sound is mono then the number of channels will be 1, 2 for stereo,
     * etc.
     *
     * Returns: Number of channels.
     */
    uint getChannelCount() const
    {
        return sfSoundBuffer_getChannelCount(sfPtr);
    }

    /**
     * Get the total duration of the sound.
     *
     * Returns: Sound duration.
     */
    Duration getDuration() const
    {
        import core.time;
        return usecs(sfSoundBuffer_getDuration(sfPtr));
    }

    /**
     * Load the sound buffer from a file.
     *
     * The supported audio formats are: WAV (PCM only), OGG/Vorbis, FLAC. The
     * supported sample sizes for FLAC and WAV are 8, 16, 24 and 32 bit.
     *
     * Params:
     * 		filename =	Path of the sound file to load
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromFile(const(char)[] filename)
    {
        import dsfml.system.string;
        if(sfSoundBuffer_loadFromFile(sfPtr, filename.ptr, filename.length))
        {
            return true;
        }
        else
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
            return false;
        }
    }

    /**
     * Load the sound buffer from a file in memory.
     *
     * The supported audio formats are: WAV (PCM only), OGG/Vorbis, FLAC. The
     * supported sample sizes for FLAC and WAV are 8, 16, 24 and 32 bit.
     *
     * Params:
     * 		data =	The array of data
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromMemory(const(void)[] data)
    {
        if(sfSoundBuffer_loadFromMemory(sfPtr, data.ptr, data.length))
        {
            return true;
        }
        else
        {
            import dsfml.system.string;
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
            return false;
        }
    }

    /*
     * Load the sound buffer from a custom stream.
     *
     * The supported audio formats are: WAV (PCM only), OGG/Vorbis, FLAC. The
     * supported sample sizes for FLAC and WAV are 8, 16, 24 and 32 bit.
     *
     * Params:
     * 		stream =	Source stream to read from
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream stream)
    {
        if(sfSoundBuffer_loadFromStream(sfPtr, new SoundBufferStream(stream)))
        {
            return true;
        }
        else
        {
            import dsfml.system.string;
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
            return false;
        }
    }

    /**
     * Load the sound buffer from an array of audio samples.
     *
     * The assumed format of the audio samples is 16 bits signed integer
     * (short).
     *
     * Params:
     * 		samples      = Array of samples in memory
     * 		channelCount = Number of channels (1 = mono, 2 = stereo, ...)
     * 		sampleRate   = Sample rate (number of samples to play per second)
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromSamples(const(short[]) samples, uint channelCount, uint sampleRate)
    {
        if(sfSoundBuffer_loadFromSamples(sfPtr, samples.ptr, samples.length, channelCount, sampleRate))
        {
            return true;
        }
        else
        {
            import dsfml.system.string;
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
            return false;
        }
    }

    /**
     * Save the sound buffer to an audio file.
     *
     * The supported audio formats are: WAV, OGG/Vorbis, FLAC.
     *
     * Params:
     * 		filename =	Path of the sound file to write
     *
     * Returns: true if saving succeeded, false if it failed.
     */
    bool saveToFile(const(char)[] filename)
    {
        import dsfml.system.string;
        if(sfSoundBuffer_saveToFile(sfPtr, filename.ptr, filename.length))
        {
            return true;
        }
        else
        {

            err.write(dsfml.system.string.toString(sfErr_getOutput()));
            return false;
        }
    }

}

unittest
{
    version(DSFML_Unittest_Audio)
    {
        import std.stdio;

        writeln("Unit test for sound buffer");

        auto soundbuffer = new SoundBuffer();

        if(!soundbuffer.loadFromFile("res/TestSound.ogg"))
        {
            //error
            return;
        }

        writeln("Sample Rate: ", soundbuffer.getSampleRate());

        writeln("Channel Count: ", soundbuffer.getChannelCount());

        writeln("Duration: ", soundbuffer.getDuration().total!"seconds");

        writeln("Sample Count: ", soundbuffer.getSamples().length);

        //use sound buffer here

        writeln();
    }
}


private extern(C++) interface sfmlInputStream
{
    long read(void* data, long size);

    long seek(long position);

    long tell();

    long getSize();
}


private class SoundBufferStream:sfmlInputStream
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

package struct sfSoundBuffer;

private extern(C):

sfSoundBuffer* sfSoundBuffer_construct();

bool sfSoundBuffer_loadFromFile(sfSoundBuffer* soundBuffer, const char* filename, size_t length);

bool sfSoundBuffer_loadFromMemory(sfSoundBuffer* soundBuffer, const void* data, size_t sizeInBytes);

bool sfSoundBuffer_loadFromStream(sfSoundBuffer* soundBuffer, sfmlInputStream stream);

bool sfSoundBuffer_loadFromSamples(sfSoundBuffer* soundBuffer, const short* samples, size_t sampleCount, uint channelCount, uint sampleRate);

sfSoundBuffer* sfSoundBuffer_copy(const sfSoundBuffer* soundBuffer);

void sfSoundBuffer_destroy(sfSoundBuffer* soundBuffer);

bool sfSoundBuffer_saveToFile(const sfSoundBuffer* soundBuffer, const char* filename, size_t length);

const(short)* sfSoundBuffer_getSamples(const sfSoundBuffer* soundBuffer);

size_t sfSoundBuffer_getSampleCount(const sfSoundBuffer* soundBuffer);

uint sfSoundBuffer_getSampleRate(const sfSoundBuffer* soundBuffer);

uint sfSoundBuffer_getChannelCount(const sfSoundBuffer* soundBuffer);

long sfSoundBuffer_getDuration(const sfSoundBuffer* soundBuffer);

const(char)* sfErr_getOutput();
