set(INCROOT ${PROJECT_SOURCE_DIR}/include/DSFMLC/Graphics)
set(SRCROOT ${PROJECT_SOURCE_DIR}/src/DSFMLC/Graphics)


# all source files
set(SRC
    ${INCROOT}/Export.h
    ${SRCROOT}/CreateRenderStates.hpp
    ${SRCROOT}/Font.cpp
    ${SRCROOT}/FontStruct.h
    ${INCROOT}/Font.h
    ${SRCROOT}/Image.cpp
    ${SRCROOT}/ImageStruct.h
    ${INCROOT}/Image.h
    ${SRCROOT}/RenderTexture.cpp
    ${SRCROOT}/RenderTextureStruct.h
    ${INCROOT}/RenderTexture.h
    ${SRCROOT}/RenderWindow.cpp
    ${SRCROOT}/RenderWindowStruct.h
    ${INCROOT}/RenderWindow.h
    ${SRCROOT}/Shader.cpp
    ${SRCROOT}/ShaderStruct.h
    ${INCROOT}/Shader.h
    ${SRCROOT}/Texture.cpp
    ${SRCROOT}/TextureStruct.h
    ${INCROOT}/Texture.h
    ${SRCROOT}/DText.cpp
    ${SRCROOT}/DText.hpp
    ${SRCROOT}/Text.cpp
    ${SRCROOT}/TextStruct.h
    ${INCROOT}/Text.h
    ${SRCROOT}/Transform.cpp
    ${INCROOT}/Transform.h
    ${INCROOT}/Types.h
)

source_group("" FILES ${SRC})

#set(CMAKE_CXX_FLAGS "/P")

#build only object files that can be linked into a d static library
add_library(dsfmlc-graphics STATIC ${SRC})

if(MSVC)
    target_link_libraries(dsfmlc-graphics STATIC opengl32.lib)
endif(MSVC)
