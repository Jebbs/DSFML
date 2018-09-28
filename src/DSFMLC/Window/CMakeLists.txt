set(INCROOT ${PROJECT_SOURCE_DIR}/include/DSFMLC/Window)
set(SRCROOT ${PROJECT_SOURCE_DIR}/src/DSFMLC/Window)


# all source files
set(SRC
    ${INCROOT}/Export.h
    ${SRCROOT}/Context.cpp
    ${SRCROOT}/ContextStruct.h
    ${INCROOT}/Context.h
    ${INCROOT}/Event.h
    ${INCROOT}/Err.h
    ${SRCROOT}/Err.cpp
    ${SRCROOT}/Joystick.cpp
    ${INCROOT}/Joystick.h
    ${SRCROOT}/Keyboard.cpp
    ${INCROOT}/Keyboard.h
    ${SRCROOT}/Mouse.cpp
    ${INCROOT}/Mouse.h
    ${SRCROOT}/Sensor.cpp
    ${INCROOT}/Sensor.h
    ${SRCROOT}/Touch.cpp
    ${INCROOT}/Touch.h
    ${INCROOT}/Types.h
    ${SRCROOT}/VideoMode.cpp
    ${INCROOT}/VideoMode.h
    ${SRCROOT}/Window.cpp
    ${SRCROOT}/WindowStruct.h
    ${INCROOT}/Window.h
    ${INCROOT}/WindowHandle.h
)

source_group("" FILES ${SRC})

#build only object files that can be linked into a d static library
add_library(dsfmlc-window OBJECT ${SRC})
