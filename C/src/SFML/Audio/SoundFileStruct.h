
#include <SFML/Audio/SoundFile.hpp>

#include <SFML/System/Mutex.hpp>


struct sfSoundFile
{
    sf::priv::SoundFile This;
    sf::Mutex m_mutex;
};
