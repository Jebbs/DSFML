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
#include <SFML/Window/VideoMode.h>
#include <SFML/Window/VideoMode.hpp>
#include <SFML/Internal.h>
#include <iostream>


////////////////////////////////////////////////////////////
void sfVideoMode_getDesktopMode(DUint* width, DUint* height, DUint* bitsPerPixel)
{
    sf::VideoMode desktop = sf::VideoMode::getDesktopMode();

    *width        = desktop.width;
    *height       = desktop.height;
    *bitsPerPixel = desktop.bitsPerPixel;


}


////////////////////////////////////////////////////////////
const DUint* sfVideoMode_getFullscreenModes(size_t* count)
{
    static std::vector<DUint> modes;

    // Populate the array on first call
    if (modes.empty())
    {
        const std::vector<sf::VideoMode>& SFMLModes = sf::VideoMode::getFullscreenModes();
        for (std::vector<sf::VideoMode>::const_iterator it = SFMLModes.begin(); it != SFMLModes.end(); ++it)
        {

            modes.push_back(it->width);
            modes.push_back(it->height);
            modes.push_back(it->bitsPerPixel);
        }
    }

    if (count)
        *count = modes.size();

    return !modes.empty() ? &modes[0] : NULL;
}


////////////////////////////////////////////////////////////
DBool sfVideoMode_isValid(DUint width, DUint height, DUint bitsPerPixel)
{
    sf::VideoMode videoMode(width, height, bitsPerPixel);
    return videoMode.isValid() ? DTrue : DFalse;
}
