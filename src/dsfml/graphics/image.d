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
module dsfml.graphics.image;

import dsfml.system.vector2;

import dsfml.graphics.color;
import dsfml.system.inputstream;

import dsfml.graphics.rect;

debug import std.stdio;

import std.string;

class Image
{
	
	package sfImage* sfPtr;
	
	this()
	{
		//Creates a null Image
	}
	
	package this(sfImage* image)
	{
		sfPtr = image;
	}
	
	~this()
	{
		debug writeln("Destroying Image");
		sfImage_destroy(sfPtr);
	}
	
	bool create(uint width, uint height, Color color)
	{
		sfPtr = sfImage_createFromColor(width, height,color.r, color.b, color.g, color.a);
		return (sfPtr == null)?false:true;
	}
	
	
	bool create(uint width, uint height, const ref ubyte[] pixels)
	{
		sfPtr = sfImage_createFromPixels(width, height,pixels.ptr);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromFile(string fileName)
	{
		sfPtr = sfImage_createFromFile(toStringz(fileName));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromMemory(const(void)* data, uint sizeInBytes)
	{
		sfPtr = sfImage_createFromMemory(data, sizeInBytes);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(InputStream stream)
	{
		sfPtr = sfImage_createFromStream(&stream);
		return (sfPtr == null)?false:true;
	}
	
	
	
	Image dup() const
	{
		return new Image(sfImage_copy(sfPtr));
	}
	
	bool saveToFile(string fileName)
	{
		return sfImage_saveToFile(sfPtr, fileName.ptr);//? true:false;
	}
	
	Vector2u getSize()
	{
		Vector2u temp;
		sfImage_getSize(sfPtr,&temp.x, &temp.y);
		return temp;
	}
	
	void createMaskFromColor(Color maskColor, ubyte alpha = 0)
	{
		sfImage_createMaskFromColor(sfPtr,maskColor.r,maskColor.b, maskColor.g, maskColor.a, alpha);
	}
	
	
	
	void setPixel(uint x, uint y, Color color)
	{
		sfImage_setPixel(sfPtr, x,y,color.r, color.b,color.g, color.a);
	}
	
	Color getPixel(uint x, uint y)
	{ 
		Color temp;
		sfImage_getPixel(sfPtr, x,y, &temp.r, &temp.b, &temp.g, &temp.a);
		return temp;
	}
	
	
	const(ubyte)[] getPixelArray()
	{
		Vector2u size = getSize();
		int length = size.x * size.y * 4;
		return sfImage_getPixelsPtr(sfPtr)[0..length];
	}
	
	void flipHorizontally()
	{
		sfImage_flipHorizontally(sfPtr);
	}
	
	void flipVertically()
	{
		sfImage_flipVertically(sfPtr);
	}
	
	void copyImage(const ref Image source, uint destX, uint destY, IntRect sourceRect = IntRect(0,0,0,0), bool applyAlpha = false)
	{
		sfImage_copyImage(sfPtr, source.sfPtr, destX, destY,sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height, applyAlpha);//:sfImage_copyImage(sfPtr, source.sfPtr, destX, destY, temp, sfFalse);
		
	}

}



package extern(C) struct sfImage;

private extern(C):



sfImage* sfImage_create(uint width, uint height);


/// \brief Create an image and fill it with a unique color
sfImage* sfImage_createFromColor(uint width, uint height, ubyte r, ubyte b, ubyte g, ubyte a);


/// \brief Create an image from an array of pixels
sfImage* sfImage_createFromPixels(uint width, uint height, const ubyte* pixels);


/// \brief Create an image from a file on disk
sfImage* sfImage_createFromFile(const char* filename);


/// \brief Create an image from a file in memory
sfImage* sfImage_createFromMemory(const void* data, size_t size);


/// \brief Create an image from a custom stream
sfImage* sfImage_createFromStream(void* stream);


/// \brief Copy an existing image
sfImage* sfImage_copy(const sfImage* image);


/// \brief Destroy an existing image
void sfImage_destroy(sfImage* image);


/// \brief Save an image to a file on disk
bool sfImage_saveToFile(const sfImage* image, const char* filename);


/// \brief Return the size of an image
void sfImage_getSize(const sfImage* image, uint* width, uint* height);


/// \brief Create a transparency mask from a specified color-key
void sfImage_createMaskFromColor(sfImage* image, ubyte r, ubyte b, ubyte g, ubyte a, ubyte alpha);


/// \brief Copy pixels from an image onto another
void sfImage_copyImage(sfImage* image, const(sfImage)* source, uint destX, uint destY, int sourceRectTop, int sourceRectLeft, int sourceRectWidth, int sourceRectHeight, bool applyAlpha);


/// \brief Change the color of a pixel in an image
void sfImage_setPixel(sfImage* image, uint x, uint y, ubyte r, ubyte b, ubyte g, ubyte a);


/// \brief Get the color of a pixel in an image
void sfImage_getPixel(const sfImage* image, uint x, uint y, ubyte* r, ubyte* b, ubyte* g, ubyte* a);


/// \brief Get a read-only pointer to the array of pixels of an image
const ubyte* sfImage_getPixelsPtr(const sfImage* image);


/// \brief Flip an image horizontally (left <-> right)
void sfImage_flipHorizontally(sfImage* image);


/// \brief Flip an image vertically (top <-> bottom)
void sfImage_flipVertically(sfImage* image);
