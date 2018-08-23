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
 * Unlike audio buffers (see $(SOUNDBUFFER_LINK)), audio streams are never
 * completely loaded in memory. Instead, the audio data is acquired continuously
 * while the stream is playing. This behaviour allows to play a sound with no
 * loading delay, and keeps the memory consumption very low.
 *
 * Sound sources that need to be streamed are usually big files (compressed
 * audio musics that would eat hundreds of MB in memory) or files that would
 * take a lot of time to be received (sounds played over the network).
 *
 * $(U SoundStream) is a base class that doesn't care about the stream source,
 * which is left to the derived class. SFML provides a built-in specialization
 * for big files (see $(MUSIC_LINK)). No network stream source is provided, but
 * you can write your own by combining this class with the network module.
 *
 * A derived class has to override two virtual functions:
 * $(UL
 * $(LI `onGetData` fills a new chunk of audio data to be played)
 * $(LI `onSeek` changes the current playing position in the source))
 *
 * $(PARA
 * It is important to note that each $(U SoundStream) is played in its own
 * separate thread, so that the streaming loop doesn't block the rest of the
 * program. In particular, the `onGetData` and `onSeek` virtual functions may
 * sometimes be called from this separate thread. It is important to keep this
 * in mind, because you may have to take care of synchronization issues if you
 * share data between threads.)
 *
 * Example:
 * ---
 * class CustomStream : SoundStream
 * {
 *
 *     bool open(const(char)[] location)
 *     {
 *         // Open the source and get audio settings
 *         ...
 *         uint channelCount = ...;
 *         unint sampleRate = ...;
 *
 *         // Initialize the stream -- important!
 *         initialize(channelCount, sampleRate);
 *     }
 *
 * protected:
 *     override bool onGetData(ref const(short)[] samples)
 *     {
 *         // Fill the chunk with audio data from the stream source
 *         // (note: must not be empty if you want to continue playing)
 *
 *         // Return true to continue playing
 *         return true;
 *     }
 *
 *     override void onSeek(Uint32 timeOffset)
 *     {
 *         // Change the current position in the stream source
 *         ...
 *     }
 * }
 *
 * // Usage
 * auto stream = CustomStream();
 * stream.open("path/to/stream");
 * stream.play();
 * ---
 *
 * See_Also:
 * $(MUSIC_LINK)
 */
module dsfml.audio.soundstream;


import core.thread;
import core.time;

import dsfml.audio.soundsource;

import dsfml.system.vector3;
import dsfml.system.err;

/**
 * Abstract base class for streamed audio sources.
 */
class SoundStream : SoundSource
{
    package sfSoundStream* sfPtr;
    private SoundStreamCallBacks callBacks;

    /// Internal constructor required to set up callbacks.
    protected this()
    {
        callBacks = new SoundStreamCallBacks(this);
        sfPtr = sfSoundStream_construct(callBacks);
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfSoundStream_destroy(sfPtr);
    }

    /**
     * Define the audio stream parameters.
     *
     * This function must be called by derived classes as soon as they know the
     * audio settings of the stream to play. Any attempt to manipulate the
     * stream (`play()`, ...) before calling this function will fail. It can be
     * called multiple times if the settings of the audio stream change, but
     * only when the stream is stopped.
     *
     * Params:
     *	channelCount = Number of channels of the stream
     *	sampleRate   = Sample rate, in samples per second
     */
    protected void initialize(uint channelCount, uint sampleRate)
    {
        import dsfml.system.string;

        sfSoundStream_initialize(sfPtr, channelCount, sampleRate);

        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    @property
    {
        /**
         * The pitch of the sound.
         *
         * The pitch represents the perceived fundamental frequency of a sound; thus
         * you can make a sound more acute or grave by changing its pitch. A side
         * effect of changing the pitch is to modify the playing speed of the sound
         * as well. The default value for the pitch is 1.
         */
        void pitch(float newPitch)
        {
            sfSoundStream_setPitch(sfPtr, newPitch);
        }

        /// ditto
        float pitch() const
        {
            return sfSoundStream_getPitch(sfPtr);
        }
    }

    @property
    {
        /**
         * The volume of the sound.
         *
         * The volume is a vlue between 0 (mute) and 100 (full volume). The default
         * value for the volume is 100.
         */
        void volume(float newVolume)
        {
            sfSoundStream_setVolume(sfPtr, newVolume);
        }

        /// ditto
        float volume() const
        {
            return sfSoundStream_getVolume(sfPtr);
        }
    }

    @property
    {
        /**
         * The 3D position of the sound in the audio scene.
         *
         * Only sounds with one channel (mono sounds) can be spatialized. The
         * default position of a sound is (0, 0, 0).
         */
        void position(Vector3f newPosition)
        {
            sfSoundStream_setPosition(sfPtr, newPosition.x, newPosition.y, newPosition.z);
        }

        /// ditto
        Vector3f position() const
        {
            Vector3f temp;
            sfSoundStream_getPosition(sfPtr, &temp.x, &temp.y, &temp.z);
            return temp;
        }
    }

    @property
    {
        /**
         * Whether or not the stream should loop after reaching the end.
         *
         * If set, the stream will restart from the beginning after reaching the end
         * and so on, until it is stopped or looping is set to false.
         *
         * Default looping state for streams is false.
         */
        void isLooping(bool loop)
        {
            sfSoundStream_setLoop(sfPtr, loop);
        }

        /// ditto
        bool isLooping() const
        {
            return sfSoundStream_getLoop(sfPtr);
        }
    }

    @property
    {
        /**
         * The current playing position (from the beginning) of the stream.
         *
         * The playing position can be changed when the stream is either paused or
         * playing.
         */
        void playingOffset(Duration offset)
        {
            sfSoundStream_setPlayingOffset(sfPtr, offset.total!"usecs");

        }

        /// ditto
        Duration playingOffset() const
        {
            return usecs(sfSoundStream_getPlayingOffset(sfPtr));
        }
    }

    @property
    {
        /**
         * Make the sound's position relative to the listener (true) or absolute
         * (false).
         *
         * Making a sound relative to the listener will ensure that it will always
         * be played the same way regardless the position of the listener.  This can
         * be useful for non-spatialized sounds, sounds that are produced by the
         * listener, or sounds attached to it. The default value is false (position
         * is absolute).
         */
        void relativeToListener(bool relative)
        {
            sfSoundStream_setRelativeToListener(sfPtr, relative);
        }

        /// ditto
        bool relativeToListener() const
        {
            return sfSoundStream_isRelativeToListener(sfPtr);
        }
    }

    @property
    {
        /**
         * The minimum distance of the sound.
         *
         * The "minimum distance" of a sound is the maximum distance at which it is
         * heard at its maximum volume. Further than the minimum distance, it will
         * start to fade out according to its attenuation factor. A value of 0
         * ("inside the head of the listener") is an invalid value and is forbidden.
         * The default value of the minimum distance is 1.
         */
        void minDistance(float distance)
        {
            sfSoundStream_setMinDistance(sfPtr, distance);
        }

        /// ditto
        float minDistance() const
        {
            return sfSoundStream_getMinDistance(sfPtr);
        }
    }

    @property
    {
        /**
         * The attenuation factor of the sound.
         *
         * The attenuation is a multiplicative factor which makes the sound more or
         * less loud according to its distance from the listener. An attenuation of
         * 0 will produce a non-attenuated sound, i.e. its volume will always be the
         * same whether it is heard from near or from far.
         *
         * On the other hand, an attenuation value such as 100 will make the sound
         * fade out very quickly as it gets further from the listener. The default
         * value of the attenuation is 1.
         */
        void attenuation(float newAttenuation)
        {
            sfSoundStream_setAttenuation(sfPtr, newAttenuation);
        }

        /// ditto
        float attenuation() const
        {
            return sfSoundStream_getAttenuation(sfPtr);
        }
    }


    @property
    {
        /**
         * The number of channels of the stream.
         *
         * 1 channel means mono sound, 2 means stereo, etc.
         */
        uint channelCount() const
        {
            return sfSoundStream_getChannelCount(sfPtr);
        }
    }

    @property
    {
        /**
         * The stream sample rate of the stream
         *
         * The sample rate is the number of audio samples played per second. The
         * higher, the better the quality.
         */
        uint sampleRate() const
        {
            return sfSoundStream_getSampleRate(sfPtr);
        }
    }

    @property
    {
        /// The current status of the stream (stopped, paused, playing)
        Status status() const
        {
            return cast(Status)sfSoundStream_getStatus(sfPtr);
        }
    }

    /**
     * Start or resume playing the audio stream.
     *
    * This function starts the stream if it was stopped, resumes it if it was
    * paused, and restarts it from the beginning if it was already playing. This
    * function uses its own thread so that it doesn't block the rest of the
    * program while the stream is played.
     */
    void play()
    {
        import dsfml.system.string;

        sfSoundStream_play(sfPtr);

        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    /**
     * Pause the audio stream.
     *
     * This function pauses the stream if it was playing, otherwise (stream
     * already paused or stopped) it has no effect.
     */
    void pause()
    {
        sfSoundStream_pause(sfPtr);
    }

    /**
     * Stop playing the audio stream.
     *
     * This function stops the stream if it was playing or paused, and does
     * nothing if it was already stopped. It also resets the playing position
     * (unlike pause()).
     */
    void stop()
    {
        sfSoundStream_stop(sfPtr);
    }

    /**
     * Request a new chunk of audio samples from the stream source.
     *
     * This function must be overridden by derived classes to provide the audio
     * samples to play. It is called continuously by the streaming loop, in a
     * separate thread. The source can choose to stop the streaming loop at any
     * time, by returning false to the caller. If you return true (i.e. continue
     * streaming) it is important that the returned array of samples is not
     * empty; this would stop the stream due to an internal limitation.
     *
     * Params:
     *	samples = Array of samples to fill
     */
    protected abstract bool onGetData(ref const(short)[] samples);

    /**
     * Change the current playing position in the stream source.
     *
     * This function must be overridden by derived classes to allow random
     * seeking into the stream source.
     *
     * Params:
     *	timeOffset = New playing position, relative to the start of the stream
     */
    protected abstract void onSeek(Duration timeOffset);
}

private extern(C++)
{
    struct Chunk
    {
        const(short)* samples;
        size_t sampleCount;
    }
}

private extern(C++) interface sfmlSoundStreamCallBacks
{
public:
    bool onGetData(Chunk* chunk);
    void onSeek(long time);
}


class SoundStreamCallBacks: sfmlSoundStreamCallBacks
{
    SoundStream m_stream;

    this(SoundStream stream)
    {
        m_stream = stream;
    }

    extern(C++) bool onGetData(Chunk* chunk)
    {
        const(short)[] samples;

        auto ret = m_stream.onGetData(samples);

        (*chunk).samples = samples.ptr;
        (*chunk).sampleCount = samples.length;

        return ret;
    }

    extern(C++) void onSeek(long time)
    {
        m_stream.onSeek(usecs(time));
    }
}

private extern(C):

struct sfSoundStream;

sfSoundStream* sfSoundStream_construct(sfmlSoundStreamCallBacks callBacks);

void sfSoundStream_destroy(sfSoundStream* soundStream);

void sfSoundStream_initialize(sfSoundStream* soundStream, uint channelCount, uint sampleRate);

void sfSoundStream_play(sfSoundStream* soundStream);

void sfSoundStream_pause(sfSoundStream* soundStream);

void sfSoundStream_stop(sfSoundStream* soundStream);

int sfSoundStream_getStatus(const sfSoundStream* soundStream);

uint sfSoundStream_getChannelCount(const sfSoundStream* soundStream);

uint sfSoundStream_getSampleRate(const sfSoundStream* soundStream);

void sfSoundStream_setPitch(sfSoundStream* soundStream, float pitch);

void sfSoundStream_setVolume(sfSoundStream* soundStream, float volume);

void sfSoundStream_setPosition(sfSoundStream* soundStream, float positionX, float positionY, float positionZ);

void sfSoundStream_setRelativeToListener(sfSoundStream* soundStream, bool relative);

void sfSoundStream_setMinDistance(sfSoundStream* soundStream, float distance);

void sfSoundStream_setAttenuation(sfSoundStream* soundStream, float attenuation);

void sfSoundStream_setPlayingOffset(sfSoundStream* soundStream, long timeOffset);

void sfSoundStream_setLoop(sfSoundStream* soundStream, bool loop);

float sfSoundStream_getPitch(const sfSoundStream* soundStream);

float sfSoundStream_getVolume(const sfSoundStream* soundStream);

void sfSoundStream_getPosition(const sfSoundStream* soundStream, float* positionX, float* positionY, float* positionZ);

bool sfSoundStream_isRelativeToListener(const sfSoundStream* soundStream);

float sfSoundStream_getMinDistance(const sfSoundStream* soundStream);

float sfSoundStream_getAttenuation(const sfSoundStream* soundStream);

bool sfSoundStream_getLoop(const sfSoundStream* soundStream);

long sfSoundStream_getPlayingOffset(const sfSoundStream* soundStream);

const(char)* sfErr_getOutput();
