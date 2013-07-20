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

#ifndef SFML_WINDOW_H
#define SFML_WINDOW_H

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
#include <SFML/Window/Export.h>
#include <SFML/Window/Event.h>
#include <SFML/Window/VideoMode.h>
#include <SFML/Window/WindowHandle.h>
#include <SFML/Window/Types.h>



////////////////////////////////////////////////////////////
/// \brief Enumeration of window creation styles
///
////////////////////////////////////////////////////////////
enum
{
    sfNone         = 0,      ///< No border / title bar (this flag and all others are mutually exclusive)
    sfTitlebar     = 1 << 0, ///< Title bar + fixed border
    sfResize       = 1 << 1, ///< Titlebar + resizable border + maximize button
    sfClose        = 1 << 2, ///< Titlebar + close button
    sfFullscreen   = 1 << 3, ///< Fullscreen mode (this flag and all others are mutually exclusive)
    sfDefaultStyle = sfTitlebar | sfResize | sfClose ///< Default window style
};


////////////////////////////////////////////////////////////
/// \brief Structure defining the window's creation settings
///
////////////////////////////////////////////////////////////
typedef struct
{
    unsigned int depthBits;         ///< Bits of the depth buffer
    unsigned int stencilBits;       ///< Bits of the stencil buffer
    unsigned int antialiasingLevel; ///< Level of antialiasing
    unsigned int majorVersion;      ///< Major number of the context version to create
    unsigned int minorVersion;      ///< Minor number of the context version to create
} sfContextSettings;



//Construct a new window
DSFML_WINDOW_API sfWindow* sfWindow_create(DUint width, DUint height, DUint bitsPerPixel, const char* title, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);


//Construct a new window (with a UTF-32 title)
DSFML_WINDOW_API sfWindow* sfWindow_createUnicode(DUint width, DUint height, DUint bitsPerPixel, const DUint* title, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);


//Construct a window from an existing control
DSFML_WINDOW_API sfWindow* sfWindow_createFromHandle(sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);


// Destroy a window
DSFML_WINDOW_API void sfWindow_destroy(sfWindow* window);


//Close a window and destroy all the attached resources
DSFML_WINDOW_API void sfWindow_close(sfWindow* window);


//Tell whether or not a window is opened
DSFML_WINDOW_API DBool sfWindow_isOpen(const sfWindow* window);


//Get the settings of the OpenGL context of a window
DSFML_WINDOW_API void sfWindow_getSettings(const sfWindow* window, DUint* depthBits, DUint* stencilBits, DUint* antialiasingLevel, DUint* majorVersion, DUint* minorVersion);


//Pop the event on top of event queue, if any, and return it
DSFML_WINDOW_API DBool sfWindow_pollEvent(sfWindow* window, DEvent* event);


//Wait for an event and return it
DSFML_WINDOW_API DBool sfWindow_waitEvent(sfWindow* window, DEvent* event);


//Get the position of a window
DSFML_WINDOW_API void sfWindow_getPosition(const sfWindow* window, DInt* x, DInt* y);


//Change the position of a window on screen
DSFML_WINDOW_API void sfWindow_setPosition(sfWindow* window, DInt x, DInt y);


//Get the size of the rendering region of a window
DSFML_WINDOW_API void sfWindow_getSize(const sfWindow* window, DUint* width, DUint* height);


//Change the size of the rendering region of a window
DSFML_WINDOW_API void sfWindow_setSize(sfWindow* window, DUint width, DUint height);


//Change the title of a window
DSFML_WINDOW_API void sfWindow_setTitle(sfWindow* window, const char* title);


//Change the title of a window (with a UTF-32 string)
DSFML_WINDOW_API void sfWindow_setUnicodeTitle(sfWindow* window, const DUint* title);


//Change a window's icon
DSFML_WINDOW_API void sfWindow_setIcon(sfWindow* window, DUint width, DUint height, const DUbyte* pixels);


//Show or hide a window
DSFML_WINDOW_API void sfWindow_setVisible(sfWindow* window, DBool visible);


//Show or hide the mouse cursor
DSFML_WINDOW_API void sfWindow_setMouseCursorVisible(sfWindow* window, DBool visible);


//Enable or disable vertical synchronization
DSFML_WINDOW_API void sfWindow_setVerticalSyncEnabled(sfWindow* window, DBool enabled);


//Enable or disable automatic key-repeat
DSFML_WINDOW_API void sfWindow_setKeyRepeatEnabled(sfWindow* window, DBool enabled);


//Activate or deactivate a window as the current target for OpenGL rendering
DSFML_WINDOW_API DBool sfWindow_setActive(sfWindow* window, DBool active);


//Display on screen what has been rendered to the window so far
DSFML_WINDOW_API void sfWindow_display(sfWindow* window);


//Limit the framerate to a maximum fixed frequency
DSFML_WINDOW_API void sfWindow_setFramerateLimit(sfWindow* window, DUint limit);


//Change the joystick threshold
DSFML_WINDOW_API void sfWindow_setJoystickThreshold(sfWindow* window, float threshold);


//Get the OS-specific handle of the window
DSFML_WINDOW_API sfWindowHandle sfWindow_getSystemHandle(const sfWindow* window);


#endif // SFML_WINDOW_H
