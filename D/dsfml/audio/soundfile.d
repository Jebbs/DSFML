module dsfml.audio.soundfile;

//TODO: Create a structure around this for code cleanliness

package extern(C):

struct sfSoundFile;

sfSoundFile* sfSoundFile_create();

void sfSoundFile_destroy(sfSoundFile* file);

long sfSoundFile_getSampleCount(const sfSoundFile* file);

uint sfSoundFile_getChannelCount( const sfSoundFile* file);

uint sfSoundFile_getSampleRate(const sfSoundFile* file);

bool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename);

bool sfSoundFile_openReadFromMemory(sfSoundFile* file,const(void)* data, long sizeInBytes);

bool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream);

bool sfSoundFile_openWrite(sfSoundFile* file, const(char)* filename,uint channelCount,uint sampleRate);

long sfSoundFile_read(sfSoundFile* file, short* data, long sampleCount);

void sfSoundFile_write(sfSoundFile* file, const short* data, long sampleCount);

void sfSoundFile_seek(sfSoundFile* file, long timeOffset);
