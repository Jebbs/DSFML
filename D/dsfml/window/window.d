module dsfml.window.window;
import dsfml.window.event;
import dsfml.window.videomode;
import dsfml.window.contextsettings;
import dsfml.window.windowhandle;
import dsfml.system.vector2;
import std.string;
import std.utf;
debug import std.stdio;

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
	
	
	this(VideoMode mode, string title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_create(mode.width, mode.height, mode.bitsPerPixel, toStringz(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
	}
	
	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d
	this(VideoMode mode, dstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_createUnicode(mode.width, mode.height, mode.bitsPerPixel, toUTF32z(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
	}
	
	
	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfWindow_createFromHandle(handle, settings.depthBits,settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
	}
	
	~this()
	{
		debug writeln("Destroying Window");
		sfWindow_destroy(sfPtr);
	}
	
	bool pollEvent(ref Event event)
	{
		return (sfWindow_pollEvent(sfPtr, &event));// == sfTrue) ? true: false;
	}
	
	bool waitEvent(ref Event event)
	{
		return (sfWindow_waitEvent(sfPtr, &event));// == sfTrue) ? true: false;
	}
	
	void setTitle(string newTitle)
	{
		sfWindow_setTitle(sfPtr, toStringz(newTitle));
	}
	
	void setTitle(dstring newTitle)
	{
		sfWindow_setUnicodeTitle(sfPtr, toUTF32z(newTitle));
	}
	
	void close()
	{
		sfWindow_close(sfPtr);
	}
	
	const(ContextSettings) getSettings() const
	{
		ContextSettings temp;
		sfWindow_getSettings(sfPtr,&temp.depthBits, &temp.stencilBits, &temp.antialiasingLevel, &temp.majorVersion, &temp.minorVersion);
		return temp;
	}
	
	
	@property
	{
		void position(Vector2i newPosition)
		{
			sfWindow_setPosition(sfPtr,newPosition.x, newPosition.y);
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
		void size(Vector2u newSize)
		{
			sfWindow_setSize(sfPtr, newSize.x, newSize.y);
		}
		Vector2u size()
		{
			Vector2u temp;
			sfWindow_getSize(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}
	
	void setIcon(uint width, uint height, const(ubyte[]) pixels)
	{
		sfWindow_setIcon(sfPtr,width, height, pixels.ptr);
	}
	
	void setVisible(bool visible)
	{
		visible ? sfWindow_setVisible(sfPtr,true): sfWindow_setVisible(sfPtr,false);
	}
	
	void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfWindow_setVerticalSyncEnabled(sfPtr, true): sfWindow_setVerticalSyncEnabled(sfPtr, false);
	}
	
	void setMouseCursorVisible(bool visible)
	{
		visible ? sfWindow_setMouseCursorVisible(sfPtr,true): sfWindow_setMouseCursorVisible(sfPtr,false);
	}
	
	void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfWindow_setKeyRepeatEnabled(sfPtr,true):sfWindow_setKeyRepeatEnabled(sfPtr,false);
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
		return (sfWindow_isOpen(sfPtr));// == sfTrue)? true: false;
	}
	
	void setActive(bool active)
	{
		active ? sfWindow_setActive(sfPtr, true): sfWindow_setActive(sfPtr, false);
	}
	
	void display()
	{
		sfWindow_display(sfPtr);
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
	bool sfWindow_isOpen(const sfWindow* window);
	
	
	//Get the settings of the OpenGL context of a window
	void sfWindow_getSettings(const sfWindow* window, uint* depthBits, uint* stencilBits, uint* antialiasingLevel, uint* majorVersion, uint* minorVersion);
	
	
	//Pop the event on top of event queue, if any, and return it
	bool sfWindow_pollEvent(sfWindow* window, Event* event);
	
	
	//Wait for an event and return it
	bool sfWindow_waitEvent(sfWindow* window, Event* event);
	
	
	//Get the position of a window
	void sfWindow_getPosition(const sfWindow* window, int* x, int* y);
	
	
	//Change the position of a window on screen
	void sfWindow_setPosition(sfWindow* window, int x, int y);
	
	
	//Get the size of the rendering region of a window
	void sfWindow_getSize(const sfWindow* window, uint* width, uint* height);
	
	
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
}