#ifndef DSFML_SOUNDSTRUCT_H
#define DSFML_SOUNDSTRUCT_H

#include <SFML/Audio/Sound.hpp>
#include "SoundBufferStruct.h"


struct sfSound
{
	sf::Sound This;
	const sfSoundBuffer* Buffer;
};


#endif //DSFML_SOUNDSTRUCT_H