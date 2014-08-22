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

module dsfml.network.packet;

import std.conv;

class Packet
{
	sfPacket* sfPtr;
	
	this()
	{
		sfPtr = sfPacket_create();
	}
	
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfPacket_destroy(sfPtr);
	}

	const(void)[] getData()
	{
		return sfPacket_getData(sfPtr)[0..sfPacket_getDataSize(sfPtr)];
	}
	
	deprecated("Getting data as a void* is deprecated. No need to find its size.") size_t getDataSize()
	{
		return sfPacket_getDataSize(sfPtr);
	}

	void append(const(void)[] data)
	{
		sfPacket_append(sfPtr, data.ptr, void.sizeof*data.length);
	}

	deprecated("Appending with a void* is deprecated. Use append(void[] data) instead.") void append(const(void)* data, size_t sizeInBytes)
	{
		sfPacket_append(sfPtr, data, sizeInBytes);	
	}

	bool canRead()
	{
		return (sfPacket_canRead(sfPtr));
	}

	void clear()
	{
		sfPacket_clear(sfPtr);
	}

	bool endOfPacket()
	{
		return (sfPacket_endOfPacket(sfPtr));
	}

	bool readBool()
	{
		return cast(bool)readByte();
	}

	byte readByte()
	{
		return sfPacket_readInt8(sfPtr);
	}
	
	ubyte readUbyte()
	{
		return sfPacket_readUint8(sfPtr);
	}
	
	short readShort()
	{
		return sfPacket_readInt16(sfPtr);
	}

	ushort readUshort()
	{
		return sfPacket_readUint16(sfPtr);
	}
	
	int readInt()
	{
		return sfPacket_readInt32(sfPtr);
	}

	uint readUint()
	{
		return sfPacket_readUint32(sfPtr);
	}
	
	float readFloat()
	{
		return sfPacket_readFloat(sfPtr);
	}
	
	double readDouble()
	{
		return sfPacket_readDouble(sfPtr);
	}
	
	string readString()
	{
		//get string length
		uint length = readUint();
		char[] temp = new char[](length);

		//read each char of the string and put it in. 
		for(int i = 0; i < length;++i)
		{
			temp[i] = cast(char)readUbyte();
		}

		return temp.to!string();
	}
	
	wstring readWstring()
	{
		//get string length
		uint length = readUint();
		wchar[] temp = new wchar[](length);
		
		//read each wchar of the string and put it in. 
		for(int i = 0; i < length;++i)
		{
			temp[i] = cast(wchar)readUshort();
		}
		
		return temp.to!wstring();
	}

	dstring readDstring()
	{
		//get string length
		uint length = readUint();
		dchar[] temp = new dchar[](length);
		
		//read each dchar of the string and put it in. 
		for(int i = 0; i < length;++i)
		{
			temp[i] = cast(dchar)readUint();
		}
		
		return temp.to!dstring();
	}

	void writeBool(bool value)
	{
		writeUbyte(cast(ubyte)value);
	}

	void writeByte(byte value)
	{
		sfPacket_writeInt8(sfPtr,value);
	}

	void writeUbyte(ubyte value)
	{
		sfPacket_writeUint8(sfPtr, value);
	}
	
	void writeShort(short value)
	{
		sfPacket_writeInt16(sfPtr, value);
	}
	
	void writeUshort(ushort value)
	{
		sfPacket_writeUint16(sfPtr, value);
	}
	
	void writeInt(int value)
	{
		sfPacket_writeInt32(sfPtr, value);
	}
	
	void writeUint(uint value)
	{
		sfPacket_writeUint32(sfPtr, value);
	}
	
	void writeFloat(float value)
	{
		sfPacket_writeFloat(sfPtr, value);
	}
	
	void writeDouble(double value)
	{
		sfPacket_writeDouble(sfPtr, value);
	}
	
	void writeString(string value)
	{
		//write length of string.
		writeUint(cast(uint)value.length);
		//write append the string data

		append(value);
	}
	
	void writeWideString(wstring value)
	{
		//write length of string.
		writeUint(cast(uint)value.length);
		//write append the string data
		for(int i = 0; i<value.length;++i)
		{
			writeUshort(cast(ushort)value[i]);
		}
	}

	void writeDstring(dstring value)
	{
		//write length of string.
		writeUint(cast(uint)value.length);
		//write append the string data
		for(int i = 0; i<value.length;++i)
		{
			writeUint(cast(uint)value[i]);
		}
	}

	const(void)[] onSend()
	{
		return getData();
	}

	void onRecieve(const(void)[] data)
	{
		append(data);
	}
	
}

unittest
{
	//TODO: Expand to use more of the mehtods found in Packet
	version(DSFML_Unittest_Network)
	{
		import std.stdio;
		import dsfml.network.tcpsocket;
		import dsfml.network.tcplistener;
		import dsfml.network.ipaddress;
		
		writeln("Unittest for Packet");

		//socket connecting to server
		auto clientSocket = new TcpSocket();

		//listener looking for new sockets
		auto listener = new TcpListener();
		listener.listen(55001);

		//get our client socket to connect to the server
		clientSocket.connect(IpAddress.LocalHost, 55001);
		

		
		//packet to send data
		auto sendPacket = new Packet();


		//Packet to receive data
		auto receivePacket = new Packet();
	
		//socket on the server side connected to the client's socket
		auto serverSocket = new TcpSocket();

		//accepts a new connection and binds it to the socket in the parameter
		listener.accept(serverSocket);

		//Let's greet the server!
		sendPacket.writeString("Hello, I'm a client!");
		clientSocket.send(sendPacket);

		//And get the data on the server side
		serverSocket.receive(receivePacket);

		//What did we get from the client?
		writeln("Gotten from client: " ,receivePacket.readString());

		//clear the packets to send/get new information
		sendPacket.clear();
		receivePacket.clear();

		//Respond back to the client
		sendPacket.writeString("Hello, I'm your server.");

		serverSocket.send(sendPacket);
		clientSocket.receive(receivePacket);
		
		
		writeln("Gotten from server: ", receivePacket.readString());

		clientSocket.disconnect();

		
		writeln();
	}
}

package extern(C):

struct sfPacket;

///Create a new packet
sfPacket* sfPacket_create();


///Create a new packet by copying an existing one
sfPacket* sfPacket_copy(const sfPacket* packet);


///Destroy a packet
void sfPacket_destroy(sfPacket* packet);


///Append data to the end of a packet
void sfPacket_append(sfPacket* packet, const void* data, size_t sizeInBytes);


///Clear a packet
void sfPacket_clear(sfPacket* packet);


///Get a pointer to the data contained in a packet
const(void)* sfPacket_getData(const sfPacket* packet);


///Get the size of the data contained in a packet
size_t sfPacket_getDataSize(const sfPacket* packet);


///Tell if the reading position has reached the end of a packet
bool sfPacket_endOfPacket(const sfPacket* packet);


///Test the validity of a packet, for reading
bool sfPacket_canRead(const sfPacket* packet);


///Functions to extract data from a packet
bool    sfPacket_readBool(sfPacket* packet);
byte    sfPacket_readInt8(sfPacket* packet);
ubyte   sfPacket_readUint8(sfPacket* packet);
short   sfPacket_readInt16(sfPacket* packet);
ushort  sfPacket_readUint16(sfPacket* packet);
int     sfPacket_readInt32(sfPacket* packet);
uint    sfPacket_readUint32(sfPacket* packet);
float    sfPacket_readFloat(sfPacket* packet);
double   sfPacket_readDouble(sfPacket* packet);
///void     sfPacket_readString(sfPacket* packet, char* string);
///void     sfPacket_readWideString(sfPacket* packet, wchar_t* string);///Remove in lieu of readUint16 and readUint32 for W and D chars in D?

///Functions to insert data into a packet
void sfPacket_writeBool(sfPacket* packet, bool);
void sfPacket_writeInt8(sfPacket* packet, byte);
void sfPacket_writeUint8(sfPacket* packet, ubyte);
void sfPacket_writeInt16(sfPacket* packet, short);
void sfPacket_writeUint16(sfPacket* packet, ushort);
void sfPacket_writeInt32(sfPacket* packet, int);
void sfPacket_writeUint32(sfPacket* packet, uint);
void sfPacket_writeFloat(sfPacket* packet, float);
void sfPacket_writeDouble(sfPacket* packet, double);

