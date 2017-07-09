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
#include <DSFMLC/Graphics/Shader.h>
#include <DSFMLC/Graphics/ShaderStruct.h>
#include <DSFMLC/Graphics/TextureStruct.h>
#include <DSFMLC/Graphics/CreateTransform.hpp>

sfShader* sfShader_construct(void)
{
    return new sfShader;
}

DBool sfShader_loadFromFile(sfShader* shader, const char* vertexShaderFilename, size_t vertexShaderFilenameLength,
							const char* fragmentShaderFilename, size_t fragmentShaderFilenameLength)
{
    bool success = false;

    if (vertexShaderFilename || fragmentShaderFilename)
    {
        if (!vertexShaderFilename || vertexShaderFilenameLength < 1)
        {
            // fragment shader only
            success = shader->This.loadFromFile(std::string(fragmentShaderFilename, fragmentShaderFilenameLength), sf::Shader::Fragment);
        }
        else if (!fragmentShaderFilename || fragmentShaderFilenameLength < 1)
        {
            // vertex shader only
            success = shader->This.loadFromFile(std::string(vertexShaderFilename, vertexShaderFilenameLength), sf::Shader::Vertex);
        }
        else
        {
            // vertex + fragment shaders
            success = shader->This.loadFromFile(std::string(vertexShaderFilename, vertexShaderFilenameLength),
            			std::string(fragmentShaderFilename, fragmentShaderFilenameLength));
        }
    }

    return success?DTrue:DFalse;
}


DBool sfShader_loadFromMemory(sfShader* shader, const char* vertexShader, size_t vertexShaderLength,
								const char* fragmentShader, size_t fragmentShaderLength)
{
    bool success = false;

    if (vertexShader || fragmentShader)
    {
        if (!vertexShader || vertexShaderLength < 1)
        {
            // fragment shader only
            success = shader->This.loadFromMemory(std::string(fragmentShader, fragmentShaderLength), sf::Shader::Fragment);
        }
        else if (!fragmentShader || fragmentShaderLength < 1)
        {
            // vertex shader only
            success = shader->This.loadFromMemory(std::string(vertexShader, vertexShaderLength), sf::Shader::Vertex);
        }
        else
        {
            // vertex + fragment shaders
            success = shader->This.loadFromMemory(std::string(vertexShader, vertexShaderLength),
            										std::string(fragmentShader, fragmentShaderLength));
        }
    }

    return success?DTrue:DFalse;
}


DBool sfShader_loadFromStream(sfShader* shader, DStream* vertexShaderStream, DStream* fragmentShaderStream)
{
    bool success = false;

    if (vertexShaderStream || fragmentShaderStream)
    {
        if (!vertexShaderStream)
        {
            // fragment shader only
            sfmlStream stream(fragmentShaderStream);
            success = shader->This.loadFromStream(stream, sf::Shader::Fragment);
        }
        else if (!fragmentShaderStream)
        {
            // vertex shader only
            sfmlStream stream(vertexShaderStream);
            success = shader->This.loadFromStream(stream, sf::Shader::Vertex);
        }
        else
        {
            // vertex + fragment shaders
            sfmlStream vertexStream(vertexShaderStream);
            sfmlStream fragmentStream(fragmentShaderStream);
            success = shader->This.loadFromStream(vertexStream, fragmentStream);
        }
    }

    return success?DTrue:DFalse;
}


void sfShader_destroy(sfShader* shader)
{
    delete shader;
}


void sfShader_setFloatParameter(sfShader* shader, const char* name, size_t length , float x)
{
    shader->This.setParameter(std::string(name, length), x);
}


void sfShader_setFloat2Parameter(sfShader* shader, const char* name, size_t length, float x, float y)
{
    shader->This.setParameter(std::string(name, length), x, y);
}


void sfShader_setFloat3Parameter(sfShader* shader, const char* name, size_t length, float x, float y, float z)
{
    shader->This.setParameter(std::string(name, length), x, y, z);
}


void sfShader_setFloat4Parameter(sfShader* shader, const char* name, size_t length, float x, float y, float z, float w)
{
    shader->This.setParameter(std::string(name, length), x, y, z, w);
}


void sfShader_setColorParameter(sfShader* shader, const char* name, size_t length, DUbyte r, DUbyte g, DUbyte b, DUbyte a)
{
    shader->This.setParameter(std::string(name, length), sf::Color(r, g, b, a));
}


void sfShader_setTransformParameter(sfShader* shader, const char* name, size_t length, float* transform)
{
    shader->This.setParameter(std::string(name, length), createTransform(transform));
}


void sfShader_setTextureParameter(sfShader* shader, const char* name, size_t length, const sfTexture* texture)
{
    shader->This.setParameter(std::string(name, length), *texture->This);
}


void sfShader_setCurrentTextureParameter(sfShader* shader, const char* name, size_t length)
{
    shader->This.setParameter(std::string(name, length), sf::Shader::CurrentTextureType());
}


void sfShader_bind(const sfShader* shader)
{
    sf::Shader::bind(shader ? &shader->This : 0);
}


DBool sfShader_isAvailable(void)
{
    return sf::Shader::isAvailable() ? DTrue : DFalse;
}
