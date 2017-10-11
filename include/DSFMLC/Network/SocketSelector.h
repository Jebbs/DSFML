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

#ifndef DSFML_SOCKETSELECTOR_H
#define DSFML_SOCKETSELECTOR_H

// Headers
#include <DSFMLC/Network/Export.h>
#include <DSFMLC/Network/Types.h>



//Create a new selector
DSFML_NETWORK_API sfSocketSelector* sfSocketSelector_create(void);

//Create a new socket selector by copying an existing one
DSFML_NETWORK_API sfSocketSelector* sfSocketSelector_copy(const sfSocketSelector* selector);


//Destroy a socket selector
DSFML_NETWORK_API void sfSocketSelector_destroy(sfSocketSelector* selector);


//Add a new socket to a socket selector
DSFML_NETWORK_API void sfSocketSelector_addTcpListener(sfSocketSelector* selector, sfTcpListener* socket);
DSFML_NETWORK_API void sfSocketSelector_addTcpSocket(sfSocketSelector* selector, sfTcpSocket* socket);
DSFML_NETWORK_API void sfSocketSelector_addUdpSocket(sfSocketSelector* selector, sfUdpSocket* socket);


//Remove a socket from a socket selector
DSFML_NETWORK_API void sfSocketSelector_removeTcpListener(sfSocketSelector* selector, sfTcpListener* socket);
DSFML_NETWORK_API void sfSocketSelector_removeTcpSocket(sfSocketSelector* selector, sfTcpSocket* socket);
DSFML_NETWORK_API void sfSocketSelector_removeUdpSocket(sfSocketSelector* selector, sfUdpSocket* socket);


//Remove all the sockets stored in a selector
DSFML_NETWORK_API void sfSocketSelector_clear(sfSocketSelector* selector);


//Wait until one or more sockets are ready to receive
DSFML_NETWORK_API DBool sfSocketSelector_wait(sfSocketSelector* selector, DLong timeout);


//Test a socket to know if it is ready to receive data
DSFML_NETWORK_API DBool sfSocketSelector_isTcpListenerReady(const sfSocketSelector* selector, sfTcpListener* socket);
DSFML_NETWORK_API DBool sfSocketSelector_isTcpSocketReady(const sfSocketSelector* selector, sfTcpSocket* socket);
DSFML_NETWORK_API DBool sfSocketSelector_isUdpSocketReady(const sfSocketSelector* selector, sfUdpSocket* socket);


#endif // DSFML_SOCKETSELECTOR_H
