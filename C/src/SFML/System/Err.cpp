#include <SFML/System/Err.h>
#include <SFML/System/Err.hpp>

void sfErr_directToNothing(void)
{

    //sf::err() <<"SFML's Error Stream will now close!" << std::endl;
    sf::err().rdbuf(NULL);
    //sf::err() << "Stream now closed for business" << std::endl;
}

