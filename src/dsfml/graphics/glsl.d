/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) 2013 - 2015 Jeremy DeHaan (dehaan.jeremiah@gmail.com)

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution
*/

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



alias Vec2 = Vector2!(float);
alias Ivec2 = Vector2!(int);
alias Bvec2 = Vector2!(bool);

alias Vec3 = Vector3!(float);
alias Ivec3 = Vector3!(int);
alias Bvec3 = Vector3!(bool);

alias Vec4 = Vector4!(float);
alias Ivec4 = Vector4!(int);
alias Bvec4 = Vector4!(bool);

alias Mat3 = Matrix!(3,3);
alias Mat4 = Matrix!(4,4);
