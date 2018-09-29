set(SRCROOT ${PROJECT_SOURCE_DIR}/Audio)

# all source files
set(SRC
     ${SRCROOT}/Err.cpp
     ${SRCROOT}/Err.h
     ${SRCROOT}/Export.h
     ${SRCROOT}/Listener.cpp
     ${SRCROOT}/Listener.h
     ${SRCROOT}/Sound.cpp
     ${SRCROOT}/Sound.h
     ${SRCROOT}/SoundBuffer.cpp
     ${SRCROOT}/SoundBuffer.h
     ${SRCROOT}/InputSoundFile.cpp
     ${SRCROOT}/InputSoundFile.h
     ${SRCROOT}/InputSoundFileStruct.h
     ${SRCROOT}/OutputSoundFile.cpp
     ${SRCROOT}/OutputSoundFile.h
     ${SRCROOT}/OutputSoundFileStruct.h
     ${SRCROOT}/SoundRecorder.cpp
     ${SRCROOT}/SoundRecorder.h
     ${SRCROOT}/SoundRecorderStruct.h
     ${SRCROOT}/SoundStreamStruct.h
     ${SRCROOT}/SoundStream.cpp
     ${SRCROOT}/SoundStream.h
)
source_group("" FILES ${SRC})

#build only object files that can be linked into a d static library
add_library(dsfmlc-audio OBJECT ${SRC})
