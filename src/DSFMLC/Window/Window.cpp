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
#include <DSFMLC/Window/Window.h>
#include <DSFMLC/Window/WindowStruct.h>
#include <DSFMLC/ConvertEvent.h>
#include <SFML/System/String.hpp>


sfWindow* sfWindow_construct(void)
{
    return new sfWindow;
}

void sfWindow_createFromSettings(sfWindow* window, DUint width, DUint height, DUint bitsPerPixel, const DUint* title, size_t titleLength, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
{
    // Convert video mode
    sf::VideoMode videoMode(width, height, bitsPerPixel);

    // Convert context settings
    sf::ContextSettings params;

        params.depthBits         = depthBits;
        params.stencilBits       = stencilBits;
        params.antialiasingLevel = antialiasingLevel;
        params.majorVersion      = majorVersion;
        params.minorVersion      = minorVersion;


    window->This.create(videoMode, sf::String(std::basic_string<DUint>(title, titleLength)), style, params);
}

void sfWindow_createFromHandle(sfWindow* window, sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
{
    // Convert context settings
    sf::ContextSettings params;
    params.depthBits         = depthBits;
    params.stencilBits       = stencilBits;
    params.antialiasingLevel = antialiasingLevel;
    params.majorVersion      = majorVersion;
    params.minorVersion      = minorVersion;

    window->This.create(handle, params);
}



void sfWindow_destroy(sfWindow* window)
{
    delete window;
}


void sfWindow_close(sfWindow* window)
{
    window->This.close();
}


DBool sfWindow_isOpen(const sfWindow* window)
{
    return window->This.isOpen()?DTrue:DFalse;
}


void sfWindow_getSettings(const sfWindow* window, DUint* depthBits, DUint* stencilBits, DUint* antialiasingLevel, DUint* majorVersion, DUint* minorVersion)
{

    const sf::ContextSettings& params = window->This.getSettings();
    *depthBits         = params.depthBits;
    *stencilBits       = params.stencilBits;
    *antialiasingLevel = params.antialiasingLevel;
    *majorVersion      = params.majorVersion;
    *minorVersion      = params.minorVersion;

}



DBool sfWindow_pollEvent(sfWindow* window, DEvent* event)
{

    // Get the event
    sf::Event SFMLEvent;
    bool ret = window->This.pollEvent(SFMLEvent);

    // No event, return
    if (!ret)
        return DFalse;

    // Convert the sf::Event event to a DSFML Event
    convertEvent(SFMLEvent, event);

    return DTrue;
}


DBool sfWindow_waitEvent(sfWindow* window, DEvent* event)
{

    // Get the event
    sf::Event SFMLEvent;
    bool ret = window->This.waitEvent(SFMLEvent);

    // Error, return
    if (!ret)
        return DFalse;

    // Convert the sf::Event event to a sfEvent
    convertEvent(SFMLEvent, event);

    return DTrue;
}


void sfWindow_getPosition(const sfWindow* window, DInt* x, DInt* y)
{
    sf::Vector2i sfmlPos = window->This.getPosition();
    *x = sfmlPos.x;
    *y = sfmlPos.y;
}


void sfWindow_setPosition(sfWindow* window, DInt x, DInt y)
{
   window->This.setPosition(sf::Vector2i(x, y));
}


void sfWindow_getSize(const sfWindow* window, DUint* width, DUint* height)
{
    sf::Vector2u sfmlSize = window->This.getSize();
    *width = sfmlSize.x;
    *height = sfmlSize.y;


}


void sfWindow_setSize(sfWindow* window, DUint width, DUint height)
{
    window->This.setSize(sf::Vector2u(width, height));
}


void sfWindow_setTitle(sfWindow* window, const char* title)
{
    window->This.setTitle(title);
}


void sfWindow_setUnicodeTitle(sfWindow* window, const DUint* title, size_t length)
{
    window->This.setTitle(std::basic_string<DUint>(title, length));
}


void sfWindow_setIcon(sfWindow* window, DUint width, DUint height, const DUbyte* pixels)
{
    window->This.setIcon(width, height, pixels);
}


void sfWindow_setVisible(sfWindow* window, DBool visible)
{
    window->This.setVisible(visible == DTrue);
}


void sfWindow_setMouseCursorVisible(sfWindow* window, DBool visible)
{
    window->This.setMouseCursorVisible(visible == DTrue);
}


void sfWindow_setVerticalSyncEnabled(sfWindow* window, DBool enabled)
{
    window->This.setVerticalSyncEnabled(enabled == DTrue);
}


void sfWindow_setKeyRepeatEnabled(sfWindow* window, DBool enabled)
{
    window->This.setKeyRepeatEnabled(enabled == DTrue);
}


DBool sfWindow_setActive(sfWindow* window, DBool active)
{
    return window->This.setActive(active == DTrue)?DTrue: DFalse;
}


void sfWindow_display(sfWindow* window)
{
    window->This.display();
}

void sfWindow_requestFocus(sfWindow* window)
{
	window->This.requestFocus();
}

DBool sfWindow_hasFocus(const sfWindow * window) {
	return (window->This.hasFocus())?DTrue: DFalse;
}


void sfWindow_setFramerateLimit(sfWindow* window, DUint limit)
{
    window->This.setFramerateLimit(limit);
}


void sfWindow_setJoystickThreshold(sfWindow* window, float threshold)
{
    window->This.setJoystickThreshold(threshold);
}


sfWindowHandle sfWindow_getSystemHandle(const sfWindow* window)
{
    return (sfWindowHandle)window->This.getSystemHandle();
}
