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
 * $(U ContextSettings) allows to define several advanced settings of the OpenGL
 * context attached to a window.
 *
 * All these settings have no impact on the regular DSFML rendering
 * (graphics module) – except the anti-aliasing level, so you may need to use
 * this structure only if you're using SFML as a windowing system for custom
 * OpenGL rendering.
 *
 * The `depthBits` and `stencilBits` members define the number of bits per pixel
 * requested for the (respectively) depth and stencil buffers.
 *
 * antialiasingLevel represents the requested number of multisampling levels for
 * anti-aliasing.
 *
 * majorVersion and minorVersion define the version of the OpenGL context that
 * you want. Only versions greater or equal to 3.0 are relevant; versions lesser
 * than 3.0 are all handled the same way (i.e. you can use any version < 3.0 if
 * you don't want an OpenGL 3 context).
 *
 * When requesting a context with a version greater or equal to 3.2, you have
 * the option of specifying whether the context should follow the core or
 * compatibility profile of all newer (>= 3.2) OpenGL specifications. For
 * versions 3.0 and 3.1 there is only the core profile. By default a
 * compatibility context is created. You only need to specify the core flag if
 * you want a core profile context to use with your own OpenGL rendering.
 * Warning: The graphics module will not function if you request a core
 * profile context. Make sure the attributes are set to Default if you want to
 * use the graphics module.
 *
 * Linking with a debug SFML binary will cause a context to be requested with
 * additional debugging features enabled. Depending on the system, this might be
 * required for advanced OpenGL debugging. OpenGL debugging is disabled by
 * default.
 *
 * $(B Special Note for OS X:)
 * Apple only supports choosing between either a legacy context (OpenGL 2.1) or
 * a core context (OpenGL version depends on the operating system version but is
 * at least 3.2). Compatibility contexts are not supported. Further information
 * is available on the $(LINK2
 * https://developer.apple.com/opengl/capabilities/index.html,
 * OpenGL Capabilities Tables) page. OS X also currently does not support debug
 * contexts.
 *
 * Please note that these values are only a hint. No failure will be reported if
 * one or more of these values are not supported by the system; instead, SFML
 * will try to find the closest valid match. You can then retrieve the settings
 * that the window actually used to create its context, with
 * `Window.getSettings()`.
 */
module dsfml.window.contextsettings;

/**
 * Structure defining the settings of the OpenGL context attached to a window.
 */
struct ContextSettings
{
    /// Bits of the depth buffer.
    uint depthBits = 0;
    /// Bits of the stencil buffer.
    uint stencilBits = 0;
    /// Level of antialiasing.
    uint antialiasingLevel = 0;
    /// Level of antialiasing.
    uint majorVersion = 2;
    /// Minor number of the context version to create.
    uint minorVersion = 0;
}
