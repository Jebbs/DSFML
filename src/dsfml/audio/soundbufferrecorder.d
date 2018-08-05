/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
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
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

/**
 * $(U SoundBufferRecorder) allows to access a recorded sound through a
 * $(SOUNDBUFFER_LINK), so that it can be played, saved to a file, etc.
 *
 * It has the same simple interface as its base class (`start()`, `stop()`) and
 * adds a function to retrieve the recorded sound buffer (`getBuffer()`).
 *
 * As usual, don't forget to call the `isAvailable()` function before using this
 * class (see $(SOUNDRECORDER_LINK) for more details about this).
 *
 * Example:
 * ---
 * if (SoundBufferRecorder.isAvailable())
 * {
 *     // Record some audio data
 *     auto recorder = SoundBufferRecorder();
 *     recorder.start();
 *     ...
 *     recorder.stop();
 *
 *     // Get the buffer containing the captured audio data
 *     auto buffer = recorder.getBuffer();
 *
 *     // Save it to a file (for example...)
 *     buffer.saveToFile("my_record.ogg");
 * }
 * ---
 *
 * See_Also:
 * $(SOUNDRECORDER_LINK)
 */
module dsfml.audio.soundbufferrecorder;

import dsfml.audio.soundrecorder;
import dsfml.audio.soundbuffer;

/**
 * Specialized SoundRecorder which stores the captured audio data into a sound
 * buffer.
 */
class SoundBufferRecorder : SoundRecorder
{
    private
    {
        short[] m_samples;
        SoundBuffer m_buffer;
    }

    /// Default constructor.
    this()
    {
        // Constructor code
        m_buffer = new SoundBuffer();
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
    }

    /**
     * Get the sound buffer containing the captured audio data.
     *
     * The sound buffer is valid only after the capture has ended. This function
     * provides a read-only access to the internal sound buffer, but it can be
     * copied if you need to make any modification to it.
     *
     * Returns: Read-only access to the sound buffer.
     */
    const(SoundBuffer) getBuffer() const
    {
        return m_buffer;
    }

    protected
    {
        /**
         * Start capturing audio data.
         *
         * Returns: true to start the capture, or false to abort it.
         */
        override bool onStart()
        {
            m_samples.length = 0;
            m_buffer = new SoundBuffer();

            return true;
        }

        /**
         * Process a new chunk of recorded samples.
         *
         * Params:
         *	samples =	Array of the new chunk of recorded samples
         *
         * Returns: true to continue the capture, or false to stop it.
         */
        override bool onProcessSamples(const(short)[] samples)
        {
            m_samples ~= samples;

            return true;
        }

        /**
         * Stop capturing audio data.
         */
        override void onStop()
        {
            if(m_samples.length >0)
            {
                m_buffer.loadFromSamples(m_samples,1,sampleRate);
            }
        }
    }
}

unittest
{
    //When this unit test is run it occasionally throws an error which will vary, and
    //is obviously in OpenAL. Probably something to do with the way the binding is done. Will be fixed in 2.1.
    version(DSFML_Unittest_Audio)
    {
        import std.stdio;
        import core.time;
        import dsfml.window.keyboard;
        import dsfml.audio.sound;
        import dsfml.system.clock;
        import dsfml.system.sleep;

        writeln("Unit test for SoundBufferRecorder.");

        assert(SoundRecorder.isAvailable());

        auto recorder = new SoundBufferRecorder();

        auto clock = new Clock();

        writeln("Recording for 5 seconds in...");
        writeln("3");
        clock.restart();

        while(clock.getElapsedTime().total!"seconds" <1)
        {
            //wait for a second
        }

        writeln("2");

        clock.restart();

        while(clock.getElapsedTime().total!"seconds" <1)
        {
            //wait for a second
        }

        writeln("1");

        clock.restart();

        while(clock.getElapsedTime().total!"seconds" <1)
        {
            //wait for a second
        }

        writeln("Recording!");

        recorder.start();
        clock.restart();

        while(clock.getElapsedTime().total!"seconds" <5)
        {
            //wait for a second
        }

        writeln("Done!");

        recorder.stop();

        auto buffer = recorder.getBuffer();
        auto recorderDuration = buffer.getDuration();
        auto recorderSound = new Sound(buffer);

        clock.restart();

        recorderSound.play();
        while(clock.getElapsedTime() < recorderDuration)
        {
            //sound playing
        }

        writeln();
    }
}
