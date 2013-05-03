module sfmodtest;

import dsfmod;
import dsfml.audio;

int main (string[] args) {

	//dsfmod.initSettings();
	auto mod = new Mod ("aurora.mod");
	
	mod.play();
	
	while (true){}

	return 0;
}
