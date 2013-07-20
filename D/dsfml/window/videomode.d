module dsfml.window.videomode;

import std.conv;

import std.stdio;

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
	
	

	

	
	static VideoMode getDesktopMode()
	{
		VideoMode temp;
		sfVideoMode_getDesktopMode(&temp.width, &temp.height, &temp.bitsPerPixel);
		return temp;
	}
	
	static VideoMode[] getFullscreenModes()
	{
		static VideoMode[] videoModes;

		if(videoModes.length == 0)
		{
			uint* modes;
			size_t counts;
		
			modes = sfVideoMode_getFullscreenModes(&counts);
		

			videoModes.length = counts/3;


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
	
	bool isValid() const
	{
		return sfVideoMode_isValid(width, height, bitsPerPixel);
	}
	
	//used for debugging
	string toString()
	{
		return "Width: " ~ text(width) ~ " Height: " ~ text(height) ~ " Bits per pixel: " ~ text(bitsPerPixel);
	}
}

private extern(C):



//Video Mode
void sfVideoMode_getDesktopMode(uint* width, uint* height, uint* bitsPerPixel);
uint* sfVideoMode_getFullscreenModes(size_t* Count);
bool sfVideoMode_isValid(uint width, uint height, uint bitsPerPixel);