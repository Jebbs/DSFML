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

///A module containing the ContextSettings struct.
module dsfml.window.contextsettings;

/**
 *Structure defining the settings of the OpenGL context attached to a window.
 *
 *ContextSettings allows to define several advanced settings of the OpenGL context attached to a window.
 *
 *All these settings have no impact on the regular SFML rendering (graphics module) – except the 
 *anti-aliasing level, so you may need to use this structure only if you're using SFML as a windowing system for custom OpenGL rendering.
 *
 *The depthBits and stencilBits members define the number of bits per pixel requested for the (respectively) depth and stencil buffers.
 *
 *antialiasingLevel represents the requested number of multisampling levels for anti-aliasing.
 *
 *majorVersion and minorVersion define the version of the OpenGL context that you want. Only versions
 *greater or equal to 3.0 are relevant; versions lesser than 3.0 are all handled the same way (i.e. you 
 *(can use any version < 3.0 if you don't want an OpenGL 3 context).
 *
 *Please note that these values are only a hint. No failure will be reported if one or more of these 
 *values are not supported by the system; instead, SFML will try to find the closest valid match. 
 *You can then retrieve the settings that the window actually used to create its context, with Window.getSettings(). 
 */
struct ContextSettings
{
	///Bits of the depth buffer.
	uint depthBits = 0;
	///Bits of the stencil buffer.
	uint stencilBits = 0;
	///Level of antialiasing.
	uint antialiasingLevel = 0;
	///Level of antialiasing.
	uint majorVersion = 2;
	///Minor number of the context version to create.
	uint minorVersion = 0;
	
	static const(ContextSettings) Default;
}
//unittest?