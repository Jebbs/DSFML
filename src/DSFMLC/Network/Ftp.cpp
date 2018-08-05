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

#include <DSFMLC/Network/Ftp.h>
#include <DSFMLC/Network/FtpStruct.h>
#include <SFML/Network/IpAddress.hpp>

///FTP Listing Responce Functions

void sfFtpListingResponse_destroy(sfFtpListingResponse* ftpListingResponse)
{
    delete ftpListingResponse;
}

DInt sfFtpListingResponse_getStatus(const sfFtpListingResponse* ftpListingResponse)
{
    return ftpListingResponse->This.getStatus();
}

const char* sfFtpListingResponse_getMessage(const sfFtpListingResponse* ftpListingResponse)
{
    return ftpListingResponse->This.getMessage().c_str();
}

size_t sfFtpListingResponse_getCount(const sfFtpListingResponse* ftpListingResponse)
{
    return ftpListingResponse->This.getListing().size();
}

const char* sfFtpListingResponse_getName(const sfFtpListingResponse* ftpListingResponse, size_t index)
{
    return ftpListingResponse->This.getListing()[index].c_str();
}

///FTP Directory Responce Functions

void sfFtpDirectoryResponse_destroy(sfFtpDirectoryResponse* ftpDirectoryResponse)
{
    delete ftpDirectoryResponse;
}

DInt sfFtpDirectoryResponse_getStatus(const sfFtpDirectoryResponse* ftpDirectoryResponse)
{
    return ftpDirectoryResponse->This.getStatus();
}

const char* sfFtpDirectoryResponse_getMessage(const sfFtpDirectoryResponse* ftpDirectoryResponse)
{
    return ftpDirectoryResponse->This.getMessage().c_str();
}

const char* sfFtpDirectoryResponse_getDirectory(const sfFtpDirectoryResponse* ftpDirectoryResponse)
{
    return ftpDirectoryResponse->This.getDirectory().c_str();
}

///FTP Responce Functions

void sfFtpResponse_destroy(sfFtpResponse* ftpResponse)
{
    delete ftpResponse;
}

DInt sfFtpResponse_getStatus(const sfFtpResponse* ftpResponse)
{
    return ftpResponse->This.getStatus();
}

const char* sfFtpResponse_getMessage(const sfFtpResponse* ftpResponse)
{
    return ftpResponse->This.getMessage().c_str();
}

///FTP Functions

sfFtp* sfFtp_create(void)
{
    return new sfFtp;
}

void sfFtp_destroy(sfFtp* ftp)
{
    delete ftp;
}

sfFtpResponse* sfFtp_connect(sfFtp* ftp, sf::IpAddress* serverIP, DUshort port, DLong timeout)
{
    return new sfFtpResponse(ftp->This.connect(*serverIP, port, sf::microseconds(timeout)));
}

sfFtpResponse* sfFtp_loginAnonymous(sfFtp* ftp)
{
    return new sfFtpResponse(ftp->This.login());
}

sfFtpResponse* sfFtp_login(sfFtp* ftp, const char* userName, size_t userNameLength, const char* password, size_t passwordLength)
{
    return new sfFtpResponse(ftp->This.login(userName ? std::string(userName, userNameLength) : "", password ? std::string(password, passwordLength) : ""));
}

sfFtpResponse* sfFtp_disconnect(sfFtp* ftp)
{
    return new sfFtpResponse(ftp->This.disconnect());
}

sfFtpResponse* sfFtp_keepAlive(sfFtp* ftp)
{
    return new sfFtpResponse(ftp->This.keepAlive());
}

sfFtpDirectoryResponse* sfFtp_getWorkingDirectory(sfFtp* ftp)
{
    return new sfFtpDirectoryResponse(ftp->This.getWorkingDirectory());
}

sfFtpListingResponse* sfFtp_getDirectoryListing(sfFtp* ftp, const char* directory, size_t length)
{
    return new sfFtpListingResponse(ftp->This.getDirectoryListing(directory ? std::string(directory, length) : ""));
}

sfFtpResponse* sfFtp_changeDirectory(sfFtp* ftp, const char* directory, size_t length)
{
    return new sfFtpResponse(ftp->This.changeDirectory(directory ? std::string(directory, length) : ""));
}

sfFtpResponse* sfFtp_parentDirectory(sfFtp* ftp)
{
    return new sfFtpResponse(ftp->This.parentDirectory());
}

sfFtpResponse* sfFtp_createDirectory(sfFtp* ftp, const char* name, size_t length)
{
    return new sfFtpResponse(ftp->This.createDirectory(name ? std::string(name, length) : ""));
}

sfFtpResponse* sfFtp_deleteDirectory(sfFtp* ftp, const char* name, size_t length)
{
    return new sfFtpResponse(ftp->This.deleteDirectory(name ? std::string(name, length) : ""));
}

sfFtpResponse* sfFtp_renameFile(sfFtp* ftp, const char* file, size_t fileLength, const char* newName, size_t newNameLength)
{
    return new sfFtpResponse(ftp->This.renameFile(file ? std::string(file, fileLength) : "", newName ? std::string(newName, newNameLength) : ""));
}

sfFtpResponse* sfFtp_deleteFile(sfFtp* ftp, const char* name, size_t length)
{
    return new sfFtpResponse(ftp->This.deleteFile(name ? std::string(name, length) : ""));
}

sfFtpResponse* sfFtp_download(sfFtp* ftp, const char* distantFile, size_t distantFileLength, const char* destPath, size_t destPathLength, DInt mode)
{
    return new sfFtpResponse(ftp->This.download(distantFile ? std::string(distantFile, distantFileLength) : "",
                                                destPath ? std::string(destPath, destPathLength) : "",
                                                static_cast<sf::Ftp::TransferMode>(mode)));
}

sfFtpResponse* sfFtp_upload(sfFtp* ftp, const char* localFile, size_t localFileLength, const char* destPath, size_t destPathLength, DInt mode)
{
    return new sfFtpResponse(ftp->This.upload(localFile ? std::string(localFile, localFileLength) : "",
                                              destPath ? std::string(destPath, destPathLength) : "",
                                              static_cast<sf::Ftp::TransferMode>(mode)));
}

sfFtpResponse* sfFtp_sendCommand(sfFtp* ftp, const char* command, size_t commandLength, const char* parameter, size_t parameterLength)
{
    return new sfFtpResponse(ftp->This.sendCommand(command ? std::string(command, commandLength) : "",
                                              parameter ? std::string(parameter, parameterLength) : ""));
}
