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

#include <DSFMLC/Audio/Listener.h>
#include <SFML/Audio/Listener.hpp>
#include <SFML/System/Vector3.hpp>

void sfListener_setGlobalVolume(float volume)
{
    sf::Listener::setGlobalVolume(volume);
}

float sfListener_getGlobalVolume(void)
{
    return sf::Listener::getGlobalVolume();
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

void sfListener_setUpVector(float x, float y, float z)
{
    sf::Listener::setUpVector(x,y,z);
}

void sfListener_getUpVector(float* x, float* y, float* z)
{
    sf::Vector3f temp;

    temp = sf::Listener::getUpVector();

    *x = temp.x;
    *y = temp.y;
    *z = temp.z;
}
