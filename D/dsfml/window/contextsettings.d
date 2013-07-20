module dsfml.window.contextsettings;

struct ContextSettings
{
	uint depthBits = 0;
	uint stencilBits = 0;
	uint antialiasingLevel = 0;
	uint majorVersion = 2;
	uint minorVersion = 0;
	
	static const(ContextSettings) Default;
}