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
module dsfml.graphics.blendmode;

/++
 + Available blending modes for drawing.
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.3/structsf_1_1BlendMode.php
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
/*enum BlendMode
{
	/// Pixel = Source * Source.a + Dest * (1 - Source.a)
	Alpha,
	/// Pixel = Source + Dest.
	Add,
	/// Pixel = Source * Dest.
	Multiply,
	/// Pixel = Source.
	None
}*/

struct BlendMode
{
	enum Alpha = BlendMode(Factor.SrcAlpha, Factor.OneMinusSrcAlpha, Equation.Add,
							Factor.One, Factor.OneMinusSrcAlpha, Equation.Add);
	enum Add = BlendMode(Factor.SrcAlpha, Factor.One, Equation.Add,
							Factor.One, Factor.One, Equation.Add);
	enum Multiply = BlendMode(Factor.DstColor, Factor.Zero);
	enum None = BlendMode (Factor.One, Factor.Zero);
	
	enum Factor
	{
		Zero,
		One,
		SrcColor,
		OneMinunSrcColor,
		DstColor,
		OneMinusDstColor,
		SrcAlpha,
		OneMinusSrcAlpha,
		DstAlpha,
		OneMinusDstAlpha
	}
	
	enum Equation
	{
		Add,
		Subtract
	}
	
	Factor colorSrcFactor = Factor.SrcAlpha;
	Factor colorDstFactor = Factor.OneMinusSrcAlpha;
	Equation colorEquation = Equation.Add;
	Factor alphaSrcFactor = Factor.One;
	Factor alphaDstFactor = Factor.OneMinusSrcAlpha;
	Equation alphaEquation = Equation.Add;
	
	this(Factor colorSrc, Factor colorDst, Equation colorEqua,
		 Factor alphaSrc, Factor alphaDst, Equation alphaEqua)
	{
		colorSrcFactor = colorSrc;
		colorDstFactor = colorDst;
		colorEquation = colorEqua;
		
		alphaSrcFactor = alphaSrc;
		alphaDstFactor = alphaDst;
		alphaEquation = alphaEquation;
	}
	
	this(Factor srcFactor, Factor dstFactor, Equation equation = Equation.Add) {
		colorSrcFactor = alphaSrcFactor = srcFactor;
		colorDstFactor = alphaDstFactor = dstFactor;
		colorEquation = alphaEquation = equation;
	}
}