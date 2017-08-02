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

///A module containing the Event struct and other event structs.
module dsfml.window.event;

import dsfml.window.keyboard;
import dsfml.window.mouse;
import dsfml.window.sensor;

/**
*Defines a system event and its parameters.
*
*Event holds all the informations about a system event that just happened.
*
*Events are retrieved using the sWindow.pollEvent and Window.waitEvent functions.
*
*A Event instance contains the type of the event (mouse moved, key pressed, window closed, ...) 
*as well as the details about this particular event. Please note that the event parameters are defined
*in a union, which means that only the member matching the type of the event will be properly filled;
*all other members will have undefined values and must not be read if the type of the event doesn't match. 
*For example, if you received a KeyPressed event, then you must read the event.key member, all other members
*such as event.MouseMove or event.text will have undefined values.
*/
struct Event
{
	/**
	*Joystick buttons events parameters (JoystickButtonPressed, JoystickButtonReleased) 
	*/
	struct JoystickButtonEvent
	{
		///Index of the joystick (in range [0 .. Joystick::Count - 1])
		uint joystickId;
		///Index of the button that has been pressed (in range [0 .. Joystick::ButtonCount - 1])
		uint button;
	}

	/**
	*Joystick connection events parameters (JoystickConnected, JoystickDisconnected)
	*/
	struct JoystickConnectEvent
	{
		///Index of the joystick (in range [0 .. Joystick::Count - 1])
		uint joystickId;
	}

	/**
	 *Joystick connection events parameters (JoystickConnected, JoystickDisconnected)
	 */
	struct JoystickMoveEvent
	{
		///Index of the joystick (in range [0 .. Joystick::Count - 1])
		uint joystickId;
		///Axis on which the joystick moved
		int axis;
		///New position on the axis (in range [-100 .. 100])
		float position;
	}

	/**
	 *Keyboard event parameters (KeyPressed, KeyReleased)
	 */
	struct KeyEvent
	{
		///Code of the key that has been pressed.
		Keyboard.Key code;
		///Is the Alt key pressed?
		bool alt;
		///Is the Control key pressed?
		bool control;
		///Is the Shift key pressed?
		bool shift;
		///Is the System key pressed?
		bool system;
	}

	/**
	 *Mouse buttons events parameters (MouseButtonPressed, MouseButtonReleased)
	 */
	struct MouseButtonEvent
	{
		///Code of the button that has been pressed
		Mouse.Button button;
		///X position of the mouse pointer, relative to the left of the owner window
		int x;
		///Y position of the mouse pointer, relative to the top of the owner window
		int y;
	}

	/**
	 *Mouse move event parameters (MouseMoved)
	 */
	struct MouseMoveEvent
	{
		///X position of the mouse pointer, relative to the left of the owner window
		int x;
		///Y position of the mouse pointer, relative to the top of the owner window
		int y;
	}

	/**
	 *Mouse wheel events parameters (MouseWheelMoved)
	 */
	deprecated("This event is deprecated and potentially inaccurate. Use MouseWheelScrollEvent instead.")
	struct MouseWheelEvent
	{
		///Number of ticks the wheel has moved (positive is up, negative is down)
		int delta;
		///X position of the mouse pointer, relative to the left of the owner window
		int x;
		///Y position of the mouse pointer, relative to the top of the owner window
		int y;
	}

	/**
	 *Mouse wheel scroll events parameters (MouseWheelScrolled)
	 */
	struct MouseWheelScrollEvent
	{
		///Which wheel (for mice with multiple ones)
		Mouse.Wheel wheel;
		/// Wheel offset. High precision mice may use non-integral offsets.
		float delta;
		/// X position of the mouse pointer, relative to the left of the owner window
		int x;
		/// Y position of the mouse pointer, relative to the left of the owner window
		int y;
	}

	/**
	 *Size events parameters (Resized)
	 */
	struct SizeEvent
	{
		///New width, in pixels
		uint width;
		///New height, in pixels
		uint height;
	}

	/**
	 *Text event parameters (TextEntered)
	 */
	struct TextEvent
	{
		/// UTF-32 unicode value of the character
		dchar unicode;
	}

	/**
	 *Sensor event parameters
	 */
	struct SensorEvent
	{
		///Type of the sensor
		Sensor.Type type;
		float x;
		float y;
		float z;
	}

	/**
	 *Touch Event parameters
	 */
	struct TouchEvent
	{
		///Index of the finger in case of multi-touch events.
		uint finger;
		int x;
		int y;
	}

	enum EventType
	{
		///The window requested to be closed (no data)
		Closed,
		///The window was resized (data in event.size)
		Resized,
		///The window lost the focus (no data)
		LostFocus,
		///The window gained the focus (no data)
		GainedFocus,
		///A character was entered (data in event.text)
		TextEntered,
		///A key was pressed (data in event.key)
		KeyPressed,
		///A key was released (data in event.key)
		KeyReleased,
		///The mouse wheel was scrolled (data in event.mouseWheel)
		MouseWheelMoved,
		///The mouse wheel was scrolled (data in event.mouseWheelScroll)
		MouseWheelScrolled,
		///A mouse button was pressed (data in event.mouseButton)
		MouseButtonPressed,
		///A mouse button was released (data in event.mouseButton)
		MouseButtonReleased,
		///The mouse cursor moved (data in event.mouseMove)
		MouseMoved,
		///The mouse cursor entered the area of the window (no data)
		MouseEntered,
		///The mouse cursor left the area of the window (no data)
		MouseLeft,
		///A joystick button was pressed (data in event.joystickButton)
		JoystickButtonPressed,
		///A joystick button was released (data in event.joystickButton)
		JoystickButtonReleased,
		///The joystick moved along an axis (data in event.joystickMove)
		JoystickMoved,
		///A joystick was connected (data in event.joystickConnect)
		JoystickConnected,
		///A joystick was disconnected (data in event.joystickConnect)
		JoystickDisconnected,
		///A touch event began (data in event.touch)
		TouchBegan,
		///A touch moved (data in event.touch)
		TouchMoved,
		///A touch ended (data in event.touch)
		TouchEnded,
		///A sensor value changed (data in event.sensor)
		SensorChanged,

		///Keep last -- the total number of event types
		Count
	}

	///Type of the event
	EventType type;

	union
	{
		///Size event parameters (Event::Resized)
		SizeEvent size;
		///Key event parameters (Event::KeyPressed, Event::KeyReleased)
		KeyEvent key;
		///Text event parameters (Event::TextEntered)
		TextEvent text;
		///Mouse move event parameters (Event::MouseMoved)
		MouseMoveEvent mouseMove;
		///Mouse button event parameters (Event::MouseButtonPressed, Event::MouseButtonReleased)
		MouseButtonEvent mouseButton;
		///Mouse wheel event parameters (Event::MouseWheelMoved)
		MouseWheelEvent mouseWheel;
		///Mouse wheel scroll event parameters
		MouseWheelScrollEvent mouseWheelScroll;
		///Joystick move event parameters (Event::JoystickMoved)
		JoystickMoveEvent joystickMove;
		///Joystick button event parameters (Event::JoystickButtonPressed, Event::JoystickButtonReleased)
		JoystickButtonEvent joystickButton;
		///Joystick (dis)connect event parameters (Event::JoystickConnected, Event::JoystickDisconnected)
		JoystickConnectEvent joystickConnect;
		///Touch event parameters
		TouchEvent touch;
		///Sensor event Parameters
		SensorEvent sensor;
	}
}

unittest
{
	version(DSFML_Unittest_Window)
	{
		import std.stdio;

		import dsfml.graphics.font;
		import dsfml.graphics.text;
		import dsfml.graphics.renderwindow;
		import dsfml.window;
		import std.conv;

		writeln("Unit tests for events.");

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

		assert(font.loadFromFile("res/Warenhaus-Standard.ttf"));

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
					mouseEventText.setString("Mouse Event: Button Pressed");
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
}



