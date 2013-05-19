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



External Libraries Used:

SFML - The Simple and Fast Multimedia Library
Copyright (C) 2007-2013 Laurent Gomila (laurent.gom@gmail.com)

*/

//This class should only be used for initial porting!
//Please use D's regular thread functionality when you can!

module dsfml.system.thread;

import core = core.thread;

class Thread
{
	core.Thread InternalThread;
	this(void function() fn, size_t sz = 0)
	{
		InternalThread = new core.Thread(fn,sz);
	}

	this(void delegate() dg, size_t sz = 0)
	{
		InternalThread = new core.Thread(dg, sz);	
	}

	void launch()
	{
		InternalThread.start();
	}

	void wait()
	{
		InternalThread.join(false);
	}

	//There is no way to stop threads in D! Mostly because it is considered unsafe. I'll leave this here for now.
	//void terminate()


}

