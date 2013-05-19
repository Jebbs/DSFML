
#include <SFML/Audio/SoundStream.h>
#include <SFML/Audio/SoundSource.hpp>
#include <SFML/Audio/AL/al.h>
#include <SFML/Audio/AL/alc.h>
#include <SFML/Audio/ALCheck.hpp>
#include <SFML/Audio/AudioDevice.hpp>
#include <SFML/System/Time.hpp>

DUint sfSoundStream_getFormatFromChannelCount(DUint channelCount)
{
    return sf::priv::AudioDevice::getFormatFromChannelCount(channelCount);
}

void sfSoundStream_alSourcePlay(DUint sourceID)
{
    alCheck(alSourcePlay(sourceID));
}

void sfSoundStream_alSourcePause(DUint sourceID)
{
    alCheck(alSourcePause(sourceID));
}

void sfSoundStream_alSourceStop(DUint sourceID)
{
    alCheck(alSourceStop(sourceID));
}

void sfSoundStream_alGenBuffers(DInt bufferCount, DUint* buffers)
{
    alCheck(alGenBuffers(bufferCount, buffers));
}


void sfSoundStream_deleteBuffers(DUint sourceID, DInt bufferCount, DUint* buffers)
{
    alCheck(alSourcei(sourceID, AL_BUFFER, 0));
    alCheck(alDeleteBuffers(bufferCount, buffers));
}

DLong sfSoundStream_getPlayingOffset(DUint sourceID,DLong samplesProcessed,  DUint theSampleRate, DUint theChannelCount)
{
    ALfloat secs = 0.f;
    alCheck(alGetSourcef(sourceID, AL_SEC_OFFSET, &secs));

    return sf::seconds(secs + static_cast<float>(samplesProcessed) / theSampleRate / theChannelCount).asMicroseconds();
}


void sfSoundStream_clearQueue(DUint sourceID)
{

    // Get the number of buffers still in the queue
    ALint nbQueued;
    alCheck(alGetSourcei(sourceID, AL_BUFFERS_QUEUED, &nbQueued));

    // Unqueue them all
    ALuint buffer;
    for (ALint i = 0; i < nbQueued; ++i)
    {
        alCheck(alSourceUnqueueBuffers(sourceID, 1, &buffer));
    }

}

DInt sfSoundStream_getNumberOfBuffersProccessed(DUint sourceID)
{
    ALint nbProcessed = 0;
    alCheck(alGetSourcei(sourceID, AL_BUFFERS_PROCESSED, &nbProcessed));
    return nbProcessed;
}

DUint sfSoundStream_UnqueueBuffer(DUint sourceID)
{
    ALuint buffer;
    alCheck(alSourceUnqueueBuffers(sourceID, 1, &buffer));
    return buffer;
}

DInt sfSoundStream_getBufferSampleSize(DUint bufferID)
{
    ALint size, bits;
    alCheck(alGetBufferi(bufferID, AL_SIZE, &size));
    alCheck(alGetBufferi(bufferID, AL_BITS, &bits));
    return size / (bits / 8);
}

void sfSoundStream_fillBuffer(DUint bufferID, const DShort* samples, DLong sampleCount, DUint soundFormat, DUint sampleRate)
{

    ALsizei size = static_cast<ALsizei>(sampleCount) * sizeof(DShort);
    alCheck(alBufferData(bufferID, soundFormat, samples, size, sampleRate));
}

void sfSoundStream_queueBuffer(DUint sourceID, DUint* bufferID)
{
     alCheck(alSourceQueueBuffers(sourceID, 1, bufferID));
}


