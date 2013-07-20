module dsfml.window.mouse;

import dsfml.system.vector2;
import dsfml.window.window;

class Mouse
{
	enum Button
	{
		Left, /// The left mouse button
		Right, /// The right mouse button
		Middle, /// The middle (wheel) mouse button
		XButton1, /// The first extra mouse button
		XButton2, /// The second extra mouse button
		
		Count /// Keep last -- the total number of mouse buttons
		
	}
	
	static bool isButtonPressed(Button button)
	{
		return (sfMouse_isButtonPressed(button) );//== sfTrue) ? true : false;
	}
	
	static Vector2i getMousePosition()
	{
		Vector2i temp;
		sfMouse_getPosition(null,&temp.x, &temp.y);

		return temp;
	}	

	static Vector2i getMousePosition(const(Window) relativeTo)
	{
		Vector2i temp;
		sfMouse_getPosition(relativeTo.sfPtr,&temp.x, &temp.y);
		return temp;
	}
	
	static void setPosition(Vector2i position)
	{
		sfMouse_setPosition(position.x, position.y,null);
	}
	
	static void setPosition(Vector2i position, const(Window) relativeTo)
	{
		sfMouse_setPosition(position.x, position.y, relativeTo.sfPtr);
	}
}

private extern(C)
{


	//Check if a mouse button is pressed
	bool sfMouse_isButtonPressed(int button);
	
	
	//Get the current position of the mouse
	void sfMouse_getPosition(const(sfWindow)* relativeTo, int* x, int* y);
	
	
	//Set the current position of the mouse
	void sfMouse_setPosition(int x, int y, const(sfWindow)* relativeTo);
}