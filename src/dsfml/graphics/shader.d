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
module dsfml.graphics.shader;

import dsfml.graphics.texture;
import dsfml.graphics.transform;
import dsfml.graphics.color;

import dsfml.system.inputstream;
import dsfml.system.vector2;
import dsfml.system.vector3;
import dsfml.system.err;


/++
 + Shader class (vertex and fragment).
 +
 + Shaders are programs written using a specific language, executed directly by the graphics card and allowing one to apply real-time operations to the rendered entities.
 +
 + There are two kinds of shaders:
 + - Vertex shaders, that process vertices
 + - Fragment (pixel) shaders, that process pixels
 +
 + A DSFML Shader can be composed of either a vertex shader alone, a fragment shader alone, or both combined (see the variants of the load functions).
 +
 + Shaders are written in GLSL, which is a C-like language dedicated to OpenGL shaders. You'll probably need to learn its basics before writing your own shaders for SFML.
 +
 + Like any D/C/C++ program, a shader has its own variables that you can set from your D application. DSFML's Shader handles 5 different types of variables:
 + - floats
 + - vectors (2, 3, or 4 components)
 + - colors
 + - textures
 + - transforms (matrices)
 +
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Shader.php#details
 +/
class Shader
{
    /// Types of shaders.
    enum Type
    {
        Vertex,  /// Vertex shader
        Fragment /// Fragment (pixel) shader.
    }

    package sfShader* sfPtr;

    /// Special type/value that can be passed to setParameter, and that represents the texture of the object being drawn.
    struct CurrentTextureType {};
    static CurrentTextureType CurrentTexture;


    this()
    {
        //creates an empty shader
    }

    package this(sfShader* shader)
    {
        sfPtr = shader;
    }

    ~this()
    {
        debug import dsfml.system.config;
        debug mixin(destructorOutput);
        sfShader_destroy(sfPtr);
    }

    /**
     * Load either the vertex or fragment shader from a file.
     *
     * This function loads a single shader, either vertex or fragment, identified by the second argument. The source must be a text file containing a valid shader in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders; you'll probably need to read a good documentation for it before writing your own shaders.
     *
     * Params:
     * 		filename	= Path of the vertex or fragment shader file to load
     * 		type		= Type of shader (vertex or fragment)
     *
     * Returns: True if loading succeeded, false if it failed.
     */
    bool loadFromFile(string filename, Type type)
    {
        import dsfml.system.string;

        bool ret;

        if(type == Type.Vertex)
        {
            ret = sfShader_loadFromFile(sfPtr, toStringz(filename) , null);
        }
        else
        {
            ret = sfShader_loadFromFile(sfPtr, null , toStringz(filename) );
        }

        if(!ret)
        {
            err.write(toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load both the vertex and fragment shaders from files.
     *
     * This function loads both the vertex and the fragment shaders. If one of them fails to load, the shader is left empty (the valid shader is unloaded). The sources must be text files containing valid shaders in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders; you'll probably need to read a good documentation for it before writing your own shaders.
     *
     * Params:
     * 		vertexShaderFilename	= Path of the vertex shader file to load
     * 		fragmentShaderFilename	= Path of the fragment shader file to load
     *
     * Returns: True if loading succeeded, false if it failed.
     */
    bool loadFromFile(string vertexShaderFilename, string fragmentShaderFilename)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromFile(sfPtr, toStringz(vertexShaderFilename) , toStringz(fragmentShaderFilename));
        if(!ret)
        {
            err.write(toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load either the vertex or fragment shader from a source code in memory.
     *
     * This function loads a single shader, either vertex or fragment, identified by the second argument. The source code must be a valid shader in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders; you'll probably need to read a good documentation for it before writing your own shaders.
     *
     * Params:
     * 		shader	= String containing the source code of the shader
     * 		type	= Type of shader (vertex or fragment)
     *
     * Returns: True if loading succeeded, false if it failed.
     */
    bool loadFromMemory(string shader, Type type)
    {
        import dsfml.system.string;

        bool ret;

        if(type == Type.Vertex)
        {
            ret = sfShader_loadFromMemory(sfPtr, toStringz(shader) , null);
        }
        else
        {
            ret = sfShader_loadFromMemory(sfPtr, null , toStringz(shader) );
        }
        if(!ret)
        {
            err.write(toString(sfErr_getOutput()));
        }
        return ret;
    }

    /**
     * Load both the vertex and fragment shaders from source codes in memory.
     *
     * This function loads both the vertex and the fragment shaders. If one of them fails to load, the shader is left empty (the valid shader is unloaded). The sources must be valid shaders in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders; you'll probably need to read a good documentation for it before writing your own shaders.
     *
     * Params:
     * 		vertexShader	= String containing the source code of the vertex shader
     * 		fragmentShader	= String containing the source code of the fragment shader
     *
     * Returns: True if loading succeeded, false if it failed.
     */
    bool loadFromMemory(string vertexShader, string fragmentShader)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromMemory(sfPtr, toStringz(vertexShader) , toStringz(fragmentShader));
        if(!ret)
        {
            err.write(toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load either the vertex or fragment shader from a custom stream.
     *
     * This function loads a single shader, either vertex or fragment, identified by the second argument. The source code must be a valid shader in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders; you'll probably need to read a good documentation for it before writing your own shaders.
     *
     * Params:
     * 		stream	= Source stream to read from
     * 		type	= Type of shader (vertex or fragment)
     *
     * Returns: True if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream stream, Type type)
    {
        import dsfml.system.string;

        bool ret;

        if(type == Type.Vertex)
        {
            ret = sfShader_loadFromStream(sfPtr, new shaderStream(stream) , null);
        }
        else
        {
            ret = sfShader_loadFromStream(sfPtr, null , new shaderStream(stream));
        }
        if(!ret)
        {
            err.write(toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load both the vertex and fragment shaders from custom streams.
     *
     * This function loads a single shader, either vertex or fragment, identified by the second argument. The source code must be a valid shader in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders; you'll probably need to read a good documentation for it before writing your own shaders.
     *
     * Params:
     * 		vertexShaderStream		= Source stream to read the vertex shader from
     * 		fragmentShaderStream	= Source stream to read the fragment shader from
     *
     * Returns: True if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream vertexShaderStream, InputStream fragmentShaderStream)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromStream(sfPtr, new shaderStream(vertexShaderStream), new shaderStream(fragmentShaderStream));
        if(!ret)
        {
            err.write(toString(sfErr_getOutput()));
        }
        return ret;
    }

    /**
     * Change a float parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a float (float GLSL type).
     * 		x		= Value to assign
     */
     void setParameter(string name, float x)
    {
        import dsfml.system.string;
        sfShader_setFloatParameter(sfPtr, toStringz(name), x);
    }

    ///ditto
    void opIndexAssign(float x, string name)
    {
        import dsfml.system.string;
        sfShader_setFloatParameter(sfPtr, toStringz(name), x);
    }

    /**
     * Change a 2-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2x1 vector (vec2 GLSL type).
     * 		x		= First component of the value to assign
     * 		y		= Second component of the value to assign
     */
    void setParameter(string name, float x, float y)
    {
        import dsfml.system.string;
        sfShader_setFloat2Parameter(sfPtr, toStringz(name), x, y);
    }

    /**
     * Change a 3-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 3x1 vector (vec3 GLSL type).
     * 		x		= First component of the value to assign
     * 		y		= Second component of the value to assign
     * 		z		= Third component of the value to assign
     */
    void setParameter(string name, float x, float y, float z)
    {
        import dsfml.system.string;
        sfShader_setFloat3Parameter(sfPtr, toStringz(name), x,y,z);
    }

    /**
     * Change a 4-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x1 vector (vec4 GLSL type).
     * 		x		= First component of the value to assign
     * 		y		= Second component of the value to assign
     * 		z		= Third component of the value to assign
     * 		w		= Fourth component of the value to assign
     */
    void setParameter(string name, float x, float y, float z, float w)
    {
        import dsfml.system.string;
        sfShader_setFloat4Parameter(sfPtr, toStringz(name), x, y, z, w);
    }

    /**
     * Change variable length vector parameter of the shader. The length of the set of floats must be between 1 and 4.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x1 vector (vec4 GLSL type).
     * 		val 	= The set of floats to assign.
     */
    void opIndexAssign(float[] val, string name)
    {
        import dsfml.system.string;
        //assert to make sure that val is of proper length at run time
        assert((val.length >0) && (val.length <= 4));

        if(val.length == 1)
            sfShader_setFloatParameter(sfPtr, toStringz(name), val[0]);
        else if(val.length == 2)
            sfShader_setFloat2Parameter(sfPtr, toStringz(name), val[0], val[1]);
        else if(val.length == 3)
            sfShader_setFloat3Parameter(sfPtr, toStringz(name), val[0], val[1], val[2]);
        else if(val.length >= 4)
            sfShader_setFloat4Parameter(sfPtr, toStringz(name), val[0], val[1], val[2], val[3]);
    }

    /**
     * Change a 2-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2x1 vector (vec2 GLSL type).
     * 		vector	= Vector to assign
     */
    void setParameter(string name, Vector2f vector)
    {
        import dsfml.system.string;
        sfShader_setFloat2Parameter(sfPtr, toStringz(name), vector.x, vector.y);
    }

    ///ditto
    void opIndexAssign(Vector2f vector, string name)
    {
        import dsfml.system.string;
        sfShader_setFloat2Parameter(sfPtr, toStringz(name), vector.x, vector.y);
    }

    /**
     * Change a 3-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 3x1 vector (vec3 GLSL type).
     * 		vector	= Vector to assign
     */
    void setParameter(string name, Vector3f vector)
    {
        import dsfml.system.string;
        sfShader_setFloat3Parameter(sfPtr, toStringz(name), vector.x, vector.y, vector.z);
    }
    ///ditto
    void opIndexAssign(Vector3f vector, string name)
    {
        import dsfml.system.string;
        sfShader_setFloat3Parameter(sfPtr, toStringz(name), vector.x, vector.y, vector.z);
    }

    /**
     * Change a color vector parameter of the shader.
     *
     * It is important to note that the components of the color are normalized before being passed to the shader. Therefore, they are converted from range [0 .. 255] to range [0 .. 1]. For example, a Color(255, 125, 0, 255) will be transformed to a vec4(1.0, 0.5, 0.0, 1.0) in the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x1 vector (vec4 GLSL type).
     * 		color	= Color to assign
     */
    void setParameter(string name, Color color)
    {
        import dsfml.system.string;
        sfShader_setColorParameter(sfPtr, toStringz(name), color.r, color.g, color.b, color.a);
    }
    ///ditto
    void opIndexAssign(Color color, string name)
    {
        import dsfml.system.string;
        sfShader_setColorParameter(sfPtr, toStringz(name), color.r, color.g, color.b, color.a);
    }

    /**
     * Change a matrix parameter of the shader.
     *
     * Params:
     * 		name		= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x4 matrix (mat4 GLSL type).
     * 		transform	= Transform to assign
     */
    void setParameter(string name, Transform transform)
    {
        import dsfml.system.string;
        sfShader_setTransformParameter(sfPtr, toStringz(name), transform.m_matrix.ptr);
    }
    ///ditto
    void opIndexAssign(Transform transform, string name)
    {
        import dsfml.system.string;
        sfShader_setTransformParameter(sfPtr, toStringz(name), transform.m_matrix.ptr);
    }

    /**
     * Change a texture parameter of the shader.
     *
     * It is important to note that the texture parameter must remain alive as long as the shader uses it - no copoy is made internally.
     *
     * To use the texture of the object being draw, which cannot be known in advance, you can pass the special value Shader.CurrentTexture.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2D texture (sampler2D GLSL type).
     * 		texture	= Texture to assign
     */
    void setParameter(string name, const(Texture) texture)
    {
        import dsfml.system.string;
        sfShader_setTextureParameter(sfPtr, toStringz(name), texture.sfPtr);
        err.write(toString(sfErr_getOutput()));
    }
    ///ditto
    void opIndexAssign(const(Texture) texture, string name)
    {
        import dsfml.system.string;
        sfShader_setTextureParameter(sfPtr, toStringz(name), texture.sfPtr);
        err.write(toString(sfErr_getOutput()));
    }


    /**
     * Change a texture parameter of the shader.
     *
     * This overload maps a shader texture variable to the texture of the object being drawn, which cannot be known in advance. The second argument must be Shader.CurrentTexture.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2D texture (sampler2D GLSL type).
     */
    void setParameter(string name, CurrentTextureType)
    {
        import dsfml.system.string;
        sfShader_setCurrentTextureParameter(sfPtr, toStringz(name));
    }

    /**
     * Change a texture parameter of the shader.
     *
     * This overload maps a shader texture variable to the texture of the object being drawn, which cannot be known in advance. The value given must be Shader.CurrentTexture.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2D texture (sampler2D GLSL type).
     */
    void opIndexAssign(CurrentTextureType, string name)
    {
        import dsfml.system.string;
        sfShader_setCurrentTextureParameter(sfPtr, toStringz(name));
    }

    /**
     * Bind a shader for rendering.
     *
     * This function is not part of the graphics API, it mustn't be used when drawing SFML entities. It must be used only if you mix Shader with OpenGL code.
     *
     * Params:
     * 		shader	= Shader to bind. Can be null to use no shader.
     */
    static void bind(Shader shader)
    {
        (shader is null)?sfShader_bind(null):sfShader_bind(shader.sfPtr);
    }

    /**
     * Tell whether or not the system supports shaders.
     *
     * This function should always be called before using the shader features. If it returns false, then any attempt to use DSFML Shader will fail.
     *
     * Returns: True if shaders are supported, false otherwise
     */
    static bool isAvailable()
    {
        import dsfml.system.string;
        bool toReturn = sfShader_isAvailable();
        err.write(toString(sfErr_getOutput()));
        return toReturn;
    }
}

unittest
{
    //find some examples of interesting shaders and use them here
}

private extern(C++) interface sfmlInputStream
{
    long read(void* data, long size);

    long seek(long position);

    long tell();

    long getSize();
}


private class shaderStream:sfmlInputStream
{
    private InputStream myStream;

    this(InputStream stream)
    {
        myStream = stream;
    }

    extern(C++)long read(void* data, long size)
    {
        return myStream.read(data[0..cast(size_t)size]);
    }

    extern(C++)long seek(long position)
    {
        return myStream.seek(position);
    }

    extern(C++)long tell()
    {
        return myStream.tell();
    }

    extern(C++)long getSize()
    {
        return myStream.getSize();
    }
}

package extern(C):
struct sfShader;

private extern(C):

//Construct a new shader
sfShader* sfShader_construct();

//Load both the vertex and fragment shaders from files
bool sfShader_loadFromFile(sfShader* shader, const(char)* vertexShaderFilename, const char* fragmentShaderFilename);

//Load both the vertex and fragment shaders from source codes in memory
bool sfShader_loadFromMemory(sfShader* shader, const(char)* vertexShader, const char* fragmentShader);

//Load both the vertex and fragment shaders from custom streams
bool sfShader_loadFromStream(sfShader* shader, sfmlInputStream vertexShaderStream, sfmlInputStream fragmentShaderStream);

//Destroy an existing shader
void sfShader_destroy(sfShader* shader);

//Change a float parameter of a shader
void sfShader_setFloatParameter(sfShader* shader, const char* name, float x);

//Change a 2-components vector parameter of a shader
void sfShader_setFloat2Parameter(sfShader* shader, const char* name, float x, float y);

//Change a 3-components vector parameter of a shader
void sfShader_setFloat3Parameter(sfShader* shader, const char* name, float x, float y, float z);

//Change a 4-components vector parameter of a shader
void sfShader_setFloat4Parameter(sfShader* shader, const char* name, float x, float y, float z, float w);

//Change a color parameter of a shader
void sfShader_setColorParameter(sfShader* shader, const char* name, ubyte r, ubyte g, ubyte b, ubyte a);

//Change a matrix parameter of a shader
void sfShader_setTransformParameter(sfShader* shader, const char* name, float* transform);

//Change a texture parameter of a shader
void sfShader_setTextureParameter(sfShader* shader, const char* name, const sfTexture* texture);

//Change a texture parameter of a shader
void sfShader_setCurrentTextureParameter(sfShader* shader, const char* name);

//Bind a shader for rendering (activate it)
void sfShader_bind(const sfShader* shader);

//Tell whether or not the system supports shaders
bool sfShader_isAvailable();

const(char)* sfErr_getOutput();
