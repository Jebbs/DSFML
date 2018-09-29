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

#ifndef DSFML_STRING_H
#define DSFML_STRING_H

#include <DSFMLC/System/Export.h>
#include <stddef.h>

//Convert to utf8
DSFML_SYSTEM_API void utf16to8(const DUshort* inStr, size_t inLen, const DUbyte* outStr, size_t* outLen);
DSFML_SYSTEM_API void utf32to8(const DUint* inStr, size_t inLen, const DUbyte* outStr, size_t* outLen);

//Convert to utf16
DSFML_SYSTEM_API void utf8to16(const DUbyte* inStr, size_t inLen, const DUshort* outStr, size_t* outLen);
DSFML_SYSTEM_API void utf32to16(const DUint* inStr, size_t inLen, const DUshort* outStr, size_t* outLen);

//Convert to utf32
DSFML_SYSTEM_API void utf8to32(const DUbyte* inStr, size_t inLen, const DUint* outStr, size_t* outLen);
DSFML_SYSTEM_API void utf16to32(const DUshort* inStr, size_t inLen, const DUint* outStr, size_t* outLen);

#endif//DSFML_STRING_H
