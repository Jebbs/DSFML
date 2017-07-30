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


***All code is based on Laurent Gomila's SFML library.***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML
*/

#ifndef DFML_NETWORK_EXPORT_H
#define DFML_NETWORK_EXPORT_H

// Headers
#include <DSFMLC/Config.h>

//If we define DSFML_NETWORK_EXPORTS
#if defined(DSFML_NETWORK_EXPORTS)
	//We need to make sure the SFML_NETWORK_EXPORTS is defined as well
	//#define SFML_NETWORK_EXPORTS
#endif

//Then we define out D export. Will work for shared and static builds (since for static SFML_API_EXPORT is just empty)
#define DSFML_NETWORK_API extern "C" SFML_API_EXPORT





#endif // DFML_NETWORK_EXPORT_H
