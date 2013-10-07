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

module dsfml.network.ftp;

import dsfml.system.time;
import dsfml.network.ipaddress;
import std.string;
import std.conv;

debug import std.stdio;

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
		return new Response(sfFtp_connect(sfPtr, address.m_address.ptr, port, timeout.asMicroseconds()));
	}

	Response connect(string address, ushort port = 21, Time timeout = Time.Zero)
	{

		return new Response(sfFtp_connect(sfPtr, IpAddress(address).m_address.ptr, port, timeout.asMicroseconds()));
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
		
		package this(Ftp.Response.Status status = Ftp.Response.Status.InvalidResponse, const(char)* message = "")
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



private extern(C):


struct sfFtpDirectoryResponse;
struct sfFtpListingResponse;
struct sfFtpResponse;
struct sfFtp;

//FTP Listing Response Functions

///Destroy a FTP listing response
void sfFtpListingResponse_destroy(sfFtpListingResponse* ftpListingResponse);


///Get the status code of a FTP listing response
Ftp.Response.Status sfFtpListingResponse_getStatus(const sfFtpListingResponse* ftpListingResponse);


///Get the full message contained in a FTP listing response
 const(char)* sfFtpListingResponse_getMessage(const(sfFtpListingResponse)* ftpListingResponse);


///Return the number of directory/file names contained in a FTP listing response
 size_t sfFtpListingResponse_getCount(const(sfFtpListingResponse)* ftpListingResponse);


///Return a directory/file name contained in a FTP listing response
 const(char)* sfFtpListingResponse_getName(const(sfFtpListingResponse)* ftpListingResponse, size_t index);



//FTP Directory Responce Functions

///Destroy a FTP directory response
 void sfFtpDirectoryResponse_destroy(sfFtpDirectoryResponse* ftpDirectoryResponse);


///Get the status code of a FTP directory response
Ftp.Response.Status sfFtpDirectoryResponse_getStatus(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);


///Get the full message contained in a FTP directory response
 const(char)* sfFtpDirectoryResponse_getMessage(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);


///Get the directory returned in a FTP directory response
 const(char)* sfFtpDirectoryResponse_getDirectory(const(sfFtpDirectoryResponse)* ftpDirectoryResponse);



//FTP Responce functions

///Destroy a FTP response
 void sfFtpResponse_destroy(sfFtpResponse* ftpResponse);


///Get the status code of a FTP response
Ftp.Response.Status sfFtpResponse_getStatus(const(sfFtpResponse)* ftpResponse);


///Get the full message contained in a FTP response
const (char)* sfFtpResponse_getMessage(const sfFtpResponse* ftpResponse);


////FTP functions

///Create a new Ftp object
sfFtp* sfFtp_create();


///Destroy a Ftp object
void sfFtp_destroy(sfFtp* ftp);


///Connect to the specified FTP server
sfFtpResponse* sfFtp_connect(sfFtp* ftp, const(char)* serverIP, ushort port, long timeout);


///Log in using an anonymous account
sfFtpResponse* sfFtp_loginAnonymous(sfFtp* ftp);


///Log in using a username and a password
sfFtpResponse* sfFtp_login(sfFtp* ftp, const(char)* userName, const(char)* password);


///Close the connection with the server
sfFtpResponse* sfFtp_disconnect(sfFtp* ftp);


///Send a null command to keep the connection alive
sfFtpResponse* sfFtp_keepAlive(sfFtp* ftp);


///Get the current working directory
sfFtpDirectoryResponse* sfFtp_getWorkingDirectory(sfFtp* ftp);


///Get the contents of the given directory
sfFtpListingResponse* sfFtp_getDirectoryListing(sfFtp* ftp, const(char)* directory);


///Change the current working directory
sfFtpResponse* sfFtp_changeDirectory(sfFtp* ftp, const(char)* directory);


///Go to the parent directory of the current one
sfFtpResponse* sfFtp_parentDirectory(sfFtp* ftp);


///Create a new directory
sfFtpResponse* sfFtp_createDirectory(sfFtp* ftp, const(char)* name);


///Remove an existing directory
sfFtpResponse* sfFtp_deleteDirectory(sfFtp* ftp, const(char)* name);


///Rename an existing file
sfFtpResponse* sfFtp_renameFile(sfFtp* ftp, const(char)* file, const(char)* newName);


///Remove an existing file
sfFtpResponse* sfFtp_deleteFile(sfFtp* ftp, const(char)* name);


///Download a file from a FTP server
sfFtpResponse* sfFtp_download(sfFtp* ftp, const(char)* distantFile, const(char)* destPath, int mode);


///Upload a file to a FTP server
sfFtpResponse* sfFtp_upload(sfFtp* ftp, const(char)* localFile, const(char)* destPath, int mode);

