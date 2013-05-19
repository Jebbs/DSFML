#DSFML System Cmake
set(INCROOT ${CMAKE_SOURCE_DIR}/include/SFML/System)
set(SRCROOT ${CMAKE_SOURCE_DIR}/src/SFML/System)

# all source files
set(SRC
    ${INCROOT}/Export.h
    ${SRCROOT}/Clock.cpp
    ${SRCROOT}/ClockStruct.h
    ${INCROOT}/Clock.h
    ${INCROOT}/Types.h
    ${SRCROOT}/Err.cpp
    ${INCROOT}/Err.h
    
    
)

# define the csfml-system target
csfml_add_library(dsfml-system
                  SOURCES ${SRC}
                  DEPENDS ${SFML_SYSTEM_LIBRARY})

