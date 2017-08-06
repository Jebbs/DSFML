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

/// A module containing the SoundRecorder class.
module dsfml.audio.soundrecorder;

import core.thread;
import core.time;
import dsfml.system.string;
import dsfml.system.err;


/**
 * Abstract base class for capturing sound data.
 *
 * SoundBuffer provides a simple interface to access the audio recording
 * capabilities of the computer (the microphone).
 *
 * As an abstract base class, it only cares about capturing sound samples, the
 * task of making something useful with them is left to the derived class. Note
 * that DSFML provides a built-in specialization for saving the captured data to
 * a sound buffer (see SoundBufferRecorder).
 *
 * A derived class has only one virtual function to override:
 * onProcessSamples provides the new chunks of audio samples while the capture
 * happens
 *
 * Moreover, two additionnal virtual functions can be overriden as well if
 * necessary:
 * onStart is called before the capture happens, to perform custom
 * initializations
 * onStop is called after the capture ends, to perform custom cleanup
 *
 * The audio capture feature may not be supported or activated on every
 * platform, thus it is recommended to check its availability with the
 * isAvailable() function. If it returns false, then any attempt to use an audio
 * recorder will fail.
 *
 * It is important to note that the audio capture happens in a separate thread,
 * so that it doesn't block the rest of the program. In particular, the
 * onProcessSamples and onStop virtual functions (but not onStart) will be
 * called from this separate thread. It is important to keep this in mind,
 * because you may have to take care of synchronization issues if you share data
 * between threads.
 *
 * See_Also:
 *  $(LINK https://www.sfml-dev.org/documentation/2.4.2/classsf_1_1SoundRecorder.php)
 *
 * Authors: Laurent Gomila, Jeremy DeHaan
 */
class SoundRecorder
{
    package sfSoundRecorder* sfPtr;
    private SoundRecorderCallBacks callBacks;

    /// Default constructor.
    protected this()
    {
        import dsfml.system.string;
        callBacks = new SoundRecorderCallBacks(this);
        sfPtr = sfSoundRecorder_construct(callBacks);

        err.write(dsfml.system.string.toString(sfErr_getOutput()));

        //Fix for some strange bug that I can't seem to track down.
        //This bug causes the array in SoundBufferRecorder to segfault if
        //its length reaches 1024, but creating an array of this size before capturing happens
        //seems to fix it. This fix should allow other implementations to not segfault as well.
        //I will look into the cause when I have more time, but this at least renders it usable.
        short[] temp;
        temp.length = 1024;
        temp.length =0;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfSoundRecorder_destroy(sfPtr);
    }

    /**
     * Start the capture.
     *
     * The sampleRate parameter defines the number of audio samples captured per
     * second. The higher, the better the quality (for example, 44100
     * samples/sec is CD quality). This function uses its own thread so that it
     * doesn't block the rest of the program while the capture runs. Please note
     * that only one capture can happen at the same time.
     *
     * Params:
     *  sampleRate = Desired capture rate, in number of samples per second
     */
    void start(uint theSampleRate = 44100)
    {
        import dsfml.system.string;
        sfSoundRecorder_start(sfPtr, theSampleRate);

        err.write(.toString(sfErr_getOutput()));
    }

    /// Stop the capture.
    void stop()
    {
        sfSoundRecorder_stop(sfPtr);
    }

    /**
     * Get the sample rate in samples per second.
     *
     * The sample rate defines the number of audio samples captured per second.
     * The higher, the better the quality (for example, 44100 samples/sec is CD
     * quality).
     */
    @property
    {
        uint sampleRate()
        {
            return sfSoundRecorder_getSampleRate(sfPtr);
        }
    }

    /**
     * Get the name of the current audio capture device.
     *
     * Returns: The name of the current audio capture device.
     */
    string getDevice() const {
        return .toString(sfSoundRecorder_getDevice(sfPtr));
    }
    /**
     * Set the audio capture device.
     *
     * This function sets the audio capture device to the device with the given
     * name. It can be called on the fly (i.e: while recording). If you do so
     * while recording and opening the device fails, it stops the recording.
     *
     * Params:
     *  name = The name of the audio capture device
     *
     * Returns: True, if it was able to set the requested device.
     *
     *See also
     *   getAvailableDevices, getDefaultDevice
     */
    bool setDevice (const(char)[] name)
    {
        return sfSoundRecorder_setDevice(sfPtr, name.ptr, name.length);
    }

    /**
     * Get a list of the names of all available audio capture devices.
     *
     * This function returns an array of strings, containing the names of all
     * available audio capture devices.
     *
     * Returns: An array of strings containing the names.
     */
    static const(string)[] getAvailableDevices()
    {
        //stores all available devices after the first call
        static string[] availableDevices;

        //if getAvailableDevices hasn't been called yet
        if(availableDevices.length == 0)
        {
            const (char)** devices;
            size_t counts;

            devices = sfSoundRecorder_getAvailableDevices(&counts);

            //calculate real length
            availableDevices.length = counts;

            //populate availableDevices
            for(uint i = 0; i < counts; i++)
            {
                availableDevices[i] = .toString(devices[i]);
            }

        }

        return availableDevices;
    }

    /**
     * Get the name of the default audio capture device.
     *
     * This function returns the name of the default audio capture device. If
     * none is available, an empty string is returned.
     *
     * Returns: The name of the default audio capture device.
     */
    static string getDefaultDevice() {
        return .toString(sfSoundRecorder_getDefaultDevice());
    }

    /**
     * Check if the system supports audio capture.
     *
     * This function should always be called before using the audio capture
     * features. If it returns false, then any attempt to use SoundRecorder or
     * one of its derived classes will fail.
     *
     * Returns: True if audio capture is supported, false otherwise.
     */
    static bool isAvailable()
    {
        return sfSoundRecorder_isAvailable();
    }

    protected
    {
        /**
         * Set the processing interval.
         *
         * The processing interval controls the period between calls to the
         * onProcessSamples function. You may want to use a small interval if
         * you want to process the recorded data in real time, for example.
         *
         * Note: this is only a hint, the actual period may vary. So don't rely
         * on this parameter to implement precise timing.
         *
         * The default processing interval is 100 ms.
         *
         * Params:
         *  interval = Processing interval
         */
        void setProcessingInterval (Duration interval) {
            sfSoundRecorder_setProcessingInterval(sfPtr,
                                                  interval.total!"usecs");
        }

        /**
         * Start capturing audio data.
         *
         * This virtual function may be overriden by a derived class if
         * something has to be done every time a new capture starts. If not,
         * this function can be ignored; the default implementation does
         * nothing.
         *
         * Returns: True to the start the capture, or false to abort it.
         */
        bool onStart()
        {
            return true;
        }

        /**
         * Process a new chunk of recorded samples.
         *
         * This virtual function is called every time a new chunk of recorded
         * data is available. The derived class can then do whatever it wants
         * with it (storing it, playing it, sending it over the network, etc.).
         *
         * Params:
         * 		samples =	Array of the new chunk of recorded samples
         *
         * Returns: True to continue the capture, or false to stop it.
         */
        abstract bool onProcessSamples(const(short)[] samples);

        /**
         * Stop capturing audio data.
         *
         * This virtual function may be overriden by a derived class if
         * something has to be done every time the capture ends. If not, this
         * function can be ignored; the default implementation does nothing.
         */
        void onStop()
        {
        }
    }
}

private:

extern(C++) interface sfmlSoundRecorderCallBacks
{

    bool onStart();
    bool onProcessSamples(const(short)* samples, size_t sampleCount);
    void onStop();
}

class SoundRecorderCallBacks: sfmlSoundRecorderCallBacks
{
    import std.stdio;

    SoundRecorder m_recorder;

    this(SoundRecorder recorder)
    {

        m_recorder = recorder;
    }

    extern(C++) bool onStart()
    {
        return m_recorder.onStart();
    }
    extern(C++) bool onProcessSamples(const(short)* samples, size_t sampleCount)
    {
        return m_recorder.onProcessSamples(samples[0..sampleCount]);
    }
    extern(C++) void onStop()
    {
        m_recorder.onStop();
    }
}

private extern(C):

struct sfSoundRecorder;

sfSoundRecorder* sfSoundRecorder_construct(sfmlSoundRecorderCallBacks newCallBacks);

void sfSoundRecorder_destroy(sfSoundRecorder* soundRecorder);

void sfSoundRecorder_start(sfSoundRecorder* soundRecorder, uint sampleRate);

void sfSoundRecorder_stop(sfSoundRecorder* soundRecorder);

uint sfSoundRecorder_getSampleRate(const sfSoundRecorder* soundRecorder);

bool sfSoundRecorder_setDevice(sfSoundRecorder* soundRecorder, const(char)* name, size_t length);

const(char)* sfSoundRecorder_getDevice(const (sfSoundRecorder)* soundRecorder);

const(char)** sfSoundRecorder_getAvailableDevices(size_t* count);

const(char)* sfSoundRecorder_getDefaultDevice();

bool sfSoundRecorder_isAvailable();

void sfSoundRecorder_setProcessingInterval(sfSoundRecorder* soundRecorder, ulong time);

const(char)* sfErr_getOutput();

