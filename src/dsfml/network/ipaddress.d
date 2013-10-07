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

module dsfml.network.ipaddress;

import dsfml.system.time;

import std.string;
import std.conv;

struct IpAddress
{
	//Initialize m_address with "0.0.0.0" and finish filling it out with /0 characters.
	public char[16] m_address = ['0','.','0','.','0','.','0', 0,0,0,0,0,0,0,0,0];

	this(string address)
	{

		sfIpAddress_fromString(toStringz(address) ,m_address.ptr);
	}
	
	this(ubyte byte0,ubyte byte1,ubyte byte2,ubyte byte3)
	{
		sfIpAddress_fromBytes(byte0,byte1, byte2, byte3, m_address.ptr);
	}
	
	this(uint address)
	{
		sfIpAddress_fromInteger(address, m_address.ptr);
	}
	

	string toString()
	{
		//Remove any null characters from the string representation
		int i = 0;
		while((m_address[i] != 0) )
		{
			++i;
		}
		//and present the string.
		return m_address[0..i].to!string();
	}
	
	int toInteger()
	{
		return sfIpAddress_toInteger(m_address.ptr);
	}
	
	static IpAddress getLocalAddress()
	{
		IpAddress temp;
		sfIpAddress_getLocalAddress(temp.m_address.ptr);
		return temp;
	}
	
	static IpAddress getPublicAddress(Time timeout = Time.Zero)
	{
		IpAddress temp;
		sfIpAddress_getPublicAddress(temp.m_address.ptr, timeout.asMicroseconds());
		return temp;
	}
	
	static immutable IpAddress None;
	static immutable(IpAddress) LocalHost;
	static immutable(IpAddress) Broadcast;

	static this()
	{
		LocalHost = IpAddress(127,0,0,1);
		Broadcast = IpAddress(255,255,255,255);
	}

}



private extern(C):
//Note: These functions rely on passing an existing array for the ipAddress.

///Create an address from a string
void sfIpAddress_fromString(const(char)* address, char* ipAddress);


///Create an address from 4 bytes
void sfIpAddress_fromBytes(ubyte byte0, ubyte byte1, ubyte byte2, ubyte byte3, char* ipAddress);


///Construct an address from a 32-bits integer
void sfIpAddress_fromInteger(uint address, char* ipAddress);


///Get an integer representation of the address
uint sfIpAddress_toInteger(const(char)* ipAddress);


///Get the computer's local address
void sfIpAddress_getLocalAddress(char* ipAddress);


///Get the computer's public address
void sfIpAddress_getPublicAddress(char* ipAddress, long timeout);

