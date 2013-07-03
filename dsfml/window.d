/*
Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty. 
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
*/

module dsfml.window;

import std.conv;
import std.string;
import core.stdc.config;

debug import std.stdio;

public
{
	import dsfml.system;
}

class Context
{
	package sfContext* sfPtr; 
	
	this()
	{
		sfPtr = sfContext_create();
	}
	
	~this()
	{
		debug writeln("Destroying Context");
		sfContext_destroy(sfPtr);	
	}
	
	void setActive(bool active)
	{
		sfContext_setActive(sfPtr,active);
	}
	
}



class Window
{
	//Choices for window style
	enum Style
	{
		None = 0,
		Titlebar = 1 << 0,
		Resize = 1 << 1,
		Close = 1 << 2,
		Fullscreen = 1 << 3,
		DefaultStyle = Titlebar | Resize | Close
	}
	
	
	package sfWindow* sfPtr;
	
	
	this(VideoMode mode, string title, Style style = Style.DefaultStyle,  ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_create(mode.tosfVideoMode(), toStringz(title),style, &settings);
	}
	
	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d
	this(VideoMode mode, dstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_createUnicode(mode.tosfVideoMode(), toUint32Ptr(title),style, &settings);
	}
	
	
	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_createFromHandle(handle,  &settings);
	}
	
	~this()
	{
		debug writeln("Destroying Window");
		sfWindow_destroy(sfPtr);
	}
	
	bool pollEvent(ref Event event)
	{
		return (sfWindow_pollEvent(sfPtr, &event.InternalsfEvent) == sfTrue) ? true: false;
	}
	
	bool waitEvent(ref Event event)
	{
		return (sfWindow_waitEvent(sfPtr, &event.InternalsfEvent) == sfTrue) ? true: false;
	}
	
	void setTitle(string newTitle)
	{
		sfWindow_setTitle(sfPtr, toStringz(newTitle));
	}
	
	void setTitle(dstring newTitle)
	{
		sfWindow_setUnicodeTitle(sfPtr, toUint32Ptr(newTitle));
	}
	
	void close()
	{
		sfWindow_close(sfPtr);
	}
	
	const(ContextSettings) getSettings() const
	{
		return sfWindow_getSettings(sfPtr);
	}
	
	
	@property
	{
		void position(Vector2i newPosition)
		{
			sfWindow_setPosition(sfPtr,newPosition.tosfVector2i());
		}
		
		Vector2i position()
		{
			return Vector2i(sfWindow_getPosition(sfPtr));
		}
	}
	
	@property
	{
		void size(Vector2u newSize)
		{
			sfWindow_setSize(sfPtr, newSize.tosfVector2u());
		}
		Vector2u size()
		{
			return Vector2u(sfWindow_getSize(sfPtr));
		}
	}
	
	void setIcon(uint width, uint height, const(ubyte[]) pixels)
	{
		sfWindow_setIcon(sfPtr,width, height, pixels.ptr);
	}
	
	void setVisible(bool visible)
	{
		visible ? sfWindow_setVisible(sfPtr,sfTrue): sfWindow_setVisible(sfPtr,sfFalse);
	}
	
	void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfWindow_setVerticalSyncEnabled(sfPtr, sfTrue): sfWindow_setVerticalSyncEnabled(sfPtr, sfFalse);
	}
	
	void setMouseCursorVisible(bool visible)
	{
		visible ? sfWindow_setMouseCursorVisible(sfPtr,sfTrue): sfWindow_setMouseCursorVisible(sfPtr,sfFalse);
	}
	
	void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfWindow_setKeyRepeatEnabled(sfPtr,sfTrue):sfWindow_setKeyRepeatEnabled(sfPtr,sfFalse);
	}
	
	void setFramerateLimit(uint limit)
	{
		sfWindow_setFramerateLimit(sfPtr, limit);
	}
	
	void setJoystickThreshhold(float threshhold)
	{
		sfWindow_setJoystickThreshold(sfPtr, threshhold);
	}
	
	WindowHandle getSystemHandle() const
	{
		return sfWindow_getSystemHandle(sfPtr);
	}
	
	//TODO: Consider adding these methods.
	//void onCreate
	//void onResize
	
	bool isOpen()
	{
		return (sfWindow_isOpen(sfPtr) == sfTrue)? true: false;
	}
	
	void setActive(bool active)
	{
		active ? sfWindow_setActive(sfPtr, sfTrue): sfWindow_setActive(sfPtr, sfFalse);
	}
	
	void display()
	{
		sfWindow_display(sfPtr);
	}

}


class Joystick
{
	enum
	{
		JoystickCount = 8, 
		JoystickButtonCount = 32, 
		JoystickAxisCount = 8 
	}
	
	enum  Axis 
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
		return (sfJoystick_isConnected(joystick) == sfTrue)?true:false;
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
		return (sfJoystick_hasAxis(joystick, axis) == sfTrue) ? true : false;
	}
	
	static float getAxisPosition(uint joystick, Axis axis)
	{
		return sfJoystick_getAxisPosition(joystick, axis);
	}
	static bool isButtonPressed(uint joystick, uint button)
	{
		return (sfJoystick_isButtonPressed(joystick, button) == sfTrue) ? true : false;
	}
	
}


class Keyboard
{
	//TODO: Remove wonky comments
	enum Key
	{
		Unknown = -1, ///< Unhandled key
		A = 0, ///< The A key
		B, ///< The B key
		C, ///< The C key
		D, ///< The D key
		E, ///< The E key
		F, ///< The F key
		G, ///< The G key
		H, ///< The H key
		I, ///< The I key
		J, ///< The J key
		K, ///< The K key
		L, ///< The L key
		M, ///< The M key
		N, ///< The N key
		O, ///< The O key
		P, ///< The P key
		Q, ///< The Q key
		R, ///< The R key
		S, ///< The S key
		T, ///< The T key
		U, ///< The U key
		V, ///< The V key
		W, ///< The W key
		X, ///< The X key
		Y, ///< The Y key
		Z, ///< The Z key
		Num0, ///< The 0 key
		Num1, ///< The 1 key
		Num2, ///< The 2 key
		Num3, ///< The 3 key
		Num4, ///< The 4 key
		Num5, ///< The 5 key
		Num6, ///< The 6 key
		Num7, ///< The 7 key
		Num8, ///< The 8 key
		Num9, ///< The 9 key
		Escape, ///< The Escape key
		LControl, ///< The left Control key
		LShift, ///< The left Shift key
		LAlt, ///< The left Alt key
		LSystem, ///< The left OS specific key: window (Windows and Linux), apple (MacOS X), ...
		RControl, ///< The right Control key
		RShift, ///< The right Shift key
		RAlt, ///< The right Alt key
		RSystem, ///< The right OS specific key: window (Windows and Linux), apple (MacOS X), ...
		Menu, ///< The Menu key
		LBracket, ///< The [ key
		RBracket, ///< The ] key
		SemiColon, ///< The ; key
		Comma, ///< The , key
		Period, ///< The . key
		Quote, ///< The ' key
		Slash, ///< The / key
		BackSlash, ///< The \ key
		Tilde, ///< The ~ key
		Equal, ///< The = key
		Dash, ///< The - key
		Space, ///< The Space key
		Return, ///< The Return key
		BackSpace, ///< The Backspace key
		Tab, ///< The Tabulation key
		PageUp, ///< The Page up key
		PageDown, ///< The Page down key
		End, ///< The End key
		Home, ///< The Home key
		Insert, ///< The Insert key
		Delete, ///< The Delete key
		Add, ///< The + key
		Subtract, ///< The - key
		Multiply, ///< The * key
		Divide, ///< The / key
		Left, ///< Left arrow
		Right, ///< Right arrow
		Up, ///< Up arrow
		Down, ///< Down arrow
		Numpad0, ///< The numpad 0 key
		Numpad1, ///< The numpad 1 key
		Numpad2, ///< The numpad 2 key
		Numpad3, ///< The numpad 3 key
		Numpad4, ///< The numpad 4 key
		Numpad5, ///< The numpad 5 key
		Numpad6, ///< The numpad 6 key
		Numpad7, ///< The numpad 7 key
		Numpad8, ///< The numpad 8 key
		Numpad9, ///< The numpad 9 key
		F1, ///< The F1 key
		F2, ///< The F2 key
		F3, ///< The F3 key
		F4, ///< The F4 key
		F5, ///< The F5 key
		F6, ///< The F6 key
		F7, ///< The F7 key
		F8, ///< The F8 key
		F9, ///< The F9 key
		F10, ///< The F10 key
		F11, ///< The F11 key
		F12, ///< The F12 key
		F13, ///< The F13 key
		F14, ///< The F14 key
		F15, ///< The F15 key
		Pause, ///< The Pause key
		
		KeyCount ///< Keep last -- the total number of keyboard keys
	}
	
	static bool isKeyPressed(Key key)
	{
		return (sfKeyboard_isKeyPressed(key) == sfTrue) ? true : false;
	}
	
}


class Mouse
{
	enum Button
	{
		Left,     /// The left mouse button
		Right,    /// The right mouse button
		Middle,   /// The middle (wheel) mouse button
		XButton1, /// The first extra mouse button
		XButton2, /// The second extra mouse button
		
		Count /// Keep last -- the total number of mouse buttons
		
	}
	
	static bool isButtonPressed(Button button)
	{
		return (sfMouse_isButtonPressed(button) == sfTrue) ? true : false;
	}
	
	static Vector2i getMousePosition()
	{
		return Vector2i(sfMouse_getPosition(null));
	}	
	
	static Vector2i getMousePosition(const(Window) relativeTo)
	{
		return Vector2i(sfMouse_getPosition(relativeTo.sfPtr));
	}
	
	static void setPosition(Vector2i position)
	{
		sfMouse_setPosition(position.tosfVector2i(),null);
	}
	
	static void setPosition(Vector2i position, const(Window) relativeTo)
	{
		sfMouse_setPosition(position.tosfVector2i(), relativeTo.sfPtr);
	}
}




struct ContextSettings
{
	uint depthBits = 0;
	uint stencilBits = 0;
	uint antialiasingLevel = 0;
	uint majorVersion = 2;
	uint minorVersion = 0;
	
	static const(ContextSettings) Default;
}

struct Event
{
	
	package sfEvent InternalsfEvent;
	
	
	@property int type()
	{
		return InternalsfEvent.type;
	}
	
	
	//TODO: make these properties as well?
	KeyEvent key()
	{
		return KeyEvent(InternalsfEvent.key.code, InternalsfEvent.key.alt, InternalsfEvent.key.control, InternalsfEvent.key.shift, InternalsfEvent.key.system);
	}
	
	
	TextEvent text()
	{
		return TextEvent(InternalsfEvent.text.unicode);
	}
	
	MouseMoveEvent mouseMove()
	{
		return MouseMoveEvent(InternalsfEvent.mouseMove.x, InternalsfEvent.mouseMove.y);
	}
	
	MouseButtonEvent mouseButton()
	{
		return MouseButtonEvent(cast(Mouse.Button)InternalsfEvent.mouseButton.button, InternalsfEvent.mouseButton.x, InternalsfEvent.mouseButton.y);
	}
	
	MouseWheelEvent mouseWheel()
	{
		return MouseWheelEvent(InternalsfEvent.mouseWheel.delta, InternalsfEvent.mouseWheel.x, InternalsfEvent.mouseWheel.y);
	}
	
	JoystickMoveEvent joystickMove()
	{
		return JoystickMoveEvent(InternalsfEvent.joystickMove.joystickId, InternalsfEvent.joystickMove.axis, InternalsfEvent.joystickMove.position);
	}
	
	JoystickButtonEvent joystickButton()
	{
		return JoystickButtonEvent(InternalsfEvent.joystickButton.joystickId, InternalsfEvent.joystickButton.button);
	}
	
	JoystickConnectEvent joystickConnect()
	{
		return JoystickConnectEvent(InternalsfEvent.joystickConnect.joystickId);
	}
	
	SizeEvent size()
	{
		return SizeEvent(InternalsfEvent.size.width, InternalsfEvent.size.height);
	}
	
	
	enum
	{
		Closed,                 
		Resized,                
		LostFocus,              
		GainedFocus,            
		TextEntered,            
		KeyPressed,             
		KeyReleased,            
		MouseWheelMoved,        
		MouseButtonPressed,     
		MouseButtonReleased,    
		MouseMoved,             
		MouseEntered,           
		MouseLeft,              
		JoystickButtonPressed,  
		JoystickButtonReleased, 
		JoystickMoved,          
		JoystickConnected,      
		JoystickDisconnected,  
	}
	
	
	struct SizeEvent
	{
		uint width;
		uint height;
		this(uint w, uint h)
		{
			width = w;
			height = h;
		}
	}
	
	struct KeyEvent
	{
		Keyboard.Key code; 
		bool alt;
		bool control;
		bool shift;
		bool system;
		
		
		this(int keyCode, int altPressed, int controlPressed,int shiftPressed, int systemPressed)
		{
			code = cast(Keyboard.Key)keyCode;
			
			alt = (altPressed == sfTrue)?true:false;
			
			
			control = (controlPressed == sfTrue)? true:false;
			
			
			shift = (shiftPressed == sfTrue)?true:false;
			
			
			system = (controlPressed == sfTrue)?true:false;
			
		}
	}
	
	struct TextEvent
	{
		dchar unicode;
		this(uint uCode)
		{
			unicode = uCode;
		}
	}
	
	struct MouseMoveEvent
	{
		int x;
		int y;
		this(int X, int Y)
		{
			x = X;
			y = Y;
		}
	}
	
	struct MouseButtonEvent
	{
		Mouse.Button button;
		int x; 
		int y; 
	}
	
	struct MouseWheelEvent
	{
		int  delta;
		int  x;
		int  y;
	}
	
	struct JoystickConnectEvent
	{
		uint joystickId; 
	}
	
	
	struct JoystickMoveEvent 
	{
		uint joystickId; 
		Joystick.Axis axis; 
		float position; 
		
		this(uint joystick, Joystick.Axis sfAxis,float sfPosition)
		{
			joystickId = joystick;
			axis = cast(Joystick.Axis)sfAxis;
			position = 	sfPosition;
			
		}
	}
	struct JoystickButtonEvent
	{
		uint joystickId;
		uint button;
		this(uint joystick, uint Button)
		{
			joystickId = joystick;
			button = Button;
		}
	}
	
	
}



struct VideoMode
{
	uint width;
	uint height;
	uint bitsPerPixel;
	
	this(uint Width, uint Height, uint bits= 32)
	{
		width = Width;
		height = Height;
		bitsPerPixel = bits;
	}
	
	
	package this(sfVideoMode videoMode)
	{
		width = videoMode.width;
		height = videoMode.height;
		bitsPerPixel = videoMode.bitsPerPixel;
	}
	
	package sfVideoMode tosfVideoMode()const
	{
		return sfVideoMode(width,height, bitsPerPixel);
	}
	
	static VideoMode getDesktopMode()
	{
		return VideoMode(sfVideoMode_getDesktopMode());
	}
	
	static VideoMode[] getFullscreenModes()
	{
		
		sfVideoMode* modes;
		size_t counts;
		
		modes = sfVideoMode_getFullscreenModes(&counts);
		
		VideoMode[] videoModes;
		videoModes.length = counts;
		
		for(uint i = 0; i < counts; ++i)
		{
			videoModes[i] = VideoMode(modes[i]);
		}
		
		return videoModes;
		
	}
	
	bool isValid() const
	{
		return (sfVideoMode_isValid(this.tosfVideoMode()) == sfTrue)? true:false;
	}
	
	//used for debugging
	string toString()
	{
		return "Width: " ~ text(width) ~ " Height: " ~ text(height) ~ " Bits per pixel: " ~ text(bitsPerPixel);
	}
	
	
	
}


version(Windows)
{
	struct HWND__;
	alias HWND__* WindowHandle;
}
version(OSX)
{
	alias c_ulong WindowHandle;
}
version(linux)
{
	alias void* WindowHandle;
}



//Internal Binding Portion
package:

enum sfEventType
{
	sfEvtClosed,
	sfEvtResized,
	sfEvtLostFocus,
	sfEvtGainedFocus,
	sfEvtTextEntered,
	sfEvtKeyPressed,
	sfEvtKeyReleased,
	sfEvtMouseWheelMoved,
	sfEvtMouseButtonPressed,
	sfEvtMouseButtonReleased,
	sfEvtMouseMoved,
	sfEvtMouseEntered,
	sfEvtMouseLeft,
	sfEvtJoystickButtonPressed,
	sfEvtJoystickButtonReleased,
	sfEvtJoystickMoved,
	sfEvtJoystickConnected,
	sfEvtJoystickDisconnected
}

struct sfKeyEvent
{
	sfEventType type;
	Keyboard.Key   code;
	sfBool      alt;
	sfBool      control;
	sfBool      shift;
	sfBool      system;
}

struct sfTextEvent
{
	sfEventType type;
	int    unicode;
}

struct sfMouseMoveEvent
{
	sfEventType type;
	int         x;
	int         y;
}

struct sfMouseButtonEvent
{
	sfEventType   type;
	Mouse.Button button;
	int           x;
	int           y;
}

struct sfMouseWheelEvent
{
	sfEventType type;
	int         delta;
	int         x;
	int         y;
}

struct sfJoystickMoveEvent
{
	sfEventType    type;
	uint   joystickId;
	Joystick.Axis axis;
	float          position;
}

struct sfJoystickButtonEvent
{
	sfEventType  type;
	uint joystickId;
	uint button;
}

struct sfJoystickConnectEvent
{
	sfEventType  type;
	uint joystickId;
}

struct sfSizeEvent
{
	sfEventType  type;
	uint width;
	uint height;
}

union sfEvent
{
	sfEventType type;
	sfSizeEvent size;
	sfKeyEvent key;
	sfTextEvent text;
	sfMouseMoveEvent mouseMove;
	sfMouseButtonEvent mouseButton;
	sfMouseWheelEvent mouseWheel;
	sfJoystickMoveEvent joystickMove;
	sfJoystickButtonEvent joystickButton;
	sfJoystickConnectEvent joystickConnect;
}





extern(C)
{
	struct sfContext;
	struct sfWindow;

	struct sfVideoMode
	{
		uint width;
		uint height;
		uint bitsPerPixel;
	}

	//Context
	sfContext* sfContext_create();
	void sfContext_destroy(sfContext* context);
	void sfContext_setActive(sfContext* context, bool  active);
	
	//Joystick
	sfBool sfJoystick_isConnected(uint joystick);
	uint sfJoystick_getButtonCount(uint joystick);
	sfBool sfJoystick_hasAxis(uint joystick, Joystick.Axis axis);
	sfBool sfJoystick_isButtonPressed(uint joystick, uint button);
	float sfJoystick_getAxisPosition(uint joystick, Joystick.Axis axis);
	void sfJoystick_update();
	
	//Keyboard
	sfBool sfKeyboard_isKeyPressed(Keyboard.Key key);
	
	//Mouse
	sfBool sfMouse_isButtonPressed(Mouse.Button button);
	sfVector2i sfMouse_getPosition(const(sfWindow)* relativeTo);
	void sfMouse_setPosition(sfVector2i position, const(sfWindow)* relativeTo);
	
	//Video Mode
	sfVideoMode sfVideoMode_getDesktopMode();
	sfVideoMode* sfVideoMode_getFullscreenModes(size_t* Count);
	sfBool sfVideoMode_isValid(sfVideoMode mode);
	
	//Window
	sfWindow* sfWindow_create(sfVideoMode mode, const(char)* title, uint style, const(ContextSettings)* settings);
	sfWindow* sfWindow_createFromHandle(WindowHandle handle, const(ContextSettings)* settings);
	sfWindow* sfWindow_createUnicode(sfVideoMode mode, const(uint)* title, uint style, const(ContextSettings)* settings);
	void  sfWindow_destroy(sfWindow* window);
	void  sfWindow_close(sfWindow* window);
	sfBool   sfWindow_isOpen(const(sfWindow)* window);
	ContextSettings  sfWindow_getSettings(const(sfWindow)* window);
	sfBool   sfWindow_pollEvent(sfWindow* window, sfEvent* event);
	sfBool   sfWindow_waitEvent(sfWindow* window, sfEvent* event);
	sfVector2i  sfWindow_getPosition(const(sfWindow)* window);
	void  sfWindow_setPosition(sfWindow* window, sfVector2i position);
	sfVector2u  sfWindow_getSize(const(sfWindow)* window);
	void  sfWindow_setSize(sfWindow* window, sfVector2u size);
	void  sfWindow_setTitle(sfWindow* window, const(char)* title);
	void sfWindow_setUnicodeTitle(sfWindow* window, const(uint)* title);
	void  sfWindow_setIcon(sfWindow* window, uint width, uint height, const(ubyte)* pixels);
	void  sfWindow_setVisible(sfWindow* window, sfBool  visible);
	void  sfWindow_setMouseCursorVisible(sfWindow* window, sfBool  visible);
	void  sfWindow_setVerticalSyncEnabled(sfWindow* window, sfBool  enabled);
	void  sfWindow_setKeyRepeatEnabled(sfWindow* window, sfBool  enabled);
	sfBool   sfWindow_setActive(sfWindow* window, sfBool  active);
	void  sfWindow_display(sfWindow* window);
	void  sfWindow_setFramerateLimit(sfWindow* window, uint limit);
	void  sfWindow_setJoystickThreshold(sfWindow* window, float threshold);
	WindowHandle  sfWindow_getSystemHandle(const(sfWindow)* window);
}
