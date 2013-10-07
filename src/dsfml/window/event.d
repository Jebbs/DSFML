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

module dsfml.window.event;

struct Event
{

	struct SizeEvent
	{
		uint width; /// New width, in pixels
		uint height; /// New height, in pixels
	}

	struct KeyEvent
	{
		int code; /// Code of the key that has been pressed
		bool alt; /// Is the Alt key pressed?
		bool control; /// Is the Control key pressed?
		bool shift; /// Is the Shift key pressed?
		bool system; /// Is the System key pressed?
	}

	struct TextEvent
	{
		uint unicode; /// UTF-32 unicode value of the character
	}
	
	struct MouseMoveEvent
	{
		int x; /// X position of the mouse pointer, relative to the left of the owner window
		int y; /// Y position of the mouse pointer, relative to the top of the owner window
	}
	
	struct MouseButtonEvent
	{
		int button; /// Code of the button that has been pressed
		int x; /// X position of the mouse pointer, relative to the left of the owner window
		int y; /// Y position of the mouse pointer, relative to the top of the owner window
	}
	
	struct MouseWheelEvent
	{
		int delta; /// Number of ticks the wheel has moved (positive is up, negative is down)
		int x; /// X position of the mouse pointer, relative to the left of the owner window
		int y; /// Y position of the mouse pointer, relative to the top of the owner window
	}
	
	struct JoystickConnectEvent
	{
		uint joystickId; /// Index of the joystick (in range [0 .. Joystick::Count - 1])
	}
	
	struct JoystickMoveEvent
	{
		uint joystickId; /// Index of the joystick (in range [0 .. Joystick::Count - 1])
		int axis; /// Axis on which the joystick moved
		float position; /// New position on the axis (in range [-100 .. 100])
	}
	
	struct JoystickButtonEvent
	{
		uint joystickId; /// Index of the joystick (in range [0 .. Joystick::Count - 1])
		uint button; /// Index of the button that has been pressed (in range [0 .. Joystick::ButtonCount - 1])
	}

	enum EventType
	{
		Closed, /// The window requested to be closed (no data)
		Resized, /// The window was resized (data in event.size)
		LostFocus, /// The window lost the focus (no data)
		GainedFocus, /// The window gained the focus (no data)
		TextEntered, /// A character was entered (data in event.text)
		KeyPressed, /// A key was pressed (data in event.key)
		KeyReleased, /// A key was released (data in event.key)
		MouseWheelMoved, /// The mouse wheel was scrolled (data in event.mouseWheel)
		MouseButtonPressed, /// A mouse button was pressed (data in event.mouseButton)
		MouseButtonReleased, /// A mouse button was released (data in event.mouseButton)
		MouseMoved, /// The mouse cursor moved (data in event.mouseMove)
		MouseEntered, /// The mouse cursor entered the area of the window (no data)
		MouseLeft, /// The mouse cursor left the area of the window (no data)
		JoystickButtonPressed, /// A joystick button was pressed (data in event.joystickButton)
		JoystickButtonReleased, /// A joystick button was released (data in event.joystickButton)
		JoystickMoved, /// The joystick moved along an axis (data in event.joystickMove)
		JoystickConnected, /// A joystick was connected (data in event.joystickConnect)
		JoystickDisconnected, /// A joystick was disconnected (data in event.joystickConnect)
		
		Count /// Keep last -- the total number of event types
	}
	
	EventType type; /// Type of the event
	
	union
	{
		SizeEvent size; ///< Size event parameters (Event::Resized)
		KeyEvent key; ///< Key event parameters (Event::KeyPressed, Event::KeyReleased)
		TextEvent text; ///< Text event parameters (Event::TextEntered)
		MouseMoveEvent mouseMove; ///< Mouse move event parameters (Event::MouseMoved)
		MouseButtonEvent mouseButton; ///< Mouse button event parameters (Event::MouseButtonPressed, Event::MouseButtonReleased)
		MouseWheelEvent mouseWheel; ///< Mouse wheel event parameters (Event::MouseWheelMoved)
		JoystickMoveEvent joystickMove; ///< Joystick move event parameters (Event::JoystickMoved)
		JoystickButtonEvent joystickButton; ///< Joystick button event parameters (Event::JoystickButtonPressed, Event::JoystickButtonReleased)
		JoystickConnectEvent joystickConnect; ///< Joystick (dis)connect event parameters (Event::JoystickConnected, Event::JoystickDisconnected)
		
	}
}





