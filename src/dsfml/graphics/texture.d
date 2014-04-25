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
module dsfml.graphics.texture;


import dsfml.graphics.rect;
import dsfml.graphics.image;
import dsfml.graphics.renderwindow;

import dsfml.window.window;

import dsfml.system.inputstream;
import dsfml.system.vector2;
import dsfml.system.err;

class Texture
{
	package sfTexture* sfPtr;

	this()
	{
		//Creates a empty Texture
	}
	
	package this(sfTexture* texturePointer)
	{
		sfPtr = texturePointer;
	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfTexture_destroy( sfPtr);	
	}
	
	bool loadFromFile(string filename, IntRect area = IntRect() )
	{
		import std.conv;
		import std.string;
		//if the Texture already exists, destroy it first
		if(sfPtr)
		{
			sfTexture_destroy(sfPtr);
		}

		sfPtr = sfTexture_createFromFile(toStringz(filename) ,area.left, area.top,area.width, area.height);
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromMemory(const(void)* data, size_t sizeInBytes, IntRect area = IntRect())
	{
		import std.conv;
		//if the Texture already exists, destroy it first
		if(sfPtr)
		{
			sfTexture_destroy(sfPtr);
		}

		sfPtr = sfTexture_createFromMemory(data,sizeInBytes,area.left, area.top,area.width, area.height);
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(InputStream stream, IntRect area = IntRect())
	{
		import std.conv;
		//if the Texture already exists, destroy it first
		if(sfPtr)
		{
			sfTexture_destroy(sfPtr);
		}

		sfPtr = sfTexture_createFromStream(new sfmlStream(stream), area.left, area.top,area.width, area.height);
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromImage(Image image, IntRect area = IntRect())
	{
		import std.conv;
		//if the Texture already exists, destroy it first
		if(sfPtr)
		{
			sfTexture_destroy(sfPtr);
		}

		sfPtr = sfTexture_createFromImage(image.sfPtr, area.left, area.top,area.width, area.height);
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr != null);
	}

	Vector2u getSize() const
	{
		Vector2u temp;
		sfTexture_getSize(sfPtr, &temp.x, &temp.y);
		return temp;
	}

	void setSmooth(bool smooth)
	{
		sfTexture_setSmooth(sfPtr, smooth);//:sfTexture_setSmooth(sfPtr, sfFalse);
	}

	void setRepeated(bool repeated)
	{
		sfTexture_setRepeated(sfPtr, repeated);//:sfTexture_setRepeated(sfPtr, sfFalse);
	}

	static void bind(Texture texture)
	{
		(texture is null)?sfTexture_bind(null):sfTexture_bind(texture.sfPtr);
	}

	bool create(uint height, uint width)
	{
		import std.conv;
		//if the Texture already exists, destroy it first
		if(sfPtr)
		{
			sfTexture_destroy(sfPtr);
		}
		
		sfPtr = sfTexture_create(width, height);
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}

	Image copyToImage()
	{
		return new Image(sfTexture_copyToImage(sfPtr));
	}

	@property
	Texture dup() const
	{
		return new Texture(sfTexture_copy(sfPtr));
	}

	bool isRepeated() const
	{
		return (sfTexture_isRepeated(sfPtr));// == sfTrue)?true:false;
	}

	bool isSmooth() const
	{
		return (sfTexture_isSmooth(sfPtr));// == sfTrue)?true:false;
	}

	void updateFromImage(Image image, uint x, uint y)
	{
		sfTexture_updateFromImage(sfPtr, image.sfPtr, x, y);
	}

	void updateFromPixels(const(ubyte)[] pixels, uint width, uint height, uint x, uint y)
	{
		sfTexture_updateFromPixels(sfPtr,pixels.ptr,width, height, x,y);
	}

	//TODO: Get this working via inheritance?(so custom window classes can do it too)
	void updateFromWindow(Window window, uint x, uint y)
	{
		sfTexture_updateFromWindow(sfPtr, RenderWindow.windowPointer(window), x, y);
	}
	//Is this even safe? RenderWindow inherits from Window, so what happens? Is this the bottom used or the top?
	void updateFromWindow(RenderWindow window, uint x, uint y)
	{
		sfTexture_updateFromRenderWindow(sfPtr, window.sfPtr, x, y);
	}
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;
		
		writeln("Unit test for Texture");

		auto texture = new Texture();

		assert(texture.loadFromFile("res/star.png"));

		//do things with the texture

		writeln();
	}
}

private extern(C++) interface sfmlInputStream
{
	long read(void* data, long size);
		
	long seek(long position);
		
	long tell();
		
	long getSize();
}


private class sfmlStream:sfmlInputStream
{
	private InputStream myStream;

	this(InputStream stream)
	{
		myStream = stream;
	}

	extern(C++)long read(void* data, long size)
	{
		return myStream.read(data[0..cast(size_t)size]);
	}

	extern(C++)long seek(long position)
	{
		return myStream.seek(position);
	}
	
	extern(C++)long tell()
	{
		return myStream.tell();
	}
	
	extern(C++)long getSize()
	{
		return myStream.getSize();
	}
}



package extern(C) struct sfTexture;

private extern(C):
//Create a new texture
sfTexture* sfTexture_create(uint width, uint height);

//Create a new texture from a file
sfTexture* sfTexture_createFromFile(const char* filename, int left, int top, int width, int height);

//Create a new texture from a file in memory
sfTexture* sfTexture_createFromMemory(const void* data, size_t sizeInBytes, int left, int top, int width, int height);

//Create a new texture from a custom stream
sfTexture* sfTexture_createFromStream(sfmlInputStream stream, int left, int top, int width, int height);

//Create a new texture from an image
sfTexture* sfTexture_createFromImage(const sfImage* image, int left, int top, int width, int height);

//Copy an existing texture
sfTexture* sfTexture_copy(const sfTexture* texture);

//Destroy an existing texture
void sfTexture_destroy(sfTexture* texture);

//Return the size of the texture
void sfTexture_getSize(const sfTexture* texture, uint* x, uint* y);

//Copy a texture's pixels to an image
sfImage* sfTexture_copyToImage(const sfTexture* texture);

//Update a texture from an array of pixels
void sfTexture_updateFromPixels(sfTexture* texture, const ubyte* pixels, uint width, uint height, uint x, uint y);

//Update a texture from an image
void sfTexture_updateFromImage(sfTexture* texture, const sfImage* image, uint x, uint y);

//Update a texture from the contents of a window
void sfTexture_updateFromWindow(sfTexture* texture, const(void)* window, uint x, uint y);

//Update a texture from the contents of a render-window
void sfTexture_updateFromRenderWindow(sfTexture* texture, const sfRenderWindow* renderWindow, uint x, uint y);

//Enable or disable the smooth filter on a texture
void sfTexture_setSmooth(sfTexture* texture, bool smooth);

//Tell whether the smooth filter is enabled or not for a texture
bool sfTexture_isSmooth(const sfTexture* texture);

//Enable or disable repeating for a texture
void sfTexture_setRepeated(sfTexture* texture, bool repeated);

//Tell whether a texture is repeated or not
bool sfTexture_isRepeated(const sfTexture* texture);

//Bind a texture for rendering
void sfTexture_bind(const sfTexture* texture);

//Get the maximum texture size allowed
uint sfTexture_getMaximumSize();

const(char)* sfErrGraphics_getOutput();
