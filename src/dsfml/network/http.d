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

/**
 * The Http class is a very simple HTTP client that allows you to communicate
 * with a web server. You can retrieve web pages, send data to an interactive
 * resource, download a remote file, etc. The HTTPS protocol is not supported.
 *
 * The HTTP client is split into 3 classes:
 * $(UL
 * $(LI Http.Request)
 * $(LI Http.Response)
 * $(LI Http))
 *
 * $(PARA Http.Request builds the request that will be sent to the server. A
 * request is made of:)
 * $(UL
 * $(LI a method (what you want to do))
 * $(LI a target URI (usually the name of the web page or file))
 * $(LI one or more header fields (options that you can pass to the server))
 * $(LI an optional body (for POST requests)))
 *
 * $(PARA Http.Response parses the response from the web server and provides
 * getters to read them. The response contains:)
 * $(UL
 * $(LI a status code)
 * $(LI header fields (that may be answers to the ones that you requested))
 * $(LI a body, which contains the contents of the requested resource))
 *
 * $(PARA $(U Http) provides a simple function, `sendRequest`, to send a
 * Http.Request and return the corresponding Http.Response from the server.)
 *
 * Example:
 * ---
 * // Create a new HTTP client
 * auto http = new Http();
 *
 * // We'll work on http://www.sfml-dev.org
 * http.setHost("http://www.sfml-dev.org");
 *
 * // Prepare a request to get the 'features.php' page
 * auto request = new Http.Request("features.php");
 *
 * // Send the request
 * auto response = http.sendRequest(request);
 *
 * // Check the status code and display the result
 * auto status = response.getStatus();
 * if (status == Http.Response.Status.Ok)
 * {
 *     writeln(response.getBody());
 * }
 * else
 * {
 *     writeln("Error ", status);
 * }
 * ---
 */
module dsfml.network.http;

import core.time;

/**
 * An HTTP client.
 */
class Http
{
    package sfHttp* sfPtr;

    ///Default constructor
    this()
    {
        sfPtr = sfHttp_create();
    }

    /**
     * Construct the HTTP client with the target host.
     *
     * This is equivalent to calling `setHost(host, port)`. The port has a
     * default value of 0, which means that the HTTP client will use the right
     * port according to the protocol used (80 for HTTP, 443 for HTTPS). You
     * should leave it like this unless you really need a port other than the
     * standard one, or use an unknown protocol.
     *
     * Params:
     * 		host = Web server to connect to
     * 		port = Port to use for connection
     */
    this(string host, ushort port = 0)
    {
        import dsfml.system.string;
        sfPtr = sfHttp_create();
        sfHttp_setHost(sfPtr, host.ptr, host.length ,port);
    }

    ///Destructor
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfHttp_destroy(sfPtr);
    }

    /**
     * Set the target host.
     *
     * This function just stores the host address and port, it doesn't actually
     * connect to it until you send a request. The port has a default value of
     * 0, which means that the HTTP client will use the right port according to
     * the protocol used (80 for HTTP, 443 for HTTPS). You should leave it like
     * this unless you really need a port other than the standard one, or use an
     * unknown protocol.
     *
     * Params:
     * 		host = Web server to connect to
     * 		port = Port to use for connection
     */
    void setHost(string host, ushort port = 0)
    {
        import dsfml.system.string;
        sfHttp_setHost(sfPtr, host.ptr, host.length,port);
    }

    /**
     * Send a HTTP request and return the server's response.
     *
     * You must have a valid host before sending a request (see setHost). Any
     * missing mandatory header field in the request will be added with an
     * appropriate value. Warning: this function waits for the server's response
     * and may not return instantly; use a thread if you don't want to block
     * your application, or use a timeout to limit the time to wait. A value of
     * Duration.Zero means that the client will use the system defaut timeout
     * (which is usually pretty long).
     *
     * Params:
     * 		request = Request to send
     * 		timeout = Maximum time to wait
     */
    Response sendRequest(Request request, Duration timeout = Duration.zero())
    {
        return new Response(sfHttp_sendRequest(sfPtr,request.sfPtrRequest,timeout.total!"usecs"));
    }

    /// Define a HTTP request.
    static class Request
    {
        /// Enumerate the available HTTP methods for a request.
        enum Method
        {
            /// Request in get mode, standard method to retrieve a page.
            Get,
            /// Request in post mode, usually to send data to a page.
            Post,
            /// Request a page's header only.
            Head,
            /// Request in put mode, useful for a REST API
            Put,
            /// Request in delete mode, useful for a REST API
            Delete
        }

        package sfHttpRequest* sfPtrRequest;

        /**
         * This constructor creates a GET request, with the root URI ("/") and
         * an empty body.
         *
         * Params:
         * 	uri    = Target URI
         * 	method = Method to use for the request
         * 	requestBody   = Content of the request's body
         */
        this(string uri = "/", Method method = Method.Get, string requestBody = "")
        {
            import dsfml.system.string;
            sfPtrRequest = sfHttpRequest_create();
            sfHttpRequest_setUri(sfPtrRequest, uri.ptr, uri.length);
            sfHttpRequest_setMethod(sfPtrRequest, method);
            sfHttpRequest_setBody(sfPtrRequest, requestBody.ptr, requestBody.length);
        }

        /// Destructor
        ~this()
        {
            import std.stdio;
            writeln("Destroying HTTP Request");
            sfHttpRequest_destroy(sfPtrRequest);
        }

        /**
         * Set the body of the request.
         *
         * The body of a request is optional and only makes sense for POST
         * requests. It is ignored for all other methods. The body is empty by
         * default.
         *
         * Params:
         * 		requestBody = Content of the body
         */
        void setBody(string requestBody)
        {
            import dsfml.system.string;
            sfHttpRequest_setBody(sfPtrRequest, requestBody.ptr, requestBody.length);
        }

        /**
         * Set the value of a field.
         *
         * The field is created if it doesn't exist. The name of the field is
         * case insensitive. By default, a request doesn't contain any field
         * (but the mandatory fields are added later by the HTTP client when
         * sending the request).
         *
         * Params:
         * 	field = Name of the field to set
         * 	value = Value of the field
         */
        void setField(string field, string value)
        {
            import dsfml.system.string;
            sfHttpRequest_setField(sfPtrRequest, field.ptr, field.length , value.ptr, value.length);
        }

        /**
         * Set the HTTP version for the request.
         *
         * The HTTP version is 1.0 by default.
         *
         * Parameters
         * 	major = Major HTTP version number
         * 	minor = Minor HTTP version number
         */
        void setHttpVersion(uint major, uint minor)
        {
            sfHttpRequest_setHttpVersion(sfPtrRequest,major, minor);
        }

        /**
         * Set the request method.
         *
         * See the Method enumeration for a complete list of all the availale
         * methods. The method is Http.Request.Method.Get by default.
         *
         * Params
         * 	method = Method to use for the request
         */
        void setMethod(Method method)
        {
            sfHttpRequest_setMethod(sfPtrRequest,method);
        }

        /**
         * Set the requested URI.
         *
         * The URI is the resource (usually a web page or a file) that you want
         * to get or post. The URI is "/" (the root page) by default.
         *
         * Params
         * 	uri = URI to request, relative to the host
         */
        void setUri(string uri)
        {
            import dsfml.system.string;
            sfHttpRequest_setUri(sfPtrRequest, uri.ptr, uri.length);
        }
    }

    /// Define a HTTP response.
    class Response
    {
        /// Enumerate all the valid status codes for a response.
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

        package sfHttpResponse* sfPtrResponse;

        //Internally used constructor
        package this(sfHttpResponse* response)
        {
            sfPtrResponse = response;
        }

        /**
         * Get the body of the response.
         *
         * Returns: The response body.
         */
        string getBody()
        {
            import dsfml.system.string;
            return dsfml.system.string.toString(sfHttpResponse_getBody(sfPtrResponse));
        }

        /**
         * Get the value of a field.
         *
         * If the field field is not found in the response header, the empty
         * string is returned. This function uses case-insensitive comparisons.
         *
         * Params:
         * 	field = Name of the field to get
         *
         * Returns: Value of the field, or empty string if not found.
         */
        string getField(const(char)[] field)
        {
            import dsfml.system.string;
            return dsfml.system.string.toString(sfHttpResponse_getField(sfPtrResponse, field.ptr, field.length));
        }

        /**
         * Get the major HTTP version number of the response.
         *
         * Returns: Major HTTP version number.
         */
        uint getMajorHttpVersion()
        {
            return sfHttpResponse_getMajorVersion(sfPtrResponse);
        }

        /**
         * Get the minor HTTP version number of the response.
         *
         * Returns: Minor HTTP version number.
         */
        uint getMinorHttpVersion()
        {
            return sfHttpResponse_getMinorVersion(sfPtrResponse);
        }

        /**
         * Get the response status code.
         *
         * The status code should be the first thing to be checked after
         * receiving a response, it defines whether it is a success, a failure
         * or anything else (see the Status enumeration).
         *
         * Returns: Status code of the response.
         */
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
        auto request = new Http.Request("learn.php");

        // Send the request
        auto response = http.sendRequest(request);

        // Check the status code and display the result
        auto status = response.getStatus();

        if (status == Http.Response.Status.Ok)
        {
            writeln("Found the site!");
        }
        else
        {
            writeln("Error: ", status);
        }
        writeln();
    }
}

private extern(C):

struct sfHttpRequest;
struct sfHttpResponse;
struct sfHttp;

//Create a new HTTP request
sfHttpRequest* sfHttpRequest_create();

//Destroy a HTTP request
void sfHttpRequest_destroy(sfHttpRequest* httpRequest);

//Set the value of a header field of a HTTP request
void sfHttpRequest_setField(sfHttpRequest* httpRequest, const(char)* field, size_t fieldLength, const(char)* value, size_t valueLength);

//Set a HTTP request method
void sfHttpRequest_setMethod(sfHttpRequest* httpRequest, int method);

//Set a HTTP request URI
void sfHttpRequest_setUri(sfHttpRequest* httpRequest, const(char)* uri, size_t length);

//Set the HTTP version of a HTTP request
void sfHttpRequest_setHttpVersion(sfHttpRequest* httpRequest,uint major, uint minor);

//Set the body of a HTTP request
void sfHttpRequest_setBody(sfHttpRequest* httpRequest, const(char)* ody, size_t length);

//HTTP Response Functions

//Destroy a HTTP response
void sfHttpResponse_destroy(sfHttpResponse* httpResponse);

//Get the value of a field of a HTTP response
const(char)* sfHttpResponse_getField(const sfHttpResponse* httpResponse, const(char)* field, size_t length);

//Get the status code of a HTTP reponse
Http.Response.Status sfHttpResponse_getStatus(const sfHttpResponse* httpResponse);

//Get the major HTTP version number of a HTTP response
uint sfHttpResponse_getMajorVersion(const sfHttpResponse* httpResponse);

//Get the minor HTTP version number of a HTTP response
uint sfHttpResponse_getMinorVersion(const sfHttpResponse* httpResponse);

//Get the body of a HTTP response
const(char)* sfHttpResponse_getBody(const sfHttpResponse* httpResponse);

//HTTP Functions

//Create a new Http object
sfHttp* sfHttp_create();

//Destroy a Http object
void sfHttp_destroy(sfHttp* http);

//Set the target host of a HTTP object
void sfHttp_setHost(sfHttp* http, const(char)* host, size_t length, ushort port);

//Send a HTTP request and return the server's response.
sfHttpResponse* sfHttp_sendRequest(sfHttp* http, const(sfHttpRequest)* request, long timeout);
