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

#ifndef DSFML_TCPSOCKET_H
#define DSFML_TCPSOCKET_H


// Headers
#include <DSFMLC/Network/Export.h>
#include <DSFMLC/Network/IpAddress.h>
#include <DSFMLC/Network/Types.h>
#include <stddef.h>


//Destroy internal stored data for receiving
DSFML_NETWORK_API void sfTcpSocket_destroyInternalData(void);

//Create a new TCP socket
DSFML_NETWORK_API sfTcpSocket* sfTcpSocket_create(void);


//Destroy a TCP socket
DSFML_NETWORK_API void sfTcpSocket_destroy(sfTcpSocket* socket);


//Set the blocking state of a TCP listener
DSFML_NETWORK_API void sfTcpSocket_setBlocking(sfTcpSocket* socket, DBool blocking);


//Tell whether a TCP socket is in blocking or non-blocking mode
DSFML_NETWORK_API DBool sfTcpSocket_isBlocking(const sfTcpSocket* socket);


//Get the port to which a TCP socket is bound locally
DSFML_NETWORK_API DUshort sfTcpSocket_getLocalPort(const sfTcpSocket* socket);


//Get the address of the connected peer of a TCP socket
DSFML_NETWORK_API void sfTcpSocket_getRemoteAddress(const sfTcpSocket* socket, sf::IpAddress* ipAddress);


//Get the port of the connected peer to which a TCP socket is connected
DSFML_NETWORK_API DUshort sfTcpSocket_getRemotePort(const sfTcpSocket* socket);


//Connect a TCP socket to a remote peer
DSFML_NETWORK_API DInt sfTcpSocket_connect(sfTcpSocket* socket, const sf::IpAddress* ipAddress, DUshort port, DLong timeout);


//Disconnect a TCP socket from its remote peer
DSFML_NETWORK_API void sfTcpSocket_disconnect(sfTcpSocket* socket);


//Send raw data to the remote peer of a TCP socket
DSFML_NETWORK_API DInt sfTcpSocket_send(sfTcpSocket* socket, const void* data, size_t size);


//Receive raw data from the remote peer of a TCP socket
DSFML_NETWORK_API void* sfTcpSocket_receive(sfTcpSocket* socket, size_t maxSize, size_t* sizeReceived, DInt* status);


//Send a formatted packet of data to the remote peer of a TCP socket
DSFML_NETWORK_API DInt sfTcpSocket_sendPacket(sfTcpSocket* socket, sfPacket* packet);


//Receive a formatted packet of data from the remote peer
DSFML_NETWORK_API DInt sfTcpSocket_receivePacket(sfTcpSocket* socket, sfPacket* packet);


#endif // DSFML_TCPSOCKET_H
