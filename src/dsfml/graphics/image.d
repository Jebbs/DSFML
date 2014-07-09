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

import dsfml.system.err;

/++
 + Class for loading, manipulating and saving images.
 + 
 + Image is an abstraction to manipulate images as bidimensional arrays of pixels.
 + 
 + The class provides functions to load, read, write and save pixels, as well as many other useful functions.
 + 
 + Image can handle a unique internal representation of pixels, which is RGBA 32 bits. This means that a pixel must be composed of 8 bits red, green, blue and alpha channels – just like a Color. All the functions that return an array of pixels follow this rule, and all parameters that you pass to Image functions (such as loadFromPixels) must use this representation as well.
 + 
 + A Image can be copied, but it is a heavy resource and if possible you should always use [const] references to pass or return them to avoid useless copies.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Image.php#details
 +/
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
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfImage_destroy(sfPtr);
	}

	/**
	 * Create the image and fill it with a unique color.
	 * 
	 * Params:
	 * 		width	= Width of the image
	 * 		height	= Height of the image
	 * 		color	= Fill color
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
	bool create(uint width, uint height, Color color)
	{
		//if the Image already exists, destroy it first
		if(sfPtr)
		{
			sfImage_destroy(sfPtr);
		}

		sfPtr = sfImage_createFromColor(width, height,color.r, color.b, color.g, color.a);
		return (sfPtr != null);
	}
	
	/**
	 * Create the image from an array of pixels.
	 * 
	 * The pixel array is assumed to contain 32-bits RGBA pixels, and have the given width and height. If not, this is an undefined behaviour. If pixels is null, an empty image is created.
	 * 
	 * Params:
	 * 		width	= Width of the image
	 * 		height	= Height of the image
	 * 		pixels	= Array of pixels to copy to the image
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
	bool create(uint width, uint height, const ref ubyte[] pixels)
	{
		//if the Image already exists, destroy it first
		if(sfPtr)
		{
			sfImage_destroy(sfPtr);
		}

		sfPtr = sfImage_createFromPixels(width, height,pixels.ptr);
		return (sfPtr != null);
	}

	/**
	 * Load the image from a file on disk.
	 * 
	 * The supported image formats are bmp, png, tga, jpg, gif, psd, hdr and pic. Some format options are not supported, like progressive jpeg. If this function fails, the image is left unchanged.
	 * 
	 * Params:
	 * 		filename	= Path of the image file to load
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
	bool loadFromFile(string fileName)
	{
		import std.conv;
		import std.string;
		//if the Image already exists, destroy it first
		if(sfPtr)
		{
			sfImage_destroy(sfPtr);
		}

		sfPtr = sfImage_createFromFile(toStringz(fileName));

		err.write(text(sfErr_getOutput()));

		return (sfPtr != null);
	}

	/**
	 * Load the image from a file in memory.
	 * 
	 * The supported image formats are bmp, png, tga, jpg, gif, psd, hdr and pic. Some format options are not supported, like progressive jpeg. If this function fails, the image is left unchanged.
	 * 
	 * Params:
	 * 		data	= Data file in memory to load
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
	bool loadFromMemory(const(void)[] data)
	{
		import std.conv;
		//if the Image already exists, destroy it first
		if(sfPtr)
		{
			sfImage_destroy(sfPtr);
		}

		sfPtr = sfImage_createFromMemory(data.ptr, data.length);
		err.write(text(sfErr_getOutput()));
		return (sfPtr != null);
	}

	/**
	 * Load the image from a custom stream.
	 * 
	 * The supported image formats are bmp, png, tga, jpg, gif, psd, hdr and pic. Some format options are not supported, like progressive jpeg. If this function fails, the image is left unchanged.
	 * 
	 * Params:
	 * 		stream	= Source stream to read from
	 * 
	 * Returns: True if loading succeeded, false if it failed
	 */
	bool loadFromStream(InputStream stream)
	{
		import std.conv;
		//if the Image already exists, destroy it first
		if(sfPtr)
		{
			sfImage_destroy(sfPtr);
		}

		sfPtr = sfImage_createFromStream(new imageStream(stream));
		err.write(text(sfErr_getOutput()));
		return (sfPtr == null)?false:true;
	}

	/**
	 * Get the color of a pixel
	 * 
	 * This function doesn't check the validity of the pixel coordinates; using out-of-range values will result in an undefined behaviour.
	 * 
	 * Params:
	 * 		x	= X coordinate of the pixel to get
	 * 		y	= Y coordinate of the pixel to get
	 * 
	 * Returns: Color of the pixel at coordinates (x, y)
	 */
	Color getPixel(uint x, uint y)
	{ 
		Color temp;
		sfImage_getPixel(sfPtr, x,y, &temp.r, &temp.b, &temp.g, &temp.a);
		return temp;
	}

	/**
	 * Get the read-only array of pixels that make up the image.
	 * 
	 * The returned value points to an array of RGBA pixels made of 8 bits integers components. The size of the array is width * height * 4 (getSize().x * getSize().y * 4). Warning: the returned pointer may become invalid if you modify the image, so you should never store it for too long.
	 * 
	 * Returns: Read-only array of pixels that make up the image.
	 */
	const(ubyte)[] getPixelArray()
	{
		Vector2u size = getSize();
		int length = size.x * size.y * 4;
		
		if(length!=0)
		{
			return sfImage_getPixelsPtr(sfPtr)[0..length];
		}
		else
		{
			err.writeln("Trying to access the pixels of an empty image");
			return [];
		}
	}

	/**
	 * Return the size (width and height) of the image.
	 * 
	 * Returns: Size of the image, in pixels.
	 */
	Vector2u getSize()
	{
		Vector2u temp;
		sfImage_getSize(sfPtr,&temp.x, &temp.y);
		return temp;
	}

	/**
	 * Change the color of a pixel.
	 * 
	 * This function doesn't check the validity of the pixel coordinates, using out-of-range values will result in an undefined behaviour.
	 * 
	 * Params:
	 * 		x		= X coordinate of pixel to change
	 * 		y		= Y coordinate of pixel to change
	 * 		color	= New color of the pixel
	 */
	void setPixel(uint x, uint y, Color color)
	{
		sfImage_setPixel(sfPtr, x,y,color.r, color.b,color.g, color.a);
	}

	/**
	 * Copy pixels from another image onto this one.
	 * 
	 * This function does a slow pixel copy and should not be used intensively. It can be used to prepare a complex static image from several others, but if you need this kind of feature in real-time you'd better use RenderTexture.
	 * 
	 * If sourceRect is empty, the whole image is copied. If applyAlpha is set to true, the transparency of source pixels is applied. If it is false, the pixels are copied unchanged with their alpha value.
	 * 
	 * Params:
	 * 		source		= Source image to copy
	 * 		destX		= X coordinate of the destination position
	 * 		destY		= Y coordinate of the destination position
	 * 		sourceRect	= Sub-rectangle of the source image to copy
	 * 		applyAlpha	= Should the copy take the source transparency into account?
	 */
	void copyImage(const ref Image source, uint destX, uint destY, IntRect sourceRect = IntRect(0,0,0,0), bool applyAlpha = false)
	{
		sfImage_copyImage(sfPtr, source.sfPtr, destX, destY,sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height, applyAlpha);//:sfImage_copyImage(sfPtr, source.sfPtr, destX, destY, temp, sfFalse);
	}

	/**
	 * Create a transparency mask from a specified color-key.
	 * 
	 * This function sets the alpha value of every pixel matching the given color to alpha (0 by default) so that they become transparent.
	 * 
	 * Params:
	 * 		color	= Color to make transparent
	 * 		alpha	= Alpha value to assign to transparent pixels
	 */
	void createMaskFromColor(Color maskColor, ubyte alpha = 0)
	{
		sfImage_createMaskFromColor(sfPtr,maskColor.r,maskColor.b, maskColor.g, maskColor.a, alpha);
	}
	
	@property
	Image dup() const
	{
		return new Image(sfImage_copy(sfPtr));
	}

	/// Flip the image horizontally (left <-> right)
	void flipHorizontally()
	{
		sfImage_flipHorizontally(sfPtr);
	}

	/// Flip the image vertically (top <-> bottom)
	void flipVertically()
	{
		sfImage_flipVertically(sfPtr);
	}

	/**
	 * Save the image to a file on disk.
	 * 
	 * The format of the image is automatically deduced from the extension. The supported image formats are bmp, png, tga and jpg. The destination file is overwritten if it already exists. This function fails if the image is empty.
	 * 
	 * Params:
	 * 		filename	= Path of the file to save
	 * 
	 * Returns: True if saving was successful
	 */
	bool saveToFile(string fileName)
	{
		import std.conv;
		bool toReturn = sfImage_saveToFile(sfPtr, fileName.ptr);
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;

		writeln("Unit test for Image");

		auto image = new Image();

		assert(image.create(100,100,Color.Blue));

		assert(image.getPixel(0,0) == Color.Blue);

		image.setPixel(0,0,Color.Green);

		assert(image.getPixel(0,0) == Color.Green);


		image.flipHorizontally();

		assert(image.getPixel(99,0) == Color.Green);

		image.flipVertically();

		assert(image.getPixel(99,99) == Color.Green);

		assert(image.getSize() == Vector2u(100,100));

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


private class imageStream:sfmlInputStream
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
sfImage* sfImage_createFromStream(sfmlInputStream stream);

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
const(ubyte)* sfImage_getPixelsPtr(const sfImage* image);

/// \brief Flip an image horizontally (left <-> right)
void sfImage_flipHorizontally(sfImage* image);

/// \brief Flip an image vertically (top <-> bottom)
void sfImage_flipVertically(sfImage* image);

const(char)* sfErr_getOutput();
