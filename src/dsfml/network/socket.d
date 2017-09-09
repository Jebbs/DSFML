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
 * This class mainly defines internal stuff to be used by derived classes.
 *
 * The only public features that it defines, and which is therefore common to
 * all the socket classes, is the blocking state. All sockets can be set as
 * blocking or non-blocking.
 *
 * In blocking mode, socket functions will hang until the operation completes,
 * which means that the entire program (well, in fact the current thread if you
 * use multiple ones) will be stuck waiting for your socket operation to
 * complete.
 *
 * In non-blocking mode, all the socket functions will return immediately. If
 * the socket is not ready to complete the requested operation, the function
 * simply returns the proper status code (Socket.Status.NotReady).
 *
 * The default mode, which is blocking, is the one that is generally used, in
 * combination with threads or selectors. The non-blocking mode is rather used
 * in real-time applications that run an endless loop that can poll the socket
 * often enough, and cannot afford blocking this loop.
 *
 * See_Also:
 * $(TCPLISTENER_LINK), $(TCPSOCKET_LINK), $(UDPSOCKET_LINK)
 */
module dsfml.network.socket;

/// Base interface for all the socket types.
interface Socket
{
    //TODO: Add methods to this so that they can be overridden by the socket classes?

    ///Status codes that may be returned by socket functions.
    enum Status
    {
        /// The socket has sent / received the data
        Done,
        /// The socket is not ready to send / receive data yet
        NotReady,
        /// The TCP socket has been disconnected
        Disconnected,
        /// An unexpected error happened
        Error
    }

    /// Special value that tells the system to pick any available port.
    enum AnyPort = 0;

    /**
     * Set the blocking state of the socket.
     *
     * In blocking mode, calls will not return until they have completed their
     * task. For example, a call to `receive` in blocking mode won't return
     * until some data was actually received.
     *
     * In non-blocking mode, calls will
     * always return immediately, using the return code to signal whether there
     * was data available or not. By default, all sockets are blocking.
     *
     * By default, all sockets are blocking.
     *
     * Params:
     * blocking = true to set the socket as blocking, false for non-blocking
     */
    void setBlocking(bool blocking);

    /**
     * Tell whether the socket is in blocking or non-blocking mode.
     *
     * Returns: true if the socket is blocking, false otherwise.
     */
    bool isBlocking() const;
}

