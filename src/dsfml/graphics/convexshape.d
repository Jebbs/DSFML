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
 * This class inherits all the functions of $(TRANSFORMABLE_LINK) (position,
 * rotation, scale, bounds, ...) as well as the functions of $(SHAPE_LINK)
 * (outline, color, texture, ...).
 *
 * It is important to keep in mind that a convex shape must always be... convex,
 * otherwise it may not be drawn correctly. Moreover, the points must be defined
 * in order; using a random order would result in an incorrect shape.
 *
 * Example:
 * ---
 * auto polygon = new ConvexShape();
 * polygon.pointCount = 3;
 * polygon.setPoint(0, Vector2f(0, 0));
 * polygon.setPoint(1, Vector2f(0, 10));
 * polygon.setPoint(2, Vector2f(25, 5));
 * polygon.outlineColor = Color.Red;
 * polygon.outlineThickness = 5;
 * polygon.position = Vector2f(10, 20);
 * ...
 * window.draw(polygon);
 * ---
 *
 * See_Also:
 * $(SHAPE_LINK), $(RECTANGLESHAPE_LINK), $(CIRCLESHAPE_LINK)
 */
module dsfml.graphics.convexshape;

import dsfml.system.vector2;
import dsfml.graphics.shape;

/**
 * Specialized shape representing a convex polygon.
 */
class ConvexShape : Shape
{
    private Vector2f[] m_points;

    /**
     * Default constructor.
     *
     * Params:
     * thePointCount = Number of points on the polygon
     */
    this(uint thePointCount = 0)
    {
        this.pointCount = thePointCount;
        update();
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
    }

    @property
    {
        /// The number of points on the polygon
        uint pointCount(uint newPointCount)
        {
            m_points.length = newPointCount;
            update();
            return newPointCount;
        }

        /// ditto
        override uint pointCount() const
        {
            import std.algorithm;
            return cast(uint)min(m_points.length, uint.max);
        }
    }

    /**
     * Get the position of a point.
     *
     * The result is undefined if index is out of the valid range.
     *
     * Params:
     * 		index =	Index of the point to get, in range [0 .. `pointCount` - 1]
     *
     * Returns: Index-th point of the shape.
     */
    override Vector2f getPoint(uint index) const
    {
        return m_points[index];
    }

    /**
     * Set the position of a point.
     *
     * Don't forget that the polygon must remain convex, and the points need to
     * stay ordered! `pointCount` must be changed first in order to set the total
     * number of points. The result is undefined if index is out of the valid
     *range.
     *
     * Params:
     * 		index =	Index of the point to change, in range
                    [0 .. `pointCount` - 1]
     * 		point =	New position of the point
     */
    void setPoint(uint index, Vector2f point)
    {
        m_points[index] = point;
    }

    /**
     * Add a point to the polygon.
     *
     * Don't forget that the polygon must remain convex, and the points need to
     * stay ordered!
     *
     * Params:
     * 		point =	Position of the new point.
     */
    void addPoint(Vector2f point)
    {
        m_points ~=point;
        update();
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;
        import dsfml.graphics;

        writeln("Unit test for ConvexShape");
        auto window = new RenderWindow(VideoMode(800,600), "ConvexShape unittest");

        auto convexShape = new ConvexShape();

        convexShape.addPoint(Vector2f(0,20));
        convexShape.addPoint(Vector2f(10,10));
        convexShape.addPoint(Vector2f(20,20));
        convexShape.addPoint(Vector2f(20,30));
        convexShape.addPoint(Vector2f(10,40));
        convexShape.addPoint(Vector2f(0,30));

        convexShape.fillColor = Color.Blue;

        convexShape.outlineColor = Color.Green;

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
            window.draw(convexShape);
            window.display();
        }

        writeln();
    }
}
