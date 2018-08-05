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
 * Define a low-level window handle type, specific to each platform.
 *
 * $(TABLE
 * $(TR $(TH Platform) $(TH Type))
 * $(TR $(TD Windows) $(TD `HWND`))
 * $(TR $(TD Linux/FreeBSD) $(TD `Window`))
 * $(TR $(TD Mac OS X)
 * $(TD either `NSWindow*` or `NSView*`, disguised as `void*`)))
 * $(LF)
 *
 * $(PARA $(B Mac OS X Specification)
 *
 * On Mac OS X, a $(WINDOW_LINK) can be created either from an existing
 * `NSWindow*` or an `NSView*`. When the window is created from a window, DSFML
 * will use its content view as the OpenGL area. `Window.getSystemHandle()` will
 * return the handle that was used to create the window,
 * which is a `NSWindow*` by default.)
 */
module dsfml.window.windowhandle;


//TODO: Make the Windows Window Handle the right type?
//(ie, a HWND from std.c.windows.windows?
version(Windows)
{
	//import std.c.windows.windows;
	struct HWND__;
	alias HWND__* WindowHandle;
}
version(OSX)
{
	import core.stdc.config;
	alias c_ulong WindowHandle;
}
version(linux)
{
	alias void* WindowHandle;
}
