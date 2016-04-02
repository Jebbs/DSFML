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

module dsfml.window.window;

import dsfml.window.event;
import dsfml.window.videomode;
import dsfml.window.contextsettings;
import dsfml.window.windowhandle;
import dsfml.system.vector2;
import dsfml.system.err;

/**
 *Window that serves as a target for OpenGL rendering.
 *
 *Window is the main class of the Window module.
 *
 *It defines an OS window that is able to receive an OpenGL rendering.
 *
 *A Window can create its own new window, or be embedded into an already existing control using the create(handle) function. This can be useful for embedding an OpenGL rendering area into a view which is part of a bigger GUI with existing windows, controls, etc. It can also serve as embedding an OpenGL rendering area into a window created by another (probably richer) GUI library like Qt or wxWidgets.
 *
 *The Window class provides a simple interface for manipulating the window: move, resize, show/hide, control mouse cursor, etc. It also provides event handling through its pollEvent() and waitEvent() functions.
 *
 *Note that OpenGL experts can pass their own parameters (antialiasing level, bits for the depth and stencil buffers, etc.) to the OpenGL context attached to the window, with the ContextSettings structure which is passed as an optional argument when creating the window.
 */
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

	private bool m_needsToDelete = true;

	//Default constructor
	this()
	{
		sfPtr = sfWindow_construct();
	}

	//Construct a window without calling sfWindow_construct
	//This allows a RenderWindow to be created without creating a Window first
	protected this(int)
	{
		m_needsToDelete = false;
	}

	//allows RenderWindow to delete the Window pointer when it is created
	//so that there are not both instances.
	protected void deleteWindowPtr()
	{
		sfWindow_destroy(sfPtr);
		m_needsToDelete = false;
	}
	
	//TODO: Reduce to one constructor with a template parameter for the string types. Use sfWindow_createUnicode in case it has unicode in the title.

	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d

	///Construct a new window.
	///
	///This constructor creates the window with the size and pixel depth defined in mode. An optional style can be passed to customize the look and behaviour of the window (borders, title bar, resizable, closable, ...). If style contains Style::Fullscreen, then mode must be a valid video mode.
	///
	///The fourth parameter is an optional structure specifying advanced OpenGL context settings such as antialiasing, depth-buffer bits, etc.
	///
	///Params:
	///   	mode = Video mode to use (defines the width, height and depth of the rendering area of the window).
	///  	title = Title of the window.
	///   	style = Window style.
	///    	settings = Additional settings for the underlying OpenGL context.
	this(T)(VideoMode mode, immutable(T)[] title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
		if (is(T == dchar)||is(T == wchar)||is(T == char))
	{
		import dsfml.system.string;

		this();
		create(mode, title, style, settings);
	}

	///Construct the window from an existing control.
	///
	///Use this constructor if you want to create an OpenGL rendering area into an already existing control.
	///
	///The second parameter is an optional structure specifying advanced OpenGL context settings such as antialiasing, depth-buffer bits, etc.
	///
	///Params:
    ///		handle = Platform-specific handle of the control.
    ///		settings = Additional settings for the underlying OpenGL context.
	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		this();
		create(handle, settings);
	}
	
	~this()
	{
		import dsfml.system.config;
		//this takes care of not freeing a null pointer due to inheritance
		//(RenderWindow does not create the inherited sfWindow)
		if(m_needsToDelete)
		{
			mixin(destructorOutput);
			sfWindow_destroy(sfPtr);
		}
	}

	///Get's or set's the window's position.
	///
	///This function only works for top-level windows (i.e. it will be ignored for windows created from the handle of a child window/control).
	@property
	{
		Vector2i position(Vector2i newPosition)
		{
			sfWindow_setPosition(sfPtr,newPosition.x, newPosition.y);
			return newPosition;
		}
		
		Vector2i position()
		{
			Vector2i temp;
			sfWindow_getPosition(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}
	
	///Get's or set's the window's size.
	@property
	{
		Vector2u size(Vector2u newSize)
		{
			sfWindow_setSize(sfPtr, newSize.x, newSize.y);
			return newSize;
		}
		Vector2u size()
		{
			Vector2u temp;
			sfWindow_getSize(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}

	///Activate or deactivate the window as the current target for OpenGL rendering.
	///
	///A window is active only on the current thread, if you want to make it active on another thread you have to deactivate it on the previous thread first if it was active. Only one window can be active on a thread at a time, thus the window previously active (if any) automatically gets deactivated.
	///
	///Params:
    ///		active = True to activate, false to deactivate.
    ///
	///Returns: True if operation was successful, false otherwise.
	bool setActive(bool active)
	{
		import dsfml.system.string;
		bool toReturn = sfWindow_setActive(sfPtr, active);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
		return toReturn;
	}
	
	///Request the current window to be made the active foreground window.
	void requestFocus()
	{
		sfWindow_requestFocus(sfPtr);
	}
	
	///Check whether the window has the input focus
	///
	///Returns: True if the window has focus, false otherwise
	bool hasFocus() const
	{
		return sfWindow_hasFocus(sfPtr);
	}
	
	///Limit the framerate to a maximum fixed frequency.
	///
	///If a limit is set, the window will use a small delay after each call to display() to ensure that the current frame lasted long enough to match the framerate limit. SFML will try to match the given limit as much as it can, but since it internally uses sf::sleep, whose precision depends on the underlying OS, the results may be a little unprecise as well (for example, you can get 65 FPS when requesting 60).
	///
	///Params:
    ///		limit = Framerate limit, in frames per seconds (use 0 to disable limit).
	void setFramerateLimit(uint limit)
	{
		sfWindow_setFramerateLimit(sfPtr, limit);
	}

	///Change the window's icon.
	///
	///pixels must be an array of width x height pixels in 32-bits RGBA format.
	///
	///The OS default icon is used by default.
	///
	///Params:
	///    width = Icon's width, in pixels.
	///    height = Icon's height, in pixels.
	///    pixels = Pointer to the array of pixels in memory.
	void setIcon(uint width, uint height, const(ubyte[]) pixels)
	{
		sfWindow_setIcon(sfPtr,width, height, pixels.ptr);
	}

	///Change the joystick threshold.
	///
	///The joystick threshold is the value below which no JoystickMoved event will be generated.
	///
	///The threshold value is 0.1 by default.
	///
	///Params:
	///    threshold = New threshold, in the range [0, 100].
	void setJoystickThreshhold(float threshhold)
	{
		sfWindow_setJoystickThreshold(sfPtr, threshhold);
	}

	///Enable or disable automatic key-repeat.
	///
	///If key repeat is enabled, you will receive repeated KeyPressed events while keeping a key pressed. If it is disabled, you will only get a single event when the key is pressed.
	///
	///Key repeat is enabled by default.
	///
	///Params:
	///    enabled = True to enable, false to disable.
	void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfWindow_setKeyRepeatEnabled(sfPtr,true):sfWindow_setKeyRepeatEnabled(sfPtr,false);
	}

	///Show or hide the mouse cursor.
	///
	///The mouse cursor is visible by default.
	///
	///Params:
    ///		visible = True to show the mouse cursor, false to hide it.
	void setMouseCursorVisible(bool visible)
	{
		visible ? sfWindow_setMouseCursorVisible(sfPtr,true): sfWindow_setMouseCursorVisible(sfPtr,false);
	}

	//Cannot use templates here as template member functions cannot be virtual.

	///Change the title of the window.
	///
	///Params:
    ///		title = New title.
	void setTitle(string newTitle)
	{
		import dsfml.system.string;
		sfWindow_setUnicodeTitle(sfPtr, toStringz(stringConvert!(char, dchar)(newTitle)));
	}
	///Change the title of the window.
	///
	///Params:
    ///		title = New title.
	void setTitle(wstring newTitle)
	{
		import dsfml.system.string;
		sfWindow_setUnicodeTitle(sfPtr, toStringz(stringConvert!(wchar, dchar)(newTitle)));
	}
	///Change the title of the window.
	///
	///Params:
    ///		title = New title.
	void setTitle(dstring newTitle)
	{
		import dsfml.system.string;
		sfWindow_setUnicodeTitle(sfPtr, toStringz(newTitle));
	}

	///Show or hide the window.
	///
	///The window is shown by default.
	///
	///Params:
	///    visible = True to show the window, false to hide it.
	void setVisible(bool visible)
	{
		sfWindow_setVisible(sfPtr,visible);
	}
	
	///Enable or disable vertical synchronization.
	///
	///Activating vertical synchronization will limit the number of frames displayed to the refresh rate of the monitor. This can avoid some visual artifacts, and limit the framerate to a good value (but not constant across different computers).
	///
	///Vertical synchronization is disabled by default.
	///
	///Params:
	///    enabled = True to enable v-sync, false to deactivate it.
	void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfWindow_setVerticalSyncEnabled(sfPtr, true): sfWindow_setVerticalSyncEnabled(sfPtr, false);
	}

	///Get the settings of the OpenGL context of the window.
	///
	///Note that these settings may be different from what was passed to the constructor or the create() function, if one or more settings were not supported. In this case, SFML chose the closest match.
	///
	///Returns: Structure containing the OpenGL context settings.
	ContextSettings getSettings() const
	{
		ContextSettings temp;
		sfWindow_getSettings(sfPtr,&temp.depthBits, &temp.stencilBits, &temp.antialiasingLevel, &temp.majorVersion, &temp.minorVersion);
		return temp;
	}

	///Get the OS-specific handle of the window.
	///
	///The type of the returned handle is sf::WindowHandle, which is a typedef to the handle type defined by the OS. You shouldn't need to use this function, unless you have very specific stuff to implement that SFML doesn't support, or implement a temporary workaround until a bug is fixed.
	///
	///Returns: System handle of the window.
	WindowHandle getSystemHandle() const
	{
		return sfWindow_getSystemHandle(sfPtr);
	}

	//TODO: Consider adding these methods.
	//void onCreate
	//void onResize

	///Close the window and destroy all the attached resources.
	///
	///After calling this function, the Window instance remains valid and you can call create() to recreate the window. All other functions such as pollEvent() or display() will still work (i.e. you don't have to test isOpen() every time), and will have no effect on closed windows.
	void close()
	{
		sfWindow_close(sfPtr);
	}

	//Cannot use templates here as template member functions cannot be virtual.

	///Create (or recreate) the window.
	///
	///If the window was already created, it closes it first. If style contains Style::Fullscreen, then mode must be a valid video mode.
	///
	///The fourth parameter is an optional structure specifying advanced OpenGL context settings such as antialiasing, depth-buffer bits, etc.
	void create(VideoMode mode, string title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import dsfml.system.string;
		sfWindow_createFromSettings(sfPtr, mode.width, mode.height, mode.bitsPerPixel, toStringz(stringConvert!(char,dchar)(title)), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
	}
	///Create (or recreate) the window.
	///
	///If the window was already created, it closes it first. If style contains Style::Fullscreen, then mode must be a valid video mode.
	///
	///The fourth parameter is an optional structure specifying advanced OpenGL context settings such as antialiasing, depth-buffer bits, etc.
	void create(VideoMode mode, wstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import dsfml.system.string;
		sfWindow_createFromSettings(sfPtr, mode.width, mode.height, mode.bitsPerPixel, toStringz(stringConvert!(wchar,dchar)(title)), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
	}
	///Create (or recreate) the window.
	///
	///If the window was already created, it closes it first. If style contains Style::Fullscreen, then mode must be a valid video mode.
	///
	///The fourth parameter is an optional structure specifying advanced OpenGL context settings such as antialiasing, depth-buffer bits, etc.
	void create(VideoMode mode, dstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import dsfml.system.string;
		sfWindow_createFromSettings(sfPtr, mode.width, mode.height, mode.bitsPerPixel, toStringz(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
	}

	///Create (or recreate) the window from an existing control.
	///
	///Use this function if you want to create an OpenGL rendering area into an already existing control. If the window was already created, it closes it first.
	///
	///The second parameter is an optional structure specifying advanced OpenGL context settings such as antialiasing, depth-buffer bits, etc.
	void create(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import dsfml.system.string;
		sfWindow_createFromHandle(sfPtr, handle, settings.depthBits,settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(dsfml.system.string.toString(sfErr_getOutput()));
	}

	///Display on screen what has been rendered to the window so far.
	///
	///This function is typically called after all OpenGL rendering has been done for the current frame, in order to show it on screen.
	void display()
	{
		sfWindow_display(sfPtr);
	}

	///Tell whether or not the window is open.
	///
	///This function returns whether or not the window exists. Note that a hidden window (setVisible(false)) is open (therefore this function would return true).
	///
	///Returns: True if the window is open, false if it has been closed.
	bool isOpen()
	{
		return (sfWindow_isOpen(sfPtr));
	}

	///Pop the event on top of the event queue, if any, and return it.
	///
	///This function is not blocking: if there's no pending event then it will return false and leave event unmodified. Note that more than one event may be present in the event queue, thus you should always call this function in a loop to make sure that you process every pending event. 
	///
	///Params:
    ///		event = Event to be returned.
    ///
	///Returns: True if an event was returned, or false if the event queue was empty.
	bool pollEvent(ref Event event)
	{
		return (sfWindow_pollEvent(sfPtr, &event));
	}
	
	///Wait for an event and return it.
	///
	///This function is blocking: if there's no pending event then it will wait until an event is received. After this function returns (and no error occured), the event object is always valid and filled properly. This function is typically used when you have a thread that is dedicated to events handling: you want to make this thread sleep as long as no new event is received. 
	///
	///Params:
    ///		event = Event to be returned.
    ///
	///Returns: False if any error occured.
	bool waitEvent(ref Event event)
	{
		return (sfWindow_waitEvent(sfPtr, &event));
	}

	//TODO: Clean this shit up. The names are so bad. :(

	//Gives a way for RenderWindow to send its mouse position 
	protected Vector2i getMousePosition()const
	{
		Vector2i temp;
		sfMouse_getPosition(sfPtr,&temp.x, &temp.y);
		return temp;
	}

	//A method for the Mouse class to use in order to get the mouse position relative to the window
	package Vector2i mouse_getPosition()const
	{
		return getMousePosition();
	}

	//Gives a way for Render Window to set its mouse position
	protected void setMousePosition(Vector2i pos) const
	{
		sfMouse_setPosition(pos.x, pos.y, sfPtr);
	}

	//A method for the mouse class to use
	package void mouse_SetPosition(Vector2i pos) const
	{
		setMousePosition(pos);
	}

	//Circumvents the package restriction allowing Texture to get the internal pointer
	protected static void* getWindowPointer(Window window)
	{
		return window.sfPtr;
	}

	
}

unittest
{
	version(DSFML_Unittest_Window)
	{
		import std.stdio;
		import dsfml.graphics.image;

		writeln("Unit test for Window class.");


		//constructor
		auto window = new Window(VideoMode(800,600),"Test Window");

		//perform each window call
		Vector2u windowSize = window.size;

		windowSize.x = 1000;
		windowSize.y = 1000;

		window.size = windowSize;

		Vector2i windowPosition = window.position;

		windowPosition.x = 100;
		windowPosition.y = 100;

		window.position = windowPosition;

		window.setTitle("thing");//uses the first set title

		window.setTitle("素晴らしい ！");//forces the dstring override and uses unicode

		window.setActive(true);

		window.setJoystickThreshhold(1);

		window.setVisible(true);

		window.setFramerateLimit(60);

		window.setMouseCursorVisible(true);

		window.setVerticalSyncEnabled(true);

		auto settings = window.getSettings();

		auto image = new Image();
		image.loadFromFile("res/TestImage.png");

		window.setIcon(image.getSize().x,image.getSize().x,image.getPixelArray());

		if(window.isOpen())
		{
			Event event;
			if(window.pollEvent(event))
			{

			}
			//requires users input
			if(window.waitEvent(event))
			{

			}

			window.display();
		}

		window.close();

	}
}


package extern(C) struct sfWindow;

private extern(C):

	//Construct a new window
	sfWindow* sfWindow_construct();

	//Construct a new window (with a UTF-32 title)
	void sfWindow_createFromSettings(sfWindow* window, uint width, uint height, uint bitsPerPixel, const(dchar)* title, int style, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

	//Construct a window from an existing control
	void sfWindow_createFromHandle(sfWindow* window, WindowHandle handle, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

	// Destroy a window
	void sfWindow_destroy(sfWindow* window);

	//Close a window and destroy all the attached resources
	void sfWindow_close(sfWindow* window);

	//Tell whether or not a window is opened
	bool sfWindow_isOpen(const(sfWindow)* window);

	//Get the settings of the OpenGL context of a window
	void sfWindow_getSettings(const(sfWindow)* window, uint* depthBits, uint* stencilBits, uint* antialiasingLevel, uint* majorVersion, uint* minorVersion);

	//Pop the event on top of event queue, if any, and return it
	bool sfWindow_pollEvent(sfWindow* window, Event* event);

	//Wait for an event and return it
	bool sfWindow_waitEvent(sfWindow* window, Event* event);

	//Get the position of a window
	void sfWindow_getPosition(const(sfWindow)* window, int* x, int* y);

	//Change the position of a window on screen
	void sfWindow_setPosition(sfWindow* window, int x, int y);

	//Get the size of the rendering region of a window
	void sfWindow_getSize(const(sfWindow)* window, uint* width, uint* height);

	//Change the size of the rendering region of a window
	void sfWindow_setSize(sfWindow* window, uint width, uint height);

	//Change the title of a window
	void sfWindow_setTitle(sfWindow* window, const(char)* title);

	//Change the title of a window (with a UTF-32 string)
	void sfWindow_setUnicodeTitle(sfWindow* window, const(dchar)* title);

	//Change a window's icon
	void sfWindow_setIcon(sfWindow* window, uint width, uint height, const(ubyte)* pixels);

	//Show or hide a window
	void sfWindow_setVisible(sfWindow* window, bool visible);

	//Show or hide the mouse cursor
	void sfWindow_setMouseCursorVisible(sfWindow* window, bool visible);

	//Enable or disable vertical synchronization
	 void sfWindow_setVerticalSyncEnabled(sfWindow* window, bool enabled);

	//Enable or disable automatic key-repeat
	 void sfWindow_setKeyRepeatEnabled(sfWindow* window, bool enabled);

	//Activate or deactivate a window as the current target for OpenGL rendering
	 bool sfWindow_setActive(sfWindow* window, bool active);
	 
	 //Request the current window to be made the active foreground window.
	 void sfWindow_requestFocus(sfWindow* window);
	 
	 //Check whether the window has the input focus
	 bool sfWindow_hasFocus(const(sfWindow)* window);

	//Display on screen what has been rendered to the window so far
	 void sfWindow_display(sfWindow* window);

	//Limit the framerate to a maximum fixed frequency
	 void sfWindow_setFramerateLimit(sfWindow* window, uint limit);

	//Change the joystick threshold
	 void sfWindow_setJoystickThreshold(sfWindow* window, float threshold);
	
	
	//Get the OS-specific handle of the window
	 WindowHandle sfWindow_getSystemHandle(const(sfWindow)* window);

	void sfMouse_getPosition(const(sfWindow)* relativeTo, int* x, int* y);
	void sfMouse_setPosition(int x, int y, const(sfWindow)* relativeTo);

	const(char)* sfErr_getOutput();



