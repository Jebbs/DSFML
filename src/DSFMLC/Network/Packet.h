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

#ifndef DSFML_PACKET_H
#define DSFML_PACKET_H

#include <DSFMLC/Network/Export.h>
#include <DSFMLC/Network/Types.h>
#include <stddef.h>

//Create a new packet
DSFML_NETWORK_API sfPacket* sfPacket_create(void);

//Create a new packet by copying an existing one
DSFML_NETWORK_API sfPacket* sfPacket_copy(const sfPacket* packet);

//Destroy a packet
DSFML_NETWORK_API void sfPacket_destroy(sfPacket* packet);

//Append data to the end of a packet
DSFML_NETWORK_API void sfPacket_append(sfPacket* packet, const void* data, size_t sizeInBytes);

//Clear a packet
DSFML_NETWORK_API void sfPacket_clear(sfPacket* packet);

//Get a pointer to the data contained in a packet
DSFML_NETWORK_API const void* sfPacket_getData(const sfPacket* packet);

//Get the size of the data contained in a packet
DSFML_NETWORK_API size_t sfPacket_getDataSize(const sfPacket* packet);

//Tell if the reading position has reached the end of a packet
DSFML_NETWORK_API DBool sfPacket_endOfPacket(const sfPacket* packet);

//Test the validity of a packet, for reading
DSFML_NETWORK_API DBool sfPacket_canRead(const sfPacket* packet);

//Functions to extract data from a packet
DSFML_NETWORK_API DBool    sfPacket_readBool(sfPacket* packet);
DSFML_NETWORK_API DByte    sfPacket_readInt8(sfPacket* packet);
DSFML_NETWORK_API DUbyte   sfPacket_readUint8(sfPacket* packet);
DSFML_NETWORK_API DShort   sfPacket_readInt16(sfPacket* packet);
DSFML_NETWORK_API DUshort  sfPacket_readUint16(sfPacket* packet);
DSFML_NETWORK_API DInt     sfPacket_readInt32(sfPacket* packet);
DSFML_NETWORK_API DUint    sfPacket_readUint32(sfPacket* packet);
DSFML_NETWORK_API DLong     sfPacket_readInt64(sfPacket* packet);
DSFML_NETWORK_API DUlong    sfPacket_readUint64(sfPacket* packet);
DSFML_NETWORK_API float    sfPacket_readFloat(sfPacket* packet);
DSFML_NETWORK_API double   sfPacket_readDouble(sfPacket* packet);
//DSFML_NETWORK_API void     sfPacket_readString(sfPacket* packet, char* string);
//DSFML_NETWORK_API void     sfPacket_readWideString(sfPacket* packet, wchar_t* string);//Remove in lieu of readUint16 and readUint32 for W and D chars in D?

//Functions to insert data into a packet
DSFML_NETWORK_API void sfPacket_writeBool(sfPacket* packet, DBool);
DSFML_NETWORK_API void sfPacket_writeInt8(sfPacket* packet, DByte);
DSFML_NETWORK_API void sfPacket_writeUint8(sfPacket* packet, DUbyte);
DSFML_NETWORK_API void sfPacket_writeInt16(sfPacket* packet, DShort);
DSFML_NETWORK_API void sfPacket_writeUint16(sfPacket* packet, DUshort);
DSFML_NETWORK_API void sfPacket_writeInt32(sfPacket* packet, DInt);
DSFML_NETWORK_API void sfPacket_writeUint32(sfPacket* packet, DUint);
DSFML_NETWORK_API void sfPacket_writeInt64(sfPacket* packet, DLong);
DSFML_NETWORK_API void sfPacket_writeUint64(sfPacket* packet, DUlong);
DSFML_NETWORK_API void sfPacket_writeFloat(sfPacket* packet, float);
DSFML_NETWORK_API void sfPacket_writeDouble(sfPacket* packet, double);
//DSFML_NETWORK_API void sfPacket_writeString(sfPacket* packet, const char* string);
//DSFML_NETWORK_API void sfPacket_writeWideString(sfPacket* packet, const wchar_t* string);//Remove in lieu of readUint16 and readUint32 for W and D chars in D?

#endif // DSFML_PACKET_H
