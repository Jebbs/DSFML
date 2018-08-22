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

#include <DSFMLC/Graphics/RenderTexture.h>
#include <DSFMLC/Graphics/RenderTextureStruct.h>
#include <DSFMLC/Graphics/CreateRenderStates.hpp>

sfRenderTexture* sfRenderTexture_construct(void)
{
    return new sfRenderTexture;
}

DBool sfRenderTexture_create(sfRenderTexture* renderTexture, DUint width, DUint height, DBool depthBuffer)
{
    return renderTexture->This.create(width, height, depthBuffer == DTrue)?DTrue:DFalse;
}

void sfRenderTexture_destroy(sfRenderTexture* renderTexture)
{
    delete renderTexture;
}

void sfRenderTexture_getSize(const sfRenderTexture* renderTexture, DUint* x, DUint* y)
{
    sf::Vector2u sfmlSize = renderTexture->This.getSize();
    *x = sfmlSize.x;
    *y = sfmlSize.y;
}

DBool sfRenderTexture_setActive(sfRenderTexture* renderTexture, DBool active)
{
    return renderTexture->This.setActive(active == DTrue)?DTrue: DFalse;
}

void sfRenderTexture_display(sfRenderTexture* renderTexture)
{
    renderTexture->This.display();
}

void sfRenderTexture_clear(sfRenderTexture* renderTexture, DUbyte r, DUbyte g, DUbyte b, DUbyte a)
{
    sf::Color SFMLColor(r, g, b, a);

    renderTexture->This.clear(SFMLColor);
}

void sfRenderTexture_setView(sfRenderTexture* renderTexture, float centerX, float centerY, float sizeX,
		float sizeY, float rotation, float viewportLeft, float viewportTop, float viewportWidth,
		float viewportHeight)
{
	sf::View view;
	view.setCenter(centerX, centerY);
	view.setSize(sizeX, sizeY);
	view.setRotation(rotation);
	view.setViewport(sf::FloatRect(viewportLeft, viewportTop, viewportWidth, viewportHeight));
    renderTexture->This.setView(view);
}

void sfRenderTexture_getView(const sfRenderTexture* renderTexture, float* centerX, float* centerY, float* sizeX,
		float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
		float* viewportHeight)
{
    sf::View view = renderTexture->This.getView();
    *centerX = view.getCenter().x;
    *centerY = view.getCenter().y;
    *sizeX = view.getSize().x;
    *sizeY = view.getSize().y;
    *rotation = view.getRotation();
    *viewportLeft = view.getViewport().left;
    *viewportTop = view.getViewport().top;
    *viewportWidth = view.getViewport().width;
    *viewportHeight = view.getViewport().height;
}

void sfRenderTexture_getDefaultView(const sfRenderTexture* renderTexture, float* centerX, float* centerY, float* sizeX,
		float* sizeY, float* rotation, float* viewportLeft, float* viewportTop, float* viewportWidth,
		float* viewportHeight)
{
    sf::View view = renderTexture->This.getDefaultView();
    *centerX = view.getCenter().x;
    *centerY = view.getCenter().y;
    *sizeX = view.getSize().x;
    *sizeY = view.getSize().y;
    *rotation = view.getRotation();
    *viewportLeft = view.getViewport().left;
    *viewportTop = view.getViewport().top;
    *viewportWidth = view.getViewport().width;
    *viewportHeight = view.getViewport().height;
}

void sfRenderTexture_drawPrimitives(sfRenderTexture* renderTexture,
                                    const void* vertices, DUint vertexCount,
                                    DInt type, DInt colorSrcFactor, DInt colorDstFactor,
									DInt colorEquation, DInt alphaSrcFactor, DInt alphaDstFactor,
									DInt alphaEquation, const float* transform, const sfTexture*
									texture, const sfShader* shader)
{
    renderTexture->This.draw(reinterpret_cast<const sf::Vertex*>(vertices), vertexCount, static_cast<sf::PrimitiveType>(type), createRenderStates(colorSrcFactor,
    		colorDstFactor, colorEquation, alphaSrcFactor, alphaDstFactor, alphaEquation, transform, texture, shader));
}

void sfRenderTexture_pushGLStates(sfRenderTexture* renderTexture)
{
    renderTexture->This.pushGLStates();
}

void sfRenderTexture_popGLStates(sfRenderTexture* renderTexture)
{
    renderTexture->This.popGLStates();
}

void sfRenderTexture_resetGLStates(sfRenderTexture* renderTexture)
{
    renderTexture->This.resetGLStates();
}

sfTexture* sfRenderTexture_getTexture(const sfRenderTexture* renderTexture)
{
    //Safe because the pointer will only be used in a const instance
    return new sfTexture(const_cast<sf::Texture*>(&renderTexture->This.getTexture()));
}

void sfRenderTexture_setSmooth(sfRenderTexture* renderTexture, DBool smooth)
{
    renderTexture->This.setSmooth(smooth == DTrue);
}

DBool sfRenderTexture_isSmooth(const sfRenderTexture* renderTexture)
{
    return renderTexture->This.isSmooth()?DTrue: DFalse;
}
