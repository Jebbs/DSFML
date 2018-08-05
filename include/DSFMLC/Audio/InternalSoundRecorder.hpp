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

#ifndef DSFML_INTERNALSOUNDRECORDER_HPP
#define DSFML_INTERNALSOUNDRECORDER_HPP

#include <DSFMLC/Config.h>
#include <vector>

//Class for recording sound data to be passed to sfSoundRecorder
class InternalSoundRecorder
{
public:
    //Initialize the system for recording
    DBool initialize(DUint sampleRate);

    //Start the capturing of sound data
    void startCapture();

    //Get the number of samples that have been recorded so far
    DInt getSampleNumber();

    //Get a pointer to the samples that have been captured
    DShort* getSamplePointer(DInt numSamples);

    //Stop the capturing of sound data
    void stopCapture();

    //Close the device so that another sound recorder may use it
    void closeDevice();

    //Check to see if sound recording is allowed on the system
    static DBool isAvailable();

private:
    //Vector that stores recorded samples
    std::vector<DShort> m_samples;
};

#endif // DSFML_INTERNALSOUNDRECORDER_HPP
