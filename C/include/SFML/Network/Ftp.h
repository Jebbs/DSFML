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

#ifndef DSFML_FTP_H
#define DSFML_FTP_H


// Headers
#include <SFML/Network/Export.h>
#include <SFML/Network/IpAddress.h>
#include <SFML/Network/Types.h>
#include <stddef.h>


///FTP Listing Responce Functions

//Destroy a FTP listing response
DSFML_NETWORK_API void sfFtpListingResponse_destroy(sfFtpListingResponse* ftpListingResponse);


//Get the status code of a FTP listing response
DSFML_NETWORK_API DInt sfFtpListingResponse_getStatus(const sfFtpListingResponse* ftpListingResponse);


//Get the full message contained in a FTP listing response
DSFML_NETWORK_API const char* sfFtpListingResponse_getMessage(const sfFtpListingResponse* ftpListingResponse);


//Return the number of directory/file names contained in a FTP listing response
DSFML_NETWORK_API size_t sfFtpListingResponse_getCount(const sfFtpListingResponse* ftpListingResponse);


//Return a directory/file name contained in a FTP listing response
DSFML_NETWORK_API const char* sfFtpListingResponse_getName(const sfFtpListingResponse* ftpListingResponse, size_t index);



///FTP Directory Responce Functions

//Destroy a FTP directory response
DSFML_NETWORK_API void sfFtpDirectoryResponse_destroy(sfFtpDirectoryResponse* ftpDirectoryResponse);


//Get the status code of a FTP directory response
DSFML_NETWORK_API DInt sfFtpDirectoryResponse_getStatus(const sfFtpDirectoryResponse* ftpDirectoryResponse);


//Get the full message contained in a FTP directory response
DSFML_NETWORK_API const char* sfFtpDirectoryResponse_getMessage(const sfFtpDirectoryResponse* ftpDirectoryResponse);


//Get the directory returned in a FTP directory response
DSFML_NETWORK_API const char* sfFtpDirectoryResponse_getDirectory(const sfFtpDirectoryResponse* ftpDirectoryResponse);



///FTP Responce functions

//Destroy a FTP response
DSFML_NETWORK_API void sfFtpResponse_destroy(sfFtpResponse* ftpResponse);


//Get the status code of a FTP response
DSFML_NETWORK_API DInt sfFtpResponse_getStatus(const sfFtpResponse* ftpResponse);


//Get the full message contained in a FTP response
DSFML_NETWORK_API const char* sfFtpResponse_getMessage(const sfFtpResponse* ftpResponse);


///FTP functions

//Create a new Ftp object
DSFML_NETWORK_API sfFtp* sfFtp_create(void);


//Destroy a Ftp object
DSFML_NETWORK_API void sfFtp_destroy(sfFtp* ftp);


//Connect to the specified FTP server
DSFML_NETWORK_API sfFtpResponse* sfFtp_connect(sfFtp* ftp, const char* serverIP, DUshort port, DLong timeout);


//Log in using an anonymous account
DSFML_NETWORK_API sfFtpResponse* sfFtp_loginAnonymous(sfFtp* ftp);


//Log in using a username and a password
DSFML_NETWORK_API sfFtpResponse* sfFtp_login(sfFtp* ftp, const char* userName, const char* password);


//Close the connection with the server
DSFML_NETWORK_API sfFtpResponse* sfFtp_disconnect(sfFtp* ftp);


//Send a null command to keep the connection alive
DSFML_NETWORK_API sfFtpResponse* sfFtp_keepAlive(sfFtp* ftp);


//Get the current working directory
DSFML_NETWORK_API sfFtpDirectoryResponse* sfFtp_getWorkingDirectory(sfFtp* ftp);


//Get the contents of the given directory
DSFML_NETWORK_API sfFtpListingResponse* sfFtp_getDirectoryListing(sfFtp* ftp, const char* directory);


//Change the current working directory
DSFML_NETWORK_API sfFtpResponse* sfFtp_changeDirectory(sfFtp* ftp, const char* directory);


//Go to the parent directory of the current one
DSFML_NETWORK_API sfFtpResponse* sfFtp_parentDirectory(sfFtp* ftp);


//Create a new directory
DSFML_NETWORK_API sfFtpResponse* sfFtp_createDirectory(sfFtp* ftp, const char* name);


//Remove an existing directory
DSFML_NETWORK_API sfFtpResponse* sfFtp_deleteDirectory(sfFtp* ftp, const char* name);


//Rename an existing file
DSFML_NETWORK_API sfFtpResponse* sfFtp_renameFile(sfFtp* ftp, const char* file, const char* newName);


//Remove an existing file
DSFML_NETWORK_API sfFtpResponse* sfFtp_deleteFile(sfFtp* ftp, const char* name);


//Download a file from a FTP server
DSFML_NETWORK_API sfFtpResponse* sfFtp_download(sfFtp* ftp, const char* distantFile, const char* destPath, DInt mode);


//Upload a file to a FTP server
DSFML_NETWORK_API sfFtpResponse* sfFtp_upload(sfFtp* ftp, const char* localFile, const char* destPath, DInt mode);


#endif // DSFML_FTP_H
