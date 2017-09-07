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

/**
 * This class inherits all the functions of $(TRANSFORMABLE_LINK) (position,
 * rotation, scale, bounds, ...) as well as the functions of $(SHAPE_LINK)
 * (outline, color, texture, ...).
 *
 * Example:
 * ---
 * auto rectangle = new RectangleShape();
 * rectangle.size = Vector2f(100, 50);
 * rectangle.outlineColor = Color.Red;
 * rectangle.outlineThickness = 5;
 * rectangle.position = Vector2f(10, 20);
 * ...
 * window.draw(rectangle);
 * ---
 * See_Also:
 * $(SHAPE_LINK), $(CIRCLESHAPE_LINK), $(CONVEXSHAPE_LINK)
 */
module dsfml.graphics.rectangleshape;

import dsfml.graphics.shape;
import dsfml.system.vector2;

/**
 * Specialized shape representing a rectangle.
 */
class RectangleShape:Shape
{
    private Vector2f m_size;

    /**
     * Default constructor.
     *
     * Params:
     *  size = Size of the rectangle
     */
    this(Vector2f theSize = Vector2f(0,0))
    {
        size = theSize;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
    }

    /// The point count for a rectangle is always 4.
    @property
    {
        override uint pointCount()
        {
            return 4;
        }
    }

    @property
    {
        /// The size of the rectangle.
        Vector2f size(Vector2f theSize)
        {
            m_size = theSize;
            update();
            return theSize;
        }
        /// ditto
        Vector2f size()
        {
            return m_size;
        }
    }

    /**
     * Get a point of the rectangle.
     *
     * The result is undefined if index is out of the valid range.
     *
     * Params:
     * 		index	= Index of the point to get, in range [0 .. pointCount - 1]
     *
     * Returns: Index-th point of the shape.
     */
    override Vector2f getPoint(uint index) const
    {
        switch (index)
        {
            default:
            case 0: return Vector2f(0, 0);
            case 1: return Vector2f(m_size.x, 0);
            case 2: return Vector2f(m_size.x, m_size.y);
            case 3: return Vector2f(0, m_size.y);
        }
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;
        import dsfml.graphics;

        writeln("Unit test for RectangleShape");
        auto window = new RenderWindow(VideoMode(800,600), "RectangleShape unittest");

        auto rectangleShape = new RectangleShape(Vector2f(10, 20));

        rectangleShape.fillColor = Color.Blue;

        rectangleShape.outlineColor = Color.Green;

        auto clock = new Clock();


        while(window.isOpen())
        {
            Event event;

            while(window.pollEvent(event))
            {
                //no events gonna do stuffs!
            }

            //draws the shape for a while before closing the window
            if(clock.getElapsedTime().total!"seconds" > 1)
            {
                window.close();
            }

            window.clear();
            window.draw(rectangleShape);
            window.display();
        }

        writeln();
    }
}
