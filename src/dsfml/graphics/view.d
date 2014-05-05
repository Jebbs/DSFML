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
module dsfml.graphics.view;

import dsfml.graphics.rect;
import dsfml.system.vector2;

/++
 + 2D camera that defines what region is shown on screen
 + 
 + View defines a camera in the 2D scene.
 + 
 + This is a very powerful concept: you can scroll, rotate or zoom the entire scene without altering the way that your drawable objects are drawn.
 + 
 + A view is composed of a source rectangle, which defines what part of the 2D scene is shown, and a target viewport, which defines where the contents of the source rectangle will be displayed on the render target (window or texture).
 + 
 + The viewport allows to map the scene to a custom part of the render target, and can be used for split-screen or for displaying a minimap, for example. If the source rectangle has not the same size as the viewport, its contents will be stretched to fit in.
 + 
 + To apply a view, you have to assign it to the render target. Then, every objects drawn in this render target will be affected by the view until you use another view.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1View.php#details
 +/
class View
{
	sfView* sfPtr;
	
	this()
	{
		// Constructor code
		sfPtr = sfView_create();
	}

	this(FloatRect rectangle)
	{
		
		sfPtr = sfView_createFromRect(rectangle.left,rectangle.top, rectangle.width, rectangle.height);
	}
	
	package this(sfView* sfview)
	{
		sfPtr = sfview;
	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
		sfView_destroy(sfPtr);
	}

	/// The center of the view.
	@property
	{
		Vector2f center(Vector2f newCenter)
		{
			sfView_setCenter(sfPtr, newCenter.x, newCenter.y);
			return newCenter;
		}
		
		Vector2f center() const
		{
			Vector2f temp;
			sfView_getCenter(sfPtr, &temp.x, &temp.y);
			return temp;
		}	
	}

	/// The orientation of the view, in degrees. The default rotation is 0 degrees.
	@property
	{
		float rotation(float newRotation)
		{
			sfView_setRotation(sfPtr, newRotation);
			return newRotation;
		}
		float rotation() const
		{
			return sfView_getRotation(sfPtr);
			
		}
	}

	/// The size of the view. The default size is (1, 1).
	@property
	{
		Vector2f size(Vector2f newSize)
		{
			sfView_setSize(sfPtr, newSize.x, newSize.y);
			return newSize;
		}
		
		Vector2f size() const
		{
			Vector2f temp;
			sfView_getSize(sfPtr, &temp.x, &temp.y);
			return temp;
		}
	}

	/**
	 * The target viewpoirt.
	 * 
	 * The viewport is the rectangle into which the contents of the view are displayed, expressed as a factor (between 0 and 1) of the size of the RenderTarget to which the view is applied. For example, a view which takes the left side of the target would be defined with View.setViewport(FloatRect(0, 0, 0.5, 1)). By default, a view has a viewport which covers the entire target.
	 */
	@property
	{
		FloatRect viewport(FloatRect newTarget)
		{
			sfView_setViewport(sfPtr, newTarget.left, newTarget.top, newTarget.width, newTarget.height);
			return newTarget;
		}
		FloatRect viewport() const
		{
			FloatRect temp;
			sfView_getViewport(sfPtr, &temp.left, &temp.top, &temp.width, &temp.height);
			return temp;
		}
	}

	/**
	 * Performs a deep copy of the view.
	 * 
	 * Returns: Duplicated view.
	 */
	@property
	View dup() const
	{
		return new View(sfView_copy(sfPtr));
	}

	/**
	 * Move the view relatively to its current position.
	 * 
	 * Params:
	 * 		offset	= Move offset
	 */
	void move(Vector2f offset)
	{
		sfView_move(sfPtr, offset.x, offset.y);
	}

	/**
	 * Reset the view to the given rectangle.
	 * 
	 * Note that this function resets the rotation angle to 0.
	 * 
	 * Params:
	 * 		rectangle	= Rectangle defining the zone to display.
	 */
	void reset(FloatRect rectangle)
	{
		sfView_reset(sfPtr, rectangle.left,rectangle.top, rectangle.width, rectangle.height);
	}

	/**
	 * Resize the view rectangle relatively to its current size.
	 * 
	 * Resizing the view simulates a zoom, as the zone displayed on screen grows or shrinks. factor is a multiplier:
	 * - 1 keeps the size unchanged.
	 * - > 1 makes the view bigger (objects appear smaller).
	 * - < 1 makes the view smaller (objects appear bigger).
	 * 
	 * Params:
	 * 		factor	= Zoom factor to apply.
	 */
	void zoom(float factor)
	{
		sfView_zoom(sfPtr, factor);
	}
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;

		import dsfml.graphics.rendertexture;

		writeln("Unit test for View");

		//the portion of the screen the view is displaying is at position (0,0) with a width of 100 and a height of 100
		auto view = new View(FloatRect(0,0,100,100));

		//the portion of the screen the view is displaying is at position (0,0) and takes up the remaining size of the screen.(expressed as a ratio)
		view.viewport = FloatRect(0,0,1,1);

		auto renderTexture = new RenderTexture();
		
		assert(renderTexture.create(1000,1000));

		renderTexture.clear();

		//set the view of the renderTexture
		renderTexture.view = view;

		//draw some things using this view

		//get it ready for rendering
		renderTexture.display();





		writeln();
	}
}


package extern(C) struct sfView;

private extern(C):

//Create a default view
sfView* sfView_create();

//Construct a view from a rectangle
sfView* sfView_createFromRect(float left, float top, float width, float height);


//Copy an existing view
sfView* sfView_copy(const sfView* view);


//Destroy an existing view
void sfView_destroy(sfView* view);


//Set the center of a view
void sfView_setCenter(sfView* view, float centerX, float centerY);


//Set the size of a view
void sfView_setSize(sfView* view, float sizeX, float sizeY);


//Set the orientation of a view
void sfView_setRotation(sfView* view, float angle);


//Set the target viewport of a view
void sfView_setViewport(sfView* view, float left, float top, float width, float height);


//Reset a view to the given rectangle
void sfView_reset(sfView* view, float left, float top, float width, float height);


//Get the center of a view
void sfView_getCenter(const sfView* view, float* x, float* y);


//Get the size of a view
void sfView_getSize(const sfView* view, float* x, float* y);


//Get the current orientation of a view
float sfView_getRotation(const sfView* view);


//Get the target viewport rectangle of a view
void sfView_getViewport(const sfView* view, float* left, float* top, float* width, float* height);

//Move a view relatively to its current position
void sfView_move(sfView* view, float offsetX, float offsetY);


//Rotate a view relatively to its current orientation
void sfView_rotate(sfView* view, float angle);


//Resize a view rectangle relatively to its current size
void sfView_zoom(sfView* view, float factor);
