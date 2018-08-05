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
 * $(U Texture) stores pixels that can be drawn, with a sprite for example. A
 * texture lives in the graphics card memory, therefore it is very fast to draw
 * a texture to a render target, or copy a render target to a texture (the
 * graphics card can access both directly).
 *
 * Being stored in the graphics card memory has some drawbacks. A texture cannot
 * be manipulated as freely as a $(IMAGE_LINK), you need to prepare the pixels
 * first and then upload them to the texture in a single operation (see
 * `Texture.update`).
 *
 * $(U Texture) makes it easy to convert from/to Image, but keep in mind that
 * these calls require transfers between the graphics card and the central
 * memory, therefore they are slow operations.
 *
 * A texture can be loaded from an image, but also directly from a
 * file/memory/stream. The necessary shortcuts are defined so that you don't
 * need an image first for the most common cases. However, if you want to
 * perform some modifications on the pixels before creating the final texture,
 * you can load your file to a $(IMAGE_LINK), do whatever you need with the
 * pixels, and then call `Texture.loadFromImage`.
 *
 * Since they live in the graphics card memory, the pixels of a texture cannot
 * be accessed without a slow copy first. And they cannot be accessed
 * individually. Therefore, if you need to read the texture's pixels (like for
 * pixel-perfect collisions), it is recommended to store the collision
 * information separately, for example in an array of booleans.
 *
 * Like $(IMAGE_LINK), $(U Texture) can handle a unique internal representation
 * of pixels, which is RGBA 32 bits. This means that a pixel must be composed of
 * 8 bits red, green, blue and alpha channels – just like a $(COLOR_LINK).
 *
 * Example:
 * ---
 * // This example shows the most common use of Texture:
 * // drawing a sprite
 *
 * // Load a texture from a file
 * auto texture = new Texture();
 * if (!texture.loadFromFile("texture.png"))
 *     return -1;
 *
 * // Assign it to a sprite
 * auto sprite = new Sprite();
 * sprite.setTexture(texture);
 *
 * // Draw the textured sprite
 * window.draw(sprite);
 * ---
 *
 * ---
 * // This example shows another common use of Texture:
 * // streaming real-time data, like video frames
 *
 * // Create an empty texture
 * auto texture = new Texture();
 * if (!texture.create(640, 480))
 *     return -1;
 *
 * // Create a sprite that will display the texture
 * auto sprite = new Sprite(texture);
 *
 * while (...) // the main loop
 * {
 *     ...
 *
 *     // update the texture
 *
 *     // get a fresh chunk of pixels (the next frame of a movie, for example)
 *     ubyte[] pixels = ...;
 *     texture.update(pixels);
 *
 *     // draw it
 *     window.draw(sprite);
 *
 *     ...
 * }
 *
 * ---
 *
 * $(PARA Like $(SHADER_LINK) that can be used as a raw OpenGL shader,
 * $(U Texture) can also be used directly as a raw texture for custom OpenGL
 * geometry.)
 * ---
 * Texture.bind(texture);
 * ... render OpenGL geometry ...
 * Texture.bind(null);
 * ---
 *
 * See_Also:
 * $(SPRITE_LINK), $(IMAGE_LINK), $(RENDERTEXTURE_LINK)
 */
module dsfml.graphics.texture;

import dsfml.graphics.rect;
import dsfml.graphics.image;
import dsfml.graphics.renderwindow;

import dsfml.window.window;

import dsfml.system.inputstream;
import dsfml.system.vector2;
import dsfml.system.err;

/**
 * Image living on the graphics card that can be used for drawing.
 */
class Texture
{
    package sfTexture* sfPtr;

    /**
     * Default constructor
     *
     * Creates an empty texture.
     */
    this()
    {
        sfPtr = sfTexture_construct();
    }

    package this(sfTexture* texturePointer)
    {
        sfPtr = texturePointer;
    }

    /// Destructor.
    ~this()
    {
        import dsfml.system.config;
        mixin(destructorOutput);
        sfTexture_destroy( sfPtr);
    }

    /**
     * Load the texture from a file on disk.
     *
     * The area argument can be used to load only a sub-rectangle of the whole
     * image. If you want the entire image then leave the default value (which
     * is an empty IntRect). If the area rectangle crosses the bounds of the
     * image, it is adjusted to fit the image size.
     *
     * The maximum size for a texture depends on the graphics driver and can be
     * retrieved with the getMaximumSize function.
     *
     * If this function fails, the texture is left unchanged.
     *
     * Params:
     * 		filename	= Path of the image file to load
     * 		area		= Area of the image to load
     *
     * Returns: true if loading was successful, false otherwise.
     */
    bool loadFromFile(const(char)[] filename, IntRect area = IntRect() )
    {
        import dsfml.system.string;

        bool ret = sfTexture_loadFromFile(sfPtr, filename.ptr, filename.length,area.left, area.top,area.width, area.height);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load the texture from a file in memory.
     *
     * The area argument can be used to load only a sub-rectangle of the whole
     * image. If you want the entire image then leave the default value (which
     * is an empty IntRect). If the area rectangle crosses the bounds of the
     * image, it is adjusted to fit the image size.
     *
     * The maximum size for a texture depends on the graphics driver and can be
     * retrieved with the getMaximumSize function.
     *
     * If this function fails, the texture is left unchanged.
     *
     * Params:
     * 		data	= Image in memory
     * 		size	= Size of the data to load, in bytes.
     * 		area	= Area of the image to load
     *
     * Returns: true if loading was successful, false otherwise.
     */
    bool loadFromMemory(const(void)[] data, IntRect area = IntRect())
    {
        import dsfml.system.string;

        bool ret = sfTexture_loadFromMemory(sfPtr, data.ptr, data.length,area.left, area.top,area.width, area.height);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load the texture from a custom stream.
     *
     * The area argument can be used to load only a sub-rectangle of the whole
     * image. If you want the entire image then leave the default value (which
     * is an empty IntRect). If the area rectangle crosses the bounds of the
     * image, it is adjusted to fit the image size.
     *
     * The maximum size for a texture depends on the graphics driver and can be
     * retrieved with the getMaximumSize function.
     *
     * If this function fails, the texture is left unchanged.
     *
     * Params:
     * 		stream	= Source stream to read from
     * 		area	= Area of the image to load
     *
     * Returns: true if loading was successful, false otherwise.
     */
    bool loadFromStream(InputStream stream, IntRect area = IntRect())
    {
        import dsfml.system.string;

        bool ret = sfTexture_loadFromStream(sfPtr, new textureStream(stream), area.left, area.top,area.width, area.height);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Load the texture from an image.
     *
     * The area argument can be used to load only a sub-rectangle of the whole
     * image. If you want the entire image then leave the default value (which
     * is an empty IntRect). If the area rectangle crosses the bounds of the
     * image, it is adjusted to fit the image size.
     *
     * The maximum size for a texture depends on the graphics driver and can be
     * retrieved with the getMaximumSize function.
     *
     * If this function fails, the texture is left unchanged.
     *
     * Params:
     * 		image	= Image to load into the texture
     * 		area	= Area of the image to load
     *
     * Returns: true if loading was successful, false otherwise.
     */
    bool loadFromImage(Image image, IntRect area = IntRect())
    {
        import dsfml.system.string;

        bool ret = sfTexture_loadFromImage(sfPtr, image.sfPtr, area.left, area.top,area.width, area.height);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Get the maximum texture size allowed.
     *
     * This Maximum size is defined by the graphics driver. You can expect a
     * value of 512 pixels for low-end graphics card, and up to 8192 pixels or
     * more for newer hardware.
     *
     * Returns: Maximum size allowed for textures, in pixels.
     */
    static uint getMaximumSize()
    {
        return sfTexture_getMaximumSize();
    }

    /**
     * Return the size of the texture.
     *
     * Returns: Size in pixels.
     */
    Vector2u getSize() const
    {
        Vector2u temp;
        sfTexture_getSize(sfPtr, &temp.x, &temp.y);
        return temp;
    }

    /**
     * Enable or disable the smooth filter.
     *
     * When the filter is activated, the texture appears smoother so that pixels
     * are less noticeable. However if you want the texture to look exactly the
     * same as its source file, you should leave it disabled. The smooth filter
     * is disabled by default.
     *
     * Params:
     * 		smooth	= true to enable smoothing, false to disable it
     */
    void setSmooth(bool smooth)
    {
        sfTexture_setSmooth(sfPtr, smooth);
    }

    /**
     * Enable or disable repeating.
     *
     * Repeating is involved when using texture coordinates outside the texture
     * rectangle [0, 0, width, height]. In this case, if repeat mode is enabled,
     * the whole texture will be repeated as many times as needed to reach the
     * coordinate (for example, if the X texture coordinate is 3 * width, the
     * texture will be repeated 3 times).
     *
     * If repeat mode is disabled, the "extra space" will instead be filled with
     * border pixels. Warning: on very old graphics cards, white pixels may
     * appear when the texture is repeated. With such cards, repeat mode can be
     * used reliably only if the texture has power-of-two dimensions
     * (such as 256x128). Repeating is disabled by default.
     *
     * Params:
     * 		repeated	= true to repeat the texture, false to disable repeating
     */
    void setRepeated(bool repeated)
    {
        sfTexture_setRepeated(sfPtr, repeated);
    }

    /**
     * Bind a texture for rendering.
     *
     * This function is not part of the graphics API, it mustn't be used when
     * drawing DSFML entities. It must be used only if you mix Texture with
     * OpenGL code.
     *
     * Params:
     * 		texture	= The texture to bind. Can be null to use no texture
     */
    static void bind(Texture texture)
    {
        (texture is null)?sfTexture_bind(null):sfTexture_bind(texture.sfPtr);
    }

    /**
     * Create the texture.
     *
     * If this function fails, the texture is left unchanged.
     *
     * Params:
     * 		width	= Width of the texture
     * 		height	= Height of the texture
     *
     * Returns: true if creation was successful, false otherwise.
     */
    bool create(uint width, uint height)
    {
        import dsfml.system.string;

        bool ret = sfTexture_create(sfPtr, width, height);
        if(!ret)
        {
            err.write(dsfml.system.string.toString(sfErr_getOutput()));
        }

        return ret;
    }

    /**
     * Copy the texture pixels to an image.
     *
     * This function performs a slow operation that downloads the texture's
     * pixels from the graphics card and copies them to a new image, potentially
     * applying transformations to pixels if necessary (texture may be padded or
     * flipped).
     *
     * Returns: Image containing the texture's pixels.
     */
    Image copyToImage() const
    {
        return new Image(sfTexture_copyToImage(sfPtr));
    }

    /**
     * Creates a new texture from the same data (this means copying the entire
     * set of pixels).
     */
    @property Texture dup() const
    {
        return new Texture(sfTexture_copy(sfPtr));
    }

    /**
     * Tell whether the texture is repeated or not.
     *
     * Returns: true if repeat mode is enabled, false if it is disabled.
     */
    bool isRepeated() const
    {
        return (sfTexture_isRepeated(sfPtr));
    }

    /**
     * Tell whether the smooth filter is enabled or not.
     *
     * Returns: true if something is enabled, false if it is disabled.
     */
    bool isSmooth() const
    {
        return (sfTexture_isSmooth(sfPtr));
    }

    /**
     * Update the whole texture from an array of pixels.
     *
     * The pixel array is assumed to have the same size as
     * the area rectangle, and to contain 32-bits RGBA pixels.
     *
     * No additional check is performed on the size of the pixel
     * array, passing invalid arguments will lead to an undefined
     * behavior.
     *
     * This function does nothing if pixels is empty or if the
     * texture was not previously created.
     *
     * Params:
     * 		pixels	= Array of pixels to copy to the texture.
     */
    void update(const(ubyte)[] pixels)
    {
        Vector2u size = getSize();

        sfTexture_updateFromPixels(sfPtr,pixels.ptr,size.x, size.y, 0,0);
    }

    /**
     * Update part of the texture from an array of pixels.
     *
     * The size of the pixel array must match the width and height arguments,
     * and it must contain 32-bits RGBA pixels.
     *
     * No additional check is performed on the size of the pixel array or the
     * bounds of the area to update, passing invalid arguments will lead to an
     * undefined behaviour.
     *
     * This function does nothing if pixels is empty or if the texture was not
     * previously created.
     *
     * Params:
     * 		pixels	= Array of pixels to copy to the texture.
     * 		width	= Width of the pixel region contained in pixels
     * 		height	= Height of the pixel region contained in pixels
     * 		x		= X offset in the texture where to copy the source pixels
     * 		y		= Y offset in the texture where to copy the source pixels
     */
    void update(const(ubyte)[] pixels, uint width, uint height, uint x, uint y)
    {
        sfTexture_updateFromPixels(sfPtr,pixels.ptr,width, height, x,y);
    }

    /**
     * Update the texture from an image.
     *
     * Although the source image can be smaller than the texture, this function
     * is usually used for updating the whole texture. The other overload, which
     * has (x, y) additional arguments, is more convenient for updating a
     * sub-area of the texture.
     *
     * No additional check is performed on the size of the image, passing an
     * image bigger than the texture will lead to an undefined behaviour.
     *
     * This function does nothing if the texture was not previously created.
     *
     * Params:
     * 		image	= Image to copy to the texture.
     */
    void update(const(Image) image)
    {
        sfTexture_updateFromImage(sfPtr, image.sfPtr, 0, 0);
    }

    /**
     * Update the texture from an image.
     *
     * No additional check is performed on the size of the image, passing an
     * invalid combination of image size and offset will lead to an undefined
     * behavior.
     *
     * This function does nothing if the texture was not previously created.
     *
     * Params:
     * 		image = Image to copy to the texture.
     *		y     = Y offset in the texture where to copy the source image.
     *		x     = X offset in the texture where to copy the source image.
     */
    void update(const(Image) image, uint x, uint y)
    {
        sfTexture_updateFromImage(sfPtr, image.sfPtr, x, y);
    }

    /**
     * Update the texture from the contents of a window
     *
     * Although the source window can be smaller than the texture, this function
     * is usually used for updating the whole texture. The other overload, which
     * has (x, y) additional arguments, is more convenient for updating a
     * sub-area of the texture.
     *
     * No additional check is performed on the size of the window, passing a
     * window bigger than the texture will lead to an undefined behavior.
     *
     * This function does nothing if either the texture or the window
     * was not previously created.
     *
     * Params:
     *		window = Window to copy to the texture
     */
    void update(T)(const(T) window)
        if(is(T == Window) || is(T == RenderWindow))
    {
        update(window, 0, 0);
    }

    /**
     * Update a part of the texture from the contents of a window.
     *
     * No additional check is performed on the size of the window, passing an
     * invalid combination of window size and offset will lead to an undefined
     * behavior.
     *
     * This function does nothing if either the texture or the window was not
     * previously created.
     *
     * Params:
     *		window = Window to copy to the texture
     *		x      = X offset in the texture where to copy the source window
     *		y      = Y offset in the texture where to copy the source window
     *
     */
    void update(T)(const(T) window, uint x, uint y)
        if(is(T == Window) || is(T == RenderWindow))
    {
        static if(is(T == RenderWindow))
        {
            sfTexture_updateFromRenderWindow(sfPtr, T.sfPtr, x, y);
        }
        else
        {
            sfTexture_updateFromWindow(sfPtr, RenderWindow.windowPointer(T),
                                        x, y);
        }
    }

    /**
     * Update the texture from an image.
     *
     * Although the source image can be smaller than the texture, this function
     * is usually used for updating the whole texture. The other overload, which
     * has (x, y) additional arguments, is more convenient for updating a
     * sub-area of the texture.
     *
     * No additional check is performed on the size of the image, passing an
     * image bigger than the texture will lead to an undefined behaviour.
     *
     * This function does nothing if the texture was not previously created.
     *
     * Params:
     * 		image	= Image to copy to the texture.
     */
    deprecated("Use update function.")
    void updateFromImage(Image image, uint x, uint y)
    {
        sfTexture_updateFromImage(sfPtr, image.sfPtr, x, y);
    }

    /**
     * Update part of the texture from an array of pixels.
     *
     * The size of the pixel array must match the width and height arguments,
     * and it must contain 32-bits RGBA pixels.
     *
     * No additional check is performed on the size of the pixel array or the
     * bounds of the area to update, passing invalid arguments will lead to an
     * undefined behaviour.
     *
     * This function does nothing if pixels is null or if the texture was not
     * previously created.
     *
     * Params:
     * 		pixels	= Array of pixels to copy to the texture.
     * 		width	= Width of the pixel region contained in pixels
     * 		height	= Height of the pixel region contained in pixels
     * 		x		= X offset in the texture where to copy the source pixels
     * 		y		= Y offset in the texture where to copy the source pixels
     */
    deprecated("Use update function.")
    void updateFromPixels(const(ubyte)[] pixels, uint width, uint height, uint x, uint y)
    {
        sfTexture_updateFromPixels(sfPtr,pixels.ptr,width, height, x,y);
    }

    //TODO: Get this working via inheritance?(so custom window classes can do it too)
    /**
     * Update a part of the texture from the contents of a window.
     *
     * No additional check is performed on the size of the window, passing an
     * invalid combination of window size and offset will lead to an undefined
     * behaviour.
     *
     * This function does nothing if either the texture or the window was not
     * previously created.
     *
     * Params:
     * 		window	= Window to copy to the texture
     * 		x		= X offset in the texture where to copy the source window
     * 		y		= Y offset in the texture where to copy the source window
     */
    deprecated("Use update function.")
    void updateFromWindow(Window window, uint x, uint y)
    {
        sfTexture_updateFromWindow(sfPtr, RenderWindow.windowPointer(window), x, y);
    }

    //Is this even safe? RenderWindow inherits from Window, so what happens? Is this bottom used or the top?
    /**
     * Update a part of the texture from the contents of a window.
     *
     * No additional check is performed on the size of the window, passing an
     * invalid combination of window size and offset will lead to an undefined
     * behaviour.
     *
     * This function does nothing if either the texture or the window was not
     * previously created.
     *
     * Params:
     * 		window	= Window to copy to the texture
     * 		x		= X offset in the texture where to copy the source window
     * 		y		= Y offset in the texture where to copy the source window
     */
    deprecated("Use update function.")
    void updateFromWindow(RenderWindow window, uint x, uint y)
    {
        sfTexture_updateFromRenderWindow(sfPtr, window.sfPtr, x, y);
    }
}

unittest
{
    version(DSFML_Unittest_Graphics)
    {
        import std.stdio;

        writeln("Unit test for Texture");

        auto texture = new Texture();

        assert(texture.loadFromFile("res/TestImage.png"));

        //do things with the texture

        writeln();
    }
}

private extern(C++) interface textureInputStream
{
    long read(void* data, long size);

    long seek(long position);

    long tell();

    long getSize();
}

private class textureStream:textureInputStream
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

package extern(C) struct sfTexture;

private extern(C):

//Construct a new texture
sfTexture* sfTexture_construct();

//Create a new texture
bool sfTexture_create(sfTexture* texture, uint width, uint height);

//Create a new texture from a file
bool sfTexture_loadFromFile(sfTexture* texture, const(char)* filename, size_t length, int left, int top, int width, int height);

//Create a new texture from a file in memory
bool sfTexture_loadFromMemory(sfTexture* texture, const(void)* data, size_t sizeInBytes, int left, int top, int width, int height);

//Create a new texture from a custom stream
bool sfTexture_loadFromStream(sfTexture* texture, textureInputStream stream, int left, int top, int width, int height);

//Create a new texture from an image
bool sfTexture_loadFromImage(sfTexture* texture, const(sfImage)* image, int left, int top, int width, int height);

//Copy an existing texture
sfTexture* sfTexture_copy(const(sfTexture)* texture);

//Destroy an existing texture
void sfTexture_destroy(sfTexture* texture);

//Return the size of the texture
void sfTexture_getSize(const(sfTexture)* texture, uint* x, uint* y);

//Copy a texture's pixels to an image
sfImage* sfTexture_copyToImage(const sfTexture* texture);

//Update a texture from an array of pixels
void sfTexture_updateFromPixels(sfTexture* texture, const ubyte* pixels, uint width, uint height, uint x, uint y);

//Update a texture from an image
void sfTexture_updateFromImage(sfTexture* texture, const sfImage* image, uint x, uint y);

//Update a texture from the contents of a window
void sfTexture_updateFromWindow(sfTexture* texture, const(void)* window, uint x, uint y);

//Update a texture from the contents of a render-window
void sfTexture_updateFromRenderWindow(sfTexture* texture, const sfRenderWindow* renderWindow, uint x, uint y);

//Enable or disable the smooth filter on a texture
void sfTexture_setSmooth(sfTexture* texture, bool smooth);

//Tell whether the smooth filter is enabled or not for a texture
bool sfTexture_isSmooth(const sfTexture* texture);

//Enable or disable repeating for a texture
void sfTexture_setRepeated(sfTexture* texture, bool repeated);

//Tell whether a texture is repeated or not
bool sfTexture_isRepeated(const sfTexture* texture);

//Bind a texture for rendering
void sfTexture_bind(const sfTexture* texture);

//Get the maximum texture size allowed
uint sfTexture_getMaximumSize();

//Flush the OpenGL command buffer.
//void  sfTexture_flush();

const(char)* sfErr_getOutput();
