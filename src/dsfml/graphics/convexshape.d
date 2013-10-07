module dsfml.graphics.convexshape;

import dsfml.system.vector2;

import dsfml.graphics.shape;
import std.algorithm;

debug import std.stdio;

class ConvexShape:Shape
{
	this(uint thePointCount)
	{
		this.pointCount = thePointCount;
		update();
	}
	~this()
	{
		debug writeln("Destroying ConvexShape");
	}
	@property
	{
		void pointCount(uint newPointCount)
		{
			m_points.length = newPointCount;
			update();
		}
		override uint pointCount()
		{
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
	
	private Vector2f[] m_points;
}