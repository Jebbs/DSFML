/*
 * DSFML - The Simple and Fast Multimedia Library for D
 *
 * Copyright (c) 2013 - 2018 Jeremy DeHaan (dehaan.jeremiah@gmail.com)
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
 *
 *
 * DSFML is based on SFML (Copyright Laurent Gomila)
 */

/**
 *
 * The interface and template are provided for convenience, on top of
 * $(TRANSFORM_LINK).
 *
 * $(TRANSFORM_LINK), as a low-level class, offers a great level of flexibility
 * but it is not always convenient to manage. Indeed, one can easily combine any
 * kind of operation, such as a translation followed by a rotation followed by a
 * scaling, but once the result transform is built, there's no way to go
 * backward and, let's say, change only the rotation without modifying the
 * translation and scaling.
 *
 * The entire transform must be recomputed, which means that you need to
 * retrieve the initial translation and scale factors as well, and combine them
 * the same way you did before updating the rotation. This is a tedious
 * operation, and it requires to store all the individual components of the
 * final transform.
 *
 * That's exactly what $(U Transformable) and $(U NormalTransformable) were
 * written for: they hides these variables and the composed transform behind an
 * easy to use interface. You can set or get any of the individual components
 * without worrying about the others. It also provides the composed transform
 * (as a $(TRANSFORM_LINK)), and keeps it up-to-date.
 *
 * In addition to the position, rotation and scale, $(U Transformable) provides
 * an "origin" component, which represents the local origin of the three other
 * components. Let's take an example with a 10x10 pixels sprite. By default, the
 * sprite is positioned/rotated/scaled relatively to its top-left corner,
 * because it is the local point (0, 0). But if we change the origin to be
 * (5, 5), the sprite will be positioned/rotated/scaled around its center
 * instead. And if we set the origin to (10, 10), it will be transformed around
 * its bottom-right corner.
 *
 * To keep $(U Transformable) and $(U NormalTransformable) simple, there's only
 * one origin for all the components. You cannot position the sprite relatively
 * to its top-left corner while rotating it around its center, for example. To
 * do such things, use $(TRANSFORM_LINK) directly.
 *
 * $(U Transformable) is meant to be used as a base for other classes. It is
 * often combined with $(DRAWABLE_LINK) -- that's what DSFML's sprites, texts
 * and shapes do.
 * ---
 * class MyEntity : Transformable, Drawable
 * {
 *     //generates the boilerplate code for Transformable
 *     mixin NormalTransformable;
 *
 *     void draw(RenderTarget target, RenderStates states) const
 *     {
 *         states.transform *= getTransform();
 *         target.draw(..., states);
 *     }
 * }
 *
 * auto entity = new MyEntity();
 * entity.position = Vector2f(10, 20);
 * entity.rotation = 45;
 * window.draw(entity);
 * ---
 *
 * $(PARA If you don't want to use the API directly (because you don't need all
 * the functions, or you have different naming conventions for example), you can
 * have a $(U TransformableMember) as a member variable.)
 * ---
 * class MyEntity
 * {
 *     this()
 *     {
 *         myTransform = new TransformableMember();
 *     }
 *
 *     void setPosition(MyVector v)
 *     {
 *         myTransform.setPosition(v.x, v.y);
 *     }
 *
 *     void draw(RenderTarget target, RenderStates states) const
 *     {
 *         states.transform *= myTransform.getTransform();
 *         target.draw(..., states);
 *     }
 *
 * private TransformableMember myTransform;
 * }
 * ---
 *
 * $(PARA A note on coordinates and undistorted rendering:
 * By default, DSFML (or more exactly, OpenGL) may interpolate drawable objects
 * such as sprites or texts when rendering. While this allows transitions like
 * slow movements or rotations to appear smoothly, it can lead to unwanted
 * results in some cases, for example blurred or distorted objects. In order to
 * render a $(DRAWABLE_LINK) object pixel-perfectly, make sure the involved
 * coordinates allow a 1:1 mapping of pixels in the window to texels (pixels in
 * the texture). More specifically, this means:)
 * $(UL
 * $(LI The object's position, origin and scale have no fractional part)
 * $(LI The object's and the view's rotation are a multiple of 90 degrees)
 * $(LI The view's center and size have no fractional part))
 *
 * See_Also:
 * $(TRANSFORM_LINK)
 */
module dsfml.graphics.transformable;

import dsfml.system.vector2;

//public import so that people don't have to worry about
//importing transform when they import transformable
public import dsfml.graphics.transform;

/**
 * Decomposed transform defined by a position, a rotation, and a scale.
 */
interface Transformable
{
    @property
    {
        /**
         * The local origin of the object.
         *
         * The origin of an object defines the center point for all
         * transformations (position, scale, ratation).
         *
         * The coordinates of this point must be relative to the top-left corner
         * of the object, and ignore all transformations (position, scale,
         * rotation).
         *
         * The default origin of a transformable object is (0, 0).
         */
        Vector2f origin(Vector2f newOrigin);

        /// ditto
        Vector2f origin() const;
    }

    @property
    {
        /// The position of the object. The default is (0, 0).
        Vector2f position(Vector2f newPosition);

        /// ditto
        Vector2f position() const;
    }

    @property
    {
        /// The orientation of the object, in degrees. The default is 0 degrees.
        float rotation(float newRotation);

        /// ditto
        float rotation() const;
    }

    @property
    {
        /// The scale factors of the object. The default is (1, 1).
        Vector2f scale(Vector2f newScale);

        /// ditto
        Vector2f scale() const;
    }

    /**
     * Get the inverse of the combined transform of the object.
     *
     * Returns: Inverse of the combined transformations applied to the object.
     */
    const(Transform) getTransform();

    /**
     * Get the combined transform of the object.
     *
     * Returns: Transform combining the position/rotation/scale/origin of the
     * object.
     */
    const(Transform) getInverseTransform();

    /**
     * Move the object by a given offset.
     *
     * This function adds to the current position of the object, unlike the
     * position property which overwrites it.
     *
     * Params:
     * 		offset	= The offset
     */
    void move(Vector2f offset);
}

/**
 * Mixin template that generates the boilerplate code for the $(U Transformable)
 * interface.
 *
 * This template is provided for convenience, so that you don't have to add the
 * properties and functions manually.
 */
mixin template NormalTransformable()
{
    private
    {
        // Origin of translation/rotation/scaling of the object
        Vector2f m_origin = Vector2f(0,0);
        // Position of the object in the 2D world
        Vector2f m_position = Vector2f(0,0);
        // Orientation of the object, in degrees
        float m_rotation = 0;
        // Scale of the object
        Vector2f m_scale = Vector2f(1,1);
        // Combined transformation of the object
        Transform m_transform;
        // Does the transform need to be recomputed?
        bool m_transformNeedUpdate;
        // Combined transformation of the object
        Transform m_inverseTransform;
        // Does the transform need to be recomputed?
        bool m_inverseTransformNeedUpdate;
    }

    @property
    {
        Vector2f origin(Vector2f newOrigin)
        {
            m_origin = newOrigin;
            m_transformNeedUpdate = true;
            m_inverseTransformNeedUpdate = true;
            return newOrigin;
        }

        Vector2f origin() const
        {
            return m_origin;
        }
    }

    @property
    {
        Vector2f position(Vector2f newPosition)
        {
            m_position = newPosition;
            m_transformNeedUpdate = true;
            m_inverseTransformNeedUpdate = true;
            return newPosition;
        }

        Vector2f position() const
        {
            return m_position;
        }
    }

    @property
    {
        import std.math: fmod;
        float rotation(float newRotation)
        {
            m_rotation = cast(float)fmod(newRotation, 360);
            if(m_rotation < 0)
            {
                m_rotation += 360;
            }
            m_transformNeedUpdate = true;
            m_inverseTransformNeedUpdate = true;
            return newRotation;
        }

        float rotation() const
        {
            return m_rotation;
        }
    }

    @property
    {
        Vector2f scale(Vector2f newScale)
        {
            m_scale = newScale;
            m_transformNeedUpdate = true;
            m_inverseTransformNeedUpdate = true;
            return newScale;
        }

        Vector2f scale() const
        {
            return m_scale;
        }
    }

    const(Transform) getInverseTransform()
    {
        if (m_inverseTransformNeedUpdate)
        {
            m_inverseTransform = getTransform().getInverse();
            m_inverseTransformNeedUpdate = false;
        }

        return m_inverseTransform;
    }

    const(Transform) getTransform()
    {
        import std.math: cos, sin;
        if (m_transformNeedUpdate)
        {
            float angle = -m_rotation * 3.141592654f / 180f;
            float cosine = cast(float)(cos(angle));
            float sine = cast(float)(sin(angle));
            float sxc = m_scale.x * cosine;
            float syc = m_scale.y * cosine;
            float sxs = m_scale.x * sine;
            float sys = m_scale.y * sine;
            float tx = -m_origin.x * sxc - m_origin.y * sys + m_position.x;
            float ty = m_origin.x * sxs - m_origin.y * syc + m_position.y;

            m_transform = Transform( sxc, sys, tx,
                                    -sxs, syc, ty,
                                    0f, 0f, 1f);
            m_transformNeedUpdate = false;
        }

        return m_transform;
    }

    void move(Vector2f offset)
    {
        position = position + offset;
    }
}

/**
 * Concrete class that implements the $(U Transformable) interface.
 *
 * This class is provided for convenience, so that a $(U Transformable) object
 * can be used as a member of a class instead of inheriting from
 * $(U Transformable).
 */
class TransformableMember: Transformable
{
    mixin NormalTransformable;
}
