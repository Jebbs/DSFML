module dsfml.window.context;

debug import std.stdio;

class Context
{
	package sfContext* sfPtr;
	
	this()
	{
		sfPtr = sfContext_create();
	}
	
	~this()
	{
		debug writeln("Destroying Context");
		sfContext_destroy(sfPtr);	
	}
	
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