
set(INCROOT ${PROJECT_SOURCE_DIR}/include/DSFMLC/System)
set(SRCROOT ${PROJECT_SOURCE_DIR}/src/DSFMLC/System)

# all source files
set(SRC
    ${INCROOT}/DStream.hpp
    ${SRCROOT}/Err.cpp
    ${INCROOT}/Err.h
    ${SRCROOT}/String.cpp
    ${INCROOT}/String.h
    ${INCROOT}/Export.h
)
#source_group("" FILES ${SRC})

#fix
#if(SFML_OS_LINUX)
#    set(SRC
#        ${SRC}
#        ${DSRCROOT}/Threads.cpp
#        ${DINCROOT}/Threads.h
#    )
#endif()

#build only object files that can be linked into a d static library
add_library(dsfmlc-system STATIC ${SRC})
