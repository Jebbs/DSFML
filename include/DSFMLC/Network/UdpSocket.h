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

#ifndef DSFML_UDPSOCKET_H
#define DSFML_UDPSOCKET_H

// Headers
#include <DSFMLC/Network/Export.h>
#include <DSFMLC/Network/IpAddress.h>
#include <DSFMLC/Network/Types.h>
#include <stddef.h>


//Destroy internal stored data for receiving
DSFML_NETWORK_API void sfUdpSocket_destroyInternalData(void);


//Create a new UDP socket
DSFML_NETWORK_API sfUdpSocket* sfUdpSocket_create(void);


//Destroy a UDP socket
DSFML_NETWORK_API void sfUdpSocket_destroy(sfUdpSocket* socket);


//Set the blocking state of a UDP listener
DSFML_NETWORK_API void sfUdpSocket_setBlocking(sfUdpSocket* socket, DBool blocking);


//Tell whether a UDP socket is in blocking or non-blocking mode
DSFML_NETWORK_API DBool sfUdpSocket_isBlocking(const sfUdpSocket* socket);


//Get the port to which a UDP socket is bound locally
DSFML_NETWORK_API DUshort sfUdpSocket_getLocalPort(const sfUdpSocket* socket);


//Bind a UDP socket to a specific port
DSFML_NETWORK_API DInt sfUdpSocket_bind(sfUdpSocket* socket, DUshort port, sf::IpAddress* ipAddress);


//Unbind a UDP socket from the local port to which it is bound
DSFML_NETWORK_API void sfUdpSocket_unbind(sfUdpSocket* socket);


//Send raw data to a remote peer with a UDP socket
DSFML_NETWORK_API DInt sfUdpSocket_send(sfUdpSocket* socket, const void* data, size_t size, sf::IpAddress* receiver, DUshort port);


//Receive raw data from a remote peer with a UDP socket
DSFML_NETWORK_API void* sfUdpSocket_receive(sfUdpSocket* socket, size_t maxSize, size_t* sizeReceived, sf::IpAddress* sender, DUshort* port, DInt* status);


//Send a formatted packet of data to a remote peer with a UDP socket
DSFML_NETWORK_API DInt sfUdpSocket_sendPacket(sfUdpSocket* socket, sfPacket* packet, sf::IpAddress* receiver, DUshort port);


//Receive a formatted packet of data from a remote peer with a UDP socket
DSFML_NETWORK_API DInt sfUdpSocket_receivePacket(sfUdpSocket* socket, sfPacket* packet, sf::IpAddress* sender, DUshort* port);


#endif // SFML_UDPSOCKET_H
