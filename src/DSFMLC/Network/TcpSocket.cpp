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
#include <DSFMLC/Network/TcpSocket.h>
#include <DSFMLC/Network/TcpSocketStruct.h>
#include <DSFMLC/Network/PacketStruct.h>
#include <SFML/Network/IpAddress.hpp>
#include <string.h>

sfTcpSocket* sfTcpSocket_create(void)
{
    return new sfTcpSocket;
}


void sfTcpSocket_destroy(sfTcpSocket* socket)
{
    delete socket;
}


void sfTcpSocket_setBlocking(sfTcpSocket* socket, DBool blocking)
{
    socket->This.setBlocking(blocking == DTrue);
}


DBool sfTcpSocket_isBlocking(const sfTcpSocket* socket)
{
    return socket->This.isBlocking()?DTrue: DFalse;
}


DUshort sfTcpSocket_getLocalPort(const sfTcpSocket* socket)
{
    return socket->This.getLocalPort();
}


void sfTcpSocket_getRemoteAddress(const sfTcpSocket* socket, sf::IpAddress* ipAddress)
{

    *ipAddress = socket->This.getRemoteAddress();
}


DUshort sfTcpSocket_getRemotePort(const sfTcpSocket* socket)
{
    return socket->This.getRemotePort();
}


DInt sfTcpSocket_connect(sfTcpSocket* socket, const sf::IpAddress* ipAddress, DUshort port, DLong timeout)
{
    return socket->This.connect(*ipAddress, port, sf::microseconds(timeout));
}


void sfTcpSocket_disconnect(sfTcpSocket* socket)
{
    socket->This.disconnect();
}


DInt sfTcpSocket_send(sfTcpSocket* socket, const void* data, size_t size)
{

    return socket->This.send(data, size);
}


DInt sfTcpSocket_receive(sfTcpSocket* socket, void* data, size_t maxSize, size_t* sizeReceived)
{
    return socket->This.receive(data, maxSize, *sizeReceived);
}


DInt sfTcpSocket_sendPacket(sfTcpSocket* socket, sfPacket* packet)
{
    return socket->This.send(packet->This);
}


DInt sfTcpSocket_receivePacket(sfTcpSocket* socket, sfPacket* packet)
{
    return socket->This.receive(packet->This);
}
