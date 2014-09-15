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

///A module containing the IpAddress struct.
module dsfml.network.ipaddress;

import dsfml.system.time;

/**
 *Encapsulate an IPv4 network address.
 *
 *IpAddress is a utility class for manipulating network addresses.
 *
 *It provides a set a implicit constructors and conversion functions to easily build or transform an IP address from/to various representations.
 */
struct IpAddress
{
	//Initialize m_address with "0.0.0.0" and finish filling it out with /0 characters.
	package char[16] m_address = ['0','.','0','.','0','.','0', 0,0,0,0,0,0,0,0,0];

	///Construct the address from a string.
	///
	///Here address can be either a decimal address (ex: "192.168.1.56") or a network name (ex: "localhost").
	this(string address)
	{
		import dsfml.system.string;
		sfIpAddress_fromString(toStringz(address) ,m_address.ptr);
	}
	
	///Construct the address from 4 bytes.
	///
	///Calling IpAddress(a, b, c, d) is equivalent to calling IpAddress("a.b.c.d"), but safer as it doesn't have to parse a string to get the address components.
	this(ubyte byte0,ubyte byte1,ubyte byte2,ubyte byte3)
	{
		sfIpAddress_fromBytes(byte0,byte1, byte2, byte3, m_address.ptr);
	}
	
	///Construct the address from a 32-bits integer.
	///
	///This constructor uses the internal representation of the address directly. It should be used for optimization purposes, and only if you got that representation from IpAddress::ToInteger().
	this(uint address)
	{
		sfIpAddress_fromInteger(address, m_address.ptr);
	}

	///Get an integer representation of the address.
	///
	///The returned number is the internal representation of the address, and should be used for optimization purposes only (like sending the address through a socket). The integer produced by this function can then be converted back to a sf::IpAddress with the proper constructor.
	int toInteger()
	{
		return sfIpAddress_toInteger(m_address.ptr);
	}

	///Get a string representation of the address.
	///
	///The returned string is the decimal representation of the IP address (like "192.168.1.56"), even if it was constructed from a host name.
	string toString()
	{
		import std.conv;
		//TODO: possibly cache the string? Maybe with a needsUpdatingMethod?

		//Remove any null characters from the string representation
		int i = 0;
		while((m_address[i] != 0) )
		{
			++i;
		}
		//and present the string.
		return m_address[0..i].to!string();
	}

	///Get the computer's local address.
	///
	///The local address is the address of the computer from the LAN point of view, i.e. something like 192.168.1.56. It is meaningful only for communications over the local network. Unlike getPublicAddress, this function is fast and may be used safely anywhere.
	static IpAddress getLocalAddress()
	{
		IpAddress temp;
		sfIpAddress_getLocalAddress(temp.m_address.ptr);
		return temp;
	}
	
	///Get the computer's public address.
	///
	///The public address is the address of the computer from the internet point of view, i.e. something like 89.54.1.169. It is necessary for communications over the world wide web. The only way to get a public address is to ask it to a distant website; as a consequence, this function depends on both your network connection and the server, and may be very slow. You should use it as few as possible. Because this function depends on the network connection and on a distant server, you may use a time limit if you don't want your program to be possibly stuck waiting in case there is a problem; this limit is deactivated by default.
	static IpAddress getPublicAddress(Time timeout = Time.Zero)
	{
		IpAddress temp;
		sfIpAddress_getPublicAddress(temp.m_address.ptr, timeout.asMicroseconds());
		return temp;
	}
	
	///Value representing an empty/invalid address. 
	static immutable(IpAddress) None;
	///The "localhost" address (for connecting a computer to itself locally) 
	static immutable(IpAddress) LocalHost;
	///The "broadcast" address (for sending UDP messages to everyone on a local network) 
	static immutable(IpAddress) Broadcast;

	static this()
	{
		LocalHost = IpAddress(127,0,0,1);
		Broadcast = IpAddress(255,255,255,255);
	}
}

unittest
{
	version(DSFML_Unittest_Network)
	{
		import std.stdio;
		
		writeln("Unittest for IpAdress");


		IpAddress address1;

		assert(address1 == IpAddress.None);

		assert(IpAddress.LocalHost == IpAddress("127.0.0.1"));

		IpAddress googleIP = IpAddress("google.com");

		writeln("Google's Ip address: ",googleIP.toString());

		writeln("Your local Ip Address: ", IpAddress.getLocalAddress());

		writeln("Your public Ip Address: ", IpAddress.getPublicAddress());

		writeln();
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

