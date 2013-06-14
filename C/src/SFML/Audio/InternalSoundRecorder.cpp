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

//Headers
#include <SFML/Audio/InternalSoundRecorder.hpp>
#include <SFML/Audio/AudioDevice.hpp>
#include <SFML/System/Err.hpp>
#include <SFML/Audio/ALCheck.hpp>

namespace
{
    ALCdevice* captureDevice = NULL;
}

DBool InternalSoundRecorder::initialize(DUint sampleRate)
{
    // Check if the device can do audio capture
    if (!isAvailable())
    {
        sf::err() << "Failed to start capture : your system cannot capture audio data (call SoundRecorder::IsAvailable to check it)" << std::endl;
        return DFalse;
    }

    // Check that another capture is not already running
    if (captureDevice)
    {
        sf::err() << "Trying to start audio capture, but another capture is already running" << std::endl;
        return DFalse;
    }

    // Open the capture device for capturing 16 bits mono samples
    captureDevice = alcCaptureOpenDevice(NULL, sampleRate, AL_FORMAT_MONO16, sampleRate);
    if (!captureDevice)
    {
        sf::err() << "Failed to open the audio capture device" << std::endl;
        return DFalse;
    }

    // Clear the array of samples
    m_samples.clear();

    return DTrue;
}

void InternalSoundRecorder::startCapture()
{
    alcCaptureStart(captureDevice);
}

DInt InternalSoundRecorder::getSampleNumber()
{
    // Get the number of samples available
    ALCint samplesAvailable;
    alcGetIntegerv(captureDevice, ALC_CAPTURE_SAMPLES, 1, &samplesAvailable);

    return samplesAvailable;
}

DShort* InternalSoundRecorder::getSamplePointer(DInt numSamples)
{
    DInt samplesAvailable = numSamples;

    // Get the recorded samples
    m_samples.resize(samplesAvailable);
    alcCaptureSamples(captureDevice, &m_samples[0], samplesAvailable);

    return &m_samples[0];
}

void InternalSoundRecorder::stopCapture()
{
    // Stop the capture
    alcCaptureStop(captureDevice);
}

void InternalSoundRecorder::closeDevice()
{
     // Close the device
    alcCaptureCloseDevice(captureDevice);
    captureDevice = NULL;
}

DBool InternalSoundRecorder::isAvailable()
{
    return (sf::priv::AudioDevice::isExtensionSupported("ALC_EXT_CAPTURE") != AL_FALSE) ||
           (sf::priv::AudioDevice::isExtensionSupported("ALC_EXT_capture") != AL_FALSE); // "bug" in Mac OS X 10.5 and 10.6
}
