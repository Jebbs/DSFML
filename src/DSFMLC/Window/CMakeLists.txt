set(SRCROOT ${PROJECT_SOURCE_DIR}/Window)

# all source files
set(SRC
    ${SRCROOT}/Export.h
    ${SRCROOT}/Context.cpp
    ${SRCROOT}/ContextStruct.h
    ${SRCROOT}/Context.h
    ${SRCROOT}/Event.h
    ${SRCROOT}/Err.h
    ${SRCROOT}/Err.cpp
    ${SRCROOT}/Joystick.cpp
    ${SRCROOT}/Joystick.h
    ${SRCROOT}/Keyboard.cpp
    ${SRCROOT}/Keyboard.h
    ${SRCROOT}/Mouse.cpp
    ${SRCROOT}/Mouse.h
    ${SRCROOT}/Sensor.cpp
    ${SRCROOT}/Sensor.h
    ${SRCROOT}/Touch.cpp
    ${SRCROOT}/Touch.h
    ${SRCROOT}/Types.h
    ${SRCROOT}/VideoMode.cpp
    ${SRCROOT}/VideoMode.h
    ${SRCROOT}/Window.cpp
    ${SRCROOT}/WindowStruct.h
    ${SRCROOT}/Window.h
    ${SRCROOT}/WindowHandle.h
)

source_group("" FILES ${SRC})

#build only object files that can be linked into a d static library
add_library(dsfmlc-window OBJECT ${SRC})
