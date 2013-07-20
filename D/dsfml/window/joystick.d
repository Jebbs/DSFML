module dsfml.window.joystick;

class Joystick
{
	enum
	{
		JoystickCount = 8,
		JoystickButtonCount = 32,
		JoystickAxisCount = 8
	}
	
	enum Axis
	{
		X,
		Y,
		Z,
		R,
		U,
		V,
		PovX,
		PovY
	}
	
	static bool isConnected(uint joystick)
	{
		return (sfJoystick_isConnected(joystick));// == sfTrue)?true:false;
	}
	
	static uint getButtonCount(uint joystick)
	{
		return sfJoystick_getButtonCount(joystick);
	}
	
	static void update()
	{
		sfJoystick_update();
	}
	
	static bool hasAxis(uint joystick, Axis axis)
	{
		return (sfJoystick_hasAxis(joystick, axis));
	}
	
	static float getAxisPosition(uint joystick, Axis axis)
	{
		return sfJoystick_getAxisPosition(joystick, axis);
	}
	static bool isButtonPressed(uint joystick, uint button)
	{
		return sfJoystick_isButtonPressed(joystick, button);
	}
	
}

private extern(C):
//Check if a joystick is connected
bool sfJoystick_isConnected(uint joystick);


//Return the number of buttons supported by a joystick
uint sfJoystick_getButtonCount(uint joystick);


//Check if a joystick supports a given axis
bool sfJoystick_hasAxis(uint joystick, int axis);


//Check if a joystick button is pressed
bool sfJoystick_isButtonPressed(uint joystick, uint button);


//Get the current position of a joystick axis
float sfJoystick_getAxisPosition(uint joystick, int axis);


//Update the states of all joysticks
void sfJoystick_update();
