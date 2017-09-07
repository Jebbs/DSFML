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
  * This class encodes audio samples to a sound file.
 *
 * It is used internally by higher-level classes such as SoundBuffer, but can
 * also be useful if you want to create audio files from custom data sources,
 * like generated audio samples.
 *
 * Example:
 * ---
 * // Create a sound file, ogg/vorbis format, 44100 Hz, stereo
 * auto file = new OutputSoundFile();
 * if (!file.openFromFile("music.ogg", 44100, 2))
 * {
 *     //error
 * }
 *
 * while (...)
 * {
 *     // Read or generate audio samples from your custom source
 *     short[] samples = ...;
 *
 *     // Write them to the file
 *     file.write(samples);
 * }
 * ---
 *
 * See_Also:
 * $(INPUTSOUNDFILE_LINK)
 */
module dsfml.audio.outputsoundfile;

import std.string;
import dsfml.system.err;

/**
 * Provide write access to sound files.
 */
class OutputSoundFile
{
    private sfOutputSoundFile* m_soundFile;

    /// Default constructor.
    this()
    {
        m_soundFile = sfOutputSoundFile_create();
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config: destructorOutput;
        mixin(destructorOutput);
        sfOutputSoundFile_destroy(m_soundFile);
    }

    /**
     * Open the sound file from the disk for writing.
     *
     * The supported audio formats are: WAV, OGG/Vorbis, FLAC.
     *
     * Params:
     *	filename     = Path of the sound file to load
     *	sampleCount  = Sample rate of the sound
     *	channelCount = Number of channels in the sound
     *
     * Returns: true if the file was successfully opened.
     */
    bool openFromFile(const(char)[] filename, uint sampleRate, uint channelCount)
    {
        import dsfml.system.string;
        bool toReturn = sfOutputSoundFile_openFromFile(m_soundFile, filename.ptr, filename.length,channelCount,sampleRate);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
        return toReturn;
    }

    /**
     * Write audio samples to the file.
     *
     * Params:
     *	samples = array of samples to write
     */
    void write(const(short)[] samples)
    {
        sfOutputSoundFile_write(m_soundFile, samples.ptr, samples.length);
    }

}

extern(C) const(char)* sfErr_getOutput();


private extern(C)
{

struct sfOutputSoundFile;

sfOutputSoundFile* sfOutputSoundFile_create();

void sfOutputSoundFile_destroy(sfOutputSoundFile* file);

bool sfOutputSoundFile_openFromFile(sfOutputSoundFile* file, const(char)* filename, size_t length, uint channelCount,uint sampleRate);

void sfOutputSoundFile_write(sfOutputSoundFile* file, const short* data, long sampleCount);

}
