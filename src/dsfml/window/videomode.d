/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

/**
 * A video mode is defined by a width and a height (in pixels) and a depth (in
 * bits per pixel). Video modes are used to setup windows ($(WINDOW_LINK)) at
 * creation time.
 *
 * The main usage of video modes is for fullscreen mode: indeed you must use one
 * of the valid video modes allowed by the OS (which are defined by what the
 * monitor and the graphics card support), otherwise your window creation will
 *
 * $(U VideoMode) provides a static function for retrieving the list of all the
 * video modes supported by the system: `getFullscreenModes()`.
 *
 * A custom video mode can also be checked directly for fullscreen compatibility
 * with its `isValid()` function.
 *
 * Additionnally, $(U VideoMode) provides a static function to get the mode
 * currently used by the desktop: `getDesktopMode()`. This allows to build
 * windows with the same size or pixel depth as the current resolution.
 *
 * Example:
 * ---
 * // Display the list of all the video modes available for fullscreen
 * auto modes = VideoMode.getFullscreenModes();
 * for (size_t i = 0; i < modes.length; ++i)
 * {
 *     VideoMode mode = modes[i];
 *     writeln("Mode #", i, ": ",
 * 	           mode.width, "x", mode.height, " - ",
 *             mode.bitsPerPixel, " bpp");
 * }
 *
 * // Create a window with the same pixel depth as the desktop
 * VideoMode desktop = VideoMode.getDesktopMode();
 * window.create(VideoMode(1024, 768, desktop.bitsPerPixel), "DSFML window");
 * ---
 */
module dsfml.window.videomode;

/**
 * VideoMode defines a video mode (width, height, bpp).
 */
struct VideoMode
{
	///Video mode width, in pixels.
	uint width;

	///Video mode height, in pixels.
	uint height;

	///Video mode pixel depth, in bits per pixels.
	uint bitsPerPixel;

	/**
	 * Construct the video mode with its attributes.
	 *
	 * Params:
     * 		modeWidth = Width in pixels
     * 		modeHeight = Height in pixels
     * 		modeBitsPerPixel = Pixel depths in bits per pixel
	 */
	this(uint Width, uint Height, uint bits= 32)
	{
		width = Width;
		height = Height;
		bitsPerPixel = bits;
	}

	/**
	 * Get the current desktop video mode.
	 *
	 * Returns: Current desktop video mode.
	 */
	static VideoMode getDesktopMode()
	{
		VideoMode temp;
		sfVideoMode_getDesktopMode(&temp.width, &temp.height, &temp.bitsPerPixel);
		return temp;
	}

	/**
	 * Retrieve all the video modes supported in fullscreen mode.
	 *
	 * When creating a fullscreen window, the video mode is restricted to be
	 * compatible with what the graphics driver and monitor support. This
	 * function returns the complete list of all video modes that can be used in
	 * fullscreen mode. The returned array is sorted from best to worst, so that
	 * the first element will always give the best mode (higher width, height
	 * and bits-per-pixel).
	 *
	 * Returns: Array containing all the supported fullscreen modes.
	 */
	static VideoMode[] getFullscreenModes()
	{
		//stores all video modes after the first call
		static VideoMode[] videoModes;

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

	/**
	 * Tell whether or not the video mode is valid.
	 *
	 * The validity of video modes is only relevant when using fullscreen
	 * windows; otherwise any video mode can be used with no restriction.
	 *
	 * Returns: true if the video mode is valid for fullscreen mode.
	 */
	bool isValid() const
	{
		return sfVideoMode_isValid(width, height, bitsPerPixel);
	}

	///Returns a string representation of the video mode.
	string toString() const
	{
		import std.conv: text;
		return "Width: " ~ text(width) ~ " Height: " ~ text(height) ~ " Bits per pixel: " ~ text(bitsPerPixel);
	}
}

unittest
{
	version(DSFML_Unittest_Window)
	{
		import std.stdio;

		writeln("Unit test for VideoMode struct");

		size_t modesCount = VideoMode.getFullscreenModes().length;

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
