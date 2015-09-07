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

///A module containing the Context class.
module dsfml.window.context;

/**
*Class holding a valid drawing context.
*
*If you need to make OpenGL calls without having an active window (like in a thread), you can use an instance of this class to get a valid context.
*
*Having a valid context is necessary for every OpenGL call.
*
*Note that a context is only active in its current thread, if you create a new thread it will have no valid context by default.
*
*To use a Context instance, just construct it and let it live as long as you need a valid context. No explicit activation is needed, all it has to do is to exist. Its destructor will take care of deactivating and freeing all the attached resources.
*/
class Context
{
	package sfContext* sfPtr;
	
	///Default constructor.
	///
	///The constructor creates and activates the context
	this()
	{
		sfPtr = sfContext_create();
	}
	
	///Destructor
	~this()
	{
		import dsfml.system.config;
		mixin(destructorOutput);
		sfContext_destroy(sfPtr);	
	}
	
	///Activate or deactivate explicitely the context.
	///
	///Params:
    ///		active = True to activate, false to deactivate.
    ///
	///Returns: True on success, false on failure.
	void setActive(bool active)
	{
		sfContext_setActive(sfPtr,active);
	}
	
}

package extern(C)
{
	struct sfContext;
}
private extern(C)
{
	sfContext* sfContext_create();
	void sfContext_destroy(sfContext* context);
	void sfContext_setActive(sfContext* context, bool active);
}
//unittest?
//I'll probably write one just to confirm no segfaults happen and to up the coverage amount