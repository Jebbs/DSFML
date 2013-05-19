
#ifndef DSFML_SOUNDSTREAM_H
#define DSFML_SOUNDSTREAM_H

#include <SFML/Audio/Export.h>



DSFML_AUDIO_API DUint sfSoundStream_getFormatFromChannelCount(DUint channelCount);

DSFML_AUDIO_API void sfSoundStream_alSourcePlay(DUint sourceID);

DSFML_AUDIO_API void sfSoundStream_alSourcePause(DUint sourceID);

DSFML_AUDIO_API void sfSoundStream_alSourceStop(DUint sourceID);

DSFML_AUDIO_API void sfSoundStream_alGenBuffers(DInt bufferCount, DUint* buffers);

DSFML_AUDIO_API void sfSoundStream_deleteBuffers(DUint sourceID, DInt bufferCount, DUint* buffers);

DSFML_AUDIO_API DLong sfSoundStream_getPlayingOffset(DUint sourceID, DLong samplesProcessed, DUint theSampleRate, DUint theChannelCount);


DSFML_AUDIO_API void sfSoundStream_clearQueue(DUint sourceID);


DSFML_AUDIO_API DInt sfSoundStream_getNumberOfBuffersProccessed(DUint sourceID);

DSFML_AUDIO_API DUint sfSoundStream_UnqueueBuffer(DUint sourceID);

DSFML_AUDIO_API DInt sfSoundStream_getBufferSampleSize(DUint bufferID);

DSFML_AUDIO_API void sfSoundStream_fillBuffer(DUint bufferID, const DShort* samples, DLong sampleCount, DUint soundFormat, DUint sampleRate);

DSFML_AUDIO_API void sfSoundStream_queueBuffer(DUint sourceID, DUint* bufferID);


#endif // DSFML_SOUNDSTREAM_H
