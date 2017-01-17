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

// Headers
#include <DSFMLC/Graphics/Image.h>
#include <DSFMLC/Graphics/ImageStruct.h>

sfImage* sfImage_construct(void)
{
    return new sfImage;
}

void sfImage_create(sfImage* image, DUint width, DUint height)
{
    image->This.create(width, height);
}


void sfImage_createFromColor(sfImage* image, DUint width, DUint height, DUbyte r, DUbyte b, DUbyte g, DUbyte a)
{
    image->This.create(width, height, sf::Color(r, g, b, a));

}


void sfImage_createFromPixels(sfImage* image, DUint width, DUint height, const DUbyte* data)
{
    image->This.create(width, height, data);
}


DBool sfImage_loadFromFile(sfImage* image, const char* filename, size_t length)
{
    return image->This.loadFromFile(std::string(filename, length))?DTrue:DFalse;
}


DBool sfImage_loadFromMemory(sfImage* image, const void* data, size_t sizeInBytes)
{
    return image->This.loadFromMemory(data, sizeInBytes)?DTrue:DFalse;
}


DBool sfImage_loadFromStream(sfImage* image, DStream* stream)
{
    sfmlStream Stream = sfmlStream(stream);

    return image->This.loadFromStream(Stream)?DTrue:DFalse;
}


sfImage* sfImage_copy(const sfImage* image)
{

    return new sfImage(*image);
}


void sfImage_destroy(sfImage* image)
{
    delete image;
}


DBool sfImage_saveToFile(const sfImage* image, const char* filename, size_t length)
{
    return image->This.saveToFile(std::string(filename, length))?DTrue:DFalse;
}


void sfImage_createMaskFromColor(sfImage* image, DUbyte r, DUbyte b, DUbyte g, DUbyte a, DUbyte alpha)
{
    image->This.createMaskFromColor(sf::Color(r, g, b, a), alpha);
}


void sfImage_copyImage(sfImage* image, const sfImage* source, DUint destX, DUint destY, DInt sourceRectTop, DInt sourceRectLeft, DInt sourceRectWidth, DInt sourceRectHeight, DBool applyAlpha)
{
    sf::IntRect sfmlRect(sourceRectLeft, sourceRectTop, sourceRectWidth, sourceRectHeight);
    image->This. copy(source->This, destX, destY, sfmlRect, applyAlpha == DTrue);
}


void sfImage_setPixel(sfImage* image, DUint x, DUint y, DUbyte r, DUbyte b, DUbyte g, DUbyte a)
{
    image->This.setPixel(x, y, sf::Color(r, g, b, a));
}


void sfImage_getPixel(const sfImage* image, DUint x, DUint y, DUbyte* r, DUbyte* b, DUbyte* g, DUbyte* a)
{
    sf::Color sfmlColor = image->This.getPixel(x, y);

    *r = sfmlColor.r;
    *b = sfmlColor.b;
    *g = sfmlColor.g;
    *a = sfmlColor.a;

}


const DUbyte* sfImage_getPixelsPtr(const sfImage* image)
{
    return image->This.getPixelsPtr();
}


void sfImage_getSize(const sfImage* image, DUint* width, DUint* height)
{
    sf::Vector2u sfmlSize = image->This.getSize();

    *width = sfmlSize.x;
    *height = sfmlSize.y;

}


void sfImage_flipHorizontally(sfImage* image)
{
    image->This.flipHorizontally();
}


void sfImage_flipVertically(sfImage* image)
{
    image->This.flipVertically();
}
