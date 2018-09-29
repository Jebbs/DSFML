/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
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
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

#ifndef DSFML_TCPLISTENER_H
#define DSFML_TCPLISTENER_H

#include <DSFMLC/Network/Export.h>
#include <DSFMLC/Network/Types.h>
#include <SFML/Network/IpAddress.hpp>

//Create a new TCP listener
DSFML_NETWORK_API sfTcpListener* sfTcpListener_create(void);

//Destroy a TCP listener
DSFML_NETWORK_API void sfTcpListener_destroy(sfTcpListener* listener);

//Set the blocking state of a TCP listener
DSFML_NETWORK_API void sfTcpListener_setBlocking(sfTcpListener* listener, DBool blocking);

//Tell whether a TCP listener is in blocking or non-blocking mode
DSFML_NETWORK_API DBool sfTcpListener_isBlocking(const sfTcpListener* listener);

//Get the port to which a TCP listener is bound locally
DSFML_NETWORK_API DUshort sfTcpListener_getLocalPort(const sfTcpListener* listener);

//Start listening for connections
DSFML_NETWORK_API DInt sfTcpListener_listen(sfTcpListener* listener, DUshort port, const sf::IpAddress* address);

//Accept a new connection
DSFML_NETWORK_API DInt sfTcpListener_accept(sfTcpListener* listener, sfTcpSocket* connected);

#endif // DSFML_TCPLISTENER_H
