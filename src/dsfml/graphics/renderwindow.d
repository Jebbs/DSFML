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

import dsfml.window.window;
import dsfml.window.windowhandle;
import dsfml.window.event;
import dsfml.graphics.rendertarget;
import dsfml.graphics.view;

import dsfml.graphics.text;
import dsfml.graphics.texture;
import dsfml.graphics.shader;

import dsfml.graphics.image;

import dsfml.graphics.drawable;
import dsfml.graphics.renderstates;

import dsfml.graphics.vertex;
import dsfml.graphics.primitivetype;

import dsfml.window.videomode;
import dsfml.window.contextsettings;

import dsfml.system.vector2;

import dsfml.graphics.rect;
import dsfml.graphics.color;

import std.algorithm;
import std.string;
import std.utf;

import dsfml.system.err;
import std.conv;

debug import std.stdio;

class RenderWindow:Window,RenderTarget
{
	package sfRenderWindow* sfPtr;

	package this()
	{

	}

	this(VideoMode mode, string title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfRenderWindow_create(mode.width, mode.height, mode.bitsPerPixel, toStringz(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErrGraphics_getOutput()));
	}

	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d
	this(VideoMode mode, dstring title, Style style = Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfRenderWindow_createUnicode(mode.width, mode.height, mode.bitsPerPixel, toUTF32z(title), style, settings.depthBits, settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErrGraphics_getOutput()));
	}

	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfRenderWindow_createFromHandle(handle, settings.depthBits,settings.stencilBits, settings.antialiasingLevel, settings.majorVersion, settings.minorVersion);
		err.write(text(sfErrGraphics_getOutput()));
	}


	~this()
	{
		debug writeln("Destroying RenderWindow");
		sfRenderWindow_destroy(sfPtr);
	}



	override bool pollEvent(ref Event event)
	{
		return (sfRenderWindow_pollEvent(sfPtr, &event));
	}

	override bool waitEvent(ref Event event)
	{
		return (sfRenderWindow_waitEvent(sfPtr, &event));
	}
	
	override void setTitle(string newTitle)
	{
		sfRenderWindow_setTitle(sfPtr, toStringz(newTitle));
	}
	
	override void setTitle(dstring newTitle)
	{
		sfRenderWindow_setUnicodeTitle(sfPtr, toUTF32z(newTitle));
	}
	
	override void close()
	{
		sfRenderWindow_close(sfPtr);
	}
	
	override ContextSettings getSettings() const
	{
		ContextSettings temp;
		sfRenderWindow_getSettings(sfPtr,&temp.depthBits, &temp.stencilBits, &temp.antialiasingLevel, &temp.majorVersion, &temp.minorVersion);
		return temp;
	}
	
	
	@property
	{
		override void position(Vector2i newPosition)
		{
			sfRenderWindow_setPosition(sfPtr,newPosition.x, newPosition.y);
		}
		
		override Vector2i position()
		{
			Vector2i temp;
			sfRenderWindow_getPosition(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}
	
	@property
	{
		override void size(Vector2u newSize)
		{
			sfRenderWindow_setSize(sfPtr, newSize.x, newSize.y);
		}
		override Vector2u size()
		{
			Vector2u temp;
			sfRenderWindow_getSize(sfPtr,&temp.x, &temp.y);
			return temp;
		}
	}
	
	override void setIcon(uint width, uint height, const(ubyte[]) pixels)
	{
		sfRenderWindow_setIcon(sfPtr,width, height, pixels.ptr);
	}
	
	override void setVisible(bool visible)
	{
		sfRenderWindow_setVisible(sfPtr,visible);
	}
	
	override void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfRenderWindow_setVerticalSyncEnabled(sfPtr, true): sfRenderWindow_setVerticalSyncEnabled(sfPtr, false);
	}
	
	override void setMouseCursorVisible(bool visible)
	{
		visible ? sfRenderWindow_setMouseCursorVisible(sfPtr,true): sfRenderWindow_setMouseCursorVisible(sfPtr,false);
	}
	
	override void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfRenderWindow_setKeyRepeatEnabled(sfPtr,true):sfRenderWindow_setKeyRepeatEnabled(sfPtr,false);
	}
	
	override void setFramerateLimit(uint limit)
	{
		sfRenderWindow_setFramerateLimit(sfPtr, limit);
	}
	
	override void setJoystickThreshhold(float threshhold)
	{
		sfRenderWindow_setJoystickThreshold(sfPtr, threshhold);
	}
	
	override WindowHandle getSystemHandle() const
	{
		return sfRenderWindow_getSystemHandle(sfPtr);
	}
	
	//TODO: Consider adding these methods.
	//void onCreate
	//void onResize
	
	override bool isOpen()
	{
		return (sfRenderWindow_isOpen(sfPtr));
	}
	
	override bool setActive(bool active)
	{
		bool toReturn = sfRenderWindow_setActive(sfPtr, active);
		err.write(text(sfErrGraphics_getOutput()));
		return toReturn;
	}
	
	override void display()
	{
		sfRenderWindow_display(sfPtr);
	}

	override protected Vector2i getMousePosition()const
	{
		Vector2i temp;
		sfMouse_getPositionRenderWindow(sfPtr, &temp.x, &temp.y);
		return temp;
	}

	override protected void setMousePosition(Vector2i pos) const
	{
		sfMouse_setPositionRenderWindow(pos.x, pos.y, sfPtr);
	}

	void clear(Color color = Color.Black)
	{
		sfRenderWindow_clear(sfPtr, color.r,color.g, color.b, color.a);
	}

	@property
	{
		void view(const(View) newView)
		{
			sfRenderWindow_setView(sfPtr, newView.sfPtr);
		}
		View view() const
		{
			return new View(sfRenderWindow_getView(sfPtr));
		}
	} 

	const(View) getDefaultView() const
	{
		return new View(sfRenderWindow_getDefaultView(sfPtr));
	}
	
	IntRect getViewport(const(View) view) const
	{
		IntRect temp;

		sfRenderWindow_getViewport(sfPtr, view.sfPtr, &temp.left, &temp.top, &temp.width, &temp.height);

		return temp;
	}
	
	Vector2f mapPixelToCoords(Vector2i point) const
	{
		Vector2f temp;

		sfRenderWindow_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y,null);

		return temp;
	}
	
	Vector2f mapPixelToCoords(Vector2i point, const(View) view) const
	{
		Vector2f temp;
		
		sfRenderWindow_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y,view.sfPtr);
		
		return temp;
	}
	
	Vector2i mapCoordsToPixel(Vector2f point) const
	{
		Vector2i temp;
		
		sfRenderWindow_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,null);
		
		return temp;
	}
	
	Vector2i mapCoordsToPixel(Vector2f point, const(View) view) const
	{
		Vector2i temp;
		
		sfRenderWindow_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,view.sfPtr);
		
		return temp;
	}

	void draw(Drawable drawable, RenderStates states = RenderStates.Default())
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

	void draw(const(Vertex)[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default())
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

		sfRenderWindow_drawPrimitives(sfPtr, vertices.ptr, cast(uint)min(uint.max, vertices.length), type,states.blendMode, states.transform.m_matrix.ptr,states.texture.sfPtr,states.shader.sfPtr);
	}

	Vector2u getSize() const
	{
		Vector2u temp;

		sfRenderWindow_getSize(sfPtr, &temp.x, &temp.y);

		return temp;
	}
	
	void pushGLStates()
	{
		sfRenderWindow_pushGLStates(sfPtr);
		err.write(text(sfErrGraphics_getOutput()));
	}
	
	void popGLStates()
	{
		sfRenderWindow_popGLStates(sfPtr);
	}
	
	void resetGLStates()
	{
		sfRenderWindow_resetGLStates(sfPtr);

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

alias std.utf.toUTFz!(const(dchar)*) toUTF32z;
package extern(C):

struct sfRenderWindow;

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
void sfRenderWindow_drawText(sfRenderWindow* renderWindow, const sfText* object, int blendMode,const float* transform, const sfTexture* texture, const sfShader* shader);


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

const(char)* sfErrGraphics_getOutput();
