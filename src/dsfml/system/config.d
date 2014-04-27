module dsfml.system.config;

//Check to confirm compiler is at least v2.064
static if (__VERSION__ < 2064L)
{
	static assert(0, "Please upgrade your compiler to v2.064 or later");
}

//version enum
enum
{
	DSFML_VERSION_MAJOR = 2,
	DSFML_VERSION_MINOR = 0
}

//destructor output for mixing in.
enum destructorOutput =`
	version (DSFML_Quiet_Destructors)
	{
	}
	else
	{
		import dsfml.system.err;
		err.writeln("Destroying ", typeof(this).stringof);
	}`;

