/*
DSFML - The Simple and Fast Multimedia Library for D

Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

3. This notice may not be removed or altered from any source distribution


***All code is based on code written by Laurent Gomila***


External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

All Libraries used by SFML - For a full list see http://www.sfml-dev.org/license.php
*/
module dsfml.graphics.primitivetype;

/++
 + Types of primitives that a VertexArray can render.
 + 
 + Points and lines have no area, therefore their thickness will always be 1 pixel, regarldess the current transform and view.
 + 
 + Authors: Laurent Gomila, Jeremy DeHaan
 + See_Also: http://www.sfml-dev.org/documentation/2.0/group__graphics.php#ga5ee56ac1339984909610713096283b1b
 +/
enum PrimitiveType
{
	/// List of individual points.
	Points,
	/// List of individual lines
	Lines,
	/// List of connected lines; a point uses the previous point to form a line.
	LinesStrip,
	/// List of individual triangles.
	Triangles,
	/// List of connected triangles; a point uses the two previous points to form a triangle.
	TrianglesStrip,
	/// List of connected triangles; a point uses the common center and the previous point to form a triangle. 
	TrianglesFan,
	/// List of individual quads.
	Quads,
}