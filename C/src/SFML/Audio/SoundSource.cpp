#include <SFML/Audio/SoundSource.h>

void sfSoundSource_ensureALInit()
{
    sf::priv::ensureALInit();
}

void sfSoundSource_initialize(DUint* sourceID)
{
    alCheck(alGenSources(1, sourceID));
    alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
}

void sfSoundSource_setPitch(DUint sourceID, float pitch)
{
    alCheck(alSourcef(sourceID, AL_PITCH, pitch));
}

void sfSoundSource_setVolume(DUint sourceID, float volume)
{
    alCheck(alSourcef(sourceID, AL_GAIN, volume * 0.01f));
}

void sfSoundSource_setPosition(DUint sourceID, float x, float y, float z)
{
    alCheck(alSource3f(sourceID, AL_POSITION, x, y, z));
}

void sfSoundSource_setRelativeToListener(DUint sourceID,DBool relative)
{
    alCheck(alSourcei(sourceID, AL_SOURCE_RELATIVE, relative));
}

void sfSoundSource_setMinDistance(DUint sourceID, float distance)
{
    alCheck(alSourcef(sourceID, AL_REFERENCE_DISTANCE, distance));
}

void sfSoundSource_setAttenuation(DUint sourceID, float attenuation)
{
    alCheck(alSourcef(sourceID, AL_ROLLOFF_FACTOR, attenuation));
}


float sfSoundSource_getPitch(DUint sourceID)
{
    ALfloat pitch;
    alCheck(alGetSourcef(sourceID, AL_PITCH, &pitch));

    return pitch;
}

float sfSoundSource_getVolume(DUint sourceID)
{
    ALfloat gain;
    alCheck(alGetSourcef(sourceID, AL_GAIN, &gain));

    return gain * 100.f;
}

void sfSoundSource_getPosition(DUint sourceID, float* x, float* y, float* z)
{
    alCheck(alGetSource3f(sourceID, AL_POSITION, x, y, z));
}

DBool sfSoundSource_isRelativeToListener(DUint sourceID)
{
    ALint relative;
    alCheck(alGetSourcei(sourceID, AL_SOURCE_RELATIVE, &relative));

    return relative;
}

float sfSoundSource_getMinDistance(DUint sourceID)
{
    ALfloat distance;
    alCheck(alGetSourcef(sourceID, AL_REFERENCE_DISTANCE, &distance));

    return distance;
}

float sfSoundSource_getAttenuation(DUint sourceID)
{
    ALfloat attenuation;
    alCheck(alGetSourcef(sourceID, AL_ROLLOFF_FACTOR, &attenuation));

    return attenuation;
}

DInt sfSoundSource_getStatus(DUint sourceID)
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

void sfSoundSource_destroy(DUint* sourceID)
{
     alCheck(alSourcei(*sourceID, AL_BUFFER, 0));
    alCheck(alDeleteSources(1, sourceID));
}
