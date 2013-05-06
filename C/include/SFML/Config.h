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

#ifndef SFML_CONFIG_H
#define SFML_CONFIG_H

//Check to make sure the compiler is not the MS compiler, which does not
//have a version of stdint.h but instead defines its own fixed sized types.
#if defined(_MSC_VER)
//do nothing
#else
    #include <stdint.h>
#endif

////////////////////////////////////////////////////////////
// Identify the operating system
////////////////////////////////////////////////////////////
#if defined(_WIN32) || defined(__WIN32__)

    // Windows
    #define DSFML_SYSTEM_WINDOWS

#elif defined(linux) || defined(__linux)

    // Linux
    #define DSFML_SYSTEM_LINUX

#elif defined(__APPLE__) || defined(MACOSX) || defined(macintosh) || defined(Macintosh)

    // MacOS
    #define DSFML_SYSTEM_MACOS

#elif defined(__FreeBSD__) || defined(__FreeBSD_kernel__)

    // FreeBSD
    #define DSFML_SYSTEM_FREEBSD

#else

    // Unsupported system
    #error This operating system is not supported by SFML library

#endif


////////////////////////////////////////////////////////////
// Define helpers to create portable import / export macros for each module
////////////////////////////////////////////////////////////
#if defined(DSFML_SYSTEM_WINDOWS)

    // Windows compilers need specific (and different) keywords for export and import
    #define DSFML_API_EXPORT extern "C" __declspec(dllexport)

    // For Visual C++ compilers, we also need to turn off this annoying C4251 warning
    #ifdef _MSC_VER

        #pragma warning(disable : 4251)

    #endif

#else // Linux, FreeBSD, Mac OS X

    #if __GNUC__ >= 4

        // GCC 4 has special keywords for showing/hidding symbols,
        // the same keyword is used for both importing and exporting
        #define DSFML_API_EXPORT extern "C" __attribute__ ((__visibility__ ("default")))

    #else

        // GCC < 4 has no mechanism to explicitely hide symbols, everything's exported
        #define DSFML_API_EXPORT extern "C"

    #endif

#endif


////////////////////////////////////////////////////////////
// Define a boolean that is compatible with D
////////////////////////////////////////////////////////////
#if defined(_MSC_VER)
    typedef unsigned __int8 DBool;
#else
    typedef uint8_t DBool;
#endif
#define DFalse 0
#define DTrue  1


////////////////////////////////////////////////////////////
// Define portable fixed-size types
////////////////////////////////////////////////////////////

// D requires everything to be a fixed size regardless of compiler
// and system. This section creates types that are guarenteed to be
// compatible with D's types.


// 8 bits integer types
#if defined(_MSC_VER)
    typedef signed   __int8 DByte;
    typedef unsigned __int8 DUbyte;
#else
    typedef int8_t  DByte;
    typedef uint8_t DUbyte;
#endif


// 16 bits integer types
#if defined(_MSC_VER)
    typedef signed   __int16 DShort;
    typedef unsigned __int16 DUshort;
#else
    typedef int16_t  DShort;
    typedef uint16_t DUshort;
#endif

// 32 bits integer types
#if defined(_MSC_VER)
    typedef signed   __int32 DInt;
    typedef unsigned __int32 DUint;
#else
    typedef int8_t  DInt;
    typedef uint8_t DUint;
#endif

// 64 bits integer types
#if defined(_MSC_VER)
    typedef signed   __int64 DLong;
    typedef unsigned __int64 DUlong;
#else
    typedef int64_t DLong;
    typedef uint64_t DUlong;
#endif

// 32 Bit wide character(dchar)
#if defined(_MSC_VER)
    typedef unsigned __int32 DChar;
#else
    typedef uint32_t DChar;
#endif




#endif // SFML_CONFIG_H
