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

final abstract class Joystick
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

	static uint getButtonCount(uint joystick)
	{
		return sfJoystick_getButtonCount(joystick);
	}

	static float getAxisPosition(uint joystick, Axis axis)
	{
		return sfJoystick_getAxisPosition(joystick, axis);
	}
	
	static bool hasAxis(uint joystick, Axis axis)
	{
		return (sfJoystick_hasAxis(joystick, axis));
	}

	static bool isConnected(uint joystick)
	{
		return (sfJoystick_isConnected(joystick));
	}

	static bool isButtonPressed(uint joystick, uint button)
	{
		return sfJoystick_isButtonPressed(joystick, button);
	}

	static void update()
	{
		sfJoystick_update();
	}
	
}

unittest
{
	version(DSFML_Unittest_Window)
	{

		import std.stdio;
	
		Joystick.update();
	
		bool[] joysticks = [false,false,false,false,false,false,false,false]; 
	
		for(uint i; i < Joystick.JoystickCount; ++i)
		{
			if(Joystick.isConnected(i))
			{
				joysticks[i] = true;
				writeln("Joystick number ",i," is connected!");
			}
		}
	
		foreach(uint i,bool joystick;joysticks)
		{
			if(joystick)
			{
				//Check buttons
				uint buttonCounts = Joystick.getButtonCount(i);
			
				for(uint j = 0; j<buttonCounts; ++j)
				{
					if(Joystick.isButtonPressed(i,j))
					{
						writeln("Button ", j, " was pressed on joystick ", i);
					}
				}
			
				//check axis
				for(int j = 0; j<Joystick.JoystickAxisCount;++j)
				{
					Joystick.Axis axis = cast(Joystick.Axis)j;
					
					if(Joystick.hasAxis(i,axis))
					{
						writeln("Axis ", axis, " has a position of ", Joystick.getAxisPosition(i,axis), "for joystick", i);
					
					
					}
				}
			
			}
		}
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


