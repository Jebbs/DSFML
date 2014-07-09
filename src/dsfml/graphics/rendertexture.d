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


import dsfml.system.err;

/++
 + Target for off-screen 2D rendering into a texture.
 + 
 + RenderTexture is the little brother of RenderWindow.
 + 
 + It implements the same 2D drawing and OpenGL-related functions (see their base class RenderTarget for more details), the difference is that the result is stored in an off-screen texture rather than being show in a window.
 + 
 + Rendering to a texture can be useful in a variety of situations:
 + - precomputing a complex static texture (like a level's background from multiple tiles)
 + - applying post-effects to the whole scene with shaders
 + - creating a sprite from a 3D object rendered with OpenGL
 + - etc.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1RenderTexture.php#details
 +/
class RenderTexture : RenderTarget
{
	package sfRenderTexture* sfPtr;
	private Texture m_texture;

	this()
	{
	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfRenderTexture_destroy(sfPtr);
	}

	/**
	 * Create the render-texture.
	 * 
	 * Before calling this function, the render-texture is in an invalid state, thus it is mandatory to call it before doing anything with the render-texture. 
	 * 
	 * The last parameter, depthBuffer, is useful if you want to use the render-texture for 3D OpenGL rendering that requires a depth-buffer. Otherwise it is unnecessary, and you should leave this parameter to false (which is its default value).
	 * 
	 * Params:
	 * 		width		= Width of the render-texture
	 * 		height		= Height of the render-texture
	 * 		depthBuffer	= Do you want this render-texture to have a depth buffer?
	 * 
	 * Returns: True if creation was successful
	 */
	bool create(uint width, uint height, bool depthBuffer = false)
	{
		import std.conv;

		//if the RenderTexture already exists, destroy it first
		if(sfPtr != null)
		{
			sfRenderTexture_destroy(sfPtr);
		}

		sfPtr = sfRenderTexture_create(width, height, depthBuffer);
		err.write(text(sfErr_getOutput()));

		if(sfPtr != null)
		{
			m_texture = new Texture(sfRenderTexture_getTexture(sfPtr));
			return true;
		}
		else
		{
			m_texture = new Texture();
			return false;
		}
	}
	
	/**
	 * Enable or disable texture smoothing.
	 */
	@property
	{
		bool smooth(bool newSmooth)
		{
			sfRenderTexture_setSmooth(sfPtr, newSmooth);
			return newSmooth;
		}
		bool smooth()
		{
			return (sfRenderTexture_isSmooth(sfPtr));//== sfTrue)? true:false;
		}
	}

	/**
	 * Change the current active view.
	 * 
	 * The view is like a 2D camera, it controls which part of the 2D scene is visible, and how it is viewed in the render-target. The new view will affect everything that is drawn, until another view is set. 
	 * 
	 * The render target keeps its own copy of the view object, so it is not necessary to keep the original one alive after calling this function. To restore the original view of the target, you can pass the result of getDefaultView() to this function.
	 */
	@property
	{
		override const(View) view(const(View) newView)
		{
			sfRenderTexture_setView(sfPtr, newView.sfPtr);
			return newView;
		}
		override const(View) view() const
		{
			//try to fix. Maybe cache?
			return new View( sfRenderTexture_getView(sfPtr));
		}
	}

	/**
	 * Get the default view of the render target.
	 * 
	 * The default view has the initial size of the render target, and never changes after the target has been created.
	 * 
	 * Returns: The default view of the render target.
	 */
	View getDefaultView() const // note: if refactored, change documentation of view property above
	{
		return new View(sfRenderTexture_getDefaultView(sfPtr));
	}

	/**
	 * Return the size of the rendering region of the target.
	 * 
	 * Returns: Size in pixels
	 */
	Vector2u getSize() const
	{
		Vector2u temp;
		sfRenderTexture_getSize(sfPtr, &temp.x, &temp.y);
		return temp;
	}

	/**
	 * Get the viewport of a view, applied to this render target.
	 * 
	 * The viewport is defined in the view as a ratio, this function simply applies this ratio to the current dimensions of the render target to calculate the pixels rectangle that the viewport actually covers in the target.
	 * 
	 * Params:
	 * 		view	= The view for which we want to compute the viewport
	 * 
	 * Returns: Viewport rectangle, expressed in pixels
	 */
	IntRect getViewport(const(View) view) const
	{
		IntRect temp;
		sfRenderTexture_getViewport(sfPtr, view.sfPtr, &temp.left, &temp.top, &temp.width, &temp.height);
		return temp;
	}

	/**
	 * Get a read-only reference to the target texture.
	 * 
	 * After drawing to the render-texture and calling Display, you can retrieve the updated texture using this function, and draw it using a sprite (for example).
	 * 
	 * The internal Texture of a render-texture is always the same instance, so that it is possible to call this function once and keep a reference to the texture even after it is modified.
	 * 
	 * Returns: Const reference to the texture.
	 */
	const(Texture) getTexture()
	{
		return m_texture;
	}

	/**
	 * Activate or deactivate the render-texture for rendering.
	 * 
	 * This function makes the render-texture's context current for future OpenGL rendering operations (so you shouldn't care about it if you're not doing direct OpenGL stuff).
	 * 
	 * Only one context can be current in a thread, so if you want to draw OpenGL geometry to another render target (like a RenderWindow) don't forget to activate it again.
	 * 
	 * Params:
	 * 		active	= True to activate, false to deactivate
	 */
	void setActive(bool active = true)
	{
		sfRenderTexture_setActive(sfPtr, active);
	}

	/**
	 * Clear the entire target with a single color.
	 * 
	 * This function is usually called once every frame, to clear the previous contents of the target.
	 * 
	 * Params:
	 * 		color	= Fill color to use to clear the render target
	 */
	void clear(Color color = Color.Black)
	{
		sfRenderTexture_clear(sfPtr, color.r,color.g, color.b, color.a);
	}

	/**
	 * Update the contents of the target texture.
	 * 
	 * This function updates the target texture with what has been drawn so far. Like for windows, calling this function is mandatory at the end of rendering. Not calling it may leave the texture in an undefined state.
	 */
	void display()
	{
		sfRenderTexture_display(sfPtr);
	}

	/**
	 * Draw a drawable object to the render target.
	 * 
	 * Params:
	 * 		drawable	= Object to draw
	 * 		states		= Render states to use for drawing
	 */
	override void draw(Drawable drawable, RenderStates states = RenderStates.Default)
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

	/**
	 * Draw primitives defined by an array of vertices.
	 * 
	 * Params:
	 * 		vertices	= Array of vertices to draw
	 * 		type		= Type of primitives to draw
	 * 		states		= Render states to use for drawing
	 */
	override void draw(const(Vertex)[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default)
	{
		import std.algorithm;
		
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

	/**
	 * Convert a point fom target coordinates to world coordinates, using the current view.
	 * 
	 * This function is an overload of the mapPixelToCoords function that implicitely uses the current view.
	 * 
	 * Params:
	 * 		point	= Pixel to convert
	 * 
	 * Returns: The converted point, in "world" coordinates.
	 */
	Vector2f mapPixelToCoords(Vector2i point) const
	{
		Vector2f temp;
		sfRenderTexture_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y, null);
		return temp;
	}

	/**
	 * Convert a point from target coordinates to world coordinates.
	 * 
	 * This function finds the 2D position that matches the given pixel of the render-target. In other words, it does the inverse of what the graphics card does, to find the initial position of a rendered pixel.
	 * 
	 * Initially, both coordinate systems (world units and target pixels) match perfectly. But if you define a custom view or resize your render-target, this assertion is not true anymore, ie. a point located at (10, 50) in your render-target may map to the point (150, 75) in your 2D world – if the view is translated by (140, 25).
	 * 
	 * For render-windows, this function is typically used to find which point (or object) is located below the mouse cursor.
	 * 
	 * This version uses a custom view for calculations, see the other overload of the function if you want to use the current view of the render-target.
	 * 
	 * Params:
	 * 		point	= Pixel to convert
	 * 		view	= The view to use for converting the point
	 * 
	 * Returns: The converted point, in "world" coordinates.
	 */
	Vector2f mapPixelToCoords(Vector2i point, const(View) view) const
	{
		Vector2f temp;
		sfRenderTexture_mapPixelToCoords(sfPtr,point.x, point.y, &temp.x, &temp.y, view.sfPtr);
		return temp;
	}

	/**
	 * Convert a point from target coordinates to world coordinates, using the current view.
	 * 
	 * This function is an overload of the mapPixelToCoords function that implicitely uses the current view.
	 * 
	 * Params:
	 * 		point	= Point to convert
	 * 
	 * The converted point, in "world" coordinates
	 */
	Vector2i mapCoordsToPixel(Vector2f point) const
	{
		Vector2i temp;
		sfRenderTexture_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,null); 
		return temp;
	}

	/**
	 * Convert a point from world coordinates to target coordinates.
	 * 
	 * This function finds the pixel of the render-target that matches the given 2D point. In other words, it goes through the same process as the graphics card, to compute the final position of a rendered point.
	 * 
	 * Initially, both coordinate systems (world units and target pixels) match perfectly. But if you define a custom view or resize your render-target, this assertion is not true anymore, ie. a point located at (150, 75) in your 2D world may map to the pixel (10, 50) of your render-target – if the view is translated by (140, 25).
	 * 
	 * This version uses a custom view for calculations, see the other overload of the function if you want to use the current view of the render-target.
	 * 
	 * Params:
	 * 		point	= Point to convert
	 * 		view	= The view to use for converting the point
	 * 
	 * Returns: The converted point, in target coordinates (pixels)
	 */
	Vector2i mapCoordsToPixel(Vector2f point, const(View) view) const
	{
		Vector2i temp;
		sfRenderTexture_mapCoordsToPixel(sfPtr,point.x, point.y, &temp.x, &temp.y,view.sfPtr); 
		return temp;
	}

	/**
	 * Restore the previously saved OpenGL render states and matrices.
	 * 
	 * See the description of pushGLStates to get a detailed description of these functions.
	 */
	void popGLStates()
	{
		sfRenderTexture_popGLStates(sfPtr);
	}

	/**
	 * Save the current OpenGL render states and matrices.
	 * 
	 * This function can be used when you mix SFML drawing and direct OpenGL rendering. Combined with PopGLStates, it ensures that:
	 * - SFML's internal states are not messed up by your OpenGL code
	 * - your OpenGL states are not modified by a call to an SFML function
	 * 
	 * More specifically, it must be used around the code that calls Draw functions.
	 * 
	 * Note that this function is quite expensive: it saves all the possible OpenGL states and matrices, even the ones you don't care about. Therefore it should be used wisely. It is provided for convenience, but the best results will be achieved if you handle OpenGL states yourself (because you know which states have really changed, and need to be saved and restored). Take a look at the ResetGLStates function if you do so.
	 */
	void pushGLStates()
	{
		import std.conv;
		sfRenderTexture_pushGLStates(sfPtr);
		err.write(text(sfErr_getOutput()));
	}

	/**
	 * Reset the internal OpenGL states so that the target is ready for drawing.
	 * 
	 * This function can be used when you mix SFML drawing and direct OpenGL rendering, if you choose not to use pushGLStates/popGLStates. It makes sure that all OpenGL states needed by SFML are set, so that subsequent draw() calls will work as expected.
	 */
	void resetGLStates()
	{
		sfRenderTexture_resetGLStates(sfPtr);
	}
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;
		import dsfml.graphics.sprite;

		writeln("Unit tests for RenderTexture");

		auto renderTexture = new RenderTexture();

		assert(renderTexture.create(100,100));

		Sprite testSprite = new Sprite();//doesn't need a texture for this unit test

		//clear before doing anything
		renderTexture.clear();

		renderTexture.draw(testSprite);

		//prepare the RenderTexture for usage after drawing
		renderTexture.display();

		writeln();

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
//void sfRenderTexture_drawText(sfRenderTexture* renderTexture, const sfText* object, int blendMode,const float* transform, const sfTexture* texture, const sfShader* shader);


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


const(char)* sfErr_getOutput();
