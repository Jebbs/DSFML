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
	
	
	View dup() const
	{
		return new View(sfView_copy(sfPtr));
	}
	
	
	@property
	{
		void center(Vector2f newCenter)
		{
			sfView_setCenter(sfPtr, newCenter.x, newCenter.y);
		}
		
		Vector2f center()
		{
			Vector2f temp;
			sfView_getCenter(sfPtr, &temp.x, &temp.y);
			return temp;
			//return Vector2f();
		}	
	}
	
	@property
	{
		void size(Vector2f newSize)
		{
			sfView_setSize(sfPtr, newSize.x, newSize.y);
		}
		
		Vector2f size()
		{
			Vector2f temp;
			sfView_getSize(sfPtr, &temp.x, &temp.y);
			return temp;
			//return Vector2f(sfView_getSize(sfPtr));
		}
	}
	
	@property
	{
		void rotation(float newRotation)
		{
			sfView_setRotation(sfPtr, newRotation);
		}
		float rotation()
		{
			return sfView_getRotation(sfPtr);
			
		}
	}
	
	@property
	{
		void viewport(FloatRect newTarget)
		{
			sfView_setViewport(sfPtr, newTarget.left, newTarget.top, newTarget.width, newTarget.height);
		}
		FloatRect viewport()
		{
			FloatRect temp;
			sfView_getViewport(sfPtr, &temp.left, &temp.top, &temp.width, &temp.height);
			return temp;
			//return FloatRect(sfView_getViewport(sfPtr));
		}
	}
	
	void reset(FloatRect rectangle)
	{
		sfView_reset(sfPtr, rectangle.left,rectangle.top, rectangle.width, rectangle.height);
	}
	
	
	void zoom(float factor)
	{
		sfView_zoom(sfPtr, factor);
	}
	
	void move(Vector2f offset)
	{
		sfView_move(sfPtr, offset.x, offset.y);
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