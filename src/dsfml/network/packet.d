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

///A module contianing the Packet class.
module dsfml.network.packet;

import std.traits;
import std.range;

/**
 *Utility class to build blocks of data to transfer over the network.
 *
 *Packets provide a safe and easy way to serialize data, in order to send it over the network using sockets (sf::TcpSocket, sf::UdpSocket).
 */
class Packet
{
	
	private
	{
		ubyte[] m_data;    /// Data stored in the packet
		size_t  m_readPos; /// Current reading position in the packet
		bool    m_isValid; /// Reading state of the packet
	}
	
	///Default constructor
	this()
	{
		m_readPos = 0;
		m_isValid = true;
	}
	
	///Destructor
	~this()
	{
		import dsfml.system.config;
		mixin(destructorOutput);
	}

	///Get a slice of the data contained in the packet.
	///
	///Returns: Slice containing the data.
	const(void)[] getData() const
	{
		return m_data;
	}

	///Append data to the end of the packet.
	///Params:
	///		data = Pointer to the sequence of bytes to append.
	void append(const(void)[] data)
	{
		if(data != null && data.length > 0)
		{
			m_data ~= cast(ubyte[])data;
		}
	}

	
	///Test the validity of a packet, for reading
	///
	///This function allows to test the packet, to check if
	///a reading operation was successful.
	///
	///A packet will be in an invalid state if it has no more
	///data to read.
	///
	///Returns: True if last data extraction from packet was successful.
	bool canRead() const
	{
		return m_isValid;
	}

	///Clear the packet.
	///
	///After calling Clear, the packet is empty.
	void clear()
	{
		m_data.length = 0;
		m_readPos = 0;
		m_isValid = true;
	}

	///Tell if the reading position has reached the end of the packet.
	///
	///This function is useful to know if there is some data left to be read, without actually reading it.
	///
	///Returns: True if all data was read, false otherwise.
	bool endOfPacket() const
	{
		return m_readPos >= m_data.length;
	}
	
	
	///Reads a primitive data type or string from the packet.
	///
	///Returns: The value in the packet at the current read position.
	///Throws: A RangeError if you try to access data that doesn't exist.
	T read(T)()
	if(isScalarType!T)
	{
		import std.bitmanip;
		
		T temp = std.bitmanip.peek!T(m_data, m_readPos);
		m_readPos += T.sizeof;

		return temp;
	}
	
	///Ditto
	T read(T)() 
	if(isSomeString!T)
	{
		import std.conv;
		
		//Get the element type of the string
		static if(isNarrowString!T)
		{
			alias ET = Unqual!(ElementEncodingType!T);
		}
		else
		{
			alias ET = Unqual!(ElementType!T);
		}

		//get string length
		uint length = read!uint();
		ET[] temp = new ET[](length);
		
		//read each dchar of the string and put it in. 
		for(int i = 0; i < length; ++i)
		{
			temp[i] = read!ET;
		}
		
		return temp.to!T();
	}
	
	
	///Writes a scalar data type or string to the packet.
	void write(T)(T value)
	if(isScalarType!T)
	{
		import std.bitmanip;
		
		size_t index = m_data.length;
		m_data.reserve(value.sizeof);
		m_data.length += value.sizeof;
		
		std.bitmanip.write!T(m_data, value, index);
	}
	
	///Ditto
	void write(T)(T value)
	if(isSomeString!T)
	{
		//write length of string.
		write(cast(uint) value.length);
		//write append the string data
		for(int i = 0; i < value.length; ++i)
		{
			write(value[i]);
		}
	}

	///Called before the packet is sent over the network.
	///
	///This function can be defined by derived classes to transform the data before it is sent; this can be used for compression, encryption, etc.
	///The function must return an array of the modified data, as well as the number of bytes pointed. The default implementation provides the packet's data without transforming it.
	///
	///Returns:  Array of bytes to send
	const(void)[] onSend()
	{
		return getData();
	}

	///Called after the packet is received over the network.
	///
	///This function can be defined by derived classes to transform the data after it is received; this can be used for uncompression, decryption, etc.
	///The function receives an array of the received data, and must fill the packet with the transformed bytes. The default implementation fills the packet directly without transforming the data.
	///
	///Params:
	///		data = Array of the received bytes. 
	void onRecieve(const(void)[] data)
	{
		append(data);
	}

	version(unittest)
	{
		shared static this()
		{
			//XInitThreads();
		}


	}
	
	private bool checkSize(size_t size)
	{
		m_isValid = m_isValid && (m_readPos + size <= m_data.length);

		return m_isValid;
	}
	
}

/**
 *Utility class used internally to interact with DSFML-C to transfer Packet's data.
 */
package class SfPacket
{
	package sfPacket* sfPtr;
	
	///Default constructor
	this()
	{
		sfPtr = sfPacket_create();
	}
	
	///Destructor
	~this()
	{
		import dsfml.system.config;
		mixin(destructorOutput);
		sfPacket_destroy(sfPtr);
	}
	
	
	///Get a slice of the data contained in the packet.
	///
	///Returns: Slice containing the data.
	const(void)[] getData() const
	{
		return sfPacket_getData(sfPtr)[0 .. sfPacket_getDataSize(sfPtr)];
	}

	///Append data to the end of the packet.
	///Params:
	///		data = Pointer to the sequence of bytes to append.
	void append(const(void)[] data)
	{
		sfPacket_append(sfPtr, data.ptr, void.sizeof * data.length);
	}
}


unittest
{
	//TODO: Expand to use more of the mehtods found in Packet
	version(DSFML_Unittest_Network)
	{
		import std.stdio;

		import dsfml.network.socket;
		import dsfml.network.tcpsocket;
		import dsfml.network.tcplistener;
		import dsfml.network.ipaddress;
		
		import core.time;

		
		writeln("Unittest for Packet");
		//socket connecting to server
		auto clientSocket = new TcpSocket();
		
		//listener looking for new sockets
		auto listener = new TcpListener();
		listener.listen(46932);
		
		//get our client socket to connect to the server
		clientSocket.connect(IpAddress.LocalHost, 46932);
		
		
		
		//packet to send data
		auto sendPacket = new Packet();
		
		
		//Packet to receive data
		auto receivePacket = new Packet();
		
		//socket on the server side connected to the client's socket
		auto serverSocket = new TcpSocket();
		
		//accepts a new connection and binds it to the socket in the parameter
		listener.accept(serverSocket);
		
		//Let's greet the server!
		sendPacket.write("Hello, I'm a client!");
		clientSocket.send(sendPacket);
		
		//And get the data on the server side
		serverSocket.receive(receivePacket);
		
		//What did we get from the client?
		writeln("Gotten from client: ", receivePacket.read!string());
		
		//clear the packets to send/get new information
		sendPacket.clear();
		receivePacket.clear();
		
		//Respond back to the client
		sendPacket.write("Hello, I'm your server.");
		
		serverSocket.send(sendPacket);

		clientSocket.receive(receivePacket);


		
		writeln("Gotten from server: ", receivePacket.read!string());
		
		clientSocket.disconnect();
		
		writeln("Done!");
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
