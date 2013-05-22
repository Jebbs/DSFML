#include <SFML/Audio/SoundFile.h>
#include <SFML/System/InputStream.hpp>
#include <SFML/Audio/SoundFileStruct.h>
#include <SFML/System/Err.hpp>
#include <SFML/System/Lock.hpp>

sfSoundFile* sfSoundFile_create()
{
return new sfSoundFile;
}

void sfSoundFile_destroy(sfSoundFile* file)
{
    delete file;
}

DLong sfSoundFile_getSampleCount(const sfSoundFile* file)
{
    return file->This.getSampleCount();
}

DUint sfSoundFile_getChannelCount( const sfSoundFile* file)
{
        return file->This.getChannelCount();
}

DUint sfSoundFile_getSampleRate(const sfSoundFile* file)
{
    DUint test = file->This.getSampleRate();
    return test;
}

DBool sfSoundFile_openReadFromFile(sfSoundFile* file, const char* filename)
{
    if(file->This.openRead(filename))
    {
        return DTrue;
    }
    return DFalse;
}

DBool sfSoundFile_openReadFromMemory(sfSoundFile* file,void* data, DLong sizeInBytes)
{
    file->This.openRead(data,(size_t)sizeInBytes);
}

DBool sfSoundFile_openReadFromStream(sfSoundFile* file, void* stream)
{
    sf::InputStream* temp = (sf::InputStream*)stream;

    file->This.openRead(*temp);
}

DBool sfSoundFile_openWrite(sfSoundFile* file, const char* filename,DUint channelCount,DUint sampleRate)
{
    file->This.openWrite(filename,channelCount,sampleRate);
}

DLong sfSoundFile_read(sfSoundFile* file, DShort* data, DLong sampleCount)
{
    //sf::Lock Lock(file->m_mutex);

    return file->This.read(data, (size_t)sampleCount);
}

void sfSoundFile_write(sfSoundFile* file, const DShort* data, DLong sampleCount)
{
    file->This.write(data,(size_t)sampleCount);
}

void sfSoundFile_seek(sfSoundFile* file, DLong timeOffset)
{
   //sf::Lock Lock(file->m_mutex);
    sf::Time temp = sf::microseconds(timeOffset);
    sf::err()<<"Calling seek in SFML" << std::endl;
    file->This.seek(temp);
}
