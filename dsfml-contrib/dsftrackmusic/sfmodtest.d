/* Simple test of sfmod's functionality.
   this code is public domain.
 */

module sfmodtest;

import dsfml.audio;
import dsfml.window;
import dsfml.graphics;

import std.conv;

import dsfmod;

SoundStatus status = SoundStatus.Stopped;


int main (string[] args) {

	dsfmod_initSettings();
	auto mod = new Mod ("aurora.mod");
	auto window = new RenderWindow (VideoMode(800, 600, 32), "MOD Player");
	auto font = new Font();
	auto keys = new Keyboard();
	string text;
	
	font.loadFromFile ("BriemAkademiStd-Regular.otf");
	
	auto mod_info = new Text ("", font);
	mod_info.characterSize = 14;
	window.display();
	
	while (window.isOpen()) {
		Event event;
		
		if (status == SoundStatus.Stopped)
			mod_info.String = "Playback Stopped.";
		else {
			mod_info.String = (status == SoundStatus.Playing?"Mod Playing: ":"Mod Paused") ~ mod.getName() ~ "   Length: " ~ to!string(mod.getLength) ~ "\n" ~ mod.getSongComments ~ "\n" ~
				"Pattern: " ~ to!string(mod.getCurrentPattern()) ~ " Row: " ~ to!string(mod.getCurrentRow()) ~ " Channels: " ~ to!string(mod.getPlayingChannels);
				
		}
		
		while (window.pollEvent (event))
		{
			if (event.type == Event.Closed)
				window.close();

			if (event.type == Event.KeyPressed)
			{
				if (keys.isKeyPressed (Keyboard.Key.Space))
				{
					status = (status==SoundStatus.Playing?SoundStatus.Paused:SoundStatus.Playing);
					if (status == SoundStatus.Playing)
						mod.play();
					else
						mod.pause();
				}
				if (keys.isKeyPressed (Keyboard.Key.Return))
				{	
					status = (status==SoundStatus.Stopped?SoundStatus.Playing:SoundStatus.Stopped);
					if (status == SoundStatus.Stopped)
						mod.stop();
					else
						mod.play();
				}
				if (keys.isKeyPressed (Keyboard.Key.Left))
					mod.currentOrder = mod.currentOrder - 1;
				if (keys.isKeyPressed (Keyboard.Key.Right))
					mod.currentOrder = mod.currentOrder + 1;
					
				if (keys.isKeyPressed (Keyboard.Key.Up))
					mod.masterVolume = mod.masterVolume + 32;
				if (keys.isKeyPressed (Keyboard.Key.Down))
					mod.masterVolume = mod.masterVolume - 32;	
				if (keys.isKeyPressed (Keyboard.Key.Escape))
					window.close();	
			}
		}
		
		
		window.clear (Color.Black);
		window.draw (mod_info);
		
		window.display();			
		
	}

	return 0;
}
