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

import std.string;

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
		import std.conv;
		//if the Shader exists, destroy it first
		if(sfPtr)
		{
			sfShader_destroy(sfPtr);
		}

		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromFile(toStringz(filename) , null);
		}
		else
		{
			sfPtr = sfShader_createFromFile(null , toStringz(filename) );
		}
		err.write(text(sfErr_getOutput()));
		return (sfPtr == null)?false:true;
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
		import std.conv;
		//if the Shader exists, destroy it first
		if(sfPtr)
		{
			sfShader_destroy(sfPtr);
		}

		sfPtr = sfShader_createFromFile(toStringz(vertexShaderFilename) , toStringz(fragmentShaderFilename));
		err.write(text(sfErr_getOutput()));
		return (sfPtr != null);
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
		import std.conv;
		//if the Shader exists, destroy it first
		if(sfPtr)
		{
			sfShader_destroy(sfPtr);
		}

		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromMemory(toStringz(shader) , null);
		}
		else
		{
			sfPtr = sfShader_createFromMemory(null , toStringz(shader) );
		}
		err.write(text(sfErr_getOutput()));
		return (sfPtr == null)?false:true;
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
		import std.conv;
		//if the Shader exists, destroy it first
		if(sfPtr)
		{
			sfShader_destroy(sfPtr);
		}

		sfShader_createFromMemory(toStringz(vertexShader) , toStringz(fragmentShader));
		err.write(text(sfErr_getOutput()));
		return (sfPtr == null)?false:true;
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
		import std.conv;
		//if the Shader exists, destroy it first
		if(sfPtr)
		{
			sfShader_destroy(sfPtr);
		}

		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromStream(&stream , null);
		}
		else
		{
			sfPtr = sfShader_createFromStream(null , &stream );
		}
		err.write(text(sfErr_getOutput()));
		return (sfPtr == null)?false:true;
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
		import std.conv;
		//if the Shader exists, destroy it first
		if(sfPtr)
		{
			sfShader_destroy(sfPtr);
		}

		sfPtr = sfShader_createFromStream(&vertexShaderStream, &fragmentShaderStream);
		err.write(text(sfErr_getOutput()));
		return (sfPtr == null)?false:true;
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
		sfShader_setFloat4Parameter(sfPtr, toStringz(name), x, y, z, w);
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
	void setParameter(string name, Texture texture)
	{
		import std.conv;
		sfShader_setTextureParameter(sfPtr, toStringz(name), texture.sfPtr);
		err.write(text(sfErr_getOutput()));
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
		import std.conv;
		bool toReturn = sfShader_isAvailable();
		err.write(text(sfErr_getOutput()));
		return toReturn;
	}
}

unittest
{
	//find some examples of interesting shaders and use them here
}

package extern(C):
struct sfShader;

private extern(C):
//Load both the vertex and fragment shaders from files
sfShader* sfShader_createFromFile(const char* vertexShaderFilename, const char* fragmentShaderFilename);

//Load both the vertex and fragment shaders from source codes in memory
sfShader* sfShader_createFromMemory(const char* vertexShader, const char* fragmentShader);

//Load both the vertex and fragment shaders from custom streams
sfShader* sfShader_createFromStream(void* vertexShaderStream, void* fragmentShaderStream);

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