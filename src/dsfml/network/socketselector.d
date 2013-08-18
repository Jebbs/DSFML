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


***All code is based on code written by Laurent Gomila***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML - For a full list see http://www.sfml-dev.org/license.php
*/

module dsfml.network.socketselector;

import dsfml.network.tcplistener;
import dsfml.network.tcpsocket;
import dsfml.network.udpsocket;

debug import std.stdio;

import dsfml.system.time;

class SocketSelector
{
	sfSocketSelector* sfPtr;
	
	this()
	{
		sfPtr = sfSocketSelector_create();
	}
	
	~this()
	{
		debug writeln("Destroying Socket Selector");
		sfSocketSelector_destroy(sfPtr);
	}
	
	void add(TcpListener listener)
	{
		sfSocketSelector_addTcpListener(sfPtr, listener.sfPtr);
	}
	
	void add(TcpSocket socket)
	{
		sfSocketSelector_addTcpSocket(sfPtr, socket.sfPtr);
	}
	
	void add(UdpSocket socket)
	{
		sfSocketSelector_addUdpSocket(sfPtr, socket.sfPtr);
	}
	
	void remove(TcpListener listener)
	{
		sfSocketSelector_removeTcpListener(sfPtr, listener.sfPtr);
	}
	void remove(TcpSocket socket)
	{
		sfSocketSelector_removeTcpSocket(sfPtr, socket.sfPtr);
	}
	
	void remove(UdpSocket socket)
	{
		sfSocketSelector_removeUdpSocket(sfPtr, socket.sfPtr);
	}
	
	void clear()
	{
		sfSocketSelector_clear(sfPtr);
	}
	
	bool wait(Time timeout = Time.Zero)
	{
		return (sfSocketSelector_wait(sfPtr, timeout.asMicroseconds()));
	}
	
	bool isReady(TcpListener listener)
	{
		return (sfSocketSelector_isTcpListenerReady(sfPtr, listener.sfPtr));
	}
	bool isReady(TcpSocket socket)
	{
		return (sfSocketSelector_isTcpSocketReady(sfPtr, socket.sfPtr));
	}
	
	bool isReady(UdpSocket socket)
	{
		return (sfSocketSelector_isUdpSocketReady(sfPtr, socket.sfPtr));
	}
	
}

private extern(C):

struct sfSocketSelector;

//Create a new selector
sfSocketSelector* sfSocketSelector_create();

//Create a new socket selector by copying an existing one
sfSocketSelector* sfSocketSelector_copy(const sfSocketSelector* selector);


//Destroy a socket selector
void sfSocketSelector_destroy(sfSocketSelector* selector);


//Add a new socket to a socket selector
void sfSocketSelector_addTcpListener(sfSocketSelector* selector, sfTcpListener* socket);
void sfSocketSelector_addTcpSocket(sfSocketSelector* selector, sfTcpSocket* socket);
void sfSocketSelector_addUdpSocket(sfSocketSelector* selector, sfUdpSocket* socket);


//Remove a socket from a socket selector
void sfSocketSelector_removeTcpListener(sfSocketSelector* selector, sfTcpListener* socket);
void sfSocketSelector_removeTcpSocket(sfSocketSelector* selector, sfTcpSocket* socket);
void sfSocketSelector_removeUdpSocket(sfSocketSelector* selector, sfUdpSocket* socket);


//Remove all the sockets stored in a selector
void sfSocketSelector_clear(sfSocketSelector* selector);


//Wait until one or more sockets are ready to receive
bool sfSocketSelector_wait(sfSocketSelector* selector, long timeout);


//Test a socket to know if it is ready to receive data
bool sfSocketSelector_isTcpListenerReady(const(sfSocketSelector)* selector, sfTcpListener* socket);
bool sfSocketSelector_isTcpSocketReady(const(sfSocketSelector)* selector, sfTcpSocket* socket);
bool sfSocketSelector_isUdpSocketReady(const(sfSocketSelector)* selector, sfUdpSocket* socket);
