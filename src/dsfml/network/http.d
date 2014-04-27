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


***All code is based on code written by Laurent Gomila***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML - For a full list see http://www.sfml-dev.org/license.php
*/

module dsfml.network.http;

import dsfml.system.time;
import std.string;


class Http
{
	sfHttp* sfPtr;
	
	this()
	{
		sfPtr = sfHttp_create();
	}
	
	this(string host, ushort port = 0)
	{
		sfPtr = sfHttp_create();
		sfHttp_setHost(sfPtr, toStringz(host),port);
	}
	
	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfHttp_destroy(sfPtr);
	}
	
	void setHost(string host, ushort port = 0)
	{
		sfHttp_setHost(sfPtr, toStringz(host),port);
	}
	
	Response sendRequest(Request request, Time timeout = Time.Zero)
	{
		return new Response(sfHttp_sendRequest(sfPtr,request.sfPtrRequest,timeout.asMicroseconds()));
	}
	
	static class Request
	{
		enum Method
		{
			Get,
			Post,
			Head
		}

		sfHttpRequest* sfPtrRequest;

		this(string uri = "/", Method method = Method.Get, string requestBody = "")
		{
			sfPtrRequest = sfHttpRequest_create();
			sfHttpRequest_setUri(sfPtrRequest, toStringz(uri));
			sfHttpRequest_setMethod(sfPtrRequest, method);
			sfHttpRequest_setBody(sfPtrRequest,toStringz(requestBody));
		}
		
		~this()
		{
			debug import std.stdio;
			debug writeln("Destroying HTTP Request");
			sfHttpRequest_destroy(sfPtrRequest);
		}

		void setBody(string requestBody)
		{
			sfHttpRequest_setBody(sfPtrRequest,toStringz(requestBody));
		}

		void setField(string feild, string value)
		{
			sfHttpRequest_setField(sfPtrRequest,toStringz(feild),toStringz(value));
		}

		void setHttpVersion(uint major, uint minor)
		{
			sfHttpRequest_setHttpVersion(sfPtrRequest,major, minor);
		}

		void setMethod(Method method)
		{
			sfHttpRequest_setMethod(sfPtrRequest,method);
		}
		
		void setUri(string uri)
		{
			sfHttpRequest_setUri(sfPtrRequest,toStringz(uri));
		}
	}
	
	class Response
	{
		enum Status
		{
			Ok = 200,
			Created = 201,
			Accepted = 202,
			NoContent = 204,
			ResetContent = 205,
			PartialContent = 206,
			MultipleChoices = 300,
			MovedPermanently = 301,
			MovedTemporarily = 302,
			NotModified = 304,
			BadRequest = 400,
			Unauthorized = 401,
			Forbidden = 403,
			NotFound = 404,
			RangeNotSatisfiable = 407,
			InternalServerError = 500,
			NotImplemented = 501,
			BadGateway = 502,
			ServiceNotAvailable = 503,
			GatewayTimeout = 504,
			VersionNotSupported = 505,
			InvalidResponse = 1000,
			ConnectionFailed = 1001
			
		}

		sfHttpResponse* sfPtrResponse;

		package this(sfHttpResponse* response)
		{
			sfPtrResponse = response;
		}

		string getBody()
		{
			import std.conv;
			return sfHttpResponse_getBody(sfPtrResponse).to!string();
		}

		string getField(string field)
		{
			import std.conv;
			return (sfHttpResponse_getField(sfPtrResponse,toStringz(field))).to!string();
		}

		uint getMajorHttpVersion()
		{
			return sfHttpResponse_getMajorVersion(sfPtrResponse);
		}
		
		uint getMinorHttpVersion()
		{
			return sfHttpResponse_getMinorVersion(sfPtrResponse);
		}
		
		Status getStatus()
		{
			return sfHttpResponse_getStatus(sfPtrResponse);
		}
	}
}

unittest
{
	version(DSFML_Unittest_Network)
	{
		import std.stdio;
		
		writeln("Unittest for Http");

		auto http = new Http();

		http.setHost("http://www.sfml-dev.org");
		
		// Prepare a request to get the 'features.php' page
		auto request = new Http.Request("resources.php");

		// Send the request
		auto response = http.sendRequest(request);

		// Check the status code and display the result
		auto status = response.getStatus();

		if (status == Http.Response.Status.Ok)
		{
			writeln(response.getBody());
		}
		else
		{
			writeln("Error ", status);
		}   
		writeln();
	}
}

private extern(C):

struct sfHttpRequest;
struct sfHttpResponse;
struct sfHttp;

///Create a new HTTP request
sfHttpRequest* sfHttpRequest_create();
	
	
///Destroy a HTTP request
void sfHttpRequest_destroy(sfHttpRequest* httpRequest);
	
	
///Set the value of a header field of a HTTP request
void sfHttpRequest_setField(sfHttpRequest* httpRequest, const(char)* field, const(char)* value);
	
	
///Set a HTTP request method
void sfHttpRequest_setMethod(sfHttpRequest* httpRequest, int method);
	
	
///Set a HTTP request URI
void sfHttpRequest_setUri(sfHttpRequest* httpRequest, const(char)* uri);
	
	
///Set the HTTP version of a HTTP request
void sfHttpRequest_setHttpVersion(sfHttpRequest* httpRequest,uint major, uint minor);
	
	
///Set the body of a HTTP request
void sfHttpRequest_setBody(sfHttpRequest* httpRequest, const(char)* ody);
	
	
//HTTP Response Functions
	
///Destroy a HTTP response
void sfHttpResponse_destroy(sfHttpResponse* httpResponse);
	
	
///Get the value of a field of a HTTP response
const(char)* sfHttpResponse_getField(const sfHttpResponse* httpResponse, const(char)* field);
	
	
///Get the status code of a HTTP reponse
Http.Response.Status sfHttpResponse_getStatus(const sfHttpResponse* httpResponse);
	
	
///Get the major HTTP version number of a HTTP response
uint sfHttpResponse_getMajorVersion(const sfHttpResponse* httpResponse);
	
	
///Get the minor HTTP version number of a HTTP response
uint sfHttpResponse_getMinorVersion(const sfHttpResponse* httpResponse);
	
	
///Get the body of a HTTP response
const(char)* sfHttpResponse_getBody(const sfHttpResponse* httpResponse);
	
	
//HTTP Functions
	
///Create a new Http object
sfHttp* sfHttp_create();
	
	
///Destroy a Http object
void sfHttp_destroy(sfHttp* http);
	
	
///Set the target host of a HTTP object
void sfHttp_setHost(sfHttp* http, const(char)* host, ushort port);
	
	
///Send a HTTP request and return the server's response.
sfHttpResponse* sfHttp_sendRequest(sfHttp* http, const(sfHttpRequest)* request, long timeout);


