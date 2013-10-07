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

module dsfml.network.udpsocket;

import dsfml.network.packet;
import dsfml.network.ipaddress;

import dsfml.network.socket;

import dsfml.system.err;
import std.conv;

debug import std.stdio;

class UdpSocket:Socket
{
	sfUdpSocket* sfPtr;
	
	this()
	{
		sfPtr = sfUdpSocket_create();
	}
	
	~this()
	{
		debug writeln("Destroy Udp Socket");
		sfUdpSocket_destroy(sfPtr);
	}
	
	void setBlocking(bool blocking)
	{
		sfUdpSocket_setBlocking(sfPtr,blocking);
	}
	
	bool isBlocking()
	{
		return (sfUdpSocket_isBlocking(sfPtr));
	}
	
	ushort getLocalPort()
	{
		return sfUdpSocket_getLocalPort(sfPtr);
	}

	Status bind(ushort port)
	{
		Status toReturn = sfUdpSocket_bind(sfPtr,port);
		err.write(text(sfErrNetwork_getOutput()));
		return toReturn;
	}

	void unbind()
	{
		sfUdpSocket_unbind(sfPtr);
	}
	
	Status send(const(void)[] data, IpAddress address, ushort port)
	{
		Status toReturn = sfUdpSocket_send(sfPtr,data.ptr, data.length,address.m_address.ptr,port);

		return toReturn;
	}

	Status receive(void[] data, IpAddress address, out ushort port)
	{

		size_t sizeReceived;

		Status status = sfUdpSocket_receive(sfPtr, data.ptr, data.length, &sizeReceived, address.m_address.ptr, &port);

		err.write(text(sfErrNetwork_getOutput()));

		return status;
	}
	
	Status send(Packet packet, IpAddress address, ushort port)
	{
		//temporary packet to be removed on function exit
		scope Packet temp = new Packet();
		
		//getting packet's "to send" data
		temp.append(packet.onSend());
		
		//send the data
		return sfUdpSocket_sendPacket(sfPtr, temp.sfPtr,address.m_address.ptr,port);
	}
	
	Status receive(Packet packet, IpAddress address, out ushort port)
	{
		//temporary packet to be removed on function exit
		scope Packet temp = new Packet();

		//get the sent data
		Status status =  sfUdpSocket_receivePacket(sfPtr, packet.sfPtr,address.m_address.ptr,&port);

		//put data into the packet so that it can process it first if it wants.
		packet.onRecieve(temp.getData());
		
		return status;
	}
	
	enum
	{
		maxDatagramSize = 65507
	}
	
}

private extern(C):

struct sfUdpSocket;


//Create a new UDP socket
sfUdpSocket* sfUdpSocket_create();


//Destroy a UDP socket
void sfUdpSocket_destroy(sfUdpSocket* socket);


//Set the blocking state of a UDP listener
void sfUdpSocket_setBlocking(sfUdpSocket* socket, bool blocking);


//Tell whether a UDP socket is in blocking or non-blocking mode
bool sfUdpSocket_isBlocking(const sfUdpSocket* socket);


//Get the port to which a UDP socket is bound locally
ushort sfUdpSocket_getLocalPort(const(sfUdpSocket)* socket);


//Bind a UDP socket to a specific port
Socket.Status sfUdpSocket_bind(sfUdpSocket* socket, ushort port);


//Unbind a UDP socket from the local port to which it is bound
void sfUdpSocket_unbind(sfUdpSocket* socket);


//Send raw data to a remote peer with a UDP socket
Socket.Status sfUdpSocket_send(sfUdpSocket* socket, const(void)* data, size_t size, const(char)* ipAddress, ushort port);


//Receive raw data from a remote peer with a UDP socket
Socket.Status sfUdpSocket_receive(sfUdpSocket* socket, void* data, size_t maxSize, size_t* sizeReceived, char* ipAddress, ushort* port);


//Send a formatted packet of data to a remote peer with a UDP socket
Socket.Status sfUdpSocket_sendPacket(sfUdpSocket* socket, sfPacket* packet, const(char)* ipAddress, ushort port);


//Receive a formatted packet of data from a remote peer with a UDP socket
Socket.Status sfUdpSocket_receivePacket(sfUdpSocket* socket, sfPacket* packet, char* address, ushort* port);

const(char)* sfErrNetwork_getOutput();



