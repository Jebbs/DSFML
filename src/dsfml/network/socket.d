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

/// A module contianing the Socket abstract class
module dsfml.network.socket;

/// Base class for all the socket types.
abstract class Socket
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
}

