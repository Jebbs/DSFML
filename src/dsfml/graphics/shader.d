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
 * Shaders are programs written using a specific language, executed directly by
 * the graphics card and allowing one to apply real-time operations to the
 * rendered entities.
 *
 * There are three kinds of shaders:
 * $(UL
 * $(LI Vertex shaders, that process vertices)
 * $(LI Geometry shaders, that process primitives)
 * $(LI Fragment (pixel) shaders, that process pixels))
 *
 * $(PARA
 * A $(U Shader) can be composed of either a vertex shader alone, a geometry
 * shader alone, a fragment shader alone, or any combination of them. (see the
 * variants of the load functions).
 *
 * Shaders are written in GLSL, which is a C-like language dedicated to OpenGL
 * shaders. You'll probably need to learn its basics before writing your own
 * shaders for DSFML.
 *
 * Like any D/C/C++ program, a GLSL shader has its own variables called uniforms
 * that you can set from your D application. $(U Shader) handles different types
 * of uniforms:)
 * $(UL
 * $(LI scalars: float, int, bool)
 * $(LI vectors (2, 3 or 4 components))
 * $(LI matrices (3x3 or 4x4))
 * $(LI samplers (textures)))
 *
 * $(PARA Some DSFML-specific types can be converted:)
*  $(UL
 * $(LI $(COLOR_LINK) as a 4D vector (`vec4`))
 * $(LI $(TRANSFORM_LINK) as matrices (`mat3` or `mat4`)))
 *
 * $(PARA Every uniform variable in a shader can be set through one of the
 * `setUniform()` or `setUniformArray()` overloads. For example, if you have a
 * shader with the following uniforms:)
 * ---
 * uniform float offset;
 * uniform vec3 point;
 * uniform vec4 color;
 * uniform mat4 matrix;
 * uniform sampler2D overlay;
 * uniform sampler2D current;
 * ---
 *
 * $(PARA You can set their values from D code as follows, using the types
 * defined in the `dsfml.graphics.glsl` module:)
 * ---
 * shader.setUniform("offset", 2.f);
 * shader.setUniform("point", Vector3f(0.5f, 0.8f, 0.3f));
 * shader.setUniform("color", Vec4(color));
 * shader.setUniform("matrix", Mat4(transform));
 * shader.setUniform("overlay", texture);
 * shader.setUniform("current", Shader.CurrentTexture);
 * ---
 *
 * $(PARA The old `setParameter()` overloads are deprecated and will be removed
 * in a future version. You should use their `setUniform()` equivalents instead.
 *
 * It is also worth noting that DSFML supports index overloads for
 * setting uniforms:)
 * ---
 * shader["offset"] = 2.f;
 * shader["point"] = Vector3f(0.5f, 0.8f, 0.3f);
 * shader["color"] = Vec4(color);
 * shader["matrix"] = Mat4(transform);
 * shader["overlay"] = texture;
 * shader["current"] = Shader.CurrentTexture;
 * ---
 *
 * $(PARA The special `Shader.CurrentTexture` argument maps the given
 * `sampler2D` uniform to the current texture of the object being drawn (which
 * cannot be known in advance).
 *
 * To apply a shader to a drawable, you must pass it as part of an additional
 * parameter to the `Window.draw()` function:)
 * ---
 * RenderStates states;
 * states.shader = shader;
 * window.draw(sprite, states);
 * ---
 *
 * $(PARA In the code above we pass a reference to the shader, because it may be
 * null (which means "no shader").
 *
 * Shaders can be used on any drawable, but some combinations are not
 * interesting. For example, using a vertex shader on a $(SPRITE_LINK) is
 * limited because there are only 4 vertices, the sprite would have to be
 * subdivided in order to apply wave effects.
 * Another bad example is a fragment shader with $(TEXT_LINK): the texture of
 * the text is not the actual text that you see on screen, it is a big texture
 * containing all the characters of the font in an arbitrary order; thus,
 * texture lookups on pixels other than the current one may not give you the
 * expected result.
 *
 * Shaders can also be used to apply global post-effects to the current contents
 * of the target. This can be done in two different ways:)
 * $(UL
 * $(LI draw everything to a $(RENDERTEXTURE_LINK), then draw it to the main
 *        target using the shader)
 * $(LI draw everything directly to the main target, then use `Texture.update`
 *        to copy its contents to a texture and draw it to the main target using
 *        the shader))
 *
 * $(PARA The first technique is more optimized because it doesn't involve
 * retrieving the target's pixels to system memory, but the second one doesn't
 * impact the rendering process and can be easily inserted anywhere without
 * impacting all the code.
 *
 * Like $(TEXTURE_LINK) that can be used as a raw OpenGL texture, $(U Shader)
 * can also be used directly as a raw shader for custom OpenGL geometry.)
 * ---
 * Shader.bind(shader);
 * ... render OpenGL geometry ...
 * Shader.bind(null);
 * ---
 *
 * See_Also:
 * $(GLSL_LINK)
 */
module dsfml.graphics.shader;

import dsfml.graphics.texture;
import dsfml.graphics.transform;
import dsfml.graphics.color;
import dsfml.graphics.glsl;

import dsfml.system.inputstream;
import dsfml.system.vector2;
import dsfml.system.vector3;
import dsfml.system.err;


/**
 * Shader class (vertex and fragment).
 */
class Shader
{
    /// Types of shaders.
    enum Type
    {
        Vertex,  /// Vertex shader
        Geometry,/// Geometry shader
        Fragment /// Fragment (pixel) shader.
    }

    package sfShader* sfPtr;

    /**
     * Special type/value that can be passed to `setParameter`, and that
     * represents the texture of the object being drawn.
     */
    struct CurrentTextureType {}
    /// ditto
    static CurrentTextureType CurrentTexture;

    /// Default constructor.
    this()
    {
        //creates an empty shader
        sfPtr=sfShader_construct();
    }

    package this(sfShader* shader)
    {
        sfPtr = shader;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfShader_destroy(sfPtr);
    }

    /**
     * Load either the vertex, geometry or fragment shader from a file.
     *
     * This function loads a single shader, either vertex, geometry or fragment,
     * identified by the second argument. The source must be a text file
     * containing a valid shader in GLSL language. GLSL is a C-like language
     * dedicated to OpenGL shaders; you'll probably need to read a good
     * documentation for it before writing your own shaders.
     *
     * Params:
     * 		filename	= Path of the vertex or fragment shader file to load
     * 		type		= Type of shader (vertex or fragment)
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromFile(const(char)[] filename, Type type)
    {
        import dsfml.system.string;

        bool ret;

        if(type == Type.Vertex)
        {
            ret = sfShader_loadFromFile(sfPtr, filename.ptr, filename.length, null, 0, null, 0);
        }
        else if(type == Type.Geometry)
        {
            ret = sfShader_loadFromFile(sfPtr, null, 0 , filename.ptr, filename.length, null, 0);
        }
        else
        {
            ret = sfShader_loadFromFile(sfPtr, null, 0 , null, 0, filename.ptr, filename.length);
        }

        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load both the vertex and fragment shaders from files.
     *
     * This function loads both the vertex and the fragment shaders. If one of
     * them fails to load, the shader is left empty (the valid shader is
     * unloaded). The sources must be text files containing valid shaders in
     * GLSL language. GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it before writing
     * your own shaders.
     *
     * Params:
     * 		vertexShaderFilename	= Path of the vertex shader file to load
     * 		fragmentShaderFilename	= Path of the fragment shader file to load
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromFile(const(char)[] vertexShaderFilename, const(char)[] fragmentShaderFilename)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromFile(sfPtr, vertexShaderFilename.ptr, vertexShaderFilename.length,
                                         fragmentShaderFilename.ptr, fragmentShaderFilename.length);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load the vertex, geometry and fragment shaders from files.
     *
     * This function loads the vertex, geometry and the fragment shaders. If one of
     * them fails to load, the shader is left empty (the valid shader is
     * unloaded). The sources must be text files containing valid shaders in
     * GLSL language. GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it before writing
     * your own shaders.
     *
     * Params:
     * 		vertexShaderFilename	= Path of the vertex shader file to load
     * 		geometryShaderFilename	= Path of the geometry shader file to load
     * 		fragmentShaderFilename	= Path of the fragment shader file to load
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromFile(const(char)[] vertexShaderFilename, const(char)[] geometryShaderFilename, const(char)[] fragmentShaderFilename)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromFile(sfPtr, vertexShaderFilename.ptr, vertexShaderFilename.length,
                                         geometryShaderFilename.ptr, geometryShaderFilename.length,
                                         fragmentShaderFilename.ptr, fragmentShaderFilename.length);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load either the vertex, geometry or fragment shader from a source code in memory.
     *
     * This function loads a single shader, either vertex, geometry or fragment,
     * identified by the second argument. The source code must be a valid shader
     * in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it before writing
     * your own shaders.
     *
     * Params:
     * 		shader	= String containing the source code of the shader
     * 		type	= Type of shader (vertex or fragment)
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromMemory(const(char)[] shader, Type type)
    {
        import dsfml.system.string;

        bool ret;

        if(type == Type.Vertex)
        {
            ret = sfShader_loadFromMemory(sfPtr, shader.ptr, shader.length, null, 0, null, 0);
        }
        else if(type == Type.Geometry)
        {
            ret = sfShader_loadFromMemory(sfPtr, null, 0 , shader.ptr, shader.length, null, 0 );
        }
        else
        {
            ret = sfShader_loadFromMemory(sfPtr, null, 0 , null, 0, shader.ptr, shader.length );
        }
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }
        return ret;
    }

    /**
     * Load both the vertex and fragment shaders from source codes in memory.
     *
     * This function loads both the vertex and the fragment shaders. If one of
     * them fails to load, the shader is left empty (the valid shader is
     * unloaded). The sources must be valid shaders in GLSL language. GLSL is a
     * C-like language dedicated to OpenGL shaders; you'll probably need to read
     * a good documentation for it before writing your own shaders.
     *
     * Params:
     * 	vertexShader   = String containing the source code of the vertex shader
     * 	fragmentShader = String containing the source code of the fragment
                         shader
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromMemory(const(char)[] vertexShader, const(char)[] fragmentShader)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromMemory(sfPtr, vertexShader.ptr, vertexShader.length , fragmentShader.ptr, fragmentShader.length);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load the vertex, geometry and fragment shaders from source codes in memory.
     *
     * This function loads the vertex, geometry and the fragment shaders. If one of
     * them fails to load, the shader is left empty (the valid shader is
     * unloaded). The sources must be valid shaders in GLSL language. GLSL is a
     * C-like language dedicated to OpenGL shaders; you'll probably need to read
     * a good documentation for it before writing your own shaders.
     *
     * Params:
     * 	vertexShader   = String containing the source code of the vertex shader
     * 	geometryShader = String containing the source code of the geometry shader
     * 	fragmentShader = String containing the source code of the fragment
                         shader
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromMemory(const(char)[] vertexShader, const(char)[] geometryShader, const(char)[] fragmentShader)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromMemory(sfPtr, vertexShader.ptr, vertexShader.length,
                                           geometryShader.ptr, geometryShader.length,
                                           fragmentShader.ptr, fragmentShader.length);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }
    /**
     * Load either the vertex, geometry or fragment shader from a custom stream.
     *
     * This function loads a single shader, either vertex, geometry or fragment,
     * identified by the second argument. The source code must be a valid shader
     * in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it before writing
     * your own shaders.
     *
     * Params:
     * 		stream	= Source stream to read from
     * 		type	= Type of shader (Vertex, Geometry or Fragment)
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream stream, Type type)
    {
        import dsfml.system.string;

        bool ret;

        if(type == Type.Vertex)
        {
            ret = sfShader_loadFromStream(sfPtr, new shaderStream(stream), null, null);
        }
        else if(type == Type.Geometry)
        {
            ret = sfShader_loadFromStream(sfPtr, null, new shaderStream(stream), null);
        }
        else
        {
            ret = sfShader_loadFromStream(sfPtr, null, null, new shaderStream(stream));
        }
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load both the vertex and fragment shaders from custom streams.
     *
     * This function loads a single shader, either vertex or fragment,
     * identified by the second argument. The source code must be a valid shader
     * in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it before writing
     * your own shaders.
     *
     * Params:
     * 	vertexShaderStream	 = Source stream to read the vertex shader from
     * 	fragmentShaderStream = Source stream to read the fragment shader from
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream vertexShaderStream, InputStream fragmentShaderStream)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromStream(sfPtr, new shaderStream(vertexShaderStream),
                                           new shaderStream(fragmentShaderStream));
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }
        return ret;
    }

    /**
     * Load the vertex, geometry and fragment shaders from custom streams.
     *
     * This function loads a single shader, either vertex, geometry or fragment,
     * identified by the second argument. The source code must be a valid shader
     * in GLSL language. GLSL is a C-like language dedicated to OpenGL shaders;
     * you'll probably need to read a good documentation for it before writing
     * your own shaders.
     *
     * Params:
     * 	vertexShaderStream	 = Source stream to read the vertex shader from
     * 	fragmentShaderStream = Source stream to read the fragment shader from
     *
     * Returns: true if loading succeeded, false if it failed.
     */
    bool loadFromStream(InputStream vertexShaderStream, InputStream geometryShaderStream, InputStream fragmentShaderStream)
    {
        import dsfml.system.string;

        bool ret = sfShader_loadFromStream(sfPtr, new shaderStream(vertexShaderStream),
                                           new shaderStream(geometryShaderStream),
                                           new shaderStream(fragmentShaderStream));
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }
        return ret;
    }

    /**
     * Specify value for float uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		x		= Value of the float scalar
     */
     void setUniform(const(char)[] name, float x)
     {
        sfShader_setFloatUniform(sfPtr, name.ptr, name.length, x);
     }

    ///ditto
    void opIndexAssign(float x, const(char)[] name)
    {
        setUniform(name, x);
    }

    /**
     * Specify value for vec2 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the vec2 vector
     */
    void setUniform(const(char)[] name, ref const(Vec2) vector)
    {
        sfShader_setVec2Uniform(sfPtr, name.ptr, name.length, &vector);
    }

    ///ditto
    void opIndexAssign(ref const(Vec2) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for vec3 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the vec3 vector
     */
    void setUniform(const(char)[] name, ref const(Vec3) vector)
    {
        sfShader_setVec3Uniform(sfPtr, name.ptr, name.length, &vector);
    }

    ///ditto
    void opIndexAssign(ref const(Vec3) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for vec4 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the vec4 vector
     */
    void setUniform(const(char)[] name, ref const(Vec4) vector)
    {
        sfShader_setVec4Uniform(sfPtr, name.ptr, name.length, &vector);
    }

    ///ditto
    void opIndexAssign(ref const(Vec4) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for int uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		x		= Value of the int scalar
     */
     void setUniform(const(char)[] name, int x)
     {
        sfShader_setIntUniform(sfPtr, name.ptr, name.length, x);
     }

    ///ditto
    void opIndexAssign(int x, const(char)[] name)
    {
        setUniform(name, x);
    }

    /**
     * Specify value for ivec2 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the ivec2 vector
     */
    void setUniform(const(char)[] name, ref const(Ivec2) vector)
    {
        sfShader_setIvec2Uniform(sfPtr, name.ptr, name.length, &vector);
    }

    ///ditto
    void opIndexAssign(ref const(Ivec2) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for ivec3 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the ivec3 vector
     */
    void setUniform(const(char)[] name, ref const(Ivec3) vector)
    {
        sfShader_setIvec3Uniform(sfPtr, name.ptr, name.length, &vector);
    }

    ///ditto
    void opIndexAssign(ref const(Ivec3) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for ivec4 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the ivec4 vector
     */
    void setUniform(const(char)[] name, ref const(Ivec4) vector)
    {
        sfShader_setIvec4Uniform(sfPtr, name.ptr, name.length, &vector);
    }

    ///ditto
    void opIndexAssign(ref const(Ivec4) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for bool uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		x		= Value of the bool scalar
     */
     void setUniform(const(char)[] name, bool x)
     {
        sfShader_setBoolUniform(sfPtr, name.ptr, name.length, x);
     }

     ///ditto
    void opIndexAssign(bool x, const(char)[] name)
    {
        setUniform(name, x);
    }

    /**
     * Specify value for bvec2 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the bvec2 vector
     */
    void setUniform(const(char)[] name, ref const(Bvec2) vector)
    {
        sfShader_setBvec2Uniform(sfPtr, name.ptr, name.length,
                                   vector.x, vector.y);
    }

    ///ditto
    void opIndexAssign(ref const(Bvec2) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for bvec3 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the bvec3 vector
     */
    void setUniform(const(char)[] name, ref const(Bvec3) vector)
    {
        sfShader_setBvec3Uniform(sfPtr, name.ptr, name.length, vector.x,
                                 vector.y, vector.z);
    }

    ///ditto
    void opIndexAssign(ref const(Bvec3) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }


    /**
     * Specify value for bvec4 uniform.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		vector	= Value of the bvec4 vector
     */
    void setUniform(const(char)[] name, ref const(Bvec4) vector)
    {
        sfShader_setBvec4Uniform(sfPtr, name.ptr, name.length, vector.x,
                                 vector.y, vector.z, vector.w);
    }

    ///ditto
    void opIndexAssign(ref const(Bvec4) vector, const(char)[] name)
    {
        setUniform(name, vector);
    }

    /**
     * Specify value for mat3 matrix.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		matrix	= Value of the mat3 vector
     */
    void setUniform(const(char)[] name, ref const(Mat3) matrix)
    {
        sfShader_setMat3Uniform(sfPtr, name.ptr, name.length, &matrix);
    }

    ///ditto
    void opIndexAssign(ref const(Mat3) matrix, const(char)[] name)
    {
        setUniform(name, matrix);
    }

    /**
     * Specify value for mat4 matrix.
     *
     * Params:
     * 		name	= Name of the uniform variable in GLSL
     * 		matrix	= Value of the mat4 vector
     */
    void setUniform(const(char)[] name, ref const(Mat4) matrix)
    {
        sfShader_setMat4Uniform(sfPtr, name.ptr, name.length, &matrix);
    }

    ///ditto
    void opIndexAssign(ref const(Mat4) matrix, const(char)[] name)
    {
        setUniform(name, matrix);
    }

    /**
     * Specify a texture as sampler2D uniform.
     *
     * 'name' is the name of the variable to change in the shader. The
     * corresponding parameter in the shader must be a 2D texture (sampler2D
     * GLSL type).
     *
     * It is important to note that texture must remain alive as long as the
     * shader uses it, no copy is made internally.
     *
     * To use the texture of the object being drawn, which cannot be known in
     * advance, you can pass the special value CurrentTexture.
     *
     * Params:
     * 		name	= Name of the texture in the shader
     *		texture	= Texture to assign
     */
    void setUniform(const(char)[] name, const(Texture) texture)
    {
        import dsfml.system.string:toString;

        sfShader_setTextureUniform(sfPtr, name.ptr, name.length,
                                   texture?texture.sfPtr:null);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    ///ditto
    void opIndexAssign(const(Texture) texture, const(char)[] name)
    {
        import dsfml.system.string:toString;

        sfShader_setTextureUniform(sfPtr, name.ptr, name.length,
                                   texture?texture.sfPtr:null);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    /**
     * Specify current texture as sampler2D uniform.
     *
     * This overload maps a shader texture variable to the texture of the object
     * being drawn, which cannot be known in advance. The second argument must
     * be CurrentTexture. The corresponding parameter in the shader must be a 2D
     * texture (sampler2D GLSL type).
     *
     * Params:
     * 		name	= Name of the texture in the shader
     */
    void setUniform(const(char)[] name, CurrentTextureType)
    {
        import dsfml.system.string:toString;

        sfShader_setCurrentTextureUniform(sfPtr, name.ptr, name.length);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    ///ditto
    void opIndexAssign(CurrentTextureType, const(char)[] name)
    {
        sfShader_setCurrentTextureUniform(sfPtr, name.ptr, name.length);
    }

    /**
     * Specify values for float[] array uniform.
     *
     * Params:
     *		name		= Name of the uniform variable in GLSL
     *		scalarArray = array of float values
     */
    void setUniformArray(const(char)[] name, const(float)[] scalarArray)
    {
        sfShader_setFloatArrayUniform(sfPtr, name.ptr, name.length,
                                      scalarArray.ptr, scalarArray.length);
    }

    ///ditto
    void opIndexAssign(const(float)[] scalars, const(char)[] name)
    {
        setUniformArray(name, scalars);
    }

    /**
     * Specify values for vec2[] array uniform.
     *
     * Params:
     *		name		= Name of the uniform variable in GLSL
     *		vectorArray = array of vec2 values
     */
    void setUniformArray(const(char)[] name, const(Vec2)[] vectorArray)
    {
        sfShader_setVec2ArrayUniform(sfPtr, name.ptr, name.length,
                                     vectorArray.ptr, vectorArray.length);
    }

    ///ditto
    void opIndexAssign(const(Vec2)[] vectors, const(char)[] name)
    {
        setUniformArray(name, vectors);
    }

    /**
     * Specify values for vec3[] array uniform.
     *
     * Params:
     *		name		= Name of the uniform variable in GLSL
     *		vectorArray = array of vec3 values
     */
    void setUniformArray(const(char)[] name, const(Vec3)[] vectorArray)
    {
        sfShader_setVec3ArrayUniform(sfPtr, name.ptr, name.length,
                                     vectorArray.ptr, vectorArray.length);
    }

    ///ditto
    void opIndexAssign(const(Vec3)[] vectors, const(char)[] name)
    {
        setUniformArray(name, vectors);
    }

    /**
     * Specify values for vec4[] array uniform.
     *
     * Params:
     *		name		= Name of the uniform variable in GLSL
     *		vectorArray = array of vec4 values
     */
    void setUniformArray(const(char)[] name, const(Vec4)[] vectorArray)
    {
        sfShader_setVec4ArrayUniform(sfPtr, name.ptr, name.length,
                                     vectorArray.ptr, vectorArray.length);
    }

    ///ditto
    void opIndexAssign(const(Vec4)[] vectors, const(char)[] name)
    {
        setUniformArray(name, vectors);
    }

    /**
     * Specify values for mat3[] array uniform.
     *
     * Params:
     *		name		= Name of the uniform variable in GLSL
     *		matrixArray = array of mat3 values
     */
    void setUniformArray(const(char)[] name, const(Mat3)[] matrixArray)
    {
        sfShader_setMat3ArrayUniform(sfPtr, name.ptr, name.length,
                                     matrixArray.ptr, matrixArray.length);
    }

    ///ditto
    void opIndexAssign(const(Mat3)[] matrices, const(char)[] name)
    {
        setUniformArray(name, matrices);
    }

    /**
     * Specify values for mat4[] array uniform.
     *
     * Params:
     *		name		= Name of the uniform variable in GLSL
     *		matrixArray = array of mat4 values
     */
    void setUniformArray(const(char)[] name, const(Mat4)[] matrixArray)
    {
        sfShader_setMat4ArrayUniform(sfPtr, name.ptr, name.length,
                                     matrixArray.ptr, matrixArray.length);
    }

    ///ditto
    void opIndexAssign(const(Mat4)[] matrices, const(char)[] name)
    {
        setUniformArray(name, matrices);
    }

    /**
     * Change a float parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a float (float GLSL type).
     * 		x		= Value to assign
     */
    deprecated("Use setUniform(const(char)[], float) instead.")
    void setParameter(const(char)[] name, float x)
    {
        import dsfml.system.string;
        sfShader_setFloatParameter(sfPtr, name.ptr, name.length, x);
    }

    /**
     * Change a 2-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2x1 vector (vec2 GLSL type).
     * 		x		= First component of the value to assign
     * 		y		= Second component of the value to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Vec2)) instead.")
    void setParameter(const(char)[] name, float x, float y)
    {
        import dsfml.system.string;
        sfShader_setFloat2Parameter(sfPtr, name.ptr, name.length, x, y);
    }

    /**
     * Change a 3-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 3x1 vector (vec3 GLSL type).
     * 		x		= First component of the value to assign
     * 		y		= Second component of the value to assign
     * 		z		= Third component of the value to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Vec3)) instead.")
    void setParameter(const(char)[] name, float x, float y, float z)
    {
        import dsfml.system.string;
        sfShader_setFloat3Parameter(sfPtr, name.ptr, name.length, x,y,z);
    }

    /**
     * Change a 4-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 4x1 vector (vec4 GLSL type).
     * 		x		= First component of the value to assign
     * 		y		= Second component of the value to assign
     * 		z		= Third component of the value to assign
     * 		w		= Fourth component of the value to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Vec4)) instead.")
    void setParameter(const(char)[] name, float x, float y, float z, float w)
    {
        import dsfml.system.string;
        sfShader_setFloat4Parameter(sfPtr, name.ptr, name.length, x, y, z, w);
    }

    /**
     * Change a 2-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The corresponding parameter in the shader must be a 2x1 vector (vec2 GLSL type).
     * 		vector	= Vector to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Vec2)) instead.")
    void setParameter(const(char)[] name, Vector2f vector)
    {
        import dsfml.system.string;
        sfShader_setFloat2Parameter(sfPtr, name.ptr, name.length, vector.x, vector.y);
    }

    /**
     * Change a 3-components vector parameter of the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader.
     *                The corresponding parameter in the shader must be a 3x1
                      vector (vec3 GLSL type)
     * 		vector	= Vector to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Vec3)) instead.")
    void setParameter(const(char)[] name, Vector3f vector)
    {
        import dsfml.system.string;
        sfShader_setFloat3Parameter(sfPtr, name.ptr, name.length, vector.x, vector.y, vector.z);
    }

    /**
     * Change a color vector parameter of the shader.
     *
     * It is important to note that the components of the color are normalized
     * before being passed to the shader. Therefore, they are converted from
     * range [0 .. 255] to range [0 .. 1]. For example, a
     * Color(255, 125, 0, 255) will be transformed to a vec4(1.0, 0.5, 0.0, 1.0)
     * in the shader.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The
     *                corresponding parameter in the shader must be a 4x1 vector
     *                (vec4 GLSL type).
     * 		color	= Color to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Vec4)) instead.")
    void setParameter(const(char)[] name, Color color)
    {
        import dsfml.system.string;
        sfShader_setColorParameter(sfPtr, name.ptr, name.length, color.r, color.g, color.b, color.a);
    }

    ///ditto
    deprecated("Use shader[\"name\"] = Vec4(color) instead.")
    void opIndexAssign(Color color, const(char)[] name)
    {
        import dsfml.system.string;
        sfShader_setColorParameter(sfPtr, name.ptr, name.length, color.r, color.g, color.b, color.a);
    }

    /**
     * Change a matrix parameter of the shader.
     *
     * Params:
     * 		name		= The name of the variable to change in the shader. The
     *                    corresponding parameter in the shader must be a 4x4
                          matrix (mat4 GLSL type)
     * 		transform	= Transform to assign
     */
    deprecated("Use setUniform(const(char)[] , ref const(Mat4)) instead.")
    void setParameter(const(char)[] name, Transform transform)
    {
        import dsfml.system.string;
        sfShader_setTransformParameter(sfPtr, name.ptr, name.length, transform.m_matrix.ptr);
    }

    ///ditto
    deprecated("Use shader[\"name\"] = Mat4(transform) instead.")
    void opIndexAssign(Transform transform, const(char)[] name)
    {
        import dsfml.system.string;
        sfShader_setTransformParameter(sfPtr, name.ptr, name.length, transform.m_matrix.ptr);
    }

    /**
     * Change a texture parameter of the shader.
     *
     * It is important to note that the texture parameter must remain alive as
     * long as the shader uses it - no copoy is made internally.
     *
     * To use the texture of the object being draw, which cannot be known in
     * advance, you can pass the special value Shader.CurrentTexture.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader. The
     *                corresponding parameter in the shader must be a 2D texture
     *                (sampler2D GLSL type)
     * 		texture	= Texture to assign
     */
    deprecated("Use setUniform(const(char)[] , const(Texture)) instead.")
    void setParameter(const(char)[] name, const(Texture) texture)
    {
        import dsfml.system.string;
        sfShader_setTextureParameter(sfPtr, name.ptr, name.length, texture?texture.sfPtr:null);
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
    }

    /**
     * Change a texture parameter of the shader.
     *
     * This overload maps a shader texture variable to the texture of the object
     * being drawn, which cannot be known in advance. The second argument must
     * be Shader.CurrentTexture.
     *
     * Params:
     * 		name	= The name of the variable to change in the shader.
     *                The corresponding parameter in the shader must be a 2D texture
     *                (sampler2D GLSL type)
     */
    deprecated("Use setUniform(const(char)[] , CurrentTextureType) instead.")
    void setParameter(const(char)[] name, CurrentTextureType)
    {
        import dsfml.system.string;
        sfShader_setCurrentTextureParameter(sfPtr, name.ptr, name.length);
    }

    /**
     * Bind a shader for rendering.
     *
     * This function is not part of the graphics API, it mustn't be used when drawing SFML entities. It must be used only if you mix Shader with OpenGL code.
     *
     * Params:
     * 		shader	= Shader to bind. Can be null to use no shader.
     */
    static void bind(Shader shader)
    {
        (shader is null)?sfShader_bind(null):sfShader_bind(shader.sfPtr);
    }

    /**
     * Tell whether or not the system supports shaders.
     *
     * This function should always be called before using the shader features.
     * If it returns false, then any attempt to use DSFML Shader will fail.
     *
     * Returns: true if shaders are supported, false otherwise
     */
    static bool isAvailable()
    {
        import dsfml.system.string;
        bool toReturn = sfShader_isAvailable();
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
        return toReturn;
    }

    /**
     * Tell whether or not the system supports geometry shaders
     *
     * Returns: true if geometry shaders are supported, false otherwise
     */
    static bool isGeometryAvailable()
    {
        import dsfml.system.string;
        bool toReturn = sfShader_isGeometryAvailable();
        err.write(dsfml.system.string.toString(sfErr_getOutput()));
        return toReturn;
    }
}

unittest
{
    //find some examples of interesting shaders and use them here?
}

private extern(C++) interface shaderInputStream
{
    long read(void* data, long size);

    long seek(long position);

    long tell();

    long getSize();
}


private class shaderStream:shaderInputStream
{
    private InputStream myStream;

    this(InputStream stream)
    {
        myStream = stream;
    }

    extern(C++)long read(void* data, long size)
    {
        return myStream.read(data[0..cast(size_t)size]);
    }

    extern(C++)long seek(long position)
    {
        return myStream.seek(position);
    }

    extern(C++)long tell()
    {
        return myStream.tell();
    }

    extern(C++)long getSize()
    {
        return myStream.getSize();
    }
}

package extern(C):
struct sfShader;

private extern(C):

//Construct a new shader
sfShader* sfShader_construct();

//Load both the vertex and fragment shaders from files
bool sfShader_loadFromFile(sfShader* shader, const(char)* vertexShaderFilename, size_t vertexShaderFilenameLength, const char* fragmentShaderFilename, size_t fragmentShaderFilenameLength);

//Load the vertex, geometry and fragment shaders from files
bool sfShader_loadFromFile(sfShader* shader, const(char)* vertexShaderFilename, size_t vertexShaderFilenameLength, const(char)* geometryShaderFilename, size_t geometryShaderFilenameLength, const char* fragmentShaderFilename, size_t fragmentShaderFilenameLength);

//Load both the vertex and fragment shaders from source codes in memory
bool sfShader_loadFromMemory(sfShader* shader, const(char)* vertexShader, size_t vertexShaderLength, const char* fragmentShader, size_t fragmentShaderLength);

//Load the vertex, geometry and fragment shaders from source codes in memory
bool sfShader_loadFromMemory(sfShader* shader, const(char)* vertexShader, size_t vertexShaderLength, const(char)* geometryShader, size_t geometryShaderLength, const char* fragmentShader, size_t fragmentShaderLength);

//Load both the vertex and fragment shaders from custom streams
bool sfShader_loadFromStream(sfShader* shader, shaderInputStream vertexShaderStream, shaderInputStream fragmentShaderStream);

//Load the vertex, geometry and fragment shaders from custom streams
bool sfShader_loadFromStream(sfShader* shader, shaderInputStream vertexShaderStream, shaderInputStream geometryInputShader, shaderInputStream fragmentShaderStream);

//Destroy an existing shader
void sfShader_destroy(sfShader* shader);

//Specify value for float uniform
void sfShader_setFloatUniform(sfShader* shader, const char* name, size_t length, float x);

//Specify value for vec2 uniform
void sfShader_setVec2Uniform(sfShader* shader, const char* name, size_t length, const(Vec2)* vec2);

//Specify value for vec3 uniform
void sfShader_setVec3Uniform(sfShader* shader, const char* name, size_t length, const(Vec3)* vec3);

//Specify value for vec4 uniform
void sfShader_setVec4Uniform(sfShader* shader, const char* name, size_t length, const(Vec4)* vec4);

//Specify value for int uniform
void sfShader_setIntUniform(sfShader* shader, const char* name, size_t length, int x);

//Specify value for ivec2 uniform
void sfShader_setIvec2Uniform(sfShader* shader, const char* name, size_t length, const(Ivec2)* ivec2);

//Specify value for ivec3 uniform
void sfShader_setIvec3Uniform(sfShader* shader, const char* name, size_t length, const(Ivec3)* ivec3);

//Specify value for ivec4 uniform
void sfShader_setIvec4Uniform(sfShader* shader, const char* name, size_t length, const(Ivec4)* ivec4);

//Specify value for bool uniform
void sfShader_setBoolUniform(sfShader* shader, const char* name, size_t length, bool x);

//Specify value for bvec2 uniform
void sfShader_setBvec2Uniform(sfShader* shader, const char* name, size_t length, bool x, bool y);

//Specify value for bvec3 uniform
void sfShader_setBvec3Uniform(sfShader* shader, const char* name, size_t length, bool x, bool y, bool z);

//Specify value for bvec4 uniform
void sfShader_setBvec4Uniform(sfShader* shader, const char* name, size_t length, bool x, bool y, bool z, bool w);

//Specify value for mat3 matrix.
void sfShader_setMat3Uniform(sfShader* shader, const char* name, size_t length, const(Mat3)* mat3);

//Specify value for mat4 matrix.
void sfShader_setMat4Uniform(sfShader* shader, const char* name, size_t length, const(Mat4)* mat4);

//Specify a texture as sampler2D uniform
void sfShader_setTextureUniform(sfShader* shader, const char* name, size_t length, const(sfTexture)* texture);

//Specify current texture as sampler2D uniform.
void sfShader_setCurrentTextureUniform(sfShader* shader, const char* name, size_t length);

//Specify values for float[] array uniform.
void sfShader_setFloatArrayUniform(sfShader* shader, const char* name, size_t nlength, const(float)* array, size_t alength);

//Specify values for vec2[] array uniform.
void sfShader_setVec2ArrayUniform(sfShader* shader, const char* name, size_t nlength, const(Vec2)*, size_t alength);

//Specify values for vec3[] array uniform.
void sfShader_setVec3ArrayUniform(sfShader* shader, const char* name, size_t nlength, const(Vec3)*, size_t alength);

//Specify values for vec4[] array uniform.
void sfShader_setVec4ArrayUniform(sfShader* shader, const char* name, size_t nlength, const(Vec4)*, size_t alength);

//Specify values for mat3[] array uniform.
void sfShader_setMat3ArrayUniform(sfShader* shader, const char* name, size_t nlength, const(Mat3)*, size_t alength);

//Specify values for mat4[] array uniform.
void sfShader_setMat4ArrayUniform(sfShader* shader, const char* name, size_t nlength, const(Mat4)*, size_t alength);

//Bind a shader for rendering (activate it)
void sfShader_bind(const sfShader* shader);

//Tell whether or not the system supports shaders
bool sfShader_isAvailable();

//Tell whether or not the system supports geometry shaders
bool sfShader_isGeometryAvailable();

const(char)* sfErr_getOutput();

//DEPRECATED

//Change a float parameter of a shader
void sfShader_setFloatParameter(sfShader* shader, const char* name, size_t length, float x);

//Change a 2-components vector parameter of a shader
void sfShader_setFloat2Parameter(sfShader* shader, const char* name, size_t length, float x, float y);

//Change a 3-components vector parameter of a shader
void sfShader_setFloat3Parameter(sfShader* shader, const char* name, size_t length, float x, float y, float z);

//Change a 4-components vector parameter of a shader
void sfShader_setFloat4Parameter(sfShader* shader, const char* name, size_t length, float x, float y, float z, float w);

//Change a color parameter of a shader
void sfShader_setColorParameter(sfShader* shader, const char* name, size_t length, ubyte r, ubyte g, ubyte b, ubyte a);

//Change a matrix parameter of a shader
void sfShader_setTransformParameter(sfShader* shader, const char* name, size_t length, float* transform);

//Change a texture parameter of a shader
void sfShader_setTextureParameter(sfShader* shader, const char* name, size_t length, const sfTexture* texture);

//Change a texture parameter of a shader
void sfShader_setCurrentTextureParameter(sfShader* shader, const char* name, size_t length);
