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
#include <DSFMLC/Network/UdpSocket.h>
#include <DSFMLC/Network/UdpSocketStruct.h>
#include <DSFMLC/Network/PacketStruct.h>
#include <SFML/Network/IpAddress.hpp>
#include <string.h>

//annonymous namespace for storing the received raw data
namespace
{
    char* receivedData;
}

void sfUdpSocket_destroyInternalData(void)
{
     if(receivedData)
    {
        delete receivedData;
        receivedData = 0;
    }
}

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
    socket->This.setBlocking(blocking == DTrue);
}


DBool sfUdpSocket_isBlocking(const sfUdpSocket* socket)
{
    return socket->This.isBlocking()?DTrue: DFalse;
}



DUshort sfUdpSocket_getLocalPort(const sfUdpSocket* socket)
{
    return socket->This.getLocalPort();
}



DInt sfUdpSocket_bind(sfUdpSocket* socket, DUshort port)
{

    return static_cast<DInt>(socket->This.bind(port));
}


void sfUdpSocket_unbind(sfUdpSocket* socket)
{
    socket->This.unbind();
}


DInt sfUdpSocket_send(sfUdpSocket* socket, const void* data, size_t size, const char* ipAddress, DUshort port)
{

    // Convert the address
    sf::IpAddress receiver(ipAddress);

    return static_cast<DInt>(socket->This.send(data, size, receiver, port));
}



void* sfUdpSocket_receive(sfUdpSocket* socket, size_t maxSize, size_t* sizeReceived, char* ipAddress, DUshort* port, DInt* status)
{
    //D didn't like passing an array to C++ and having it altered here, so we will be creating a temp
    //way to store the data and pass it up to D. It should work, so I will look into a different/better solution for 2.2.

    sfUdpSocket_destroyInternalData();
    receivedData = new char[maxSize];

    // Call SFML internal function
    sf::IpAddress sender;

    *status = static_cast<DInt>(socket->This.receive(receivedData, maxSize, *sizeReceived, sender, *port));
    
    strncpy(ipAddress, sender.toString().c_str(), 16);

    return static_cast<void*>(receivedData);
}



DInt sfUdpSocket_sendPacket(sfUdpSocket* socket, sfPacket* packet, const char* ipAddress, DUshort port)
{
    // Convert the address
    sf::IpAddress receiver(ipAddress);

    return static_cast<DInt>(socket->This.send(packet->This, receiver, port));
}



DInt sfUdpSocket_receivePacket(sfUdpSocket* socket, sfPacket* packet, char* ipAddress, DUshort* port)
{
    sf::IpAddress sender;

    DInt status = static_cast<DInt>(socket->This.receive(packet->This, sender, *port));
    
    strncpy(ipAddress, sender.toString().c_str(), 16);

    return status;
}


