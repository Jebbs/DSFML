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

#include <DSFMLC/Graphics/RenderWindow.h>
#include <DSFMLC/Graphics/RenderWindowStruct.h>
#include <DSFMLC/Graphics/ImageStruct.h>
#include <DSFMLC/Graphics/CreateRenderStates.hpp>
#include <DSFMLC/ConvertEvent.h>
#include <SFML/System/String.hpp>

sfRenderWindow* sfRenderWindow_construct(void)
{
    return new sfRenderWindow;
}

sfRenderWindow* sfRenderWindow_constructFromSettings(DUint width, DUint height, DUint bitsPerPixel, const DUint* title, size_t titleLength, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
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
    sfRenderWindow* renderWindow = new sfRenderWindow;
    renderWindow->This.create(videoMode, sf::String(std::basic_string<DUint>(title, titleLength)), style, params);

    return renderWindow;
}

sfRenderWindow* sfRenderWindow_constructFromHandle(sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
{
    // Convert context settings
    sf::ContextSettings params;

    params.depthBits         = depthBits;
    params.stencilBits       = stencilBits;
    params.antialiasingLevel = antialiasingLevel;
    params.majorVersion      = majorVersion;
    params.minorVersion      = minorVersion;

    // Create the window
    sfRenderWindow* renderWindow = new sfRenderWindow;
    renderWindow->This.create(handle, params);

    return renderWindow;
}

void sfRenderWindow_createFromSettings(sfRenderWindow* renderWindow, DUint width, DUint height, DUint bitsPerPixel, const DUint* title, size_t titleLength, DInt style, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
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

    renderWindow->This.create(videoMode, sf::String(std::basic_string<DUint>(title, titleLength)), style, params);
}

void sfRenderWindow_createFromHandle(sfRenderWindow* renderWindow, sfWindowHandle handle, DUint depthBits, DUint stencilBits, DUint antialiasingLevel, DUint majorVersion, DUint minorVersion)
{
    // Convert context settings
    sf::ContextSettings params;

    params.depthBits         = depthBits;
    params.stencilBits       = stencilBits;
    params.antialiasingLevel = antialiasingLevel;
    params.majorVersion      = majorVersion;
    params.minorVersion      = minorVersion;

    renderWindow->This.create(handle, params);
}

void sfRenderWindow_destroy(sfRenderWindow* renderWindow)
{
    delete renderWindow;
}

void sfRenderWindow_close(sfRenderWindow* renderWindow)
{
    renderWindow->This.close();
}

DBool sfRenderWindow_isOpen(const sfRenderWindow* renderWindow)
{
    return renderWindow->This.isOpen()?DTrue: DFalse;
}

void sfRenderWindow_getSettings(const sfRenderWindow* renderWindow, DUint* depthBits, DUint* stencilBits, DUint* antialiasingLevel, DUint* majorVersion, DUint* minorVersion)
{
    const sf::ContextSettings& params = renderWindow->This.getSettings();
    *depthBits         = params.depthBits;
    *stencilBits       = params.stencilBits;
    *antialiasingLevel = params.antialiasingLevel;
    *majorVersion      = params.majorVersion;
    *minorVersion      = params.minorVersion;

}

DBool sfRenderWindow_pollEvent(sfRenderWindow* renderWindow, DEvent* event)
{
    // Get the event
    sf::Event SFMLEvent;
    DBool ret = renderWindow->This.pollEvent(SFMLEvent);

    // No event, return
    if (!ret)
        return DFalse;

    // Convert the sf::Event event to a DSFML Event
    convertEvent(SFMLEvent, event);

    return DTrue;
}

DBool sfRenderWindow_waitEvent(sfRenderWindow* renderWindow, DEvent* event)
{
    // Get the event
    sf::Event SFMLEvent;
    DBool ret = renderWindow->This.waitEvent(SFMLEvent);

    // Error, return
    if (!ret)
        return DFalse;

    // Convert the sf::Event event to a sfEvent
    convertEvent(SFMLEvent, event);

    return DTrue;
}

void sfRenderWindow_getPosition(const sfRenderWindow* renderWindow, DInt* x, DInt* y)
{
    sf::Vector2i sfmlPos = renderWindow->This.getPosition();
    *x = sfmlPos.x;
    *y = sfmlPos.y;
}

void sfRenderWindow_setPosition(sfRenderWindow* renderWindow, DInt x, DInt y)
{
    renderWindow->This.setPosition(sf::Vector2i(x, y));
}

void sfRenderWindow_getSize(const sfRenderWindow* renderWindow, DUint* width, DUint* height)
{
    sf::Vector2u sfmlSize = renderWindow->This.getSize();
    *width = sfmlSize.x;
    *height = sfmlSize.y;
}

void sfRenderWindow_setSize(sfRenderWindow* renderWindow, DInt width, DInt height)
{
    renderWindow->This.setSize(sf::Vector2u(width, height));
}

void sfRenderWindow_setTitle(sfRenderWindow* renderWindow, const char* title, size_t length)
{
    renderWindow->This.setTitle(std::string(title, length));
}

void sfRenderWindow_setUnicodeTitle(sfRenderWindow* renderWindow, const DUint* title, size_t length)
{
    renderWindow->This.setTitle(sf::String(std::basic_string<DUint>(title, length)));
}

void sfRenderWindow_setIcon(sfRenderWindow* renderWindow, DUint width, DUint height, const DUbyte* pixels)
{
    renderWindow->This.setIcon(width, height, pixels);
}

void sfRenderWindow_setVisible(sfRenderWindow* renderWindow, DBool visible)
{
    renderWindow->This.setVisible(visible == DTrue);
}

void sfRenderWindow_setMouseCursorVisible(sfRenderWindow* renderWindow, DBool visible)
{
   renderWindow->This.setMouseCursorVisible(visible == DTrue);
}

void sfRenderWindow_setVerticalSyncEnabled(sfRenderWindow* renderWindow, DBool enabled)
{
    renderWindow->This.setVerticalSyncEnabled(enabled == DTrue);
}

void sfRenderWindow_setKeyRepeatEnabled(sfRenderWindow* renderWindow, DBool enabled)
{
    renderWindow->This.setKeyRepeatEnabled(enabled == DTrue);
}

DBool sfRenderWindow_setActive(sfRenderWindow* renderWindow, DBool active)
{
    return renderWindow->This.setActive(active == DTrue)?DTrue: DFalse;
}

void sfRenderWindow_display(sfRenderWindow* renderWindow)
{
    renderWindow->This.display();
}

void sfRenderWindow_setFramerateLimit(sfRenderWindow* renderWindow, DUint limit)
{
    renderWindow->This.setFramerateLimit(limit);
}

void sfRenderWindow_setJoystickThreshold(sfRenderWindow* renderWindow, float threshold)
{
    renderWindow->This.setJoystickThreshold(threshold);
}

sfWindowHandle sfRenderWindow_getSystemHandle(const sfRenderWindow* renderWindow)
{
    return (sfWindowHandle)renderWindow->This.getSystemHandle();
}

void sfRenderWindow_clear(sfRenderWindow* renderWindow, DUbyte r, DUbyte g, DUbyte b, DUbyte a)
{
    sf::Color SFMLColor(r, g, b, a);

    renderWindow->This.clear(SFMLColor);
}

void sfRenderWindow_setView(sfRenderWindow* renderWindow, float centerX, float centerY, float sizeX,
		float sizeY, float rotation, float viewportLeft, float viewportTop, float viewportWidth,
		float viewportHeight)
{
	sf::View view;
	view.setCenter(centerX, centerY);
	view.setSize(sizeX, sizeY);
	view.setRotation(rotation);
	view.setViewport(sf::FloatRect(viewportLeft, viewportTop, viewportWidth, viewportHeight));
    renderWindow->This.setView(view);
}


void sfRenderWindow_getView(const sfRenderWindow* renderWindow, float* centerX, float* centerY, float* sizeX,
		float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
		float* viewportHeight)
{
    sf::View view = renderWindow->This.getView();
    *centerX = view.getCenter().x;
    *centerY = view.getCenter().y;
    *sizeX = view.getSize().x;
    *sizeY = view.getSize().y;
    *rotation = view.getRotation();
    *viewportLeft = view.getViewport().left;
    *viewportTop = view.getViewport().top;
    *viewportWidth = view.getViewport().width;
    *viewportHeight = view.getViewport().height;
}

void sfRenderWindow_getDefaultView(const sfRenderWindow* renderWindow, float* centerX, float* centerY, float* sizeX,
		float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
		float* viewportHeight)
{
    sf::View view = renderWindow->This.getDefaultView();
    *centerX = view.getCenter().x;
    *centerY = view.getCenter().y;
    *sizeX = view.getSize().x;
    *sizeY = view.getSize().y;
    *rotation = view.getRotation();
    *viewportLeft = view.getViewport().left;
    *viewportTop = view.getViewport().top;
    *viewportWidth = view.getViewport().width;
    *viewportHeight = view.getViewport().height;
}

void sfRenderWindow_drawPrimitives(sfRenderWindow* renderWindow,
                                                      const void* vertices, DUint vertexCount, DInt type, DInt colorSrcFactor, DInt colorDstFactor, DInt colorEquation,
													  DInt alphaSrcFactor, DInt alphaDstFactor, DInt alphaEquation,
													  const float* transform, const sfTexture* texture, const sfShader* shader)
{
    renderWindow->This.draw(static_cast<const sf::Vertex*>(vertices), vertexCount, static_cast<sf::PrimitiveType>(type), createRenderStates(colorSrcFactor, colorDstFactor,
    		colorEquation, alphaSrcFactor, alphaDstFactor, alphaEquation, transform, texture, shader));
}

void sfRenderWindow_pushGLStates(sfRenderWindow* renderWindow)
{
    renderWindow->This.pushGLStates();
}

void sfRenderWindow_popGLStates(sfRenderWindow* renderWindow)
{
    renderWindow->This.popGLStates();
}

void sfRenderWindow_resetGLStates(sfRenderWindow* renderWindow)
{
    renderWindow->This.resetGLStates();
}

sfImage* sfRenderWindow_capture(const sfRenderWindow* renderWindow)
{

    sfImage* image = new sfImage;
    image->This = renderWindow->This.capture();

    return image;
}

void sfMouse_getPositionRenderWindow(const sfRenderWindow* relativeTo, DInt* x, DInt* y)
{
    sf::Vector2i sfmlPos;

   //Will always be called with a Window
    sfmlPos = sf::Mouse::getPosition(relativeTo->This);

    *x = sfmlPos.x;
    *y = sfmlPos.y;
}

void sfMouse_setPositionRenderWindow(DInt x, DInt y, const sfRenderWindow* relativeTo)
{
    //Will always be called with a Window
    sf::Mouse::setPosition(sf::Vector2i(x, y), relativeTo->This);
}
