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

#ifndef DSFML_WINDOWHANDLE_H
#define DSFML_WINDOWHANDLE_H

#include <DSFMLC/Window/Export.h>


////////////////////////////////////////////////////////////
/// Define a low-level window handle type, specific to
/// each platform
////////////////////////////////////////////////////////////
#if defined(SFML_SYSTEM_WINDOWS)

    // Window handle is HWND (HWND__*) on Windows
    struct HWND__;
    typedef struct HWND__* sfWindowHandle;

#elif defined(SFML_SYSTEM_LINUX) || defined(SFML_SYSTEM_FREEBSD)

    // Window handle is Window (unsigned long) on Unix - X11
    typedef unsigned long sfWindowHandle;

#elif defined(SFML_SYSTEM_MACOS)

    // Window handle is NSWindow (void*) on Mac OS X - Cocoa
	typedef void* sfWindowHandle;

#endif

#endif // DSFML_WINDOWHANDLE_H
