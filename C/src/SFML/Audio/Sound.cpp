
#include <SFML/Audio/Sound.h>
#include <SFML/Audio/AL/al.h>
#include <SFML/Audio/AL/alc.h>
#include <SFML/Audio/ALCheck.hpp>

void sfSound_assignBuffer(DUint sourceID, DUint bufferID)
{
    alCheck(alSourcei(sourceID, AL_BUFFER, bufferID));
}

void sfSound_detachBuffer(DUint sourceID)
{
    alCheck(alSourcei(sourceID, AL_BUFFER, 0));
}

void sfSound_setLoop(DUint sourceID,DBool loop)
{
    alCheck(alSourcei(sourceID, AL_LOOPING, loop));
}

DBool sfSound_getLoop(DUint sourceID)
{
    ALint loop;
    alCheck(alGetSourcei(sourceID, AL_LOOPING, &loop));

    return loop;
}

void sfSound_setPlayingOffset(DUint sourceID, float offset)
{
    alCheck(alSourcef(sourceID, AL_SEC_OFFSET, offset));
}

float sfSound_getPlayingOffset(DUint sourceID)
{
    ALfloat secs = 0.f;
    alCheck(alGetSourcef(sourceID, AL_SEC_OFFSET, &secs));

    return secs;
}
