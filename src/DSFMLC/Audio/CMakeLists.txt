set(INCROOT ${PROJECT_SOURCE_DIR}/include/DSFMLC/Audio)
set(SRCROOT ${PROJECT_SOURCE_DIR}/src/DSFMLC/Audio)

# all source files
set(SRC
     ${SRCROOT}/Err.cpp
     ${INCROOT}/Err.h
     ${INCROOT}/Export.h
     ${SRCROOT}/Listener.cpp
     ${INCROOT}/Listener.h
     ${SRCROOT}/Sound.cpp
     ${INCROOT}/Sound.h
     ${SRCROOT}/SoundBuffer.cpp
     ${INCROOT}/SoundBuffer.h
     ${SRCROOT}/InputSoundFile.cpp
     ${INCROOT}/InputSoundFile.h
     ${SRCROOT}/InputSoundFileStruct.h
     ${SRCROOT}/OutputSoundFile.cpp
     ${INCROOT}/OutputSoundFile.h
     ${SRCROOT}/OutputSoundFileStruct.h
     ${SRCROOT}/SoundRecorder.cpp
     ${INCROOT}/SoundRecorder.h
     ${SRCROOT}/SoundRecorderStruct.h
     ${SRCROOT}/SoundStreamStruct.h
     ${SRCROOT}/SoundStream.cpp
     ${INCROOT}/SoundStream.h
)
source_group("" FILES ${SRC})

#build only object files that can be linked into a d static library
add_library(dsfmlc-audio OBJECT ${SRC})
