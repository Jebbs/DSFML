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

///A module containing the Mouse class.
module dsfml.window.mouse;

import dsfml.system.vector2;
import dsfml.window.window;

/**
*Give access to the real-time state of the mouse.
*
*Mouse provides an interface to the state of the mouse.
*
*It only contains static functions (a single mouse is assumed), so it's not meant to be instanciated.
*
*This class allows users to query the mouse state at any time and directly, without having to deal with 
*a window and its events. Compared to the MouseMoved, MouseButtonPressed and MouseButtonReleased events, 
*Mouse can retrieve the state of the cursor and the buttons at any time (you don't need to store and update 
*a boolean on your side in order to know if a button is pressed or released), and you always get the real 
*state of the mouse, even if it is moved, pressed or released when your window is out of focus and no event is triggered.
*
*The setPosition and getPosition functions can be used to change or retrieve the current position of the 
*mouse pointer. There are two versions: one that operates in global coordinates (relative to the desktop) 
*and one that operates in window coordinates (relative to a specific window).
*/
final abstract class Mouse
{
	enum Button
	{
		///The left mouse button
		Left,
		///The right mouse button
		Right,
		///The middle (wheel) mouse button
		Middle,
		///The first extra mouse button
		XButton1,
		///The second extra mouse button
		XButton2,
		
		///Keep last -- the total number of mouse buttons
		Count
		
	}

	///Set the current position of the mouse in desktop coordinates.
	///
	///This function sets the global position of the mouse cursor on the desktop.
	///
	///Params:
	///		position = New position of the mouse.
	static void setPosition(Vector2i position)
	{
		sfMouse_setPosition(position.x, position.y,null);
	}
	
	///Set the current position of the mouse in window coordinates.
	///
	///This function sets the current position of the mouse cursor, relative to the given window.
	///
	///Params:
    ///		position = New position of the mouse.
    ///		relativeTo = Reference window.
	static void setPosition(Vector2i position, const(Window) relativeTo)
	{
		relativeTo.mouse_SetPosition(position);
	}

	///Get the current position of the mouse in desktop coordinates.
	///
	///This function returns the global position of the mouse cursor on the desktop.
	///
	///Returns: Current position of the mouse.
	static Vector2i getPosition()
	{
		Vector2i temp;
		sfMouse_getPosition(null,&temp.x, &temp.y);

		return temp;
	}	

	///Get the current position of the mouse in window coordinates.
	///
	///This function returns the current position of the mouse cursor, relative to the given window.
	///
	///Params:
	///    relativeTo = Reference window.
    ///
	///Returns: Current position of the mouse.
	static Vector2i getPosition(const(Window) relativeTo)
	{
		return relativeTo.mouse_getPosition();
	}

	///Check if a mouse button is pressed.
	///
	///Params:
    ///		button = Button to check.
	///
	///Returns: True if the button is pressed, false otherwise.
	static bool isButtonPressed(Button button)
	{
		return (sfMouse_isButtonPressed(button) );
	}

}

unittest
{
	version(DSFML_Unittest_Window)
	{
		import std.stdio;
	
		writeln("Unit test for Mouse class");
	
		writeln("Current mouse position: ", Mouse.getPosition().toString());
	
		Mouse.setPosition(Vector2i(100,400));
	
		writeln("New mouse position: ", Mouse.getPosition().toString());
	
	}
	
}

private extern(C)
{

	//Check if a mouse button is pressed
	bool sfMouse_isButtonPressed(int button);

	//Get the current position of the mouse
	void sfMouse_getPosition(const(sfWindow)* relativeTo, int* x, int* y);

	//Set the current position of the mouse
	void sfMouse_setPosition(int x, int y, const(sfWindow)* relativeTo);
}

