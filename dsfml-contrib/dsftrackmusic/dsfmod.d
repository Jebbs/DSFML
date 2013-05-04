/** DSFMod 
  * Uses libmodplug to play Amiga Module-style tracker music.
  * Based on sfMod by Kerli Low
  * Copyright © 2013 E.S. Quinn
  
    This software is provided 'as-is', without any express or implied
    warranty.  In no event will the authors be held liable for any damages
    arising from the use of this software.
  
    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
       claim that you wrote the original software. If you use this software
       in a product, an acknowledgment in the product documentation would be
       appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be
       misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.

  */
module dsftrackmusic.dsfmod;

import std.file;

import dsfml.audio;
import dsfml.system;

import modplug;

private import std.algorithm;
private import std.conv;


immutable BUFFERSIZE = 4096;

//Not sure if thees are necessary. Need to dig around SFML a bit.
immutable CHANNELCOUNT = 2;
immutable SAMPLERATE = 44100;

extern(C) int sfTime_asMilliseconds(sfTime time);


ModPlug_Settings settings;
ModPlug_Settings defSettings;

void dsfmod_initSettings() {
	ModPlug_GetSettings (&defSettings);
	
	settings = defSettings;
}

void dsfmod_applySettings() {
	ModPlug_SetSettings (&settings);
}

void dsfmod_defaultSettings () {
	ModPlug_SetSettings (&defSettings);
	
	settings = defSettings;
}

class Mod : SoundStream
{
	public:
	this(string filename) {
		
		auto data = cast(ubyte[]) read (filename);
		
		
		this (cast (void*)data.ptr, data.length);
	}
	
	this (const (void)* data, size_t sizeInBytes) {
		buffer_ = new short[](BUFFERSIZE / 2);	
		userdata_.our_buffer_ = buffer_.ptr;
		
		file_ = null;
		name_ = "";
		length_ = 0;

		file_ = ModPlug_Load (data, cast(int)(min(int.max, sizeInBytes)));
		
		if (file_ == null) {
			throw new Exception ("Failed to load module.");
		}
		userdata_.our_file_ = file_;
		
		name_ = to!string(ModPlug_GetName(file_));
		length_ = ModPlug_GetLength(file_);
		
		ModPlug_Settings settings;
		ModPlug_GetSettings (&settings);
		

		super (cast(sfSoundStreamGetDataCallback)&onGetData,cast(sfSoundStreamSeekCallback)&onSeek, cast(uint)settings.mChannels, settings.mFrequency, cast(void*)&userdata_);
	}
	
	~this() {
		if (super.status() != SoundStatus.Stopped)
			stop();
		
		if (file_ != null) {
			ModPlug_Unload(file_);
			file_ = null;
		}
		
		name_ = "";
		length_ = 0;
		
		destroy (buffer_);			
	}
	
	ModPlugFile* getModPlugFile() {
		return file_;
	}
	
	string getName () {
		return name_;
	}
	
	int getLength () {
		return length_;
	}
	
	int getModuleType () {
		return ModPlug_GetModuleType(file_);
	}
	
	string getSongComments () {
		auto comments = ModPlug_GetMessage(file_);
		if (comments == null)
			return "";
		
		return to!string(comments);	
	}
	
	int getCurrentSpeed () {
		return ModPlug_GetCurrentSpeed(file_);
	}
	
	int getCurrentTempo () {
		return ModPlug_GetCurrentTempo(file_);
	}
	
	int getCurrentPattern () {
		return ModPlug_GetCurrentPattern(file_);
	}
	
	int getCurrentRow () {
		return ModPlug_GetCurrentRow(file_);
	}
	
	int getPlayingChannels () {
		return ModPlug_GetPlayingChannels(file_);
	}

	@property {
		int currentOrder () {
			return ModPlug_GetCurrentOrder(file_);
		}
		
		void currentOrder (int order) {
			ModPlug_SeekOrder(file_, order);
		}
	}

	@property {
		uint masterVolume () {
			return ModPlug_GetMasterVolume(file_);
		}
		
		void masterVolume (uint volume) {
			ModPlug_SetMasterVolume (file_, volume);
		}
	}
	
	@property uint instrumentCount () {
		return ModPlug_NumInstruments(file_);
	}
	
	@property uint sampleCount () {
		return ModPlug_NumSamples(file_);
	}
	
	@property uint patternCount () {
		return ModPlug_NumPatterns(file_);
	}
	
	override @property uint channelCount () {
		return ModPlug_NumChannels(file_);
	}
	
	string getInstrumentName (uint index) {
		char[40] buf;
		
		ModPlug_InstrumentName(file_, index, buf.ptr);
		
		return to!string(buf);
	}
	
	string getSampleName (uint index) {
		char[40] buf;
		
		ModPlug_SampleName(file_, index, buf.ptr);
		
		return to!string(buf);
	}
	
	ModPlugNote* getPattern (int pattern, out uint numrows) {
		return ModPlug_GetPattern (file_, pattern, &numrows);
	}
	
	void initMixerCallback (ModPlugMixerProc proc) {
		ModPlug_InitMixerCallback (file_, proc);
	}
	
	void unloadMixerCallback () {
		ModPlug_UnloadMixerCallback(file_);
	}
	
	private:
	
	userdata_t userdata_;
	
	ModPlugFile* file_;
	string name_;
	int length_;
	
	short[] buffer_;	
}

extern (C) {
	sfBool onGetData (SoundStreamChunk* data, void* userdata) {
		userdata_t* our_data = cast(userdata_t*) userdata;
		
		int read = ModPlug_Read (our_data.our_file_, cast(void *)our_data.our_buffer_, BUFFERSIZE);
	
		if (read == 0)
			return false;
	
		data.sampleCount = cast(size_t)(read / 2);
		data.samples = our_data.our_buffer_;
	
		return true;	
	}
	void onSeek (sfTime timeOffset, void *userdata) {
		userdata_t* our_data = cast(userdata_t*) userdata;
		ModPlug_Seek(our_data.our_file_, cast(int)(sfTime_asMilliseconds(timeOffset)));
	}
}

struct userdata_t {
	ModPlugFile* our_file_;
	short* our_buffer_;
};

