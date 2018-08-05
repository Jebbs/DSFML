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

#include <DSFMLC/Network/Http.h>
#include <DSFMLC/Network/HttpStruct.h>

///HTTP Request Functions

sfHttpRequest* sfHttpRequest_create(void)
{
    return new sfHttpRequest;
}

void sfHttpRequest_destroy(sfHttpRequest* httpRequest)
{
    delete httpRequest;
}

void sfHttpRequest_setField(sfHttpRequest* httpRequest, const char* field, size_t fieldLength, const char* value, size_t valueLength)
{
    if (field)
        httpRequest->This.setField(std::string(field, fieldLength), std::string(value, valueLength));
}

void sfHttpRequest_setMethod(sfHttpRequest* httpRequest, DInt method)
{
    httpRequest->This.setMethod(static_cast<sf::Http::Request::Method>(method));
}

void sfHttpRequest_setUri(sfHttpRequest* httpRequest, const char* uri, size_t length)
{
    httpRequest->This.setUri(uri ? std::string(uri, length) : "");
}

void sfHttpRequest_setHttpVersion(sfHttpRequest* httpRequest, DUint major, DUint minor)
{
    httpRequest->This.setHttpVersion(major, minor);
}

void sfHttpRequest_setBody(sfHttpRequest* httpRequest, const char* body, size_t length)
{
    httpRequest->This.setBody(body ? std::string(body, length) : "");
}

///HTTP Response Functions

void sfHttpResponse_destroy(sfHttpResponse* httpResponse)
{
    delete httpResponse;
}

const char* sfHttpResponse_getField(const sfHttpResponse* httpResponse, const char* field, size_t length)
{
    if (!field)
        return NULL;

    return httpResponse->This.getField(std::string(field, length)).c_str();
}

DInt sfHttpResponse_getStatus(const sfHttpResponse* httpResponse)
{
    return httpResponse->This.getStatus();
}

DUint sfHttpResponse_getMajorVersion(const sfHttpResponse* httpResponse)
{
   return httpResponse->This.getMajorHttpVersion();
}

DUint sfHttpResponse_getMinorVersion(const sfHttpResponse* httpResponse)
{
    return httpResponse->This.getMinorHttpVersion();
}

const char* sfHttpResponse_getBody(const sfHttpResponse* httpResponse)
{

    return httpResponse->This.getBody().c_str();
}

///HTTP Functions

sfHttp* sfHttp_create(void)
{
    return new sfHttp;
}

void sfHttp_destroy(sfHttp* http)
{
    delete http;
}

void sfHttp_setHost(sfHttp* http, const char* host, size_t length, DUshort port)
{
    http->This.setHost(host ? std::string(host, length) : "", port);
}

sfHttpResponse* sfHttp_sendRequest(sfHttp* http, const sfHttpRequest* request, DLong timeout)
{
    sfHttpResponse* response = new sfHttpResponse;
    response->This = http->This.sendRequest(request->This, sf::microseconds(timeout));

    return response;
}
