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
module dsfml.window.mouse;

import dsfml.system.vector2;
import dsfml.window.window;

final abstract class Mouse
{
	enum Button
	{
		Left, /// The left mouse button
		Right, /// The right mouse button
		Middle, /// The middle (wheel) mouse button
		XButton1, /// The first extra mouse button
		XButton2, /// The second extra mouse button
		
		Count /// Keep last -- the total number of mouse buttons
		
	}

	static void setPosition(Vector2i position)
	{
		sfMouse_setPosition(position.x, position.y,null);
	}
	
	static void setPosition(Vector2i position, const(Window) relativeTo)
	{
		relativeTo.mouse_SetPosition(position);
	}

	static Vector2i getPosition()
	{
		Vector2i temp;
		sfMouse_getPosition(null,&temp.x, &temp.y);

		return temp;
	}	

	static Vector2i getPosition(const(Window) relativeTo)
	{
		return relativeTo.mouse_getPosition();
	}

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

