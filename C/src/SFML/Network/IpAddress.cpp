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

// Headers
#include <SFML/Network/IpAddress.h>
#include <SFML/Network/IpAddress.hpp>
#include <string.h>


namespace
{
    // Helper function for converting a SFML address to an array one
    void fromSFMLAddress(sf::IpAddress address, char* ipAddress)
    {
        strncpy(ipAddress, address.toString().c_str(), 16);
    }

    // Helper function for converting an array address to a SFML one
    sf::IpAddress toSFMLAddress(const char* ipAddress)
    {
        return sf::IpAddress(ipAddress);
    }
}

///Don't forget these in the D code!

/*
////////////////////////////////////////////////////////////
const sfIpAddress sfIpAddress_None = sfIpAddress_fromBytes(0, 0, 0, 0);


////////////////////////////////////////////////////////////
const sfIpAddress sfIpAddress_LocalHost = sfIpAddress_fromBytes(127, 0, 0, 1);


////////////////////////////////////////////////////////////
const sfIpAddress sfIpAddress_Broadcast = sfIpAddress_fromBytes(255, 255, 255, 255);
*/


void sfIpAddress_fromString(const char* address, char* ipAddress)
{
    fromSFMLAddress(sf::IpAddress(address), ipAddress);
}


void sfIpAddress_fromBytes(DUbyte byte0, DUbyte byte1, DUbyte byte2, DUbyte byte3, char* ipAddress)
{
    fromSFMLAddress(sf::IpAddress(byte0, byte1, byte2, byte3), ipAddress);
}


void sfIpAddress_fromInteger(DUint address, char* ipAddress)
{
    fromSFMLAddress(sf::IpAddress(address), ipAddress);
}


DUint sfIpAddress_toInteger(const char* ipAddress)
{
    return toSFMLAddress(ipAddress).toInteger();
}


void sfIpAddress_getLocalAddress(char* ipAddress)
{
     fromSFMLAddress(sf::IpAddress::getLocalAddress(),ipAddress);
}


////////////////////////////////////////////////////////////
void sfIpAddress_getPublicAddress(char* ipAddress, DLong timeout)
{
    fromSFMLAddress(sf::IpAddress::getPublicAddress(sf::microseconds(timeout)), ipAddress);
}
