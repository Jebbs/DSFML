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
	debug
	{
		version (DSFML_Quiet_Destructors)
		{
		}
		else
		{
			import std.string;
			import dsfml.system.err;
			err.writeln(this.classinfo.name[1+lastIndexOf(this.classinfo.name,'.')..$]);
		}
	}`;

