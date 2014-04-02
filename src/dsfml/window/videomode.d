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
module dsfml.window.videomode;

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

	bool isValid() const
	{
		return sfVideoMode_isValid(width, height, bitsPerPixel);
	}
	
	//used for debugging
	string toString()
	{
		import std.conv: text;
		return "Width: " ~ text(width) ~ " Height: " ~ text(height) ~ " Bits per pixel: " ~ text(bitsPerPixel);
	}

	static VideoMode getDesktopMode()
	{
		VideoMode temp;
		sfVideoMode_getDesktopMode(&temp.width, &temp.height, &temp.bitsPerPixel);
		return temp;
	}
	
	static VideoMode[] getFullscreenModes()
	{
		static VideoMode[] videoModes;//stores all video modes after the first call
		
		//if getFullscreenModes hasn't been called yet
		if(videoModes.length == 0)
		{
			uint* modes;
			size_t counts;
			
			//returns uints instead of structs due to 64 bit bug
			modes = sfVideoMode_getFullscreenModes(&counts);
			
			//calculate real length
			videoModes.length = counts/3;
			
			//populate videoModes
			int videoModeIndex = 0;
			for(uint i = 0; i < counts; i+=3)
			{
				VideoMode temp = VideoMode(modes[i], modes[i+1], modes[i+2]);
				
				videoModes[videoModeIndex] = temp;
				++videoModeIndex;
			}
			
		}
		
		return videoModes;
		
	}
}

unittest
{
	version(DSFML_Unittest_Window)
	{
		import std.stdio;
		
		writeln("Unit test for VideoMode struct");
		
		uint modesCount = VideoMode.getFullscreenModes().length;
		
		writeln("There are ", modesCount, " full screen modes available.");
		writeln("Your current desktop video mode is ",VideoMode.getDesktopMode().toString());
		
		writeln("Confirming all fullscreen modes are valid.");
		foreach(mode; VideoMode.getFullscreenModes())
		{
			assert(mode.isValid());
		}
		writeln("All video modes are valid.");
		
		writeln();
	}
}

private extern(C)
{
	void sfVideoMode_getDesktopMode(uint* width, uint* height, uint* bitsPerPixel);
	uint* sfVideoMode_getFullscreenModes(size_t* Count);
	bool sfVideoMode_isValid(uint width, uint height, uint bitsPerPixel);
}
