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
#include <SFML/Window/Window.h>
#include <SFML/Window/WindowStruct.h>
#include <SFML/Internal.h>
#include <SFML/ConvertEvent.h>


////////////////////////////////////////////////////////////
sfWindow* sfWindow_create(DUint width, DUint height, DUint bitsPerPixel, const char* title, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
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


    // Create the window
    sfWindow* window = new sfWindow;
    window->This.create(videoMode, title, style, params);

    return window;
}


sfWindow* sfWindow_createUnicode(DUint width, DUint height, DUint bitsPerPixel, const DUint* title, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
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


    // Create the window
    sfWindow* window = new sfWindow;
    window->This.create(videoMode, title, style, params);

    return window;
}


////////////////////////////////////////////////////////////
sfWindow* sfWindow_createFromHandle(sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
{
    // Convert context settings
    sf::ContextSettings params;
    params.depthBits         = depthBits;
    params.stencilBits       = stencilBits;
    params.antialiasingLevel = antialiasingLevel;
    params.majorVersion      = majorVersion;
    params.minorVersion      = minorVersion;

    // Create the window
    sfWindow* window = new sfWindow;
    window->This.create(handle, params);

    return window;
}



void sfWindow_destroy(sfWindow* window)
{
    delete window;
}


void sfWindow_close(sfWindow* window)
{
    CSFML_CALL(window, close());
}


DBool sfWindow_isOpen(const sfWindow* window)
{
    CSFML_CALL_RETURN(window, isOpen(), DFalse);
}


void sfWindow_getSettings(const sfWindow* window, DUint* depthBits, DUint* stencilBits, DUint* antialiasingLevel, DUint* majorVersion, DUint* minorVersion)
{

    //CSFML_CHECK_RETURN(window, settings);

    const sf::ContextSettings& params = window->This.getSettings();
    *depthBits         = params.depthBits;
    *stencilBits       = params.stencilBits;
    *antialiasingLevel = params.antialiasingLevel;
    *majorVersion      = params.majorVersion;
    *minorVersion      = params.minorVersion;

}



DBool sfWindow_pollEvent(sfWindow* window, DEvent* event)
{
    CSFML_CHECK_RETURN(window, DFalse);
    CSFML_CHECK_RETURN(event, DFalse);

    // Get the event
    sf::Event SFMLEvent;
    bool ret = window->This.pollEvent(SFMLEvent);

    // No event, return
    if (!ret)
        return DFalse;

    // Convert the sf::Event event to a sfEvent
    convertEvent(SFMLEvent, event);

    return DTrue;
}


////////////////////////////////////////////////////////////
DBool sfWindow_waitEvent(sfWindow* window, DEvent* event)
{
    CSFML_CHECK_RETURN(window, DFalse);
    CSFML_CHECK_RETURN(event, DFalse);

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


////////////////////////////////////////////////////////////
void sfWindow_getPosition(const sfWindow* window, DInt* x, DInt* y)
{
    //sfVector2i position = {0, 0};
    //CSFML_CHECK_RETURN(window, position);

    sf::Vector2i sfmlPos = window->This.getPosition();
    *x = sfmlPos.x;
    *y = sfmlPos.y;


}


////////////////////////////////////////////////////////////
void sfWindow_setPosition(sfWindow* window, DInt x, DInt y)
{
    CSFML_CALL(window, setPosition(sf::Vector2i(x, y)));
}


////////////////////////////////////////////////////////////
void sfWindow_getSize(const sfWindow* window, DUint* width, DUint* height)
{
    //sfVector2u size = {0, 0};
    //CSFML_CHECK_RETURN(window, size);

    sf::Vector2u sfmlSize = window->This.getSize();
    *width = sfmlSize.x;
    *height = sfmlSize.y;


}


////////////////////////////////////////////////////////////
void sfWindow_setSize(sfWindow* window, DUint width, DUint height)
{
    CSFML_CALL(window, setSize(sf::Vector2u(width, height)));
}


////////////////////////////////////////////////////////////
void sfWindow_setTitle(sfWindow* window, const char* title)
{
    CSFML_CALL(window, setTitle(title));
}


////////////////////////////////////////////////////////////
void sfWindow_setUnicodeTitle(sfWindow* window, const DUint* title)
{
    CSFML_CALL(window, setTitle(title));
}


////////////////////////////////////////////////////////////
void sfWindow_setIcon(sfWindow* window, DUint width, DUint height, const DUbyte* pixels)
{
    CSFML_CALL(window, setIcon(width, height, pixels));
}


////////////////////////////////////////////////////////////
void sfWindow_setVisible(sfWindow* window, DBool visible)
{
    CSFML_CALL(window, setVisible(visible == DTrue));
}


////////////////////////////////////////////////////////////
void sfWindow_setMouseCursorVisible(sfWindow* window, DBool visible)
{
    CSFML_CALL(window, setMouseCursorVisible(visible == DTrue));
}


////////////////////////////////////////////////////////////
void sfWindow_setVerticalSyncEnabled(sfWindow* window, DBool enabled)
{
    CSFML_CALL(window, setVerticalSyncEnabled(enabled == DTrue));
}


////////////////////////////////////////////////////////////
void sfWindow_setKeyRepeatEnabled(sfWindow* window, DBool enabled)
{
    CSFML_CALL(window, setKeyRepeatEnabled(enabled == DTrue));
}


////////////////////////////////////////////////////////////
DBool sfWindow_setActive(sfWindow* window, DBool active)
{
    CSFML_CALL_RETURN(window, setActive(active == DTrue), DFalse);
}


////////////////////////////////////////////////////////////
void sfWindow_display(sfWindow* window)
{
    CSFML_CALL(window, display());
}


////////////////////////////////////////////////////////////
void sfWindow_setFramerateLimit(sfWindow* window, DUint limit)
{
    CSFML_CALL(window, setFramerateLimit(limit));
}


////////////////////////////////////////////////////////////
void sfWindow_setJoystickThreshold(sfWindow* window, float threshold)
{
    CSFML_CALL(window, setJoystickThreshold(threshold));
}


////////////////////////////////////////////////////////////
sfWindowHandle sfWindow_getSystemHandle(const sfWindow* window)
{
    CSFML_CHECK_RETURN(window, NULL);

    return (sfWindowHandle)window->This.getSystemHandle();
}
