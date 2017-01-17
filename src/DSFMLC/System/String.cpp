#include <DSFMLC/System/String.h>
#include <SFML/System/Utf.hpp>

namespace
{
    std::basic_string<DUbyte> utf8Out;
    std::basic_string<DUshort> utf16Out;
    std::basic_string<DUint> utf32Out;
}

//Convert to utf8
void utf16to8(const DUshort* inStr, size_t inLen, const DUbyte* outStr, size_t* outLen)
{
	std::basic_string<DUshort> in;
	in.insert(0,inStr, inLen);
   
    utf8Out.clear();
   
   sf::Utf16::toUtf8(in.begin(), in.end(), utf8Out.begin());

	outStr = utf8Out.data();
	*outLen = utf8Out.length();
	

}
void utf32to8(const DUint* inStr, size_t inLen, const DUbyte* outStr, size_t* outLen)
{
    std::basic_string<DUint> in;
	in.insert(0,inStr, inLen);
   
    utf8Out.clear();
   
   sf::Utf32::toUtf8(in.begin(), in.end(), utf8Out.begin());

	outStr = utf8Out.data();
	*outLen = utf8Out.length();
}

//Convert to utf16
void utf8to16(const DUbyte* inStr, size_t inLen, const DUshort* outStr, size_t* outLen)
{
    std::basic_string<DUbyte> in;
	in.insert(0,inStr, inLen);
   
    utf16Out.clear();
   
   sf::Utf8::toUtf16(in.begin(), in.end(), utf16Out.begin());

	outStr = utf16Out.data();
	*outLen = utf16Out.length();
}
void utf32to16(const DUint* inStr, size_t inLen, const DUshort* outStr, size_t* outLen)
{
    std::basic_string<DUint> in;
	in.insert(0,inStr, inLen);
   
    utf8Out.clear();
   
   sf::Utf32::toUtf16(in.begin(), in.end(), utf16Out.begin());

	outStr = utf16Out.data();
	*outLen = utf16Out.length();
}

//Convert to utf32
void utf8to32(const DUbyte* inStr, size_t inLen, const DUint* outStr, size_t* outLen)
{
    std::basic_string<DUbyte> in;
	in.insert(0,inStr, inLen);
   
    utf32Out.clear();
   
   sf::Utf8::toUtf32(in.begin(), in.end(), utf32Out.begin());

	outStr = utf32Out.data();
	*outLen = utf32Out.length();
}
void utf16to32(const DUshort* inStr, size_t inLen, const DUint* outStr, size_t* outLen)
{
    std::basic_string<DUshort> in;
	in.insert(0,inStr, inLen);
   
    utf32Out.clear();
   
   sf::Utf16::toUtf32(in.begin(), in.end(), utf32Out.begin());

	outStr = utf32Out.data();
	*outLen = utf32Out.length();
}
