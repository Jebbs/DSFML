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

#include <DSFMLC/Graphics/Shader.h>
#include <DSFMLC/Graphics/ShaderStruct.h>
#include <DSFMLC/Graphics/TextureStruct.h>

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

void sfShader_bind(const sfShader* shader)
{
    sf::Shader::bind(shader ? &shader->This : 0);
}

DBool sfShader_isAvailable(void)
{
    return sf::Shader::isAvailable() ? DTrue : DFalse;
}

void sfShader_setFloatUniform(sfShader* shader, const char* name, size_t length, float x)
{
    shader->This.setUniform(std::string(name, length), x);
}

void sfShader_setVec2Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Vec2* vec2)
{
    shader->This.setUniform(std::string(name, length), *vec2);
}

void sfShader_setVec3Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Vec3* vec3)
{
    shader->This.setUniform(std::string(name, length), *vec3);
}

void sfShader_setVec4Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Vec4* vec4)
{
    shader->This.setUniform(std::string(name, length), *vec4);
}

void sfShader_setIntUniform(sfShader* shader, const char* name, size_t length, int x)
{
    shader->This.setUniform(std::string(name, length), x);
}

void sfShader_setIvec2Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Ivec2* ivec2)
{
    shader->This.setUniform(std::string(name, length), *ivec2);
}

void sfShader_setIvec3Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Ivec3* ivec3)
{
    shader->This.setUniform(std::string(name, length), *ivec3);
}

void sfShader_setIvec4Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Ivec4* ivec4)
{
    shader->This.setUniform(std::string(name, length), *ivec4);
}

void sfShader_setBoolUniform(sfShader* shader, const char* name, size_t length, DBool x)
{
    shader->This.setUniform(std::string(name, length), static_cast<bool>(x));
}

void sfShader_setBvec2Uniform(sfShader* shader, const char* name, size_t length, DBool x, DBool y)
{
    shader->This.setUniform(std::string(name, length),
                   sf::Glsl::Bvec2(static_cast<bool>(x), static_cast<bool>(y)));
}

void sfShader_setBvec3Uniform(sfShader* shader, const char* name, size_t length, DBool x, DBool y, DBool z)
{
    shader->This.setUniform(std::string(name, length),
                    sf::Glsl::Bvec3(static_cast<bool>(x), static_cast<bool>(y),
                                    static_cast<bool>(z)));
}

void sfShader_setBvec4Uniform(sfShader* shader, const char* name, size_t length, DBool x, DBool y, DBool z, DBool w)
{
    shader->This.setUniform(std::string(name, length),
                   sf::Glsl::Bvec4(static_cast<bool>(x), static_cast<bool>(y),
                                   static_cast<bool>(z), static_cast<bool>(w)));
}

void sfShader_setMat3Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Mat3* mat3)
{
    shader->This.setUniform(std::string(name, length),*mat3);
}

void sfShader_setMat4Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Mat4* mat4)
{
    shader->This.setUniform(std::string(name, length),*mat4);
}

void sfShader_setTextureUniform(sfShader* shader, const char* name, size_t length, const sfTexture* texture)
{
    shader->This.setUniform(std::string(name, length), *texture->This);
}

void sfShader_setCurrentTextureUniform(sfShader* shader, const char* name, size_t length)
{
    shader->This.setUniform(std::string(name, length), sf::Shader::CurrentTextureType());
}

void sfShader_setFloatArrayUniform(sfShader* shader, const char* name, size_t nlength, const float* array, size_t alength)
{
    shader->This.setUniformArray(std::string(name, nlength), array, alength);
}

void sfShader_setVec2ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Vec2* array, size_t alength)
{
    shader->This.setUniformArray(std::string(name, nlength), array, alength);
}

void sfShader_setVec3ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Vec3* array, size_t alength)
{
    shader->This.setUniformArray(std::string(name, nlength), array, alength);
}

void sfShader_setVec4ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Vec4* array, size_t alength)
{
    shader->This.setUniformArray(std::string(name, nlength), array, alength);
}

void sfShader_setMat3ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Mat3* array, size_t alength)
{
    shader->This.setUniformArray(std::string(name, nlength), array, alength);
}

void sfShader_setMat4ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Mat4* array, size_t alength)
{
    shader->This.setUniformArray(std::string(name, nlength), array, alength);
}

/******************Deprecated******************/

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
    shader->This.setParameter(std::string(name, length),*reinterpret_cast<sf::Transform*>(transform));
}

void sfShader_setTextureParameter(sfShader* shader, const char* name, size_t length, const sfTexture* texture)
{
    shader->This.setParameter(std::string(name, length), *texture->This);
}

void sfShader_setCurrentTextureParameter(sfShader* shader, const char* name, size_t length)
{
    shader->This.setParameter(std::string(name, length), sf::Shader::CurrentTextureType());
}
