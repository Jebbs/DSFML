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
 * $(U Drawable) is a very simple base interface that allows objects of derived
 * classes to be drawn to a RenderTarget.
 *
 * All you have to do in your derived class is to override the draw virtual
 * function.
 *
 * Note that inheriting from $(DRAWABLE_LINK) is not mandatory, but it allows
 * this nice syntax `window.draw(object)` rather than `object.draw(window)`,
 * which is more consistent with other DSFML classes.
 *
 * Example:
 * ---
 * class MyDrawable : Drawable
 * {
 * public:
 *
 *     this()
 *     {
 *         m_sprite = Sprite();
 *         m_texture = Texture();
 *         m_vertices = VertexArray();
 *
 *         // additional setup
 *     }
 *    ...
 *
 *     void draw(RenderTarget target, RenderStates states) const
 *     {
 *         // You can draw other high-level objects
 *         target.draw(m_sprite, states);
 *
 *         // ... or use the low-level API
 *         states.texture = m_texture;
 *         target.draw(m_vertices, states);
 *
 *         // ... or draw with OpenGL directly
 *         glBegin(GL_QUADS);
 *         ...
 *         glEnd();
 *     }
 *
 * private:
 *     Sprite m_sprite;
 *     Texture m_texture;
 *     VertexArray m_vertices;
 * }
 * ---
 *
 * See_Also:
 * $(RENDERTARGET_LINK)
 */
module dsfml.graphics.drawable;

import dsfml.graphics.rendertarget;
import dsfml.graphics.renderstates;

/**
 * Interface for objects that can be drawn to a render target.
 */
interface Drawable
{
    /**
     * Draw the object to a render target.
     *
     * Params:
     *  		renderTarget =	Render target to draw to
     *  		renderStates =	Current render states
     */
    void draw(RenderTarget renderTarget, RenderStates renderStates);
}