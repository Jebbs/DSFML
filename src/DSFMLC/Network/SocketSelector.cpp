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
#include <DSFMLC/Network/SocketSelector.h>
#include <DSFMLC/Network/SocketSelectorStruct.h>
#include <DSFMLC/Network/TcpListenerStruct.h>
#include <DSFMLC/Network/TcpSocketStruct.h>
#include <DSFMLC/Network/UdpSocketStruct.h>


sfSocketSelector* sfSocketSelector_create(void)
{
    return new sfSocketSelector;
}


sfSocketSelector* sfSocketSelector_copy(const sfSocketSelector* selector)
{

    return new sfSocketSelector(*selector);
}


void sfSocketSelector_destroy(sfSocketSelector* selector)
{
    delete selector;
}


void sfSocketSelector_addTcpListener(sfSocketSelector* selector, sfTcpListener* socket)
{
    selector->This.add(socket->This);
}
void sfSocketSelector_addTcpSocket(sfSocketSelector* selector, sfTcpSocket* socket)
{
    selector->This.add(socket->This);
}
void sfSocketSelector_addUdpSocket(sfSocketSelector* selector, sfUdpSocket* socket)
{
    selector->This.add(socket->This);
}



void sfSocketSelector_removeTcpListener(sfSocketSelector* selector, sfTcpListener* socket)
{
    selector->This.remove(socket->This);
}
void sfSocketSelector_removeTcpSocket(sfSocketSelector* selector, sfTcpSocket* socket)
{
    selector->This.remove(socket->This);
}
void sfSocketSelector_removeUdpSocket(sfSocketSelector* selector, sfUdpSocket* socket)
{
    selector->This.remove(socket->This);
}


void sfSocketSelector_clear(sfSocketSelector* selector)
{
    selector->This.clear();
}


DBool sfSocketSelector_wait(sfSocketSelector* selector, DLong timeout)
{
    return selector->This.wait(sf::microseconds(timeout))?DTrue: DFalse;
}


DBool sfSocketSelector_isTcpListenerReady(const sfSocketSelector* selector, sfTcpListener* socket)
{
    return selector->This.isReady(socket->This)?DTrue: DFalse;
}
DBool sfSocketSelector_isTcpSocketReady(const sfSocketSelector* selector, sfTcpSocket* socket)
{
    return selector->This.isReady(socket->This)?DTrue: DFalse;
}
DBool sfSocketSelector_isUdpSocketReady(const sfSocketSelector* selector, sfUdpSocket* socket)
{
    return selector->This.isReady(socket->This)?DTrue: DFalse;
}
