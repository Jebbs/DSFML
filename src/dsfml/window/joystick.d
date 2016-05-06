/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

///A module containing the Joystick class.
module dsfml.window.joystick;

/**
 *Give access to the real-time state of the joysticks.
 *
 *Joystick provides an interface to the state of the joysticks.
 *
 *It only contains static functions, so it's not meant to be instanciated. Instead, each joystick is identified
  *by an index that is passed to the functions of this class.
 *
 *This class allows users to query the state of joysticks at any time and directly, without having to deal with
 *a window and its events. Compared to the JoystickMoved, JoystickButtonPressed and JoystickButtonReleased events,
 *Joystick can retrieve the state of axes and buttons of joysticks at any time (you don't need to store and update
 *a boolean on your side in order to know if a button is pressed or released), and you always get the real state of
 *joysticks, even if they are moved, pressed or released when your window is out of focus and no event is triggered.
*/
final abstract class Joystick
{
	///Structure holding a joystick's identification;
	struct Identification {
		private static dstring[immutable(uint)[2]] nameCache;
		///Index of the joystick
		uint index;
		///Name of the joystick
		@property dstring name() {
			//In theory, each vid:pid combination should only have one name associated with it.
			//slightly arcane syntax to make older GDC happy.
			uint[2] tempkey;
			tempkey[0] = vendorId;
			tempkey[1] = productId;
			immutable(uint)[2] key = tempkey;

			dstring* cachedName = (key in nameCache);
			if (cachedName !is null) {
				return *cachedName;
			} else {
				import std.exception;

				dchar[] retrievedName;

				retrievedName.length = sfJoystick_getIdentificationNameLength(index);

				sfJoystick_getIdentificationName(index, retrievedName.ptr);

				nameCache[key] = assumeUnique(retrievedName);

				return assumeUnique(retrievedName);
			}
		}

		///Manufacturer identifier
		uint vendorId;
		///Product identifier
		uint productId;
	}

	//Constants related to joysticks capabilities.
	enum
	{
		///Maximum number of supported joysticks.
		JoystickCount = 8,
		///Maximum number of supported buttons.
		JoystickButtonCount = 32,
		///Maximum number of supported axes.
		JoystickAxisCount = 8
	}

	///Axes supported by SFML joysticks.
	enum Axis
	{
		///The X axis.
		X,
		///The Y axis.
		Y,
		///The Z axis.
		Z,
		///The R axis.
		R,
		///The U axis.
		U,
		///The V axis.
		V,
		///The X axis of the point-of-view hat.
		PovX,
		///The Y axis of the point-of-view hat.
		PovY
	}

	///Return the number of buttons supported by a joystick.
	///
	///If the joystick is not connected, this function returns 0.
	///
	//////Params:
	///		joystick = Index of the joystick.
	///
	///Returns: Number of buttons supported by the joystick.
	static uint getButtonCount(uint joystick)
	{
		return sfJoystick_getButtonCount(joystick);
	}

	///Get the current position of a joystick axis.
	///
	///If the joystick is not connected, this function returns 0.
	///
	///Params:
	///		joystick = 	Index of the joystick.
	///		axis = Axis to check.
	///
	///Returns: Current position of the axis, in range [-100 .. 100].
	static float getAxisPosition(uint joystick, Axis axis)
	{
		return sfJoystick_getAxisPosition(joystick, axis);
	}

	///Get the joystick information
	///
	///Params:
	///		joystick = Index of the joystick.
	///
	///Returns: Structure containing the joystick information.
	static Identification getIdentification(uint joystick) {
		Identification identification;

		sfJoystick_getIdentification(joystick, &identification.vendorId, &identification.productId);

		return identification;
	}

	///Check if a joystick supports a given axis.
	///
	///If the joystick is not connected, this function returns false.
	///
	///Params:
	///		joystick = 	Index of the joystick.
	///		axis = Axis to check.
	///
	///Returns: True if the joystick supports the axis, false otherwise.
	static bool hasAxis(uint joystick, Axis axis)
	{
		return (sfJoystick_hasAxis(joystick, axis));
	}

	///Check if a joystick button is pressed.
	///
	///If the joystick is not connected, this function returns false.
	///
	///Params:
	///		joystick = 	Index of the joystick.
	///		button = Button to check.
	///
	///Returns: True if the button is pressed, false otherwise.
	static bool isButtonPressed(uint joystick, uint button)
	{
		return sfJoystick_isButtonPressed(joystick, button);
	}

	///Check if a joystick is connected.
	///
	///Params:
	///		joystick = 	Index of the joystick.
	///
	///Returns: True if the joystick is connected, false otherwise.
	static bool isConnected(uint joystick)
	{
		return (sfJoystick_isConnected(joystick));
	}

	///Update the states of all joysticks.
	///
	///This function is used internally by SFML, so you normally don't have to call it explicitely.
	///However, you may need to call it if you have no window yet (or no window at all): in this case the joysticks states are not updated automatically.
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
				auto id = Joystick.getIdentification(i);
				joysticks[i] = true;
				writeln("Joystick number ",i," is connected!");
				writefln("Type: %s, ID: %x:%x", id.name, id.vendorId, id.productId);
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

//Return the length of the joystick identification structure's name
size_t sfJoystick_getIdentificationNameLength(uint joystick);

//Write the name of the joystick into a D-allocated string buffer.
void sfJoystick_getIdentificationName (uint joystick, dchar* nameBuffer);

//Return the identification structure for a joystick
void sfJoystick_getIdentification(uint joystick, uint* vendorID, uint* productId);

//Check if a joystick supports a given axis
bool sfJoystick_hasAxis(uint joystick, int axis);

//Check if a joystick button is pressed
bool sfJoystick_isButtonPressed(uint joystick, uint button);

//Get the current position of a joystick axis
float sfJoystick_getAxisPosition(uint joystick, int axis);

//Update the states of all joysticks
void sfJoystick_update();


