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
module dsfml.graphics.rendertexture;

import dsfml.graphics.rendertarget;
import dsfml.graphics.view;
import dsfml.graphics.rect;
import dsfml.graphics.drawable;
import dsfml.graphics.texture;
import dsfml.graphics.renderstates;
import dsfml.graphics.vertex;
import dsfml.graphics.primitivetype;

import dsfml.graphics.text;
import dsfml.graphics.shader;

import dsfml.graphics.color;

import dsfml.system.vector2;

debug import std.stdio;

import std.algorithm;

import dsfml.graphics.transform;

import dsfml.system.err;
import std.conv;

class RenderTexture:RenderTarget
{
	
	package sfRenderTexture* sfPtr;
	
	this(uint width, uint height, bool depthBuffer = false)
	{
		sfPtr = sfRenderTexture_create(width, height, depthBuffer);
		err.write(text(sfErrGraphics_getOutput()));

	}
	
	~this()
	{
		debug writeln("Destroying Render Texture");
		sfRenderTexture_destroy(sfPtr);
	}

	@property
	{
		void smooth(bool newSmooth)
		{
			sfRenderTexture_setSmooth(sfPtr, newSmooth);
		}
		bool smooth()
		{
			return (sfRenderTexture_isSmooth(sfPtr));//== sfTrue)? true:false;
		}
	}
	
	Vector2u getSize() const
	{
		Vector2u temp;
		sfRenderTexture_getSize(sfPtr, &temp.x, &temp.y);
		return temp;
	}
	
	void setActive(bool active = true)
	{
		sfRenderTexture_setActive(sfPtr, active);
	}
	
	@property
	{
		override void view(const(View) newView)
		{
			sfRenderTexture_setView(sfPtr, newView.sfPtr);
		}
		override View view() const
		{
			//try to fix
			return new View( sfRenderTexture_getView(sfPtr));
			
		}
	}
	
	const(View) getDefaultView() const
	{
		return new View( sfRenderTexture_getDefaultView(sfPtr));
	}
		
	Vector2f mapPixelToCoords(Vector2i point) const
	{
		Vector2f temp;
		sfRenderTexture_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y, null);
		return temp;
	}

	Vector2f mapPixelToCoords(Vector2i point, const(View) view) const
	{
		Vector2f temp;
		sfRenderTexture_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y, view.sfPtr);
		return temp;
	}

	Vector2i mapCoordsToPixel(Vector2f point) const
	{
		Vector2i temp;
		sfRenderTexture_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,null); 
		return temp;
	}

	Vector2i mapCoordsToPixel(Vector2f point, const(View) view) const
	{
		Vector2i temp;
		sfRenderTexture_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,view.sfPtr); 
		return temp;
	}
	
	IntRect getViewport(const(View) view) const
	{
		IntRect temp;

		sfRenderTexture_getViewport(sfPtr, view.sfPtr, &temp.left, &temp.top, &temp.width, &temp.height);
		
		return temp;
	}
	
	
	const(Texture) getTexture()
	{
		//Will be fixed in Revision 2
		return new Texture(sfRenderTexture_getTexture(sfPtr));
	}
	
	
	override void draw(Drawable drawable, RenderStates states = RenderStates.Default())
	{
		//Confirms that even a blank render states struct won't break anything during drawing
		if(states.texture is null)
		{
			states.texture = RenderStates.emptyTexture;
		}
		if(states.shader is null)
		{
			states.shader = RenderStates.emptyShader;
		}

		drawable.draw(this, states);
	}
	
	override void draw(const(Vertex)[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default())
	{
		//Confirms that even a blank render states struct won't break anything during drawing
		if(states.texture is null)
		{
			states.texture = RenderStates.emptyTexture;
		}
		if(states.shader is null)
		{
			states.shader = RenderStates.emptyShader;
		}

		sfRenderTexture_drawPrimitives(sfPtr, vertices.ptr, cast(uint)min(uint.max, vertices.length),type,states.blendMode, states.transform.m_matrix.ptr, states.texture.sfPtr, states.shader.sfPtr);
	}
	
	void display()
	{
		
		
		sfRenderTexture_display(sfPtr);
	}
	
	void clear(Color color = Color.Black)
	{
		sfRenderTexture_clear(sfPtr, color.r,color.g, color.b, color.a);
	}
	
	void pushGLStates()
	{
		sfRenderTexture_pushGLStates(sfPtr);
		err.write(text(sfErrGraphics_getOutput()));
	}

	void popGLStates()
	{
		sfRenderTexture_popGLStates(sfPtr);
	}

	void resetGLStates()
	{
		sfRenderTexture_resetGLStates(sfPtr);
	}
	
}


package extern(C) struct sfRenderTexture;

private extern(C):

//Construct a new render texture
sfRenderTexture* sfRenderTexture_create(uint width, uint height, bool depthBuffer);

//Destroy an existing render texture
void sfRenderTexture_destroy(sfRenderTexture* renderTexture);

//Get the size of the rendering region of a render texture
void sfRenderTexture_getSize(const sfRenderTexture* renderTexture, uint* x, uint* y);

//Activate or deactivate a render texture as the current target for rendering
bool sfRenderTexture_setActive(sfRenderTexture* renderTexture, bool active);

//Update the contents of the target texture
void sfRenderTexture_display(sfRenderTexture* renderTexture);

//Clear the rendertexture with the given color
void sfRenderTexture_clear(sfRenderTexture* renderTexture, ubyte r, ubyte g, ubyte b, ubyte a);

//Change the current active view of a render texture
void sfRenderTexture_setView(sfRenderTexture* renderTexture, const sfView* view);

//Get the current active view of a render texture
sfView* sfRenderTexture_getView(const sfRenderTexture* renderTexture);

//Get the default view of a render texture
sfView* sfRenderTexture_getDefaultView(const sfRenderTexture* renderTexture);

//Get the viewport of a view applied to this target
void sfRenderTexture_getViewport(const sfRenderTexture* renderTexture, const sfView* view, int* rectLeft, int* rectTop, int* rectWidth, int* rectHeight);

//Convert a point from texture coordinates to world coordinates
void sfRenderTexture_mapPixelToCoords(const sfRenderTexture* renderTexture, int xIn, int yIn, float* xOut, float* yOut, const sfView* targetView);

//Convert a point from world coordinates to texture coordinates
void sfRenderTexture_mapCoordsToPixel(const sfRenderTexture* renderTexture, float xIn, float yIn, int* xOut, int* yOut, const sfView* targetView);

//Draw a drawable object to the render-target
void sfRenderTexture_drawText(sfRenderTexture* renderTexture, const sfText* object, int blendMode,const float* transform, const sfTexture* texture, const sfShader* shader);


//Draw primitives defined by an array of vertices to a render texture
void sfRenderTexture_drawPrimitives(sfRenderTexture* renderTexture,  const void* vertices, uint vertexCount, int type, int blendMode,const float* transform, const sfTexture* texture, const sfShader* shader);

//Save the current OpenGL render states and matrices
void sfRenderTexture_pushGLStates(sfRenderTexture* renderTexture);

//Restore the previously saved OpenGL render states and matrices
void sfRenderTexture_popGLStates(sfRenderTexture* renderTexture);

//Reset the internal OpenGL states so that the target is ready for drawing
void sfRenderTexture_resetGLStates(sfRenderTexture* renderTexture);

//Get the target texture of a render texture
sfTexture* sfRenderTexture_getTexture(const sfRenderTexture* renderTexture);

//Enable or disable the smooth filter on a render texture
void sfRenderTexture_setSmooth(sfRenderTexture* renderTexture, bool smooth);

//Tell whether the smooth filter is enabled or not for a render texture
bool sfRenderTexture_isSmooth(const sfRenderTexture* renderTexture);


const(char)* sfErrGraphics_getOutput();
