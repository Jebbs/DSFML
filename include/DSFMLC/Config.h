////////////////////////////////////////////////////////////
//
// SFML - Simple and Fast Multimedia Library
// Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it freely,
// subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented;
//    you must not claim that you wrote the original software.
//    If you use this software in a product, an acknowledgment
//    in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such,
//    and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.
//
////////////////////////////////////////////////////////////

#ifndef DSFML_CONFIG_H
#define DSFML_CONFIG_H

#include <SFML/Config.hpp>




////////////////////////////////////////////////////////////
// Define portable fixed-size types
////////////////////////////////////////////////////////////

// Redefine D's types using the same method SFML does.


// 8 bits integer types
typedef signed char  DByte;
typedef unsigned char DUbyte;



// 16 bits integer types
typedef signed short  DShort;
typedef unsigned short DUshort;


// 32 bits integer types
typedef signed int  DInt;
typedef unsigned int DUint;


// 64 bits integer types
#if defined(_MSC_VER)
    typedef signed   __int64 DLong;
    typedef unsigned __int64 DUlong;
#else
    typedef signed long long DLong;
    typedef unsigned long long DUlong;
#endif

// 32 Bit wide character(dchar)
typedef DUint DChar;



////////////////////////////////////////////////////////////
// Define a boolean that is compatible with D
////////////////////////////////////////////////////////////

typedef DUbyte DBool;

#define DFalse 0
#define DTrue  1


#endif // SFML_CONFIG_H
