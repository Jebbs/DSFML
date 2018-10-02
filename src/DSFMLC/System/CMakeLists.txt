set(SRCROOT ${PROJECT_SOURCE_DIR}/System)

set(SRC
    ${SRCROOT}/DStream.hpp
    ${SRCROOT}/Err.cpp
    ${SRCROOT}/Err.h
    ${SRCROOT}/ErrStream.cpp
    ${SRCROOT}/ErrStream.hpp
    ${SRCROOT}/String.cpp
    ${SRCROOT}/String.h
    ${SRCROOT}/Export.h
)

#build only object files that can be linked into a d static library
add_library(dsfmlc-system OBJECT ${SRC})
