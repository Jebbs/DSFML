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
#include <DSFMLC/Network/Packet.h>
#include <DSFMLC/Network/PacketStruct.h>


////////////////////////////////////////////////////////////
sfPacket* sfPacket_create(void)
{
    return new sfPacket;
}


sfPacket* sfPacket_copy(const sfPacket* packet)
{
    return new sfPacket(*packet);
}


void sfPacket_destroy(sfPacket* packet)
{
    delete packet;
}



void sfPacket_append(sfPacket* packet, const void* data, size_t sizeInBytes)
{
    packet->This.append(data, sizeInBytes);
}


////////////////////////////////////////////////////////////
void sfPacket_clear(sfPacket* packet)
{
    packet->This.clear();
}


////////////////////////////////////////////////////////////
const void* sfPacket_getData(const sfPacket* packet)
{
   return packet->This.getData();
}


////////////////////////////////////////////////////////////
size_t sfPacket_getDataSize(const sfPacket* packet)
{
    return packet->This.getDataSize();
}


////////////////////////////////////////////////////////////
DBool sfPacket_endOfPacket(const sfPacket* packet)
{
    return packet->This.endOfPacket()?DTrue:DFalse;
}


////////////////////////////////////////////////////////////
DBool sfPacket_canRead(const sfPacket* packet)
{
    return packet->This ? DTrue : DFalse;
}


////////////////////////////////////////////////////////////
DBool sfPacket_readBool(sfPacket* packet)
{
    return sfPacket_readUint8(packet);
}
DByte sfPacket_readInt8(sfPacket* packet)
{
    DByte value;
    packet->This >> value;
    return value;
}
DUbyte sfPacket_readUint8(sfPacket* packet)
{
    DUbyte value;
    packet->This >> value;
    return value;
}
DShort sfPacket_readInt16(sfPacket* packet)
{
    DShort value;
    packet->This >> value;
    return value;
}
DUshort sfPacket_readUint16(sfPacket* packet)
{
    DUshort value;
    packet->This >> value;
    return value;
}
DInt sfPacket_readInt32(sfPacket* packet)
{
    DInt value;
    packet->This >> value;
    return value;
}
DUint sfPacket_readUint32(sfPacket* packet)
{
    DInt value;
    packet->This >> value;
    return value;
}

DLong sfPacket_readInt64(sfPacket* packet)
{
	DLong value;
	packet->This >> value;
	return value;
}

DUlong sfPacket_readUint64(sfPacket* packet)
{
	DUlong value;
	packet->This >> value;
	return value;
}

float sfPacket_readFloat(sfPacket* packet)
{
    float value;
    packet->This >> value;
    return value;
}
double sfPacket_readDouble(sfPacket* packet)
{
    double value;
    packet->This >> value;
    return value;
}




////////////////////////////////////////////////////////////
void sfPacket_writeBool(sfPacket* packet, DBool value)
{
    sfPacket_writeUint8(packet, value ? 1 : 0);
}
void sfPacket_writeInt8(sfPacket* packet, DByte value)
{
    packet->This << value;
}
void sfPacket_writeUint8(sfPacket* packet, DUbyte value)
{
    packet->This << value;
}
void sfPacket_writeInt16(sfPacket* packet, DShort value)
{
    packet->This << value;
}
void sfPacket_writeUint16(sfPacket* packet, DUshort value)
{
    packet->This << value;
}
void sfPacket_writeInt32(sfPacket* packet, DInt value)
{
    packet->This << value;
}
void sfPacket_writeUint64(sfPacket* packet, DUint value)
{
    packet->This << value;
}
void sfPacket_writeInt64(sfPacket* packet, DLong value)
{
    packet->This << value;
}
void sfPacket_writeUint32(sfPacket* packet, DUlong value)
{
    packet->This << value;
}
void sfPacket_writeFloat(sfPacket* packet, float value)
{
    packet->This << value;
}
void sfPacket_writeDouble(sfPacket* packet, double value)
{
    packet->This << value;
}

