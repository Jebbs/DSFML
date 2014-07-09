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

/++
 + The audio listener is the point in the scene from where all the sounds are heard.
 + 
 + The audio listener defines the global properties of the audio environment, it defines where and how sounds and musics are heard.
 + 
 + If View is the eyes of the user, then Listener is his ears (by the way, they are often linked together – same position, orientation, etc.).
 + 
 + Listener is a simple interface, which allows to setup the listener in the 3D audio environment (position and direction), and to adjust the global volume.
 + 
 + Because the listener is unique in the scene, Listener only contains static functions and doesn't have to be instanciated.
 + 
 + See_Also: http://www.sfml-dev.org/documentation/2.0/classsf_1_1Listener.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
final abstract class Listener
{
	/** 
	 * The orientation of the listener in the scene. The orientation defines the 3D axes of the listener (left, up, front) in the scene. The orientation vector doesn't have to be normalized. 
	 * 
	 * The default listener's orientation is (0, 0, -1).
	 */
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

	/** 
	 * The global volume of all the sounds and musics. The volume is a number between 0 and 100; it is combined with the individual volume of each sound / music. 
	 * 
	 * The default value for the volume is 100 (maximum).
	 */
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
	
	/// The position of the listener in the scene.
	/// The default listener's position is (0, 0, 0).
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
}

unittest
{
	version(DSFML_Unittest_Audio)
	{
		import std.stdio;

		writeln("Unit test for Listener");

		float volume = Listener.GlobalVolume;
		volume-=10;
		Listener.GlobalVolume = volume;


		Vector3f pos = Listener.Position;
		pos.x += 10;
		pos.y -= 10;
		pos.z *= 3;
		Listener.Position = pos;

		Vector3f dir = Listener.Direction;
		dir.x += 10;
		dir.y -= 10;
		dir.z *= 3;
		Listener.Direction = dir;
		writeln("Unit tests pass!");
		writeln();
	}
}

private extern(C):

void sfListener_setGlobalVolume(float volume);

float sfListener_getGlobalVolume();

void sfListener_setPosition(float x, float y, float z);

void sfListener_getPosition(float* x, float* y, float* z);

void sfListener_setDirection(float x, float y, float z);

void sfListener_getDirection(float* x, float* y, float* z);

