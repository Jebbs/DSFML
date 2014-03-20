module dsfml.graphics.convexshape;

import dsfml.system.vector2;
import dsfml.graphics.shape;

class ConvexShape:Shape
{
	private Vector2f[] m_points;

	this(uint thePointCount)
	{
		this.pointCount = thePointCount;
		update();
	}

	~this()
	{
		version(DSFML_Quiet_Destructors) { }
		else
		{
			import std.stdio;
			writeln("Destroying ConvexShape");
		}
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
