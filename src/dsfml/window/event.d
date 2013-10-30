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
		//TODO: Replace code with a Keyboad KeyCode?
		int code; /// Code of the key that has been pressed
		bool alt; /// Is the Alt key pressed?
		bool control; /// Is the Control key pressed?
		bool shift; /// Is the Shift key pressed?
		bool system; /// Is the System key pressed?
	}

	struct TextEvent
	{
		dchar unicode; /// UTF-32 unicode value of the character
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

unittest
{
	import std.stdio;
	//import dsfml.graphics.all; Cannot use graphics.all due to a never ending import cycle with window module. Be on the look out for this?
	import dsfml.graphics.font;
	import dsfml.graphics.text;
	import dsfml.graphics.renderwindow;
	import dsfml.window.all;
	import std.conv;

	string[int] keys;
	//in its own scope for code folding
	{
		keys[-1] = "Unknown";
		keys[0] = 	"A";
		keys[1] =	"B";
		keys[2] =	"C";
		keys[3] =	"D";
		keys[4] =	"E";
		keys[5] =	"F";
		keys[6] =	"G";
		keys[7] =	"H";
		keys[8] =	"I";
		keys[9] =	"J";
		keys[10] =	"K";
		keys[11] =	"L";
		keys[12] =	"M";
		keys[13] =	"N";
		keys[14] =	"O";
		keys[15] =	"P";
		keys[16] =	"Q";
		keys[16] =	"R";
		keys[18] =	"S";
		keys[19] =	"T";
		keys[20] =	"U";
		keys[21] =	"V";
		keys[22] =	"W";
		keys[23] =	"X";
		keys[24] =	"Y";
		keys[25] =	"Z";
		keys[26] =	"Num0";
		keys[26] =	"Num1";
		keys[28] =	"Num2";
		keys[29] =	"Num3";
		keys[30] =	"Num4";
		keys[31] =	"Num5";
		keys[32] =	"Num6";
		keys[33] =	"Num7";
		keys[34] =	"Num8";
		keys[35] =	"Num9";
		keys[36] =	"Escape";
		keys[37] =	"LControl";
		keys[38] =	"LShift";
		keys[39] =	"LAlt";
		keys[40] =	"LSystem";
		keys[41] =	"RControl";
		keys[42] =	"RShift";
		keys[43] =	"RAlt";
		keys[44] =	"RSystem";
		keys[45] =	"Menu";
		keys[46] =	"LBracket";
		keys[47] =	"RBracket";
		keys[48] =	"SemiColon";
		keys[49] =	"Comma";
		keys[50] =	"Period";
		keys[51] =	"Quote";
		keys[52] =	"Slash";
		keys[53] =	"BackSlash";
		keys[54] =	"Tilde";
		keys[55] =	"Equal";
		keys[56] =	"Dash";
		keys[57] =	"Space";
		keys[58] =	"Return";
		keys[59] =	"BackSpace";
		keys[60] =	"Tab";
		keys[61] =	"PageUp";
		keys[62] =	"PageDown";
		keys[63] =	"End";
		keys[64] =	"Home";
		keys[65] =	"Insert";
		keys[66] =	"Delete";
		keys[67] =	"Add";
		keys[68] =	"Subtract";
		keys[69] =	"Multiply";
		keys[70] =	"Divide";
		keys[71] =	"Left";
		keys[72] =	"Right";
		keys[73] =	"Up";
		keys[74] =	"Down";
		keys[75] =	"Numpad0";
		keys[76] =	"Numpad1";
		keys[77] =	"Numpad2";
		keys[78] =	"Numpad3";
		keys[79] =	"Numpad4";
		keys[80] =	"Numpad5";
		keys[81] =	"Numpad6";
		keys[82] =	"Numpad7";
		keys[83] =	"Numpad8";
		keys[84] =	"Numpad9";
		keys[85] =	"F1";
		keys[86] =	"F2";
		keys[87] =	"F3";
		keys[88] =	"F4";
		keys[89] =	"F5";
		keys[90] =	"F6";
		keys[91] =	"F7";
		keys[92] =	"F8";
		keys[93] =	"F9";
		keys[94] =	"F10";
		keys[95] =	"F11";
		keys[96] =	"F12";
		keys[97] =	"F13";
		keys[98] =	"F14";
		keys[99] =	"F15";
		keys[100] =	"Pause";
	}






	auto font = new Font();

	assert(font.loadFromFile("Cyberbit.ttf"));//will fix when unittest building get's added to build script(fix as in not use Cyberbit)

	auto text1 = new Text("Unit test for events.",font);
	auto text2 = new Text("Note: This unit test does require user input.",font);
	text2.position = Vector2f(0,30);
	auto text3 = new Text("Press esc or close window to exit test.",font);
	text3.position = Vector2f(0,60);
	auto text4 = new Text("Press Left Control to enable/diable text mode/key press mode.",font);
	text4.position = Vector2f(0,90);
	auto text5 = new Text("Currently in key press mode.",font);
	text5.position = Vector2f(0,120);
	auto outputText = new Text("Key pressed:",font);
	outputText.position = Vector2f(0,150);
	auto mouseEventText = new Text("Mouse Event: ", font);
	mouseEventText.position = Vector2f(0,180);
	auto joystickEventText = new Text("Joystick Event: ", font);
	joystickEventText.position = Vector2f(0,210);



	bool keyPressMode = true;

	dstring savedText = "";

	auto window = new RenderWindow(VideoMode(800,600),"Event Unit Test Window");

	while(window.isOpen())
	{

		Event event;

		while(window.pollEvent(event))
		{
			if(event.type == Event.EventType.Closed)
			{
				window.close();
			}

			//looking for key presses!
			if(keyPressMode)
			{
				if(event.type == Event.EventType.KeyPressed)
				{
					outputText.setString = "Key pressed: " ~ dtext(keys[event.key.code]);
				}
			}
			//writing text
			else
			{
				if(event.type == Event.EventType.TextEntered)
				{
					savedText ~= event.text.unicode;
					outputText.setString = "Current Text: " ~ savedText;
				}
			}

			//mouse events: these could be improved, but I will write some just to have them present
			if(event.type == Event.EventType.MouseButtonPressed)
			{
				mouseEventText.setString( "Mouse Event: Button Pressed");
			}
			if(event.type == Event.EventType.MouseButtonReleased)
			{
				mouseEventText.setString( "Mouse Event: Button Released");
			}
			if(event.type == Event.EventType.MouseEntered)
			{
				mouseEventText.setString( "Mouse Event: Mouse Entered Window");
			}
			if(event.type == Event.EventType.MouseLeft)
			{
				mouseEventText.setString( "Mouse Event: Mouse Left Window");
			}
			if(event.type == Event.EventType.MouseMoved)
			{
				mouseEventText.setString( "Mouse Event: Mouse Moved");
			}
			if(event.type == Event.EventType.MouseWheelMoved)
			{
				mouseEventText.setString( "Mouse Event: Mouse Wheel Moved");
			}

			//joystick events: these could be improved, but I will write some just to have them present
			if(event.type == Event.EventType.JoystickConnected)
			{
				joystickEventText.setString("Joystick Event: Joystick Connected");
			}
			if(event.type == Event.EventType.JoystickDisconnected)
			{
				joystickEventText.setString("Joystick Event: Joystick Disconnected");
			}
			if(event.type == Event.EventType.JoystickButtonPressed)
			{
				joystickEventText.setString("Joystick Event: Button Pressed");
			}
			if(event.type == Event.EventType.JoystickButtonReleased)
			{
				joystickEventText.setString("Joystick Event: Button Released");
			}
			if(event.type == Event.EventType.JoystickMoved)
			{
				joystickEventText.setString("Joystick Event: Joystick Moved");
			}

			//Events that will always happen
			if(event.type == Event.EventType.KeyPressed)
			{
				if(event.key.code == Keyboard.Key.Escape)
				{
					window.close();
				}
				if(event.key.code == Keyboard.Key.LControl)
				{
					if(keyPressMode)
					{
						keyPressMode = false;
						text5.setString("Currently in text mode.");
						outputText.setString = "Current Text:";
						savedText = "";
					}
					else
					{
						keyPressMode = true;
						text5.setString("Currently in key press mode.");
						outputText.setString = "Key pressed:";
					}

				}
			}

		}
		window.clear();

		window.draw(text1);
		window.draw(text2);
		window.draw(text3);
		window.draw(text4);
		window.draw(text5);
		window.draw(outputText);
		window.draw(mouseEventText);
		window.draw(joystickEventText);

		window.display();


	}



}



