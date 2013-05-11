
#ifndef DSFML_SOUNDSTREAM_H
#define DSFML_SOUNDSTREAM_H

#include <SFML/Audio/AL/al.h>
#include <SFML/Audio/AL/alc.h>
#include <SFML/Audio/ALCheck.hpp>
#include <SFML/Audio/Export.h>
#include <SFML/Audio/SoundSource.hpp>



//Define the OpenAL functions used by SFML, but wrapped up nicely.

DSFML_AUDIO_API void ensureALInit();

DSFML_AUDIO_API void SoundSourceInitialize(DUint* sourceID);

DSFML_AUDIO_API void SoundSourceSetPitch(DUint sourceID, float pitch);

DSFML_AUDIO_API void SoundSourceSetVolume(DUint sourceID, float volume);

DSFML_AUDIO_API void SoundSourceSetPosition(DUint sourceID, float x, float y, float z);

DSFML_AUDIO_API void SoundSourceSetRelativeToListener(DUint sourceID,DBool relative);

DSFML_AUDIO_API void SoundSourceSetMinDistance(DUint sourceID, float distance);

DSFML_AUDIO_API void SoundSourceSetAttenuation(DUint sourceID, float attenuation);



DSFML_AUDIO_API float SoundSourceGetPitch(DUint sourceID);

DSFML_AUDIO_API float SoundSourceGetVolume(DUint sourceID);

DSFML_AUDIO_API void SoundSourceGetPosition(DUint sourceID, float* x, float* y, float* z);

DSFML_AUDIO_API DBool SoundSourceIsRelativeToListener(DUint sourceID);

DSFML_AUDIO_API float SoundSourceGetMinDistance(DUint sourceID);

DSFML_AUDIO_API float SoundSourceGetAttenuation(DUint sourceID);

DSFML_AUDIO_API int SoundSourceGetStatus(DUint sourceID);

DSFML_AUDIO_API void SoundSourceDestroy(DUint* sourceID);

#endif // DSFML_SOUNDSTREAM_H
