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
 * $(U VertexArray) is a very simple wrapper around a dynamic array of vertices
 *and a primitives type.
 *
 * It inherits $(DRAWABLE_LINK), but unlike other drawables it is not
 * transformable.
 *
 * Example:
 * ---
 * VertexArray lines(PrimitiveType.LineStrip, 4);
 * lines[0].position = Vector2f(10, 0);
 * lines[1].position = Vector2f(20, 0);
 * lines[2].position = Vector2f(30, 5);
 * lines[3].position = Vector2f(40, 2);
 *
 * window.draw(lines);
 * ---
 *
 * See_Also:
 * $(VERTEX_LINK)
 */
module dsfml.graphics.vertexarray;

import dsfml.graphics.vertex;
import dsfml.graphics.primitivetype;
import dsfml.graphics.rect;
import dsfml.graphics.drawable;
import dsfml.graphics.rendertarget;
import dsfml.graphics.renderstates;

import dsfml.system.vector2;

/**
 * Define a set of one or more 2D primitives.
 */
class VertexArray : Drawable
{
    /**
     * The type of primitive to draw.
     *
     * Can be any of the following:
     * - Points
     * - Lines
     * - Triangles
     * - Quads
     *
     * The default primitive type is Points.
     */
    PrimitiveType primitiveType;
    private Vertex[] Vertices;

    /**
     * Default constructor
     *
     * Creates an empty vertex array.
     */
    this()
    {
    }

    /**
     * Construct the vertex array with a type and an initial number of vertices
     *
     * Params:
     *  type        = Type of primitives
     *  vertexCount = Initial number of vertices in the array
     */
    this(PrimitiveType type, uint vertexCount = 0)
    {
        primitiveType = type;
        Vertices = new Vertex[vertexCount];
    }

    private this(PrimitiveType type, Vertex[] vertices)
    {
        primitiveType = type;
        Vertices = vertices;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
    }

    /**
     * Compute the bounding rectangle of the vertex array.
     *
     * This function returns the axis-aligned rectangle that contains all the
     * vertices of the array.
     *
     * Returns: Bounding rectangle of the vertex array.
     */
    FloatRect getBounds() const
    {
        if (Vertices.length>0)
        {
            float left = Vertices[0].position.x;
            float top = Vertices[0].position.y;
            float right = Vertices[0].position.x;
            float bottom = Vertices[0].position.y;

            for (size_t i = 1; i < Vertices.length; ++i)
            {
                Vector2f position = Vertices[i].position;

                // Update left and right
                if (position.x < left)
                    left = position.x;
                else if (position.x > right)
                    right = position.x;

                // Update top and bottom
                if (position.y < top)
                    top = position.y;
                else if (position.y > bottom)
                    bottom = position.y;
            }

            return FloatRect(left, top, right - left, bottom - top);
        }
        else
        {
            return FloatRect(0,0,0,0);
        }
    }

    /**
     * Return the vertex count.
     *
     * Returns: Number of vertices in the array
     */
    uint getVertexCount() const
    {
        import std.algorithm;
        return cast(uint)min(uint.max, Vertices.length);
    }

    /**
     * Add a vertex to the array.
     *
     * Params:
     * 		newVertex = Vertex to add.
     */
    void append(Vertex newVertex)
    {
        Vertices ~= newVertex;
    }

    /**
     * Clear the vertex array.
     *
     * This function removes all the vertices from the array. It doesn't
     * deallocate the corresponding memory, so that adding new vertices after
     * clearing doesn't involve reallocating all the memory.
     */
    void clear()
    {
        Vertices.length = 0;
    }

    /**
     * Draw the object to a render target.
     *
     * Params:
     *  	renderTarget = Render target to draw to
     *  	renderStates = Current render states
     */
    override void draw(RenderTarget renderTarget, RenderStates renderStates)
    {
        if(Vertices.length != 0)
        {
            renderTarget.draw(Vertices, primitiveType,renderStates);
        }
    }

    /**
     * Resize the vertex array.
     *
     * If vertexCount is greater than the current size, the previous vertices
     * are kept and new (default-constructed) vertices are added. If vertexCount
     * is less than the current size, existing vertices are removed from the
     * array.
     *
     * Params:
     * 		vertexCount	= New size of the array (number of vertices).
     */
    void resize(uint vertexCount)
    {
        Vertices.length = vertexCount;
    }

    /**
     * Get a read-write access to a vertex by its index
     *
     * This function doesn't check index, it must be in range
     * [0, getVertexCount() - 1]. The behavior is undefined otherwise.
     *
     * Params:
     *  index = Index of the vertex to get
     *
     * Returns: Reference to the index-th vertex.
     */
    ref Vertex opIndex(size_t index)
    {
        return Vertices[index];
    }

    //TODO: const ref Vertex opIndex(size_t) const, perhaps?
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;
        import dsfml.graphics.texture;
        import dsfml.graphics.rendertexture;
        import dsfml.graphics.color;

        writeln("Unit test for VertexArray");

        auto texture = new Texture();

        assert(texture.loadFromFile("res/TestImage.png"));

        auto dimensions = FloatRect(0,0,texture.getSize().x,texture.getSize().y);

        auto vertexArray = new VertexArray(PrimitiveType.Quads, 0);

        //Creates a vertex array at position (0,0) the width and height of the loaded texture
        vertexArray.append(Vertex(Vector2f(dimensions.left,dimensions.top), Color.Blue, Vector2f(dimensions.left,dimensions.top)));
        vertexArray.append(Vertex(Vector2f(dimensions.left,dimensions.height), Color.Blue, Vector2f(dimensions.left,dimensions.height)));
        vertexArray.append(Vertex(Vector2f(dimensions.width,dimensions.height), Color.Blue, Vector2f(dimensions.width,dimensions.height)));
        vertexArray.append(Vertex(Vector2f(dimensions.width,dimensions.top), Color.Blue, Vector2f(dimensions.width,dimensions.top)));

        auto renderStates = RenderStates(texture);

        auto renderTexture = new RenderTexture();

        renderTexture.create(100,100);

        renderTexture.clear();

        //draw the VertexArray with the texture we loaded
        renderTexture.draw(vertexArray, renderStates);

        renderTexture.display();

        writeln();
    }
}
