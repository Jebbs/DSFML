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
module dsfml.graphics.renderwindow;

import dsfml.graphics.color;
import dsfml.graphics.image;
import dsfml.graphics.rect;

import dsfml.graphics.drawable;
import dsfml.graphics.primitivetype;
import dsfml.graphics.renderstates;
import dsfml.graphics.rendertarget;
import dsfml.graphics.shader;
import dsfml.graphics.text;
import dsfml.graphics.texture;
import dsfml.graphics.view;
import dsfml.graphics.vertex;


import dsfml.window.contextsettings;
import dsfml.window.windowhandle;
import dsfml.window.event;
import dsfml.window.window;
import dsfml.window.videomode;

import dsfml.system.err;
import dsfml.system.vector2;

/++
 + Window that can serve as a target for 2D drawing.
 + 
 + RenderWindow is the main class of the Graphics package.
 + 
 + It defines an OS window that can be painted using the other classes of the graphics module.
 + 
 + RenderWindow is derived from Window, thus it inherits all its features: events, window management, OpenGL rendering, etc. See the documentation of Window for a more complete description of all these features, as well as code examples.
 + 
 + On top of that, RenderWindow adds more features related to 2D drawing with the graphics module (see its base class RenderTarget for more details).
 + 
 + Like Window, RenderWindow is still able to render direct OpenGL stuff. It is even possible to mix together OpenGL calls and regular SFML drawing commands.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1RenderWindow.php#details
 +/
class RenderWindow : Window, RenderTarget
{
	package sfRenderWindow* sfPtr;

	package this()
	{
	}

	this(VideoMode mode, string title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import std.string;
		import std.conv;
		sfPtr = sfRenderWindow_create(mode.width, mode.height, mode.bitsPerPixel, toStringz(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErr_getOutput()));
	}

	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d
	this(VideoMode mode, dstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import std.conv;
		sfPtr = sfRenderWindow_createUnicode(mode.width, mode.height, mode.bitsPerPixel, toUTF32z(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErr_getOutput()));
	}

	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		import std.conv;
		sfPtr = sfRenderWindow_createFromHandle(handle, settings.depthBits,settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErr_getOutput()));
	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfRenderWindow_destroy(sfPtr);
	}

	/**
	 * Change the position of the window on screen.
	 * 
	 * This property only works for top-level windows (i.e. it will be ignored for windows created from the handle of a child window/control).
	 */
	@property
	{
		override Vector2i position(Vector2i newPosition)
		{
			sfRenderWindow_setPosition(sfPtr,newPosition.x, newPosition.y);
			return newPosition;
		}
		
		override Vector2i position()
		{
			Vector2i temp;
			sfRenderWindow_getPosition(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}

	/**
	 * The size of the rendering region of the window.
	 */
	@property
	{
		override Vector2u size(Vector2u newSize)
		{
			sfRenderWindow_setSize(sfPtr, newSize.x, newSize.y);
			return newSize;
		}
		override Vector2u size()
		{
			Vector2u temp;
			sfRenderWindow_getSize(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}

	/**
	 * Change the current active view.
	 * 
	 * The view is like a 2D camera, it controls which part of the 2D scene is visible, and how it is viewed in the render-target. The new view will affect everything that is drawn, until another view is set. 
	 * 
	 * The render target keeps its own copy of the view object, so it is not necessary to keep the original one alive after calling this function. To restore the original view of the target, you can pass the result of getDefaultView() to this function.
	 */
	@property
	{
		const(View) view(const(View) newView)
		{
			sfRenderWindow_setView(sfPtr, newView.sfPtr);
			return newView;
		}
		const(View) view() const
		{
			return new View(sfRenderWindow_getView(sfPtr));
		}
	}

	/**
	 * Get the default view of the render target.
	 * 
	 * The default view has the initial size of the render target, and never changes after the target has been created.
	 * 
	 * Returns: The default view of the render target.
	 */
	View getDefaultView() const // note: if refactored, change documentation of view property above
	{
		return new View(sfRenderWindow_getDefaultView(sfPtr));
	}

	/**
	 * Get the settings of the OpenGL context of the window.
	 * 
	 * Note that these settings may be different from what was passed to the constructor or the create() function, if one or more settings were not supported. In this case, SFML chose the closest match.
	 * 
	 * Returns: Structure containing the OpenGL context settings
	 */
	override ContextSettings getSettings() const
	{
		ContextSettings temp;
		sfRenderWindow_getSettings(sfPtr,&temp.depthBits, &temp.stencilBits, &temp.antialiasingLevel, &temp.majorVersion, &temp.minorVersion);
		return temp;
	}

	//this is a duplicate with the size property. Need to look into that.(Inherited from RenderTarget)
	/**
	 * Return the size of the rendering region of the target.
	 * 
	 * Returns: Size in pixels
	 */
	Vector2u getSize() const
	{
		Vector2u temp;
		
		sfRenderWindow_getSize(sfPtr, &temp.x, &temp.y);
		
		return temp;
	}

	/**
	 * Get the OS-specific handle of the window.
	 * 
	 * The type of the returned handle is WindowHandle, which is a typedef to the handle type defined by the OS. You shouldn't need to use this function, unless you have very specific stuff to implement that SFML doesn't support, or implement a temporary workaround until a bug is fixed.
	 * 
	 * Returns: System handle of the window
	 */
	override WindowHandle getSystemHandle() const
	{
		return sfRenderWindow_getSystemHandle(sfPtr);
	}

	/**
	 * Get the viewport of a view, applied to this render target.
	 * 
	 * The viewport is defined in the view as a ratio, this function simply applies this ratio to the current dimensions of the render target to calculate the pixels rectangle that the viewport actually covers in the target.
	 * 
	 * Params:
	 * 		view	= The view for which we want to compute the viewport
	 * 
	 * Returns: Viewport rectangle, expressed in pixels
	 */
	IntRect getViewport(const(View) view) const
	{
		IntRect temp;
		
		sfRenderWindow_getViewport(sfPtr, view.sfPtr, &temp.left, &temp.top, &temp.width, &temp.height);
		
		return temp;
	}

	/**
	 * Get the viewport of a view, applied to this render target.
	 * 
	 * A window is active only on the current thread, if you want to make it active on another thread you have to deactivate it on the previous thread first if it was active. Only one window can be active on a thread at a time, thus the window previously active (if any) automatically gets deactivated.
	 * 
	 * Params:
	 * 		active	= True to activate, false to deactivate
	 * 
	 * Returns: True if operation was successful, false otherwise
	 */
	override bool setActive(bool active)
	{
		import std.conv;
		bool toReturn = sfRenderWindow_setActive(sfPtr, active);
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}

	/**
	 * Limit the framerate to a maximum fixed frequency.
	 * 
	 * If a limit is set, the window will use a small delay after each call to display() to ensure that the current frame lasted long enough to match the framerate limit.
	 * 
	 * SFML will try to match the given limit as much as it can, but since it internally uses sf::sleep, whose precision depends on the underlying OS, the results may be a little unprecise as well (for example, you can get 65 FPS when requesting 60).
	 * 
	 * Params:
	 * 		limit	= Framerate limit, in frames per seconds (use 0 to disable limit)
	 */
	override void setFramerateLimit(uint limit)
	{
		sfRenderWindow_setFramerateLimit(sfPtr, limit);
	}

	/**
	 * Change the window's icon.
	 * 
	 * pixels must be an array of width x height pixels in 32-bits RGBA format.
	 * 
	 * The OS default icon is used by default.
	 * 
	 * Params:
	 * 		width	= Icon's width, in pixels
	 * 		height	= Icon's height, in pixels
	 * 		pixels	= Icon pixel array to load from
	 */
	override void setIcon(uint width, uint height, const(ubyte[]) pixels)
	{
		sfRenderWindow_setIcon(sfPtr,width, height, pixels.ptr);
	}

	/**
	 * Change the joystick threshold.
	 * 
	 * The joystick threshold is the value below which no JoystickMoved event will be generated.
	 * 
	 * The threshold value is 0.1 by default.
	 * 
	 * Params:
	 * 		threshold	= New threshold, in the range [0, 100]
	 */
	override void setJoystickThreshhold(float threshhold)
	{
		sfRenderWindow_setJoystickThreshold(sfPtr, threshhold);
	}

	/**
	 * Enable or disable automatic key-repeat.
	 * 
	 * If key repeat is enabled, you will receive repeated KeyPressed events while keeping a key pressed. If it is disabled, you will only get a single event when the key is pressed.
	 * 
	 * Key repeat is enabled by default.
	 * 
	 * Params:
	 * 		enabled	= True to enable, false to disable
	 */
	override void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfRenderWindow_setKeyRepeatEnabled(sfPtr,true):sfRenderWindow_setKeyRepeatEnabled(sfPtr,false);
	}

	/**
	 * Show or hide the mouse cursor.
	 * 
	 * The mouse cursor is visible by default.
	 * 
	 * Params:
	 * 		enabled	= True show the mouse cursor, false to hide it
	 */
	override void setMouseCursorVisible(bool visible)
	{
		visible ? sfRenderWindow_setMouseCursorVisible(sfPtr,true): sfRenderWindow_setMouseCursorVisible(sfPtr,false);
	}

	/**
	 * Change the title of the window
	 * 
	 * Params:
	 * 		title	= New title
	 */
	override void setTitle(string newTitle)
	{
		import std.string;
		sfRenderWindow_setTitle(sfPtr, toStringz(newTitle));
	}
	
	/**
	 * Change the title of the window
	 * 
	 * Params:
	 * 		title	= New title
	 */
	override void setTitle(dstring newTitle)
	{
		sfRenderWindow_setUnicodeTitle(sfPtr, toUTF32z(newTitle));
	}

	/**
	 * Enable or disable vertical synchronization.
	 * 
	 * Activating vertical synchronization will limit the number of frames displayed to the refresh rate of the monitor. This can avoid some visual artifacts, and limit the framerate to a good value (but not constant across different computers).
	 * 
	 * Vertical synchronization is disabled by default.
	 * 
	 * Params:
	 * 		enabled	= True to enable v-sync, false to deactivate it
	 */
	override void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfRenderWindow_setVerticalSyncEnabled(sfPtr, true): sfRenderWindow_setVerticalSyncEnabled(sfPtr, false);
	}

	/**
	 * Show or hide the window.
	 * 
	 * The window is shown by default.
	 * 
	 * Params:
	 * 		visible	= True to show the window, false to hide it
	 */
	override void setVisible(bool visible)
	{
		sfRenderWindow_setVisible(sfPtr,visible);
	}

	/**
	 * Clear the entire target with a single color.
	 * 
	 * This function is usually called once every frame, to clear the previous contents of the target.
	 * 
	 * Params:
	 * 		color	= Fill color to use to clear the render target
	 */
	void clear(Color color = Color.Black)
	{
		sfRenderWindow_clear(sfPtr, color.r,color.g, color.b, color.a);
	}

	/**
	 * Close the window and destroy all the attached resources.
	 * 
	 * After calling this function, the Window instance remains valid and you can call create() to recreate the window. All other functions such as pollEvent() or display() will still work (i.e. you don't have to test isOpen() every time), and will have no effect on closed windows.
	 */
	override void close()
	{
		sfRenderWindow_close(sfPtr);
	}

	/**
	 * Display on screen what has been rendered to the window so far.
	 * 
	 * This function is typically called after all OpenGL rendering has been done for the current frame, in order to show it on screen.
	 */
	override void display()
	{
		sfRenderWindow_display(sfPtr);
	}

	/**
	 * Draw a drawable object to the render target.
	 * 
	 * Params:
	 * 		drawable	= Object to draw
	 * 		states		= Render states to use for drawing
	 */
	void draw(Drawable drawable, RenderStates states = RenderStates.Default)
	{
		//Confirms that even a blank render states struct won't break anything during drawing
		if(states.texture is null)
		{
			states.texture = RenderStates.emptyTexture;
		}
		if(states.shader is null)
		{
			states.shader = RenderStates.emptyShader;
		}
		
		drawable.draw(this,states);
	}

	/**
	 * Draw primitives defined by an array of vertices.
	 * 
	 * Params:
	 * 		vertices	= Array of vertices to draw
	 * 		type		= Type of primitives to draw
	 * 		states		= Render states to use for drawing
	 */
	void draw(const(Vertex)[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default)
	{
		import std.algorithm;
		//Confirms that even a blank render states struct won't break anything during drawing
		if(states.texture is null)
		{
			states.texture = RenderStates.emptyTexture;
		}
		if(states.shader is null)
		{
			states.shader = RenderStates.emptyShader;
		}
		
		sfRenderWindow_drawPrimitives(sfPtr, vertices.ptr, cast(uint)min(uint.max, vertices.length), type,states.blendMode, states.transform.m_matrix.ptr,states.texture.sfPtr,states.shader.sfPtr);
	}

	/**
	 * Tell whether or not the window is open.
	 * 
	 * This function returns whether or not the window exists. Note that a hidden window (setVisible(false)) is open (therefore this function would return true).
	 * 
	 * Returns: True if the window is open, false if it has been closed
	 */
	override bool isOpen()
	{
		return (sfRenderWindow_isOpen(sfPtr));
	}

	/**
	 * Convert a point fom target coordinates to world coordinates, using the current view.
	 * 
	 * This function is an overload of the mapPixelToCoords function that implicitely uses the current view.
	 * 
	 * Params:
	 * 		point	= Pixel to convert
	 * 
	 * Returns: The converted point, in "world" coordinates.
	 */
	Vector2f mapPixelToCoords(Vector2i point) const
	{
		Vector2f temp;
		
		sfRenderWindow_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y,null);
		
		return temp;
	}

	/**
	 * Convert a point from target coordinates to world coordinates.
	 * 
	 * This function finds the 2D position that matches the given pixel of the render-target. In other words, it does the inverse of what the graphics card does, to find the initial position of a rendered pixel.
	 * 
	 * Initially, both coordinate systems (world units and target pixels) match perfectly. But if you define a custom view or resize your render-target, this assertion is not true anymore, ie. a point located at (10, 50) in your render-target may map to the point (150, 75) in your 2D world – if the view is translated by (140, 25).
	 * 
	 * For render-windows, this function is typically used to find which point (or object) is located below the mouse cursor.
	 * 
	 * This version uses a custom view for calculations, see the other overload of the function if you want to use the current view of the render-target.
	 * 
	 * Params:
	 * 		point	= Pixel to convert
	 * 		view	= The view to use for converting the point
	 * 
	 * Returns: The converted point, in "world" coordinates.
	 */
	Vector2f mapPixelToCoords(Vector2i point, const(View) view) const
	{
		Vector2f temp;
		
		sfRenderWindow_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y,view.sfPtr);
		
		return temp;
	}

	/**
	 * Convert a point from target coordinates to world coordinates, using the current view.
	 * 
	 * This function is an overload of the mapPixelToCoords function that implicitely uses the current view.
	 * 
	 * Params:
	 * 		point	= Point to convert
	 * 
	 * The converted point, in "world" coordinates
	 */
	Vector2i mapCoordsToPixel(Vector2f point) const
	{
		Vector2i temp;
		
		sfRenderWindow_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,null);
		
		return temp;
	}

	/**
	 * Convert a point from world coordinates to target coordinates.
	 * 
	 * This function finds the pixel of the render-target that matches the given 2D point. In other words, it goes through the same process as the graphics card, to compute the final position of a rendered point.
	 * 
	 * Initially, both coordinate systems (world units and target pixels) match perfectly. But if you define a custom view or resize your render-target, this assertion is not true anymore, ie. a point located at (150, 75) in your 2D world may map to the pixel (10, 50) of your render-target – if the view is translated by (140, 25).
	 * 
	 * This version uses a custom view for calculations, see the other overload of the function if you want to use the current view of the render-target.
	 * 
	 * Params:
	 * 		point	= Point to convert
	 * 		view	= The view to use for converting the point
	 * 
	 * Returns: The converted point, in target coordinates (pixels)
	 */
	Vector2i mapCoordsToPixel(Vector2f point, const(View) view) const
	{
		Vector2i temp;
		
		sfRenderWindow_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,view.sfPtr);
		
		return temp;
	}

	/**
	 * Restore the previously saved OpenGL render states and matrices.
	 * 
	 * See the description of pushGLStates to get a detailed description of these functions.
	 */
	void popGLStates()
	{
		sfRenderWindow_popGLStates(sfPtr);
	}

	/**
	 * Save the current OpenGL render states and matrices.
	 * 
	 * This function can be used when you mix SFML drawing and direct OpenGL rendering. Combined with PopGLStates, it ensures that:
	 * - SFML's internal states are not messed up by your OpenGL code
	 * - your OpenGL states are not modified by a call to an SFML function
	 * 
	 * More specifically, it must be used around the code that calls Draw functions.
	 * 
	 * Note that this function is quite expensive: it saves all the possible OpenGL states and matrices, even the ones you don't care about. Therefore it should be used wisely. It is provided for convenience, but the best results will be achieved if you handle OpenGL states yourself (because you know which states have really changed, and need to be saved and restored). Take a look at the ResetGLStates function if you do so.
	 */
	void pushGLStates()
	{
		import std.conv;
		sfRenderWindow_pushGLStates(sfPtr);
		err.write(text(sfErr_getOutput()));
	}

	/**
	 * Reset the internal OpenGL states so that the target is ready for drawing.
	 * 
	 * This function can be used when you mix SFML drawing and direct OpenGL rendering, if you choose not to use pushGLStates/popGLStates. It makes sure that all OpenGL states needed by SFML are set, so that subsequent draw() calls will work as expected.
	 */
	void resetGLStates()
	{
		sfRenderWindow_resetGLStates(sfPtr);
	}

	/**
	 * Pop the event on top of the event queue, if any, and return it.
	 * 
	 * This function is not blocking: if there's no pending event then it will return false and leave event unmodified. Note that more than one event may be present in the event queue, thus you should always call this function in a loop to make sure that you process every pending event.
	 * 
	 * Params:
	 * 		event	= Event to be returned
	 * 
	 * Returns: True if an event was returned, or false if the event queue was empty
	 */
	override bool pollEvent(ref Event event)
	{
		return (sfRenderWindow_pollEvent(sfPtr, &event));
	}

	/**
	 * Wait for an event and return it.
	 * 
	 * This function is blocking: if there's no pending event then it will wait until an event is received. After this function returns (and no error occured), the event object is always valid and filled properly. This function is typically used when you have a thread that is dedicated to events handling: you want to make this thread sleep as long as no new event is received.
	 * 
	 * Params:
	 * 		event	= Event to be returned
	 * 
	 * Returns: False if any error occurred
	 */
	override bool waitEvent(ref Event event)
	{
		return (sfRenderWindow_waitEvent(sfPtr, &event));
	}
	
	//TODO: Consider adding these methods.
	//void onCreate
	//void onResize

	override protected Vector2i getMousePosition()const
	{
		Vector2i temp;
		sfMouse_getPositionRenderWindow(sfPtr, &temp.x, &temp.y);
		return temp;
	}

	//TODO: Fix these names or something.
	override protected void setMousePosition(Vector2i pos) const
	{
		sfMouse_setPositionRenderWindow(pos.x, pos.y, sfPtr);
	}

	//Provides the static windowPointer method a way to get the pointer
	//Window.getWindowPointer is protected, so the static method cannot call it directly
	private void* getWindowPtr(Window window)
	{
		return getWindowPointer(window);
	}

	//let's Texture have a way to get the sfPtr of a regular window.
	package static void* windowPointer(Window window)
	{
		scope RenderWindow temp = new RenderWindow();
		
		return temp.getWindowPtr(window); 
	}

}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;
		import dsfml.graphics.image;
		import dsfml.system.clock;
		import dsfml.graphics.sprite;

		writeln("Unit test for RenderWindow");

		//constructor
		auto window = new RenderWindow(VideoMode(800,600),"Test Window");
		
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
		image.loadFromFile("res/star.png");//replace with something that won't get me in trouble
		
		window.setIcon(image.getSize().x,image.getSize().x,image.getPixelArray());

		auto texture = new Texture();

		texture.loadFromImage(image);

		auto sprite = new Sprite(texture);

		auto clock = new Clock();

		while(window.isOpen())
		{
			Event event;
			if(window.pollEvent(event))
			{
				//no events
			}

			if(clock.getElapsedTime().asSeconds()>1)
			{
				window.close();
			}

			window.clear();
			
			window.draw(sprite);
			
			window.display();

		}


		writeln();
	}
}

alias toUTF32z = std.utf.toUTFz!(const(dchar)*);

package extern(C):

struct sfRenderWindow;

private extern(C):



sfRenderWindow* sfRenderWindow_create(uint width, uint height, uint bitsPerPixel, const char* title, int style, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

//Construct a new render window (with a UTF-32 title)
sfRenderWindow* sfRenderWindow_createUnicode(uint width, uint height, uint bitsPerPixel, const(dchar)* title, int style, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

//Construct a render window from an existing control
sfRenderWindow* sfRenderWindow_createFromHandle(WindowHandle handle, uint depthBits, uint stencilBits, uint antialiasingLevel, uint majorVersion, uint minorVersion);

//Destroy an existing render window
void sfRenderWindow_destroy(sfRenderWindow* renderWindow);

//Close a render window (but doesn't destroy the internal data)
void sfRenderWindow_close(sfRenderWindow* renderWindow);

//Tell whether or not a render window is opened
bool sfRenderWindow_isOpen(const sfRenderWindow* renderWindow);

//Get the creation settings of a render window
void sfRenderWindow_getSettings(const sfRenderWindow* renderWindow, uint* depthBits, uint* stencilBits, uint* antialiasingLevel, uint* majorVersion, uint* minorVersion);

//Get the event on top of event queue of a render window, if any, and pop it
bool sfRenderWindow_pollEvent(sfRenderWindow* renderWindow, Event* event);

//Wait for an event and return it
bool sfRenderWindow_waitEvent(sfRenderWindow* renderWindow, Event* event);

//Get the position of a render window
void sfRenderWindow_getPosition(const sfRenderWindow* renderWindow, int* x, int* y);

//Change the position of a render window on screen
void sfRenderWindow_setPosition(sfRenderWindow* renderWindow, int x, int y);

//Get the size of the rendering region of a render window
void sfRenderWindow_getSize(const sfRenderWindow* renderWindow, uint* width, uint* height);

//Change the size of the rendering region of a render window
void sfRenderWindow_setSize(sfRenderWindow* renderWindow, int width, int height);

//Change the title of a render window
void sfRenderWindow_setTitle(sfRenderWindow* renderWindow, const char* title);

//Change the title of a render window (with a UTF-32 string)
void sfRenderWindow_setUnicodeTitle(sfRenderWindow* renderWindow, const(dchar)* title);

//Change a render window's icon
void sfRenderWindow_setIcon(sfRenderWindow* renderWindow, uint width, uint height, const ubyte* pixels);

//Show or hide a render window
void sfRenderWindow_setVisible(sfRenderWindow* renderWindow, bool visible);

//Show or hide the mouse cursor on a render window
void sfRenderWindow_setMouseCursorVisible(sfRenderWindow* renderWindow, bool show);

//Enable / disable vertical synchronization on a render window
void sfRenderWindow_setVerticalSyncEnabled(sfRenderWindow* renderWindow, bool enabled);

//Enable or disable automatic key-repeat for keydown events
void sfRenderWindow_setKeyRepeatEnabled(sfRenderWindow* renderWindow, bool enabled);

//Activate or deactivate a render window as the current target for rendering
bool sfRenderWindow_setActive(sfRenderWindow* renderWindow, bool active);

//Display a render window on screen
void sfRenderWindow_display(sfRenderWindow* renderWindow);

//Limit the framerate to a maximum fixed frequency for a render window
void sfRenderWindow_setFramerateLimit(sfRenderWindow* renderWindow, uint limit);

//Change the joystick threshold, ie. the value below which no move event will be generated
void sfRenderWindow_setJoystickThreshold(sfRenderWindow* renderWindow, float threshold);

//Retrieve the OS-specific handle of a render window
WindowHandle sfRenderWindow_getSystemHandle(const sfRenderWindow* renderWindow);

//Clear a render window with the given color
void sfRenderWindow_clear(sfRenderWindow* renderWindow, ubyte r, ubyte g, ubyte b, ubyte a);

//Change the current active view of a render window
void sfRenderWindow_setView(sfRenderWindow* renderWindow, const sfView* view);

//Get the current active view of a render window
sfView* sfRenderWindow_getView(const sfRenderWindow* renderWindow);

//Get the default view of a render window
sfView* sfRenderWindow_getDefaultView(const sfRenderWindow* renderWindow);

//Get the viewport of a view applied to this target
void sfRenderWindow_getViewport(const sfRenderWindow* renderWindow, const sfView* view, int* left, int* top, int* width, int* height);

//Convert a point from window coordinates to world coordinates
void sfRenderWindow_mapPixelToCoords(const sfRenderWindow* renderWindow, int xIn, int yIn, float* xOut, float* yOut, const sfView* targetView);

//Convert a point from world coordinates to window coordinates
void sfRenderWindow_mapCoordsToPixel(const sfRenderWindow* renderWindow, float xIn, float yIn, int* xOut, int* yOut, const sfView* targetView);

//Draw a drawable object to the render-target
//void sfRenderWindow_drawText(sfRenderWindow* renderWindow, const sfText* object, int blendMode,const float* transform, const sfTexture* texture, const sfShader* shader);


//Draw primitives defined by an array of vertices to a render window
void sfRenderWindow_drawPrimitives(sfRenderWindow* renderWindow,const (void)* vertices, uint vertexCount, int type, int blendMode,const(float)* transform, const(sfTexture)* texture, const(sfShader)* shader);

//Save the current OpenGL render states and matrices
void sfRenderWindow_pushGLStates(sfRenderWindow* renderWindow);

//Restore the previously saved OpenGL render states and matrices
void sfRenderWindow_popGLStates(sfRenderWindow* renderWindow);

//Reset the internal OpenGL states so that the target is ready for drawing
void sfRenderWindow_resetGLStates(sfRenderWindow* renderWindow);

//Copy the current contents of a render window to an image
sfImage* sfRenderWindow_capture(const sfRenderWindow* renderWindow);

//Get the current position of the mouse relatively to a render-window
void sfMouse_getPositionRenderWindow(const sfRenderWindow* relativeTo, int* x, int* y);

//Set the current position of the mouse relatively to a render-window
void sfMouse_setPositionRenderWindow(int x, int y, const sfRenderWindow* relativeTo);

const(char)* sfErr_getOutput();
