/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

#ifndef DSFML_SOUNDSTREAM_H
#define DSFML_SOUNDSTREAM_H

//Headers
#include <DSFMLC/Audio/Export.h>
#include <DSFMLC/Audio/SoundStreamStruct.h>

DSFML_AUDIO_API sfSoundStream* sfSoundStream_construct(SoundStreamCallBacks* callBacks);

DSFML_AUDIO_API void sfSoundStream_destroy(sfSoundStream* soundStream);

DSFML_AUDIO_API void sfSoundStream_initialize(sfSoundStream* soundStream, DUint channelCount, DUint sampleRate);

DSFML_AUDIO_API void sfSoundStream_play(sfSoundStream* soundStream);

DSFML_AUDIO_API void sfSoundStream_pause(sfSoundStream* soundStream);

DSFML_AUDIO_API void sfSoundStream_stop(sfSoundStream* soundStream);

DSFML_AUDIO_API DInt sfSoundStream_getStatus(const sfSoundStream* soundStream);

DSFML_AUDIO_API DUint sfSoundStream_getChannelCount(const sfSoundStream* soundStream);

DSFML_AUDIO_API DUint sfSoundStream_getSampleRate(const sfSoundStream* soundStream);

DSFML_AUDIO_API void sfSoundStream_setPitch(sfSoundStream* soundStream, float pitch);

DSFML_AUDIO_API void sfSoundStream_setVolume(sfSoundStream* soundStream, float volume);

DSFML_AUDIO_API void sfSoundStream_setPosition(sfSoundStream* soundStream, float positionX, float positionY, float positionZ);

DSFML_AUDIO_API void sfSoundStream_setRelativeToListener(sfSoundStream* soundStream, DBool relative);

DSFML_AUDIO_API void sfSoundStream_setMinDistance(sfSoundStream* soundStream, float distance);

DSFML_AUDIO_API void sfSoundStream_setAttenuation(sfSoundStream* soundStream, float attenuation);

DSFML_AUDIO_API void sfSoundStream_setPlayingOffset(sfSoundStream* soundStream, DLong timeOffset);

DSFML_AUDIO_API void sfSoundStream_setLoop(sfSoundStream* soundStream, DBool loop);

DSFML_AUDIO_API float sfSoundStream_getPitch(const sfSoundStream* soundStream);

DSFML_AUDIO_API float sfSoundStream_getVolume(const sfSoundStream* soundStream);

DSFML_AUDIO_API void sfSoundStream_getPosition(const sfSoundStream* soundStream, float* positionX, float* positionY, float* positionZ);

DSFML_AUDIO_API DBool sfSoundStream_isRelativeToListener(const sfSoundStream* soundStream);

DSFML_AUDIO_API float sfSoundStream_getMinDistance(const sfSoundStream* soundStream);

DSFML_AUDIO_API float sfSoundStream_getAttenuation(const sfSoundStream* soundStream);

DSFML_AUDIO_API DBool sfSoundStream_getLoop(const sfSoundStream* soundStream);

DSFML_AUDIO_API DLong sfSoundStream_getPlayingOffset(const sfSoundStream* soundStream);

#endif // DSFML_SOUNDSTREAM_H
