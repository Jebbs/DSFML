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

module dsfml.network.tcplistener;

debug import std.stdio;
import dsfml.network.socket;
import dsfml.network.tcpsocket;

import dsfml.system.err;
import std.conv;

class TcpListener:Socket
{
	sfTcpListener* sfPtr;
	this()
	{
		sfPtr = sfTcpListener_create();
	}
	
	~this()
	{
		debug writeln("Destroying Tcp Listener");
		sfTcpListener_destroy(sfPtr);
	}
	
	void setBlocking(bool blocking)
	{
		sfTcpListener_setBlocking(sfPtr, blocking);
	}
	
	bool isBlocking()
	{
		return (sfTcpListener_isBlocking(sfPtr));
	}
	
	ushort getLocalPort()
	{
		return sfTcpListener_getLocalPort(sfPtr);
	}
	
	Status listen(ushort port)
	{
		Status toReturn = sfTcpListener_listen(sfPtr, port);
		err.write(text(sfErrNetwork_getOutput()));
		return toReturn;
	}
	
	Status accept(TcpSocket socket)
	{
		Status toReturn = sfTcpListener_accept(sfPtr, &socket.sfPtr); 
		err.write(text(sfErrNetwork_getOutput()));
		return toReturn; 
	}
	
}

private extern(C):

struct sfTcpListener;

sfTcpListener* sfTcpListener_create();


//Destroy a TCP listener
void sfTcpListener_destroy(sfTcpListener* listener);


//Set the blocking state of a TCP listener
void sfTcpListener_setBlocking(sfTcpListener* listener, bool blocking);


//Tell whether a TCP listener is in blocking or non-blocking mode
bool sfTcpListener_isBlocking(const sfTcpListener* listener);


//Get the port to which a TCP listener is bound locally
ushort sfTcpListener_getLocalPort(const(sfTcpListener)* listener);


//Start listening for connections
Socket.Status sfTcpListener_listen(sfTcpListener* listener, ushort port);


//Accept a new connection
Socket.Status sfTcpListener_accept(sfTcpListener* listener, sfTcpSocket** connected);

const(char)* sfErrNetwork_getOutput();