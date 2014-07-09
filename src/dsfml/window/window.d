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
module dsfml.window.window;

import dsfml.window.event;
import dsfml.window.videomode;
import dsfml.window.contextsettings;
import dsfml.window.windowhandle;
import dsfml.system.vector2;
import dsfml.system.err;
import std.conv;
import std.string;
import std.utf;


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

	//blank constructor for RenderWindow
	protected this()
	{
	}
	
	this(VideoMode mode, string title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_create(mode.width, mode.height, mode.bitsPerPixel, toStringz(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErr_getOutput()));
	}
	
	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d
	this(VideoMode mode, dstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_createUnicode(mode.width, mode.height, mode.bitsPerPixel, toUTF32z(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErr_getOutput()));
	}

	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_createFromHandle(handle, settings.depthBits,settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErr_getOutput()));
	}
	
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfWindow_destroy(sfPtr);
	}

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

	bool setActive(bool active)
	{
		bool toReturn = sfWindow_setActive(sfPtr, active);
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}

	void setFramerateLimit(uint limit)
	{
		sfWindow_setFramerateLimit(sfPtr, limit);
	}

	void setIcon(uint width, uint height, const(ubyte[]) pixels)
	{
		sfWindow_setIcon(sfPtr,width, height, pixels.ptr);
	}

	void setJoystickThreshhold(float threshhold)
	{
		sfWindow_setJoystickThreshold(sfPtr, threshhold);
	}

	void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfWindow_setKeyRepeatEnabled(sfPtr,true):sfWindow_setKeyRepeatEnabled(sfPtr,false);
	}

	void setMouseCursorVisible(bool visible)
	{
		visible ? sfWindow_setMouseCursorVisible(sfPtr,true): sfWindow_setMouseCursorVisible(sfPtr,false);
	}

	void setTitle(string newTitle)
	{
		sfWindow_setTitle(sfPtr, toStringz(newTitle));
	}
	
	void setTitle(dstring newTitle)
	{
		sfWindow_setUnicodeTitle(sfPtr, toUTF32z(newTitle));
	}

	void setVisible(bool visible)
	{
		sfWindow_setVisible(sfPtr,visible);
	}
	
	void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfWindow_setVerticalSyncEnabled(sfPtr, true): sfWindow_setVerticalSyncEnabled(sfPtr, false);
	}

	ContextSettings getSettings() const
	{
		ContextSettings temp;
		sfWindow_getSettings(sfPtr,&temp.depthBits, &temp.stencilBits, &temp.antialiasingLevel, &temp.majorVersion, &temp.minorVersion);
		return temp;
	}

	WindowHandle getSystemHandle() const
	{
		return sfWindow_getSystemHandle(sfPtr);
	}


	//TODO: Consider adding these methods.
	//void onCreate
	//void onResize

	void close()
	{
		sfWindow_close(sfPtr);
	}

	void display()
	{
		sfWindow_display(sfPtr);
	}

	bool isOpen()
	{
		return (sfWindow_isOpen(sfPtr));
	}

	bool pollEvent(ref Event event)
	{
		return (sfWindow_pollEvent(sfPtr, &event));
	}
	
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

	protected void setMousePosition(Vector2i pos) const
	{
		sfMouse_setPosition(pos.x, pos.y, sfPtr);
	}

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

		window.setTitle("素晴らしい ！"d);//forces the dstring override and uses unicode

		window.setActive(true);

		window.setJoystickThreshhold(1);

		window.setVisible(true);

		window.setFramerateLimit(60);

		window.setMouseCursorVisible(true);

		window.setVerticalSyncEnabled(true);

		auto settings = window.getSettings();

		auto image = new Image();
		image.loadFromFile("Crono.png");//replace with something that won't get me in trouble

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


alias std.utf.toUTFz!(const(dchar)*) toUTF32z;

package extern(C)
{
	struct sfWindow;
}

private extern(C)
{
	//Construct a new window
	sfWindow* sfWindow_create(uint width, uint height, uint bitsPerPixel, const char* title, int style, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

	//Construct a new window (with a UTF-32 title)
	sfWindow* sfWindow_createUnicode(uint width, uint height, uint bitsPerPixel, const(dchar)* title, int style, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

	//Construct a window from an existing control
	sfWindow* sfWindow_createFromHandle(WindowHandle handle, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

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
}


