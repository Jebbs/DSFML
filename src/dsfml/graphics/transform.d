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
module dsfml.graphics.transform;

import dsfml.system.vector2;
import dsfml.graphics.rect;
public import std.math;


/++
 + Define a 3x3 transform matrix.
 + 
 + A Transform specifies how to translate, rotate, scale, shear, project, whatever things.
 + 
 + In mathematical terms, it defines how to transform a coordinate system into another.
 + 
 + For example, if you apply a rotation transform to a sprite, the result will be a rotated sprite. And anything that is transformed by this rotation transform will be rotated the same way, according to its initial position.
 + 
 + Transforms are typically used for drawing. But they can also be used for any computation that requires to transform points between the local and global coordinate systems of an entity (like collision detection).
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Transform.php#details
 +/
struct Transform
{
	float[9] m_matrix = [1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f];

	/**
	 * Construct a 3x3 matrix.
	 * 
	 * Params:
	 * 		a00	= Element (0, 0) of the matrix
	 * 		a01	= Element (0, 1) of the matrix
	 * 		a02	= Element (0, 2) of the matrix
	 * 		a10	= Element (1, 0) of the matrix
	 * 		a11	= Element (1, 1) of the matrix
	 * 		a12	= Element (1, 2) of the matrix
	 * 		a20	= Element (2, 0) of the matrix
	 * 		a21	= Element (2, 1) of the matrix
	 * 		a22	= Element (2, 2) of the matrix
	 */
	this(float a00, float a01, float a02, float a10, float a11, float a12, float a20, float a21, float a22)
	{
		m_matrix = [a00, a01, a02, a10, a11, a12, a20, a21, a22];
	}
	
	this(float[9] newMatrix)
	{
		m_matrix = newMatrix.dup;
	}

	/**
	 * Return the inverse of the transform.
	 * 
	 * If the inverse cannot be computed, an identity transform is returned.
	 * 
	 * Returns: A new transform which is the inverse of self.
	 */
	Transform getInverse() const
	{
		float[9] temp;
		sfTransform_getInverse(m_matrix.ptr,temp.ptr);
		return Transform(temp);
	}

	/**
	 * Return the transform as a 4x4 matrix.
	 * 
	 * This function returns a pointer to an array of 16 floats containing the transform elements as a 4x4 matrix, which is directly compatible with OpenGL functions.
	 * 
	 * Returns: A 4x4 matrix.
	 */
	const(float)[] getMatrix()
	{
		static float[16] temp;
		
		sfTransform_getMatrix(m_matrix.ptr, temp.ptr);
		
		return temp.dup;
	}

	/**
	 * Combine the current transform with another one.
	 * 
	 * The result is a transform that is equivalent to applying this followed by transform. Mathematically, it is equivalent to a matrix multiplication.
	 * 
	 * Params:
	 * 		transform	= Transform to combine with this one.
	 * 
	 * Returns: Reference to this.
	 */
	void combine(Transform otherTransform)
	{
		sfTransform_combine(m_matrix.ptr, otherTransform.m_matrix.ptr);
	}

	/**
	 * Transform a 2D point.
	 * 
	 * Params:
	 * 		x	= X coordinate of the point to transform.
	 * 		y	= Y coordinate of the point to transform.
	 * 
	 * Returns: Transformed point.
	 */
	Vector2f transformPoint(Vector2f point) const
	{
		Vector2f temp;
		sfTransform_transformPoint(m_matrix.ptr,point.x, point.y, &temp.x, &temp.y);
		return temp;	
	}

	/**
	 * Transform a rectangle.
	 * 
	 * Since SFML doesn't provide support for oriented rectangles, the result of this function is always an axis-aligned rectangle. Which means that if the transform contains a rotation, the bounding rectangle of the transformed rectangle is returned.
	 * 
	 * Params:
	 * 		rectangle	= Rectangle to transform.
	 * 
	 * Returns: Transformed rectangle.
	 */
	FloatRect transformRect(const(FloatRect) rect)const
	{
		FloatRect temp;
		sfTransform_transformRect(m_matrix.ptr,rect.left, rect.top, rect.width, rect.height, &temp.left, &temp.top, &temp.width, &temp.height);
		return temp;
	}

	//TODO: These functions should probably return this; like the documentation states.
	/**
	 * Combine the current transform with a translation.
	 * 
	 * This function returns a reference to this, so that calls can be chained.
	 * 
	 * Params:
	 * 		offset	= Translation offset to apply.
	 * 
	 * Returns: this
	 */
	void translate(float x, float y)
	{
		sfTransform_translate(m_matrix.ptr, x, y);
	}

	/**
	 * Combine the current transform with a rotation.
	 * 
	 * This function returns a reference to this, so that calls can be chained.
	 * 
	 * Params:
	 * 		angle	= Rotation angle, in degrees.
	 * 
	 * Returns: this
	 */
	void rotate(float angle)
	{
		sfTransform_rotate(m_matrix.ptr, angle);
	}

	/**
	 * Combine the current transform with a rotation.
	 * 
	 * The center of rotation is provided for convenience as a second argument, so that you can build rotations around arbitrary points more easily (and efficiently) than the usual translate(-center).rotate(angle).translate(center).
	 * 
	 * This function returns a reference to this, so that calls can be chained.
	 * 
	 * Params:
	 * 		angle	= Rotation angle, in degrees.
	 * 		center	= Center of rotation
	 * 
	 * Returns: this
	 */
	void rotate(float angle, float centerX, float centerY)
	{
		sfTransform_rotateWithCenter(m_matrix.ptr, angle, centerX, centerY);
	}

	/**
	 * Combine the current transform with a scaling.
	 * 
	 * This function returns a reference to this, so that calls can be chained.
	 * 
	 * Params:
	 * 		scaleX	= Scaling factor on the X-axis.
	 * 		scaleY	= Scaling factor on the Y-axis.
	 * 
	 * Returns: this
	 */
	void scale(float scaleX, float scaleY)
	{
		sfTransform_scale(m_matrix.ptr, scaleX, scaleY);	
	}

	/**
	 * Combine the current transform with a scaling.
	 * 
	 * The center of scaling is provided for convenience as a second argument, so that you can build scaling around arbitrary points more easily (and efficiently) than the usual translate(-center).scale(factors).translate(center).
	 * 
	 * This function returns a reference to this, so that calls can be chained.
	 * 
	 * Params:
	 * 		scaleX	= Scaling factor on the X-axis.
	 * 		scaleY	= Scaling factor on the Y-axis.
	 * 		centerX	= X coordinate of the center of scaling
	 * 		centerY	= Y coordinate of the center of scaling
	 * 
	 * Returns: this
	 */
	void scale(float scaleX, float scaleY, float centerX, float centerY)
	{
		sfTransform_scaleWithCenter(m_matrix.ptr, scaleX, scaleY, centerX, centerY);
	}

	string toString()
	{
		return "";//text(InternalsfTransform.matrix);
	}

	Transform opBinary(string op)(Transform rhs)
		if(op == "*")
	{
		Transform temp = this;//Transform(InternalsfTransform);
		temp.combine(rhs);
		return temp;
	}
	
	ref Transform opOpAssign(string op)(Transform rhs)
		if(op == "*")
	{
		
		this.combine(rhs);
		return this;
	}
	
	Transform opBinary(string op)(Vector2f vector)
		if(op == "*")
	{
		return transformPoint(vector);
	}

	/// Indentity transform (does nothing).
	static const(Transform) Identity;
}

private extern(C):

//Return the 4x4 matrix of a transform
void sfTransform_getMatrix(const float* transform, float* matrix);

//Return the inverse of a transform
void sfTransform_getInverse(const float* transform, float* inverse);

//Apply a transform to a 2D point
void sfTransform_transformPoint(const float* transform, float xIn, float yIn, float* xOut, float* yOut);

//Apply a transform to a rectangle
void sfTransform_transformRect(const float* transform, float leftIn, float topIn, float widthIn, float heightIn, float* leftOut, float* topOut, float* widthOut, float* heightOut);

//Combine two transforms
void sfTransform_combine(float* transform, const float* other);

//Combine a transform with a translation
void sfTransform_translate(float* transform, float x, float y);

//Combine the current transform with a rotation
void sfTransform_rotate(float* transform, float angle);

//Combine the current transform with a rotation
void sfTransform_rotateWithCenter(float* transform, float angle, float centerX, float centerY);

//Combine the current transform with a scaling
void sfTransform_scale(float* transform, float scaleX, float scaleY);

//Combine the current transform with a scaling
void sfTransform_scaleWithCenter(float* transform, float scaleX, float scaleY, float centerX, float centerY);


