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

#ifndef DSFML_CONVERTRENDERSTATES_H
#define DSFML_CONVERTRENDERSTATES_H

// Headers
#include <SFML/Graphics/RenderStates.hpp>
#include <SFML/Graphics/BlendMode.hpp>
#include <DSFMLC/Graphics/CreateTransform.hpp>
#include <DSFMLC/Graphics/TextureStruct.h>
#include <DSFMLC/Graphics/ShaderStruct.h>


// Convert sfRenderStates* to sf::RenderStates
inline sf::RenderStates createRenderStates(DInt colorSrcFactor, DInt colorDstFactor, DInt colorEquation,
		DInt alphaSrcFactor, DInt alphaDstFactor, DInt alphaEquation,
		const float* transform, const sfTexture* texture, const sfShader* shader)
{
    sf::RenderStates sfmlStates;
    sf::BlendMode blendMode;

    blendMode.colorSrcFactor = static_cast<sf::BlendMode::Factor>(colorSrcFactor);
    blendMode.colorDstFactor = static_cast<sf::BlendMode::Factor>(colorDstFactor);
    blendMode.colorEquation = static_cast<sf::BlendMode::Equation>(colorEquation);
    blendMode.alphaSrcFactor = static_cast<sf::BlendMode::Factor>(alphaSrcFactor);
    blendMode.alphaDstFactor = static_cast<sf::BlendMode::Factor>(alphaDstFactor);
    blendMode.alphaEquation = static_cast<sf::BlendMode::Equation>(alphaEquation);
    
    sfmlStates.blendMode = blendMode;
    sfmlStates.transform = createTransform(transform);
    sfmlStates.texture = texture ? texture->This : NULL;
    sfmlStates.shader = shader ? &shader->This : NULL;
    

    return sfmlStates;
}


#endif // DSFML_CONVERTRENDERSTATES_H
