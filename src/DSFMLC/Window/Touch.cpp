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

#include <DSFMLC/Window/Touch.h>
#include <DSFMLC/Window/WindowStruct.h>
#include <SFML/Window/Touch.hpp>
#include <SFML/System/Vector2.hpp>

DBool sfTouch_isDown (DUint finger)
{
	 return sf::Touch::isDown(finger) ? DTrue : DFalse;
}

void sfTouch_getPosition (DUint finger, const sfWindow* relativeTo, DInt* x, DInt* y)
{
	sf::Vector2i getPosition;
	if (relativeTo)
		getPosition = sf::Touch::getPosition(finger, relativeTo->This);
	else
		getPosition = sf::Touch::getPosition(finger);

	*x = getPosition.x;
	*y = getPosition.y;
}
