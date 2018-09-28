
set(INCROOT ${PROJECT_SOURCE_DIR}/include/DSFMLC/System)
set(SRCROOT ${PROJECT_SOURCE_DIR}/src/DSFMLC/System)

set(SRC
    ${INCROOT}/DStream.hpp
    ${SRCROOT}/Err.cpp
    ${INCROOT}/Err.h
    ${SRCROOT}/String.cpp
    ${INCROOT}/String.h
    ${INCROOT}/Export.h
)

#build only object files that can be linked into a d static library
add_library(dsfmlc-system OBJECT ${SRC})
