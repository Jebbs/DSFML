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
 * Example:
 * ---
 * auto circle = new CircleShape();
 * circle.radius = 150;
 * circle.outlineColor = Color.Red;
 * circle.outlineThickness = 5;
 * circle.position = Vector2f(10, 20);
 * ...
 * window.draw(circle);
 * ---
 *
 *$(PARA Since the graphics card can't draw perfect circles, we have to fake
 * them with multiple triangles connected to each other. The "points count"
 * property of $(U CircleShape) defines how many of these triangles to use, and
 * therefore defines the quality of the circle.)
 *
 * See_Also:
 * $(SHAPE_LINK), $(RECTANGLESHAPE_LINK), $(CONVEXSHAPE_LINK)
 */
module dsfml.graphics.circleshape;

import dsfml.graphics.shape;

import dsfml.system.vector2;

/**
 * Specialized shape representing a circle.
 */
class CircleShape : Shape
{
    private
    {
        // Radius of the circle
        float m_radius;
        /// Number of points composing the circle
        uint m_pointCount;
    }

    /**
     * Default constructor.
     *
     * Params:
     * 		radius =		Radius of the circle
     * 		pointCount =	Number of points composing the circle
    */
    this(float radius = 0, uint pointCount = 30)
    {
        m_radius = radius;
        m_pointCount = pointCount;

        update();
    }

    /// Destructor
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
    }

    @property
    {
        /// The number of points of the circle.
        uint pointCount(uint newPointCount)
        {
            m_pointCount = newPointCount;
            return newPointCount;
        }

        /// ditto
        override uint pointCount() const
        {
            return m_pointCount;
        }
    }

    @property
    {
        /// The radius of the circle.
        float radius(float newRadius)
        {
            m_radius = newRadius;
            update();
            return newRadius;
        }

        /// ditto
        float radius() const
        {
            return m_radius;
        }
    }

    /**
     * Get a point of the shape.
     *
     * The result is undefined if index is out of the valid range.
     *
     * Params:
     * 		index =	Index of the point to get, in range [0 .. pointCount - 1].
     *
     * Returns: Index-th point of the shape.
     */
    override Vector2f getPoint(uint index) const
    {
        import std.math;
        static const(float) pi = 3.141592654f;

        float angle = index * 2 * pi / m_pointCount - pi / 2;

        float x = cos(angle) * m_radius;
        float y = sin(angle) * m_radius;

        return Vector2f(m_radius + x, m_radius + y);
    }

    /// Clones this CircleShape
    @property
    CircleShape dup() const
    {
        CircleShape temp = new CircleShape(m_radius, m_pointCount);

        temp.position = position;
        temp.rotation = rotation;
        temp.scale = scale;
        temp.origin = origin;

        return temp;
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;
        import dsfml.graphics;

        writeln("Unit test for CircleShape");
        auto window = new RenderWindow(VideoMode(800,600), "CircleShape unittest");

        auto circleShape = new CircleShape(20);

        circleShape.fillColor = Color.Blue;

        circleShape.outlineColor = Color.Green;

        auto clock = new Clock();


        while(window.isOpen())
        {
            Event event;

            while(window.pollEvent(event))
            {
                //no events gonna do stuffs!
            }

            //draws the shape for a while before closing the window
            if(clock.getElapsedTime().asSeconds() > 1)
            {
                window.close();
            }

            window.clear();
            window.draw(circleShape);
            window.display();
        }

        writeln();
    }
}
