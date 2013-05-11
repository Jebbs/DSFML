#include <SFML/Audio/SoundSource.h>

void ensureALInit()
{
    sf::priv::ensureALInit();
}

void SoundSourceInitialize(DUint* sourceID)
{
    alCheck(alGenSources(1, sourceID));
    alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
}

void SoundSourceSetPitch(DUint sourceID, float pitch)
{
    alCheck(alSourcef(sourceID, AL_PITCH, pitch));
}

void SoundSourceSetVolume(DUint sourceID, float volume)
{
    alCheck(alSourcef(sourceID, AL_GAIN, volume * 0.01f));
}

void SoundSourceSetPosition(DUint sourceID, float x, float y, float z)
{
    alCheck(alSource3f(sourceID, AL_POSITION, x, y, z));
}

void SoundSourceSetRelativeToListener(DUint sourceID,DBool relative)
{
    alCheck(alSourcei(sourceID, AL_SOURCE_RELATIVE, relative));
}

void SoundSourceSetMinDistance(DUint sourceID, float distance)
{
    alCheck(alSourcef(sourceID, AL_REFERENCE_DISTANCE, distance));
}

void SoundSourceSetAttenuation(DUint sourceID, float attenuation)
{
    alCheck(alSourcef(sourceID, AL_ROLLOFF_FACTOR, attenuation));
}


float SoundSourceGetPitch(DUint sourceID)
{
    ALfloat pitch;
    alCheck(alGetSourcef(sourceID, AL_PITCH, &pitch));

    return pitch;
}

float SoundSourceGetVolume(DUint sourceID)
{
    ALfloat gain;
    alCheck(alGetSourcef(sourceID, AL_GAIN, &gain));

    return gain * 100.f;
}

void SoundSourceGetPosition(DUint sourceID, float* x, float* y, float* z)
{
    alCheck(alGetSource3f(sourceID, AL_POSITION, x, y, z));
}

DBool SoundSourceIsRelativeToListener(DUint sourceID)
{
    ALint relative;
    alCheck(alGetSourcei(sourceID, AL_SOURCE_RELATIVE, &relative));

    return relative;
}

float SoundSourceGetMinDistance(DUint sourceID)
{
    ALfloat distance;
    alCheck(alGetSourcef(sourceID, AL_REFERENCE_DISTANCE, &distance));

    return distance;
}

float SoundSourceGetAttenuation(DUint sourceID)
{
    ALfloat attenuation;
    alCheck(alGetSourcef(sourceID, AL_ROLLOFF_FACTOR, &attenuation));

    return attenuation;
}

int SoundSourceGetStatus(DUint sourceID)
{
    ALint status;
    alCheck(alGetSourcei(sourceID, AL_SOURCE_STATE, &status));

    switch (status)
    {
        case AL_INITIAL :
        case AL_STOPPED : return sf::SoundSource::Stopped;
        case AL_PAUSED :  return sf::SoundSource::Paused;
        case AL_PLAYING : return sf::SoundSource::Playing;
    }

    return sf::SoundSource::Stopped;
}

void SoundSourceDestroy(DUint* sourceID)
{
     alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
    alCheck(alDeleteSources(1, sourceID));
}
