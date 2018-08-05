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

#ifndef DSFML_CONVERTEVENT_H
#define DSFML_CONVERTEVENT_H

#include <SFML/Window/Event.hpp>
#include <DSFMLC/Window/Event.h>

//Define a function to convert a sf::Event ot a sfEvent
inline void convertEvent(const sf::Event& SFMLEvent, DEvent* event)
{
    // Convert its type
    event->type = static_cast<DEvent::EventType>(SFMLEvent.type);

    // Fill its fields
    switch (event->type)
    {
        case DEvent::Resized :
            event->size.width  = SFMLEvent.size.width;
            event->size.height = SFMLEvent.size.height;
            break;

        case DEvent::TextEntered :
            event->text.unicode = SFMLEvent.text.unicode;
            break;

        case DEvent::KeyReleased :
        case DEvent::KeyPressed :
            event->key.code    = static_cast<DInt>(SFMLEvent.key.code);
            event->key.alt     = SFMLEvent.key.alt     ? DTrue : DFalse;
            event->key.control = SFMLEvent.key.control ? DTrue : DFalse;
            event->key.shift   = SFMLEvent.key.shift   ? DTrue : DFalse;
            event->key.system  = SFMLEvent.key.system  ? DTrue : DFalse;
            break;

        case DEvent::MouseWheelMoved :
            event->mouseWheel.delta = SFMLEvent.mouseWheel.delta;
            event->mouseWheel.x     = SFMLEvent.mouseWheel.x;
            event->mouseWheel.y     = SFMLEvent.mouseWheel.y;
            break;

        case DEvent::MouseButtonPressed :
        case DEvent::MouseButtonReleased :
            event->mouseButton.button = static_cast<DInt>(SFMLEvent.mouseButton.button);
            event->mouseButton.x      = SFMLEvent.mouseButton.x;
            event->mouseButton.y      = SFMLEvent.mouseButton.y;
            break;

        case DEvent::MouseMoved :
            event->mouseMove.x = SFMLEvent.mouseMove.x;
            event->mouseMove.y = SFMLEvent.mouseMove.y;
            break;

        case DEvent::JoystickButtonPressed :
        case DEvent::JoystickButtonReleased :
            event->joystickButton.joystickId = SFMLEvent.joystickButton.joystickId;
            event->joystickButton.button     = SFMLEvent.joystickButton.button;
            break;

        case DEvent::JoystickMoved :
            event->joystickMove.joystickId = SFMLEvent.joystickMove.joystickId;
            event->joystickMove.axis       = static_cast<DInt>(SFMLEvent.joystickMove.axis);
            event->joystickMove.position   = SFMLEvent.joystickMove.position;
            break;

        case DEvent::JoystickConnected :
        case DEvent::JoystickDisconnected :
            event->joystickConnect.joystickId = SFMLEvent.joystickConnect.joystickId;
            break;

        default :
            break;
    }
}

#endif // DSFML_CONVERTEVENT_H
