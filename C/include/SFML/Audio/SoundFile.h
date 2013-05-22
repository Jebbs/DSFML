
#ifndef DSFML_SOUNDFILE_H
#define DSFML_SOUNDFILE_H

#include <SFML/Audio/Export.h>
#include <SFML/Audio/Types.h>

DSFML_AUDIO_API sfSoundFile* sfSoundFile_create();

DSFML_AUDIO_API void sfSoundFile_destroy(sfSoundFile* file);

DSFML_AUDIO_API DLong sfSoundFile_getSampleCount(const sfSoundFile* file);

DSFML_AUDIO_API DUint sfSoundFile_getChannelCount( const sfSoundFile* file);

DSFML_AUDIO_API DUint sfSoundFile_getSampleRate(const sfSoundFile* file);

DSFML_AUDIO_API DBool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename);

DSFML_AUDIO_API DBool sfSoundFile_openReadFromMemory(sfSoundFile* file,void* data, DLong sizeInBytes);

DSFML_AUDIO_API DBool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream);

DSFML_AUDIO_API DBool sfSoundFile_openWrite(sfSoundFile* file, const char* filename,DUint channelCount,DUint sampleRate);

DSFML_AUDIO_API DLong sfSoundFile_read(sfSoundFile* file, DShort* data, DLong sampleCount);

DSFML_AUDIO_API void sfSoundFile_write(sfSoundFile* file, const DShort* data, DLong sampleCount);

DSFML_AUDIO_API void sfSoundFile_seek(sfSoundFile* file, DLong timeOffset);


#endif // DSFML_SOUNDFILE_H
