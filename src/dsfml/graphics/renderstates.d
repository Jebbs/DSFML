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
 * There are four global states that can be applied to the drawn objects:
 * $(UL
 * $(LI the blend mode: how pixels of the object are blended with the
 * background)
 * $(LI the transform: how the object is positioned/rotated/scaled)
 * $(LI the texture: what image is mapped to the object)
 * $(LI the shader: what custom effect is applied to the object))
 *
 * High-level objects such as sprites or text force some of these states when
 * they are drawn. For example, a sprite will set its own texture, so that you
 * don't have to care about it when drawing the sprite.
 *
 * The transform is a special case: sprites, texts and shapes (and it's a good
 * idea to do it with your own drawable classes too) combine their transform
 * with the one that is passed in the RenderStates structure. So that you can
 * use a "global" transform on top of each object's transform.
 *
 * Most objects, especially high-level drawables, can be drawn directly without
 * defining render states explicitely – the default set of states is ok in most
 * cases.
 * ---
 * RenderWindow window;
 * Sprite sprite;
 *
 * ...
 *
 * window.draw(sprite);
 * ---
 *
 * $(PARA If you want to use a single specific render state, for example a
 * shader, you can construct a $(U RenderStates) object from it:)
 * ---
 * auto states = RenderStates(shader)
 * window.draw(sprite, states);
 *
 * //or
 * window.draw(sprite, RenderStates(shader));
 * ---
 *
 * $(PARA When you're inside the `draw` function of a drawable object (inherited
 * from $(DRAWABLE_LINK)), you can either pass the render states unmodified, or
 * change some of them. For example, a transformable object will combine the
 * current transform with its own transform. A sprite will set its texture.
 * Etc.)
 *
 * See_Also:
 * $(RENDERTARGET_LINK), $(DRAWABLE_LINK)
 */
module dsfml.graphics.renderstates;

import dsfml.graphics.blendmode;
import dsfml.graphics.transform;
import dsfml.graphics.texture;
import dsfml.graphics.shader;
import std.typecons:Rebindable;

/**
 * Define the states used for drawing to a RenderTarget.
 */
struct RenderStates
{
    /// The blending mode.
    BlendMode blendMode;
    /// The transform.
    Transform transform;
    private
    {
        Rebindable!(const(Texture)) m_texture;
        Rebindable!(const(Shader)) m_shader;
    }

    /**
     * Construct a default set of render states with a custom blend mode.
     *
     * Params:
     *	theBlendMode = Blend mode to use
     */
    this(BlendMode theBlendMode)
    {
        blendMode = theBlendMode;
        transform = Transform();

        m_texture = null;
        m_shader = null;

    }

    /**
     * Construct a default set of render states with a custom transform.
     *
     * Params:
     *	theTransform = Transform to use
     */
    this(Transform theTransform)
    {
        transform = theTransform;

        blendMode = BlendMode.Alpha;

        m_texture = null;
        m_shader = null;
    }

    /**
     * Construct a default set of render states with a custom texture
     *
     * Params:
     *	theTexture = Texture to use
     */
    this(const(Texture) theTexture)
    {
        m_texture = theTexture;

        blendMode = BlendMode.Alpha;

        transform = Transform();
        m_shader = null;
    }

    /**
     * Construct a default set of render states with a custom shader
     *
     * Params:
     * theShader = Shader to use
     */
    this(const(Shader) theShader)
    {
        m_shader = theShader;
    }

    /**
     * Construct a set of render states with all its attributes
     *
     * Params:
     *	theBlendMode = Blend mode to use
     *	theTransform = Transform to use
     *	theTexture   = Texture to use
     *	theShader    = Shader to use
     */
    this(BlendMode theBlendMode, Transform theTransform, const(Texture) theTexture, const(Shader) theShader)
    {
        blendMode = theBlendMode;
        transform = theTransform;
        m_texture = theTexture;
        m_shader = theShader;
    }

    @property
    {
        /// The shader to apply while rendering.
        const(Shader) shader(const(Shader) theShader)
        {
            m_shader = theShader;
            return theShader;
        }
        /// ditto
        const(Shader) shader()
        {
            return m_shader;
        }
    }

    @property
    {
        /// The texture to apply while rendering.
        const(Texture) texture(const(Texture) theTexture)
        {
            m_texture = theTexture;
            return theTexture;
        }
        /// ditto
        const(Texture) texture()
        {
            return m_texture;
        }
    }
}
