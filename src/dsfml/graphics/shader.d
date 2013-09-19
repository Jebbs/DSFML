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

import dsfml.system.inputstream;

import dsfml.system.vector2;
import dsfml.system.vector3;

import dsfml.graphics.color;

import dsfml.system.err;
import std.conv;

import std.string;

debug import std.stdio;

class Shader
{
	enum Type
	{
		Vertex,
		Fragment
	}
	struct CurrentTextureType {};
	
	static CurrentTextureType CurrentTexture;
	
	
	package sfShader* sfPtr;
	
	
	//creates a null shader
	this()
	{
		
	}
	
	package this(sfShader* shader)
	{
		sfPtr = shader;
		
	}
	
	~this()
	{
		debug writeln("Destroying Shader");
		sfShader_destroy(sfPtr);
	}
	
	bool loadFromFile(string filename, Type type)
	{
		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromFile(toStringz(filename) , null);
		}
		else
		{
			sfPtr = sfShader_createFromFile(null , toStringz(filename) );
		}
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromFile(string vertexShaderFilename, string fragmentShaderFilename)
	{
		sfPtr = sfShader_createFromFile(toStringz(vertexShaderFilename) , toStringz(fragmentShaderFilename));
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr != null);
	}
	
	bool loadFromMemory(string shader, Type type)
	{

		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromMemory(toStringz(shader) , null);
		}
		else
		{
			sfPtr = sfShader_createFromMemory(null , toStringz(shader) );
		}
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	
	bool loadFromMemory(string vertexShader, string fragmentShader)
	{
		sfShader_createFromMemory(toStringz(vertexShader) , toStringz(fragmentShader));
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	
	bool loadFromStream(InputStream stream, Type type)
	{
		
		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromStream(&stream , null);
		}
		else
		{
			sfPtr = sfShader_createFromStream(null , &stream );
		}
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(InputStream vertexShaderStream, InputStream fragmentShaderStream)
	{
		sfPtr = sfShader_createFromStream(&vertexShaderStream, &fragmentShaderStream);
		err.write(text(sfErrGraphics_getOutput()));
		return (sfPtr == null)?false:true;
	}
	
	void setParameter(string name, float x)
	{
		sfShader_setFloatParameter(sfPtr, toStringz(name), x);
	}
	
	void setParameter(string name, float x, float y)
	{
		sfShader_setFloat2Parameter(sfPtr, toStringz(name), x, y);
	}
	
	void setParameter(string name, float x, float y, float z)
	{
		sfShader_setFloat3Parameter(sfPtr, toStringz(name), x,y,z);
	}
	
	void setParameter(string name, float x, float y, float z, float w)
	{
		sfShader_setFloat4Parameter(sfPtr, toStringz(name), x, y, z, w);
	}
	
	void setParameter(string name, Vector2f vector)
	{
		sfShader_setFloat2Parameter(sfPtr, toStringz(name), vector.x, vector.y);
	}
	
	void setParameter(string name, Vector3f vector)
	{
		sfShader_setFloat3Parameter(sfPtr, toStringz(name), vector.x, vector.y, vector.z);
	}

	void setParameter(string name, Color color)
	{
		sfShader_setColorParameter(sfPtr, toStringz(name), color.r, color.g, color.b, color.a);
	}
	
	void setParameter(string name, Transform transform)
	{
		sfShader_setTransformParameter(sfPtr, toStringz(name), transform.m_matrix.ptr);
	}
	
	void setParameter(string name, Texture texture)
	{
		sfShader_setTextureParameter(sfPtr, toStringz(name), texture.sfPtr);
		err.write(text(sfErrGraphics_getOutput()));
	}
	
	void setParameter(string name, CurrentTextureType)
	{
		sfShader_setCurrentTextureParameter(sfPtr, toStringz(name));
	}
	
	
	static void bind(Shader shader)
	{
		(shader is null)?sfShader_bind(null):sfShader_bind(shader.sfPtr);
	}
	
	static bool isAvailable()
	{
		bool toReturn = sfShader_isAvailable();
		err.write(text(sfErrGraphics_getOutput()));
		return toReturn;
	}
	
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

const(char)* sfErrGraphics_getOutput();