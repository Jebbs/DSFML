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

#ifndef DSFML_SOUNDRECORDER_STRUCT_H
#define DSFML_SOUNDRECORDER_STRUCT_H

//Headers
#include <SFML/Audio/SoundRecorder.hpp>
#include <SFML/System/Time.hpp>
#include <DSFMLC/Config.h>



//class to use in D
class SoundRecorderCallBacks
{
public:
	virtual DBool onStart();

    virtual DBool onProcessSamples(const DShort* samples, std::size_t sampleCount);

    virtual void onStop();
};


class SoundRecorderImp: public sf::SoundRecorder
{
private:
	SoundRecorderCallBacks* callBacks;

public:
	SoundRecorderImp(SoundRecorderCallBacks* newCallBacks):
	callBacks(newCallBacks)
	{
		//callBacks = newCallBacks;
	}

	//XXX Using a public method here to gain access to a C++ Protected method from D. Not sure if this is the best way.
	void setProcessingIntervalD (DUlong time)
	{
		sf::SoundRecorder::setProcessingInterval(sf::microseconds(time));
	}

protected:
	virtual bool onStart()
	{
		return (callBacks->onStart() == DTrue);
	}

	virtual bool onProcessSamples(const sf::Int16* samples, std::size_t sampleCount)
	{
		return (callBacks->onProcessSamples(samples, sampleCount) == DTrue);
	}

	virtual void onStop()
	{
		callBacks->onStop();
	}

};

//Wrapper around an InternalSoundRecorder
struct sfSoundRecorder
{
	sfSoundRecorder(SoundRecorderCallBacks* newCallBacks):
	This(newCallBacks)
	{

	}

    SoundRecorderImp This;
};
#endif // DSFML_SOUNDRECORDER_STRUCT_H
