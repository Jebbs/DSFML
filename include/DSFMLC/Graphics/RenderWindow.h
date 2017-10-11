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

#ifndef SFML_RENDERWINDOW_H
#define SFML_RENDERWINDOW_H

// Headers
#include <DSFMLC/Graphics/Export.h>
#include <DSFMLC/Graphics/Types.h>
#include <DSFMLC/Window/Event.h>
#include <DSFMLC/Window/VideoMode.h>
#include <DSFMLC/Window/WindowHandle.h>
#include <DSFMLC/Window/Window.h>
#include <stddef.h>

//Construct a new render window
DSFML_GRAPHICS_API sfRenderWindow* sfRenderWindow_construct(void);

//Construct a new render window from settings
DSFML_GRAPHICS_API sfRenderWindow* sfRenderWindow_constructFromSettings(DUint width, DUint height, DUint bitsPerPixel, const DUint* title, size_t titleLength, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);

//Construct a render window from an existing control
DSFML_GRAPHICS_API sfRenderWindow* sfRenderWindow_constructFromHandle(sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);

//Create(or recreate) a new render window from settings
DSFML_GRAPHICS_API void sfRenderWindow_createFromSettings(sfRenderWindow* renderWindow, DUint width, DUint height, DUint bitsPerPixel, const DUint* title, size_t titleLength, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);

//Create(or recreate) a render window from an existing control
DSFML_GRAPHICS_API void sfRenderWindow_createFromHandle(sfRenderWindow* renderWindow, sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion);

//Destroy an existing render window
DSFML_GRAPHICS_API void sfRenderWindow_destroy(sfRenderWindow* renderWindow);

//Close a render window (but doesn't destroy the internal data)
DSFML_GRAPHICS_API void sfRenderWindow_close(sfRenderWindow* renderWindow);

//Tell whether or not a render window is opened
DSFML_GRAPHICS_API DBool sfRenderWindow_isOpen(const sfRenderWindow* renderWindow);

//Get the creation settings of a render window
DSFML_GRAPHICS_API void sfRenderWindow_getSettings(const sfRenderWindow* renderWindow, DUint* depthBits, DUint* stencilBits, DUint* antialiasingLevel, DUint* majorVersion, DUint* minorVersion);

//Get the event on top of event queue of a render window, if any, and pop it
DSFML_GRAPHICS_API DBool sfRenderWindow_pollEvent(sfRenderWindow* renderWindow, DEvent* event);

//Wait for an event and return it
DSFML_GRAPHICS_API DBool sfRenderWindow_waitEvent(sfRenderWindow* renderWindow, DEvent* event);

//Get the position of a render window
DSFML_GRAPHICS_API void sfRenderWindow_getPosition(const sfRenderWindow* renderWindow, DInt* x, DInt* y);

//Change the position of a render window on screen
DSFML_GRAPHICS_API void sfRenderWindow_setPosition(sfRenderWindow* renderWindow, DInt x, DInt y);

//Get the size of the rendering region of a render window
DSFML_GRAPHICS_API void sfRenderWindow_getSize(const sfRenderWindow* renderWindow, DUint* width, DUint* height);

//Change the size of the rendering region of a render window
DSFML_GRAPHICS_API void sfRenderWindow_setSize(sfRenderWindow* renderWindow, DInt width, DInt height);

//Change the title of a render window
DSFML_GRAPHICS_API void sfRenderWindow_setTitle(sfRenderWindow* renderWindow, const char* title, size_t length);

//Change the title of a render window (with a UTF-32 string)
DSFML_GRAPHICS_API void sfRenderWindow_setUnicodeTitle(sfRenderWindow* renderWindow, const DUint* title, size_t length);

//Change a render window's icon
DSFML_GRAPHICS_API void sfRenderWindow_setIcon(sfRenderWindow* renderWindow, DUint width, DUint height, const DUbyte* pixels);

//Show or hide a render window
DSFML_GRAPHICS_API void sfRenderWindow_setVisible(sfRenderWindow* renderWindow, DBool visible);

//Show or hide the mouse cursor on a render window
DSFML_GRAPHICS_API void sfRenderWindow_setMouseCursorVisible(sfRenderWindow* renderWindow, DBool show);

//Enable / disable vertical synchronization on a render window
DSFML_GRAPHICS_API void sfRenderWindow_setVerticalSyncEnabled(sfRenderWindow* renderWindow, DBool enabled);

//Enable or disable automatic key-repeat for keydown events
DSFML_GRAPHICS_API void sfRenderWindow_setKeyRepeatEnabled(sfRenderWindow* renderWindow, DBool enabled);

//Activate or deactivate a render window as the current target for rendering
DSFML_GRAPHICS_API DBool sfRenderWindow_setActive(sfRenderWindow* renderWindow, DBool active);

//Display a render window on screen
DSFML_GRAPHICS_API void sfRenderWindow_display(sfRenderWindow* renderWindow);

//Limit the framerate to a maximum fixed frequency for a render window
DSFML_GRAPHICS_API void sfRenderWindow_setFramerateLimit(sfRenderWindow* renderWindow, DUint limit);

//Change the joystick threshold, ie. the value below which no move event will be generated
DSFML_GRAPHICS_API void sfRenderWindow_setJoystickThreshold(sfRenderWindow* renderWindow, float threshold);

//Retrieve the OS-specific handle of a render window
DSFML_GRAPHICS_API sfWindowHandle sfRenderWindow_getSystemHandle(const sfRenderWindow* renderWindow);

//Clear a render window with the given color
DSFML_GRAPHICS_API void sfRenderWindow_clear(sfRenderWindow* renderWindow, DUbyte r, DUbyte g, DUbyte b, DUbyte a);

//Change the current active view of a render window
DSFML_GRAPHICS_API void sfRenderWindow_setView(sfRenderWindow* renderWindow, float centerX, float centerY, float sizeX,
												float sizeY, float rotation, float viewportLeft, float viewportTop, float viewportWidth,
												float viewportHeight);

//Get the current active view of a render window
DSFML_GRAPHICS_API void sfRenderWindow_getView(const sfRenderWindow* renderWindow, float* centerX, float* centerY, float* sizeX,
												float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
												float* viewportHeight);

//Get the default view of a render window
DSFML_GRAPHICS_API void sfRenderWindow_getDefaultView(const sfRenderWindow* renderWindow, float* centerX, float* centerY, float* sizeX,
														float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
														float* viewportHeight);

//Draw primitives defined by an array of vertices to a render window
DSFML_GRAPHICS_API void sfRenderWindow_drawPrimitives(sfRenderWindow* renderWindow,
                                                      const void* vertices, DUint vertexCount,
                                                      DInt type, DInt colorSrcFactor, DInt colorDstFactor, DInt colorEquation,
													  DInt alphaSrcFactor, DInt alphaDstFactor, DInt alphaEquation, const float* transform, const sfTexture* texture, const sfShader* shader);

//Save the current OpenGL render states and matrices
DSFML_GRAPHICS_API void sfRenderWindow_pushGLStates(sfRenderWindow* renderWindow);

//Restore the previously saved OpenGL render states and matrices
DSFML_GRAPHICS_API void sfRenderWindow_popGLStates(sfRenderWindow* renderWindow);

//Reset the internal OpenGL states so that the target is ready for drawing
DSFML_GRAPHICS_API void sfRenderWindow_resetGLStates(sfRenderWindow* renderWindow);

//Copy the current contents of a render window to an image
DSFML_GRAPHICS_API sfImage* sfRenderWindow_capture(const sfRenderWindow* renderWindow);

//Get the current position of the mouse relatively to a render-window
DSFML_GRAPHICS_API void sfMouse_getPositionRenderWindow(const sfRenderWindow* relativeTo, DInt* x, DInt* y);

//Set the current position of the mouse relatively to a render-window
DSFML_GRAPHICS_API void sfMouse_setPositionRenderWindow(DInt x, DInt y, const sfRenderWindow* relativeTo);


#endif // SFML_RENDERWINDOW_H
