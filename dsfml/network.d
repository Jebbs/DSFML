/*
Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty. 
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications, 
and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
*/

module dsfml.network;
import std.string;
import std.conv;
import std.utf;

debug import std.stdio;

public 
{
	import dsfml.system;
}


class Ftp
{
	enum TransferMode
	{
		Binary,
		Ascii,
		Ebcdic,
	}

	sfFtp* sfPtr;

	this()
	{
		sfPtr = sfFtp_create();
	}
	~this()
	{
		debug writeln("Destroying FTP");
		sfFtp_destroy(sfPtr);
	}

	Response connect(IpAddress address, ushort port = 21, Time timeout = Time.Zero)
	{
		return new Response(sfFtp_connect(sfPtr, address.InternalsfIpAddress,port, timeout.InternalsfTime));
	}

	Response dissconnect()
	{
		return new Response(sfFtp_disconnect(sfPtr));
	}

	Response login()
	{
		return new Response(sfFtp_loginAnonymous(sfPtr));
	}

	Response login(string name, string password)
	{
		return new Response(sfFtp_login(sfPtr,toStringz(name), toStringz(password)));
	}

	Response keepAlive()
	{
		return new Response(sfFtp_keepAlive(sfPtr));
	}

	DirectoryResponse getWorkingDirectory()
	{
		return new DirectoryResponse(sfFtp_getWorkingDirectory(sfPtr));
	}

	ListingResponse getDirectoryListing(string directory = "")
	{
		return new ListingResponse(sfFtp_getDirectoryListing(sfPtr, toStringz(directory)));
	}

	Response changeDirectory(string directory)
	{
		return new Response(sfFtp_changeDirectory(sfPtr,toStringz(directory)));
	}

	Response parentDirectory()
	{
		return new Response(sfFtp_parentDirectory(sfPtr));
	}
	Response createDirectory(string name)
	{
		return new Response(sfFtp_createDirectory(sfPtr, toStringz(name)));
	}

	Response deleteDirectory(string name)
	{
		return new Response(sfFtp_deleteDirectory(sfPtr, toStringz(name)));
	}

	Response renameFile(string name, string newName)
	{
		return new Response(sfFtp_renameFile(sfPtr,toStringz(name),toStringz(newName)));
	}

	Response deleteFile(string name)
	{
		return new Response(sfFtp_deleteFile(sfPtr, toStringz(name)));
	}

	Response download(string remoteFile, string localPath, TransferMode mode = TransferMode.Binary)
	{
		return new Response(sfFtp_download(sfPtr, toStringz(remoteFile),toStringz(localPath),mode));
	}

	Response upload(string localFile, string remotePath, TransferMode mode = TransferMode.Binary)
	{
		return new Response(sfFtp_upload(sfPtr,toStringz(localFile),toStringz(remotePath),mode));
	}


	class DirectoryResponse:Response
	{
		private string Directory;
		package this(sfFtpDirectoryResponse* FtpDirectoryResponce)
		{

			Directory = sfFtpDirectoryResponse_getDirectory(FtpDirectoryResponce).to!string();

			super(sfFtpDirectoryResponse_getStatus(FtpDirectoryResponce), sfFtpDirectoryResponse_getMessage(FtpDirectoryResponce));

			sfFtpDirectoryResponse_destroy(FtpDirectoryResponce);
		}

		string getDirectory()
		{
			return Directory;
		}
		
	}

	class ListingResponse:Response
	{
		private string[] Filenames;
		package this(sfFtpListingResponse* FtpListingResponce)
		{
			Filenames.length = sfFtpListingResponse_getCount(FtpListingResponce);
			for(int i = 0; i < Filenames.length; i++)
			{
				Filenames[i] = text(sfFtpListingResponse_getName(FtpListingResponce,i));
			}

			super(sfFtpListingResponse_getStatus(FtpListingResponce), sfFtpListingResponse_getMessage(FtpListingResponce));

			sfFtpListingResponse_destroy(FtpListingResponce);

		}

		const(string[]) getFilenames()
		{
			return Filenames;
		}
	}

	class Response
	{
		package this(sfFtpResponse* FtpResponce)
		{
			this(sfFtpResponse_getStatus(FtpResponce),sfFtpResponse_getMessage(FtpResponce));
			sfFtpResponse_destroy(FtpResponce);
		}

		package this(Ftp.Response.Status status = Ftp.Response.Status.InvalidResponse,  const(char)* message = "")
		{
			FtpStatus = status;
			Message = message.to!string();
		}


		private Status FtpStatus;
		private string Message;

		enum Status
		{
			RestartMarkerReply = 110,
			ServiceReadySoon = 120,
			DataConnectionAlreadyOpened = 125,
			OpeningDataConnection = 150,
			
			Ok = 200,
			PointlessCommand = 202,
			SystemStatus = 211,
			DirectoryStatus = 212,
			FileStatus = 213,
			HelpMessage = 214,
			SystemType = 215,
			ServiceReady = 220,
			ClosingConnection = 221,
			DataConnectionOpened = 225,
			ClosingDataConnection = 226,
			EnteringPassiveMode = 227,
			LoggedIn = 230,
			FileActionOk = 250,
			DirectoryOk = 257,
			
			NeedPassword = 331,
			NeedAccountToLogIn = 332,
			NeedInformation = 350,
			ServiceUnavailable = 421,
			DataConnectionUnavailable = 425,
			TransferAborted = 426,
			FileActionAborted = 450,
			LocalError = 451,
			InsufficientStorageSpace = 452,
			
			CommandUnknown = 500,
			ParametersUnknown = 501,
			CommandNotImplemented = 502,
			BadCommandSequence = 503,
			ParameterNotImplemented = 504,
			NotLoggedIn = 530,
			NeedAccountToStore = 532,
			FileUnavailable = 550,
			PageTypeUnknown = 551,
			NotEnoughMemory = 552,
			FilenameNotAllowed = 553,
			
			InvalidResponse = 1000,
			ConnectionFailed = 1001,
			ConnectionClosed = 1002,
			InvalidFile = 1003,
		}

		bool isOk()
		{
			return FtpStatus< 400;
		}

		string getMessage()
		{
			return Message;
		}

		Status getStatus()
		{
			return FtpStatus;
		}

	}
}


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
		debug writeln("Destroying Http");
		sfHttp_destroy(sfPtr);
	}

	void setHost(string host, ushort port = 0)
	{
		sfHttp_setHost(sfPtr, toStringz(host),port);
	}

	Response sendRequest(Request request, Time timeout = Time.Zero)
	{
		return new Response(sfHttp_sendRequest(sfPtr,request.sfPtrRequest,timeout.InternalsfTime));
	}

	class Request
	{
		sfHttpRequest* sfPtrRequest;

		enum Method
		{
			Get,
			Post,
			Head
		}

		this(string uri = "/", Method method = Method.Get, string requestBody = "")
		{
			sfPtrRequest = sfHttpRequest_create();
			sfHttpRequest_setUri(sfPtrRequest, toStringz(uri));
			sfHttpRequest_setMethod(sfPtrRequest, method);
			sfHttpRequest_setBody(sfPtrRequest,toStringz(requestBody));
		}

		~this()
		{
			debug writeln("");
			sfHttpRequest_destroy(sfPtrRequest);
		}

		void setField(string feild, string value)
		{
			sfHttpRequest_setField(sfPtrRequest,toStringz(feild),toStringz(value));
		}

		void setMethod(Method method)
		{
			sfHttpRequest_setMethod(sfPtrRequest,method);
		}

		void setUri(string uri)
		{
			sfHttpRequest_setUri(sfPtrRequest,toStringz(uri));
		}

		void setHttpVersion(uint major, uint minor)
		{
			sfHttpRequest_setHttpVersion(sfPtrRequest,major, minor);
		}

		void setBody(string requestBody)
		{
			sfHttpRequest_setBody(sfPtrRequest,toStringz(requestBody));
		}
	

	}

	class Response
	{
		sfHttpResponse* sfPtrResponse;
		package this(sfHttpResponse* response)
		{
			sfPtrResponse = response;
		}
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

		string getField(string field)
		{
			return (sfHttpResponse_getField(sfPtrResponse,toStringz(field))).to!string();
		}

		Status getStatus()
		{
			return sfHttpResponse_getStatus(sfPtrResponse);
		}

		uint getMajorHttpVersion()
		{
			return sfHttpResponse_getMajorVersion(sfPtrResponse);
		}

		uint getMinorHttpVersion()
		{
			return sfHttpResponse_getMinorVersion(sfPtrResponse);;
		}

		string getBody()
		{
			return sfHttpResponse_getBody(sfPtrResponse).to!string();
		}
	}
}



struct IpAddress
{
	package sfIpAddress InternalsfIpAddress;

	this(string address)
	{
		InternalsfIpAddress = sfIpAddress_fromString(toStringz(address));
	}

	this(ubyte byte0,ubyte byte1,ubyte byte2,ubyte byte3)
	{
		InternalsfIpAddress = sfIpAddress_fromBytes(byte0,byte1, byte2, byte3);
	}

	this(uint address)
	{
		InternalsfIpAddress = sfIpAddress_fromInteger(address);
	}

	package this(sfIpAddress address)
	{
		InternalsfIpAddress = address;
	}

	string toString()
	{
		return InternalsfIpAddress.address.to!string();
	}

	int toInteger()
	{
		return sfIpAddress_toInteger(InternalsfIpAddress);
	}

	static IpAddress getLocalAddress()
	{
		return IpAddress(sfIpAddress_getLocalAddress());
	}

	static IpAddress getPublicAddress(Time timeout = Time.Zero)
	{
		return IpAddress(sfIpAddress_getPublicAddress(timeout.InternalsfTime));
	}

	static immutable IpAddress None;


	@property static immutable(IpAddress) LocalHost()
	{
		return IpAddress(127,0,0,1);
	}

	@property static immutable(IpAddress) Broadcast()
	{
		return IpAddress(255,255,255,255);
	}

}





//TODO: bitwise operator overloads for << and >>(To be released in revision 2)
class Packet
{
	sfPacket* sfPtr;

	this()
	{
		sfPtr = sfPacket_create();
	}

	~this()
	{
		debug writeln("Destroying Packet");
		sfPacket_destroy(sfPtr);
	}

	void append(const(void)* data, size_t sizeInBytes)
	{
		sfPacket_append(sfPtr, data, sizeInBytes);

	}

	void clear()
	{
		sfPacket_clear(sfPtr);
	}

	//may change to an array of bytes
	const(void)* getData()
	{
		return sfPacket_getData(sfPtr);
	}

	size_t getDataSize()
	{
		return sfPacket_getDataSize(sfPtr);
	}

	bool endOfPacket()
	{
		return (sfPacket_endOfPacket(sfPtr) == sfTrue)?true:false;
	}

	bool canRead()
	{
		return (sfPacket_canRead(sfPtr) == sfTrue)?true:false;
	}

	bool readBool()
	{
		return (sfPacket_readBool(sfPtr) == sfTrue)?true:false;
	}

	//Keep name changes or keep old names?
	byte readByte()
	{
		return sfPacket_readInt8(sfPtr);
	}

	ubyte readUbyte()
	{
		return sfPacket_readUint8(sfPtr);
	}

	short readShort()
	{
		return sfPacket_readInt16(sfPtr);
	}
	ushort readUshort()
	{
		return sfPacket_readUint16(sfPtr);
	}

	int readInt()
	{
		return sfPacket_readInt32(sfPtr);
	}
	uint readUint()
	{
		return sfPacket_readUint32(sfPtr);
	}

	float readFloat()
	{
		return sfPacket_readFloat(sfPtr);
	}

	double readDouble()
	{
		return sfPacket_readDouble(sfPtr);
	}

	string readString()
	{
		char* temp;

		sfPacket_readString(sfPtr, temp);

		return temp.to!string();
	}

	wstring readWideString()
	{
		wchar temp;

		sfPacket_readWideString(sfPtr, &temp);

		return temp.to!wstring();
	}


	void writeBool(bool value)
	{
		value?sfPacket_writeBool(sfPtr,sfTrue):sfPacket_writeBool(sfPtr, sfFalse);
	}

	void writeByte(byte value)
	{
		sfPacket_writeInt8(sfPtr,value);
	}
	void writeUbyte(ubyte value)
	{
		sfPacket_writeUint8(sfPtr, value);
	}

	void writeShort(short value)
	{
		sfPacket_writeInt16(sfPtr, value);
	}

	void writeUshort(ushort value)
	{
		sfPacket_writeUint16(sfPtr, value);
	}

	void writeInt(int value)
	{
		sfPacket_writeInt32(sfPtr, value);
	}

	void writeUint(uint value)
	{
		sfPacket_writeUint32(sfPtr, value);
	}

	void writeFloat(float value)
	{
		sfPacket_writeFloat(sfPtr, value);
	}

	void writeDouble(double value)
	{
		sfPacket_writeDouble(sfPtr, value);
	}

	void writeString(string value)
	{
		sfPacket_writeString(sfPtr,toStringz(value));

	}

	void writeWideString(wstring value)
	{
		sfPacket_writeWideString(sfPtr, toUTF16z(value));

	}

}


//base class for sockets
class Socket
{
	enum Status
	{
		Done, ///< The socket has sent / received the data
		NotReady, ///< The socket is not ready to send / receive data yet
		Disconnected, ///< The TCP socket has been disconnected
		Error ///< An unexpected error happened
	}
}



class SocketSelector
{
	sfSocketSelector* sfPtr;

	this()
	{
		sfPtr = sfSocketSelector_create();
	}

	~this()
	{
		debug writeln("Destroying Socket Selector");
		sfSocketSelector_destroy(sfPtr);
	}

	void add(TcpListener listener)
	{
		sfSocketSelector_addTcpListener(sfPtr, listener.sfPtr);
	}

	void add(TcpSocket socket)
	{
		sfSocketSelector_addTcpSocket(sfPtr, socket.sfPtr);
	}

	void add(UdpSocket socket)
	{
		sfSocketSelector_addUdpSocket(sfPtr, socket.sfPtr);
	}

	void remove(TcpListener listener)
	{
		sfSocketSelector_removeTcpListener(sfPtr, listener.sfPtr);
	}
	void remove(TcpSocket socket)
	{
		sfSocketSelector_removeTcpSocket(sfPtr, socket.sfPtr);
	}
	
	void remove(UdpSocket socket)
	{
		sfSocketSelector_removeUdpSocket(sfPtr, socket.sfPtr);
	}

	void clear()
	{
		sfSocketSelector_clear(sfPtr);
	}

	bool wait(Time timeout = Time.Zero)
	{
		return (sfSocketSelector_wait(sfPtr, timeout.InternalsfTime) == sfTrue)?true:false;
	}

	bool isReady(TcpListener listener)
	{
		return (sfSocketSelector_isTcpListenerReady(sfPtr, listener.sfPtr) == sfTrue)?true:false;
	}
	bool isReady(TcpSocket socket)
	{
		return (sfSocketSelector_isTcpSocketReady(sfPtr, socket.sfPtr) == sfTrue)?true:false;
	}
	
	bool isReady(UdpSocket socket)
	{
		return (sfSocketSelector_isUdpSocketReady(sfPtr, socket.sfPtr) == sfTrue)?true:false;
	}

}

class TcpListener:Socket
{
	sfTcpListener* sfPtr;
	this()
	{
		sfPtr = sfTcpListener_create();
	}

	~this()
	{
		debug writeln("Destroying Tcp Listener");
		sfTcpListener_destroy(sfPtr);
	}

	void setBlocking(bool blocking)
	{
		blocking?sfTcpListener_setBlocking(sfPtr,sfTrue):sfTcpListener_setBlocking(sfPtr,sfFalse);
	}

	bool isBlocking()
	{
		return (sfTcpListener_isBlocking(sfPtr) == sfTrue)?true:false;
	}

	ushort getLocalPort()
	{
		return sfTcpListener_getLocalPort(sfPtr);
	}

	Status listen(ushort port)
	{
		return sfTcpListener_listen(sfPtr, port);
	}

	Status accept(TcpSocket socket)
	{
		return sfTcpListener_accept(sfPtr, &socket.sfPtr);
	}

}





class TcpSocket:Socket
{
	sfTcpSocket* sfPtr;

	this()
	{
		sfPtr = sfTcpSocket_create();
	}

	~this()
	{
		debug writeln("Destroying Tcp Socket");
		sfTcpSocket_destroy(sfPtr);
	}

	void setBlocking(bool blocking)
	{
		blocking?sfTcpSocket_setBlocking(sfPtr,sfTrue):sfTcpSocket_setBlocking(sfPtr,sfFalse);
	}
	
	bool isBlocking()
	{
		return (sfTcpSocket_isBlocking(sfPtr) == true)?true:false;
	}

	ushort getLocalPort()
	{
		return sfTcpSocket_getLocalPort(sfPtr);
	}

	IpAddress  getRemoteAddress()
	{
		return IpAddress(sfTcpSocket_getRemoteAddress(sfPtr));
	}

	ushort getRemotePort()
	{
		return sfTcpSocket_getRemotePort(sfPtr);
	}

	Status connect(IpAddress host, ushort port, Time timeout)
	{
		return sfTcpSocket_connect(sfPtr, host.InternalsfIpAddress,port, timeout.InternalsfTime);
	}

	void disconnect()
	{
		sfTcpSocket_disconnect(sfPtr);
	}

	Status send(const(void)* data, size_t size)
	{
		return sfTcpSocket_send(sfPtr, data, size);
	}
	//change to an out Variable?
	Status receive(void* data, size_t maxSize, size_t* sizeReceived)
	{
		return sfTcpSocket_receive(sfPtr, data, maxSize, sizeReceived);
	}
	Status sendPacket(Packet packet)
	{
		return sfTcpSocket_sendPacket(sfPtr, packet.sfPtr);
	}

	Status receivePacket(Packet packet)
	{
		return sfTcpSocket_receivePacket(sfPtr, packet.sfPtr);
	}


}



class UdpSocket:Socket
{
	sfUdpSocket* sfPtr;

	this()
	{
		sfPtr = sfUdpSocket_create();
	}

	~this()
	{
		debug writeln("Destroy Udp Socket");
		sfUdpSocket_destroy(sfPtr);
	}

	void setBlocking(bool blocking)
	{
		blocking?sfUdpSocket_setBlocking(sfPtr,sfTrue):sfUdpSocket_setBlocking(sfPtr,sfFalse);
	}
	
	bool isBlocking()
	{
		return (sfUdpSocket_isBlocking(sfPtr) == true)?true:false;
	}
	
	ushort getLocalPort()
	{
		return sfUdpSocket_getLocalPort(sfPtr);
	}

	void unbind()
	{
		sfUdpSocket_unbind(sfPtr);
	}

	Status send(const(void)* data, size_t size, IpAddress address, ushort port)
	{
		return sfUdpSocket_send(sfPtr,data, size,address.InternalsfIpAddress,port);
	}

	Status bind(ushort port)
	{
		return sfUdpSocket_bind(sfPtr,port);
	}

	Status receive(void* data, size_t maxSize, size_t* sizeReceived, IpAddress address, ushort* port)
	{
		return sfUdpSocket_receive(sfPtr, data, maxSize,sizeReceived, &address.InternalsfIpAddress, port);
	}

	Status sendPacket(Packet packet, IpAddress address, ushort port)
	{
		return sfUdpSocket_sendPacket(sfPtr, packet.sfPtr,address.InternalsfIpAddress,port);
	}

	Status receivePacket(Packet packet, IpAddress address, ushort* port)
	{
		return sfUdpSocket_receivePacket(sfPtr, packet.sfPtr,&address.InternalsfIpAddress,port);
	}

	enum
	{
		maxDatagramSize = 65507
	}

}


//Internal binding what not
package:
struct sfFtpDirectoryResponse;
struct sfFtpListingResponse;
struct sfFtpResponse;
struct sfFtp;
struct sfHttpRequest;
struct sfHttpResponse;
struct sfHttp;
struct sfPacket;
struct sfSocketSelector;
struct sfTcpListener;
struct sfTcpSocket;
struct sfUdpSocket;

struct sfIpAddress
{
	char[16] address;
}


package extern(C)
{
	//Ftp Directory Response
	void sfFtpDirectoryResponse_destroy(sfFtpDirectoryResponse* ftpDirectoryResponse);
	sfBool  sfFtpDirectoryResponse_isOk(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);
	Ftp.Response.Status sfFtpDirectoryResponse_getStatus(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);
	const(char)* sfFtpDirectoryResponse_getMessage(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);
	const(char)* sfFtpDirectoryResponse_getDirectory(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);

	//Ftp Listing Response
	void sfFtpListingResponse_destroy(sfFtpListingResponse* ftpListingResponse);
	sfBool sfFtpListingResponse_isOk(const(sfFtpListingResponse)* ftpListingResponse);
	Ftp.Response.Status sfFtpListingResponse_getStatus(const(sfFtpListingResponse)* ftpListingResponse);
	const(char)* sfFtpListingResponse_getMessage(const(sfFtpListingResponse)* ftpListingResponse);
	size_t sfFtpListingResponse_getCount(const(sfFtpListingResponse)* ftpListingResponse);
	const(char)* sfFtpListingResponse_getName(const(sfFtpListingResponse)* ftpListingResponse,size_t index);

	//Ftp Response
	void sfFtpResponse_destroy(sfFtpResponse* ftpResponse);
	sfBool sfFtpResponse_isOk(const(sfFtpResponse)* ftpResponse);
	Ftp.Response.Status sfFtpResponse_getStatus(const(sfFtpResponse)* ftpResponse);
	const(char)* sfFtpResponse_getMessage(const(sfFtpResponse)* ftpResponse);

	//Ftp
	sfFtp* sfFtp_create();
	void sfFtp_destroy(sfFtp* ftp);
	sfFtpResponse* sfFtp_connect(sfFtp* ftp,sfIpAddress server,ushort port,sfTime timeout);
	sfFtpResponse* sfFtp_loginAnonymous(sfFtp* ftp);
	sfFtpResponse* sfFtp_login(sfFtp* ftp,const(char)* userName,const(char)* password);
	sfFtpResponse* sfFtp_disconnect(sfFtp* ftp);
	sfFtpResponse* sfFtp_keepAlive(sfFtp* ftp);
	sfFtpDirectoryResponse* sfFtp_getWorkingDirectory(sfFtp* ftp);
	sfFtpListingResponse* sfFtp_getDirectoryListing(sfFtp* ftp,const(char)* directory);
	sfFtpResponse* sfFtp_changeDirectory(sfFtp* ftp,const(char)* directory);
	sfFtpResponse* sfFtp_parentDirectory(sfFtp* ftp);
	sfFtpResponse* sfFtp_createDirectory(sfFtp* ftp,const(char)* name);
	sfFtpResponse* sfFtp_deleteDirectory(sfFtp* ftp,const(char)* name);
	sfFtpResponse* sfFtp_renameFile(sfFtp* ftp,const(char)* file,const(char)* newName);
	sfFtpResponse* sfFtp_deleteFile(sfFtp* ftp,const(char)* name);
	sfFtpResponse* sfFtp_download(sfFtp* ftp,const(char)* distantFile,const(char)* destPath,Ftp.TransferMode mode);
	sfFtpResponse* sfFtp_upload(sfFtp* ftp,const(char)* localFile,const(char)* destPath,Ftp.TransferMode mode);

	//Http Request
	sfHttpRequest*  sfHttpRequest_create();
	void sfHttpRequest_destroy(sfHttpRequest* httpRequest);
	void sfHttpRequest_setField(sfHttpRequest* httpRequest,const(char)* field,const(char)* value);
	void sfHttpRequest_setMethod(sfHttpRequest* httpRequest,Http.Request.Method method);
	void sfHttpRequest_setUri(sfHttpRequest* httpRequest,const(char)* uri);
	void sfHttpRequest_setHttpVersion(sfHttpRequest* httpRequest,uint major,uint minor);
	void sfHttpRequest_setBody(sfHttpRequest* httpRequest,const(char)* _body);

	//Http Response
	void sfHttpResponse_destroy(sfHttpResponse* httpResponse);
	const(char)* sfHttpResponse_getField(const(sfHttpResponse)* httpResponse,const(char)* field);
	Http.Response.Status sfHttpResponse_getStatus(const(sfHttpResponse)* httpResponse);
	uint sfHttpResponse_getMajorVersion(const(sfHttpResponse)* httpResponse);
	uint sfHttpResponse_getMinorVersion(const(sfHttpResponse)* httpResponse);
	const(char)* sfHttpResponse_getBody(const(sfHttpResponse)* httpResponse);

	//Http
	sfHttp* sfHttp_create();
	void sfHttp_destroy(sfHttp* http);
	void sfHttp_setHost(sfHttp* http,const(char)* host,ushort port);
	sfHttpResponse* sfHttp_sendRequest(sfHttp* http,const(sfHttpRequest)* request,sfTime timeout);

	//Ip Address
	sfIpAddress sfIpAddress_fromString(const(char)* address);
	sfIpAddress sfIpAddress_fromBytes(ubyte byte0,ubyte byte1,ubyte byte2,ubyte byte3);
	sfIpAddress sfIpAddress_fromInteger(uint address);
	void sfIpAddress_toString(sfIpAddress address,char* string);
	int sfIpAddress_toInteger(sfIpAddress address);
	sfIpAddress sfIpAddress_getLocalAddress();
	sfIpAddress sfIpAddress_getPublicAddress(sfTime timeout);

	//Packet
	sfPacket* sfPacket_create();
	sfPacket* sfPacket_copy(const(sfPacket)* packet);
	void sfPacket_destroy(sfPacket* packet);
	void sfPacket_append(sfPacket* packet,const(void)* data,size_t sizeInBytes);
	void sfPacket_clear(sfPacket* packet);
	const(void)* sfPacket_getData(const(sfPacket)* packet);
	size_t sfPacket_getDataSize(const(sfPacket)* packet);
	sfBool sfPacket_endOfPacket(const(sfPacket)* packet);
	sfBool sfPacket_canRead(const(sfPacket)* packet);
	sfBool sfPacket_readBool(sfPacket* packet);
	byte sfPacket_readInt8(sfPacket* packet);
	ubyte sfPacket_readUint8(sfPacket* packet);
	short sfPacket_readInt16(sfPacket* packet);
	ushort sfPacket_readUint16(sfPacket* packet);
	int sfPacket_readInt32(sfPacket* packet);
	uint sfPacket_readUint32(sfPacket* packet);
	float sfPacket_readFloat(sfPacket* packet);
	double sfPacket_readDouble(sfPacket* packet);
	void sfPacket_readString(sfPacket* packet,char* string);
	void sfPacket_readWideString(sfPacket* packet,wchar* string);
	void sfPacket_writeBool(sfPacket* packet, sfBool value);
	void sfPacket_writeInt8(sfPacket* packet, byte value);
	void sfPacket_writeUint8(sfPacket* packet, ubyte value);
	void sfPacket_writeInt16(sfPacket* packet, short value);
	void sfPacket_writeUint16(sfPacket* packet, ushort value);
	void sfPacket_writeInt32(sfPacket* packet, int value);
	void sfPacket_writeUint32(sfPacket* packet, uint value);
	void sfPacket_writeFloat(sfPacket* packet, float value);
	void sfPacket_writeDouble(sfPacket* packet, double value);
	void sfPacket_writeString(sfPacket* packet,const(char)* string);
	void sfPacket_writeWideString(sfPacket* packet,const(wchar)* string);

	//Socket Selector
	sfSocketSelector* sfSocketSelector_create();
	sfSocketSelector* sfSocketSelector_copy(const(sfSocketSelector)* selector);
	void sfSocketSelector_destroy(sfSocketSelector* selector);
	void sfSocketSelector_addTcpListener(sfSocketSelector* selector,sfTcpListener* socket);
	void sfSocketSelector_addTcpSocket(sfSocketSelector* selector,sfTcpSocket* socket);
	void sfSocketSelector_addUdpSocket(sfSocketSelector* selector,sfUdpSocket* socket);
	void sfSocketSelector_removeTcpListener(sfSocketSelector* selector,sfTcpListener* socket);
	void sfSocketSelector_removeTcpSocket(sfSocketSelector* selector,sfTcpSocket* socket);
	void sfSocketSelector_removeUdpSocket(sfSocketSelector* selector,sfUdpSocket* socket);
	void sfSocketSelector_clear(sfSocketSelector* selector);
	sfBool sfSocketSelector_wait(sfSocketSelector* selector,sfTime timeout);
	sfBool sfSocketSelector_isTcpListenerReady(const(sfSocketSelector)* selector,sfTcpListener* socket);
	sfBool sfSocketSelector_isTcpSocketReady(const(sfSocketSelector)* selector,sfTcpSocket* socket);
	sfBool sfSocketSelector_isUdpSocketReady(const(sfSocketSelector)* selector,sfUdpSocket* socket);

	//Tcp Listener
	sfTcpListener* sfTcpListener_create();
	void sfTcpListener_destroy(sfTcpListener* listener);
	void sfTcpListener_setBlocking(sfTcpListener* listener,sfBool blocking);
	sfBool sfTcpListener_isBlocking(const(sfTcpListener)* listener);
	ushort sfTcpListener_getLocalPort(const(sfTcpListener)* listener);
	Socket.Status sfTcpListener_listen(sfTcpListener* listener,ushort port);
	Socket.Status sfTcpListener_accept(sfTcpListener* listener,sfTcpSocket** connected);

	//Tcp Socket
	sfTcpSocket* sfTcpSocket_create();
	void sfTcpSocket_destroy(sfTcpSocket* socket);
	void sfTcpSocket_setBlocking(sfTcpSocket* socket,sfBool blocking);
	sfBool sfTcpSocket_isBlocking(const(sfTcpSocket)* socket);
	ushort sfTcpSocket_getLocalPort(const(sfTcpSocket)* socket);
	sfIpAddress sfTcpSocket_getRemoteAddress(const(sfTcpSocket)* socket);
	ushort sfTcpSocket_getRemotePort(const(sfTcpSocket)* socket);
	Socket.Status sfTcpSocket_connect(sfTcpSocket* socket,sfIpAddress host,ushort port,sfTime timeout);
	void sfTcpSocket_disconnect(sfTcpSocket* socket);
	Socket.Status sfTcpSocket_send(sfTcpSocket* socket,const(void)* data,size_t size);
	Socket.Status sfTcpSocket_receive(sfTcpSocket* socket,void* data,size_t maxSize,size_t* sizeReceived);
	Socket.Status sfTcpSocket_sendPacket(sfTcpSocket* socket,sfPacket* packet);
	Socket.Status sfTcpSocket_receivePacket(sfTcpSocket* socket,sfPacket* packet);

	//Udp Socket
	sfUdpSocket* sfUdpSocket_create();
	void sfUdpSocket_destroy(sfUdpSocket* socket);
	void sfUdpSocket_setBlocking(sfUdpSocket* socket,sfBool blocking);
	sfBool sfUdpSocket_isBlocking(const(sfUdpSocket)* socket);
	short sfUdpSocket_getLocalPort(const(sfUdpSocket)* socket);
	Socket.Status sfUdpSocket_bind(sfUdpSocket* socket,ushort port);
	void sfUdpSocket_unbind(sfUdpSocket* socket);
	Socket.Status sfUdpSocket_send(sfUdpSocket* socket,const(void)* data,size_t size,sfIpAddress address,ushort port);
	Socket.Status  sfUdpSocket_receive(sfUdpSocket* socket,void* data,size_t maxSize,size_t* sizeReceived,sfIpAddress* address,ushort* port);
	Socket.Status sfUdpSocket_sendPacket(sfUdpSocket* socket,sfPacket* packet,sfIpAddress address,ushort port);
	Socket.Status sfUdpSocket_receivePacket(sfUdpSocket* socket,sfPacket* packet,sfIpAddress* address,ushort* port);
	uint sfUdpSocket_maxDatagramSize();
}
