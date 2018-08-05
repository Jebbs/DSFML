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

#ifndef SFML_SHADER_H
#define SFML_SHADER_H

#include <DSFMLC/Graphics/Export.h>
#include <DSFMLC/Graphics/Types.h>
#include <DSFMLC/System/DStream.hpp>
#include<SFML/Graphics/Glsl.hpp>
#include <stddef.h>

//Construct a new shader
DSFML_GRAPHICS_API sfShader* sfShader_construct(void);

//Load both the vertex and fragment shaders from files
DSFML_GRAPHICS_API DBool sfShader_loadFromFile(sfShader* shader, const char* vertexShaderFilename, size_t vertexShaderFilenameLength, const char* fragmentShaderFilename, size_t fragmentShaderFilenameLength);

//Load both the vertex and fragment shaders from source codes in memory
DSFML_GRAPHICS_API DBool sfShader_loadFromMemory(sfShader* shader, const char* vertexShader, size_t vertexShaderLength, const char* fragmentShader, size_t fragmentShaderLength);

//Load both the vertex and fragment shaders from custom streams
DSFML_GRAPHICS_API DBool sfShader_loadFromStream(sfShader* shader, DStream* vertexShaderStream, DStream* fragmentShaderStream);

//Destroy an existing shader
DSFML_GRAPHICS_API void sfShader_destroy(sfShader* shader);

//Specify value for float uniform
DSFML_GRAPHICS_API void sfShader_setFloatUniform(sfShader* shader, const char* name, size_t length, float x);

//Specify value for vec2 uniform
DSFML_GRAPHICS_API void sfShader_setVec2Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Vec2* vec2);

//Specify value for vec3 uniform
DSFML_GRAPHICS_API void sfShader_setVec3Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Vec3* vec3);

//Specify value for vec4 uniform
DSFML_GRAPHICS_API void sfShader_setVec4Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Vec4* vec4);

//Specify value for int uniform
DSFML_GRAPHICS_API void sfShader_setIntUniform(sfShader* shader, const char* name, size_t length, int x);

//Specify value for ivec2 uniform
DSFML_GRAPHICS_API void sfShader_setIvec2Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Ivec2* ivec2);

//Specify value for ivec3 uniform
DSFML_GRAPHICS_API void sfShader_setIvec3Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Ivec3* ivec3);

//Specify value for ivec4 uniform
DSFML_GRAPHICS_API void sfShader_setIvec4Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Ivec4* ivec4);

//Specify value for bool uniform
DSFML_GRAPHICS_API void sfShader_setBoolUniform(sfShader* shader, const char* name, size_t length, DBool x);

//Specify value for bvec2 uniform
DSFML_GRAPHICS_API void sfShader_setBvec2Uniform(sfShader* shader, const char* name, size_t length, DBool x, DBool y);

//Specify value for bvec3 uniform
DSFML_GRAPHICS_API void sfShader_setBvec3Uniform(sfShader* shader, const char* name, size_t length, DBool x, DBool y, DBool z);

//Specify value for bvec4 uniform
DSFML_GRAPHICS_API void sfShader_setBvec4Uniform(sfShader* shader, const char* name, size_t length, DBool x, DBool y, DBool z, DBool w);

//Specify value for mat3 matrix.
DSFML_GRAPHICS_API void sfShader_setMat3Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Mat3* mat3);

//Specify value for mat4 matrix.
DSFML_GRAPHICS_API void sfShader_setMat4Uniform(sfShader* shader, const char* name, size_t length, const sf::Glsl::Mat4* mat4);

//Specify a texture as sampler2D uniform
DSFML_GRAPHICS_API void sfShader_setTextureUniform(sfShader* shader, const char* name, size_t length, const sfTexture* texture);

//Specify current texture as sampler2D uniform.
DSFML_GRAPHICS_API void sfShader_setCurrentTextureUniform(sfShader* shader, const char* name, size_t length);

//Specify values for float[] array uniform.
DSFML_GRAPHICS_API void sfShader_setFloatArrayUniform(sfShader* shader, const char* name, size_t nlength, const float* array, size_t alength);

//Specify values for vec2[] array uniform.
DSFML_GRAPHICS_API void sfShader_setVec2ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Vec2*, size_t alength);

//Specify values for vec3[] array uniform.
DSFML_GRAPHICS_API void sfShader_setVec3ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Vec3*, size_t alength);

//Specify values for vec4[] array uniform.
DSFML_GRAPHICS_API void sfShader_setVec4ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Vec4*, size_t alength);

//Specify values for mat3[] array uniform.
DSFML_GRAPHICS_API void sfShader_setMat3ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Mat3*, size_t alength);

//Specify values for mat4[] array uniform.
DSFML_GRAPHICS_API void sfShader_setMat4ArrayUniform(sfShader* shader, const char* name, size_t nlength, const sf::Glsl::Mat4*, size_t alength);

//Bind a shader for rendering (activate it)
DSFML_GRAPHICS_API void sfShader_bind(const sfShader* shader);

//Tell whether or not the system supports shaders
DSFML_GRAPHICS_API DBool sfShader_isAvailable(void);


/**************Deprecated*******************/

//Change a float parameter of a shader
DSFML_GRAPHICS_API void sfShader_setFloatParameter(sfShader* shader, const char* name, size_t length, float x);

//Change a 2-components vector parameter of a shader
DSFML_GRAPHICS_API void sfShader_setFloat2Parameter(sfShader* shader, const char* name, size_t length, float x, float y);

//Change a 3-components vector parameter of a shader
DSFML_GRAPHICS_API void sfShader_setFloat3Parameter(sfShader* shader, const char* name, size_t length, float x, float y, float z);

//Change a 4-components vector parameter of a shader
DSFML_GRAPHICS_API void sfShader_setFloat4Parameter(sfShader* shader, const char* name, size_t length, float x, float y, float z, float w);

//Change a color parameter of a shader
DSFML_GRAPHICS_API void sfShader_setColorParameter(sfShader* shader, const char* name, size_t length, DUbyte r, DUbyte g, DUbyte b, DUbyte a);

//Change a matrix parameter of a shader
DSFML_GRAPHICS_API void sfShader_setTransformParameter(sfShader* shader, const char* name, size_t length, float* transform);

//Change a texture parameter of a shader
DSFML_GRAPHICS_API void sfShader_setTextureParameter(sfShader* shader, const char* name, size_t length, const sfTexture* texture);

//Change a texture parameter of a shader
DSFML_GRAPHICS_API void sfShader_setCurrentTextureParameter(sfShader* shader, const char* name, size_t length);

#endif // SFML_SHADER_H
