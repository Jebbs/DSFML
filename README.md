DSFML
=====

DSFML is a D static binding of SFML, which let's you use SFML in your D program. DSFML attempts to be as compatible with SFML as possible, but does so in a D way by using new D semanics, as well as avoiding raw pointers. 

*Important Notice:* A new version of DSFML is currently being worked on and is very nearly done. Please check it out in the experimental branch [here](https://github.com/Jebbs/DSFML/tree/Experimental). This branch has many improvements over the current branch and will soon be replacing it.


Compiling a project using DSFML
===

You can use DSFML in one of two ways, both of which are simple. You can either compile the source code into a library and link against it in your final project, or simply include the source code along with your own when compiling. DSFML is based on CSFML(which needs to be built from source if on mac or linux) and need's its shared libraries and import libraries in order to compile properly. Link against the import libraries, and make sure the application has access to the shared libraries and you should be good to go! 

The version in this repo should be up to date with the latest SFML and CSFML versions. If you happen to see something I missed please open an issue in the tracker! The .dll's and .lib's for building in Windows are included in the repo for download and will always be in sync with the code presented here.



Extensions
===

E.S. Quinn has started a repository for various extensions to DSFML including his own bindings for sfMod and sfMidi.
You can find it at <https://github.com/aubade/dsfml-contrib>

Known Issues
===

There is a known issue that currently prevents 64bit builds of this library using DMD. There is a fix in the works, but for the time being either compile SFML, CSFML, and DSFML in 32bits or use a D compiler that doesn't skew the C ABI such as GDC.


If problems are encountered!
===

This is my first project that I have provided others to use, so feel free to give me feed back. Especially if you encounter an issue that prevents you from using the binding!

Email is <dehaan.jeremiah@gmail.com>

