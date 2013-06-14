////////////////////////////////////////////////////////////
//
// SFML - Simple and Fast Multimedia Library
// Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it freely,
// subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented;
//    you must not claim that you wrote the original software.
//    If you use this software in a product, an acknowledgment
//    in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such,
//    and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.
//
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
#include <SFML/Audio/SoundFile.hpp>
#include <SFML/System/InputStream.hpp>
#include <SFML/System/Err.hpp>
#include <cstring>
#include <cctype>


namespace
{
    // Convert a string to lower case
    std::string toLower(std::string str)
    {
        for (std::string::iterator i = str.begin(); i != str.end(); ++i)
            *i = static_cast<char>(std::tolower(*i));
        return str;
    }
}


namespace sf
{
namespace priv
{
////////////////////////////////////////////////////////////
SoundFile::SoundFile() :
m_file        (NULL),
m_sampleCount (0),
m_channelCount(0),
m_sampleRate  (0)
{

}


////////////////////////////////////////////////////////////
SoundFile::~SoundFile()
{
    if (m_file)
        sf_close(m_file);
}


////////////////////////////////////////////////////////////
std::size_t SoundFile::getSampleCount() const
{
    return m_sampleCount;
}


////////////////////////////////////////////////////////////
unsigned int SoundFile::getChannelCount() const
{
    return m_channelCount;
}


////////////////////////////////////////////////////////////
unsigned int SoundFile::getSampleRate() const
{
    return m_sampleRate;
}


////////////////////////////////////////////////////////////
bool SoundFile::openRead(const std::string& filename)
{
    // If the file is already opened, first close it
    if (m_file)
        sf_close(m_file);

    // Open the sound file
    SF_INFO fileInfo;
    m_file = sf_open(filename.c_str(), SFM_READ, &fileInfo);
    if (!m_file)
    {
        err() << "Failed to open sound file \"" << filename << "\" (" << sf_strerror(m_file) << ")" << std::endl;
        return false;
    }

    // Initialize the internal state from the loaded information
    initialize(fileInfo);

    return true;
}


////////////////////////////////////////////////////////////
bool SoundFile::openRead(const void* data, std::size_t sizeInBytes)
{
    // If the file is already opened, first close it
    if (m_file)
        sf_close(m_file);

    // Prepare the memory I/O structure
    SF_VIRTUAL_IO io;
    io.get_filelen = &Memory::getLength;
    io.read        = &Memory::read;
    io.seek        = &Memory::seek;
    io.tell        = &Memory::tell;

    // Initialize the memory data
    m_memory.DataStart = static_cast<const char*>(data);
    m_memory.DataPtr   = m_memory.DataStart;
    m_memory.TotalSize = sizeInBytes;

    // Open the sound file
    SF_INFO fileInfo;
    m_file = sf_open_virtual(&io, SFM_READ, &fileInfo, &m_memory);
    if (!m_file)
    {
        err() << "Failed to open sound file from memory (" << sf_strerror(m_file) << ")" << std::endl;
        return false;
    }

    // Initialize the internal state from the loaded information
    initialize(fileInfo);

    return true;
}


////////////////////////////////////////////////////////////
bool SoundFile::openRead(InputStream& stream)
{
    // If the file is already opened, first close it
    if (m_file)
        sf_close(m_file);

    // Prepare the memory I/O structure
    SF_VIRTUAL_IO io;
    io.get_filelen = &Stream::getLength;
    io.read        = &Stream::read;
    io.seek        = &Stream::seek;
    io.tell        = &Stream::tell;

    // Open the sound file
    SF_INFO fileInfo;
    m_file = sf_open_virtual(&io, SFM_READ, &fileInfo, &stream);
    if (!m_file)
    {
        err() << "Failed to open sound file from stream (" << sf_strerror(m_file) << ")" << std::endl;
        return false;
    }

    // Initialize the internal state from the loaded information
    initialize(fileInfo);

    return true;
}


////////////////////////////////////////////////////////////
bool SoundFile::openWrite(const std::string& filename, unsigned int channelCount, unsigned int sampleRate)
{
    // If the file is already opened, first close it
    if (m_file)
        sf_close(m_file);

    // Find the right format according to the file extension
    int format = getFormatFromFilename(filename);
    if (format == -1)
    {
        // Error : unrecognized extension
        err() << "Failed to create sound file \"" << filename << "\" (unknown format)" << std::endl;
        return false;
    }

    // Fill the sound infos with parameters
    SF_INFO fileInfos;
    fileInfos.channels   = channelCount;
    fileInfos.samplerate = sampleRate;
    fileInfos.format     = format | (format == SF_FORMAT_OGG ? SF_FORMAT_VORBIS : SF_FORMAT_PCM_16);

    // Open the sound file for writing
    m_file = sf_open(filename.c_str(), SFM_WRITE, &fileInfos);
    if (!m_file)
    {
        err() << "Failed to create sound file \"" << filename << "\" (" << sf_strerror(m_file) << ")" << std::endl;
        return false;
    }

    // Set the sound parameters
    m_channelCount = channelCount;
    m_sampleRate   = sampleRate;
    m_sampleCount  = 0;

    return true;
}


////////////////////////////////////////////////////////////
std::size_t SoundFile::read(Int16* data, std::size_t sampleCount)
{
    if (m_file && data && sampleCount)
        return static_cast<std::size_t>(sf_read_short(m_file, data, sampleCount));
    else
        return 0;
}


////////////////////////////////////////////////////////////
void SoundFile::write(const Int16* data, std::size_t sampleCount)
{
    if (m_file && data && sampleCount)
    {
        // Write small chunks instead of everything at once,
        // to avoid a stack overflow in libsndfile (happens only with OGG format)
        while (sampleCount > 0)
        {
            std::size_t count = sampleCount > 10000 ? 10000 : sampleCount;
            sf_write_short(m_file, data, count);
            data += count;
            sampleCount -= count;
        }
    }
}


////////////////////////////////////////////////////////////
void SoundFile::seek(Time timeOffset)
{
    if (m_file)
    {
        sf_count_t frameOffset = static_cast<sf_count_t>(timeOffset.asSeconds() * m_sampleRate);
        sf_seek(m_file, frameOffset, SEEK_SET);
    }
}


////////////////////////////////////////////////////////////
void SoundFile::initialize(SF_INFO fileInfo)
{
    // Save the sound properties
    m_channelCount = fileInfo.channels;
    m_sampleRate   = fileInfo.samplerate;
    m_sampleCount  = static_cast<std::size_t>(fileInfo.frames) * fileInfo.channels;

    // Enable scaling for Vorbis files (float samples)
    // @todo enable when it's faster (it currently has to iterate over the *whole* music)
    //if (fileInfo.format & SF_FORMAT_VORBIS)
    //    sf_command(m_file, SFC_SET_SCALE_FLOAT_INT_READ, NULL, SF_TRUE);
}


////////////////////////////////////////////////////////////
int SoundFile::getFormatFromFilename(const std::string& filename)
{
    // Extract the extension
    std::string ext = "wav";
    std::string::size_type pos = filename.find_last_of(".");
    if (pos != std::string::npos)
        ext = filename.substr(pos + 1);

    // Match every supported extension with its format constant
    if (toLower(ext) == "wav"  ) return SF_FORMAT_WAV;
    if (toLower(ext) == "aif"  ) return SF_FORMAT_AIFF;
    if (toLower(ext) == "aiff" ) return SF_FORMAT_AIFF;
    if (toLower(ext) == "au"   ) return SF_FORMAT_AU;
    if (toLower(ext) == "raw"  ) return SF_FORMAT_RAW;
    if (toLower(ext) == "paf"  ) return SF_FORMAT_PAF;
    if (toLower(ext) == "svx"  ) return SF_FORMAT_SVX;
    if (toLower(ext) == "nist" ) return SF_FORMAT_NIST;
    if (toLower(ext) == "voc"  ) return SF_FORMAT_VOC;
    if (toLower(ext) == "sf"   ) return SF_FORMAT_IRCAM;
    if (toLower(ext) == "w64"  ) return SF_FORMAT_W64;
    if (toLower(ext) == "mat4" ) return SF_FORMAT_MAT4;
    if (toLower(ext) == "mat5" ) return SF_FORMAT_MAT5;
    if (toLower(ext) == "pvf"  ) return SF_FORMAT_PVF;
    if (toLower(ext) == "xi"   ) return SF_FORMAT_XI;
    if (toLower(ext) == "htk"  ) return SF_FORMAT_HTK;
    if (toLower(ext) == "sds"  ) return SF_FORMAT_SDS;
    if (toLower(ext) == "avr"  ) return SF_FORMAT_AVR;
    if (toLower(ext) == "sd2"  ) return SF_FORMAT_SD2;
    if (toLower(ext) == "flac" ) return SF_FORMAT_FLAC;
    if (toLower(ext) == "caf"  ) return SF_FORMAT_CAF;
    if (toLower(ext) == "wve"  ) return SF_FORMAT_WVE;
    if (toLower(ext) == "ogg"  ) return SF_FORMAT_OGG;
    if (toLower(ext) == "mpc2k") return SF_FORMAT_MPC2K;
    if (toLower(ext) == "rf64" ) return SF_FORMAT_RF64;

    return -1;
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Memory::getLength(void* user)
{
    Memory* memory = static_cast<Memory*>(user);
    return memory->TotalSize;
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Memory::read(void* ptr, sf_count_t count, void* user)
{
    Memory* memory = static_cast<Memory*>(user);

    sf_count_t position = memory->DataPtr - memory->DataStart;
    if (position + count >= memory->TotalSize)
        count = memory->TotalSize - position;

    std::memcpy(ptr, memory->DataPtr, static_cast<std::size_t>(count));
    memory->DataPtr += count;
    return count;
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Memory::seek(sf_count_t offset, int whence, void* user)
{
    Memory* memory = static_cast<Memory*>(user);
    sf_count_t position = 0;
    switch (whence)
    {
        case SEEK_SET : position = offset;                                       break;
        case SEEK_CUR : position = memory->DataPtr - memory->DataStart + offset; break;
        case SEEK_END : position = memory->TotalSize - offset;                   break;
        default       : position = 0;                                            break;
    }

    if (position >= memory->TotalSize)
        position = memory->TotalSize - 1;
    else if (position < 0)
        position = 0;

    memory->DataPtr = memory->DataStart + position;
    return position;
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Memory::tell(void* user)
{
    Memory* memory = static_cast<Memory*>(user);
    return memory->DataPtr - memory->DataStart;
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Stream::getLength(void* userData)
{
    sf::InputStream* stream = static_cast<sf::InputStream*>(userData);
    return stream->getSize();
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Stream::read(void* ptr, sf_count_t count, void* userData)
{
    sf::InputStream* stream = static_cast<sf::InputStream*>(userData);
    return stream->read(reinterpret_cast<char*>(ptr), count);
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Stream::seek(sf_count_t offset, int whence, void* userData)
{
    sf::InputStream* stream = static_cast<sf::InputStream*>(userData);
    switch (whence)
    {
        case SEEK_SET : return stream->seek(offset);
        case SEEK_CUR : return stream->seek(stream->tell() + offset);
        case SEEK_END : return stream->seek(stream->getSize() - offset);
        default       : return stream->seek(0);
    }
}


////////////////////////////////////////////////////////////
sf_count_t SoundFile::Stream::tell(void* userData)
{
    sf::InputStream* stream = static_cast<sf::InputStream*>(userData);
    return stream->tell();
}

} // namespace priv

} // namespace sf
