module dsfml.audio.listener;

import dsfml.system.vector3;

final abstract class Listener
{
	@property
	{
		static void GlobalVolume(float volume)
		{
			sfListener_setGlobalVolume(volume);
		}
		static float GlobalVolume()
		{
			return sfListener_getGlobalVolume();
		}
		
	}
	
	@property
	{
		static void Position(Vector3f position)
		{
			sfListener_setPosition(position.x, position.y, position.z);
		}
		static Vector3f Position()
		{
			Vector3f temp;

			sfListener_getPosition(&temp.x, &temp.y, &temp.z);

			return temp;
		}
	}
	
	@property
	{
		static void Direction(Vector3f orientation)
		{
			sfListener_setDirection(orientation.x, orientation.y, orientation.z);
		}
		static Vector3f Direction()
		{
			Vector3f temp;
			
			sfListener_getDirection(&temp.x, &temp.y, &temp.z);
			
			return temp;
		}
	}
}

private extern(C):

void sfListener_setGlobalVolume(float volume);

float sfListener_getGlobalVolume();

void sfListener_setPosition(float x, float y, float z);

void sfListener_getPosition(float* x, float* y, float* z);

void sfListener_setDirection(float x, float y, float z);

void sfListener_getDirection(float* x, float* y, float* z);

