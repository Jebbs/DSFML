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
#include <SFML/Network/UdpSocket.h>
#include <SFML/Network/UdpSocketStruct.h>
#include <SFML/Network/PacketStruct.h>
#include <SFML/Network/IpAddress.hpp>
#include <SFML/Internal.h>
#include <string.h>



sfUdpSocket* sfUdpSocket_create(void)
{
    return new sfUdpSocket;
}


void sfUdpSocket_destroy(sfUdpSocket* socket)
{
    delete socket;
}


void sfUdpSocket_setBlocking(sfUdpSocket* socket, DBool blocking)
{
    CSFML_CALL(socket, setBlocking(blocking == DTrue));
}


DBool sfUdpSocket_isBlocking(const sfUdpSocket* socket)
{
    CSFML_CALL_RETURN(socket, isBlocking(), DFalse);
}



DUshort sfUdpSocket_getLocalPort(const sfUdpSocket* socket)
{
    CSFML_CALL_RETURN(socket, getLocalPort(), 0);
}



DInt sfUdpSocket_bind(sfUdpSocket* socket, DUshort port)
{

    return socket->This.bind(port);
}


void sfUdpSocket_unbind(sfUdpSocket* socket)
{
    CSFML_CALL(socket, unbind());
}


DInt sfUdpSocket_send(sfUdpSocket* socket, const void* data, size_t size, const char* ipAddress, DUshort port)
{

    // Convert the address
    sf::IpAddress receiver(ipAddress);

    return socket->This.send(data, size, receiver, port);
}



DInt sfUdpSocket_receive(sfUdpSocket* socket, void* data, size_t maxSize, size_t* sizeReceived, char* ipAddress, DUshort* port)
{


    // Call SFML internal function
    sf::IpAddress sender;
    unsigned short senderPort;
    std::size_t received;

    sf::Socket::Status status = socket->This.receive(data, maxSize, received, sender, senderPort);
    if (status != sf::Socket::Done)
        return status;

    if (sizeReceived)
        *sizeReceived = received;

    if (ipAddress)
        strncpy(ipAddress, sender.toString().c_str(), 16);

    if (port)
        *port = senderPort;

    return sf::Socket::Done;
}



DInt sfUdpSocket_sendPacket(sfUdpSocket* socket, sfPacket* packet, const char* ipAddress, DUshort port)
{


    // Convert the address
    sf::IpAddress receiver(ipAddress);

    return socket->This.send(packet->This, receiver, port);
}



DInt sfUdpSocket_receivePacket(sfUdpSocket* socket, sfPacket* packet, char* ipAddress, DUshort* port)
{


    sf::IpAddress sender;
    unsigned short senderPort;
    sf::Socket::Status status = socket->This.receive(packet->This, sender, senderPort);
    if (status != sf::Socket::Done)
        return status;

    if (ipAddress)
        strncpy(ipAddress, sender.toString().c_str(), 16);

    if (port)
        *port = senderPort;

    return sf::Socket::Done;
}


