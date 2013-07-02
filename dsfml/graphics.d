/*
Copyright (c) <2013> <Jeremy DeHaan>

This software is provided 'as-is', without any express or implied warranty. 
In no event will the authors be held liable for any damages arising from the use of this software.

Permission is granted to anyone to use this software for any purpose, including commercial applications,
and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software.
    If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
*/

module dsfml.graphics;
import std.traits;
import std.conv;
import std.string;
import std.algorithm;
import std.math;

import std.utf;

debug import std.stdio;

public
{
	import dsfml.window;
}

enum BlendMode
{
	Alpha,    
	Add,      
	Multiply, 
	None 
}

class CircleShape:Shape
{
	private
	{
		float m_radius; /// Radius of the circle
		uint m_pointCount; /// Number of points composing the circle
	}
	
	this(float radius = 0, uint pointCount = 30)
	{
		m_radius = radius;
		
		m_pointCount = pointCount;
		
		update();
	}
	
	~this()
	{
		debug writeln("Destroying CircleShape");
	}
	
	//TODO: Get this working
	CircleShape dup() const 
	{
		CircleShape temp = new CircleShape(m_radius, m_pointCount);
		
		temp.position = position;
		temp.rotation = rotation;
		temp.scale = scale;
		temp.origin = origin;
		
		return temp;
	}
	
	
	@property
	{
		void pointCount(uint newPointCount)
		{
			m_pointCount = newPointCount;
		}
		override uint pointCount()
		{
			return m_pointCount;
		}
	}
	
	override Vector2f getPoint(uint index)
	{
		
		static const(float) pi = 3.141592654f;
		
		float angle = index * 2 * pi / m_pointCount - pi / 2;
		
		
		float x = cos(angle) * m_radius;
		float y = sin(angle) * m_radius;
		
		
		return Vector2f(m_radius + x, m_radius + y);
	}
	
	
	
	@property
	{
		void radius(float newRadius)
		{
			m_radius = newRadius;
			update();
		}
		float radius()
		{
			return m_radius;
		}
	}
	
	
}

class ConvexShape:Shape
{
	this(uint thePointCount)
	{
		this.pointCount = thePointCount;
		update();
	}
	~this()
	{
		debug writeln("Destroying ConvexShape");
	}
	@property
	{
		void pointCount(uint newPointCount)
		{
			m_points.length = newPointCount;
			update();
		}
		override uint pointCount()
		{
			return cast(uint)min(m_points.length, uint.max);
		}
	}
	
	
	override Vector2f getPoint(uint index)
	{
		return m_points[index];
	}
	
	
	void setPoint(uint index, Vector2f point)
	{
		m_points[index] = point;
	}
	
	void addPoint(Vector2f point)
	{
		m_points ~=point;
		update();
	}
	
	private Vector2f[] m_points;
}


abstract class Drawable
{
	void draw(RenderTarget renderTarget, ref RenderStates renderStates);
}

abstract class DrawableTransformable:Drawable,Transformable
{
	mixin NormalTransformable;
}

class Font
{
	package sfFont* sfPtr;
	
	this()
	{
		//Creates a null font
	}
	
	~this()
	{
		debug writeln("Destroying Font");
		sfFont_destroy(sfPtr);
	}
	
	bool loadFromFile(string filename)
	{
		sfPtr = sfFont_createFromFile(toStringz(filename));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromMemory(const(void)* data, int sizeInBytes)
	{
		sfPtr = sfFont_createFromMemory(data, sizeInBytes);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(ref sfInputStream stream)
	{
		sfPtr = sfFont_createFromStream(&stream);
		return (sfPtr == null)?false:true;
	}
	
	package this(sfFont* newFont)
	{
		sfPtr = newFont;
	}
	
	Font dup() const
	{
		return new Font(sfFont_copy(sfPtr));
	}
	
	Glyph getGlyph(uint codePoint, uint CharacterSize, bool bold) 
	{
		return(bold)? Glyph(sfFont_getGlyph(sfPtr, codePoint, CharacterSize, sfTrue)):Glyph(sfFont_getGlyph(sfPtr, codePoint, CharacterSize, sfFalse));
	}
	
	int getKerning (uint first, uint second, uint characterSize)
	{
		return sfFont_getKerning(sfPtr, first, second,  characterSize);	
	}
	
	int getLineSpacing (uint characterSize)
	{
		return sfFont_getLineSpacing(sfPtr, characterSize);		
	}
	
	const(Texture) getTexture (uint characterSize)
	{
		//Will try to fix for Revision 2
		return new Texture(sfTexture_copy(sfFont_getTexture(sfPtr, characterSize)));
	}
	
}

struct Glyph
{
	package this(sfGlyph glyph)
	{
		advance = glyph.advance;
		bounds = IntRect(glyph.bounds);
		textureRect = IntRect(glyph.textureRect);
	}
	int advance;
	IntRect bounds;
	IntRect textureRect;
}

class Image
{
	
	package sfImage* sfPtr;
	
	this()
	{
		//Creates a null Image
	}
	
	package this(sfImage* image)
	{
		sfPtr = image;
	}
	
	~this()
	{
		debug writeln("Destroying Image");
		sfImage_destroy(sfPtr);
	}
	
	bool create(uint width, uint height, Color color)
	{
		sfPtr = sfImage_createFromColor(width, height, color);
		return (sfPtr == null)?false:true;
	}
	
	
	bool create(uint width, uint height, const ref ubyte[] pixels)
	{
		sfPtr = sfImage_createFromPixels(width, height,pixels.ptr);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromFile(string fileName)
	{
		sfPtr = sfImage_createFromFile(toStringz(fileName));
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromMemory(const(void)* data, uint sizeInBytes)
	{
		sfPtr = sfImage_createFromMemory(data, sizeInBytes);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(ref sfInputStream stream)
	{
		sfPtr = sfImage_createFromStream(&stream);
		return (sfPtr == null)?false:true;
	}
	
	
	
	Image dup() const
	{
		return new Image(sfImage_copy(sfPtr));
	}
	
	bool saveToFile(string fileName)
	{
		return (sfImage_saveToFile(sfPtr, fileName.ptr) == sfTrue)? true:false;
	}
	
	Vector2u getSize()
	{
		sfVector2u temp = sfImage_getSize(sfPtr);
		return Vector2u(temp.x, temp.y);
	}
	
	void createMaskFromColor(Color maskColor, ubyte alpha = 0)
	{
		sfImage_createMaskFromColor(sfPtr, maskColor, alpha);
	}
	
	
	
	void setPixel(uint x, uint y, Color color)
	{
		sfImage_setPixel(sfPtr, x,y,color);
	}
	
	Color getPixel(uint x, uint y)
	{
		return sfImage_getPixel(sfPtr, x,y);
	}
	
	
	const(ubyte)[] getPixelArray()
	{
		Vector2u size = getSize();
		int length = size.x * size.y * 4;
		return sfImage_getPixelsPtr(sfPtr)[0..length];
	}
	
	void flipHorizontally()
	{
		sfImage_flipHorizontally(sfPtr);
	}
	
	void flipVertically()
	{
		sfImage_flipVertically(sfPtr);
	}
	
	void copyImage(const ref Image source, uint destX, uint destY, IntRect sourceRect = IntRect(0,0,0,0), bool applyAlpha = false)
	{
		sfIntRect temp = sfIntRect(sourceRect.left, sourceRect.top, sourceRect.width, sourceRect.height);
		
		(applyAlpha)?sfImage_copyImage(sfPtr, source.sfPtr, destX, destY, temp, sfTrue):sfImage_copyImage(sfPtr, source.sfPtr, destX, destY, temp, sfFalse);
		
	}
	
	
	
	
}

class RectangleShape:Shape
{
	private Vector2f m_size;
	
	
	this(Vector2f size = Vector2f(0,0))
	{
		m_size = size;
		update();
	}
	~this()
	{
		debug writeln("Destroying RectangleShape");
	}
	@property
	{
		void size(Vector2f newSize)
		{
			m_size = newSize;
			update();
		}
		Vector2f size() const
		{
			return m_size;
		}
	}
	
	@property
	{
		
		override uint pointCount()
		{
			return 4;
		}
	}
	
	override Vector2f getPoint(uint index)
	{
		
		switch (index)
		{
			default:
			case 0: return Vector2f(0, 0);
			case 1: return Vector2f(m_size.x, 0);
			case 2: return Vector2f(m_size.x, m_size.y);
			case 3: return Vector2f(0, m_size.y);
		}
	}
}

struct RenderStates
{
	private
	{
		Texture m_texture;
		Shader m_shader;
	}
	
	package sfRenderStates InternalsfRenderStates = sfRenderStates(BlendMode.Alpha,
	                                                               sfTransform([1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f]),null,null);
	
	this(BlendMode theBlendMode)
	{
		InternalsfRenderStates.blendMode = blendMode;
	}		
	this(Transform theTransform)
	{
		InternalsfRenderStates.transform = theTransform.InternalsfTransform;
	}
	this(const(Texture) theTexture)
	{
		InternalsfRenderStates.texture = theTexture.sfPtr;
		m_texture = cast(Texture)theTexture;
	}
	this(const(Shader) theShader)
	{
		InternalsfRenderStates.shader = theShader.sfPtr;
	}
	this(BlendMode theBlendMode, Transform theTransform, const(Texture) theTexture, const(Shader) theShader)
	{
		InternalsfRenderStates.blendMode = blendMode;
		InternalsfRenderStates.transform = theTransform.InternalsfTransform;
		InternalsfRenderStates.texture = theTexture.sfPtr;
		InternalsfRenderStates.shader = theShader.sfPtr;
	}
	
	
	@property
	{
		void blendMode(BlendMode theBlendMode)
		{
			InternalsfRenderStates.blendMode = blendMode;
		}
		BlendMode blendMode()
		{
			return InternalsfRenderStates.blendMode;
		}
	}
	
	@property
	{
		void transform(Transform theTransform)
		{
			InternalsfRenderStates.transform = theTransform.InternalsfTransform;
		}
		Transform transform()
		{
			return Transform(InternalsfRenderStates.transform);
		}
	}
	
	
	@property
	{
		void texture(const(Texture) theTexture)
		{
			if(theTexture !is null)
			{
				
				m_texture = cast(Texture)theTexture;
				
				InternalsfRenderStates.texture = m_texture.sfPtr;
			}
			else
			{
				m_texture = null;
				
				InternalsfRenderStates.texture = null;
				
				
			}
			
		}
		const(Texture) texture()
		{
			return m_texture;
		}
	}
	
	@property
	{
		void shader(const(Shader) theShader)
		{
			m_shader = cast(Shader)theShader;
			InternalsfRenderStates.shader = m_shader.sfPtr;
		}
		const(Shader) shader()
		{
			return m_shader;
		}
	}
	
	
	static RenderStates Default()
	{
		return RenderStates();
	}
	
}


//Used to prevent doubling drawing code for drawable types
abstract class RenderTarget
{
	package sfRenderWindow* WindowPtr;
	package sfRenderTexture* TexturePtr;
	
	package bool IsRenderWindow;
	
	void draw(Drawable drawable, RenderStates states = RenderStates.Default());
	
	void draw(const Vertex[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default());
}

class RenderTexture:RenderTarget
{
	
	package alias TexturePtr sfPtr;
	
	this(uint width, uint height, bool depthBuffer = false)
	{
		sfPtr = (depthBuffer)? sfRenderTexture_create(width, height, sfTrue): sfRenderTexture_create(width, height,sfFalse);
		IsRenderWindow = false;
	}
	
	~this()
	{
		debug writeln("Destroying Render Texture");
		sfRenderTexture_destroy(sfPtr);
	}
	
	@property
	{
		void smooth(bool newSmooth)
		{
			(newSmooth)?sfRenderTexture_setSmooth(sfPtr, sfTrue):sfRenderTexture_setSmooth(sfPtr, sfFalse);			
		}
		bool smooth()
		{
			return (sfRenderTexture_isSmooth(sfPtr) == sfTrue)? true:false;
		}
	}
	
	Vector2u getSize()
	{
		return Vector2u(sfRenderTexture_getSize(sfPtr));	
	}
	
	void setActive(bool active = true)
	{
	(active)?sfRenderTexture_setActive(sfPtr,sfTrue):sfRenderTexture_setActive(sfPtr, sfFalse);
	}
	
	@property
	{
		void view(View newView)
		{
			sfRenderTexture_setView(sfPtr, newView.sfPtr);
		}
		View view()
		{
			//try to fix
			return new View( sfView_copy(sfRenderTexture_getView(sfPtr)));
			
		}
	} 
	
	View getDefaultView()
	{
		return new View( sfView_copy(sfRenderTexture_getDefaultView(sfPtr)));
	}
	
	
	Vector2f mapPixelToCoords(Vector2i point)//second version with a view parameter
	{
		sfVector2f temp = sfRenderTexture_mapPixelToCoords(sfPtr, sfVector2i(point.x, point.y), sfRenderTexture_getView(sfPtr));
		return Vector2f(temp.x, temp.y);
	}
	
	Vector2i mapCoordsToPixel(Vector2f point)
	{
		return Vector2i(0,0);
	}
	
	
	IntRect getViewport(View view)
	{
		
		sfIntRect temp = sfRenderTexture_getViewport(sfPtr, view.sfPtr);
		
		return IntRect(temp.left, temp.top, temp.width, temp.height);
	}
	
	
	const(Texture) getTexture()
	{
		//Will be fixed in Revision 2
		return new Texture(sfTexture_copy(sfRenderTexture_getTexture(sfPtr)));
	}
	
	
	override void draw(Drawable drawable, RenderStates states = RenderStates.Default())
	{
		
		drawable.draw(this, states);
	}
	
	override void draw(const Vertex[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default())
	{
		sfRenderTexture_drawPrimitives(sfPtr, vertices.ptr, cast(uint)min(uint.max, vertices.length),type,&states.InternalsfRenderStates);
	}
	
	void display()
	{
		
		
		sfRenderTexture_display(sfPtr);
	}
	
	void Clear(Color color)
	{
		sfRenderTexture_clear(sfPtr, color);
	}
	
	
	
}

class RenderWindow:RenderTarget
{
	
	package alias WindowPtr sfPtr;
	
	this(VideoMode mode, string title, uint style = Window.Style.DefaultStyle,  ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfRenderWindow_create(mode.tosfVideoMode(),toStringz(title),style,&settings);
		IsRenderWindow = true;
	}
	
	//in order to envoke this constructor when using string literals, be sure to use the d suffix, i.e. "素晴らしい ！"d
	this(VideoMode mode, dstring title, uint style = Window.Style.DefaultStyle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfRenderWindow_createUnicode(mode.tosfVideoMode(), toUint32Ptr(title),style, &settings);
		IsRenderWindow = true;
	}
	
	this(WindowHandle handle, ref const(ContextSettings) settings = ContextSettings.Default)
	{
		sfPtr = sfRenderWindow_createFromHandle(handle,&settings);
		IsRenderWindow = true;
	}
	
	~this()
	{
		debug writeln("Destroying Render Window");
		sfRenderWindow_destroy(sfPtr);
	}
	
	
	public bool pollEvent( ref Event event)
	{
		return ( sfRenderWindow_pollEvent(sfPtr, &event.InternalsfEvent) == sfTrue)?true:false;
		
	}
	
	bool waitEvent(ref Event event)
	{
		return (sfRenderWindow_waitEvent(sfPtr, &event.InternalsfEvent) == sfTrue) ? true: false;
	}
	
	public void setTitle(string newTitle)
	{
		sfRenderWindow_setTitle(sfPtr,toStringz(newTitle));
	}
	
	public void setTitle(dstring newTitle)
	{
		sfRenderWindow_setUnicodeTitle(sfPtr, toUint32Ptr(newTitle));
	}
	
	public void setIcon(uint width, uint height, ref const(ubyte)[] pixels)
	{
		sfRenderWindow_setIcon(sfPtr, width, height, pixels.ptr);
	}
	
	
	const(ContextSettings) getSettings()
	{
		return sfRenderWindow_getSettings(sfPtr);
	}
	
	@property
	{
		void position(Vector2i newPosition)
		{
			sfRenderWindow_setPosition(sfPtr,newPosition.tosfVector2i());
		}
		
		Vector2i position()
		{
			return Vector2i(sfRenderWindow_getPosition(sfPtr));
		}
	}
	
	
	@property
	{
		void size(Vector2u newSize)
		{
			sfRenderWindow_setSize(sfPtr, newSize.tosfVector2u());
		}
		Vector2u size()
		{
			return Vector2u(sfRenderWindow_getSize(sfPtr));
		}
	}
	
	@property
	{
		void view(View newView)
		{
			sfRenderWindow_setView(sfPtr, newView.sfPtr);
		}
		View view()
		{
			return new View( sfView_copy(sfRenderWindow_getView(sfPtr)));
			
		}
	} 

	
	void setMouseCursorVisible(bool visible)
	{
		visible ? sfRenderWindow_setMouseCursorVisible(sfPtr,sfTrue): sfRenderWindow_setMouseCursorVisible(sfPtr,sfFalse);
	}
	
	void setKeyRepeatEnabled(bool enabled)
	{
		enabled ? sfRenderWindow_setKeyRepeatEnabled(sfPtr,sfTrue):sfRenderWindow_setKeyRepeatEnabled(sfPtr,sfFalse);
	}
	
	void setFramerateLimit(uint limit)
	{
		sfRenderWindow_setFramerateLimit(sfPtr, limit);
	}
	
	void setJoystickThreshhold(float threshhold)
	{
		sfRenderWindow_setJoystickThreshold(sfPtr, threshhold);
	}
	
	WindowHandle getSystemHandle() const
	{
		return sfRenderWindow_getSystemHandle(sfPtr);
	}
	
	bool isOpen()
	{
		return (sfRenderWindow_isOpen(sfPtr) == sfTrue)? true: false;
	}
	
	override void draw(Drawable drawable, RenderStates states = RenderStates.Default())
	{	
		drawable.draw(this, states);
	}
	
	override void draw(const Vertex[] vertices, PrimitiveType type, RenderStates states = RenderStates.Default())
	{
		sfRenderWindow_drawPrimitives(sfPtr, vertices.ptr, cast(uint)min(uint.max, vertices.length), type, &states.InternalsfRenderStates);
	}
	
	void setVerticalSyncEnabled(bool enabled)
	{
		enabled ? sfRenderWindow_setVerticalSyncEnabled(sfPtr, sfTrue): sfRenderWindow_setVerticalSyncEnabled(sfPtr, sfFalse);
	}
	
	void display()
	{
		sfRenderWindow_display(sfPtr);
	}
	
	void setVisible(bool isVisible = true)
	{
	isVisible?sfRenderWindow_setVisible(sfPtr,sfTrue):sfRenderWindow_setVisible(sfPtr,sfFalse);
		
	}
	
	void setActive(bool active = true)
	{
	active?sfRenderWindow_setActive(sfPtr,sfTrue):sfRenderWindow_setActive(sfPtr,sfFalse);
		
	}
	
	void clear(Color color)
	{
		sfRenderWindow_clear(sfPtr, color);
		
	}
	
	void close()
	{
		sfRenderWindow_close(sfPtr);
	}
	
	static Vector2i mousePosition(const(RenderWindow) relativeTo)
	{
		return Vector2i(sfMouse_getPositionRenderWindow(relativeTo.sfPtr));
	}
	
	static void setMousePosition(Vector2i position, const(RenderWindow) relativeTo)
	{
		sfMouse_setPositionRenderWindow(position.tosfVector2i(),relativeTo.sfPtr);
	}
	
	
	
}

class Shader
{
	enum Type
	{
		Vertex,
		Fragment
	}
	struct CurrentTextureType {};
	
	static CurrentTextureType CurrentTexture;
	
	
	package sfShader* sfPtr;
	
	
	//creates a null shader
	this()
	{
		
	}
	
	package this(sfShader* shader)
	{
		sfPtr = shader;
		
	}
	
	~this()
	{
		debug writeln("Destroying Shader");
		sfShader_destroy(sfPtr);
	}
	
	bool loadFromFile(string filename, Type type)
	{
		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromFile(toStringz(filename) , null);
		}
		else
		{
			sfPtr = sfShader_createFromFile(null , toStringz(filename) );
		}
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromFile(string vertexShaderFilename, string fragmentShaderFilename)
	{
		sfPtr = sfShader_createFromFile(toStringz(vertexShaderFilename) , toStringz(fragmentShaderFilename));
		//exception
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromMemory(char[] shader, Type type)
	{
		
		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromMemory(toStringz(shader) , null);
		}
		else
		{
			sfPtr = sfShader_createFromMemory(null , toStringz(shader) );
		}
		
		return (sfPtr == null)?false:true;
	}
	
	
	bool loadFromMemory(string vertexShader, string fragmentShader)
	{
		sfShader_createFromMemory(toStringz(vertexShader) , toStringz(fragmentShader));
		return (sfPtr == null)?false:true;
	}
	
	
	bool loadFromStream(ref sfInputStream stream, Type type)
	{
		
		if(type == Type.Vertex)
		{
			sfPtr = sfShader_createFromStream(&stream , null);
		}
		else
		{
			sfPtr = sfShader_createFromStream(null , &stream );
		}
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromStream(ref sfInputStream vertexShaderStream, ref sfInputStream fragmentShaderStream)
	{
		sfPtr = sfShader_createFromStream(&vertexShaderStream, &fragmentShaderStream);  
		return (sfPtr == null)?false:true;
	}
	
	void setParameter(string name, float x)
	{
		sfShader_setFloatParameter(sfPtr, toStringz(name), x);
	}
	
	void setParameter(string name, float x, float y)
	{
		sfShader_setFloat2Parameter(sfPtr, toStringz(name), x, y);
	}
	
	void setParameter(string name, float x, float y, float z)
	{
		sfShader_setFloat3Parameter(sfPtr, toStringz(name), x,y,z);
	}
	
	void setParameter(string name, float x, float y, float z, float w)
	{
		sfShader_setFloat4Parameter(sfPtr, toStringz(name), x, y, z, w);
	}
	
	void setParameter(string name, Vector2f vector)
	{
		sfShader_setVector2Parameter(sfPtr, toStringz(name), vector.tosfVector2f());
	}
	
	void setParameter(string name, Vector3f vector)
	{
		sfShader_setVector3Parameter(sfPtr, toStringz(name), vector.tosfVector3f());
	}
	
	void setParameter(string name, Color color)
	{
		sfShader_setColorParameter(sfPtr, toStringz(name), color);
	}
	
	void setParameter(string name, Transform transform)
	{
		sfShader_setTransformParameter(sfPtr, toStringz(name), transform.InternalsfTransform);
	}
	
	void setParameter(string name, Texture texture)
	{
		sfShader_setTextureParameter(sfPtr, toStringz(name), texture.sfPtr);
	}
	
	void setParameter(string name, CurrentTextureType)
	{
		sfShader_setCurrentTextureParameter(sfPtr, toStringz(name));
	}
	
	
	static void bind(Shader shader)
	{
		(shader is null)?sfShader_bind(null):sfShader_bind(shader.sfPtr);
	}
	
	static bool isAvailable()
	{
		return (sfShader_isAvailable() == sfTrue)?true:false;
	}
	
}


class Shape:DrawableTransformable
{
	private Vector2f computeNormal(Vector2f p1, Vector2f p2)
	{
		Vector2f normal = Vector2f(p1.y - p2.y, p2.x - p1.x);
		float length = sqrt(normal.x * normal.x + normal.y * normal.y);
		if (length != 0f)
		{
			normal /= length;
		}
		return normal;
	}
	
	private float dotProduct(Vector2f p1, Vector2f p2)
	{
		return (p1.x * p2.x) + (p1.y * p2.y);
	}
	
	void setTexture(const(Texture) texture, bool resetRect)
	{
		if((texture !is null) && (resetRect || (m_texture is null)))
		{
			textureRect = IntRect(0, 0, texture.getSize().x, texture.getSize().y);
		}
		
		//texture is only used as constant data, so this is safe
		m_texture = (texture is null)? null:cast(Texture)texture;
		
	}
	//get texture
	const(Texture) getTexture() const
	{
		return m_texture;
	}
	
	@property
	{
		//Set Texture Rect
		void textureRect(IntRect rect)
		{
			m_textureRect = rect;
			updateTexCoords();
		}
		//get texture Rect
		IntRect textureRect() const
		{
			return m_textureRect;
		}
	}
	
	@property
	{
		//set Fill color
		void fillColor(Color color)
		{
			m_fillColor = color;
			updateFillColors();
		}
		//get fill color
		Color fillColor() const
		{
			return m_fillColor;
		}
	}
	
	@property
	{
		//set outline color
		void outlineColor(Color color)
		{
			m_outlineColor = color;
			updateOutlineColors();
		}
		//get outline color
		Color outlineColor() const
		{
			return m_outlineColor;
		}
	}
	
	@property
	{
		//set ouline thickness
		void outlineThickness(float thickness)
		{
			m_outlineThickness = thickness;
			update();
		}
		//get outline thickness
		float outlineThickness() const
		{
			return m_outlineThickness;
		}
	}
	
	@property
	{
		abstract uint pointCount();
	}
	
	abstract Vector2f getPoint(uint index);
	
	//get local bounds
	FloatRect getLocalBounds() const
	{
		return m_bounds;
	}
	
	//get global bounds
	FloatRect getGlobalBounds() 
	{
		return getTransform().transformRect(getLocalBounds());
	}
	
	override void draw(RenderTarget renderTarget, ref RenderStates renderStates)
	{
		
		renderStates.transform = renderStates.transform * getTransform();
		
		// Render the inside
		//
		renderStates.texture = m_texture;
		
		
		renderTarget.draw(m_vertices, renderStates);
		
		// Render the outline
		if (m_outlineThickness != 0)
		{
			renderStates.texture = null;
			renderTarget.draw(m_outlineVertices, renderStates);
		}
		
		
	}
	
	protected void update()
	{
		// Get the total number of points of the shape
		uint count = pointCount();
		if (count < 3)
		{
			m_vertices.resize(0);
			m_outlineVertices.resize(0);
			return;
		}
		
		m_vertices.resize(count + 2); // + 2 for center and repeated first point
		
		// Position
		for (uint i = 0; i < count; ++i)
		{
			m_vertices[i + 1].position = getPoint(i);
		}
		m_vertices[count + 1].position = m_vertices[1].position;
		
		// Update the bounding rectangle
		m_vertices[0] = m_vertices[1]; // so that the result of getBounds() is correct
		m_insideBounds = m_vertices.getBounds();
		
		
		
		// Compute the center and make it the first vertex
		m_vertices[0].position.x = m_insideBounds.left + m_insideBounds.width / 2;
		m_vertices[0].position.y = m_insideBounds.top + m_insideBounds.height / 2;
		
		// Color
		updateFillColors();
		
		// Texture coordinates
		updateTexCoords();
		
		// Outline
		updateOutline();
	}
	
	private
	{
		//update methods
		
		void updateFillColors()
		{
			for(uint i = 0; i < m_vertices.getVertexCount(); ++i)
			{
				m_vertices[i].color = m_fillColor;
			}
		}
		
		void updateTexCoords()
		{
			
			for (uint i = 0; i < m_vertices.getVertexCount(); ++i)
			{
				float xratio = (m_vertices[i].position.x - m_insideBounds.left) / m_insideBounds.width;
				float yratio = (m_vertices[i].position.y - m_insideBounds.top) / m_insideBounds.height;
				
				m_vertices[i].texCoords.x = m_textureRect.left + m_textureRect.width * xratio;
				m_vertices[i].texCoords.y = m_textureRect.top + m_textureRect.height * yratio;
				
			}
			
			
		}
		
		void updateOutline()
		{
			uint count = m_vertices.getVertexCount() - 2;
			m_outlineVertices.resize((count + 1) * 2);
			
			for (uint i = 0; i < count; ++i)
			{
				uint index = i + 1;
				
				// Get the two segments shared by the current point
				Vector2f p0 = (i == 0) ? m_vertices[count].position : m_vertices[index - 1].position;
				Vector2f p1 = m_vertices[index].position;
				Vector2f p2 = m_vertices[index + 1].position;
				
				// Compute their normal
				Vector2f n1 = computeNormal(p0, p1);
				Vector2f n2 = computeNormal(p1, p2);
				
				// Make sure that the normals point towards the outside of the shape
				// (this depends on the order in which the points were defined)
				if (dotProduct(n1, m_vertices[0].position - p1) > 0)
					n1 = -n1;
				if (dotProduct(n2, m_vertices[0].position - p1) > 0)
					n2 = -n2;
				
				// Combine them to get the extrusion direction
				float factor = 1f + (n1.x * n2.x + n1.y * n2.y);
				Vector2f normal = (n1 + n2) / factor;
				
				// Update the outline points
				m_outlineVertices[i * 2 + 0].position = p1;
				m_outlineVertices[i * 2 + 1].position = p1 + normal * m_outlineThickness;
			}
			
			// Duplicate the first point at the end, to close the outline
			m_outlineVertices[count * 2 + 0].position = m_outlineVertices[0].position;
			m_outlineVertices[count * 2 + 1].position = m_outlineVertices[1].position;
			
			// Update outline colors
			updateOutlineColors();
			
			// Update the shape's bounds
			m_bounds = m_outlineVertices.getBounds();
		}
		
		void updateOutlineColors()
		{
			for (uint i = 0; i < m_outlineVertices.getVertexCount(); ++i)
			{
				m_outlineVertices[i].color = m_outlineColor;
			}
		}
		
		this()
		{
			m_vertices = new VertexArray(PrimitiveType.TrianglesFan,0);
			m_outlineVertices = new VertexArray(PrimitiveType.TrianglesStrip,0);
		}
		
		//Member data
		//Can't make m_texture const, as const data can only be initialized in a constructor
		Texture m_texture; /// Texture of the shape
		IntRect m_textureRect; /// Rectangle defining the area of the source texture to display
		Color m_fillColor; /// Fill color
		Color m_outlineColor; /// Outline color
		float m_outlineThickness; /// Thickness of the shape's outline
		VertexArray m_vertices; /// Vertex array containing the fill geometry
		VertexArray m_outlineVertices; /// Vertex array containing the outline geometry
		FloatRect m_insideBounds; /// Bounding rectangle of the inside (fill)
		FloatRect m_bounds; /// Bounding rectangle of the whole shape (outline + fill)
	}
}


class Sprite:Drawable
{
	package sfSprite* sfPtr;
	
	
	this(Texture texture)
	{
		// Constructor code
		
		sfPtr = sfSprite_create();
		
		sfSprite_setTexture(sfPtr, texture.sfPtr, sfTrue);
	}
	
	
	package this(sfSprite* sprite)
	{
		sfPtr = sprite;
	}
	
	Sprite dup() const
	{
		return new Sprite(sfSprite_copy(sfPtr));
	}
	@property
	{
		void position(Vector2f newPosition)
		{
			sfSprite_setPosition(sfPtr, newPosition.tosfVector2f());
		}
		
		Vector2f position()//get position
		{
			
			return Vector2f( sfSprite_getPosition(sfPtr));
		}
	}
	
	@property//scale
	{
		void scale(Vector2f newScale)
		{
			sfSprite_setScale(sfPtr,newScale.tosfVector2f());
		}
		
		Vector2f scale()
		{
			
			return Vector2f( sfSprite_getScale(sfPtr) );
		}
	}
	
	@property//rotation
	{
		void rotation(float newRotation)
		{
			sfSprite_setRotation(sfPtr, newRotation);
		}
		float rotation()
		{
			return sfSprite_getRotation(sfPtr);
		}
	}
	
	@property//origin
	{
		void origin(Vector2f newOrigin)
		{
			sfSprite_setOrigin(sfPtr, newOrigin.tosfVector2f());
		}
		Vector2f origin()
		{
			return Vector2f(sfSprite_getOrigin(sfPtr));
		}
	}
	
	
	Transform getTransform()
	{
		return Transform(sfSprite_getTransform(sfPtr));
	}
	
	Transform getInverseTransform()
	{
		return Transform(sfSprite_getInverseTransform(sfPtr));
	}
	
	
	void setTexture(const(Texture) texture, bool rectReset = false)
	{
		rectReset?sfSprite_setTexture(sfPtr,texture.sfPtr, sfTrue):sfSprite_setTexture(sfPtr,texture.sfPtr, sfFalse);
	}
	const(Texture) getTexture()
	{
		//will be fixed in Revision 2(especially if it returns a null pointer)
		return new Texture(sfTexture_copy(sfSprite_getTexture(sfPtr)));
	}
	
	@property
	{
		void textureRect(IntRect rect)
		{
			sfSprite_setTextureRect(sfPtr, rect.tosfIntRect());
		}
		
		IntRect textureRect()
		{
			sfIntRect temp = sfSprite_getTextureRect(sfPtr);
			
			return IntRect(temp.left,temp.top,temp.width, temp.height);
		}
	}
	
	@property//color
	{
		void color(Color newColor)
		{
			sfSprite_setColor(sfPtr, newColor);
		}
		
		Color color()
		{
			return sfSprite_getColor(sfPtr);
		}
		
	}
	
	//will fix these before Revision 2
	FloatRect getLocalBounds()
	{
		sfFloatRect temp = sfSprite_getLocalBounds(sfPtr);
		return FloatRect(temp.left,temp.top,temp.width, temp.height);
	}
	
	FloatRect getGlobalBounds()
	{
		sfFloatRect temp = sfSprite_getGlobalBounds(sfPtr);
		return FloatRect(temp.left,temp.top,temp.width, temp.height);
	}
	
	override void draw(RenderTarget renderTarget, ref RenderStates renderStates)// const
	{
		
		renderTarget.IsRenderWindow?
			sfRenderWindow_drawSprite(renderTarget.WindowPtr,sfPtr, &renderStates.InternalsfRenderStates):
			sfRenderTexture_drawSprite(renderTarget.TexturePtr, sfPtr, &renderStates.InternalsfRenderStates);
		
	}
	
	
	~this()
	{
		debug writeln("Destroying Sprite");
		sfSprite_destroy(sfPtr);
	}
	
}


class Text:Drawable
{
	enum Style
	{
		Regular = 0,
		Bold = 1 << 0,
		Italic = 1 << 1,
		Underlined = 1 << 2 
	}
	
	package sfText* sfPtr;
	private Font font_;
	private const(void)* string_;
	
	
	this(string String, const(Font) font, uint characterSize=30)
	{
		
		
		sfPtr = sfText_create();
		
		//set string
		
		sfText_setString(sfPtr,toStringz(String));
		
		//set font
		
		sfText_setFont(sfPtr, font.sfPtr);
		
		//set character size
		
		sfText_setCharacterSize(sfPtr, characterSize);
		
		font_ = cast(Font)font;
		
	}
	
	
	@property
	{
		void position(Vector2f newPosition)
		{
			sfText_setPosition(sfPtr, sfVector2f(newPosition.x, newPosition.y));
		}
		
		Vector2f position()
		{
			return Vector2f(sfText_getPosition(sfPtr));
		}
	}
	
	
	@property
	{
		void scale(Vector2f newScale)
		{
			sfText_setScale(sfPtr, newScale.tosfVector2f());
		}
		
		Vector2f scale()
		{
			return Vector2f(sfText_getScale(sfPtr));
		}		
	}
	
	@property
	{
		void origin(Vector2f newOrigin)
		{
			sfText_setOrigin(sfPtr,newOrigin.tosfVector2f());
		}
		
		Vector2f origin()
		{
			return Vector2f(sfText_getOrigin(sfPtr));		
		}
	}
	
	@property
	{
		void rotation(float newRotation)
		{
			sfText_setRotation(sfPtr, newRotation);
		}
		
		float rotation()
		{
			return sfText_getRotation(sfPtr);
		}
	}
	
	@property
	{
		void color(Color newColor)
		{
			sfText_setColor(sfPtr, newColor);
		}
		Color color()
		{
			return sfText_getColor(sfPtr);
		}
	}
	
	
	
	
	@property
	{
		void style(Style newStyle)
		{
			sfText_setStyle(sfPtr,newStyle);
		}
		Style style()
		{
			return sfText_getStyle(sfPtr);
		}
	}
	
	
	
	@property
	{
		void String(string newString)
		{
			string_ = toStringz(newString);
			sfText_setString(sfPtr, cast(immutable(char)*)string_);
		}
		
		string String()
		{			
			return text(cast(immutable(char)*)string_);			
		}
	}
	
	@property
	{
		void unicodeString(dstring newUnicodeString)
		{
			string_ = toUint32Ptr(newUnicodeString);
			sfText_setUnicodeString(sfPtr, cast(const(uint)*)string_);
		}
		
		dstring unicodeString()
		{
			return dtext(cast(immutable(dchar)*)string_);
		}
	}
	
	
	@property
	{
		void font(const(Font) newFont)
		{
			font_ = cast(Font)newFont;
			sfText_setFont(sfPtr, newFont.sfPtr);
		}
		const(Font) font()
		{
			return cast(const(Font))font_;
		}
	}
	
	@property
	{
		void characterSize(uint size)
		{
			sfText_setCharacterSize(sfPtr, size);
		}
		uint characterSize()
		{
			return sfText_getCharacterSize(sfPtr);
		}
	}
	
	override void draw(RenderTarget renderTarget, ref RenderStates renderStates)
	{
		renderTarget.IsRenderWindow?
			sfRenderWindow_drawText(renderTarget.WindowPtr, sfPtr,&renderStates.InternalsfRenderStates):
			sfRenderTexture_drawText(renderTarget.TexturePtr, sfPtr,&renderStates.InternalsfRenderStates);
	}
	
	~this()
	{
		debug writeln("Destroying Text");
		sfText_destroy(sfPtr);
	}
	
}


class Texture
{
	
	package sfTexture* sfPtr;
	
	
	this()
	{
		//Creates a null Texture
	}
	
	package this(sfTexture* texturePointer)
	{
		sfPtr = texturePointer;
	}
	
	bool create(uint height, uint width)
	{
		sfPtr = sfTexture_create(width, height);
		return (sfPtr == null)?false:true;
	}
	
	bool loadFromFile(string filename, IntRect area = IntRect() )
	{
		sfIntRect sfArea= area.tosfIntRect();
		sfPtr = sfTexture_createFromFile(toStringz(filename) ,&sfArea);
		return (sfPtr == null)?false:true;
	}
	
	this(const(void)* data, size_t sizeInBytes, IntRect area = IntRect())
	{
		sfIntRect sfArea= area.tosfIntRect();
		sfPtr = sfTexture_createFromMemory(data,sizeInBytes,&sfArea);
	}
	
	this(ref sfInputStream stream, IntRect area = IntRect())
	{
		sfIntRect sfArea= area.tosfIntRect();
		sfPtr = sfTexture_createFromStream(&stream, &sfArea);
	}
	
	this(Image image, IntRect area = IntRect())
	{
		sfIntRect sfArea= area.tosfIntRect();
		sfPtr = sfTexture_createFromImage(image.sfPtr, &sfArea);
	}
	
	
	Texture dup() const
	{
		return new Texture(sfTexture_copy(sfPtr));
	}
	
	Vector2u getSize() const
	{
		return Vector2u( sfTexture_getSize(sfPtr));
	}
	
	void updateFromPixels(const(ubyte)[] pixels, uint width, uint height, uint x, uint y)
	{
		sfTexture_updateFromPixels(sfPtr,pixels.ptr,width, height, x,y);
	}
	
	void updateFromImage(Image image, uint x, uint y)
	{
		sfTexture_updateFromImage(sfPtr, image.sfPtr, x, y);
	}
	
	void updateFromWindow(Window window, uint x, uint y)
	{
		sfTexture_updateFromWindow(sfPtr, window.sfPtr, x, y);
	}
	void updateFromWindow(RenderWindow window, uint x, uint y)
	{
		sfTexture_updateFromRenderWindow(sfPtr, window.sfPtr, x, y);
	}
	
	
	Image copyToImage()
	{
		return new Image(sfTexture_copyToImage(sfPtr));
	}
	
	void setSmooth(bool smooth)
	{
		smooth?sfTexture_setSmooth(sfPtr, sfTrue):sfTexture_setSmooth(sfPtr, sfFalse);
	}
	
	bool isSmooth() const
	{
		return (sfTexture_isSmooth(sfPtr) == sfTrue)?true:false;
	}
	
	void setRepeated(bool repeated)
	{
		repeated?sfTexture_setRepeated(sfPtr, sfTrue):sfTexture_setRepeated(sfPtr, sfFalse);
	}
	
	bool isRepeated() const
	{
		return (sfTexture_isRepeated(sfPtr) == sfTrue)?true:false;
	}
	
	
	static void bind(Texture texture)
	{
		(texture is null)?sfTexture_bind(null):sfTexture_bind(texture.sfPtr);
	}
	
	~this()
	{
		
		debug writeln("Destroying Texture");
		sfTexture_destroy( sfPtr);
		
	}
	
	
	
}


class VertexArray:Drawable
{
	
	PrimitiveType primativeType;
	private Vertex[] Vertices;
	
	
	this(PrimitiveType type, uint vertexCount)
	{
		primativeType = type;
		
		Vertices = new Vertex[vertexCount];
	}
	
	private this(PrimitiveType type, Vertex[] vertices)
	{
		primativeType = type;
		
		Vertices = vertices;
	}
	
	~this()
	{
		debug writeln("Destroying Vertex Array");
	}
	
	VertexArray dup() const
	{
		return new VertexArray(this.primativeType,Vertices.dup);
	}
	
	
	ref Vertex opIndex(size_t index)
	{
		return Vertices[index];
	}
	
	
	void append(Vertex newVertex)
	{
		Vertices ~= newVertex;
	}
	void clear()
	{
		Vertices.length = 0;
	}
	
	void resize(uint length)
	{
		Vertices.length = length;
	}
	
	uint getVertexCount()
	{
		return cast(uint)min(uint.max, Vertices.length);
	}
	
	
	FloatRect getBounds()
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
	
	
	override void draw(RenderTarget renderTarget, ref RenderStates renderStates)
	{
		if(Vertices.length != 0)
		{
			renderTarget.IsRenderWindow?
				sfRenderWindow_drawPrimitives(renderTarget.WindowPtr,Vertices.ptr,cast(uint)min(uint.max, Vertices.length),primativeType,&renderStates.InternalsfRenderStates):
				sfRenderTexture_drawPrimitives(renderTarget.TexturePtr,Vertices.ptr,cast(uint)min(uint.max, Vertices.length),primativeType,&renderStates.InternalsfRenderStates);
		}
		
	}
	
	
}


class View
{
	sfView* sfPtr;

	this()
	{
		// Constructor code
		sfPtr = sfView_create();
		
		sfView_reset(sfPtr, sfFloatRect(0,0,1000,1000));
	}
	this(FloatRect rectangle)
	{
		
		sfPtr = sfView_createFromRect(sfFloatRect(rectangle.left,rectangle.top, rectangle.width, rectangle.height));
	}
	
	package this(sfView* sfview)
	{
		sfPtr = sfview;
	}
	
	
	View dup() const
	{
		return new View(sfView_copy(sfPtr));
	}
	
	
	@property
	{
		void center(Vector2f newCenter)
		{
			sfView_setCenter(sfPtr, newCenter.tosfVector2f());
		}
		
		Vector2f center()
		{
			return  Vector2f(sfView_getCenter(sfPtr));
		}		
	}
	
	@property
	{
		void size(Vector2f newSize)
		{
			sfView_setSize(sfPtr, newSize.tosfVector2f());
		}
		
		Vector2f size()
		{
			return Vector2f(sfView_getSize(sfPtr));
		}
	}
	
	@property
	{
		void rotation(float newRotation)
		{
			sfView_setRotation(sfPtr, newRotation);
		}
		float rotation()
		{
			return sfView_getRotation(sfPtr);
			
		}
	}
	
	@property
	{
		void viewport(FloatRect newTarget)
		{
			sfView_setViewport(sfPtr, sfFloatRect(newTarget.left, newTarget.top, newTarget.width, newTarget.height));
		}
		FloatRect viewport()
		{
			return FloatRect(sfView_getViewport(sfPtr));
		}
	}
	
	void reset(FloatRect rectangle)
	{
		sfView_reset(sfPtr, sfFloatRect(rectangle.left,rectangle.top, rectangle.width, rectangle.height));
	}
	
	
	void zoom(float factor)
	{
		sfView_zoom(sfPtr, factor);
	}
	
	
}



struct Rect(T)
	if(isNumeric!(T))
{
	T left;
	T top;
	T width;
	T height;
	
	
	this(T rectLeft, T rectTop, T rectWidth, T rectHeight)
	{
		left = rectLeft;
		top = rectTop;
		width = rectWidth;
		height = rectHeight;
		
	}
	
	this(Vector2!(T) position, Vector2!(T) size)
	{
		left = position.x;
		top = position.y;
		width = size.x;
		height = size.y;
	}
	
	package this(sfIntRect rect)
	{
		left = cast(T)rect.left;
		top = cast(T)rect.top;
		width = cast(T)rect.width;
		height = cast(T)rect.height;
	}
	
	package this(sfFloatRect rect)
	{
		left = cast(T)rect.left;
		top = cast(T)rect.top;
		width = cast(T)rect.width;
		height = cast(T)rect.height;
	}
	
	bool contains(E)(E X, E Y)
	if(isNumeric!(E))
	{
		if(left <= X && X<= (left + width))
		{
			if(top <= Y && Y <= (top + height))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	bool contains(E)(Vector2!(E) point)
	if(isNumeric!(E))
	{
		if(left <= point.x && point.x<= (left + width))
		{
			if(top <= point.y && point.y <= (top + height))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	bool intersects(E)(Rect!(E) rectangle)
	if(isNumeric!(E))
	{
		Rect!(T) rect;
		
		return intersects(rectangle, rect);
	}
	
	bool intersects(E,O)(Rect!(E) rectangle, out Rect!(O) intersection)
	if(isNumeric!(E) && isNumeric!(O))
	{
		O interLeft = intersection.max(left, rectangle.left);
		O interTop = intersection.max(top, rectangle.top);
		O interRight = intersection.min(left + width, rectangle.left + rectangle.width);
		O interBottom = intersection.min(top + height, rectangle.top + rectangle.height);
		
		if ((interLeft < interRight) && (interTop < interBottom))
		{
			intersection = Rect!(O)(interLeft, interTop, interRight - interLeft, interBottom - interTop);
			return true;
		}
		else
		{
			intersection = Rect!(O)(0, 0, 0, 0);
			return false;
		}
	}
	
	
	string toString()
	{
		return "Left: " ~ text(left) ~ " Top: " ~ text(top) ~ " Width: " ~ text(width) ~ " Height: " ~ text(height);
	}
	
	private T max(T a, T b)
	{
		if(a>b)
		{
			return a;
		}
		else
		{
			return b;
		}
	}
	
	private T min(T a, T b)
	{
		if(a<b)
		{
			return a;
		}
		else
		{
			return b;
		}
	}
	
	package sfIntRect tosfIntRect()
	{
		return sfIntRect(cast(int)left, cast(int)top, cast(int)width, cast(int)height);
	}
	
	package sfFloatRect tosfFloatRect()
	{
		return sfFloatRect(cast(float)left, cast(float)top, cast(float)width, cast(float)height);
	}
	
	
}

alias Rect!(int) IntRect;
alias Rect!(float) FloatRect;


struct Color
{
	ubyte r;
	ubyte g;
	ubyte b;
	ubyte a;
	
	static immutable Black = Color(0, 0, 0, 255);
	static immutable White = Color(255, 255, 255, 255);
	static immutable Red = Color(255, 0, 0, 255);
	static immutable Green = Color(0, 255, 0,255);
	static immutable Blue = Color(0, 0, 255,255);
	static immutable Yellow = Color(255, 255, 0, 255);
	static immutable Magenta = Color(255, 0, 255, 255);
	static immutable Cyan = Color(0, 255, 255, 255);
	static immutable  Transparent = Color(0, 0, 0, 0);
	
	Color opBinary(string op)(Color otherColor) const
	if((op == "+") || (op == "-"))
	{
		static if(op == "+")
		{
			return Color(cast(ubyte)min(r+otherColor.r, 255),
			             cast(ubyte)min(g+otherColor.g, 255),
			             cast(ubyte)min(b+otherColor.b, 255),
			             cast(ubyte)min(a+otherColor.a, 255));
		}
		static if(op == "-")
		{
			return Color(cast(ubyte)max(r-otherColor.r, 0),
			             cast(ubyte)max(g-otherColor.g, 0),
			             cast(ubyte)max(b-otherColor.b, 0),
			             cast(ubyte)max(a-otherColor.a, 0));
		}
	}
	
	Color opBinary(string op, E)(E num) const
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			return Color(cast(ubyte)min(r*num, 255),
			             cast(ubyte)min(g*num, 255),
			             cast(ubyte)min(b*num, 255),
			             cast(ubyte)min(a*num, 255));
		}
		static if(op == "/")
		{
			return Color(cast(ubyte)max(r/num, 0),
			             cast(ubyte)max(g/num, 0),
			             cast(ubyte)max(b/num, 0),
			             cast(ubyte)max(a/num, 0));
		}
	}
	
	ref Color opOpAssign(string op)(Color otherColor)
	if((op == "+") || (op == "-"))
	{
		static if(op == "+")
		{
			r = cast(ubyte)min(r+otherColor.r, 255);
			g = cast(ubyte)min(g+otherColor.g, 255);
			b = cast(ubyte)min(b+otherColor.b, 255);
			a = cast(ubyte)min(a+otherColor.a, 255);
			return this;
		}
		static if(op == "-")
		{
			r = cast(ubyte)max(r-otherColor.r, 0);
			g = cast(ubyte)max(g-otherColor.g, 0);
			b = cast(ubyte)max(b-otherColor.b, 0);
			a = cast(ubyte)max(a-otherColor.a, 0);
			return this;
		}
	}
	
	ref Color opOpAssign(string op, E)(E num)
	if(isNumeric!(E) && ((op == "*") || (op == "/")))
	{
		static if(op == "*")
		{
			r = cast(ubyte)min(r*num, 255);
			g = cast(ubyte)min(g*num, 255);
			b = cast(ubyte)min(b*num, 255);
			a = cast(ubyte)min(a*num, 255);
			return this;
		}
		static if(op == "/")
		{
			r = cast(ubyte)max(r/num, 0);
			g = cast(ubyte)max(g/num, 0);
			b = cast(ubyte)max(b/num, 0);
			a = cast(ubyte)max(a/num, 0);
			return this;
		}
	}
	
	bool opEquals(Color otherColor) const
	{
		return ((r == otherColor.r) && (g == otherColor.g) && (b == otherColor.b) && (a == otherColor.a));
	}
	
	string toString() const
	{
		return "R: " ~ text(r) ~ " G: " ~ text(g) ~ " B: " ~ text(b) ~ " A: " ~ text(a);
	}
}

struct Transform
{
	
	package sfTransform InternalsfTransform = sfTransform(
		[1.0f, 0.0f, 0.0f,
	 0.0f, 1.0f, 0.0f,
	 0.0f, 0.0f, 1.0f]);
	
	
	this(float a00, float a01, float a02, float a10, float a11, float a12, float a20, float a21, float a22)
	{
		InternalsfTransform = sfTransform(
			[a00, a01, a02,
		 a10, a11, a12,
		 a20, a21, a22]);
		
	}
	
	package this(sfTransform transform)
	{
		InternalsfTransform = transform;
	}
	
	@property 
	{
		float[] matrix()
		{
			return InternalsfTransform.matrix;
		}
	}
	
	const(float)[] getMatrix()
	{
		float[16] temp;
		
		sfTransform_getMatrix(&InternalsfTransform, temp.ptr);
		
		return temp.dup;
		
	}
	
	Transform getInverse() const
	{
		
		return Transform(sfTransform_getInverse(&InternalsfTransform));
	}
	
	Vector2f transformPoint(Vector2f point)
	{
		return Vector2f(sfTransform_transformPoint(&InternalsfTransform,sfVector2f(point.x, point.y)));		
	}
	
	FloatRect transformRect(const(FloatRect) rect)const
	{
		return FloatRect(sfTransform_transformRect(&InternalsfTransform, sfFloatRect(rect.left, rect.top, rect.width, rect.height)));
	}
	
	void combine(Transform otherTransform)
	{
		
		sfTransform_combine(&InternalsfTransform, &otherTransform.InternalsfTransform);
	}
	
	void translate(float x, float y)
	{
		sfTransform_translate(&InternalsfTransform, x, y);
	}
	
	void rotate(float angle)
	{
		sfTransform_rotate(&InternalsfTransform, angle);
		
	}
	
	void rotateWithCenter(float angle, float x, float y)
	{
		sfTransform_rotateWithCenter(&InternalsfTransform, angle, x, y);
	}
	
	void scale(float scaleX, float scaleY)
	{
		sfTransform_scale(&InternalsfTransform, scaleX, scaleY);
		
	}
	
	void scaleWithCenter(float scaleX, float scaleY, float centerX, float centerY)
	{
		sfTransform_scaleWithCenter(&InternalsfTransform, scaleX, scaleY, centerX, centerY);
	}
	
	
	string toString()
	{
		return text(InternalsfTransform.matrix);
	}
	
	Transform opBinary(string op)(Transform rhs)
	if(op == "*")
	{
		Transform temp = Transform(InternalsfTransform);
		temp.combine(rhs);
		return temp;
	}
	
	ref Transform opOpAssign(string op)(Transform rhs)
	if(op == "*")
	{
		
		this.combine(rhs);
		return this;
	}
	
	Transform opBinary(string op)(Vector2f vector)
	if(op == "*")
	{
		return transformPoint(vector);
	}
	
	static const(Transform) Identity;
	
}

interface Transformable
{
	
	@property
	{
		void position(Vector2f newPosition);
		Vector2f position() const;
	}
	
	@property
	{
		void rotation(float newRotation);
		float rotation() const;
	}
	
	@property
	{
		void scale(Vector2f newScale);
		Vector2f scale() const;
	}
	
	@property
	{
		void origin(Vector2f newOrigin);
		Vector2f origin() const;
	}
	
	const(Transform) getTransform();
	
	const(Transform) getInverseTransform();
	
}

mixin template NormalTransformable()
{
	@property
	{
		void position(Vector2f newPosition)
		{
			m_position = newPosition;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		Vector2f position() const
		{
			return m_position;
		}
	}
	
	@property
	{
		void rotation(float newRotation)
		{
			m_rotation = cast(float)fmod(newRotation, 360);
			if(m_rotation < 0)
			{
				m_rotation += 360;
			}
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		float rotation() const
		{
			return m_rotation;
		}
	}
	
	@property
	{
		void scale(Vector2f newScale)
		{
			m_scale = newScale;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		Vector2f scale() const
		{
			return m_scale;
		}
	}
	
	@property
	{
		void origin(Vector2f newOrigin)
		{
			m_origin = newOrigin;
			m_transformNeedUpdate = true;
			m_inverseTransformNeedUpdate = true;
		}
		
		Vector2f origin() const
		{
			return m_origin;
		}
	}
	
	const(Transform) getTransform()
	{
		
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
	
	const(Transform) getInverseTransform()
	{
		if (m_inverseTransformNeedUpdate)
		{
			m_inverseTransform = getTransform().getInverse();
			m_inverseTransformNeedUpdate = false;
		}
		
		return m_inverseTransform;
	}
	
	
	
	private 
	{
		Vector2f m_origin = Vector2f(0,0); ///< Origin of translation/rotation/scaling of the object
		Vector2f m_position = Vector2f(0,0); ///< Position of the object in the 2D world
		float m_rotation = 0; ///< Orientation of the object, in degrees
		Vector2f m_scale = Vector2f(1,1); ///< Scale of the object
		Transform m_transform; ///< Combined transformation of the object
		bool m_transformNeedUpdate; ///< Does the transform need to be recomputed?
		Transform m_inverseTransform; ///< Combined transformation of the object
		bool m_inverseTransformNeedUpdate; ///< Does the transform need to be recomputed?
	}
}

enum PrimitiveType
{
	Points,
	Lines,
	LinesStrip,
	Triangles,
	TrianglesStrip,
	TrianglesFan,
	Quads,
}

struct Vertex
{
	
	Vector2f position = Vector2f(0,0);
	Color color = Color.White;
	Vector2f texCoords = Vector2f(0,0);
	
	
	this(Vector2f thePosition)
	{
		position = thePosition;
	}
	this(Vector2f thePosition, Color theColor)
	{
		position = thePosition;
		color = theColor;
	}
	this(Vector2f thePosition, Vector2f theTexCoords)
	{
		position = thePosition;
		texCoords = theTexCoords;
	}
	
	this(Vector2f thePosition, Color theColor, Vector2f theTexCoords)
	{
		position = thePosition;
		color = theColor;
		texCoords = theTexCoords;
	}
	
	
}


package:


struct sfFont;
struct sfImage;
struct sfShader;
struct sfRenderTexture;
struct sfRenderWindow;
struct sfSprite;
struct sfText;
struct sfTexture;
struct sfTransformable;
struct sfVertexArray;
struct sfView;


struct sfFloatRect
{
	float left;
	float top;
	float width;
	float height;
}

struct sfIntRect
{
	int left;
	int top;
	int width;
	int height;
}

struct sfGlyph
{
	int advance;
	sfIntRect bounds;
	sfIntRect textureRect;
}

struct sfRenderStates
{
	BlendMode blendMode;
	sfTransform transform;
	const(sfTexture)* texture;
	const(sfShader)* shader;
}

struct sfTransform
{
	float[9] matrix;
}

extern(C)
{
	
	//Font
	sfFont* sfFont_createFromFile(const(char)* filename);
	sfFont* sfFont_createFromMemory(const(void)* data,size_t sizeInBytes);
	sfFont* sfFont_createFromStream(sfInputStream* stream);
	sfFont* sfFont_copy(const(sfFont)* font);
	void sfFont_destroy(sfFont* font);
	sfGlyph sfFont_getGlyph(sfFont* font,int codePoint,uint characterSize,sfBool bold);
	int sfFont_getKerning(sfFont* font,int first,int second,uint characterSize);
	int sfFont_getLineSpacing(sfFont* font,uint characterSize);
	const(sfTexture)* sfFont_getTexture(sfFont* font,uint characterSize);
	
	//Image
	sfImage* sfImage_create(uint width,uint height);
	sfImage* sfImage_createFromColor(uint width,uint height,Color color);
	sfImage* sfImage_createFromPixels(uint width,uint height,const(ubyte)* pixels);
	sfImage* sfImage_createFromFile(const(char)* filename);
	sfImage* sfImage_createFromMemory(const(void)* data,size_t size);
	sfImage* sfImage_createFromStream(sfInputStream* stream);
	sfImage* sfImage_copy(const(sfImage)* image);
	void sfImage_destroy(sfImage* image);
	sfBool sfImage_saveToFile(const(sfImage)* image,const(char)* filename);
	sfVector2u sfImage_getSize(const(sfImage)* image);
	void sfImage_createMaskFromColor(sfImage* image,Color color,byte alpha);
	void sfImage_copyImage(sfImage* image,const(sfImage)* source,uint destX,uint destY,sfIntRect sourceRect,sfBool applyAlpha);
	void sfImage_setPixel(sfImage* image,uint x,uint y,Color color);
	Color sfImage_getPixel(const(sfImage)* image,uint x,uint y);
	const(ubyte)* sfImage_getPixelsPtr(const(sfImage)* image);
	void sfImage_flipHorizontally(sfImage* image);
	void sfImage_flipVertically(sfImage* image);
	
	//Float and Int Rects
	sfBool sfFloatRect_contains(const(sfFloatRect)* rect,float x,float y);
	sfBool sfIntRect_contains(const(sfIntRect)* rect,int x,int y);
	sfBool sfFloatRect_intersects(const(sfFloatRect)* rect1,const(sfFloatRect)* rect2,sfFloatRect* intersection);
	sfBool sfIntRect_intersects(const(sfIntRect)* rect1,const(sfIntRect)* rect2,sfIntRect* intersection);
	
	//Render Texture
	sfRenderTexture* sfRenderTexture_create(uint width,uint height,sfBool depthBuffer);
	void sfRenderTexture_destroy(sfRenderTexture* renderTexture);
	sfVector2u sfRenderTexture_getSize(const(sfRenderTexture)* renderTexture);
	sfBool sfRenderTexture_setActive(sfRenderTexture* renderTexture,sfBool active);
	void sfRenderTexture_display(sfRenderTexture* renderTexture);
	void sfRenderTexture_clear(sfRenderTexture* renderTexture,Color color);
	void sfRenderTexture_setView(sfRenderTexture* renderTexture,const(sfView)* view);
	const(sfView)* sfRenderTexture_getView(const(sfRenderTexture)* renderTexture);
	const(sfView)* sfRenderTexture_getDefaultView(const(sfRenderTexture)* renderTexture);
	sfIntRect sfRenderTexture_getViewport(const(sfRenderTexture)* renderTexture,const(sfView)* view);
	sfVector2f sfRenderTexture_mapPixelToCoords(const(sfRenderTexture)* renderTexture,sfVector2i point,const(sfView)* view);
	sfVector2i sfRenderTexture_mapCoordsToPixel(const(sfRenderTexture)* renderTexture,sfVector2f point,const(sfView)* view);
	void sfRenderTexture_drawSprite(sfRenderTexture* renderTexture,const(sfSprite)* object,const(sfRenderStates)* states);
	void sfRenderTexture_drawText(sfRenderTexture* renderTexture,const(sfText)* object,const(sfRenderStates)* states);
	//void sfRenderTexture_drawShape(sfRenderTexture* renderTexture,const(sfShape)* object,const(sfRenderStates)* states);
	//void sfRenderTexture_drawCircleShape(sfRenderTexture* renderTexture,const(sfCircleShape)* object,const(sfRenderStates)* states);
	//void sfRenderTexture_drawConvexShape(sfRenderTexture* renderTexture,const(sfConvexShape)* object,const(sfRenderStates)* states);
	//void sfRenderTexture_drawRectangleShape(sfRenderTexture* renderTexture,const(sfRectangleShape)* object,const(sfRenderStates)* states);
	void sfRenderTexture_drawVertexArray(sfRenderTexture* renderTexture,const(sfVertexArray)* object,const(sfRenderStates)* states);
	void sfRenderTexture_drawPrimitives(sfRenderTexture* renderTexture,const(Vertex)* vertices,uint vertexCount, PrimitiveType type, const(sfRenderStates)* states);
	void sfRenderTexture_pushGLStates(sfRenderTexture* renderTexture);
	void sfRenderTexture_popGLStates(sfRenderTexture* renderTexture);
	void sfRenderTexture_resetGLStates(sfRenderTexture* renderTexture);
	const(sfTexture)* sfRenderTexture_getTexture(const(sfRenderTexture)* renderTexture);
	void sfRenderTexture_setSmooth(sfRenderTexture* renderTexture,sfBool smooth);
	sfBool sfRenderTexture_isSmooth(const(sfRenderTexture)* renderTexture);
	
	//Render Window
	sfRenderWindow* sfRenderWindow_create(sfVideoMode mode,const(char)* title,int style,const(ContextSettings)* settings);
	sfRenderWindow* sfRenderWindow_createUnicode(sfVideoMode mode, const(uint)* title, uint style, const(ContextSettings)* settings);
	sfRenderWindow* sfRenderWindow_createFromHandle(WindowHandle handle,const(ContextSettings)* settings);
	void sfRenderWindow_destroy(sfRenderWindow* renderWindow);
	void sfRenderWindow_close(sfRenderWindow* renderWindow);
	sfBool sfRenderWindow_isOpen(const(sfRenderWindow)* renderWindow);
	ContextSettings sfRenderWindow_getSettings(const(sfRenderWindow)* renderWindow);
	sfBool sfRenderWindow_pollEvent(sfRenderWindow* renderWindow,sfEvent* event);
	sfBool sfRenderWindow_waitEvent(sfRenderWindow* renderWindow,sfEvent* event);
	sfVector2i sfRenderWindow_getPosition(const(sfRenderWindow)* renderWindow);
	void sfRenderWindow_setPosition(sfRenderWindow* renderWindow,sfVector2i position);
	sfVector2u sfRenderWindow_getSize(const(sfRenderWindow)* renderWindow);
	void sfRenderWindow_setSize(sfRenderWindow* renderWindow,sfVector2u size);
	void sfRenderWindow_setTitle(sfRenderWindow* renderWindow,const(char)* title);
	void sfRenderWindow_setUnicodeTitle(sfRenderWindow* renderWindow, const(uint)* title);
	void sfRenderWindow_setIcon(sfRenderWindow* renderWindow,uint width, uint height,const(ubyte)* pixels);
	void sfRenderWindow_setVisible(sfRenderWindow* renderWindow,sfBool visible);
	void sfRenderWindow_setMouseCursorVisible(sfRenderWindow* renderWindow,sfBool show);
	void sfRenderWindow_setVerticalSyncEnabled(sfRenderWindow* renderWindow,sfBool enabled);
	void sfRenderWindow_setKeyRepeatEnabled(sfRenderWindow* renderWindow,sfBool enabled);
	sfBool sfRenderWindow_setActive(sfRenderWindow* renderWindow,sfBool active);
	void sfRenderWindow_display(sfRenderWindow* renderWindow);
	void sfRenderWindow_setFramerateLimit(sfRenderWindow* renderWindow,uint limit);
	void sfRenderWindow_setJoystickThreshold(sfRenderWindow* renderWindow,float threshold);
	WindowHandle sfRenderWindow_getSystemHandle(const(sfRenderWindow)* renderWindow);
	void sfRenderWindow_clear(sfRenderWindow* renderWindow,Color color);
	void sfRenderWindow_setView(sfRenderWindow* renderWindow,const(sfView)* view);
	const(sfView)* sfRenderWindow_getView(const(sfRenderWindow)* renderWindow);
	const(sfView)* sfRenderWindow_getDefaultView(const(sfRenderWindow)* renderWindow);
	sfIntRect sfRenderWindow_getViewport(const(sfRenderWindow)* renderWindow,const(sfView)* view);
	sfVector2f sfRenderWindow_mapPixelToCoords(const(sfRenderWindow)* renderWindow,sfVector2i point,const(sfView)* view);
	sfVector2i sfRenderWindow_mapCoordsToPixel(const(sfRenderWindow)* renderWindow,sfVector2f point,const(sfView)* view);
	void sfRenderWindow_drawSprite(sfRenderWindow* renderWindow,const(sfSprite)* object,const(sfRenderStates)* states);
	void sfRenderWindow_drawText(sfRenderWindow* renderWindow,const(sfText)* object,const(sfRenderStates)* states);
	//void sfRenderWindow_drawShape(sfRenderWindow* renderWindow,const(sfShape)* object,const(sfRenderStates)* states);
	//void sfRenderWindow_drawCircleShape(sfRenderWindow* renderWindow,const(sfCircleShape)* object,const(sfRenderStates)* states);
	//void sfRenderWindow_drawConvexShape(sfRenderWindow* renderWindow,const(sfConvexShape)* object,const(sfRenderStates)* states);
	//void sfRenderWindow_drawRectangleShape(sfRenderWindow* renderWindow,const(sfRectangleShape)* object,const(sfRenderStates)* states);
	void sfRenderWindow_drawVertexArray(sfRenderWindow* renderWindow,const(sfVertexArray)* object,const(sfRenderStates)* states);
	void sfRenderWindow_drawPrimitives(sfRenderWindow* renderWindow,const(Vertex)* vertices,uint vertexCount, PrimitiveType type,const(sfRenderStates)* states);
	void sfRenderWindow_pushGLStates(sfRenderWindow* renderWindow);
	void sfRenderWindow_popGLStates(sfRenderWindow* renderWindow);
	void sfRenderWindow_resetGLStates(sfRenderWindow* renderWindow);
	sfImage* sfRenderWindow_capture(const(sfRenderWindow)* renderWindow);
	sfVector2i sfMouse_getPositionRenderWindow(const(sfRenderWindow)* relativeTo);
	void sfMouse_setPositionRenderWindow(sfVector2i position, const(sfRenderWindow)* relativeTo);
	
	//Shader
	sfShader* sfShader_createFromFile(const(char)* vertexShaderFilename,const(char)* fragmentShaderFilename);
	sfShader* sfShader_createFromMemory(const(char)* vertexShader,const(char)* fragmentShader);
	sfShader* sfShader_createFromStream(sfInputStream* vertexShaderStream,sfInputStream* fragmentShaderStream);
	void sfShader_destroy(sfShader* shader);
	void sfShader_setFloatParameter(sfShader* shader,const(char)* name,float x);
	void sfShader_setFloat2Parameter(sfShader* shader,const(char)* name,float x,float y);
	void sfShader_setFloat3Parameter(sfShader* shader,const(char)* name,float x,float y,float z);
	void sfShader_setFloat4Parameter(sfShader* shader,const(char)* name,float x,float y,float z,float w);
	void sfShader_setVector2Parameter(sfShader* shader,const(char)* name,sfVector2f vector);
	void sfShader_setVector3Parameter(sfShader* shader,const(char)* name,sfVector3f vector);
	void sfShader_setColorParameter(sfShader* shader,const(char)* name,Color color);
	void sfShader_setTransformParameter(sfShader* shader,const(char)* name,sfTransform transform);
	void sfShader_setTextureParameter(sfShader* shader,const(char)* name,const(sfTexture)* texture);
	void sfShader_setCurrentTextureParameter(sfShader* shader,const(char)* name);
	void sfShader_bind(const(sfShader)* shader);
	sfBool sfShader_isAvailable();
	
	
	//Sprite
	sfSprite* sfSprite_create();
	sfSprite* sfSprite_copy(const(sfSprite)* sprite);
	void sfSprite_destroy(sfSprite* sprite);
	void sfSprite_setPosition(sfSprite* sprite,sfVector2f position);
	void sfSprite_setRotation(sfSprite* sprite,float angle);
	void sfSprite_setScale(sfSprite* sprite,sfVector2f scale);
	void sfSprite_setOrigin(sfSprite* sprite,sfVector2f origin);
	sfVector2f sfSprite_getPosition(const(sfSprite)* sprite);
	float sfSprite_getRotation(const(sfSprite)* sprite);
	sfVector2f sfSprite_getScale(const(sfSprite)* sprite);
	sfVector2f sfSprite_getOrigin(const(sfSprite)* sprite);
	//void sfSprite_move(sfSprite* sprite,sfVector2f offset);
	//void sfSprite_rotate(sfSprite* sprite,float angle);
	//void sfSprite_scale(sfSprite* sprite,sfVector2f factors);
	sfTransform sfSprite_getTransform(const(sfSprite)* sprite);
	sfTransform sfSprite_getInverseTransform(const(sfSprite)* sprite);
	void sfSprite_setTexture(sfSprite* sprite,const(sfTexture)* texture,sfBool resetRect);
	void sfSprite_setTextureRect(sfSprite* sprite,sfIntRect rectangle);
	void sfSprite_setColor(sfSprite* sprite,Color color);
	const(sfTexture)* sfSprite_getTexture(const(sfSprite)* sprite);
	sfIntRect sfSprite_getTextureRect(const(sfSprite)* sprite);
	Color sfSprite_getColor(const(sfSprite)* sprite);
	sfFloatRect sfSprite_getLocalBounds(const(sfSprite)* sprite);
	sfFloatRect sfSprite_getGlobalBounds(const(sfSprite)* sprite);
	
	//Text
	sfText* sfText_create();
	sfText* sfText_copy(const(sfText)* text);
	void sfText_destroy(sfText* text);
	void sfText_setPosition(sfText* text,sfVector2f position);
	void sfText_setRotation(sfText* text,float angle);
	void sfText_setScale(sfText* text,sfVector2f scale);
	void sfText_setOrigin(sfText* text,sfVector2f origin);
	sfVector2f sfText_getPosition(const(sfText)* text);
	float sfText_getRotation(const(sfText)* text);
	sfVector2f sfText_getScale(const(sfText)* text);
	sfVector2f sfText_getOrigin(const(sfText)* text);
	void sfText_move(sfText* text,sfVector2f offset);
	void sfText_rotate(sfText* text,float angle);
	void sfText_scale(sfText* text,sfVector2f factors);
	sfTransform sfText_getTransform(const(sfText)* text);
	sfTransform sfText_getInverseTransform(const(sfText)* text);
	void sfText_setString(sfText* text,const(char)* string);
	void sfText_setUnicodeString(sfText* text,const(uint)* string);
	void sfText_setFont(sfText* text,const(sfFont)* font);
	void sfText_setCharacterSize(sfText* text,uint size);
	void sfText_setStyle(sfText* text,Text.Style style);
	void sfText_setColor(sfText* text,Color color);
	const(char)* sfText_getString(const(sfText)* text);
	const(dchar)* sfText_getUnicodeString(const(sfText)* text);
	const(sfFont)* sfText_getFont(const(sfText)* text);
	uint sfText_getCharacterSize(const(sfText)* text);
	Text.Style sfText_getStyle(const(sfText)* text);
	Color sfText_getColor(const(sfText)* text);
	sfVector2f sfText_findCharacterPos(const(sfText)* text,size_t index);
	sfFloatRect sfText_getLocalBounds(const(sfText)* text);
	sfFloatRect sfText_getGlobalBounds(const(sfText)* text);
	
	//Texture
	sfTexture* sfTexture_create(uint width, uint height);
	sfTexture* sfTexture_createFromFile(const(char)* filename,const(sfIntRect)* area);
	sfTexture* sfTexture_createFromMemory(const(void)* data,size_t sizeInBytes,const(sfIntRect)* area);
	sfTexture* sfTexture_createFromStream(sfInputStream* stream,const(sfIntRect)* area);
	sfTexture* sfTexture_createFromImage(const(sfImage)* image,const(sfIntRect)* area);
	sfTexture* sfTexture_copy(const(sfTexture)* texture);
	void sfTexture_destroy(sfTexture* texture);
	sfVector2u sfTexture_getSize(const(sfTexture)* texture);
	sfImage* sfTexture_copyToImage(const(sfTexture)* texture);
	void sfTexture_updateFromPixels(sfTexture* texture,const(ubyte)* pixels,uint width,uint height,uint x,uint y);
	void sfTexture_updateFromImage(sfTexture* texture,const(sfImage)* image,uint x,uint y);
	void sfTexture_updateFromWindow(sfTexture* texture,const(sfWindow)* window,uint x,uint y);
	void sfTexture_updateFromRenderWindow(sfTexture* texture,const(sfRenderWindow)* renderWindow,uint x,uint y);
	void sfTexture_bind(const(sfTexture)* texture);
	void sfTexture_setSmooth(sfTexture* texture,sfBool smooth);
	sfBool sfTexture_isSmooth(const(sfTexture)* texture);
	void sfTexture_setRepeated(sfTexture* texture,sfBool repeated);
	sfBool sfTexture_isRepeated(const(sfTexture)* texture);
	uint sfTexture_getMaximumSize();
	
	//Transform
	sfTransform sfTransform_fromMatrix(float a00,float a01,float a02,float a10,float a11,float a12,float a20,float a21,float a22);
	void sfTransform_getMatrix(const(sfTransform)* transform, float* matrix);
	sfTransform sfTransform_getInverse(const(sfTransform)* transform);
	sfVector2f sfTransform_transformPoint(const(sfTransform)* transform,sfVector2f point);
	sfFloatRect sfTransform_transformRect(const(sfTransform)* transform,sfFloatRect rectangle);
	void sfTransform_combine(sfTransform* transform,const(sfTransform)* other);
	void sfTransform_translate(sfTransform* transform,float x,float y);
	void sfTransform_rotate(sfTransform* transform,float angle);
	void sfTransform_rotateWithCenter(sfTransform* transform,float angle,float centerX,float centerY);
	void sfTransform_scale(sfTransform* transform,float scaleX,float scaleY);
	void sfTransform_scaleWithCenter(sfTransform* transform,float scaleX,float scaleY,float centerX,float centerY);
	sfTransformable* sfTransformable_create();
	sfTransformable* sfTransformable_copy(const(sfTransformable)* transformable);
	void sfTransformable_destroy(sfTransformable* transformable);
	void sfTransformable_setPosition(sfTransformable* transformable,sfVector2f position);
	void sfTransformable_setRotation(sfTransformable* transformable,float angle);
	void sfTransformable_setScale(sfTransformable* transformable,sfVector2f scale);
	void sfTransformable_setOrigin(sfTransformable* transformable,sfVector2f origin);
	sfVector2f sfTransformable_getPosition(const(sfTransformable)* transformable);
	float sfTransformable_getRotation(const(sfTransformable)* transformable);
	sfVector2f sfTransformable_getScale(const(sfTransformable)* transformable);
	sfVector2f sfTransformable_getOrigin(const(sfTransformable)* transformable);
	void sfTransformable_move(sfTransformable* transformable,sfVector2f offset);
	void sfTransformable_rotate(sfTransformable* transformable,float angle);
	void sfTransformable_scale(sfTransformable* transformable,sfVector2f factors);
	sfTransform sfTransformable_getTransform(const(sfTransformable)* transformable);
	sfTransform sfTransformable_getInverseTransform(const(sfTransformable)* transformable);
	
	//View
	sfView* sfView_create();
	sfView* sfView_createFromRect(sfFloatRect rectangle);
	sfView* sfView_copy(const(sfView)* view);
	void sfView_destroy(sfView* view);
	void sfView_setCenter(sfView* view,sfVector2f center);
	void sfView_setSize(sfView* view,sfVector2f size);
	void sfView_setRotation(sfView* view,float angle);
	void sfView_setViewport(sfView* view,sfFloatRect viewport);
	void sfView_reset(sfView* view,sfFloatRect rectangle);
	sfVector2f sfView_getCenter(const(sfView)* view);
	sfVector2f sfView_getSize(const(sfView)* view);
	float sfView_getRotation(const(sfView)* view);
	sfFloatRect sfView_getViewport(const(sfView)* view);
	void sfView_move(sfView* view,sfVector2f offset);
	void sfView_rotate(sfView* view,float angle);
	void sfView_zoom(sfView* view,float factor);
	
}
