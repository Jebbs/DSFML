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

/**
 * A $(U Transform) specifies how to translate, rotate, scale, shear, project,
 * whatever things. In mathematical terms, it defines how to transform a
 * coordinate system into another.
 *
 * For example, if you apply a rotation transform to a sprite, the result will
 * be a rotated sprite. And anything that is transformed by this rotation
 * transform will be rotated the same way, according to its initial position.
 *
 * Transforms are typically used for drawing. But they can also be used for any
 * computation that requires to transform points between the local and global
 * coordinate systems of an entity (like collision detection).
 *
 * Example:
 * ---
 * // define a translation transform
 * Transform translation;
 * translation.translate(20, 50);
 *
 * // define a rotation transform
 * Transform rotation;
 * rotation.rotate(45);
 *
 * // combine them
 * Transform transform = translation * rotation;
 *
 * // use the result to transform stuff...
 * Vector2f point = transform.transformPoint(Vector2f(10, 20));
 * FloatRect rect = transform.transformRect(FloatRect(0, 0, 10, 100));
 * ---
 *
 * See_Also:
 * $(TRANSFORMABLE_LINK), $(RENDERSTATES_LINK)
 */
module dsfml.graphics.transform;

import dsfml.system.vector2;
import dsfml.graphics.rect;
public import std.math;


/**
 * Define a 3x3 transform matrix.
 */
struct Transform
{
	/// 4x4 matrix defining the transformation.
	package float[16] m_matrix = [1.0f, 0.0f, 0.0f, 0.0f,
						  		  0.0f, 1.0f, 0.0f, 0.0f,
						  		  0.0f, 0.0f, 1.0f, 0.0f,
						  		  0.0f, 0.0f, 0.0f, 1.0f];

	/**
	 * Construct a transform from a 3x3 matrix.
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
		m_matrix = [ a00,  a10, 0.0f,  a20,
    			     a01,  a11, 0.0f,  a21,
    				0.0f, 0.0f, 1.0f, 0.0f,
    				 a02,  a12, 0.0f,  a22];
	}

	/// Construct a transform from a float array describing a 3x3 matrix.
	this(float[9] matrix)
	{
		m_matrix = [matrix[0], matrix[3], 0.0f, matrix[6],
    			    matrix[1], matrix[4], 0.0f, matrix[7],
    				     0.0f,      0.0f, 1.0f,      0.0f,
    				matrix[2], matrix[5], 0.0f, matrix[8]];
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
		Transform temp;
		sfTransform_getInverse(m_matrix.ptr,temp.m_matrix.ptr);
		return temp;
	}

	/**
	 * Return the transform as a 4x4 matrix.
	 *
	 * This function returns a pointer to an array of 16 floats containing the
	 * transform elements as a 4x4 matrix, which is directly compatible with
	 * OpenGL functions.
	 *
	 * Returns: A 4x4 matrix.
	 */
	const(float)[] getMatrix() const
	{
		return m_matrix;
	}

	/**
	 * Combine the current transform with another one.
	 *
	 * The result is a transform that is equivalent to applying this followed by
	 * transform. Mathematically, it is equivalent to a matrix multiplication.
	 *
	 * Params:
	 * 		transform	= Transform to combine with this one
	 *
	 * Returns: Reference to this.
	 */
	ref Transform combine(Transform otherTransform)
	{
		sfTransform_combine(m_matrix.ptr, otherTransform.m_matrix.ptr);
		return this;
	}

	/**
	 * Transform a 2D point.
	 *
	 * Params:
	 * 		x	= X coordinate of the point to transform
	 * 		y	= Y coordinate of the point to transform
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
	 * Since SFML doesn't provide support for oriented rectangles, the result of
	 * this function is always an axis-aligned rectangle. Which means that if
	 * the transform contains a rotation, the bounding rectangle of the
	 * transformed rectangle is returned.
	 *
	 * Params:
	 * 		rect	= Rectangle to transform
	 *
	 * Returns: Transformed rectangle.
	 */
	FloatRect transformRect(const(FloatRect) rect)const
	{
		FloatRect temp;
		sfTransform_transformRect(m_matrix.ptr,rect.left, rect.top, rect.width, rect.height, &temp.left, &temp.top, &temp.width, &temp.height);
		return temp;
	}

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
	ref Transform translate(float x, float y)
	{
		sfTransform_translate(m_matrix.ptr, x, y);
		return this;
	}

	/**
	 * Combine the current transform with a rotation.
	 *
	 * This function returns a reference to this, so that calls can be chained.
	 *
	 * Params:
	 * 		angle	= Rotation angle, in degrees
	 *
	 * Returns: this
	 */
	ref Transform rotate(float angle)
	{
		sfTransform_rotate(m_matrix.ptr, angle);
		return this;
	}

	/**
	 * Combine the current transform with a rotation.
	 *
	 * The center of rotation is provided for convenience as a second argument,
	 * so that you can build rotations around arbitrary points more easily (and
	 * efficiently) than the usual
	 * translate(-center).rotate(angle).translate(center).
	 *
	 * This function returns a reference to this, so that calls can be chained.
	 *
	 * Params:
	 * 		angle	= Rotation angle, in degrees
	 * 		center	= Center of rotation
	 *
	 * Returns: this
	 */
	ref Transform rotate(float angle, float centerX, float centerY)
	{
		sfTransform_rotateWithCenter(m_matrix.ptr, angle, centerX, centerY);
		return this;
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
	ref Transform scale(float scaleX, float scaleY)
	{
		sfTransform_scale(m_matrix.ptr, scaleX, scaleY);
		return this;
	}

	/**
	 * Combine the current transform with a scaling.
	 *
	 * The center of scaling is provided for convenience as a second argument,
	 * so that you can build scaling around arbitrary points more easily
	 * (and efficiently) than the usual
	 * translate(-center).scale(factors).translate(center).
	 *
	 * This function returns a reference to this, so that calls can be chained.
	 *
	 * Params:
	 * 		scaleX	= Scaling factor on the X-axis
	 * 		scaleY	= Scaling factor on the Y-axis
	 * 		centerX	= X coordinate of the center of scaling
	 * 		centerY	= Y coordinate of the center of scaling
	 *
	 * Returns: this
	 */
	ref Transform scale(float scaleX, float scaleY, float centerX, float centerY)
	{
		sfTransform_scaleWithCenter(m_matrix.ptr, scaleX, scaleY, centerX, centerY);
		return this;
	}

	string toString() const
	{
		return "";//text(InternalsfTransform.matrix);
	}

	/**
	 * Overload of binary operator `*` to combine two transforms.
	 *
	 * This call is equivalent to:
	 * ---
	 * Transform combined = transform;
	 * combined.combine(rhs);
	 * ---
	 *
	 * Params:
	 * rhs = the second transform to be combined with the first
	 *
	 * Returns: New combined transform.
	 */
	Transform opBinary(string op)(Transform rhs)
		if(op == "*")
	{
		Transform temp = this;
		return temp.combine(rhs);
	}

	/**
	 * Overload of assignment operator `*=` to combine two transforms.
	 *
	 * This call is equivalent to calling `transform.combine(rhs)`.
	 *
	 * Params:
	 * rhs = the second transform to be combined with the first
	 *
	 * Returns: The combined transform.
	 */
	ref Transform opOpAssign(string op)(Transform rhs)
		if(op == "*")
	{
		return this.combine(rhs);
	}

	/**
	* Overload of binary operator * to transform a point
	*
	* This call is equivalent to calling `transform.transformPoint(vector)`.
	*
	* Params:
	* vector = the point to transform
	*
	* Returns: New transformed point.
	*/
	Vextor2f opBinary(string op)(Vector2f vector)
		if(op == "*")
	{
		return transformPoint(vector);
	}

	/// Indentity transform (does nothing).
	static const(Transform) Identity;
}

unittest
{
	version(DSFML_Unittest_Graphics)
	{
		import std.stdio;
		import std.math;

		bool compareTransform(Transform a, Transform b)
		{
			/*
			 * There's a slight difference in precision between D's and C++'s
			 * sine and cosine functions, so we'll use approxEqual here.
			 */
			return approxEqual(a.getMatrix(), b.getMatrix());
		}

		writeln("Unit Test for Transform");

		assert(compareTransform(Transform.Identity.getInverse(), Transform.Identity));

		Transform scaledTransform;
		scaledTransform.scale(2, 3);

		Transform comparisonTransform;
		comparisonTransform.m_matrix =  [2.0f, 0.0f, 0.0f, 0.0f,
						  		  	  	 0.0f, 3.0f, 0.0f, 0.0f,
						  		  	  	 0.0f, 0.0f, 1.0f, 0.0f,
						  		  	  	 0.0f, 0.0f, 0.0f, 1.0f];

		assert(compareTransform(scaledTransform, comparisonTransform));

		Transform rotatedTransform;
		rotatedTransform.rotate(20);

		float rad = 20 * 3.141592654f / 180.0f;
    	float cos = cos(rad);
    	float sin = sin(rad);

		// combine identity with rotational matrix (what rotate() should do)
    	comparisonTransform = Transform().combine(Transform(cos, -sin, 0,
                       					   					sin,  cos, 0,
                       					   					0,    0,   1));

		assert(compareTransform(rotatedTransform, comparisonTransform));

		writeln();
	}
}

private extern(C):

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
