#include <SFML/Audio/SoundBuffer.h>
#include <SFML/Audio/AL/al.h>
#include <SFML/Audio/AL/alc.h>
#include <SFML/Audio/ALCheck.hpp>

void sfSoundBuffer_alGenBuffers(DUint* bufferID)
{
    alCheck(alGenBuffers(1, bufferID));
}

void sfSoundBuffer_alDeleteBuffer(DUint* bufferID)
{
     alCheck(alDeleteBuffers(1, bufferID));
}

DUint sfSoundBuffer_getSampleRate(DUint bufferID)
{
    ALint sampleRate;
    alCheck(alGetBufferi(bufferID, AL_FREQUENCY, &sampleRate));

    return sampleRate;
}

DUint sfSoundBuffer_getChannelCount(DUint bufferID)
{
    ALint channelCount;
    alCheck(alGetBufferi(bufferID, AL_CHANNELS, &channelCount));

    return channelCount;
}

void sfSoundBuffer_fillBuffer(DUint bufferID, DShort* samples, DLong sampleSize, DUint sampleRate, DUint format)
{
    ALsizei size = static_cast<ALsizei>( sampleSize* sizeof(DShort));
    alCheck(alBufferData(bufferID, format, samples, size, sampleRate));
}
