set(SRCROOT ${PROJECT_SOURCE_DIR}/Graphics)

# all source files
set(SRC
    ${SRCROOT}/Export.h
    ${SRCROOT}/CreateRenderStates.hpp
    ${SRCROOT}/Font.cpp
    ${SRCROOT}/FontStruct.h
    ${SRCROOT}/Font.h
    ${SRCROOT}/Image.cpp
    ${SRCROOT}/ImageStruct.h
    ${SRCROOT}/Image.h
    ${SRCROOT}/RenderTexture.cpp
    ${SRCROOT}/RenderTextureStruct.h
    ${SRCROOT}/RenderTexture.h
    ${SRCROOT}/RenderWindow.cpp
    ${SRCROOT}/RenderWindowStruct.h
    ${SRCROOT}/RenderWindow.h
    ${SRCROOT}/Shader.cpp
    ${SRCROOT}/ShaderStruct.h
    ${SRCROOT}/Shader.h
    ${SRCROOT}/Texture.cpp
    ${SRCROOT}/TextureStruct.h
    ${SRCROOT}/Texture.h
    ${SRCROOT}/DText.cpp
    ${SRCROOT}/DText.hpp
    ${SRCROOT}/Text.cpp
    ${SRCROOT}/TextStruct.h
    ${SRCROOT}/Text.h
    ${SRCROOT}/Transform.cpp
    ${SRCROOT}/Transform.h
    ${SRCROOT}/Types.h
)

source_group("" FILES ${SRC})


#build only object files that can be linked into a d static library
add_library(dsfmlc-graphics OBJECT ${SRC})

#if(MSVC)
    #target_link_libraries(dsfmlc-graphics STATIC opengl32.lib)
#endif(MSVC)
