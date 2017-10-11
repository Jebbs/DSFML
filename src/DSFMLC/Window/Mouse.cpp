/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution


***All code is based on code written by Laurent Gomila***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML - For a full list see http://www.sfml-dev.org/license.php
*/

// Headers
#include <DSFMLC/Window/Mouse.h>
#include <DSFMLC/Window/WindowStruct.h>
#include <SFML/Window/Mouse.hpp>



DBool sfMouse_isButtonPressed(DInt button)
{
    return sf::Mouse::isButtonPressed(static_cast<sf::Mouse::Button>(button)) ? DTrue : DFalse;
}



void sfMouse_getPosition(const sfWindow* relativeTo, DInt* x, DInt* y)
{
    sf::Vector2i sfmlPos;
    if (relativeTo)
        sfmlPos = sf::Mouse::getPosition(relativeTo->This);
    else
        sfmlPos = sf::Mouse::getPosition();

    *x = sfmlPos.x;
    *y = sfmlPos.y;
}



void sfMouse_setPosition(DInt x, DInt y, const sfWindow* relativeTo)
{
    if (relativeTo)
        sf::Mouse::setPosition(sf::Vector2i(x, y), relativeTo->This);
    else
        sf::Mouse::setPosition(sf::Vector2i(x, y));
}
