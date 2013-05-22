#ifndef DSFML_SOUNDBUFFER_H
#define DSFML_SOUNDBUFFER_H

#include <SFML/Audio/Export.h>

DSFML_AUDIO_API void sfSoundBuffer_alGenBuffers(DUint* bufferID);

DSFML_AUDIO_API void sfSoundBuffer_alDeleteBuffer(DUint* bufferID);

DSFML_AUDIO_API DUint sfSoundBuffer_getSampleRate(DUint bufferID);

DSFML_AUDIO_API DUint sfSoundBuffer_getChannelCount(DUint bufferID);

DSFML_AUDIO_API void sfSoundBuffer_fillBuffer(DUint bufferID, DShort* samples, DLong sampleSize, DUint sampleRate, DUint format);


#endif // DSFML_SOUNDBUFFER_H
