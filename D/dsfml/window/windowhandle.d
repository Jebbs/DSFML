module dsfml.window.windowhandle;


version(Windows)
{
	struct HWND__;
	alias HWND__* WindowHandle;
}
version(OSX)
{
	import core.stdc.config;
	alias c_ulong WindowHandle;
}
version(linux)
{
	alias void* WindowHandle;
}