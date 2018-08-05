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

#include <DSFMLC/Network/TcpListener.h>
#include <DSFMLC/Network/TcpListenerStruct.h>
#include <DSFMLC/Network/TcpSocketStruct.h>

sfTcpListener* sfTcpListener_create(void)
{
    return new sfTcpListener;
}

void sfTcpListener_destroy(sfTcpListener* listener)
{
    delete listener;
}

void sfTcpListener_setBlocking(sfTcpListener* listener, DBool blocking)
{
    listener->This.setBlocking(blocking == DTrue);
}

DBool sfTcpListener_isBlocking(const sfTcpListener* listener)
{
    return listener->This.isBlocking()?DTrue: DFalse;
}

DUshort sfTcpListener_getLocalPort(const sfTcpListener* listener)
{
    return listener->This.getLocalPort();
}

DInt sfTcpListener_listen(sfTcpListener* listener,DUshort port, const sf::IpAddress* address)
{
    return listener->This.listen(port, *address);
}

DInt sfTcpListener_accept(sfTcpListener* listener, sfTcpSocket* connected)
{
    sf::Socket::Status status = listener->This.accept(connected->This);

    return status;
}
