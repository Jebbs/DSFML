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

#ifndef DSFML_IPADDRESS_H
#define DSFML_IPADDRESS_H


// Headers
#include <SFML/Network/Export.h>



//Note: These functions rely on passing an existing array for the ipAddress.
//It will not allocate data into a null pointer for functions that return a new IP Address


//Create an address from a string
DSFML_NETWORK_API void sfIpAddress_fromString(const char* address, char* ipAddress);


//Create an address from 4 bytes
DSFML_NETWORK_API void sfIpAddress_fromBytes(DUbyte byte0, DUbyte byte1, DUbyte byte2, DUbyte byte3, char* ipAddress);


//Construct an address from a 32-bits integer
DSFML_NETWORK_API void sfIpAddress_fromInteger(DUint address, char* ipAddress);


//Get an integer representation of the address
DSFML_NETWORK_API DUint sfIpAddress_toInteger(const char* ipAddress);


//Get the computer's local address
DSFML_NETWORK_API void sfIpAddress_getLocalAddress(char* ipAddress);


//Get the computer's public address
DSFML_NETWORK_API void sfIpAddress_getPublicAddress(char* ipAddress, DLong timeout);


#endif // DSFML_IPADDRESS_H
