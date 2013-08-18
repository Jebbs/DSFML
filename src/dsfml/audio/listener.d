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

module dsfml.audio.listener;

import dsfml.system.vector3;

final abstract class Listener
{
	@property
	{
		static void GlobalVolume(float volume)
		{
			sfListener_setGlobalVolume(volume);
		}
		static float GlobalVolume()
		{
			return sfListener_getGlobalVolume();
		}
		
	}
	
	@property
	{
		static void Position(Vector3f position)
		{
			sfListener_setPosition(position.x, position.y, position.z);
		}
		static Vector3f Position()
		{
			Vector3f temp;

			sfListener_getPosition(&temp.x, &temp.y, &temp.z);

			return temp;
		}
	}
	
	@property
	{
		static void Direction(Vector3f orientation)
		{
			sfListener_setDirection(orientation.x, orientation.y, orientation.z);
		}
		static Vector3f Direction()
		{
			Vector3f temp;
			
			sfListener_getDirection(&temp.x, &temp.y, &temp.z);
			
			return temp;
		}
	}
}

private extern(C):

void sfListener_setGlobalVolume(float volume);

float sfListener_getGlobalVolume();

void sfListener_setPosition(float x, float y, float z);

void sfListener_getPosition(float* x, float* y, float* z);

void sfListener_setDirection(float x, float y, float z);

void sfListener_getDirection(float* x, float* y, float* z);

