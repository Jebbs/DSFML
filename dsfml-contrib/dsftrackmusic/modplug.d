module dsftrackmusic.modplug;

import core.stdc.config;

extern (C):

alias void function (int*, c_ulong, c_ulong) ModPlugMixerProc;

enum ModPlug_Flags
{
	MODPLUG_ENABLE_OVERSAMPLING = 1,
	MODPLUG_ENABLE_NOISE_REDUCTION = 2,
	MODPLUG_ENABLE_REVERB = 4,
	MODPLUG_ENABLE_MEGABASS = 8,
	MODPLUG_ENABLE_SURROUND = 16
}

enum ModPlug_ResamplingMode
{
	MODPLUG_RESAMPLE_NEAREST = 0,
	MODPLUG_RESAMPLE_LINEAR = 1,
	MODPLUG_RESAMPLE_SPLINE = 2,
	MODPLUG_RESAMPLE_FIR = 3
}


struct ModPlugNote
{
	ubyte Note;
	ubyte Instrument;
	ubyte VolumeEffect;
	ubyte Effect;
	ubyte Volume;
	ubyte Parameter;
}

struct ModPlug_Settings
{
	int mFlags;
	int mChannels;
	int mBits;
	int mFrequency;
	int mResamplingMode;
	int mStereoSeparation;
	int mMaxMixChannels;
	int mReverbDepth;
	int mReverbDelay;
	int mBassAmount;
	int mBassRange;
	int mSurroundDepth;
	int mSurroundDelay;
	int mLoopCount;
}

package {

struct ModPlugFile;

ModPlugFile* ModPlug_Load (const(void)* data, int size);
void ModPlug_Unload (ModPlugFile* file);
int ModPlug_Read (ModPlugFile* file, void* buffer, int size);
const(char)* ModPlug_GetName (ModPlugFile* file);
int ModPlug_GetLength (ModPlugFile* file);
void ModPlug_Seek (ModPlugFile* file, int millisecond);
void ModPlug_GetSettings (ModPlug_Settings* settings);
void ModPlug_SetSettings (const(ModPlug_Settings)* settings);
uint ModPlug_GetMasterVolume (ModPlugFile* file);
void ModPlug_SetMasterVolume (ModPlugFile* file, uint cvol);
int ModPlug_GetCurrentSpeed (ModPlugFile* file);
int ModPlug_GetCurrentTempo (ModPlugFile* file);
int ModPlug_GetCurrentOrder (ModPlugFile* file);
int ModPlug_GetCurrentPattern (ModPlugFile* file);
int ModPlug_GetCurrentRow (ModPlugFile* file);
int ModPlug_GetPlayingChannels (ModPlugFile* file);
void ModPlug_SeekOrder (ModPlugFile* file, int order);
int ModPlug_GetModuleType (ModPlugFile* file);
char* ModPlug_GetMessage (ModPlugFile* file);
char ModPlug_ExportS3M (ModPlugFile* file, const(char)* filepath);
char ModPlug_ExportXM (ModPlugFile* file, const(char)* filepath);
char ModPlug_ExportMOD (ModPlugFile* file, const(char)* filepath);
char ModPlug_ExportIT (ModPlugFile* file, const(char)* filepath);
uint ModPlug_NumInstruments (ModPlugFile* file);
uint ModPlug_NumSamples (ModPlugFile* file);
uint ModPlug_NumPatterns (ModPlugFile* file);
uint ModPlug_NumChannels (ModPlugFile* file);
uint ModPlug_SampleName (ModPlugFile* file, uint qual, char* buff);
uint ModPlug_InstrumentName (ModPlugFile* file, uint qual, char* buff);
ModPlugNote* ModPlug_GetPattern (ModPlugFile* file, int pattern, uint* numrows);
void ModPlug_InitMixerCallback (ModPlugFile* file, ModPlugMixerProc proc);
void ModPlug_UnloadMixerCallback (ModPlugFile* file);
}