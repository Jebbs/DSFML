module dsfml.graphics.convexshape;

import dsfml.system.vector2;
import dsfml.graphics.shape;

/++
 + Specialized shape representing a convex polygon.
 + 
 + This class inherits all the functions of Transformable (position, rotation, scale, bounds, ...) as well as the functions of Shape (outline, color, texture, ...).
 + 
 + It is important to keep in mind that a convex shape must always be... convex, otherwise it may not be drawn correctly. Moreover, the points must be defined in order; using a random order would result in an incorrect shape.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1ConvexShape.php#a4f4686f57622bfbbe419ac1420b1432a
 +/
class ConvexShape : Shape
{
	private Vector2f[] m_points;

	/// Params: pointCount =	Number of points on the polygon
	this(uint thePointCount = 0)
	{
		this.pointCount = thePointCount;
		update();
	}

	~this()
	{
		debug import dsfml.system.config;
		debug mixin(destructorOutput);
	}

	/// The number of points on the polygon
	@property
	{
		uint pointCount(uint newPointCount)
		{
			m_points.length = newPointCount;
			update();
			return newPointCount;
		}
		override uint pointCount()
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
	 * 		index =	Index of the point to get, in range [0 .. pointCount - 1].
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
	 * Don't forget that the polygon must remain convex, and the points need to stay ordered! pointCount must be changed first in order to set the total number of points. The result is undefined if index is out of the valid range.
	 * 
	 * Params:
	 * 		index =	Index of the point to change, in range [0 .. pointCount - 1].
	 * 		point =	New position of the point
	 */
	void setPoint(uint index, Vector2f point)
	{
		m_points[index] = point;
	}

	/**
	 * Add a point to the polygon.
	 * 
	 * Don't forget that the polygon must remain convex, and the points need to stay ordered!
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
			if(clock.getElapsedTime().asSeconds() >1)
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