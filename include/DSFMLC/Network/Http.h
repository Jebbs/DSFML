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

#ifndef DSFML_HTTP_H
#define DSFML_HTTP_H

#include <DSFMLC/Network/Export.h>
#include <DSFMLC/Network/Types.h>
#include <stddef.h>

///HTTP Request Functions

//Create a new HTTP request
DSFML_NETWORK_API sfHttpRequest* sfHttpRequest_create(void);

//Destroy a HTTP request
DSFML_NETWORK_API void sfHttpRequest_destroy(sfHttpRequest* httpRequest);

//Set the value of a header field of a HTTP request
DSFML_NETWORK_API void sfHttpRequest_setField(sfHttpRequest* httpRequest, const char* field, size_t fieldLength, const char* value, size_t valueLength);

//Set a HTTP request method
DSFML_NETWORK_API void sfHttpRequest_setMethod(sfHttpRequest* httpRequest, DInt method);

//Set a HTTP request URI
DSFML_NETWORK_API void sfHttpRequest_setUri(sfHttpRequest* httpRequest, const char* uri, size_t length);

//Set the HTTP version of a HTTP request
DSFML_NETWORK_API void sfHttpRequest_setHttpVersion(sfHttpRequest* httpRequest, DUint major, DUint minor);

//Set the body of a HTTP request
DSFML_NETWORK_API void sfHttpRequest_setBody(sfHttpRequest* httpRequest, const char* body, size_t length);

///HTTP Response Functions

//Destroy a HTTP response
DSFML_NETWORK_API void sfHttpResponse_destroy(sfHttpResponse* httpResponse);

//Get the value of a field of a HTTP response
DSFML_NETWORK_API const char* sfHttpResponse_getField(const sfHttpResponse* httpResponse, const char* field, size_t fieldlength);

//Get the status code of a HTTP reponse
DSFML_NETWORK_API DInt sfHttpResponse_getStatus(const sfHttpResponse* httpResponse);

//Get the major HTTP version number of a HTTP response
DSFML_NETWORK_API DUint sfHttpResponse_getMajorVersion(const sfHttpResponse* httpResponse);

//Get the minor HTTP version number of a HTTP response
DSFML_NETWORK_API DUint sfHttpResponse_getMinorVersion(const sfHttpResponse* httpResponse);

//Get the body of a HTTP response
DSFML_NETWORK_API const char* sfHttpResponse_getBody(const sfHttpResponse* httpResponse);

///HTTP Functions

//Create a new Http object
DSFML_NETWORK_API sfHttp* sfHttp_create(void);

//Destroy a Http object
DSFML_NETWORK_API void sfHttp_destroy(sfHttp* http);

//Set the target host of a HTTP object
DSFML_NETWORK_API void sfHttp_setHost(sfHttp* http, const char* host, size_t length,DUshort port);

//Send a HTTP request and return the server's response.
DSFML_NETWORK_API sfHttpResponse* sfHttp_sendRequest(sfHttp* http, const sfHttpRequest* request, DLong timeout);

#endif // DSFML_HTTP_H
