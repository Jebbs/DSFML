/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2017 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 */

/**
 * Socket selectors provide a way to wait until some data is available on a set
 * of sockets, instead of just one. This is convenient when you have multiple
 * sockets that may possibly receive data, but you don't know which one will be
 * ready first. In particular, it avoids to use a thread for each socket; with
 * selectors, a single thread can handle all the sockets.
 *
 * All types of sockets can be used in a selector:
 * $(LIST TcpListener)
 * $(LIST TcpSocket)
 * $(LIST UdpSocket)
 *
 * A selector doesn't store its own copies of the sockets, it simply keeps a
 * reference to the original sockets that you pass to the "add" function.
 * Therefore, you can't use the selector as a socket container, you must store
 * them outside and make sure that they are alive as long as they are used in
 * the selector (i.e., they cannot be collected by the GC).
 *
 * Using a selector is simple:
 * $(LIST populate the selector with all the sockets that you want to observe)
 * $(LIST make it wait until there is data available on any of the sockets)
 * $(LIST test each socket to find out which ones are ready)
 *
 * Example:
 * ---
 * // Create a socket to listen to new connections
 * auto listener = new TcpListener();
 * listener.listen(55001);
 *
 * // Create a list to store the future clients
 * TcpSocket[] clients;
 *
 * // Create a selector
 * auto selector = new SocketSelector();
 *
 * // Add the listener to the selector
 * selector.add(listener);
 *
 * // Endless loop that waits for new connections
 * while (running)
 * {
 *     // Make the selector wait for data on any socket
 *     if (selector.wait())
 *     {
 *         // Test the listener
 *         if (selector.isReady(listener))
 *         {
 *             // The listener is ready: there is a pending connection
 *             auto client = new TcpSocket();
 *             if (listener.accept(client) == Socket.Status.Done)
 *             {
 *                 // Add the new client to the clients list
 *                 clients~=client;
 *
 *                 // Add the new client to the selector so that we will
 *                 // be notified when he sends something
 *                 selector.add(client);
 *             }
 *             else
 *             {
 *                 // Error, we won't get a new connection
 *             }
 *         }
 *         else
 *         {
 *             // The listener socket is not ready, test all other sockets (the clients)
 *             foreach(client; clients)
 *             {
 *                 if (selector.isReady(client))
 *                 {
 *                     // The client has sent some data, we can receive it
 *                     auto packet = new Packet();
 *                     if (client.receive(packet) == Socket.Status.Done)
 *                     {
 *                         ...
 *                     }
 *                 }
 *             }
 *         }
 *     }
 * }
 * ---
 *
 * See_Also:
 * $(SOCKET_LINK)
 */
module dsfml.network.socketselector;

import dsfml.network.tcplistener;
import dsfml.network.tcpsocket;
import dsfml.network.udpsocket;

import core.time;

/**
 * Multiplexer that allows to read from multiple sockets.
 */
class SocketSelector
{
    package sfSocketSelector* sfPtr;

    /// Default constructor.
    this()
    {
        sfPtr = sfSocketSelector_create();
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfSocketSelector_destroy(sfPtr);
    }

    /**
     * Add a new TcpListener to the selector.
     *
     * This function keeps a weak reference to the socket, so you have to make
     * sure that the socket is not destroyed while it is stored in the selector.
     * This function does nothing if the socket is not valid.
     *
     * Params:
     * 	listener = Reference to the listener to add
     */
    void add(TcpListener listener)
    {
        sfSocketSelector_addTcpListener(sfPtr, listener.sfPtr);
    }

    /**
     * Add a new TcpSocket to the selector.
     *
     * This function keeps a weak reference to the socket, so you have to make
     * sure that the socket is not destroyed while it is stored in the selector.
     * This function does nothing if the socket is not valid.
     *
     * Params:
     *  socket = Reference to the socket to add
     */
    void add(TcpSocket socket)
    {
        sfSocketSelector_addTcpSocket(sfPtr, socket.sfPtr);
    }

    /**
     * Add a new UdpSocket to the selector.
     *
     * This function keeps a weak reference to the socket, so you have to make
     * sure that the socket is not destroyed while it is stored in the selector.
     * This function does nothing if the socket is not valid.
     *
     * Params:
     * 	socket = Reference to the socket to add
     */
    void add(UdpSocket socket)
    {
        sfSocketSelector_addUdpSocket(sfPtr, socket.sfPtr);
    }

    /**
     * Remove all the sockets stored in the selector.
     *
     * This function doesn't destroy any instance, it simply removes all the
     * references that the selector has to external sockets.
     */
    void clear()
    {
        sfSocketSelector_clear(sfPtr);
    }

    /**
     * Test a socket to know if it is ready to receive data.
     *
     * This function must be used after a call to Wait, to know which sockets
     * are ready to receive data. If a socket is ready, a call to receive will
     * never block because we know that there is data available to read. Note
     * that if this function returns true for a TcpListener, this means that it
     * is ready to accept a new connection.
     */
    bool isReady(TcpListener listener)
    {
        return (sfSocketSelector_isTcpListenerReady(sfPtr, listener.sfPtr));
    }

    /// ditto
    bool isReady(TcpSocket socket)
    {
        return (sfSocketSelector_isTcpSocketReady(sfPtr, socket.sfPtr));
    }

    /// ditto
    bool isReady(UdpSocket socket)
    {
        return (sfSocketSelector_isUdpSocketReady(sfPtr, socket.sfPtr));
    }

    /**
     * Remove a socket from the selector.
     *
     * This function doesn't destroy the socket, it simply removes the reference
     * that the selector has to it.
     *
     * Params:
     *  socket = Reference to the socket to remove
     */
    void remove(TcpListener socket)
    {
        sfSocketSelector_removeTcpListener(sfPtr, socket.sfPtr);
    }

    /**
     * Remove a socket from the selector.
     *
     * This function doesn't destroy the socket, it simply removes the reference
     * that the selector has to it.
     *
     * Params:
     *  socket = Reference to the socket to remove
     */
    void remove(TcpSocket socket)
    {
        sfSocketSelector_removeTcpSocket(sfPtr, socket.sfPtr);
    }

    /**
     * Remove a socket from the selector.
     *
     * This function doesn't destroy the socket, it simply removes the reference
     * that the selector has to it.
     *
     * Params:
     *  socket = Reference to the socket to remove
     */
    void remove(UdpSocket socket)
    {
        sfSocketSelector_removeUdpSocket(sfPtr, socket.sfPtr);
    }

    /**
     * Wait until one or more sockets are ready to receive.
     *
     * This function returns as soon as at least one socket has some data
     * available to be received. To know which sockets are ready, use the
     * isReady function. If you use a timeout and no socket is ready before the
     * timeout is over, the function returns false.
     *
     * Parameters
     * 		timeout = Maximum time to wait, (use Time::Zero for infinity)
     *
     * Returns: true if there are sockets ready, false otherwise.
     */
    bool wait(Duration timeout = Duration.zero())
    {
        return (sfSocketSelector_wait(sfPtr, timeout.total!"usecs"));
    }
}

unittest
{
    version(DSFML_Unittest_Network)
    {
        import std.stdio;
        import dsfml.network.ipaddress;


        writeln("Unittest for SocketSelector");

        auto selector = new SocketSelector();

        //get a listener and start listening to a new port
        auto listener = new TcpListener();
        listener.listen(55004);

        //add the listener to the selector
        selector.add(listener);

        //The client tries to connect to the server
        auto clientSocket = new TcpSocket();
        clientSocket.connect(IpAddress.LocalHost, 55004);


        //wait for the selector to be informed of new things!
        selector.wait();

        auto serverSocket = new TcpSocket();
        //the listener is ready! New connections are available
        if(selector.isReady(listener))
        {
            writeln("Accepted the connection.");
            listener.accept(serverSocket);
        }

        writeln();
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
