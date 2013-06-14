
#ifndef DSFML_SOUNDSOURCE_H
#define DSFML_SOUNDSOURCE_H


#include <SFML/Audio/ALCheck.hpp>
#include <SFML/Audio/Export.h>
#include <SFML/Audio/SoundSource.hpp>



//Define the audio methods used within sf::SoundSource

DSFML_AUDIO_API void sfSoundSource_ensureALInit();

DSFML_AUDIO_API void sfSoundSource_initialize(DUint* sourceID);

DSFML_AUDIO_API void sfSoundSource_setPitch(DUint sourceID, float pitch);

DSFML_AUDIO_API void sfSoundSource_setVolume(DUint sourceID, float volume);

DSFML_AUDIO_API void sfSoundSource_setPosition(DUint sourceID, float x, float y, float z);

DSFML_AUDIO_API void sfSoundSource_setRelativeToListener(DUint sourceID,DBool relative);

DSFML_AUDIO_API void sfSoundSource_setMinDistance(DUint sourceID, float distance);

DSFML_AUDIO_API void sfSoundSource_setAttenuation(DUint sourceID, float attenuation);



DSFML_AUDIO_API float sfSoundSource_getPitch(DUint sourceID);

DSFML_AUDIO_API float sfSoundSource_getVolume(DUint sourceID);

DSFML_AUDIO_API void sfSoundSource_getPosition(DUint sourceID, float* x, float* y, float* z);

DSFML_AUDIO_API DBool sfSoundSource_isRelativeToListener(DUint sourceID);

DSFML_AUDIO_API float sfSoundSource_getMinDistance(DUint sourceID);

DSFML_AUDIO_API float sfSoundSource_getAttenuation(DUint sourceID);

DSFML_AUDIO_API DInt sfSoundSource_getStatus(DUint sourceID);

DSFML_AUDIO_API void sfSoundSource_destroy(DUint* sourceID);

#endif // DSFML_SOUNDSOURCE_H
