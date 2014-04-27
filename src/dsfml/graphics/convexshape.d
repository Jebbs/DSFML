module dsfml.graphics.convexshape;

import dsfml.system.vector2;
import dsfml.graphics.shape;

class ConvexShape:Shape
{
	private Vector2f[] m_points;

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
	
	override Vector2f getPoint(uint index) const
	{
		return m_points[index];
	}
	
	
	void setPoint(uint index, Vector2f point)
	{
		m_points[index] = point;
	}
	
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