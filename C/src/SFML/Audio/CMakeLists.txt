#DSFML Audio Cmake

set(INCROOT ${CMAKE_SOURCE_DIR}/include/SFML/Audio)
set(SRCROOT ${CMAKE_SOURCE_DIR}/src/SFML/Audio)

# all source files
set(SRC
 ${SRCROOT}/ALCheck.cpp
 ${SRCROOT}/ALCheck.hpp
 ${SRCROOT}/AudioDevice.cpp
 ${SRCROOT}/AudioDevice.hpp
 ${INCROOT}/Export.h
 ${SRCROOT}/Listener.cpp
 ${INCROOT}/Listener.h
 ${SRCROOT}/Sound.cpp
 ${INCROOT}/Sound.h
 ${SRCROOT}/SoundBuffer.cpp
 ${INCROOT}/SoundBuffer.h
 ${SRCROOT}/sfSoundFile.cpp
 ${INCROOT}/sfSoundFile.h
 ${SRCROOT}/sfSoundFile.cpp
 ${SRCROOT}/SoundFile.cpp
 ${SRCROOT}/SoundFile.hpp
 ${SRCROOT}/InternalSoundRecorder.cpp
 ${INCROOT}/InternalSoundRecorder.hpp
 ${SRCROOT}/SoundFileStruct.h
 ${SRCROOT}/SoundRecorder.cpp
 ${INCROOT}/SoundRecorder.h
 ${SRCROOT}/SoundSource.cpp
 ${INCROOT}/SoundSource.h
 ${SRCROOT}/SoundStream.cpp
 ${INCROOT}/SoundStream.h
 
)

source_group("" FILES ${SRC})


# let CMake know about our additional audio libraries paths (on Windows and OSX)
if(WINDOWS)
    set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "${PROJECT_SOURCE_DIR}/extlibs/headers/AL")
    set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "${PROJECT_SOURCE_DIR}/extlibs/headers/libsndfile/windows")
elseif (MACOSX)
    set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "${PROJECT_SOURCE_DIR}/extlibs/headers/libsndfile/osx")
    set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "${PROJECT_SOURCE_DIR}/extlibs/libs-osx/Frameworks")
endif()


# find external libraries
find_package(OpenAL REQUIRED)
find_package(Sndfile REQUIRED)

# add include paths of external libraries
include_directories(${OPENAL_INCLUDE_DIR} ${SNDFILE_INCLUDE_DIR})

# define the csfml-audio target
csfml_add_library(dsfml-audio
                  SOURCES ${SRC}
                  DEPENDS ${SFML_AUDIO_LIBRARY} ${SFML_SYSTEM_LIBRARY})

