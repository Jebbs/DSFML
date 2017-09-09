/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2017 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * In no event will the authors be held liable for any damages arising from the
 * use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not claim
 * that you wrote the original software. If you use this software in a product,
 * an acknowledgment in the product documentation would be appreciated but is
 * not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source distribution
 */

/**
 * Touch provides an interface to the state of the touches.
 *
 * It only contains static functions, so it's not meant to be instantiated.
 *
 * This class allows users to query the touches state at any time and directly,
 * without having to deal with a window and its events. Compared to the
 * `TouchBegan`, `TouchMoved` and `TouchEnded` events, Touch can retrieve the
 * state of  the touches at any time (you don't need to store and update a
 * boolean on your side in order to know if a touch is down), and you always get
 * the real state of the touches, even if they happen when your window is out of
 * focus and no event is triggered.
 *
 * The `getPosition` function can be used to retrieve the current position of a
 * touch. There are two versions: one that operates in global coordinates
 * (relative to the desktop) and one that operates in window coordinates
 * (relative to a specific window).
 *
 * Touches are identified by an index (the "finger"), so that in multi-touch
 * events, individual touches can be tracked correctly. As long as a finger
 * touches the screen, it will keep the same index even if other fingers start
 * or stop touching the screen in the meantime. As a consequence, active touch
 * indices may not always be sequential (i.e. touch number 0 may be released
 * while touch number 1 is still down).
 *
 * Example:
 * ---
 * if (Touch.isDown(0))
 * {
 *     // touch 0 is down
 * }
 *
 * // get global position of touch 1
 * Vector2i globalPos = Touch.getPosition(1);
 *
 * // get position of touch 1 relative to a window
 * Vector2i relativePos = Touch.getPosition(1, window);
 * ---
 *
 * See_Also:
 * $(JOYSTICK_LINK), $(KEYBOARD_LINK), $(MOUSE_LINK)
 */
module dsfml.window.touch;

import dsfml.system.vector2;
import dsfml.window.window;

/**
 * Give access to the real-time state of the touches.
 */
final abstract class Touch
{
    /**
    * Check if a touch event is currently down.
    *
    * Params:
    *	finger = Finger index
    *
    * Returns: true if finger is currently touching the screen, false otherwise.
    */
    static bool isDown (uint finger)
    {
        return sfTouch_isDown (finger);
    }

    /**
    * Get the current position of a touch in desktop coordinates.
    *
    * This function returns the current touch position in global (desktop)
    * coordinates.
    *
    * Params:
    *	finger = Finger index
    *
    * Returns: Current position of finger, or undefined if it's not down.
    */
    static Vector2i getPosition (uint finger)
    {
        Vector2i getPosition;

        sfTouch_getPosition(finger, null, &getPosition.x, &getPosition.y);

        return getPosition;
    }

    /**
    * Get the current position of a touch in window coordinates.
    *
    * This function returns the current touch position in relative (window)
    * coordinates.
    *
    * Params:
    *	finger = Finger index
    *
    * Returns:
    *    Current position of finger, or undefined if it's not down
    */
    static Vector2i getPosition (uint finger, const(Window) relativeTo)
    {
        Vector2i getPosition;

        sfTouch_getPosition(finger, relativeTo.sfPtr, &getPosition.x, &getPosition.y);

        return getPosition;
    }
}

private extern(C)
{

    //Check if a touch event is currently down
    bool sfTouch_isDown (uint finger);

    //Get the current position of a given touch
    void sfTouch_getPosition(uint finger, const(sfWindow)* relativeTo, int* x, int* y);
}
