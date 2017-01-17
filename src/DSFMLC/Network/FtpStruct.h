////////////////////////////////////////////////////////////
//
// SFML - Simple and Fast Multimedia Library
// Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it freely,
// subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented;
//    you must not claim that you wrote the original software.
//    If you use this software in a product, an acknowledgment
//    in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such,
//    and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.
//
////////////////////////////////////////////////////////////

#ifndef DSFML_FTPSTRUCT_H
#define DSFML_FTPSTRUCT_H

////////////////////////////////////////////////////////////
// Headers
////////////////////////////////////////////////////////////
#include <SFML/Network/Ftp.hpp>
#include <vector>


////////////////////////////////////////////////////////////
// Internal structure of sfFtp
////////////////////////////////////////////////////////////
struct sfFtp
{
    sf::Ftp This;
};


////////////////////////////////////////////////////////////
// Internal structure of sfFtpResponse
////////////////////////////////////////////////////////////
struct sfFtpResponse
{
    sfFtpResponse(const sf::Ftp::Response& Response)
        : This(Response)
    {
    }

    sf::Ftp::Response This;
};


////////////////////////////////////////////////////////////
// Internal structure of sfFtpDirectoryResponse
////////////////////////////////////////////////////////////
struct sfFtpDirectoryResponse
{
    sfFtpDirectoryResponse(const sf::Ftp::DirectoryResponse& Response)
        : This(Response)
    {
    }

    sf::Ftp::DirectoryResponse This;
};


////////////////////////////////////////////////////////////
// Internal structure of sfFtpListingResponse
////////////////////////////////////////////////////////////
struct sfFtpListingResponse
{
    sfFtpListingResponse(const sf::Ftp::ListingResponse& Response)
        : This(Response)
    {
    }

    ~sfFtpListingResponse()
    {
        for (std::vector<const char*>::iterator it = Filenames.begin(); it != Filenames.end(); ++it)
            delete[] *it;
    }

    sf::Ftp::ListingResponse This;
    std::vector<const char*> Filenames;
};


#endif // DSFML_FTPSTRUCT_H
