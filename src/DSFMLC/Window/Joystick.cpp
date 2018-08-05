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

#include <DSFMLC/Window/Joystick.h>
#include <SFML/Window/Joystick.hpp>

DBool sfJoystick_isConnected(DUint joystick)
{
    return sf::Joystick::isConnected(joystick) ? DTrue : DFalse;
}

DUint sfJoystick_getButtonCount(DUint joystick)
{
    return sf::Joystick::getButtonCount(joystick);
}

DBool sfJoystick_hasAxis(DUint joystick, DInt axis)
{
    return sf::Joystick::hasAxis(joystick, static_cast<sf::Joystick::Axis>(axis)) ? DTrue : DFalse;
}

DBool sfJoystick_isButtonPressed(DUint joystick, DUint button)
{
    return sf::Joystick::isButtonPressed(joystick, button) ? DTrue : DFalse;
}

float sfJoystick_getAxisPosition(DUint joystick, DInt axis)
{
    return sf::Joystick::getAxisPosition(joystick, static_cast<sf::Joystick::Axis>(axis));
}

size_t sfJoystick_getIdentificationNameLength (DUint joystick)
{
	return sf::Joystick::getIdentification(joystick).name.getSize();
}

void sfJoystick_getIdentificationName (DUint joystick, DUint * nameBuffer)
{
	//On Linux, just returning the pointer to the name string works fine, but on windows it corrupts during passing.
	sf::Joystick::Identification sfmlIdentification = sf::Joystick::getIdentification(joystick);

	for (unsigned int i = 0; i < sfmlIdentification.name.getSize(); i++)
	{
		nameBuffer[i] = sfmlIdentification.name[i];
	}

}

void sfJoystick_getIdentification(DUint joystick, DUint * vendorId, DUint* productId)
{
	sf::Joystick::Identification sfmlIdentification = sf::Joystick::getIdentification(joystick);

	*vendorId = sfmlIdentification.vendorId;
	*productId = sfmlIdentification.productId;
}

void sfJoystick_update(void)
{
    sf::Joystick::update();
}
