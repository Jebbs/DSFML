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

///A module containing the Keyboard class.
module dsfml.window.keyboard;

/**
 *Give access to the real-time state of the keyboard.
*
*Keyboard provides an interface to the state of the keyboard.
*
*It only contains static functions (a single keyboard is assumed), so it's not meant to be instanciated.
*
*This class allows users to query the keyboard state at any time and directly, without having to deal with
*a window and its events. Compared to the KeyPressed and KeyReleased events, Keyboard can retrieve the state
*of a key at any time (you don't need to store and update a boolean on your side in order to know if a key is
*pressed or released), and you always get the real state of the keyboard, even if keys are pressed or released 
*when your window is out of focus and no event is triggered.
*/
final abstract class Keyboard
{
	enum Key
	{
		///Unhandled key
		Unknown = -1,
		///The A key
		A = 0,
		///The B key
		B,
		///The C key
		C,
		///The D key
		D,
		///The E key
		E,
		///The F key
		F,
		///The G key
		G,
		///The H key
		H,
		///The I key
		I,
		///The J key
		J,
		///The K key
		K,
		///The L key
		L,
		///The M key
		M,
		///The N key
		N,
		///The O key
		O,
		///The P key
		P,
		///The Q key
		Q,
		///The R key
		R,
		///The S key
		S,
		///The T key
		T,
		///The U key
		U,
		///The V key
		V,
		///The W key
		W,
		///The X key
		X,
		///The Y key
		Y,
		///The Z key
		Z,
		///The 0 key
		Num0,
		///The 1 key
		Num1,
		///The 2 key
		Num2,
		///The 3 key
		Num3,
		///The 4 key
		Num4,
		///The 5 key
		Num5,
		///The 6 key
		Num6,
		///The 7 key
		Num7,
		///The 8 key
		Num8,
		///The 9 key
		Num9,
		///The Escape key
		Escape,
		///The left Control key
		LControl,
		///The left Shift key
		LShift,
		///The left Alt key
		LAlt,
		///The left OS specific key: window (Windows and Linux), apple (MacOS X), ...
		LSystem,
		///The right Control key
		RControl,
		///The right Shift key
		RShift,
		///The right Alt key
		RAlt,
		///The right OS specific key: window (Windows and Linux), apple (MacOS X), ...
		RSystem,
		///The Menu key
		Menu,
		///The [ key
		LBracket,
		///The ] key
		RBracket,
		///The ; key
		SemiColon,
		///The , key
		Comma,
		///The . key
		Period,
		///The ' key
		Quote,
		///The / key
		Slash,
		///The \ key
		BackSlash,
		///The ~ key
		Tilde,
		///The = key
		Equal,
		///The - key
		Dash,
		///The Space key
		Space,
		///The Return key
		Return,
		///The Backspace key
		BackSpace,
		///The Tabulation key
		Tab,
		///The Page up key
		PageUp,
		///The Page down key
		PageDown,
		///The End key
		End,
		///The Home key
		Home,
		///The Insert key
		Insert,
		///The Delete key
		Delete,
		///The + key
		Add,
		///The - key
		Subtract,
		///The * key
		Multiply,
		///The / key
		Divide,
		///Left arrow
		Left,
		///Right arrow
		Right,
		///Up arrow
		Up,
		///Down arrow
		Down,
		///The numpad 0 key
		Numpad0,
		///The numpad 1 key
		Numpad1,
		///The numpad 2 key
		Numpad2,
		///The numpad 3 key
		Numpad3,
		///The numpad 4 key
		Numpad4,
		///The numpad 5 key
		Numpad5,
		///The numpad 6 key
		Numpad6,
		///The numpad 7 key
		Numpad7,
		///The numpad 8 key
		Numpad8,
		///The numpad 9 key
		Numpad9,
		///The F1 key
		F1,
		///The F2 key
		F2,
		///The F3 key
		F3,
		///The F4 key
		F4,
		///The F5 key
		F5,
		///The F6 key
		F6,
		///The F7 key
		F7,
		///The F8 key
		F8,
		///The F9 key
		F9,
		///The F10 key
		F10,
		///The F11 key
		F11,
		///The F12 key
		F12,
		///The F13 key
		F13,
		///The F14 key
		F14,
		///The F15 key
		F15,
		///The Pause key
		Pause,
		
		///Keep last -- the total number of keyboard keys
		KeyCount
	}
	
	///Check if a key is pressed.
	///
	///Params:
	///		key = Key to check.
	///
	///Returns: True if the key is pressed, false otherwise.
	static bool isKeyPressed(Key key)
	{
		return (sfKeyboard_isKeyPressed(key));
	}
	
}

//known bugs:
//cannot press two keys at once for this unit test
unittest
{
	version(DSFML_Unittest_Window)
	{
		import std.stdio;
		
		writeln("Unit test for Keyboard realtime input");
		
		bool running = true;
		
		writeln("Press any key for real time input. Press esc to exit.");
		
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
			keys[17] =	"R";
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
		
		//must check for each possible key 
		while(running)
		{
			for(int i =-1;i<101;++i)
			{
				if(Keyboard.isKeyPressed(cast(Keyboard.Key)i))
				{
					if(i in keys)
					{
						writeln("Key "~ keys[i] ~ " was pressed.");
					}
					else
					{
						writeln(i);
					}
					if(i == 36)
					{
						running = false;
					}
				}
			}
		}
	}
}

private extern(C)
{
	bool sfKeyboard_isKeyPressed(int key);
}


