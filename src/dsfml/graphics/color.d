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
 * $(U Color) is a simple color class composed of 4 components:
 * $(UL
 * $(LI Red)
 * $(LI Green)
 * $(LI Blue)
 * $(LI Alpha (opacity)))
 *
 * Each component is a public member, an unsigned integer in the range [0, 255].
 * Thus, colors can be constructed and manipulated very easily:
 *
 * ---
 * auto color = Color(255, 0, 0); // red
 * color.r = 0;                // make it black
 * color.b = 128;              // make it dark blue
 * ---
 *
 * $(PARA The fourth component of colors, named "alpha", represents the opacity
 * of the color. A color with an alpha value of 255 will be fully opaque, while
 * an alpha value of 0 will make a color fully transparent, whatever the value
 * of the other components is.
 *
 * The most common colors are already defined as static variables:)
 * ---
 * auto black       = Color.Black;
 * auto white       = Color.White;
 * auto red         = Color.Red;
 * auto green       = Color.Green;
 * auto blue        = Color.Blue;
 * auto yellow      = Color.Yellow;
 * auto magenta     = Color.Magenta;
 * auto cyan        = Color.Cyan;
 * auto transparent = Color.Transparent;
 * ---
 *
 * $(PARA Colors can also be added and modulated (multiplied) using the
 * overloaded operators `+` and `*`.)
 */
module dsfml.graphics.color;

import std.algorithm;
import std.math;
import std.traits;

/**
 * Color is a utility struct for manipulating 32-bits RGBA colors.
 */
struct Color
{
    /// Red component
    ubyte r;
    /// Green component
    ubyte g;
    /// Blue component
    ubyte b;
    /// Alpha component
    ubyte a = 255;

    static immutable Black = Color(0, 0, 0, 255);
    static immutable White = Color(255, 255, 255, 255);
    static immutable Red = Color(255, 0, 0, 255);
    static immutable Green = Color(0, 255, 0,255);
    static immutable Blue = Color(0, 0, 255,255);
    static immutable Yellow = Color(255, 255, 0, 255);
    static immutable Magenta = Color(255, 0, 255, 255);
    static immutable Cyan = Color(0, 255, 255, 255);
    static immutable Transparent = Color(0, 0, 0, 0);

    /// Get the string representation of the Color.
    string toString() const
    {
        import std.conv;
        return "R: " ~ text(r) ~ " G: " ~ text(g) ~ " B: " ~ text(b) ~ " A: " ~ text(a);
    }

    /**
     * Overlolad of the `+`, `-`, and `*` operators.
     *
     * This operator returns the component-wise sum, subtraction, or
     * multiplication (also called"modulation") of two colors.
     *
     * For addition and subtraction, components that exceed 255 are clamped to
     * 255 and those below 0 are clamped to 0. For multiplication, are divided
     * by 255 so that the result is still in the range [0, 255].
     *
     * Params:
     * otherColor = The Color to be added to/subtracted from/bultiplied by this
     *              one
     *
     * Returns:
     * The addition, subtraction, or multiplication between this Color and the
     * other.
     */
    Color opBinary(string op)(Color otherColor) const
        if((op == "+") || (op == "-") || (op == "*"))
    {
        static if(op == "+")
        {
            return Color(cast(ubyte)min(r+otherColor.r, 255),
                         cast(ubyte)min(g+otherColor.g, 255),
                         cast(ubyte)min(b+otherColor.b, 255),
                         cast(ubyte)min(a+otherColor.a, 255));
        }
        static if(op == "-")
        {
            return Color(cast(ubyte)max(r-otherColor.r, 0),
                         cast(ubyte)max(g-otherColor.g, 0),
                         cast(ubyte)max(b-otherColor.b, 0),
                         cast(ubyte)max(a-otherColor.a, 0));
        }
        static if(op == "*")
        {
            return Color(cast(ubyte)(r*otherColor.r / 255),
                         cast(ubyte)(g*otherColor.g / 255),
                         cast(ubyte)(b*otherColor.b / 255),
                         cast(ubyte)(a*otherColor.a / 255));
        }
    }

    /**
     * Overlolad of the `*` and `/` operators.
     *
     * This operator returns the component-wise multiplicaton or division of a
     * color and a scalar.
     * Components that exceed 255 are clamped to 255 and those below 0 are
     * clamped to 0.
     *
     * Params:
     * num = the scalar to multiply/divide the Color.
     *
     * Returns:
     * The multiplication or division of this Color by the scalar.
     */
    Color opBinary(string op, E)(E num) const
        if(isNumeric!(E) && ((op == "*") || (op == "/")))
    {
        static if(op == "*")
        {
            //actually dividing or multiplying by a negative
            if(num < 1)
            {
                return Color(cast(ubyte)max(r*num, 0),
                             cast(ubyte)max(g*num, 0),
                             cast(ubyte)max(b*num, 0),
                             cast(ubyte)max(a*num, 0));
            }
            else
            {
                return Color(cast(ubyte)min(r*num, 255),
                             cast(ubyte)min(g*num, 255),
                             cast(ubyte)min(b*num, 255),
                             cast(ubyte)min(a*num, 255));
            }
        }
        static if(op == "/")
        {
            //actually multiplying or dividing by a negative
            if(num < 1)
            {
                return Color(cast(ubyte)min(r/num, 255),
                             cast(ubyte)min(g/num, 255),
                             cast(ubyte)min(b/num, 255),
                             cast(ubyte)min(a/num, 255));
            }
            else
            {
                return Color(cast(ubyte)max(r/num, 0),
                             cast(ubyte)max(g/num, 0),
                             cast(ubyte)max(b/num, 0),
                             cast(ubyte)max(a/num, 0));
            }
        }
    }

    /**
     * Overlolad of the `+=, `-=`, and `*=` operators.
     *
     * This operation computes the component-wise sum, subtraction, or
     * multiplication (also called"modulation") of two colors and assigns it to
     * the left operand.
     * Components that exceed 255 are clamped to 255 and those below 0 are
     * clamped to 0. For multiplication, are divided
     * by 255 so that the result is still in the range [0, 255].
     *
     * Params:
     * otherColor = The Color to be added to/subtracted from/bultiplied by this
     *              one
     *
     * Returns:
     * A reference to this color after performing the addition, subtraction, or
     * multiplication.
     */
    ref Color opOpAssign(string op)(Color otherColor)
        if((op == "+") || (op == "-") || (op == "*"))
    {
        static if(op == "+")
        {
            r = cast(ubyte)min(r+otherColor.r, 255);
            g = cast(ubyte)min(g+otherColor.g, 255);
            b = cast(ubyte)min(b+otherColor.b, 255);
            a = cast(ubyte)min(a+otherColor.a, 255);
        }
        static if(op == "-")
        {
            r = cast(ubyte)max(r-otherColor.r, 0);
            g = cast(ubyte)max(g-otherColor.g, 0);
            b = cast(ubyte)max(b-otherColor.b, 0);
            a = cast(ubyte)max(a-otherColor.a, 0);
        }
        static if(op == "*")
        {
            r = cast(ubyte)(r*otherColor.r / 255);
            g = cast(ubyte)(g*otherColor.g / 255);
            b = cast(ubyte)(b*otherColor.b / 255);
            a = cast(ubyte)(a*otherColor.a / 255);
        }

        return this;
    }

    /**
     * Overlolad of the `*=` and `/=` operators.
     *
     * This operation computers the component-wise multiplicaton or division of
     * a color and a scalar, then assignes it to the color.
     * Components that exceed 255 are clamped to 255 and those below 0 are
     * clamped to 0.
     *
     * Params:
     * num = the scalar to multiply/divide the Color
     *
     * Returns:
     * A reference to this color after performing the multiplication or
     * division.
     */
    ref Color opOpAssign(string op, E)(E num)
        if(isNumeric!(E) && ((op == "*") || (op == "/")))
    {
        static if(op == "*")
        {
            //actually dividing or multiplying by a negative
            if(num < 1)
            {
                r = cast(ubyte)max(r*num, 0);
                g = cast(ubyte)max(g*num, 0);
                b = cast(ubyte)max(b*num, 0);
                a = cast(ubyte)max(a*num, 0);
            }
            else
            {
                r = cast(ubyte)min(r*num, 255);
                g = cast(ubyte)min(g*num, 255);
                b = cast(ubyte)min(b*num, 255);
                a = cast(ubyte)min(a*num, 255);
            }

            return this;
        }
        static if(op == "/")
        {
            //actually multiplying or dividing by a negative
            if( num < 1)
            {
                r = cast(ubyte)min(r/num, 255);
                g = cast(ubyte)min(g/num, 255);
                b = cast(ubyte)min(b/num, 255);
                a = cast(ubyte)min(a/num, 255);
            }
            else
            {
                r = cast(ubyte)max(r/num, 0);
                g = cast(ubyte)max(g/num, 0);
                b = cast(ubyte)max(b/num, 0);
                a = cast(ubyte)max(a/num, 0);
            }

            return this;
        }
    }
    /**
     * Overload of the `==` and `!=` operators.
     *
     * This operator compares two colors and check if they are equal.
     *
     * Params:
     * otherColor = the Color to be compared with
     *
     * Returns: true if colors are equal, false if they are different.
     */
    bool opEquals(Color otherColor) const
    {
        return ((r == otherColor.r) && (g == otherColor.g) && (b == otherColor.b) && (a == otherColor.a));
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;

        writeln("Unit test for Color");

        //will perform arithmatic on Color to make sure everything works right.

        Color color = Color(100,100,100, 100);

        color*= 2;//(200, 200, 200, 200)

        color = color *.5;//(100, 100, 100, 100)

        color = color / 2;//(50, 50, 50, 50)

        color/= 2;//(25, 25, 25, 25)

        color+= Color(40,20,10,5);//(65,45, 35, 30)

        color-= Color(5,10,20,40);//(60, 35, 15, 0)

        color = color + Color(40, 20, 10, 5);//(100, 55, 25, 5)

        color = color - Color(5, 10, 20, 40);//(95, 45, 5, 0)

        assert(color == Color(95, 45, 5, 0));

        writeln();
    }
}
