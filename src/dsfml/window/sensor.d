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
 * $(U Sensor) provides an interface to the state of the various sensors that a
 * device provides. It only contains static functions, so it's not meant to be
 * instantiated.
 *
 * This class allows users to query the sensors values at any time and directly,
 * without having to deal with a window and its events. Compared to the
 * SensorChanged event, Sensor can retrieve the state of a sensor at any time
 * (you don't need to store and update its current value on your side).
 *
 * Depending on the OS and hardware of the device (phone, tablet, ...), some
 * sensor types may not be available. You should always check the availability
 * of a sensor before trying to read it, with the `Sensor.isAvailable` function.
 *
 * You may wonder why some sensor types look so similar, for example
 * Accelerometer and Gravity / UserAcceleration. The first one is the raw
 * measurement of the acceleration, and takes into account both the earth
 * gravity and the user movement. The others are more precise: they provide
 * these components separately, which is usually more useful. In fact they are
 * not direct sensors, they are computed internally based on the raw
 * acceleration and other sensors. This is exactly the same for Gyroscope vs
 * Orientation.
 *
 * Because sensors consume a non-negligible amount of current, they are all
 * disabled by default. You must call `Sensor.setEnabled` for each sensor in
 * which you are interested.
 *
 * Example:
 * ---
 * if (Sensor.isAvailable(Sensor.Type.Gravity))
 * {
 *     // gravity sensor is available
 * }
 *
 * // enable the gravity sensor
 * Sensor.setEnabled(Sensor.Type.Gravity, true);
 *
 * // get the current value of gravity
 * Vector3f gravity = Sensor.getValue(Sensor.Type.Gravity);
 * ---
 */
module dsfml.window.sensor;

import dsfml.system.vector3;

/**
 * Give access to the real-time state of the sensors.
 */
final abstract class Sensor
{
    /// Sensor type
    enum Type
    {
        /// Measures the raw acceleration (m/s²)
        Accelerometer,
        /// Measures the raw rotation rates (°/s)
        Gyroscope,
        /// Measures the ambient magnetic field (micro-teslas)
        Magnetometer,
        /**
         * Measures the direction and intensity of gravity, independent of
         * device acceleration (m/s²)
         */
        Gravity,
        /**
         * Measures the direction and intensity of device cceleration,
         * independent of the gravity (m/s²)
         */
        UserAcceleration,
        /// Measures the absolute 3D orientation (°)
        Orientation,
        /// Keep last - the total number of sensor types
        Count
    }

    /**
    * Check if a sensor is available on the underlying platform.
    *
    * Params:
    *	sensor = Sensor to check
    *
    * Returns: True if the sensor is available, false otherwise.
    */
    static bool isAvailable (Type sensor)
    {
        return sfSensor_isAvailable(sensor);
    }

    /**
    * Enable or disable a sensor.
    *
    * All sensors are disabled by default, to avoid consuming too much battery
    * power. Once a sensor is enabled, it starts sending events of the
    * corresponding type.
    *
    * This function does nothing if the sensor is unavailable.
    *
    * Params:
    *   sensor = Sensor to enable
    *   enabled = True to enable, false to disable
    */
    static void setEnabled (Type sensor, bool enabled)
    {
        sfSensor_setEnabled(sensor, enabled);
    }

    /**
    * Get the current sensor value.
    *
    * Params:
    *   sensor = Sensor to read
    *
    * Returns: The current sensor value.
    */
    static Vector3f getValue (Type sensor)
    {
        Vector3f getValue;
        sfSensor_getValue(sensor, &getValue.x, &getValue.y, &getValue.z);

        return getValue;
    }
}

private extern(C)
{

    //Check if a sensor is available
    bool sfSensor_isAvailable (int sensor);

    //Enable or disable a given sensor
    void sfSensor_setEnabled (int sensor, bool enabled);

    //Set the current value of teh sensor
    void sfSensor_getValue (int sensor, float* x, float* y, float* z);
}
