#ifndef DSFML_SOUND_H
#define DSFML_SOUND_H

#include <SFML/Audio/Export.h>


DSFML_AUDIO_API void sfSound_assignBuffer(DUint sourceID, DUint bufferID);

DSFML_AUDIO_API void sfSound_detachBuffer(DUint sourceID);

DSFML_AUDIO_API void sfSound_setLoop(DUint sourceID,DBool loop);

DSFML_AUDIO_API DBool sfSound_getLoop(DUint sourceID);

DSFML_AUDIO_API void sfSound_setPlayingOffset(DUint sourceID, float offset);

DSFML_AUDIO_API float sfSound_getPlayingOffset(DUint sourceID);

#endif // DSFML_SOUND_H
