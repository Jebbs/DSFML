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

///A module containing the TcpSocket class.
module dsfml.network.tcpsocket;

import dsfml.network.socket;
import dsfml.network.ipaddress;
import dsfml.network.packet;

import dsfml.system.time;
import dsfml.system.err;

/**
 *Specialized socket using the TCP protocol.
 *
 *TCP is a connected protocol, which means that a TCP socket can only communicate with the host it is connected to.
 *
 *It can't send or receive anything if it is not connected.
 *
 *The TCP protocol is reliable but adds a slight overhead. It ensures that your data will always be received in order and without errors (no data corrupted, lost or duplicated).
 *
 *When a socket is connected to a remote host, you can retrieve informations about this host with the getRemoteAddress and getRemotePort functions.
 *You can also get the local port to which the socket is bound (which is automatically chosen when the socket is connected), with the getLocalPort function.
 *
 *Sending and receiving data can use either the low-level or the high-level functions. The low-level functions process a raw sequence of bytes, and cannot ensure that one call to Send will exactly match one call to Receive at the other end of the socket.
 *
 *The high-level interface uses packets (see sf::Packet), which are easier to use and provide more safety regarding the data that is exchanged. You can look at the sf::Packet class to get more details about how they work.
 *
 *The socket is automatically disconnected when it is destroyed, but if you want to explicitely close the connection while the socket instance is still alive, you can call disconnect.
 */
class TcpSocket:Socket
{
	package sfTcpSocket* sfPtr;
	
	///Default constructor
	this()
	{
		sfPtr = sfTcpSocket_create();
	}
	
	///Destructor
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfTcpSocket_destroy(sfPtr);
	}

	///Get the port to which the socket is bound locally.
	///
	///If the socket is not connected, this function returns 0.
	ushort getLocalPort()
	{
		return sfTcpSocket_getLocalPort(sfPtr);
	}

	///Get the address of the connected peer.
	///
	///It the socket is not connected, this function returns IpAddress.None.
	IpAddress getRemoteAddress()
	{
		IpAddress temp;
		
		sfTcpSocket_getRemoteAddress(sfPtr,temp.m_address.ptr);
		
		return temp;
	}

	///Get the port of the connected peer to which the socket is connected.
	///
	///If the socket is not connected, this function returns 0.
	ushort getRemotePort()
	{
		return sfTcpSocket_getRemotePort(sfPtr);
	}

	///Set the blocking state of the socket.
	///
	///In blocking mode, calls will not return until they have completed their task. For example, a call to Receive in blocking mode won't return until some data was actually received.
	///In non-blocking mode, calls will always return immediately, using the return code to signal whether there was data available or not. By default, all sockets are blocking.
	void setBlocking(bool blocking)
	{
		sfTcpSocket_setBlocking(sfPtr, blocking);
	}

	///Connect the socket to a remote peer.
	///
	///In blocking mode, this function may take a while, especially if the remote peer is not reachable. The last parameter allows you to stop trying to connect after a given timeout.
	///If the socket was previously connected, it is first disconnected.
	Status connect(IpAddress host, ushort port, Time timeout = Time.Zero)
	{
		return sfTcpSocket_connect(sfPtr, host.m_address.ptr,port, timeout.asMicroseconds());
	}
	
	///Disconnect the socket from its remote peer.
	///
	///This function gracefully closes the connection. If the socket is not connected, this function has no effect.
	void disconnect()
	{
		sfTcpSocket_disconnect(sfPtr);
	}

	///Tell whether the socket is in blocking or non-blocking mode. 
	bool isBlocking()
	{
		return (sfTcpSocket_isBlocking(sfPtr));
	}

	///Send raw data to the remote peer.
	///
	///This function will fail if the socket is not connected.
	Status send(const(void)[] data)
	{
		import dsfml.system.string;

		Status toReturn = sfTcpSocket_send(sfPtr, data.ptr, data.length);
		err.write(toString(sfErr_getOutput()));
		return toReturn;
	}

	///Send a formatted packet of data to the remote peer.
	///
	///This function will fail if the socket is not connected.
	Status send(Packet packet)
	{

		//temporary packet to be removed on function exit
		scope Packet temp = new Packet();

		//getting packet's "to send" data
		temp.append(packet.onSend());

		//send the data
		return sfTcpSocket_sendPacket(sfPtr, temp.sfPtr);
	}
	///Receive raw data from the remote peer.
	///
	///In blocking mode, this function will wait until some bytes are actually received. This function will fail if the socket is not connected.
	Status receive(out void[] data, size_t maxSize)
	{
		void* dataPtr;
		size_t sizeReceived;
		
		Status status = sfTcpSocket_receive(sfPtr, dataPtr, maxSize, &sizeReceived);
		//TODO: catch when maxSize is < than Size received?
		data = dataPtr[0..sizeReceived];

		import std.stdio;

		//writeln(sizeReceived);
		
		return status;
	}

	//Receive a formatted packet of data from the remote peer.
	///
	///In blocking mode, this function will wait until the whole packet has been received. This function will fail if the socket is not connected.
	Status receive(Packet packet)
	{
		//temporary packet to be removed on function exit
		scope Packet temp = new Packet();

		//get the sent data
		Status status = sfTcpSocket_receivePacket(sfPtr, temp.sfPtr);

		//put data into the packet so that it can process it first if it wants.
		packet.onRecieve(temp.getData());

		return status;
	}
}

unittest
{
	//TODO: Expand to use more methods in TcpSocket
	version(DSFML_Unittest_Network)
	{
		import std.stdio;
		import dsfml.network.tcplistener;

		writeln("Unittest for Tcp Socket");

		//socket connecting to server
		auto clientSocket = new TcpSocket();
		
		//listener looking for new sockets
		auto listener = new TcpListener();
		listener.listen(55003);
		
		//get our client socket to connect to the server
		clientSocket.connect(IpAddress.LocalHost, 55003);
		
		
		
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
	}
}

package extern(C):

struct sfTcpSocket;

//Create a new TCP socket
sfTcpSocket* sfTcpSocket_create();


//Destroy a TCP socket
void sfTcpSocket_destroy(sfTcpSocket* socket);


//Set the blocking state of a TCP listener
void sfTcpSocket_setBlocking(sfTcpSocket* socket, bool blocking);


//Tell whether a TCP socket is in blocking or non-blocking mode
bool sfTcpSocket_isBlocking(const(sfTcpSocket)* socket);


//Get the port to which a TCP socket is bound locally
ushort sfTcpSocket_getLocalPort(const(sfTcpSocket)* socket);


//Get the address of the connected peer of a TCP socket
void sfTcpSocket_getRemoteAddress(const(sfTcpSocket)* socket, char* ipAddress);


//Get the port of the connected peer to which a TCP socket is connected
ushort sfTcpSocket_getRemotePort(const(sfTcpSocket)* socket);


//Connect a TCP socket to a remote peer
Socket.Status sfTcpSocket_connect(sfTcpSocket* socket, const(char)* hostIP, ushort port, long timeout);


//Disconnect a TCP socket from its remote peer
void sfTcpSocket_disconnect(sfTcpSocket* socket);


//Send raw data to the remote peer of a TCP socket
Socket.Status sfTcpSocket_send(sfTcpSocket* socket, const void* data, size_t size);


//Receive raw data from the remote peer of a TCP socket
Socket.Status sfTcpSocket_receive(sfTcpSocket* socket, void* data, size_t maxSize, size_t* sizeReceived);


//Send a formatted packet of data to the remote peer of a TCP socket
Socket.Status sfTcpSocket_sendPacket(sfTcpSocket* socket, sfPacket* packet);


//Receive a formatted packet of data from the remote peer
Socket.Status sfTcpSocket_receivePacket(sfTcpSocket* socket, sfPacket* packet);

const(char)* sfErr_getOutput();

