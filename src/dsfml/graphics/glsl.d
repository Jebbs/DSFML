/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2017 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
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
 */

/// A module containing GLSL data structures.
module dsfml.graphics.glsl;

import dsfml.graphics.color;
import dsfml.graphics.transform;

import dsfml.system.vector2;
import dsfml.system.vector3;

import std.traits;


struct Vector4(T)
    if(isNumeric!(T) || is(T == bool))
{
    T x, y, z, w;

    this(Color source)
    {
        static if(is(T == float))
        {
            x = source.r / 255f;
            y = source.g / 255f;
            z = source.b / 255f;
            w = source.a / 255f;
        }
        else static if(is(T == int))
        {
            x = cast(T)source.r;
            y = cast(T)source.g;
            z = cast(T)source.b;
            w = cast(T)source.a;
        }
    }

}

struct Matrix(uint C, uint R)
{
    float[C * R] array;

    this(ref const(Transform) source)
    {
        const(float)[] from = source.getMatrix();

        static if(C==R && C == 3)
        {
            float[] to = array;                 // 3x3
        // Use only left-upper 3x3 block (for a 2D transform)
        to[0] = from[ 0]; to[1] = from[ 1]; to[2] = from[ 3];
        to[3] = from[ 4]; to[4] = from[ 5]; to[5] = from[ 7];
        to[6] = from[12]; to[7] = from[13]; to[8] = from[15];
        }
        else static if(C==R && C == 4)
        {
            array[] = from[];
        }
    }

    this(const(float)[] source)
    {
        assert(array.length >= source.length);

        array[0..$] = source[0 .. $];
    }
}


/// 2D float vector (vec2 in GLSL)
alias Vec2 = Vector2!(float);
/// 2D int vector (ivec2 in GLSL)
alias Ivec2 = Vector2!(int);
/// 2D bool vector (bvec2 in GLSL)
alias Bvec2 = Vector2!(bool);
/// 3D float vector (vec3 in GLSL)
alias Vec3 = Vector3!(float);
/// 3D int vector (ivec3 in GLSL)
alias Ivec3 = Vector3!(int);
/// 3D bool vector (bvec3 in GLSL)
alias Bvec3 = Vector3!(bool);


/**
 * 4D float vector (vec4 in GLSL)
 *
 * 4D float vectors can be converted from sf::Color instances. Each color
 * channel is normalized from integers in [0, 255] to floating point values
 * in [0, 1].
 */
alias Vec4 = Vector4!(float);
/**
 * 4D int vector ( ivec4 in GLSL)
 *
 * 4D int vectors can be converted from sf::Color instances. Each color channel
 * remains unchanged inside the integer interval [0, 255].
 */
alias Ivec4 = Vector4!(int);
/// 4D bool vector (bvec4 in GLSL)
alias Bvec4 = Vector4!(bool);

/**
 * 3x3 float matrix (mat3 in GLSL)
 *
 * The matrix can be constructed from an array with 3x3 elements, aligned in
 * column-major order.
 *
 * Mat3 can also be converted from a Transform.
 */
alias Mat3 = Matrix!(3,3);

/**
 * 4x4 float matrix (mat4 in GLSL)
 *
 * The matrix can be constructed from an array with 4x4 elements, aligned in
 * column-major order.
 *
 * Mat4 can also be converted from a Transform.
 */
alias Mat4 = Matrix!(4,4);
