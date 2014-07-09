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

module dsfml.audio.soundsource;

import dsfml.system.vector3;

import dsfml.system.err;

/++
 + Base class defining a sound's properties.
 + 
 + SoundSource is not meant to be used directly, it only serves as a common base for all audio objects that can live in the audio environment.
 + 
 + It defines several properties for the sound: pitch, volume, position, attenuation, etc. All of them can be changed at any time with no impact on performances.
 + 
 + See_Also: http://sfml-dev.org/documentation/2.0/classsf_1_1SoundSource.php#details
 + Authors: Laurent Gomila, Jeremy DeHaan
 +/
interface SoundSource
{
	/// Enumeration of the sound source states.
	enum Status
	{
		/// Sound is not playing.
		Stopped,
		/// Sound is paused.
		Paused,
		/// Sound is playing.
		Playing
	}

	/**
	 * The pitch of the sound.
	 * 
	 * The pitch represents the perceived fundamental frequency of a sound; thus you can make a sound more acute or grave by changing its pitch. A side effect of changing the pitch is to modify the playing speed of the sound as well. The default value for the pitch is 1.
	 */
	@property
	{
		void pitch(float newPitch);
		
		float pitch();
	}

	/**
	 * The volume of the sound.
	 * 
	 * The volume is a vlue between 0 (mute) and 100 (full volume). The default value for the volume is 100.
	 */
	@property
	{
		void volume(float newVolume);

		float volume();
	}

	/**
	 * The 3D position of the sound in the audio scene.
	 * 
	 * Only sounds with one channel (mono sounds) can be spatialized. The default position of a sound is (0, 0, 0).
	 */
	@property
	{
		void position(Vector3f newPosition);

		Vector3f position();
	}

	/**
	 * Make the sound's position relative to the listener (true) or absolute (false).
	 * 
	 * Making a sound relative to the listener will ensure that it will always be played the same way regardless the position of the listener.  This can be useful for non-spatialized sounds, sounds that are produced by the listener, or sounds attached to it. The default value is false (position is absolute).
	 */
	@property
	{
		void relativeToListener(bool relative);

		bool relativeToListener();
	}
	
	/**
	 * The minimum distance of the sound.
	 * 
	 * The "minimum distance" of a sound is the maximum distance at which it is heard at its maximum volume. Further than the minimum distance, it will start to fade out according to its attenuation factor. A value of 0 ("inside the head of the listener") is an invalid value and is forbidden. The default value of the minimum distance is 1.
	 */
	@property
	{
		void minDistance(float distance);

		float minDistance();
	}
	
	/**
	 * The attenuation factor of the sound.
	 * 
	 * The attenuation is a multiplicative factor which makes the sound more or less loud according to its distance from the listener. An attenuation of 0 will produce a non-attenuated sound, i.e. its volume will always be the same whether it is heard from near or from far. 
	 * 
	 * On the other hand, an attenuation value such as 100 will make the sound fade out very quickly as it gets further from the listener. The default value of the attenuation is 1.
	 */
	@property
	{
		void attenuation(float newAttenuation);

		float attenuation();
	}

}

private extern(C):

const(char)* sfErrAudio_getOutput();

