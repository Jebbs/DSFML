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


***All code is based on Laurent Gomila's SFML library.***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML
*/


// Headers
#include <SFML/Network/TcpListener.h>
#include <SFML/Network/TcpListenerStruct.h>
#include <SFML/Network/TcpSocketStruct.h>
#include <SFML/Internal.h>


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
    CSFML_CALL(listener, setBlocking(blocking == DTrue));
}


DBool sfTcpListener_isBlocking(const sfTcpListener* listener)
{
    CSFML_CALL_RETURN(listener, isBlocking(), DFalse);
}



DUshort sfTcpListener_getLocalPort(const sfTcpListener* listener)
{
    CSFML_CALL_RETURN(listener, getLocalPort(), 0);
}


////////////////////////////////////////////////////////////
DInt sfTcpListener_listen(sfTcpListener* listener,DUshort port)
{
    CSFML_CHECK_RETURN(listener, sfSocketError);

    return listener->This.listen(port);
}


////////////////////////////////////////////////////////////
DInt sfTcpListener_accept(sfTcpListener* listener, sfTcpSocket** connected)
{
    CSFML_CHECK_RETURN(listener, sfSocketError);
    CSFML_CHECK_RETURN(connected, sfSocketError);

    *connected = new sfTcpSocket;
    return listener->This.accept((*connected)->This);
}
