#ifndef DSFML_AUDIO_LISTENER_H
#define DSFML_AUDIO_LISTENER_H

#include <SFML/Audio/Export.h>

DSFML_AUDIO_API void sfListener_setGlobalVolume(float volume);


DSFML_AUDIO_API float sfListener_getGlobalVolume(void);


DSFML_AUDIO_API void sfListener_setPosition(float x, float y, float z);


DSFML_AUDIO_API void sfListener_getPosition(float* x, float* y, float* z);


DSFML_AUDIO_API void sfListener_setDirection(float x, float y, float z);


DSFML_AUDIO_API void sfListener_getDirection(float* x, float* y, float* z);


#endif // DSFML_AUDIO_LISTENER_H
