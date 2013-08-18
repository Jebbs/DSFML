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
module dsfml.window.joystick;

class Joystick
{
	enum
	{
		JoystickCount = 8,
		JoystickButtonCount = 32,
		JoystickAxisCount = 8
	}
	
	enum Axis
	{
		X,
		Y,
		Z,
		R,
		U,
		V,
		PovX,
		PovY
	}
	
	static bool isConnected(uint joystick)
	{
		return (sfJoystick_isConnected(joystick));// == sfTrue)?true:false;
	}
	
	static uint getButtonCount(uint joystick)
	{
		return sfJoystick_getButtonCount(joystick);
	}
	
	static void update()
	{
		sfJoystick_update();
	}
	
	static bool hasAxis(uint joystick, Axis axis)
	{
		return (sfJoystick_hasAxis(joystick, axis));
	}
	
	static float getAxisPosition(uint joystick, Axis axis)
	{
		return sfJoystick_getAxisPosition(joystick, axis);
	}
	static bool isButtonPressed(uint joystick, uint button)
	{
		return sfJoystick_isButtonPressed(joystick, button);
	}
	
}

private extern(C):
//Check if a joystick is connected
bool sfJoystick_isConnected(uint joystick);


//Return the number of buttons supported by a joystick
uint sfJoystick_getButtonCount(uint joystick);


//Check if a joystick supports a given axis
bool sfJoystick_hasAxis(uint joystick, int axis);


//Check if a joystick button is pressed
bool sfJoystick_isButtonPressed(uint joystick, uint button);


//Get the current position of a joystick axis
float sfJoystick_getAxisPosition(uint joystick, int axis);


//Update the states of all joysticks
void sfJoystick_update();
