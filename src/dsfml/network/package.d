/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

///Socket-based communication, utilities and higher-level network protocols (HTTP, FTP).
module dsfml.network;

public
{
	import dsfml.system;

	import dsfml.network.ftp;
	import dsfml.network.http;
	import dsfml.network.ipaddress;
	import dsfml.network.packet;
	import dsfml.network.socket;
	import dsfml.network.socketselector;
	import dsfml.network.tcplistener;
	import dsfml.network.tcpsocket;
	import dsfml.network.udpsocket;
}
