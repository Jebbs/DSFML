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

#include <DSFMLC/Graphics/Texture.h>
#include <DSFMLC/Graphics/TextureStruct.h>
#include <DSFMLC/Graphics/ImageStruct.h>
#include <DSFMLC/Graphics/RenderWindowStruct.h>
#include <DSFMLC/Window/WindowStruct.h>

//Construct a new texture
sfTexture* sfTexture_construct(void)
{
    return new sfTexture;
}

DBool sfTexture_create(sfTexture* texture, DUint width, DUint height)
{
    return texture->This->create(width, height)?DTrue:DFalse;

}

DBool sfTexture_loadFromFile(sfTexture* texture, const char* filename, size_t filenameLength, DInt left, DInt top, DInt width, DInt height)
{
    sf::IntRect rect = sf::IntRect(left, top, width, height);

    return texture->This->loadFromFile(std::string(filename, filenameLength), rect)?DTrue:DFalse;
}

DBool sfTexture_loadFromMemory(sfTexture* texture, const void* data, size_t sizeInBytes, DInt left, DInt top, DInt width, DInt height)
{
    sf::IntRect rect = sf::IntRect(left, top, width, height);

    return texture->This->loadFromMemory(data, sizeInBytes, rect)?DTrue:DFalse;
}

DBool sfTexture_loadFromStream(sfTexture* texture, DStream* stream, DInt left, DInt top, DInt width, DInt height)
{
    sf::IntRect rect = sf::IntRect(left, top, width, height);

    sfmlStream Stream = sfmlStream(stream);

    return texture->This->loadFromStream(Stream, rect)?DTrue:DFalse;
}

DBool sfTexture_loadFromImage(sfTexture* texture, const sfImage* image, DInt left, DInt top, DInt width, DInt height)
{
    sf::IntRect rect = sf::IntRect(left, top, width, height);

    return texture->This->loadFromImage(image->This, rect)?DTrue:DFalse;
}

sfTexture* sfTexture_copy(const sfTexture* texture)
{
    return new sfTexture(*texture);
}

void sfTexture_destroy(sfTexture* texture)
{
    delete texture;
}

void sfTexture_getSize(const sfTexture* texture, DUint* x, DUint* y)
{
    sf::Vector2u sfmlSize = texture->This->getSize();

    *x = sfmlSize.x;
    *y = sfmlSize.y;
}

sfImage* sfTexture_copyToImage(const sfTexture* texture)
{
    sfImage* image = new sfImage;
    image->This = texture->This->copyToImage();

    return image;
}

void sfTexture_updateFromPixels(sfTexture* texture, const DUbyte* pixels, DUint width, DUint height, DUint x, DUint y)
{
   texture->This->update(pixels, width, height, x, y);
}

void sfTexture_updateFromImage(sfTexture* texture, const sfImage* image, DUint x, DUint y)
{
    texture->This->update(image->This, x, y);
}

void sfTexture_updateFromWindow(sfTexture* texture, const void* window, DUint x, DUint y)
{
    texture->This->update(static_cast<const sfWindow*>(window)->This, x, y);
}

void sfTexture_updateFromRenderWindow(sfTexture* texture, const sfRenderWindow* renderWindow, DUint x, DUint y)
{
    texture->This->update(renderWindow->This, x, y);
}

void sfTexture_setSmooth(sfTexture* texture, DBool smooth)
{
    texture->This->setSmooth(smooth == DTrue);
}

DBool sfTexture_isSmooth(const sfTexture* texture)
{
    return texture->This->isSmooth();
}

void sfTexture_setRepeated(sfTexture* texture, DBool repeated)
{
    texture->This->setRepeated(repeated == DTrue);
}

DBool sfTexture_isRepeated(const sfTexture* texture)
{
    return texture->This->isRepeated();
}

void sfTexture_bind(const sfTexture* texture)
{
    sf::Texture::bind(texture ? texture->This : NULL);
}

DUint sfTexture_getMaximumSize()
{
    return sf::Texture::getMaximumSize();
}
