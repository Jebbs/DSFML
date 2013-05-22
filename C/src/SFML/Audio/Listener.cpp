#include <SFML/Audio/Listener.h>
#include <SFML/Audio/Listener.hpp>
#include <SFML/System/Vector3.hpp>

void sfListener_setGlobalVolume(float volume)
{
    sf::Listener::setGlobalVolume(volume);
}


float sfListener_getGlobalVolume(void)
{
    sf::Listener::getGlobalVolume();
}


void sfListener_setPosition(float x, float y, float z)
{

    sf::Listener::setPosition(x,y,z);
}


void sfListener_getPosition(float* x, float* y, float* z)
{
    sf::Vector3f temp;

    temp = sf::Listener::getPosition();

    *x = temp.x;
    *y = temp.y;
    *z = temp.z;
}


void sfListener_setDirection(float x, float y, float z)
{
    sf::Listener::setDirection(x,y,z);
}


void sfListener_getDirection(float* x, float* y, float* z)
{
    sf::Vector3f temp;

    temp = sf::Listener::getDirection();

    *x = temp.x;
    *y = temp.y;
    *z = temp.z;
}
